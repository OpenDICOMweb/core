// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:collection';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/element_list/element_list.dart';
import 'package:core/src/dataset/errors.dart';
import 'package:core/src/dataset/private_group.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/pixel_data.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/tag/tag_lib.dart';
import 'package:core/src/uid/uid.dart';

// ignore_for_file: unnecessary_getters_setters

// Design Note:
//   Only [keyToTag] and [keys] use the Type variable <K>. All other
//   Getters and Methods are defined in terms of [Element] [index].
//   [Element.index] is currently [Element.code], but that is likely
//   to change in the future.

/// A DICOM Dataset. The [Type] [<K>] is the Type of 'key'
/// used to lookup [Element]s in the [Dataset]].
abstract class Dataset<K> extends ListBase<Element> {
  // **** Start of Interface ****
  DSBytes get dsBytes;

  /// Returns the [Tag.index] for the corresponding [key].
  int keyToIndex(K key);

  Tag getTag(int index);

  /// The parent of _this_. If [parent] == _null_, then this is a Root Dataset
  /// (see RootDatasetMixin); otherwise, it is an [Item].
  Dataset<K> get parent;

  /// An [ElementList] of the [Element]s in _this_.
  ///
  // Design Note: It is expected that [ElementList] will have
  // it's own specialized implementation for correctness and efficiency.
  ElementList get elements;

  /// _true_ if _this_ is immutable.
  bool get isImmutable;


  /// Returns a Sequence([SQ]) containing any [Element]s that were
  /// modified or removed.
  //TODO: complete and test
  //SQ get originalAttributesSequence;

  // **** End of Interface ****

  // **** Section Start: ListBase implementation
  // **** These may be overridden in subclasses.

  /// Returns the [Element] with the [index].
  @override
  Element operator [](int index) => elements[index];

  /// [add]s [Element] to this [Dataset].
  @override
  void operator []=(int index, Element e) {
    if (index != e.index) return invalidElementIndex(index, element: e);
    return elements.add(e);
  }

  // TODO: when are 2 Datasets equal
  // TODO: should this be checking that parents are equal? It doesn't
  @override
  bool operator ==(Object other) =>
      other is Dataset &&
      elements.length == other.elements.length &&
      elements == other.elements;

  //Issue: is this good enough?
  @override
  int get hashCode => elements.hashCode;

  /// An [Iterable] of the [Element] [keys] in _this_.
  Iterable<int> get keys => elements.keys;

  /// The number of [elements] (and [keys]) in _this_.
  /// _Note_: Does not include duplicate elements.
  @override
  int get length => elements.length;
  @override
  set length(int length) {}

  int get eLength => (dsBytes == null) ? -1 : dsBytes.eLength;

  /// The actual length of the Value Field for _this_
  int get vfLength => (dsBytes != null) ? dsBytes.eLength : null;

  bool get hasULength => dsBytes.hasULength;

  /// The value of the Value Field Length field for _this_.
  int get vfLengthField => (dsBytes != null) ? dsBytes.eLength : null;

  int get total => elements.total;
  int get dupTotal => elements.dupTotal;

  // **** Section Start: Default Operator and Getters
  // **** These may be overridden in subclasses.

  /// The length in bytes of [dsBytes]. If [dsBytes] is _null_ returns -1.
  int get lengthInBytes => (dsBytes == null) ? -1 : dsBytes.eLength;
  bool get hasDuplicates => elements.history.duplicates.isNotEmpty;

  //Urgent: implement private groups and Private elements
  String get info => '''
$runtimeType(#$hashCode):
            Total: ${elements.total}
        Top Level: $length
       Duplicates: ${elements.history.duplicates.length}
  PrivateElements: $nPrivateElements
    PrivateGroups: $nPrivateGroups
    ''';

  @override
  void forEach(void f(Element e)) => elements.forEach(f);

  @override
  T fold<T>(T initialValue, T combine(T v, Element e)) =>
      elements.fold(initialValue, combine);

  // **** Section Start: Element related Getters and Methods

  // Dataset<K> copy([Dataset<K> parent]);

  /// Returns the Element with [index], if present; otherwise, returns _null_.
  ///
  /// _Note_: All lookups should be done using this method.
  ///
  // Design Note: This method should record the index of any Elements
  // not found if [recordNotFound] is _true_.
  Element lookup(int index, {bool required = false}) {
    final e = elements[index];
    if (e == null && required == true) return elementNotPresentError(index);
    return e;
  }

