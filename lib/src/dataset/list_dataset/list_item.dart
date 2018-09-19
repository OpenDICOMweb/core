//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/list_dataset/list_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/utils/bytes.dart';

// ignore_for_file: public_member_api_docs

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
      Dataset parent, this.codes, this.elements, SQ sequence, Bytes bd)
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
            parent ?? item.parent, sequence ?? item.sequence, item.dsBytes.bytes);

  ListItem copy([ListItem item, Dataset parent, SQ sequence]) {
    item ??= this;
    parent ??= item.parent;
    sequence ??= item.sequence;
    return new ListItem.from(item, parent, sequence);
  }
}
