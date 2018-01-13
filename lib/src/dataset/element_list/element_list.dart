// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:collection';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/element_list/history.dart';
import 'package:core/src/dataset/errors.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/float.dart';
import 'package:core/src/element/base/integer.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/empty_list.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/logger/formatter.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/tag/tag_lib.dart';
import 'package:core/src/uid/uid.dart';
import 'package:core/src/vr/vr.dart';

// Design Notes:
// - All lookups are done using Tag.index;
// - There should be no references to keys;

///
abstract class ElementList<V> extends ListBase<Element> {
  /// If _true_ duplicate [Element]s are stored in the duplicate Map
  /// of the [Dataset]; otherwise, a [DuplicateElementError] is thrown.
  bool allowDuplicates = true;

  /// If _true_ [Element]s with invalid values are stored in the
  /// [Dataset]; otherwise, an [InvalidValuesError] is thrown.
  bool allowInvalidValues = true;

  /// A field that control whether new [Element]s are checked for
  /// [Issues] when they are [add]ed to the [Dataset].
  bool checkIssuesOnAdd = false;

  /// A field that control whether new [Element]s are checked for
  /// [Issues] when they are accessed from the [Dataset].
  bool checkIssuesOnAccess = false;

  /// A list of the Sequences ([SQ]) in _this_.
  List<SQ> sequences; // = <SQ>[];

  ElementList([this._dataset, List<SQ> sequences, this._history])
      : sequences = sequences ?? <SQ>[];

  /// Returns the [Element] with [index], or _null_.
  @override
  Element operator [](int index);

  /// Stores the [Element] at [index] in _this_. If [e] == _null_
  /// the [Element] at that [index] is removed.
  //
  // Design Note: [index] is ignored and [e.index] is used instead.
  @override
  void operator []=(int index, Element e);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  // Enhancement: in the future turn this into a 2 lists, one for tagCode
  // and one for values, and used binary search to lookup the tagCode.
  /// A [Map] from key to [Element].
  /// An [Iterable] of the [Element]s in _this_.
  // _Design Note_: It is expected that [elements] will have it's own
  // specialized implementation for correctness and efficiency.
  Iterable<Element> get elements;

  List<Element> get elementsList;

  Iterable<int> get keys;

  List<int> get keysList;

  /// Removes [Element]s from _this_.
  @override
  void clear();

  ///
  // ignore: unnecessary_getters_setters
  Dataset get dataset => _dataset;
  Dataset _dataset;
  // ignore: unnecessary_getters_setters
  set dataset(Dataset ds) => _dataset ??= ds;

  /// Lazy access to modified elements
  History get history => _history ??= new History();
  History _history;
  set history(History m) => _history ??= new History();

  bool recordNotFound = false;

  Iterable<int> get indices => elements.map((e) => (e is Element) ? e.index : null);

  /// An [List] of the duplicate [Element]s in _this_.
  List<Element> get duplicates => history.duplicates;
  List<Element> get added => history.added;
  List<Element> get removed => history.removed;
  List<Element> get updated => history.updated;
  List<int> get requiredNotPresent => history.requiredNotPresent;
  List<int> get notPresent => history.requiredNotPresent;

  int get total => counter((e) => true);
  int get nSequences => counter((e) => (e is SQ));
  int get nPrivate => counter((e) => Tag.isPrivateCode(e.code));
  int get nPrivateSequences => counter((e) => Tag.isPrivateCode(e.code) && e is SQ);

  //TODO: Uncomment when counter has fold interface
 // int get nItems => counter(itemCount);
  int get dupTotal {
    var count = history.duplicates.length;
    for (var sq in sequences)
      for (var item in sq.items) count += item.elements.history.duplicates.length;
    return count;
  }

  //Enhancement? make private for performance
  //Urgent Jim: make conform to Fold interface
  /// Walk the [Dataset] recursively and return the count of [Element]s
  /// for which [test] is true.
  /// Note: It ignores duplicates.
  int counter(ElementTest test) {
    var count = 0;
    for (var e in elements)
      if (e is SQ) {
        count += e.counter(test);
      } else {
        if (test(e)) count++;
      }
    return count;
  }

