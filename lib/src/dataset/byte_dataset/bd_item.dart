//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/dataset/base.dart';
import 'package:core/src/dataset/byte_dataset/bd_mixin.dart';
import 'package:core/src/dataset/map_dataset/map_item.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/utils/bytes.dart';

/// An [BDItem] is a DICOM [Dataset], which is contained in an SQ Element.
class BDItem extends MapItem with BDMixin {
  @override
  List<PrivateGroup> privateGroups = <PrivateGroup>[];

  /// Creates a new empty [BDItem] from [Bytes].
  BDItem(Dataset parent, 
      [SQ sequence, Map<int, Element> eMap, Bytes bd])
      : super(parent, sequence, eMap ?? <int, Element>{}, bd);

  /// Creates a new empty [BDItem] from [Bytes].
  BDItem.empty(Dataset parent, [SQ sequence, Bytes bd])
      : super(parent, sequence, <int, Element>{}, bd);

  /// Create a new [BDItem] from an existing [BDItem].
  /// If [parent] is _null_the new [BDItem] has the same
  /// parent as [item].
  BDItem.from(BDItem item, MapItem parent, [SQ sequence])
      : super.from(item, parent ?? item.parent, sequence ?? item.sequence);

  /// Creates a new [BDItem] from [Bytes].
  BDItem.fromBD(Dataset parent, [SQ sequence, Map<int, Element> eMap, Bytes bd])
      : super(parent, sequence, eMap,  bd);
}
