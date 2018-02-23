// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/map_dataset/map_dataset.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/tag/errors.dart';
import 'package:core/src/uid/export.dart';

/// A [MapRootDataset].
class MapRootDataset extends RootDataset with MapDataset {
  final FmiMap fmiMap;

  /// A [Map] from key to [Element].
  @override
  final Map<int, Element> eMap;

  /// Creates an [MapRootDataset].
  MapRootDataset(this.fmiMap, this.eMap, String path, ByteData bd, int fmiEnd)
      : super(path, bd, fmiEnd);

  /// Creates an empty, i.e. without [Element]s, [MapRootDataset].
  MapRootDataset.empty(String path, ByteData bd, int fmiEnd)
      : fmiMap = new FmiMap.empty(),
        eMap = <int, Element>{},
        super(path, bd, fmiEnd);

  /// Creates a [MapRootDataset] from another [MapRootDataset].
  MapRootDataset.from(MapRootDataset rds)
      : fmiMap = new FmiMap.from(rds.fmiMap),
        eMap = new Map.from(rds.eMap),
        super(rds.path, rds.dsBytes.bd, rds.dsBytes.fmiEnd);

  @override
  Fmi get fmi => fmiMap;

  RootDataset copy([RootDataset rds]) => new MapRootDataset.from(rds ?? this);
}

class FmiMap extends Fmi {
  final Map <int, Element> fmiMap;

  FmiMap(this.fmiMap);

  FmiMap.empty() : fmiMap = <int, Element>{};

  FmiMap.from(FmiMap fmi) : fmiMap = new Map.from(fmi.fmiMap);

  @override
  Element operator [](int code) => fmiMap[code];

  @override
  void operator []=(int code, Element e) => fmiMap[code] = e;

  @override
  int get length => fmiMap.length;

  @override
  set length(int _) => unsupportedError();

  @override
  Uid uidLookup(int code) {
    final e = fmiMap[code];
    if (e == null) return null;
    return (e is UI) ? e.uids.elementAt(0) : nonUidTag(code);
  }


}