  int itemCount(Element e) => (e is SQ) ? e.values.length : 0;


  // **** Other Getters and Methods

  /// Returns a formatted [String]. See [Formatter].
  String format(Formatter z) => z.fmt(this, elements);

  String get summary => '$runtimeType (#$hashCode)\n$subSummary';

  String get subSummary {
    final sb = new StringBuffer('''
ElementList Summary
        Total Elements: $total
    Top Level Elements: $length
             Sequences: $nSequences
         Private Total: $nPrivate
''');
    if (nPrivateSequences != 0) sb.writeln('     Private Sequences: $nPrivateSequences');
    if (dupTotal != 0) sb.writeln('      Total Duplicates: $dupTotal');
    if (duplicates.isNotEmpty) sb.writeln('  Top Level Duplicates: ${duplicates.length}');
    return sb.toString();
  }

  @override
  int indexOf(Object e, [int _]) => (e is Element) ? e.code : -1;

  @override
  void forEach(void f(Element e)) {
    for (var e in elements)
      if (e is SQ) {
        for (var item in e.items) item.forEach(f);
      } else {
        f(e);
      }
  }

  @override
  T fold<T>(T initialValue, T combine(T previous, Element e)) {
    var v = initialValue;
    for (var e in elements)
      if (e is SQ) {
        v = e.fold<T>(v, (v, item) => item.fold(v, combine));
      } else {
        combine(v, e);
      }
    return v;
  }

  void forEachSequence(void f(Element e)) => sequences.forEach(f);

  void forAll(int index, void f(Element e)) {
    final e = this[index];
    e ?? f(e);
    for (var sq in sequences)
      for (var item in sq.items) {
        final e = item[index];
        e ?? f(e);
      }
  }

  // **** ElementList Getters and Methods

  Element lookup(int index, {bool required = false}) {
    assert(index != null);
    final e = this[index];
    return (e == null && required) ? elementNotPresentError(index) : e;
  }

  /// Returns a list of all elements in any [Dataset] contained in _this_.
  /// The list might be empty, will not be null.
  Iterable<Element> lookupAll(int index) {
    final results = <Element>[];
    final e = this[index];
    e ?? results.add(e);
    for (var sq in sequences)
      for (var item in sq.items) results.addAll(item.lookupAll(index));
    return results;
  }

  /// Trys to add an [Element] to a [Dataset].
  ///
  /// If the new [Element] is not valid and [allowInvalidValues] is _false_,
  /// an [invalidValuesError] is thrown; otherwise, the [Element] is added
  /// to both the [_issues] [Map] and to the [Dataset]. The [_issues] [Map]
  /// can be used later to return an [Issues] for the [Element].
  ///
  /// If an [Element] with the same [Tag] is already contained in the
  /// [Dataset] and [allowDuplicates] is _false_, a [DuplicateElementError] is
  /// thrown; otherwise, the [Element] is added to both the [duplicates] [Map]
  /// and to the [Dataset].
  bool tryAdd(Element e, [Issues issues]) {
    final old = lookup(e.code);
    if (old == null) {
      if (checkIssuesOnAdd && (issues != null)) if (!allowInvalidValues && !e.isValid)
        invalidElementError(e);
      this[e.code] = e;
      if (e is SQ) sequences.add(e);
      return true;
    } else if (allowDuplicates) {
      system.warn('** Duplicate Element:\n\tnew: $e\n\told: $old');
      if (old.vrIndex != kUNIndex) {
        history.duplicates.add(e);
      } else {
        this[e.index] = e;
        history.duplicates.add(old);
      }
      return false;
    } else {
      return duplicateElementError(old, e);
    }
  }

  @override
  void add(Element e, [Issues issues]) {
    tryAdd(e, issues);
  }

  static const List emptyList = const <dynamic>[];

  @override
  void addAll(Iterable<Element> eList) => eList.forEach(add);

