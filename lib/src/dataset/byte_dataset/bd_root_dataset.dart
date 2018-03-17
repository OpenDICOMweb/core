// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/byte_dataset/bd_mixin.dart';
import 'package:core/src/dataset/map_dataset/map_root_dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/utils/bytes.dart';

/// A [BDRootDataset].
class BDRootDataset extends MapRootDataset with BDMixin {

  /// Creates an empty, i.e. without ByteElements, [BDRootDataset].
  BDRootDataset(FmiMap fmi, Map<int, Element> eMap, String path,
      Bytes bd, int fmiEnd)
      : super(fmi, eMap, path, bd, fmiEnd);

  /// Creates an empty, i.e. without ByteElements, [BDRootDataset].
  BDRootDataset.empty([String path = '', Bytes bd, int fmiEnd])
      : super(new FmiMap.empty(), <int, Element>{}, path, bd, fmiEnd);

  /// Creates a [BDRootDataset] from another [BDRootDataset].
  BDRootDataset.from(BDRootDataset rds)
      : super.from(rds);

  static BDRootDataset fromBytes(FmiMap fmi,
          Map<int, Element> eMap, String path, Bytes bd, int fmiEnd) =>
      new BDRootDataset(fmi, eMap, path, bd, fmiEnd);
}
