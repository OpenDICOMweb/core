//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:bytes/bytes.dart';
import 'package:core/src/dataset/base.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/map_dataset/map_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/error.dart';

// ignore_for_file: public_member_api_docs

/// A [MapRootDataset].
class MapRootDataset extends RootDataset with MapDataset {
  @override
  final FmiMap fmi;

  /// A [Map] from key to [Element].
  @override
  final Map<int, Element> eMap;

  /// Creates an [MapRootDataset].
  MapRootDataset(this.fmi, this.eMap, String path, Bytes bd, int fmiEnd)
      : super(path, bd, fmiEnd);

  /// Creates an empty, i.e. without [Element]s, [MapRootDataset].
  MapRootDataset.empty(String path, Bytes bd, int fmiEnd)
      : fmi = FmiMap.empty(),
        eMap = <int, Element>{},
        super(path, bd, fmiEnd);

  /// Creates a [MapRootDataset] from another [MapRootDataset].
  MapRootDataset.from(MapRootDataset rds)
      : fmi = FmiMap.from(rds.fmi),
        eMap = Map.from(rds.eMap),
        super(rds.path, rds.dsBytes.bytes, rds.dsBytes.fmiEnd);

  /// Returns a copy of _this_.
  RootDataset copy([RootDataset rds]) => MapRootDataset.from(rds ?? this);
}

class FmiMap extends Fmi {
  /// A [Map] from key to [Element].
  final Map<int, Element> eMap;

  FmiMap(this.eMap);

  FmiMap.empty() : eMap = <int, Element>{};

  FmiMap.from(FmiMap fmi) : eMap = Map.from(fmi.eMap);

  @override
  Element operator [](int code) => eMap[code];

  @override
  void operator []=(int code, Element e) {
    assert(code == e.code);
    tryAdd(e);
  }

  @override
  Iterable<Element> get elements => eMap.values;

  @override
  void add(Element element) => tryAdd(element);

  bool tryAdd(Element e) {
    final old = eMap[e.code];
    if (old == null) {
      eMap[e.code] = e;
      return true;
    } else {
      final result = eMap.putIfAbsent(e.code, () => e);
      if (result != e) {
        duplicateElementError(result, e);
        return false;
      }
      return true;
    }
  }

  @override
  int get length => eMap.length;

  @override
  set length(int n) => unsupportedSetter();

  @override
  String toString() => '$runtimeType: $length elements';
}
