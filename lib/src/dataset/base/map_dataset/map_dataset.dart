// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:collection/collection.dart';
import 'package:core/src/dataset/base/history.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/issues.dart';

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
MapEquality<int, Element> mapEquality = const MapEquality<int, Element>();

bool mapsEqual(Map<int, Element> map0, Map<int, Element> map1) =>
    mapEquality.equals(map0, map1);

int mapHash(Map<int, Element> map) => mapEquality.hash(map);

abstract class MapDataset {
  /// A [Map] from key to [Element].
  Map<int, Element> get eMap;
  bool get allowDuplicates;
  bool tryAdd(Element e, [Issues issues]);
  History get history;


  Element operator [](int i) => eMap[i];

  void operator []=(int i, Element e) => tryAdd(e);
/*
  void operator []=(int i, Element e) {
    print('   e: $e');
    final oldE = eMap.putIfAbsent(i, () => e);
    print('oldE: $oldE');
    if (oldE == e) {
      store(e.index, e);
    } else if (allowDuplicates) {
      system.warn('** Duplicate Element:\n\tnew: $e\n\told: $oldE');
      if (oldE.vrIndex != kUNIndex) {
        history.duplicates.add(e);
      } else {
        store(e.index, e);
        history.duplicates.add(oldE);
      }
    } else {
      duplicateElementError(oldE, e);
    }
  }
*/

  // *** Primitive only for internal use Stores e in eMap
  void store(int index, Element e) {
    assert(index == e.code);
    eMap[e.code] = e;
  }

  @override
  bool operator ==(Object other) =>
      (other is MapDataset && mapsEqual(eMap, other.eMap));

  @override
  int get hashCode => mapHash(eMap);

  int get length => eMap.length;

  set length(int _) => unsupportedError();

  Iterable<int> get keys => eMap.keys;
  Iterable<int> get codes => keys;

  Iterable<Element> get elements => eMap.values;

  Element elementAt(int index) => eMap.values.elementAt(index);

  Map<int, Element> asMap() => eMap;

  bool remove(Object e) => (e is Element) ? e == eMap.remove(e.code) : false;

  /// Removes the [Element] with key from _this_.
  Element removeAt(int index, {bool required = false}) => eMap.remove(index);

  List<Element> toList({bool growable: true}) =>
      elements.toList(growable: false);

  @override
  String toString() => '$runtimeType: ${eMap.length} elements';
}
