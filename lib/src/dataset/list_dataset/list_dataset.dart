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

abstract class ListDataset {
  /// A sorted [List] of Tag Codes increasing order.
  List<int> get codes;

  /// A sorted [List] of [Element]s in Tag Code order.
  List<Element> get elements;

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

  @override
  bool operator ==(Object other) =>
      other is ListDataset && listsEqual(elements, other.elements);

  @override
  int get hashCode => mapHash(elements);

  int get length => elements.length;

  set length(int _) => unsupportedError();

  int indexOf(Element e, [int start = 0]) => codes.indexOf(e.code, start);

  Iterable<int> get keys => codes;

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
      elements.toList(growable: false);

  @override
  String toString() => '$runtimeType: ${elements.length} elements';
}
