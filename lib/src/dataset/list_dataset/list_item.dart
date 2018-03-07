// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/list_dataset/list_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';

/// An [ListItem] implemented using a [List].
class ListItem extends Item with ListDataset {
  /// A sorted [List] of Tag Codes increasing order.
  @override
  List<int> codes;

  /// A sorted [List] of [Element]s in Tag Code order.
  @override
  List<Element> elements;

  // TODO: decide if we need these constructors
  /// Creates a [ListItem].
  ListItem(
      Dataset parent, this.codes, this.elements, SQ sequence, ByteData bd)
      : super(parent, sequence, bd);

  /// Creates an empty, i.e. without [Element]s, [ListItem].
  ListItem.empty(Dataset parent, SQ sequence)
      : codes = <int>[],
        elements = <Element>[],
        super(parent, sequence, null);

  /// Creates a [ListItem] from another [ListItem].
  ListItem.from(ListItem item, Dataset parent, SQ sequence)
      : codes = new List<int>.from(item.codes),
        elements = new List<Element>.from(item.elements),
        super(
            parent ?? item.parent, sequence ?? item.sequence, item.dsBytes.bd);

  ListItem copy([ListItem item, Dataset parent, SQ sequence]) {
    item ??= this;
    parent ??= item.parent;
    sequence ??= item.sequence;
    return new ListItem.from(item, parent, sequence);
  }
}
