//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:collection/collection.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/global.dart';
import 'package:core/src/error/general_errors.dart';

// ignore_for_file: public_member_api_docs

//  create MapItem and MapRootDataset
//  create some Elements
//  insert and remove and compare for identity (identical(a, b)
//
//  create a second MapItem and MapRootDataset
//  insert same elements in both list
//  compare for equality and hashCode
//  compare list.keys and list.elements for equality
//
//  confirm that removeAt and copy work.
ListEquality<Element> listEquality = const ListEquality<Element>();

bool listsEqual(List<Element> map0, List<Element> map1) =>
    listEquality.equals(map0, map1);

int mapHash(List<Element> list) => listEquality.hash(list);

mixin ListDataset {
  /// A sorted [List] of Tag Codes increasing order.
  List<int> get codes;

  /// A sorted [List] of [Element]s in Tag Code order.
  List<Element> get elements;

  int get total;

  /// Returns the [Element] with [code].
  Element operator [](int code) {
    final index = codes.indexOf(code);
    return (index < 0) ? null : elements[index];
  }

  void operator []=(int code, Element e) {
    assert(code == e.code);
    final index = codes.indexOf(code);
    if (index >= 0) {
      elements[index] = e;
    } else {
      codes.add(code);
      elements.add(e);
    }
  }

  // TODO(Jim): should this be checking that parents are equal? It doesn't
  /// Returns true if [other] has the same [Element]s as _this_.
  @override
  bool operator ==(Object other) {
    if (other is ListDataset && total == other.total) {
      for (var e in elements) {
        if (e != other[e.code]) return false;
      }
      return true;
    }
    return false;
  }

  // Implement Equality
  @override
  int get hashCode => global.hasher.nList(elements);

  int get length => elements.length;

  set length(int _) => unsupportedError();

  int indexOf(Object e, [int start = 0]) =>
      e is Element ? codes.indexOf(e.code, start) : null;

  Iterable<int> get keys => codes;

  // *** Primitive only for internal use Stores e in eMap
  void store(int index, Element e) {
    final code = e.code;
    assert(index == code);
    final i = codes.indexOf(code);
    if (i >= 0) {
      elements[i] = e;
    } else {
      codes.add(code);
      elements.add(e);
    }
  }

  Element elementAt(int index) => elements.elementAt(index);

  Map<int, Element> asMap() => elements.asMap();

  bool remove(Object e) {
    if (e is Element) return codes.remove(e.code) && elements.remove(e);
    return false;
  }

  /// Removes the [Element] with [code] from _this_.
  Element removeAt(int code, {bool required = false}) {
    final index = codes.indexOf(code);
    if (index < 0) return null;
    codes.removeAt(index);
    return elements.removeAt(index);
  }

  /// Removes the [Element] with [code] from _this_.
  Element deleteCode(int code) => removeAt(code);

  /// Returns the [Element]s in _this_ as a [List<Element>]
  List<Element> toList({bool growable = true}) =>
      (elements is List) ? elements : elements.toList(growable: false);
}