  /// All lookups should be done using this method.
  List<Element> lookupAll(int index) {
    final results = <Element>[];
    final e = elements[index];
    e ?? results.add(e);
    for (var sq in elements.sequences)
      for (var item in sq.items) {
        final e = item[index];
        e ?? results.add(e);
      }
    return results;
  }

  bool hasElementsInRange(int min, int max) => elements.hasElementsInRange(min, max);

  List<Element> getElementsInRange(int min, int max) =>
      elements.getElementsInRange(min, max);

  @override
  void add(Element e, [Issues issues]) => elements.add(e);

  bool tryAdd(Element e, [Issues issues]) => elements.tryAdd(e);

  void addList(List<Element> eList) => elements.addAll(eList);

  /// Replaces the element with [index] with a new element with the same [Tag],
  /// but with [vList] as its _values_. Returns the original element.
  Element update<V>(int index, Iterable<V> vList, {bool required = false}) {
    final old = elements.lookup(index, required: required);
    if (old != null) elements[index] = old.update(vList);
    return old;
  }

  /// Replaces the element with [index] with a new element with the same [Tag],
  /// but with _values_ of [f(e.values)]. Returns the original element.
  Element updateF<V>(int index, Iterable f(Iterable<V> vList), {bool required = false}) {
    final old = elements.lookup(index, required: required);
    if (old != null) elements[index] = old.updateF(f);
    return old;
  }

  /// Updates all elements with [index] in _this_, or any Sequence ([SQ])
  /// Items contained in it, with a new element whose values are [f(this.values)].
  /// Returns a list containing all [Element]s that were replaced.
  List<List> updateAll<V>(int index, Iterable<V> vList) =>
      elements.updateAll(index, vList: vList);


  /// Updates all elements with [index] in _this_, or any Sequence ([SQ])
  /// Items contained in it, with a new element whose values are [f(this.values)].
  /// Returns a list containing all [Element]s that were replaced.
  List<List> updateAllF<V>(int index, Iterable f(Iterable<V> vList)) =>
      elements.updateAllF(index, f);

  Element updateUid(int index, Iterable<Uid> uids, {bool required = false}) =>
      elements.updateUid(index, uids);

  Element updateUidString(int index, Iterable<String> uids, {bool required = false}) =>
      elements.updateUidStrings(index, uids);

  List<Element> updateAllUids(int index, Iterable<Uid> uids) =>
      elements.updateAllUids(index, uids);

  /// Replaces the _values_ of the [Element] with [index] with [vList].
  /// Returns the original _values_.
  Iterable<V> replace<V>(int index, Iterable<V> vList, {bool required = false}) {
    final e = elements.lookup(index, required: required);
    if (e == null) return const <V>[];
    final old = e.values;
    e.values = vList;
    return old;
  }

  /// Replaces all elements with [index] in _this_ and any [Item]s
  /// descended from it, with a new element that has [vList<V>] as its
  /// values. Returns a list containing all [Element]s that were replaced.
  List<Element> replaceAll(int index, Iterable vList) =>
      elements.replaceAll(index, vList);

  List<Element> replaceAllF(int index, List f(Iterable vList)) =>
      elements.replaceAllF(index, f);

  Element replaceUid(int index, Iterable<Uid> uids, {bool required = false}) =>
      elements.replaceUid(index, uids);

  List<Element> replaceAllUids(int index, Iterable<Uid> uids) =>
      elements.replaceAllUids(index, uids);

  /// Replaces the element with [index] with a new element that is
  /// the same except it has no values.  Returns the original element.
  Element noValues(int index, {bool required = false}) =>
      elements.noValues(index, required: required);

  /// Replaces all elements with [index] in _this_ and any [Item]s
  /// descended from it, with a new element that is the same except
  /// it has no values. Returns a list containing all [Element]s
  /// that were replaced.
  List<Element> noValuesAll(int index, {bool recursive = false}) =>
      elements.noValuesAll(index);

  Element delete(int index, {bool required = false, bool recursive = false}) =>
      (recursive)
      ? elements.deleteAll(index, recursive: recursive)
      : elements.delete(index, required: required);

