// Copyright (c) 2016, 2017 Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/byte_data/bd_dataset_mixin.dart';
import 'package:core/src/dataset/element_list/map_as_list.dart';
import 'package:core/src/dataset/private_group.dart';

/// An [BDItem] is a DICOM [Dataset], which is contained in an SQ Element.
class BDItem extends Item<int>  with DatasetBD {
  @override
  IDSBytes dsBytes;
  @override
  final Dataset<int> parent;
  @override
  final MapAsList elements;

  @override
  final List<PrivateGroup> privateGroups = <PrivateGroup>[];

  /// Creates a new empty [BDItem] from [ByteData].
  BDItem(this.parent, [ByteData bd])
      : dsBytes = new IDSBytes(bd),
        elements = new MapAsList();

  /// Create a new [BDItem] from an existing [BDItem].
  /// If [parent] is _null_the new [BDItem] has the same
  /// parent as [item].
  BDItem.from(BDItem item, Dataset parent)
      : parent = (parent == null) ? item.parent : parent,
        elements = new MapAsList.from(item.elements),
        dsBytes = item.dsBytes;

  /// Creates a new [BDItem] from [ByteData].
  BDItem.fromList(this.parent, this.elements, [ByteData bd])
      : dsBytes = new IDSBytes(bd);

  @override
  BDItem copy([Dataset<int> parent]) =>
      new BDItem.from(this, (parent == null) ? this.parent : parent);
}
