//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:bytes/bytes.dart';
import 'package:core/src/error.dart';
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/base/group/private_group.dart';
import 'package:core/src/dataset/map_dataset/map_item.dart';
import 'package:core/src/dataset/tag/tag_dataset.dart';
import 'package:core/src/element.dart';


// ignore_for_file: public_member_api_docs

/// An [TagItem] is an [Item] contained in an SQtag Element.
class TagItem extends MapItem with TagDataset {
  @override
  final PrivateGroups pGroups;

  /// Creates a new [TagItem] from [Bytes].
  TagItem(Dataset parent, [SQ sequence, Map<int, Element> eMap, Bytes bd])
      : pGroups = PrivateGroups(),
        super(parent, sequence, eMap, bd) {
    pGroups.ds = this;
  }

  /// Creates a new empty [Item] from [Bytes].
  TagItem.empty(Dataset parent, [SQ sequence])
      : pGroups = PrivateGroups(),
        super.empty(parent, sequence) {
    pGroups.ds = this;
  }

  /// Create a new [TagItem] from an existing [TagItem].
  /// If [parent] is _null_the new [TagItem] has the same
  /// parent as [item].
  TagItem.from(Dataset parent, Item item, SQtag sequence)
      : pGroups = PrivateGroups(),
        super(parent, sequence, <int, Element>{}, null) {
    pGroups.ds = this;
    convert(parent, item, sequence);
  }

  // TODO: this is only used by test - create a local version in test.
  factory TagItem.fromList(Dataset parent, Iterable<Element> elements,
      [SQtag sequence]) {
    final eMap = <int, Element>{};
    for (final e in elements) eMap[e.index] = e;
    //TODO: handle PrivateGroups
    return TagItem(parent, sequence, eMap);
  }

  @override
  bool tryAdd(Element e, [Issues issues]) {
    var eNew = e;
    // [e] MUST be added to the pGroups before it is added to the Dataset.
    if (e.isPrivate) eNew = pGroups.add(e, this);
    return super.tryAdd(eNew, issues);
  }

  @override
  bool get isImmutable => false;

  static Dataset convert(Dataset parent, Item item, SQ sequence) {
    final Dataset tagItem = TagItem.empty(parent, sequence);
    return TagDataset.convert(item, tagItem);
  }
}
