// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/map_dataset/map_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/utils/bytes.dart';

/// An [MapItem] implemented using a [Map].
class MapItem extends Item with MapDataset {
  /// A [Map] from key to [Element].
  @override
  final Map<int, Element> eMap;

  // TODO: decide if we need these constructors
  /// Creates a [MapItem].
  MapItem(Dataset parent, SQ sequence, this.eMap, Bytes bd)
      : super(parent, sequence, bd);

  /// Creates an empty, i.e. without [Element]s, [MapItem].
  MapItem.empty(Dataset parent, SQ sequence)
      : eMap = <int, Element>{},
        super(parent, sequence, null);

  /// Creates a [MapItem] from another [MapItem].
  MapItem.from(MapItem item, Dataset parent, SQ sequence)
      : eMap = new Map.from(item.eMap),
        super(
            parent ?? item.parent, sequence ?? item.sequence, item.dsBytes.bytes);

  MapItem copy([MapItem item, Dataset parent, SQ sequence]) {
    item ??= this;
    parent ??= item.parent;
    sequence ??= item.sequence;
    return new MapItem.from(item, parent, sequence);
  }
}
