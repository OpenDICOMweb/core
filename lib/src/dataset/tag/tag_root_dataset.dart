// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/map_dataset/map_root_dataset.dart';
import 'package:core/src/dataset/byte_data/bd_root_dataset.dart';
import 'package:core/src/dataset/tag/tag_dataset.dart';
import 'package:core/src/element/base/element.dart';

/// A [TagRootDataset].
class TagRootDataset extends MapRootDataset with TagDataset {

  /// Creates an empty, i.e. without TagElements, [TagRootDataset].
  TagRootDataset(Map<int, Element> fmi, Map<int, Element> eMap,
                 [String path = ''])
      :  super(fmi, eMap, path);

  /// Creates an empty [TagRootDataset], i.e. without [Element]s.
  TagRootDataset.empty([String path = ''])
      : super.empty(path) {
//    print('BDRoot: $this');
  }
  // TODO: make this work recursively
  /// Creates a [TagRootDataset] from another [TagRootDataset].
  TagRootDataset.from(MapRootDataset rds)
      : super(new Map.from(rds.fmi), new Map.from(rds.eMap), rds.path);

  // TODO: make this work recursively
  /// Creates a [TagRootDataset] from another [TagRootDataset].
  TagRootDataset.fromBD(BDRootDataset rds)
      : super(new Map.from(rds.fmi), new Map.from(rds.eMap), rds.path);

  TagRootDataset copy([TagRootDataset rds]) =>
      new TagRootDataset.from(rds ?? this);
}
