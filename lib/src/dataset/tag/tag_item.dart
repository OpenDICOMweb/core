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
import 'package:core/src/dataset/map_dataset/map_item.dart';
import 'package:core/src/dataset/tag/tag_dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/vr.dart';

/// An [TagItem] is an [Item] contained in an SQtag Element.
class TagItem extends MapItem with TagDataset {
  // @override
//  List<PrivateGroup> privateGroups = <PrivateGroup>[];

  /// Creates a new [TagItem] from [Bytes].
  TagItem(Dataset parent, [SQ sequence, Map<int, Element> eMap, Bytes bd])
      : super(parent, sequence, eMap, bd);

  /// Creates a new empty [Item] from [Bytes].
  TagItem.empty(Dataset parent, [SQ sequence, Bytes bd])
      : super(parent, sequence, <int, Element>{}, bd);

  /// Create a new [TagItem] from an existing [TagItem].
  /// If [parent] is _null_the new [TagItem] has the same
  /// parent as [item].
  TagItem.from(Item item, Dataset parent, [SQtag sequence])
      : super.from(item, parent ?? item.parent, sequence ?? item.sequence);

  factory TagItem.fromList(Dataset parent, Iterable<Element> elements,
      [SQtag sequence]) {
    final eMap = <int, Element>{};
    for (var e in elements) eMap[e.index] = e;
    return new TagItem(parent, sequence, eMap);
  }

  @override
  bool get isImmutable => false;

  static TagItem convert<V>(Dataset parent, Item item) {
    final Dataset tagItem = new TagItem(parent);
    for (var e in item.elements) {
      if (e is SQ) {
        final tagItems = <TagItem>[];
        for (var item in e.items) tagItems.add(convert<V>(tagItem, item));
        TagElement.makeSequenceFromTag(
            e.tag, tagItem, tagItems, e.vfLengthField);
      } else {
        tagItem.add(TagElement.makeFromElement(e, kSQIndex));
      }
    }
    return tagItem;
  }
}
