// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/map_dataset/map_root_dataset.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/tag/tag_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/empty_list.dart';

/// A [TagRootDataset].
class TagRootDataset extends MapRootDataset with TagDataset {
  /// Creates an empty, i.e. without TagElements, [TagRootDataset].
  TagRootDataset(FmiMap fmi, Map<int, Element> eMap,
      [String path = '', ByteData bd, int fmiEnd])
      : super(fmi, eMap, path, bd, fmiEnd);

  /// Creates an empty [TagRootDataset], i.e. without [Element]s.
  TagRootDataset.empty([String path = '', ByteData bd, int fmiEnd = 0])
      : super.empty(path, bd ?? kEmptyByteData, fmiEnd);

  // TODO: make this work recursively
  /// Creates a [TagRootDataset] from another [TagRootDataset].
  TagRootDataset.from(MapRootDataset rds) : super.from(rds);

  @override
  RootDataset copy([RootDataset rds]) => new TagRootDataset.from(rds ?? this);
}
