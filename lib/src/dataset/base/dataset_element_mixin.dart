//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/group/private_group.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/tag/code.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/value/date_time.dart';
import 'package:core/src/value/uid.dart';

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
abstract class DatasetElementMixin<V> {
  // **** Start of Interface ****

  Dataset get parent;
  List<Element> get elements;
  List<SQ> get sequences;
  int get length;
  /// Returns the Element with [index], if present; otherwise, returns _null_.
  ///
  /// _Note_: All lookups should be done using this method.
  ///
  // Design Note: This method should record the index of any Elements
  // not found if [recordNotFound] is _true_.
  // TODO: turn required into an EType test
  Element lookup(int index, {bool required = false});

  Element internalLookup(int index);

  void add(Element e, [Issues issues]);

  bool tryAdd(Element e, [Issues issues]);

  Element deleteCode(int index);

  /// Store [Element] [e] at [index] in _this_.
  void store(int index, Element e);

  bool remove(Object e);

  // **** End of Interface ****

  /// Sets the values of the [Element] with [code] to the _emptyList_
  /// for that [Element].  If no [Element] in _this_ has [code] returns
  /// _null_.
  // TODO: better name
  List<V> toEmpty(int code) {
    if (!isValidTagCode(code)) return badTagCode(code);
    final e = lookup(code);
    if (e == null) return null;
    if (e.checkValues(e.emptyList)) {
      final values = e.values;
      e.values = e.emptyList;
      return values;
    } else {
      return badValues(e.emptyList);
    }
  }

  List<V> values(int code) {
    if (!Tag.isValidCode(code)) return badTagCode(code);
    final e = lookup(code);
    return (e == null) ? elementNotPresentError(code) : e.values;
  }




  // **** Section Start: Default Operator and Getters
  // **** These may be overridden in subclasses.

  // **** Section Start: Element related Getters and Methods

  // Dataset<K> copy([Dataset<K> parent]);

  bool hasElementsInRange(int min, int max) {
    for (var e in elements) if (e.code >= min && e.code <= max) return true;
    return false;
  }

  /// Returns a [List] of the Elements that satisfy [min] <= e.code <= [max].
  List<Element> getElementsInRange(int min, int max) {
    final elements = <Element>[];
    for (var e in elements) if (e.code >= min && e.code < max) elements.add(e);
    return elements;
  }

