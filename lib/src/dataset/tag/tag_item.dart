// Copyright (c) 2016, 2017, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/base/map_dataset/map_item.dart';
import 'package:core/src/dataset/byte_data/bd_item.dart';
import 'package:core/src/dataset/tag/tag_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/element/tag/sequence.dart';

/// An [TagItem] is an [Item] contained in an SQtag Element.
class TagItem extends MapItem with TagDataset {
  // @override
//  List<PrivateGroup> privateGroups = <PrivateGroup>[];

  /// Creates a new [TagItem] from [ByteData].
  TagItem(Dataset parent, Map<int, Element> eMap, [SQ sequence, ByteData bd])
      : super(parent, eMap, sequence, bd);

  /// Creates a new empty [BDItem] from [ByteData].
  TagItem.empty(Dataset parent, [SQ sequence, ByteData bd])
      : super(parent, <int, Element>{}, sequence, bd);

  /// Create a new [BDItem] from an existing [BDItem].
  /// If [parent] is _null_the new [BDItem] has the same
  /// parent as [item].
  TagItem.from(Item item, Dataset parent, [SQtag sequence])
      : super.from(item, parent ?? item.parent, sequence ?? item.sequence);

  // TODO: needed?
  factory TagItem.fromList(Dataset parent, Iterable<Element> elements,
      [SQtag sequence]) {
    final eMap = <int, Element>{};
    for (var e in elements) eMap[e.index] = e;
    return new TagItem(parent, eMap, sequence);
  }

/*  /// Creates a new [TagItem] from an existing [TagItem].
  /// If [parent] is _null_ the new [TagItem] has the same
  /// parent as [item].
  TagItem.fromBD(BDItem item, Dataset parent, [SQtag sequence])
      : super.from(item, parent ?? item.parent, sequence ?? item.sequence);
  */
  @override
  bool get isImmutable => false;
}
