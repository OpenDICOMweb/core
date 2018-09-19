//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/element.dart';
import 'package:core/src/error/dataset_errors.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values/date_time.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

abstract class ReplaceMixin<V> {
  /// An [Iterable<Element>] of the [Element]s contained in _this_.
  ///
  // Design Note: It is expected that [ElementList] will have
  // it's own specialized implementation for correctness and efficiency.
  List<Element> get elements;

  /// Store [Element] [e] at [index] in _this_.
  void store(int index, Element e);

  void add(Element e, [Issues issues]);

  bool isValidValues(Iterable<V> vList);

  /// Returns the Element with [index], if present; otherwise, returns _null_.
  ///
  /// _Note_: All lookups should be done using this method.
  ///
  // Design Note: This method should record the index of any Elements
  // not found if [recordNotFound] is _true_.
  // TODO: turn required into an EType test
  Element lookup(int index, {bool required = false});

  Element updateUid(int index, Iterable<Uid> uids, {bool required = false});

// **** End Interface

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
  List<V> replace(int index, Iterable<V> vList, {bool required = false}) {
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
  List<V> replaceF(int index, Iterable<V> f(List<V> vList),
      {bool required = false}) {
    assert(index != null && f != null);
    final e = lookup(index, required: required);
    if (e == null) return (required) ? elementNotPresentError(index) : null;
    final v = e.values;
    e.replace(f(v));
    return v;
  }

  /// Replaces all elements with [index] in _this_ and any Items
  /// descended from it, with a new element that has [vList<V>] as its
  /// values. Returns a list containing all [Element]s that were replaced.
  Iterable<Iterable<V>> replaceAll(int index, Iterable<V> vList) {
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

  Iterable<Iterable<V>> replaceAllF(
      int index, Iterable<V> f(List<V> vList)) {
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

  bool replaceValues(int index, Iterable<V> vList) {
    final e = lookup(index);
    if (e == null) return elementNotPresentError(index);
    if (!isValidValues(vList)) return false;
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

  /// Returns the original [DA] [Element] that was replaced in the
  /// Dataset with a new [Element] with a normalized [Date] based
  /// on the original [Date] and the [enrollment] [Date].
  /// If [Element] is not present, either throws or returns _null_;
  Element normalizeDate(int index, Date enrollment) {
    final DA old = lookup(index);
    if (old is DA) {
      final vList = Date.normalizeStrings(old.values, enrollment);
      old.replace(vList);
      return old;
    }
    return badElement('Not a DA (date) Element', old);
  }
}