  /// Returns new [Element] with the same [index] and [Type],
  /// but with [Element.values] containing [List<V>].
  /// Note: This method does NOT modify the [Dataset],
  /// it returns a new (modified) element.
  ///
  /// If updating the [Element] fails, the current element is left in
  /// place and _null_ is returned.
  Element update(int index, {Iterable<V> vList, bool required = false}) {
    final old = lookup(index);
    if (old == null) return null;
    this[index] =
        old.update((vList == null) ? const <V>[] : vList.toList(growable: false));
    return old;
  }

  /// Returns a new [Element] with the same [index] and [Type],
  /// but with [Element.values] containing [f]([List<V>]).
  ///
  /// If updating the [Element] fails, the current element is left in
  /// place and _null_ is returned.
  Element updateF(int index, Iterable<V> f(Iterable<V> vList), {bool required = false}) {
    final old = lookup(index);
    if (old == null) return null;
    this[index] = old.update(f(old.values) ?? const <V>[]);
    return old;
  }

  /// Updates all [Element.values] with [index] in _this_ or in any
  /// Sequences (SQ) contained in _this_ with [vList]. Returns a [List<Element>]
  /// of the original [Element]s that were updated.
  List<Element> updateAll(int index, {Iterable<V> vList, bool required = false}) {
    vList ??= const <V>[];
    final v = update(index, vList: vList, required: required);
    final result = <Element>[]..add(v);
    for (var e in elements)
      if (e is SQ) {
        result.addAll(e.updateAll<V>(index, vList, required: required));
      } else {
        result.add(e.replace(e.values));
      }
    return result;
  }

