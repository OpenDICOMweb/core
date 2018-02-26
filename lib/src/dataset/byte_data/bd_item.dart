// Copyright (c) 2016, 2017 Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/private_group.dart';
import 'package:core/src/dataset/byte_data/bd_dataset_mixin.dart';
import 'package:core/src/dataset/map_dataset/map_item.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';

/// An [BDItem] is a DICOM [Dataset], which is contained in an SQ Element.
class BDItem extends MapItem with DatasetBD {
  @override
  List<PrivateGroup> privateGroups = <PrivateGroup>[];

  /// Creates a new empty [BDItem] from [ByteData].
  BDItem(Dataset parent, Map<int, Element> eMap, [SQ sequence, ByteData bd])
      : super(parent, eMap, sequence, bd);

  /// Creates a new empty [BDItem] from [ByteData].
  BDItem.empty(Dataset parent,  [SQ sequence, ByteData bd])
      : super(parent, <int, Element>{}, sequence, bd);

  /// Create a new [BDItem] from an existing [BDItem].
  /// If [parent] is _null_the new [BDItem] has the same
  /// parent as [item].
  BDItem.from(BDItem item, MapItem parent, [SQ sequence])
      : super.from(item, parent ?? item.parent,
                       sequence ?? item.sequence);

  /// Creates a new [BDItem] from [ByteData].
  BDItem.fromBD(Dataset parent, Map<int, Element> eMap,
      [SQ sequence, ByteData bd])
      : super(parent, eMap, sequence, bd);
}
