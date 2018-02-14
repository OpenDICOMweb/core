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
import 'package:core/src/dataset/base/private_group.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/element_list/element_list.dart';
import 'package:core/src/dataset/errors.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/integer/pixel_data.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/tag/export.dart';
import 'package:core/src/uid/uid.dart';

// ignore_for_file: unnecessary_getters_setters

// Meaning of method names:
//    lookup:
//    add:
//    update
//    replace(int index, Iterable<V>: Replaces
//    noValue: Replaces an Element in the Dataset with one with an empty value.
//    delete: Removes an Element from the Dataset

// Design Note:
//   Only [keyToTag] and [keys] use the Type variable <K>. All other
//   Getters and Methods are defined in terms of [Element] [index].
//   [Element.index] is currently [Element.code], but that is likely
//   to change in the future.

/// A DICOM Dataset. The [Type] [<K>] is the Type of 'key'
/// used to lookup [Element]s in the [Dataset]].
abstract class Dataset extends ListBase<Element> {
  // **** Start of Interface ****
  DSBytes get dsBytes;

  /// Returns the [Tag.index] for the corresponding [key].
  int keyToIndex(int key);

  Tag getTag(int index);

  /// The parent of _this_. If [parent] == _null_, then this is a Root Dataset
  /// (see RootDatasetMixin); otherwise, it is an [Item].
  Dataset get parent;

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
    elements.add(e);
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
  int get hashCode => system.hasher.nList(elements);

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

  // TODO: implement private groups and Private elements
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

  bool hasElementsInRange(int min, int max) =>
      elements.hasElementsInRange(min, max);

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

  /// Returns a new [Element] with the same [index] and [Type],
  /// but with [Element.values] containing [f]([List<V>]).
  ///
  /// If updating the [Element] fails, the current element is left in
  /// place and _null_ is returned.
  Element updateF<V>(int index, Iterable f(Iterable<V> vList),
      {bool required = false}) {
    final old = lookup(index, required: required);
    if (old == null) return (required) ? elementNotPresentError(index) : null;
    if (old != null) this[index] = old.updateF(f);
    return old;
  }

  /// Updates all Elements with [index] in _this_, or any Sequence ([SQ])
  /// Items contained in _this_, with a new element whose values are
  /// [f(this.values)]. Returns a list containing all [Element]s that were
  /// replaced.
  List<Element> updateAll<V>(int index,
      {Iterable<V> vList, bool required = false}) {
    vList ??= const <V>[];
    final v = update(index, vList, required: required);
    final result = <Element>[]..add(v);
    for (var e in this)
      if (e is SQ) {
        result.addAll(e.updateAll<V>(index, vList, required: required));
      } else {
        result.add(e.replace(e.values));
      }
    return result;
  }

  /// Updates all Elements with [index] in _this_, or any Sequence ([SQ])
  /// Items contained in it, with a new element whose values are
  /// [f(this.values)]. Returns a list containing all [Element]s that were
  /// replaced.
  List<Element> updateAllF<V>(int index, Iterable<V> f(Iterable<V> vList),
      {bool required = false}) {
    final v = updateF(index, f, required: required);
    final result = <Element>[]..add(v);
    for (var e in this)
      if (e is SQ) {
        result.addAll(e.updateAllF<V>(index, f, required: required));
      } else {
        result.add(e.replace(e.values));
      }
    return result;
  }

//  Element updateUid(int index, Iterable<Uid> uids, {bool required = false}) =>
//      elements.updateUid(index, uids);

  Element updateUid(int index, Iterable<Uid> uids, {bool required = false}) {
    assert(index != null && uids != null);
    final old = lookup(index, required: required);
    if (old == null) return (required) ? elementNotPresentError(index) : null;
    if (old is! UI) return invalidUidElement(old);
    add(old.update(uids.toList(growable: false)));
    return old;
  }

