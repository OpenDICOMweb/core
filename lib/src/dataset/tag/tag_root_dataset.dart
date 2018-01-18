// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/byte_data/bd_root_dataset.dart';
import 'package:core/src/dataset/element_list/map_as_list.dart';
import 'package:core/src/dataset/tag/tag_dataset.dart';

/// A [TagRootDataset].
class TagRootDataset extends RootDataset<int> with TagDataset {
  ByteData bd;
  @override
  RDSBytes dsBytes;
  @override
  final MapAsList fmi;
  @override
  final MapAsList elements;
  @override
  final String path;

  /// Creates an empty, i.e. without TagElements, [TagRootDataset].
  TagRootDataset({this.bd, int fmiEnd, MapAsList fmi, MapAsList elements, this.path = ''})
      : dsBytes = new RDSBytes(bd, fmiEnd),
        fmi = new MapAsList(),
        elements = new MapAsList();

  //Urgent make this work recursively
  /// Creates a [TagRootDataset] from another [TagRootDataset].
  TagRootDataset.from(RootDataset rds,
      {ByteData bd,
      int fmiEnd,
      bool recursive = false,
      bool async = true,
      bool fast = true})
      : dsBytes = new RDSBytes(bd, fmiEnd),
        fmi = new MapAsList.from(rds.fmi),
        elements = new MapAsList.from(rds.elements),
        path = rds.path;

  //Urgent make this work recursively
  /// Creates a [TagRootDataset] from another [TagRootDataset].
  TagRootDataset.fromBD(BDRootDataset rds)
/*                      {ByteData bd,
                        int fmiEnd,
                        bool recursive = false,
                        bool async = true,
                        bool fast = true})*/
      : dsBytes = new RDSBytes(rds.bd, rds.dsBytes.fmiEnd),
        fmi = new MapAsList.from(rds.fmi),
        elements = new MapAsList.from(rds.elements),
        path = rds.path;

  @override
  TagRootDataset copy([_]) => new TagRootDataset.from(this);

  /// Sets [dsBytes] to the empty list.
  @override
  RDSBytes clearDSBytes() {
    final dsb = dsBytes;
    dsBytes = RDSBytes.kEmpty;
    return dsb;
  }

  static final TagRootDataset empty = new TagRootDataset();
}
