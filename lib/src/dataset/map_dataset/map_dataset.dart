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
  int get total;

  /// Returns the [Element] with [code].
  Element operator [](int code) => eMap[code];

  // TODO(Jim): should this be checking that parents are equal? It doesn't
  /// Returns true if [other] has the same [Element]s as _this_.
  @override
  bool operator ==(Object other) {
    if (other is MapDataset && total == other.total) {
      for (var e in elements) {
        if (e != other.eMap[e.code]) return false;
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode => mapHash(eMap);

  int get length => eMap.length;

  set length(int _) => unsupportedError();

  Iterable<int> get keys => eMap.keys;
  Iterable<int> get codes => keys;

  List<Element> get elements => eMap.values.toList(growable: false);

  // *** Primitive only for internal use Stores e in eMap
  void store(int code, Element e) {
    final other = e.code;
    assert(other == code);
    eMap[e.code] = e;
  }

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
}