  /// Replace the UIDs in an [Element]. If [required] is _true_ and the
  /// [Element] is not present a [elementNotPresentError] is called.
  /// It is an error if [sList] is _null_.  It is an error if the [Element]
  /// corresponding to [index] does not have a VR of UI.
  Element updateUidList(int index, Iterable<String> sList,
      {bool recursive = true, bool required = false}) {
    assert(index != null && sList != null);
    final old = lookup(index, required: required);
    if (old == null) return (required) ? elementNotPresentError(index) : null;
    if (old is! UI) return invalidUidElement(old);

    // If [e] has noValues, and [uids] == null, just return [e],
    // because there is no discernible difference.
    if (old.values.isEmpty && sList.isEmpty) return old;
    return old.update(sList);
  }

  Element updateUidStrings(int index, Iterable<String> uids,
          {bool required = false}) =>
      updateUidList(index, uids);

  List<Element> updateAllUids(int index, Iterable<Uid> uids) {
    final v = updateUid(index, uids);
    final result = <Element>[]..add(v);
    for (var e in this)
      if (e is SQ) {
        result.addAll(e.updateAllUids(index, uids));
      } else {
        result.add(e.replace(e.values));
      }
    return result;
  }

//  List<Element> updateAllUids(int index, Iterable<Uid> uids) =>
//      elements.updateAllUids(index, uids);

/*
  /// Replaces the _values_ of the [Element] with [index] with [vList].
  /// Returns the original _values_.
  Iterable<V> replace<V>(int index, Iterable<V> vList,
      {bool required = false}) {
    final e = elements.lookup(index, required: required);
    if (e == null) return const <V>[];
    final old = e.values;
    e.values = vList;
    return old;
  }
*/

  /// Replaces the [Element.values] at [index] with [vList].
  /// Returns the original [Element.values], or _null_ if no
  /// [Element] with [index] was not present.
  Iterable<V> replace<V>(int index, Iterable<V> vList,
      {bool required = false}) {
    assert(index != null && vList != null);
    final e = lookup(index, required: required);
    if (e == null) return (required) ? elementNotPresentError(index) : null;
    final v = e.values;
    e.replace(vList);
    return v;
  }

  /// Replaces the [Element.values] at [index] with [f(vList)].
  /// Returns the original [Element.values], or _null_ if no
  /// [Element] with [index] was not present.
  Iterable<V> replaceF<V>(int index, Iterable<V> f(Iterable<V> vList),
      {bool required = false}) {
    assert(index != null && f != null);
    final e = lookup(index, required: required);
    if (e == null) return (required) ? elementNotPresentError(index) : null;
    final v = e.values;
    e.replace(f(v));
    return v;
  }

  /// Replaces all elements with [index] in _this_ and any [Item]s
  /// descended from it, with a new element that has [vList<V>] as its
  /// values. Returns a list containing all [Element]s that were replaced.
//  Iterable<Iterable<V>> replaceAll<V>(int index, Iterable<V> vList) =>
//      elements.replaceAll(index, vList);

/*
  Iterable<Iterable<V>> replaceAllF<V>(
          int index, Iterable<V> f(Iterable vList)) =>
      elements.replaceAllF<V>(index, f);
*/

  Iterable<Iterable<V>> replaceAll<V>(int index, Iterable<V> vList) {
    assert(index != null && vList != null);
    final result = <List<V>>[]..add(replace(index, vList));
    for (var e in elements)
      if (e is SQ) {
        result.addAll(e.replaceAll(index, vList));
      } else {
        result.add(e.replace(e.values));
      }
    return result;
  }

  Iterable<Iterable<V>> replaceAllF<V>(
      int index, Iterable<V> f(Iterable<V> vList)) {
    assert(index != null && f != null);
    final result = <List<V>>[]..add(replaceF(index, f));
    for (var e in elements)
      if (e is SQ) {
        result.addAll(e.replaceAllF(index, f));
      } else {
        result.add(e.replace(f(e.values)));
      }
    return result;
  }

/*
  Iterable<String> replaceUid(int index, Iterable<Uid> uids,
          {bool required = false}) =>
      elements.replaceUid(index, uids);
*/

