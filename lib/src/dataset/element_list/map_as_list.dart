// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/element_list/element_list.dart';
import 'package:core/src/dataset/element_list/history.dart';
import 'package:core/src/dataset/errors.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/system/system.dart';

//  create MapAsList
//  create some Elements
//  insert and remove and compare for identity (identical(a, b)
//
//  create a second ElementList
//  insert same elements in both list
//  compare for equality and hashCode
//  compare list.keys and list.elements for equality
//
//  confirm that removeAt and copy work.

/// The default initial size of an Element [List].
// TODO: update this number so that it handles 80% of Datasets without need to grow
const int defaultSize = 200;

/// An [ElementList] implemented using a [Map].
class MapAsList extends ElementList {
  /// A [Map] from key to [Element].
  final Map<int, Element> eMap;
  @override
  final List<SQ> sequences;
  Dataset _dataset;
  History _history;

  /// If _true_ duplicate [Element]s are stored in the duplicate Map
  /// of the [Dataset]; otherwise, a [DuplicateElementError] is thrown.
  @override
  bool allowDuplicates = true;

  /// If _true_ [Element]s with invalid values are stored in the
  /// [Dataset]; otherwise, an [elementNotPresentError] is thrown.
  @override
  bool allowInvalidValues = true;

  /// A field that control whether new [Element]s are checked for
  /// Issues when they are [add]ed to the [Dataset].
  @override
  bool checkIssuesOnAdd = false;

  /// A field that control whether new [Element]s are checked for
  /// Issues when they are accessed from the [Dataset].
  @override
  bool checkIssuesOnAccess = false;

  MapAsList([this._dataset, List<SQ> sequences, this._history])
      : sequences = (sequences == null) ? <SQ>[] : sequences,
        eMap = <int, Element>{};

  MapAsList.from(MapAsList map, [Dataset dataset])
      : eMap = new Map.from(map.eMap),
        sequences = new List.from(map.sequences),
        _dataset = dataset ?? map._dataset,
        _history = new History.from(map.history);

/* TODO: change to this version of ==
  @override
  bool operator ==(Object other) =>
		  (other is MapAsList) ? _equality.equals(eMap, other.eMap) : false;
*/
  // Flush when above is working
  @override
  bool operator ==(Object other) {
    if (other is MapAsList) {
      final length = eMap.length;
      if (length != other.eMap.length) return false;
      final keysA = eMap.keys.iterator;
      final keysB = other.eMap.keys.iterator;

      for (var i = 0; i < length; i++) {
        keysA.moveNext();
        keysB.moveNext();
        if (keysA.current != keysB.current) return false;
      }

      final valuesA = eMap.values.iterator;
      final valuesB = other.eMap.values.iterator;
      for (var i = 0; i < length; i++) {
        valuesA.moveNext();
        valuesB.moveNext();
        if (valuesA.current != valuesB.current) return false;
      }
      return true;
    }
    return false;
  }

  @override
  Element operator [](int index) => lookup(index);

  @override
  // ignore: unnecessary_getters_setters
  Dataset get dataset => _dataset;
  // ignore: unnecessary_getters_setters
  set dataset(Dataset ds) => _dataset ??= ds;

  /// Lazy access to modified elements
  @override
  History get history => _history ??= new History();
  set history(History m) => _history ??= new History();

  @override
  Element lookup(int index, {bool required = false}) {
    final e = eMap[index];
    return (e == null && required == true)
        // TODO: which error to throw - invalidElementIndex or
        ? elementNotPresentError(index)
        : e;
  }

  @override
  void operator []=(int index, Element e) => eMap[e.index] = e;

  // TODO: verify that this hashCode is unique
  @override
  int get hashCode => system.hasher.nList(eMap.values);

  @override
  Iterable<Element> get values => eMap.values;

  @override
  Element elementAt(int index) => eMap.values.elementAt(index);

  @override
  List<Element> get asList => values.toList();

  @override
  Map<int, Element> asMap() => eMap;

  @override
  Iterable<int> get keys => eMap.keys;

  @override
  List<int> get keysList => keys.toList();

  @override
  int get length => eMap.length;

  @override
  set length(int length) {}

  @override
  String get info {
    final sb = new StringBuffer('$this:\n');
    for (var e in eMap.values) sb.write('  $e\n');
    return sb.toString();
  }

  @override
  void replace(int index, Element e) => eMap[index] = e;

  @override
  bool replaceValues<V>(int index, Iterable<V> vList) {
    final e = eMap[index];
    if (e == null) return elementNotPresentError(index);
    if (!e.tag.isValidValues(vList)) return false;
    e.replace(vList);
    return true;
  }

  /// Removes the [Element] with [index] from _this_.
  @override
  Element delete(int index, {bool required = false}) {
    assert(index != null, 'Invalid index: $index');
    final e = lookup(index, required: required);
    if (e == null)
      return (required) ? elementNotPresentError<int>(index) : null;
    if (e is SQ) sequences.remove(e);
    return eMap.remove(index);
  }

  @override
  List<Element> deleteAll(int index, {bool recursive = false}) {
    assert(index != null, 'Invalid index: $index');
    final results = <Element>[];
    final e = delete(index);
    if (e != null) results.add(e);
    assert(this[index] == null);
    // If index is not a Sequence walk all
    // Sequences recursively, and remove index.
    if (recursive)
      for (var sq in sequences)
        for (var item in sq.items) {
          final deleted = item.delete(index);
          if (deleted != null) print('item $item deleted: $deleted');
          if (deleted != null) results.add(deleted);
        }
    return results;
  }

/*
  @override
  Iterable<Element> deleteAllPrivate({bool recursive = false}) {
    // deleteIfTrue((e) => e.isPrivate, recursive: recursive);
    final deleted = <Element>[];

    for (var e in eMap.values) {
      if (e.group.isOdd) print('Odd: $e');
      if (e.isPrivate) {
        final v = delete(e.code);
        if (v != null) deleted.add(e);
        if (v != null) print('DPrivate: $v');
      }

    }
    if (deleted != null) print('DeletedPrivate: (${deleted.length})$deleted');
*/
/*
    for (var e in elements) {
      if (e.isPrivate) {
        deleted.add(delete(e.code));
      }
      print('DeletedPrivate: (${deleted.length})$deleted');
    }
*/ /*


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
    print('DeletedPrivate: (${deleted.length})$deleted');
    deleted.addAll(deletedInSQ);
    return deleted;
  }
*/

  @override
  bool remove(Object o) {
    if (o is Element) {
      final e = delete(o.index);
      return e != null;
    }
    return false;
  }

  /// Removes the [Element] with key from _this_.
  @override
  Element removeAt(int index, {bool required = false}) => eMap.remove(index);

  @override
  MapAsList copy([Dataset dataset]) => new MapAsList.from(this, dataset);

  @override
  String toString() => '$asList';

  // static const MapEquality<int, Element> _equality = const MapEquality();
}