  /// Updates all [Element.values] with [index] in _this_ or in any
  /// Sequences (SQ) contained in _this_ with an empty list.
  /// Returns a List<Element>] of the original [Element.values] that
  /// were updated.
  List<Element> updateAllF(int index, Iterable<V> f(Iterable<V> vList),
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

  Element updateUid(int index, Iterable<Uid> uids, {bool required = false}) {
    assert(index != null && uids != null);
    final old = this[index];
    if (old == null) return (required) ? elementNotPresentError(index) : null;
    if (old is! UI) return invalidUidElement(old);
    add(old.update(uids.toList(growable: false)));
    return old;
  }

  /// Replace the [List<UUIDs in a [UI].  If [uids] is _null_, then
  /// a list of [Uid.randomList] is created. It is an error if [Element]
  /// corresponding to [index] does not have a VR of UI.
  UI updateUidStrings(int index, Iterable<String> uids,
                           {bool required = false}) {
    //Note: This assumes [uids] are valid
    assert(index != null && uids != null);
    final old = this[index];
    if (old == null) return (required) ? elementNotPresentError(index) : null;
    if (old is! UI) return invalidUidElement(old);
    final e = old.update(uids ?? kEmptyStringList);
    add(e);
    return old;
  }

  /// Replace the UIDs in an [Element].  If [uids] is _null_, then
  /// a list of [Uid.randomList] is created. It is an error if [Element]
  /// corresponding to [index] does not have a VR of UI.
  Element updateUidList(int index, List<String> uids,
      {bool recursive = true, bool required = false}) {
    assert(index != null);
    final e = this[index];

    final uids = getUidList(index, required: required);
    if (uids == null) return (required) ? elementNotPresentError(index) : null;
    // If [e] has noValues, and [uids] == null, just return [e],
    // because there is no discernible difference.
    if (e.values.isEmpty && (uids == null || uids.isEmpty)) return e;
    assert(e.values is List<String>);
    final vList = (uids == null) ? Uid.randomList(e.values.length) : uids;
    return e.update(vList);
  }

  List<Element> updateAllUids(int index, Iterable<Uid> uids) {
    final v = updateUid(index, uids);
    final result = <Element>[]..add(v);
    for (var e in elements)
      if (e is SQ) {
        result.addAll(e.updateAllUids<V>(index, uids));
      } else {
        result.add(e.replace(e.values));
      }
    return result;
  }

  /// Replaces the element with [index] with a new element that is
  /// the same except it has no values.  Returns the original element.
  Element noValues(int index, {bool required = false}) {
    final e = this[index];
    if (e == null) return (required) ? elementNotPresentError(index) : null;
    this[index] = e.noValues;
    return e;
  }

  /// Updates all [Element.values] with [index] in _this_ or in any
  /// Sequences (SQ) contained in _this_ with an empty list.
  /// Returns a List<Element>] of the original [Element.values] that
  /// were updated.
  List<Element> noValuesAll(int index) {
    assert(index != null);
    final result = <Element>[]..add(noValues(index));
    for (var e in elements)
      if (e is SQ) {
        result.addAll(e.noValuesAll(index));
      } else {
        result.add(e.replace(e.values));
      }
    return result;
  }

  /// Replaces the [Element.values] at [index] with [f(vList)].
  /// Returns the original [Element.values], or _null_ if no
  /// [Element] with [index] was not present.
  List<V> replace(int index, Iterable<V> vList, {bool required = false}) {
    assert(index != null && vList != null);
    final e = this[index];
    if (e == null) return (required) ? elementNotPresentError(index) : null;
    final v = e.values;
    e.replace(vList);
    return v;
  }

  List<V> replaceF(int index, Iterable<V> f(Iterable<V> vList), {bool required = false}) {
    assert(index != null && f != null);
    final e = this[index];
    if (e == null) return (required) ? elementNotPresentError(index) : null;
    final v = e.values;
    e.replace(f(v));
    return v;
  }


  List<List<V>> replaceAll(int index, Iterable<V> vList) {
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


  List<List<V>> replaceAllF(int index, Iterable<V> f(Iterable<V> vList)) {
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

  Element replaceUid(int index, Iterable<Uid> uids, {bool required = false}) {
    final old = lookup(index);
    if (old == null) return null;
    if (old is! UI) return invalidUidElement(old);
    old.replace(uids.toList(growable: false));
    return old;
  }

  List<Element> replaceAllUids(int index, Iterable<Uid> uids) {
    final v = updateUid(index, uids);
    final result = <Element>[]..add(v);
    for (var e in elements)
      if (e is SQ) {
        result.addAll(e.updateAllUids<V>(index, uids));
      } else {
        result.add(e.replace(e.values));
      }
    return result;
  }

  // Urgent Sharath: unit test
  /// Removes the [Element] with index from _this_.
  // Design Note: Can't use remove
  @override
  Element removeAt(int index, {bool required = false}) {
    final e = this[index];
    this[index] == null;
    return (e == null && required) ? elementNotPresentError(index) : e;
  }

  // Urgent Sharath: unit test
  /// Removes the [Element] with [index] from _this_.
  Element delete(int index, {bool required = false}) {
    assert(index != null, 'Invalid index: $index');
    final e = removeAt(index);
    if (e == null) return (required) ? elementNotPresentError<int>(index) : e;
    return e;
  }

  List<Element> deleteAll(int index, {bool recursive = false}) {
    assert(index != null, 'Invalid index: $index');
    final results = <Element>[];
    final e = delete(index);
    if (e != null) results.add(e);
    assert(this[index] == null);
    // If index is not a Sequence walk all Sequences recursively and remove index.
    if (recursive)
      for (var sq in sequences)
        for (var item in sq.items) results.add(item.delete(index));
    return results;
  }

  /// Returns a copy of _this_. If [parent] is _null_ the
  /// [parent] of the copy is _this_ [parent].
  // Urgent Jim: Why don't the subclasses work with this interface?
  ElementList copy([Dataset parent]);

  /* Flush if not used
  Element noValuesCode(int index, [bool required = true]) {
    assert(index != null);
    Element e = elements[index];
    if (_isNotPresentElement(index, e, required)) return null;
    elements[index] = e.noValues;
    return e;
  }
*/

  /// Remove all duplicates from the [Dataset].
  void removeDuplicates() => duplicates.clear();

  /*
  bool _isNotPresentKey(int index, bool required) {
    assert(index != null);
    if (elements[index] == null) {
      if (required) elementNotPresentError(index);
      return true;
    }
    return false;
  }

  bool isNotPresentTag(Tag tag, bool required) =>
      _isNotPresentKey(tag.code as K, required);

  bool _isNotPresentElement(Element e, bool required) =>
      _isNotPresentKey(e.index, required);
*/

  Element getElement(int index) => unsupportedError();

  /// Returns a [Map] of the Elements that satisfy [min] <= e.code <= [max].
  List<Element> getElementsInRange(int min, int max) {
    final fmi = <Element>[];
    for (var e in elements) if (e.code >= min && e.code < max) fmi.add(e);
    return fmi;
  }

  //Enhancement: test
  bool hasElementsInRange(int min, int max) {
    for (var e in elements) if (e.code >= min && e.code <= max) return true;
    return false;
  }

  // **** Values Getters and Methods

  V _checkOneValue<V>(int index, List<V> values) => (values == null || values.length != 1)
      ? invalidValuesLengthError(Tag.lookupByCode(index), values)
      : values.first;

  /// Returns the [int] value for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  V getValue(int index, {bool required = false}) {
    final e = this[index];
    return _checkOneValue(index, e.values);
  }

  List<V> getValues(int index, {bool required = false}) {
    final e = this[index];
    if (e == null) return (required) ? elementNotPresentError(index) : null;
    final List<V> values = e.values;
    assert(values != null);
    return (allowInvalidValues) ? e.values : e.isValid;
  }

  // **** Integers

  /// Returns the [int] value for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  int getInt(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! IntBase) return nonIntegerTag(index);
    return _checkOneValue<int>(index, e.values);
  }

  /// Returns the [List<int>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<int> getIntList(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! IntBase) return nonIntegerTag(index);
    if (!allowInvalidValues && !e.hasValidValues) return invalidElementError(e);
    final vList = e.values;
    if (vList == null) return nullValueError('getIntList');
    return vList;
  }

