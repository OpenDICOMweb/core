// Copyright (c) 2016, 2017, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/byte_data/bd_item.dart';
import 'package:core/src/dataset/element_list/map_as_list.dart';
import 'package:core/src/dataset/tag/tag_dataset.dart';

/// An [TagItem] is an [Item] contained in an SQtag Element.
class TagItem extends Item with TagDataset {
  @override
  IDSBytes dsBytes;
  @override
  final Dataset parent;
  @override
  final MapAsList elements;

  /// Creates a new [TagItem] from [ByteData].
  TagItem(this.parent, [ByteData bd])
      : dsBytes = new IDSBytes(bd),
        elements = new MapAsList();

  /// Creates a new [TagItem] from an existing [TagItem].
  /// If [parent] is _null_ the new [TagItem] has the same
  /// parent as [item].
  TagItem.from(TagItem item, Dataset parent)
      : parent = (parent == null) ? item.parent : parent,
        elements = new MapAsList.from(item.elements, parent),
        dsBytes = item.dsBytes;

  /// Creates a new [TagItem] from an existing [TagItem].
  /// If [parent] is _null_ the new [TagItem] has the same
  /// parent as [item].
  TagItem.fromBD(BDItem item, Dataset parent)
      : parent = (parent == null) ? item.parent : parent,
        elements = new MapAsList.from(item.elements, parent),
        dsBytes = item.dsBytes;

  /// Creates a new [TagItem] from an [MapAsList].
  TagItem.fromList(this.parent, this.elements, [ByteData bd])
      : dsBytes = new IDSBytes(bd);

  @override
  bool get isImmutable => false;

  @override
  TagItem copy([Dataset parent]) =>
      new TagItem.from(this, (parent == null) ? this.parent : parent);
}
