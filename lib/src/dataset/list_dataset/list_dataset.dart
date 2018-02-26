// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:collection/collection.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/errors.dart';

// Urgent Sharath:
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
  List<int> get codeList;

  /// A sorted [List] of [Element]s in Tag Code order.
  List<Element> get elementList;

  Element operator [](int code) {
    final index = codeList.indexOf(code);
    return elementList[index];
  }

  void operator []=(int code, Element e) {
    assert(code == e.code);
    codeList[code] = e.code;
    elementList[code] = e;
  }
  // void operator []=(int i, Element e) => tryAdd(e);

  // *** Primitive only for internal use Stores e in eMap
  void store(int index, Element e) {
    assert(index == e.code);
    elementList[e.code] = e;
  }

  @override
  bool operator ==(Object other) =>
      (other is ListDataset && listsEqual(elementList, other.elementList));

  @override
  int get hashCode => mapHash(elementList);

  int get length => elementList.length;

  set length(int _) => unsupportedError();

  int indexOf(Element e) => codeList.indexOf(e.code);
  Iterable<int> get keys => codeList;
  Iterable<int> get codes => keys;

  Iterable<Element> get elements => elementList;

  Element elementAt(int index) => elementList.elementAt(index);

  Map<int, Element> asMap() => elementList.asMap();

  bool remove(Object e) {
    if (e is Element) return codeList.remove(e.code) && elementList.remove(e);
    return false;
  }

  /// Removes the [Element] with key from _this_.
  Element removeAt(int code, {bool required = false}) {
    final index = codeList.indexOf(code);
    return elementList.removeAt(index);
  }

  List<Element> toList({bool growable: true}) =>
      elements.toList(growable: false);

  @override
  String toString() => '$runtimeType: ${elementList.length} elements';
}