  // **** Floating Point

  /// Returns a [double] value for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  double getFloat(int index, {bool required = false}) {
    final FloatBase e = this[index];
    return _checkOneValue<double>(index, e.values);
  }

  /// Returns the [List<double>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<double> getFloatList(int index, {bool required = false}) {
    final FloatBase e = this[index];
    if (e == null || e is! FloatBase) return invalidFloatElement(e);
    final vList = e.values;
    if (vList == null) return nullValueError('getFloatList');
    return vList;
  }

  // **** String

  /// Returns a [double] value for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  String getString(int index, {bool required = false}) {
    final StringBase e = this[index];
    return (e == null || e.isEmpty) ? '' : _checkOneValue<String>(index, e.values);
  }

  /// Returns the [List<double>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<String> getStringList(int index, {bool required = false}) {
    final StringBase e = this[index];
    if (e == null || e is! StringBase) return nonStringTag(index);
    final vList = e.values;
    if (vList == null) return nullValueError('getStringList');
    return vList;
  }

  // **** Item

  /// Returns an [Item] value for the [SQ] [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  Item getItem(int index, {bool required = false}) {
    final SQ e = this[index];
    return _checkOneValue<Item>(index, e.values);
  }

  /// Returns the [List<double>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<Item> getItemList(int index, {bool required = false}) {
    final SQ e = this[index];
    if (e == null || e is! Item) return nonSequenceTag(index);
    final vList = e.values;
    if (vList == null) return nullValueError('getItemList');
    return vList;
  }

  // **** Uid

  /// Returns a [Uid] value for the [UI] [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  Uid getUid(int index, {bool required = false}) {
    final UI e = lookup(index, required: required);
    return (e == null) ? null : _checkOneValue<Uid>(index, e.uids);
  }

  /// Returns the [List<double>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<Uid> getUidList(int index, {bool required = false}) {
    final UI e = this[index];
    if (e == null || e is! UI) return nonUidTag(index);
    final vList = e.uids;
    if (vList == null) return nullValueError('getUidList');
    return vList;
  }

  String get info {
    final dups = (dupTotal <= 0) ? '' : 'Top Level Duplicates: $dupTotal\n';
    return '''
  	  	ElementList: 
  	  	Total: $total 
  	  	Top Level: $length
  	  	$dups
  	''';
  }

  @override
  String toString() => '$runtimeType: $length Elements';
}
