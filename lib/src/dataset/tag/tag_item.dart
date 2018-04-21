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
import 'package:core/src/dataset/base/group/private_group.dart';
import 'package:core/src/dataset/map_dataset/map_item.dart';
import 'package:core/src/dataset/tag/tag_dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/utils.dart';

/// An [TagItem] is an [Item] contained in an SQtag Element.
class TagItem extends MapItem with TagDataset {
  @override
  final PrivateGroups pGroups;

  /// Creates a new [TagItem] from [Bytes].
  TagItem(Dataset parent, [SQ sequence, Map<int, Element> eMap, Bytes bd])
      : pGroups = new PrivateGroups(),
        super(parent, sequence, eMap, bd) {
    pGroups.ds = this;
  }

  /// Creates a new empty [Item] from [Bytes].
  TagItem.empty(Dataset parent, [SQ sequence, Bytes bd])
      : pGroups = new PrivateGroups(),
        super(parent, sequence, <int, Element>{}, bd) {
    pGroups.ds = this;
  }

  static const _makeE = TagElement.makeFromElement;
  /// Create a new [TagItem] from an existing [TagItem].
  /// If [parent] is _null_the new [TagItem] has the same
  /// parent as [item].
  TagItem.from(Dataset parent, Item item, [SQtag sequence])
      : pGroups = new PrivateGroups(),
        super(parent, sequence, <int, Element>{}, null) {
    pGroups.ds = this;
    for (var e in item.elements) {
      final te = (e is SQ) ? SQtag.convert(e) : _makeE(e);
      add(te);
    }
  }


/*
      : // TODO: add check for if empty
        pGroups = new PrivateGroups(),
        super.from(item, parent ?? item.parent, sequence ?? item.sequence) {
    pGroups.ds = this;
  }
*/

  factory TagItem.fromList(Dataset parent, Iterable<Element> elements,
      [SQtag sequence]) {
    final eMap = <int, Element>{};
    for (var e in elements) eMap[e.index] = e;
    //TODO: handle PrivateGroups
    return new TagItem(parent, sequence, eMap);
  }

  @override
  bool tryAdd(Element e, [Issues issues]) {
    var eNew = e;
    // [e] MUST be added to the pGroups before it is added to the Dataset.
    if (e.isPrivate) eNew = pGroups.add(e);
    return super.tryAdd(eNew, issues);
  }

  @override
  bool get isImmutable => false;

  void addPrivate(Element e) => pGroups.add(e);

  static TagItem convert(Dataset parent, Item item, SQ sequence) {
    const makeE = TagElement.makeFromElement;

    final Dataset tagItem = new TagItem(parent, sequence);
    for (var e in item.elements) {
      final te = (e is SQ) ? SQtag.convert(e) : makeE(e);
      tagItem.add(te);
    }
    return tagItem;
  }
}
