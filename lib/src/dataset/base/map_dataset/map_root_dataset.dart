// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/map_dataset/map_dataset.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/element/base/element.dart';

/// A [MapRootDataset].
class MapRootDataset extends RootDataset with MapDataset {
  @override
  final Map<int, Element> fmi;

  /// A [Map] from key to [Element].
  @override
  final Map<int, Element> eMap;

  /// Creates an [MapRootDataset].
  MapRootDataset(this.fmi, this.eMap, String path, ByteData bd, int fmiEnd)
      : super(path, bd, fmiEnd);

  /// Creates an empty, i.e. without [Element]s, [MapRootDataset].
  MapRootDataset.empty(String path, ByteData bd, int fmiEnd)
      : fmi = <int, Element>{},
        eMap = <int, Element>{},
        super(path, bd, fmiEnd);

  /// Creates a [MapRootDataset] from another [MapRootDataset].
  MapRootDataset.from(MapRootDataset rds)
      : fmi = new Map.from(rds.fmi),
        eMap = new Map.from(rds.eMap),
        super(rds.path, rds.dsBytes.bd, rds.dsBytes.fmiEnd);

  RootDataset copy([RootDataset rds]) => new MapRootDataset.from(rds ?? this);
}
