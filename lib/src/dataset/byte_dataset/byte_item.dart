//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/dataset/base.dart';
import 'package:core/src/dataset/byte_dataset/byte_dataset.dart';
import 'package:core/src/dataset/map_dataset/map_item.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/utils/bytes.dart';

/// An [ByteItem] is a DICOM [Dataset], which is contained in an SQ Element.
class ByteItem extends MapItem with ByteDataset {
  @override
  List<PrivateGroup> privateGroups = <PrivateGroup>[];

  /// Creates a new empty [ByteItem] from [Bytes].
  ByteItem(Dataset parent, [SQ sequence, Map<int, Element> eMap, Bytes bd])
      : super(parent, sequence, eMap ?? <int, Element>{}, bd);

  /// Creates a new empty [ByteItem] from [Bytes].
  ByteItem.empty(Dataset parent, [SQ sequence, Bytes bd])
      : super(parent, sequence, <int, Element>{}, bd);

  /// Create a new [ByteItem] from an existing [ByteItem].
  /// If [parent] is _null_the new [ByteItem] has the same
  /// parent as [item].
  ByteItem.from(ByteItem item, MapItem parent, [SQ sequence])
      : super.from(item, parent ?? item.parent, sequence ?? item.sequence);

  /// Creates a new [ByteItem] from [Bytes].
  ByteItem.fromBD(Dataset parent,
      [SQ sequence, Map<int, Element> eMap, Bytes bd])
      : super(parent, sequence, eMap, bd);
}