  List<String> replaceUid(int index, Iterable<Uid> uids,
      {bool required = false}) {
    final old = lookup(index);
    if (old == null) return (required) ? elementNotPresentError(index) : null;
    if (old is UI) {
      old.replaceUid(uids);
      return old;
    }
    return invalidUidElement(old);
  }

/*
  Iterable<Element> replaceAllUids(int index, Iterable<Uid> uids) =>
      elements.replaceAllUids(index, uids);
*/

  List<Element> replaceAllUids(int index, Iterable<Uid> uids) {
    final v = updateUid(index, uids);
    final result = <Element>[]..add(v);
    for (var e in elements)
      if (e is SQ) {
        result.addAll(e.updateAllUids(index, uids));
      } else {
        result.add(e.replace(e.values));
      }
    return result;
  }

  /// Replaces the element with [index] with a new element that is
  /// the same except it has no values.  Returns the original element.
//  Element noValues(int index, {bool required = false}) =>
//      elements.noValues(index, required: required);

  /// Replaces the element with [index] with a new element that is
  /// the same except it has no values.  Returns the original element.
  Element noValues(int index, {bool required = false}) {
    final old = lookup(index, required: required);
    if (old == null) return (required) ? elementNotPresentError(index) : null;
    final nv = old.noValues;
    elements.replace(index, nv);
    return old;
  }

  /// Replaces all elements with [index] in _this_ and any [Item]s
  /// descended from it, with a new element that is the same except
  /// it has no values. Returns a list containing all [Element]s
  /// that were replaced.
//  Iterable<Element> noValuesAll(int index, {bool recursive = false}) =>
//      elements.noValuesAll(index);

  /// Updates all [Element.values] with [index] in _this_ or in any
  /// Sequences (SQ) contained in _this_ with an empty list.
  /// Returns a List<Element>] of the original [Element.values] that
  /// were updated.
  List<Element> noValuesAll(int index) {
    assert(index != null);
    final result = <Element>[]..add(noValues(index));
    for (var e in elements) {
      if (e is SQ) {
        result.addAll(e.noValuesAll(index));
      } else if (e.index == index) {
        result.add(e);
        this[index] = e.noValues;
      }
    }
    return result;
  }

/*
  Element delete(int index, {bool required = false, bool recursive = false}) =>
      (recursive)
          ? elements.deleteAll(index, recursive: recursive)
          : elements.delete(index, required: required);
*/

  /// Removes the [Element] with [index] from _this_.
  Element delete(int index, {bool required = false}) {
    assert(index != null, 'Invalid index: $index');
    final e = lookup(index, required: required);
    return (e == null)
        ? (required) ? elementNotPresentError<int>(index) : null
        : elements.delete(index);
  }

/*
  Iterable<Element> deleteAll(int index, {bool recursive = false}) =>
      elements.deleteAll(index, recursive: recursive);
*/

  List<Element> deleteAll(int index, {bool recursive = false}) {
    assert(index != null, 'Invalid index: $index');
    final results = <Element>[];
    final e = delete(index);
    if (e != null) results.add(e);
    assert(this[index] == null);
    if (recursive)
      for (var e in elements) {
        if (e is SQ) {
          for (var item in e.items) {
            final deleted = item.delete(index);
//            if (deleted != null) print('item $item deleted: $deleted');
            if (deleted != null) results.add(deleted);
          }
        }
      }
    return results;
  }

  // Urgent Jim: Fix - maybe remove recursive call
  List<Element> deleteIfTrue(bool test(Element e), {bool recursive = false}) {
    final deleted = <Element>[];
    for (var e in elements) {
      if (test(e)) {
        delete(e.index);
        deleted.add(e);
      } else if (e is SQ) {
        for (var item in e.items) {
          final dList = item.deleteIfTrue(test, recursive: recursive);
          deleted.addAll(dList);
        }
      }
    }
    return deleted;
  }