  /// Replaces the element with [index] with a new element with the same [Tag],
  /// but with [vList] as its _values_. Returns the original element.
  Element update(int index, Iterable vList, {bool required = false}) {
    final old = lookup(index, required: required);
    if (old != null) store(index, old.update(vList));
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
    if (old != null) store(index, old.updateF(f));
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
    for (var e in elements)
      if (e is SQ) {
        result.addAll(e.updateAll<V>(index, vList, required: required));
      } else {
        result.add(e.update(e.values));
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
    for (var e in elements)
      if (e is SQ) {
        result.addAll(e.updateAllF<V>(index, f, required: required));
      } else {
        result.add(e.update(e.values));
      }
    return result;
  }

//  Element updateUid(int index, Iterable<Uid> uids, {bool required = false}) =>
//      elements.updateUid(index, uids);

  Element updateUid(int index, Iterable<Uid> uids, {bool required = false}) {
    assert(index != null && uids != null);
    final old = lookup(index, required: required);
    if (old == null) return (required) ? elementNotPresentError(index) : null;
    if (old is! UI) return badUidElement(old);
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
    if (old is! UI) return badUidElement(old);

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
    for (var e in elements)
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
  List<V> replace<V>(int index, Iterable<V> vList,
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
  List<V> replaceF<V>(int index, Iterable<V> f(Iterable<V> vList),
      {bool required = false}) {
    assert(index != null && f != null);
    final e = lookup(index, required: required);
    if (e == null) return (required) ? elementNotPresentError(index) : null;
    final v = e.values;
    e.replace(f(v));
    return v;
  }

  /// Replaces all Elements with [index] in _this_, or any Sequence ([SQ])
  /// Items contained in _this_, with a new element whose values are
  /// [vList]. Returns a list containing all [Element]s that were
  /// replaced.
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

  List<Iterable<V>> replaceAllF<V>(
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

  bool replaceValues<V>(int index, Iterable<V> vList) {
    final e = lookup(index);
    if (e == null) return elementNotPresentError(index);
    if (!e.checkValues(vList)) return false;
    e.replace(vList);
    return true;
  }

/*
  Iterable<String> replaceUid(int index, Iterable<Uid> uids,
          {bool required = false}) =>
      elements.replaceUid(index, uids);
*/

  List<Uid> replaceUids(int index, Iterable<Uid> uids,
      {bool required = false}) {
    final old = lookup(index);
    if (old == null) return (required) ? elementNotPresentError(index) : null;
    return (old is UI) ? old.replaceUid(uids) : badUidElement(old);
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
  Element noValues(int index, {bool required = false}) {
    final oldE = lookup(index, required: required);
    if (oldE == null) return (required) ? elementNotPresentError(index) : null;
    final newE = oldE.update(oldE.emptyList);
    store(index, newE);
    return oldE;
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
  Iterable<Element> noValuesAll(int index) {
    assert(index != null);
    final result = <Element>[]..add(noValues(index));
    for (var e in elements) {
      if (e is SQ) {
        result.addAll(e.noValuesAll(index));
      } else if (e.index == index) {
        result.add(e);
        store(index, e.noValues);
      }
    }
    return result;
  }

  /// Removes the [Element] with [code] from _this_. If no [Element]
  /// with [code] is contained in _this_ returns _null_.
  Element delete(int code, {bool required = false}) {
    assert(code != null && !code.isNegative, 'Invalid index: $code');
    final e = lookup(code, required: required);
    if (e == null) return (required) ? elementNotPresentError<int>(code) : null;
    return (remove(e)) ? e : null;
  }

  /// Deletes all [Element]s in _this_ that have a Tag Code in [codes].
  /// If there is no [Element] with one of the codes _this_ does nothing.
  List<Element> deleteCodes(List<int> codes) {
    assert(codes != null && codes.isNotEmpty);
    final deleted = <Element>[];
    for (var code in codes) {
      final e = deleteCode(code);
      if (e != null) deleted.add(e);
    }
    return deleted;
  }

  List<Element> deleteAll(int index, {bool recursive = false}) {
    assert(index != null, 'Invalid index: $index');
    final results = <Element>[];
    final e = delete(index);
    if (e != null) results.add(e);
    assert(lookup(index) == null);
    if (recursive)
      for (var e in elements) {
        if (e is SQ) {
          for (var item in e.items) {
            final deleted = item.delete(index);
            if (deleted != null) results.add(deleted);
          }
        }
      }
    return results;
  }

  // TODO Jim: maybe remove recursive call
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
  Iterable<Element> findAllPrivate0() => findAllWhere(_isPrivate);

  List<int> findAllPrivateCodes({bool recursive: false}) {
    final privates = <int>[];
    for (var e in elements) if (e.isPrivate) privates.add(e.code);
    return privates;
  }

  List<Element> deleteAllPrivate({bool recursive = false}) {
    final privates = findAllPrivateCodes(recursive: recursive);
    final deleted = deleteCodes(privates);
    if (recursive) {
      // Fix: you cant tell what sequence the element was in.
      for (var sq in sequences) {
        for (var i = 0; i < sq.items.length; i++) {
          final Iterable<int> codes =
              sq.items.elementAt(i).findAllPrivateCodes();
          final elements = deleteCodes(codes);
          deleted.addAll(elements);
        }
      }
    }
    return deleted;
  }

  /// Deletes all Private Elements in Public Sequences.
  // TODO: doesn't implement recursion
  List<Element> deleteAllPrivateInPublicSQs({bool recursive = false}) {
    final deleted = <Element>[];
    for (var sq in sequences) {
      for (var item in sq.items) {
        final privates = item.deleteAllPrivate();
        if (privates.isNotEmpty) deleted.addAll(privates);
      }
    }
    return deleted;
  }

  Iterable<Element> deletePrivateGroup(int group, {bool recursive = false}) =>
      deleteIfTrue((e) => e.isPrivate && e.group.isOdd, recursive: recursive);

  Iterable<Element> retainSafePrivate() {
    final dList = <Element>[];
    //TODO: finish
    return dList;
  }

  // **** Getters for [values]s.

  /// Returns the value for the [Element] with [index]. If the [Element]
  /// is not present or if the [Element] has more than one value,
  /// either throws or returns _null_;
  V getValue<V>(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null) return (required) ? elementNotPresentError(index) : null;
    return _checkOneValue(index, e.values);
  }

  V _checkOneValue<V>(int index, List<V> values) =>
      (values == null || values.length != 1)
          ? badValuesLength(values, 0, 1, null, Tag.lookupByCode(index))
          : values.first;

  /// Returns the [int] value for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<V> getValues<V>(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null) return (required) ? elementNotPresentError(index) : null;
    final List<V> values = e.values;
    assert(values != null);
    return (global.allowInvalidValues) ? e.values : e.isValid;
  }

  // **** Integers

  /// Returns the [int] value for the [Integer] Element with [index].
  /// If the [Element] is not present or if the [Element] has more
  /// than one value, either throws or returns _null_.
  int getInt(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! Integer) return nonIntegerTag(index);
    return _checkOneValue<int>(index, e.values);
  }

  /// Returns the [List<int>] values for the [Integer] Element with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<int> getIntList(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! Integer) return nonIntegerTag(index);
    if (!global.allowInvalidValues && !e.hasValidValues)
      return elementError('Invalud Values: $e', e);
    final vList = e.values;
    //if (vList == null) return nullValueError('getIntList');
    assert(vList != null);
    return vList;
  }

  // **** Floating Point

  /// Returns a [double] value for the [Float] Element with
  /// [index]. If the [Element] is not present or if the [Element] has more
  /// than one value, either throws or returns _null_.
  double getFloat(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! Float) return nonFloatTag(index);
    return _checkOneValue<double>(index, e.values);
  }

  /// Returns the [List<double>] values for the [Float] Element
  /// with [index]. If [Element] is not present, either throws or returns
  /// _null_;
  List<double> getFloatList(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! Float) return badFloatElement(e);
    final vList = e.values;
    //if (vList == null) return nullValueError('getFloatList');
    assert(vList != null);
    return vList;
  }

