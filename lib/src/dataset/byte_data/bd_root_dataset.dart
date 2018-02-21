// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/dataset/base/map_dataset/map_root_dataset.dart';
import 'package:core/src/dataset/byte_data/bd_dataset_mixin.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/empty_list.dart';
import 'package:core/src/entity/patient/patient.dart';

/// A [BDRootDataset].
class BDRootDataset extends MapRootDataset with DatasetBD {
  final ByteData bd;
  RDSBytes dsBytes;

  /// Creates an empty, i.e. without ByteElements, [BDRootDataset].
  BDRootDataset(this.bd,
      int fmiEnd,
      Map<int, Element> fmi,
      Map<int, Element> eMap,
      String path)
      : dsBytes = new RDSBytes(bd, fmiEnd),
        super(fmi, eMap, path) {
//    print('BDRoot: $this');
  }

  /// Creates an empty, i.e. without ByteElements, [BDRootDataset].
  BDRootDataset.empty(this.bd, [String path = '', int fmiEnd])
      : dsBytes = new RDSBytes(bd, fmiEnd),
        super(<int, Element>{}, <int, Element>{}, path) {
//    print('BDRoot: $this');
  }

  /// Creates a [BDRootDataset] from another [BDRootDataset].
  BDRootDataset.from(BDRootDataset rds)
      : bd = rds.bd,
        dsBytes = rds.dsBytes,
        super.from(rds);

  int get eLength => (dsBytes == null) ? -1 : dsBytes.eLength;

  /// The actual length of the Value Field for _this_
  int get vfLength => dsBytes.dsEnd;
 // int get vfLength => (dsBytes != null) ? dsBytes.eLength : null;

  bool get hasULength => dsBytes.hasULength;

  /// The value of the Value Field Length field for _this_.
  int get vfLengthField => (dsBytes != null) ? dsBytes.eLength : null;

  ByteData get preamble =>
      (dsBytes != null) ? dsBytes.preamble : kEmptyByteData;
  ByteData get prefix => (dsBytes != null) ? dsBytes.prefix : kEmptyByteData;

/*
  /// Returns the encoded [ByteData] for the File Meta Information (FMI) for
  /// _this_. [fmiBytes] has _one-time_ setter that is initialized lazily.
  Uint8List get fmiBytes => dsBytes.fmiBytes;
*/


  @override
  Patient get patient => new Patient.fromRDS(this);

  /// Sets [dsBytes] to the empty list.
  RDSBytes clearDSBytes() {
    final dsb = dsBytes;
    dsBytes = RDSBytes.kEmpty;
    return dsb;
  }

  static BDRootDataset fromBytes(ByteData bd,
                                 int fmiEnd,
                                 Map<int, Element> fmi,
                                 Map<int, Element> eMap,
                                 String path) =>
      new BDRootDataset(bd, fmiEnd, fmi, eMap, path);
}
