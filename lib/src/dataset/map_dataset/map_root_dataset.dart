//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/map_dataset/map_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/utils/bytes.dart';

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
      : fmi = new FmiMap.empty(),
        eMap = <int, Element>{},
        super(path, bd, fmiEnd);

  /// Creates a [MapRootDataset] from another [MapRootDataset].
  MapRootDataset.from(MapRootDataset rds)
      : fmi = new FmiMap.from(rds.fmi),
        eMap = new Map.from(rds.eMap),
        super(rds.path, rds.dsBytes.bytes, rds.dsBytes.fmiEnd);

//  @override
//  Fmi get fmi => fmiMap;

  RootDataset copy([RootDataset rds]) => new MapRootDataset.from(rds ?? this);
}

class FmiMap extends Fmi with MapDataset {
  /// A [Map] from key to [Element].
  @override
  final Map<int, Element> eMap;

  FmiMap(this.eMap);

  FmiMap.empty() : eMap = <int, Element>{};

  FmiMap.from(FmiMap fmi) : eMap = new Map.from(fmi.eMap);

  @override
  Element operator[](int code) => eMap[code];
  @override
  void operator[]=(int code, Element e) => eMap[code] = e;
  @override
  int get length => eMap.length;
  @override
  set length(int n) {}

  @override
  String toString() => '$runtimeType: $length elements';
}
