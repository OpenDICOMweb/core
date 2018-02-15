// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/byte_data/bd_dataset_mixin.dart';
import 'package:core/src/dataset/element_list/map_as_list.dart';
import 'package:core/src/entity/patient/patient.dart';

/// A [BDRootDataset].
class BDRootDataset extends RootDataset with DatasetBD {
  final ByteData bd;
  @override
  RDSBytes dsBytes;
  @override
  final MapAsList fmi;
  @override
  final MapAsList elements;
  @override
  String path;

  /// Creates an empty, i.e. without ByteElements, [BDRootDataset].
  BDRootDataset(this.bd,
      {int fmiEnd, MapAsList fmi, MapAsList elements, this.path = ''})
      : dsBytes = new RDSBytes(bd, fmiEnd),
        fmi = (fmi == null) ? new MapAsList() : fmi,
        elements = (elements == null) ? new MapAsList() : elements {
//    print('BDRoot: $this');
  }

  //Flush at V0.9.0 if not used.
  /// Creates a [BDRootDataset] from another [BDRootDataset].
  BDRootDataset.from(BDRootDataset rds)
      : bd = rds.bd,
        dsBytes = rds.dsBytes,
        fmi = rds.fmi ?? new MapAsList(),
        elements = new MapAsList();

  @override
  int get vfLength => dsBytes.dsEnd;

  @override
  BDRootDataset copy([_]) => new BDRootDataset.from(this);

  @override
  Patient get patient => new Patient.fromRDS(this);

  /// Sets [dsBytes] to the empty list.
  @override
  RDSBytes clearDSBytes() {
    final dsb = dsBytes;
    dsBytes = RDSBytes.kEmpty;
    return dsb;
  }

  static BDRootDataset fromBytes(ByteData bd, MapAsList elements) =>
      new BDRootDataset(bd, elements: elements);
}
