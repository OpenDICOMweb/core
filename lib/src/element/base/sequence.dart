//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/logger.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values/uid.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

bool _inRange(int v, int min, int max) => v >= min && v <= max;

int level = 0;

abstract class SQ extends Element<Item> {
  /// The [tag] corresponding to _this_.
  @override
  Tag get tag;
  // **** End of Interface

  /// The DICOM name for Sequence values, which are Items.
  List<Item> get items => (values is List) ? values : values.toList();

  @override
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;

  int get sizeInBytes => kSizeInBytes;
  @override
  int get vlfSize => 4;
  @override
  int get maxVFLength => kMaxVFLength;
  Dataset get parent;
  @override
  int get maxLength => kMaxLength;
  // TODO: what is right value, maybe this should be in the interface.
  @override
  int get vfLength => -1;
  // TODO: what is right value
  @override
  int get lengthInBytes => -1;
//  @override
//  int get vfLengthField;
  @override
  bool get isLengthAlwaysValid => true;
  @override
  bool get isUndefinedLengthAllowed => true;
//  @override
//  bool get hadULength => vfLengthField == kUndefinedLength;

  @override
  TypedData get typedData =>
      throw UnsupportedError('Sequence VR does not support this Getter.');

  @override
  Uint8List get bulkdata => typedData;

  /// Returns the total number of Elements in _this_.
  @override
  int get total => counter((e) => true);

  List sqMap(Object f(Element e)) {
    final iList = List<Object>(items.length);
    for (var item in items) {
      final eList = List<Object>(item.length);
      iList.add(eList);
      for (var e in item)
        if (e is SQ) {
          eList.add(sqMap(f));
        } else {
          eList.add(f(e));
        }
    }
    return iList;
  }

  /// Returns a [String] containing a summary of the sequence.
  String get summary => '''
Summary $tag
  Parent: $parent
  Item count: ${values.length} 
''';

  @override
  bool checkValue(Item v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  @override
  bool checkValues(Iterable<Item> vList, [Issues issues]) =>
      isValidValues(vList, issues);

  /// Walk the [Dataset] recursively and return the count of [Element]s
  /// for which [test] is true.
  /// Note: It ignores duplicates.
  @override
  int counter(ElementTest test) {
    var count = 1;
    for (var item in items) {
      for (var e in item) {
        count += (e is SQ) ? e.counter(test) : 1;
      }
    }
    return count;
  }

  @override
  void forEach(void action(Item element)) => items.forEach(action);

  @override
  T fold<T>(T initialValue, T combine(T previous, Item item)) =>
      items.fold(initialValue, combine);

  Element lookup(int index, {bool required = false}) {
    for (var item in items) {
      final e = item.lookup(index, required: required);
      if (e != null) return e;
    }
    return null;
  }

  Iterable<Element> lookupAll(int index, {bool required = false}) {
    final result = <Element>[];
    for (var item in items) {
      final e = item.lookup(index, required: required);
      if (e != null) result.add(e);
    }
    return result;
  }

  /// Returns the [Element] with [tagIndex] in the [itemIndex]th Item.
  Element getElement(int tagIndex, [int itemIndex = 0]) {
    if (itemIndex < 0 || itemIndex >= items.length) return null;
    final item = values[itemIndex];
    return item[tagIndex];
  }

  /// Returns a [Iterable<Element>] containing the [Element] corresponding
  /// to the [index] in each Item of [items].  If the Item does not
  /// contain the [index], _null_ is inserted in the returned
  /// [Iterable<Element].
  Iterable<Element> getAll(int index) {
    final eList = <Element>[];
    for (var item in items) eList.addAll(item.map<Element>((e) => e));
    return eList;
  }

  void addElementAt(int itemIndex, Element e) {
    RangeError.checkValueInInterval(itemIndex, 0, items.length);
    items[itemIndex].add(e);
  }

  @override
  List<Item> get emptyList => kEmptyList;
  static const Iterable<Item> kEmptyList = <Item>[];

  @override
  SQ get noValues => update(kEmptyList);

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
  SQ update([Iterable<Item> vList = kEmptyList]) => unsupportedError();

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

  Iterable<Element> updateAllF<V>(int index, Iterable<V> f(List<V> vList),
      {bool required = false}) {
    final eList = <Element>[];
    for (var item in items) {
      final e = item[index];
      if (e == null) continue;
      eList.add(e.update(f(e.values) ?? const <Object>[]));
    }
    return eList;
  }

  Iterable<Element> updateAllUids(int index, Iterable<Uid> uids,
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

  @override
  List<Item> replace([Iterable<Item> vList = kEmptyList]) => unsupportedError();

  @override
  List<Item> replaceF(List<Item> f(List<Item> vList)) => unsupportedError();

  Iterable<V> _replaceF<V>(Iterable<V> vList) => vList;

  Iterable<Iterable<V>> replaceAll<V>(int index, Iterable<V> vList) =>
      replaceAllF(index, _replaceF);

  Iterable<Iterable<V>> replaceAllF<V>(
      int index, Iterable<V> f(List<V> vList)) {
    final result = <Iterable<V>>[];
    for (var item in items) {
      final e = item.lookup(index);
      final old = item.replace<V>(index, f(e.values));
      result.add(old);
    }
    return result;
  }

  // TODO Jim: merge with removeRecursive
  Iterable<Element> removeAll(int index,
      {bool recursive = true, bool required = false}) {
    final result = <Element>[];
    forEach((item) => result.add(item.delete(index)));
    return result;
  }

  /// Returns a formatted [String]. See [Formatter].
  String format(Formatter z) => z.fmt(this, items);

  static const int kVRIndex = kSQIndex;
  static const int kVRCode = kSQCode;
  static const String kVRKeyword = 'SQ';
  static const String kVRName = 'Sequence of Items';
  static const int kSizeInBytes = 1;
  static const int kMinItemLength = 8;
  static const int kMaxVFLength = kMaxLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kMinItemLength;

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    VR.badIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    return VR.invalidCode(vrCode, issues, kVRIndex);
  }

  static int checkVRIndex(int index, [Issues issues]) =>
      (index == kVRIndex) ? index : VR.badIndex(index, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : VR.badCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidLength(int vfl) => true;

  static bool isValidValue(Item item,
          {Issues issues, bool allowInvalid = false}) =>
      true;

  static bool isValidValues(Iterable<Item> vList, Issues issues) => true;
}