  Iterable<Element> copyWhere(bool test(Element e)) {
    final result = <Element>[];
    for (var e in elements) {
      if (test(e)) result.add(e);
    }
    return result;
  }

  Iterable<Element> findWhere(bool test(Element e)) {
    final result = <Element>[];
    for (var e in elements) {
      if (test(e)) result.add(e);
    }
    return result;
  }

  Iterable<dynamic> findAllWhere(bool test(Element e)) {
    final result = <dynamic>[];
    for (var e in elements) if (test(e)) result.add(e);
    return result;
  }

  Map<SQ, Element> findSQWhere(bool test(Element e)) {
    final map = <SQ, Element>{};
    for (var e in elements) {
      if (e is SQ) {
        for (var item in e.items) {
          final eList = item.findAllWhere(test);
          if (eList.isNotEmpty) {
            map[e];
          }
        }
      }
    }
    return map;
  }

  bool _isDA(Element e) => e is DA;
  Iterable<Element> findDates() => findAllWhere(_isDA);

  bool _isUI(Element e) => e is UI;
  Iterable<Element> findUids() => findAllWhere(_isUI);

  bool _isSQ(Element e) => e is SQ;
  Iterable<Element> findSequences() => findWhere(_isSQ);

  bool _isPrivate(Element e) => e.isPrivate;
  Iterable<Element> findAllPrivate() => findAllWhere(_isPrivate);

  Iterable<Element> deleteAllPrivate({bool recursive = false}) {
    // deleteIfTrue((e) => e.isPrivate, recursive: recursive);
    final deleted = <Element>[];
    final private = findAllPrivate();
    for (var e in private)
       deleted.add( delete(e.index, required: true));
    return deleted;
  }

  // final sequences = findAllSequences();
  /*
    for (var e in elements) {
      if (e.group.isOdd) print('Odd: $e');
      if (e.isPrivate) {
        final v = delete(e.code);
        if (v != null) deleted.add(e);
        if (v != null) print('DPrivate: $v');
      }
    }
    if (deleted != null) print('DeletedPrivate: (${deleted.length})$deleted');

    for (var e in elements) {
      if (e.isPrivate) {
        deleted.add(delete(e.code));
      }
      print('DeletedPrivate: (${deleted.length})$deleted');
    }
*/
/*

    final deletedInSQ = <Element>[];
    var count = 0;
    print('sequences: $sequences');
    for (var e in sequences) {
      if (e is SQ) {
        count++;
        print('sq: $e');
        for (var item in e.items) {
          print(' item: $item');
          for(var v in item.elements) {
            if (v.isPrivate) {
              print('  Deleted: $v');
              deletedInSQ.add(delete(v.code));
            }
          }
        }
      }
    }
    print('SQ.length: ${sequences.length}');
        print('SQ.count: $count');
        deleted.addAll(deletedInSQ);
    print('DeletedPrivate: (${deleted.length})$deleted');
    return deleted;
  }
*/

  Iterable<Element> deletePrivateGroup(int group, {bool recursive = false}) =>
      deleteIfTrue((e) => e.isPrivate && e.group.isOdd, recursive: recursive);

  Iterable<Element> retainSafePrivate() {
    final dList = <Element>[];
    //TODO: finish
    return dList;
  }

  @override
  bool remove(Object o) => elements.remove(o);

  /// Removes the [Element] with key from _this_.
  @override
  Element removeAt(int index, {bool required = false}) =>
      elements.removeAt(index, required: required);

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
  String toString() =>
      '$runtimeType ${elements.total} Elements, $length Top Level, '
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

  int _privateElementCounter(int count, Element e) =>
      e.isPrivate ? count + 1 : count;
  int get nPrivateElements => fold(0, _privateElementCounter);

  int _privateGroupCounter(int count, Element e) =>
      e.isPrivateCreator ? count + 1 : count;
  int get nPrivateGroups => fold(0, _privateGroupCounter);

  // **** Statics

  static const List<Dataset> empty = const <Dataset>[];

  static final ByteData emptyByteData = new ByteData(0);
}
