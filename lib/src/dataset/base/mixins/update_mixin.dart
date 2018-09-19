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
import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

abstract class UpdateMixin {
  /// An [Iterable<Element>] of the [Element]s contained in _this_.
  ///
  // Design Note: It is expected that [ElementList] will have
  // it's own specialized implementation for correctness and efficiency.
  List<Element> get elements;

  /// Store [Element] [e] at [index] in _this_.
  void store(int index, Element e);

  void add(Element e, [Issues issues]);

  /// Returns the Element with [index], if present; otherwise, returns _null_.
  ///
  /// _Note_: All lookups should be done using this method.
  ///
  // Design Note: This method should record the index of any Elements
  // not found if [recordNotFound] is _true_.
  // TODO: turn required into an EType test
  Element lookup(int index, {bool required = false});

  // **** End Interface

  /// Replaces the element with [index] with a new element with the same Tag,
  /// but with [vList] as its _values_. Returns the original element.
  Element<V> update<V>(int index, Iterable<V> vList, {bool required = false}) {
    final old = lookup(index, required: required);
    if (old != null) store(index, old.update(vList));
    return old;
  }

  /// Returns a new [Element] with the same [index] and [Type],
  /// but with [Element.values] containing [f]([List<V>]).
  ///
  /// If updating the [Element] fails, the current element is left in
  /// place and _null_ is returned.
  Element<V> updateF<V>(int index, List<V> f(List vList),
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
    vList ??= const [];
    final v = update(index, vList, required: required);
    final result = <Element>[]..add(v);
    for (var e in elements)
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
  List<Element> updateAllF<V>(int index, List<V> f(List vList),
                              {bool required = false}) {
    final v = updateF(index, f, required: required);
    final result = <Element>[]..add(v);
    for (var e in elements)
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

}