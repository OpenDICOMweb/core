// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dicom.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/mixin/undefined_length_mixin.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/logger/formatter.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/uid/uid.dart';
import 'package:core/src/vr/vr.dart';

bool _inRange(int v, int min, int max) => v >= min && v <= max;

/* Flush at V0.9.0
bool _isValidVFLength(int vfl, int minBytes, int maxBytes, int sizeInBytes) =>
    _inRange(vfl, minBytes, maxBytes) && (vfl % sizeInBytes == 0);
*/

const Iterable<Item> emptyItemList = const <Item>[];

abstract class SQ<K> extends Element<Item> with UndefinedLengthMixin {
  // **** Interface

  @override
  Iterable<Item> get emptyList => emptyItemList;

  /// The [tag] corresponding to _this_.
  @override
  Tag get tag;
  @override
  Iterable<Item> get values;
  @override
  set values(Iterable<Item> vList) => unsupportedError('StringBase.values');

  /// The DICOM name for Sequence values, which are Items.
  Iterable<Item> get items => values;

  //**** End of Interface
  @override
//  VR get vr => kVR;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get sizeInBytes => kSizeInBytes;
  @override
  int get vflSize => 4;
  @override
  int get padChar => unsupportedError('Float does not have a padChar');
  @override
  int get maxVFLength => kMaxVFLength;
  Dataset get parent;
  @override
  int get maxLength => kMaxLength;
  @override
  int get vfLength => unimplementedError();

  @override
  bool get hadULength => vfLengthField == kUndefinedLength;

  @override
  SQ get noValues => update(emptyItemList);

  @override
  TypedData get typedData =>
      throw new UnsupportedError('Sequence VR does not support this Getter.');

  /// Returns the total number of Elements in _this_.
  @override
  int get total => counter((e) => true);

  /// Returns a [String] containing a summary of the sequence.
  String get summary => '''
Summary $tag
  Parent: $parent
  Item count: ${values.length} 
''';

  @override
  bool checkValue(Item v, [Issues issues]) => isValidValue(v);
  @override
  bool checkValues(Iterable<Item> vList, [Issues issues]) =>
      isValidValues(vList, issues);

  //Fix: make conform to Fold interface
  /// Walk the [Dataset] recursively and return the count of [Element]s
  /// for which [test] is true.
  /// Note: It ignores duplicates.
  @override
  int counter(ElementTest test) {
    // Starts at 1 in order to include the SQ itself.
    var count = 1;
    for (var item in items)
      for (var e in item.elements) {
        if (e is SQ) {
          count += e.counter(test);
        } else {
          if (test(e)) count++;
        }
      }
    //    log.debug1('sqCounter: $count');
    return count;
  }

  @override
  void forEach(void f(Item item)) => items.forEach(f);

  @override
  T fold<T>(T initialValue, T combine(T v, Item item)) {
    var v = initialValue;
    for (var item in items) v = combine(v, item);
    return v;
  }

  Element lookup(int index, {bool required = false}) {
    for (var item in items) {
      final e = item.lookup(index);
      if (e != null) return e;
    }
    return null;
  }

  Iterable<Element> lookupAll(int index, {bool required = false}) {
    final result = <Element>[];
    for (var item in items) {
      final e = item.lookup(index);
      if (e != null) result.add(e);
    }
    return result;
  }

  /// Returns the [Element] with [tagIndex] in the [itemIndex]th Item.
  Element getElement(int tagIndex, [int itemIndex = 0]) {
    if (itemIndex < 0 || itemIndex >= items.length) return null;
    final item = values.elementAt(itemIndex);
    return item[tagIndex];
  }

  /// Returns a [Iterable<Element>] containing the [Element] corresponding
  /// to the [index] in each Item of [items].  If the Item does not
  /// contain the [index], _null_ is inserted in the returned [Iterable<Element].
  Iterable<Element> getAll(int index) {
    final eList = <Element>[];
    for (var item in items) eList.addAll(item.map<Element>((e) => e));
    return eList;
  }

