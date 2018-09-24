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

MapEquality<int, Element> mapEquality = const MapEquality<int, Element>();

bool mapsEqual(Map<int, Element> map0, Map<int, Element> map1) =>
    mapEquality.equals(map0, map1);

int mapHash(Map<int, Element> map) => mapEquality.hash(map);

abstract class MapDataset {
  /// A [Map] from key to [Element].
  Map<int, Element> get eMap;

  /// Returns the [Element] with [code].
  Element operator [](int code) => eMap[code];

  // *** Primitive only for internal use Stores e in eMap
  void store(int index, Element e) {
    final code = e.code;
    assert(index == code);

    eMap[e.code] = e;
  }

  @override
  bool operator ==(Object other) =>
      other is MapDataset && mapsEqual(eMap, other.eMap);

  @override
  int get hashCode => mapHash(eMap);

  int get length => eMap.length;

  set length(int _) => unsupportedError();

  Iterable<int> get keys => eMap.keys;
  Iterable<int> get codes => keys;

  Iterable<Element> get elements => eMap.values;

  // TODO(high): determine how expensive this is?
  Element elementAt(int index) => eMap.values.elementAt(index);

  Map<int, Element> asMap() => eMap;

  /// Removes the [Element] [e] from _this_.
  bool remove(Object e) =>
      ((e is Element) && e == eMap.remove(e.code)) || false;

  /// Removes the [Element] with [code] from _this_.
  Element deleteCode(int code) => eMap.remove(code);

  /// Removes the [Element] with key from _this_.
  Element removeAt(int index, {bool required = false}) => eMap.remove(index);

  /// Returns the [Element]s in _this_ as a [List<Element>]
  List<Element> toList({bool growable = false}) =>
      elements.toList(growable: false);

  @override
  String toString() => '$runtimeType: ${eMap.length} elements';
}
