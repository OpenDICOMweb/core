// Copyright (c) 2016, 2017 Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/map_dataset/map_item.dart';
import 'package:core/src/dataset/base/private_group.dart';
import 'package:core/src/dataset/byte_data/bd_dataset_mixin.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';

/// An [BDItem] is a DICOM [Dataset], which is contained in an SQ Element.
class BDItem extends MapItem with DatasetBD {

  @override
  List<PrivateGroup> privateGroups = <PrivateGroup>[];

  /// Creates a new empty [BDItem] from [ByteData].
  BDItem(Dataset parent, {Map<int, Element> eMap, SQ sequence, ByteData bd})
      :
        super(parent, eMap, sequence, bd);

  /// Creates a new empty [BDItem] from [ByteData].
  BDItem.empty(Dataset parent,  [SQ sequence, ByteData bd])
      :
        super(parent, <int, Element>{}, sequence, bd);

  /// Create a new [BDItem] from an existing [BDItem].
  /// If [parent] is _null_the new [BDItem] has the same
  /// parent as [item].
  BDItem.from(BDItem item, MapItem parent, [SQ sequence])
      : super.from(item, parent ?? item.parent,
                       sequence ?? item.sequence);

/*
  /// Creates a new [BDItem] from [ByteData].
  BDItem.fromBD(ByteData bd, MapItem parent, Map<int, Element> eMap,
      [SQ sequence])
      :
        super(parent, eMap, sequence);
*/
/*
  /// The length of the Value Field of the encoded object (e.g. ByteData,
  /// JSON [String]...) that _this_was created from, or
  /// _null_ if _this_was not created by parsing an encoded object.
  int get vfLengthField => dsBytes.vfLengthField;

  /// The actual length of the Value Field for _this_
  int get vfLength => (dsBytes != null) ? dsBytes.eLength - 8 : null;

  /// _true_if _this_was created from an encoded object (e.g. [ByteData],
  /// JSON [String]...) and the Value Field length was [kUndefinedLength].
  // Design Note:
  //   Only Item and its subclasses can have undefined length.
  //   RootDatasets cannot.
  bool get hasULength => vfLengthField == kUndefinedLength;
 */
}
