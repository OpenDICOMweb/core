// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/errors.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/errors.dart';
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

// All operations are defined in terms of `length`, `operator[]`,
// `operator[]=` and `length=`, which need to be implemented.

/// An [MapItem] implemented using a [Map].
class MapItem extends Item {
  @override
  final Dataset parent;
  /// A [Map] from key to [Element].
  final Map<int, Element> eMap;
  @override
  SQ sequence;


  MapItem(this.parent, this.eMap, this.sequence);

  MapItem.empty(this.parent, [this.sequence]) : eMap = <int, Element>{};

  MapItem.from(MapItem item, MapItem parent)
      : parent = parent ?? item.parent,
        eMap = new Map.from(item.eMap),
        sequence = item.sequence;

  @override
  Element operator [](int i) => eMap[i];

  @override
  void operator []=(int i, Element e) => eMap[i] = e;

  @override
  int get length => eMap.length;

  @override
  set length(int _) => unsupportedError();

  @override
  Iterable<Element> get elements => eMap.values;

  @override
  bool operator ==(Object other) => other is MapItem && super == other;

/*
  // Flush when above is working
  @override
  bool operator ==(Object other) {
    if (other is MapDataset) {
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
*/

/*
  @override
  Element lookup(int index, {bool required = false}) {
    final e = eMap[index];
    return (e == null && required == true)
        // TODO: which error to throw - invalidElementIndex or
        ? elementNotPresentError(index)
        : e;
  }
*/

  // TODO: verify that this hashCode is unique
  @override
  int get hashCode => system.hasher.nList(eMap.values);

  Iterable<Element> get asList => eMap.values;

  @override
  Element elementAt(int index) => eMap.values.elementAt(index);

/*
  @override
  List<Element> get asList => values.toList();
*/

  @override
  Map<int, Element> asMap() => eMap;

  @override
  Iterable<int> get keys => eMap.keys;


  @override
  String get info {
    final sb = new StringBuffer('$this:\n');
    for (var e in eMap.values) sb.write('  $e\n');
    return sb.toString();
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
  String toString() => '$asList';

  // static const MapEquality<int, Element> _equality = const MapEquality();
}
