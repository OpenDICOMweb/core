// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/map_dataset/map_root_dataset.dart';
import 'package:core/src/dataset/tag/tag_dataset.dart';
import 'package:core/src/dataset/tag/tag_item.dart';
import 'package:core/src/element.dart';
import 'package:core/src/utils/bytes.dart';

/// A [TagRootDataset].
class TagRootDataset extends MapRootDataset with TagDataset {

  /// Creates an empty, i.e. without TagElements, [TagRootDataset].
  TagRootDataset(Fmi fmi, Map<int, Element> eMap,
      [String path = '', Bytes bd, int fmiEnd])
      : super(fmi, eMap, path, bd, fmiEnd);

  /// Creates an empty [TagRootDataset], i.e. without [Element]s.
  TagRootDataset.empty([String path = '', Bytes bd, int fmiEnd = 0])
      : super.empty(path, bd ?? Bytes.kEmptyBytes, fmiEnd);

  // TODO: make this work recursively
  /// Creates a [TagRootDataset] from another [TagRootDataset].
  TagRootDataset.from(RootDataset rds) : super.from(rds);

  @override
  RootDataset copy([RootDataset rds]) => new TagRootDataset.from(rds ?? this);

  TagRootDataset convert<V>(RootDataset rds) {
    final tagRDS = new TagRootDataset.from(rds);
    for(var e in elements) {
      if (e is SQ) {
        final tagItems = <TagItem>[];
        for(var item in e.items)
          tagItems.add(TagItem.convert<V>(tagRDS, item));
      } else {
        tagRDS.add(TagElement.makeFromElement(e));
      }
    }
    return tagRDS;
  }
}