  void addElementAt(int itemIndex, Element e) {
    RangeError.checkValueInInterval(itemIndex, 0, items.length);
    items.elementAt(itemIndex)..add(e);
  }

  @override
  SQ update([Iterable<Item> vList = emptyItemList]);

  @override
  SQ updateF(Iterable<Item> f(Iterable<Item> vList));

/*
  Element updateElementAt<V>(int itemIndex, int eIndex, Iterable<V> vList) {
    RangeError.checkValueInInterval(itemIndex, 0, items.length);
    final item = items[itemIndex];
    final e = item.lookup(eIndex);
    return e.update(vList);
  }
*/

  Iterable<Element> updateAll<V>(int index, Iterable<V> vList,
      {bool required = false}) {
    final eList = <Element>[];
    for (var item in items) {
      final e = item[index];
      if (e == null) continue;
      eList.add(e.update(vList));
    }
    return eList;
  }

  Iterable<Element> updateAllF<V>(int index, Iterable<V> f(Iterable<V> vList),
      {bool required = false}) {
    final eList = <Element>[];
    for (var item in items) {
      final e = item[index];
      if (e == null) continue;
      eList.add(e.update(f(e.values) ?? const <V>[]));
    }
    return eList;
  }

  Iterable<Element> updateAllUids<V>(int index, Iterable<Uid> uids,
      {bool required = false}) {
    final eList = <Element>[];
    final vList = uids.map((v) => asString).toList(growable: false);
    for (var item in items) {
      final e = item[index];
      if (e == null) continue;
      eList.add(e.update(vList));
    }
    return eList;
  }

  Iterable<Element> noValuesAll(int index) {
    final result = <Element>[];
    for (var item in items) {
      final e = item.lookup(index);
      item[index] = e.noValues;
      result.add(e);
    }
    return result;
  }

  @override
  Iterable<Item> replace([Iterable<Item> vList = emptyItemList]) => unsupportedError();

  @override
  Iterable<Item> replaceF(Iterable<Item> f(Iterable<Item> vList)) => unsupportedError();

  Iterable<Iterable<V>> replaceAll<V>(int index, Iterable<V> vList) {
    final result = <Iterable<V>>[];
    for (var item in items) {
      final old = item.replace<V>(index, vList);
      result.add(old);
    }
    return result;
  }

  Iterable<Iterable<V>> replaceAllF<V>(int index, Iterable<V> f(Iterable<V> vList)) {
    final result = <Iterable<V>>[];
    for (var item in items) {
      final e = item.lookup(index);
      final old = item.replace<V>(index, f(e.values));
      result.add(old);
    }
    return result;
  }

  //Urgent Jim: merge with removeRecursive
  Iterable<Element> removeAll(int index,
      {bool recursive = true, bool required = false}) {
    final result = <Element>[];
    forEach((item) => result.add(item.delete(index)));
    return result;
  }

/*
  /// Returns a formatted [String]. See [Formatter].
  String format(Formatter z) =>
		  '${z(this)} ${z.fmt("$runtimeType(${items.length})", items)}';
*/

  /// Returns a formatted [String]. See [Formatter].
  @override
  String format(Formatter z) => z.fmt(this, items);

//  static const VR kVR = VR.kSQ;
  static const int kVRIndex = kSQIndex;
  static const int kVRCode = kSQCode;
  static const String kVRKeyword = 'SQ';
  static const String kVRName = 'Sequence of Items';
  static const int kSizeInBytes = 1;
  static const int kMinItemLength = 8;
  static const int kMaxVFLength = kMaxLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kMinItemLength;

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

/*
  static bool isValidVR(VR vr, [Issues issues]) {
    if (vr == kVR) return true;
    invalidVR(vr.index, issues, kVRIndex);
    return false;
  }
*/

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int index, [Issues issues]) =>
      (index == kVRIndex) ? index : invalidVRIndex(index, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
    (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  //TODO: make sure this is good enough
  static bool isValidValue(Item item, [Issues issues]) => true;

  static bool isValidValues(Iterable<Item> vList, Issues issues) => true;
}