  // **** String

  /// Returns a [double] value for the [StringBase] Element with [index].
  /// If the [Element] is not present or if the [Element] has more
  /// than one value, either throws or returns _null_.
  String getString(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! StringBase) return nonStringTag(index);
    return (e.isEmpty) ? '' : _checkOneValue<String>(index, e.values);
  }

  /// Returns the [List<double>] values for the [StringBase] Element
  /// with [index]. If [Element] is not present, either throws or returns
  /// _null_;
  List<String> getStringList(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! StringBase) return nonStringTag(index);
    if (!global.allowInvalidValues && !e.hasValidValues)
      return elementError('Invalud Values: $e', e);
    final vList = e.values;
    //if (vList == null) return nullValueError('getStringList');
    assert(vList != null);
    return vList;
  }

  // **** Item

  /// Returns an [Item] value for the [SQ] [Element] with [index].
  /// If the [Element] is not present or if the [Element] has more
  /// than one value, either throws or returns _null_.
  Item getItem(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null)
      return (required == false) ? null : elementNotPresentError(index);
    if (e is SQ) return _checkOneValue<Item>(index, e.values);
    return nonSequenceTag(index);
  }

  /// Returns the [List<Item>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<Item> getItemList(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null)
      return (required == false) ? null : elementNotPresentError(index);
    if (e is SQ) {
      final vList = e.values;
      if (vList == null) return nullValueError('getItemList');
      return vList;
    }
    return nonSequenceTag(index);
  }

  // **** Uid

  /// Returns a [Uid] value for the [UI] [Element] with [index].
  /// If the [Element] is not present or if the [Element] has more
  /// than one value, either throws or returns _null_.
  Uid getUid(int index, {bool required = false}) {
    // Note: this might be UI or UN
    final e = lookup(index, required: required);
    if (e == null) return null;
    if (e is UI) return _checkOneValue<Uid>(index, e.uids);
    if (e is UN) {
      var s = e.vfBytesAsUtf8;
      if (s.codeUnitAt(s.length - 1) == 0) s = s.substring(0, s.length - 1);
      return new Uid(s);
    }
    return elementError('Invalud Values: $e', e);
  }

  /// Returns the [List<double>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<Uid> getUidList(int index, {bool required = false}) {
    final UI e = lookup(index, required: required);
    if (e == null) {
      log.warn('${dcm(index)} not present');
      return null;
    } else if (e is! UI) {
      return nonUidTag(index);
    } else {
      final vList = e.uids;
      if (vList == null) return nullValueError('getUidList');
      return vList;
    }
  }

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
    return elementError('Not a DA (date) Element', old);
  }

  /// Returns a formatted [String]. See [Formatter].
  String format(Formatter z) => z.fmt('$runtimeType: $length Elements', this);

  // **************** RootDataset related Getters and Methods

  /// Returns _true_ if _this_ is a [RootDataset].
  bool get isRoot => parent == null;

  /// The [RootDataset] of _this_.
  /// _Note_: A [RootDataset] is its own [root].
  DatasetElementMixin get root => (isRoot) ? this : parent.root;

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
    final vList = getStringList(kPixelAspectRatio);
    if (vList == null || vList.isEmpty) return 1.0;
    if (vList.length != 2) {
      badValuesLength(vList, 2, 2, null, PTag.kPixelAspectRatio);
      //Issue: is this reasonable?
      return 1.0;
    }
    final numerator = int.parse(vList[0]);
    final denominator = int.parse(vList[1]);
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
    final e = lookup(kPixelData);
    if (e == null || bitsAllocated == null) return pixelDataNotPresent();
    assert(e.code == kPixelData);

    if (e is PixelData) {
      if (e is OWPixelData) {
        assert(bitsAllocated == 16);
        return e.values;
      } else if (e is OBPixelData) {
        assert(bitsAllocated == 8 || bitsAllocated == 1);
        return e.values;
      } else if (e is UNPixelData) {
        // TODO: use transfer syntax to convert UN into OW or OB
        assert(bitsAllocated == 8 || bitsAllocated == 1);
        return e.values;
      } else {
        return elementError('$e is bad Pixel Data', e);
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
  int get nPrivateElements => elements.fold(0, _privateElementCounter);

  int _privateGroupCounter(int count, Element e) =>
      e.isPrivateCreator ? count + 1 : count;
  int get nPrivateGroups => elements.fold(0, _privateGroupCounter);

  // **** Statics

  static const List<Dataset> empty = const <Dataset>[];

  static final ByteData emptyByteData = new ByteData(0);
}