  List<Element> deleteAll(int index, {bool recursive = false}) =>
      elements.deleteAll(index, recursive: recursive);

  List<Element> deleteIfTrue(bool test(Element e), {bool recursive = false}) {
    final deleted = <Element>[];
    for (var e in elements) {
      if (test(e)) {

        delete(e.index);
        deleted.add(e);

      } else if (e is SQ) {
        for(var item in e.items) {
          final dList = item.deleteIfTrue(test, recursive: recursive);
          deleted.addAll(dList);
        }
      }
    }
    return deleted;
  }
  Iterable<Element> deleteAllPrivate({bool recursive = false}) =>
      deleteIfTrue((e) => e.isPrivate, recursive: recursive);

  Iterable<Element> deletePrivateGroup(int group, {bool recursive = false}) =>
      deleteIfTrue((e) => e.isPrivate && e.group.isOdd, recursive: recursive);

  Iterable<Element> retainSafePrivate() {
    final dList = <Element>[];
    //TODO: finish
    return dList;
  }

  // **** end Element interface

  // **** Getters for [values]s.

  /// Returns the [int] value for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  V getValue<V>(int index, {bool required = false}) =>
      elements.getValue(index, required: required);

  List<V> getValues<V>(int index, {bool required = false}) =>
      elements.getValues(index, required: required);

  // **** Integers

  /// Returns the [int] value for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  int getInt(int index, {bool required = false}) =>
      elements.getInt(index, required: required);

  /// Returns the [List<int>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<int> getIntList(int index, {bool required = false}) =>
      elements.getIntList(index, required: required);

  // **** Floating Point

  /// Returns a [double] value for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  double getFloat(int index, {bool required = false}) =>
      elements.getFloat(index, required: required);

  /// Returns the [List<double>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<double> getFloatList(int index, {bool required = false}) =>
      elements.getFloatList(index, required: required);

  // **** String

  /// Returns a [double] value for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  String getString(int index, {bool required = false}) =>
      elements.getString(index, required: required);

  /// Returns the [List<double>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<String> getStringList(int index, {bool required = false}) =>
      elements.getStringList(index, required: required);

  // **** Item

  /// Returns an [Item] value for the [SQ] [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  Item getItem(int index, {bool required = false}) =>
      elements.getItem(index, required: required);

  /// Returns the [List<double>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<Item> getItemList(int index, {bool required = false}) =>
      elements.getItemList(index, required: required);

  // **** Uid

  /// Returns a [Uid] value for the [UI] [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  Uid getUid(int index, {bool required = false}) =>
      elements.getUid(index, required: required);

  /// Returns the [List<double>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<Uid> getUidList(int index, {bool required = false}) =>
      elements.getUidList(index, required: required);

  /// Returns the original [DA] [Element] that was replaced in the
  /// [Dataset] with a new [Element] with a normalized [Date] based
  /// on the original [Date] and the [enrollment] [Date].
  /// If [Element] is not present, either throws or returns _null_;
  Element normalizeDate(int index, Date enrollment) {
    final old = lookup(index);
    if (old is DA) {
      final e = old.normalize(enrollment);
      replace(index, e);
      return old;
    }
    return invalidElementError(old, 'Not a DA (date) Element');
  }
  /// Returns a formatted [String]. See [Formatter].
  String format(Formatter z) => z.fmt(this, elements);

  @override
  String toString() => '$runtimeType ${elements.total} Elements, $length Top Level, '
      '${elements.duplicates.length} Duplicates, isRoot $isRoot';

  // **************** RootDataset related Getters and Methods

  /// Returns _true_ if _this_ is a [RootDataset].
  bool get isRoot => parent == null;

  /// The [RootDataset] of _this_.
  /// _Note_: A [RootDataset] is its own [root].
  Dataset get root => (isRoot) ? this : parent.root;

  /// If _true_ duplicate [Element]s are stored in the duplicate Map
  /// of the [Dataset]; otherwise, a [DuplicateElementError] is thrown.
  bool get allowDuplicates => elements.allowDuplicates;
  set allowDuplicates(bool v) => elements.allowDuplicates = v;

