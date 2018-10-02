//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/byte_dataset/byte_dataset.dart';
import 'package:core/src/dataset/map_dataset/map_root_dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/utils/bytes.dart';

// ignore_for_file: public_member_api_docs

/// A [ByteRootDataset].
class ByteRootDataset extends MapRootDataset with ByteDataset {
  /// Creates an empty, i.e. without ByteElements, [ByteRootDataset].
  ByteRootDataset(
      FmiMap fmi, Map<int, Element> eMap, String path, Bytes bd, int fmiEnd)
      : super(fmi, eMap, path, bd, fmiEnd);

  /// Creates an empty, i.e. without ByteElements, [ByteRootDataset].
  ByteRootDataset.empty([String path = '', Bytes bd, int fmiEnd])
      : super(FmiMap.empty(), <int, Element>{}, path, bd, fmiEnd);

  factory ByteRootDataset.fromBytes(FmiMap fmi, Map<int, Element> eMap,
          String path, Bytes bd, int fmiEnd) =>
      ByteRootDataset(fmi, eMap, path, bd, fmiEnd);

  /// Creates a [ByteRootDataset] from another [ByteRootDataset].
  ByteRootDataset.from(ByteRootDataset rds) : super.from(rds);
}