  /// If _true_ [Element]s with invalid values are stored in the
  /// [Dataset]; otherwise, an [InvalidValuesError] is thrown.
  bool get allowInvalidValues => elements.allowInvalidValues;
  set allowInvalidValues(bool v) => elements.allowInvalidValues = v;

  /// A field that control whether new [Element]s are checked for
  /// [Issues] when they are [add]ed to the [Dataset].
  bool get checkIssuesOnAdd => elements.checkIssuesOnAdd;
  set checkIssuesOnAdd(bool v) => elements.checkIssuesOnAdd = v;

  /// A field that control whether new [Element]s are checked for
  /// [Issues] when they are accessed from the [Dataset].
  bool get checkIssuesOnAccess => elements.checkIssuesOnAccess;
  set checkIssuesOnAccess(bool v) => elements.checkIssuesOnAccess = v;

  // **************** Element value accessors
  //TODO: when fast_tag is working replace code with index.
  // Note: currently the variable 'index' in this file means code.

  // Image Pixel Macro values

  int get frameCount => getInt(kNumberOfFrames);

  int get samplesPerPixel => getInt(kSamplesPerPixel);

  String get photometricInterpretation => getString(kPhotometricInterpretation);

  int get rows => getInt(kRows);

  int get columns => getInt(kColumns);

  int get bitsAllocated => getInt(kBitsAllocated);

  int get bitsStored => getInt(kBitsStored);

  int get highBit => getInt(kHighBit);

  int get pixelRepresentation => getInt(kPixelRepresentation);

  //TODO definedTerms [colorByPixel = 0, colorByPlane = 1]
  int get planarConfiguration => getInt(kPlanarConfiguration);

  double get pixelAspectRatio {
    final list = getStringList(kPixelAspectRatio);
    //   print('PAR list: $list');
    if (list == null || list.isEmpty) return 1.0;
    if (list.length != 2) {
      invalidValuesError(list, tag: PTag.kPixelAspectRatio);
      //Issue: is this reasonable?
      return 1.0;
    }
    final numerator = int.parse(list[0]);
    final denominator = int.parse(list[1]);
    //   print('num: $numerator, den: $denominator');
    return numerator / denominator;
  }

  int get smallestImagePixelValue => getInt(kSmallestImagePixelValue);

  int get largestImagePixelValue => getInt(kLargestImagePixelValue);

  /// Returns a [Uint8List] or [Uint16List] of pixels from the [kPixelData]
  /// [Element];
  List<int> getPixelData() {
    final bitsAllocated = getInt(kBitsAllocated);
    return _getPixelData(bitsAllocated);
  }

  List<int> _getPixelData(int bitsAllocated) {
    final pd = elements[kPixelData];
    if (pd == null || bitsAllocated == null) return pixelDataNotPresent();
    //    return (throwOnError) ? throw 'Dataset $this Missing Pixel Data' : null;
    if (pd.code == kPixelData) {
      if (pd is OWPixelData) {
        assert(bitsAllocated == 16);
        return pd.pixels;
      } else if (pd is OBPixelData) {
        assert(bitsAllocated == 8 || bitsAllocated == 1);
        return pd.pixels;
      } else if (pd is UNPixelData) {
        // TODO: use transfer syntax to convert UN into OW or OB
        assert(bitsAllocated == 8 || bitsAllocated == 1);
        return pd.pixels;
      } else {
        return invalidElementError(pd, '$pd is bad Pixel Data');
      }
    }
    if (throwOnError) return null;
    return null;
  }

  /// PrivateGroup]s contained in this [Dataset].
  /// [privateGroups] has one-time setter that is initialized lazily.
  /// Note: this may disappear in the future.  Don't rely on it.
  List<PrivateGroup> get privateGroups => _privateGroups;
  List<PrivateGroup> _privateGroups;
  set privateGroups(List<PrivateGroup> vList) => _privateGroups ??= vList;

  int _privateElementCounter(int count, Element e) => e.isPrivate ? count + 1 : count;
  int get nPrivateElements => fold(0, _privateElementCounter);

  int _privateGroupCounter(int count, Element e) =>
      e.isPrivateCreator ? count + 1 : count;
  int get nPrivateGroups => fold(0, _privateGroupCounter);

  // **** Statics

  static const List<Dataset> empty = const <Dataset>[];

  static final ByteData emptyByteData = new ByteData(0);
}
