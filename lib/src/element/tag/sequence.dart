//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/dataset/base.dart';
import 'package:core/src/dataset/tag.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/error.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/logger.dart';
import 'package:core/src/vr.dart';

/// A Sequence ([SQ]) Element.
///
/// A Sequence contains a [List] of [TagItem]s, where each
/// [TagItem] is a TagDataset.
class SQtag extends SQ with TagElement<Item> {
  @override
  final Tag tag;
  List<Item> _values;

  /// The [Dataset] that contains _this_.
  @override
  final Dataset parent;

  final Bytes bytes;

  /// Creates a new [SQtag] instance.
  factory SQtag(Dataset parent, Tag tag, [Iterable<Item> vList]) =>
      new SQtag._(parent, tag, vList);

  /// Creates a new [SQtag] instance.
  SQtag._(this.parent, this.tag, [Iterable<Item> vList, this.bytes])
      : _values = (vList == null)
            ? emptyTagItemList
            : (vList is List) ? vList : vList.toList(growable: false);

  /// The [Iterable<ItemTag>] that are the [values] of _this_.
  @override
  List<Item> get values => _values;
  @override
  set values(Iterable<Item> vList) =>
      _values = (vList is List) ? vList : vList.toList(growable: false);

  @override
  Bytes get vfBytes => unimplementedError('vfBytes in SQtag');

  @override
  SQtag get noValues => update(emptyTagItemList);

  @override
  SQtag get sha256 => throw new UnsupportedError('Can\t hash a sequence');

  @override
  String get info => '$tag: Items:${values.length}, total Elements: $total';

  /// Returns a copy of _this_ Sequence, with a new [List] of [Item]s.
  @override
  SQtag update([Iterable<Item> vList = emptyTagItemList]) =>
      new SQtag(parent, tag, vList);

  /// Returns a copy of _this_ Sequence, with a new [List] of Tag[Item]s.
  SQtag updateSQtag(Iterable<TagItem> items, Dataset parent) =>
      new SQtag(parent, tag, items);

  Uint8List getValuesToBytes({bool addHeader, bool isAscii = true}) {
    throw new UnimplementedError('toDcm');
  }

  Uint8List getBytesToValues({bool addHeader, bool isAscii = true}) {
    throw new UnimplementedError('toDcm');
  }

  SQtag copySQ([Dataset parent]) => convert(parent ?? this.parent, this);

  @override
  String format(Formatter z) => z.fmt(this, items);

  @override
  String toString() => '$runtimeType $dcm ${tag.keyword} ${items.length} items';

  static const Iterable<Item> emptyTagItemList = const <TagItem>[];

  static SQtag fromValues(Tag tag, Iterable<Item> values,
          [int vfLength, Dataset parent]) =>
      new SQtag(parent, tag, values);

  static SQtag from(Dataset parent, SQ sq) {
    final nItems = new List<TagItem>(sq.values.length);
    for (var i = 0; i < sq.values.length; i++) {
      final item = sq.values[i];
      nItems[i] = TagItem.convert(parent, item, sq);
    }
    return new SQtag(parent, sq.tag, nItems);
  }

  static SQtag fromBytes(
      Dataset parent, List<TagItem> vList, Tag tag) {
    if (tag.vrIndex != kSQIndex) return null;
    return new SQtag(parent, tag, vList);
  }

  static const _makeSQ = TagElement.makeSequenceFromCode;

  static SQtag convert(Dataset parent, SQ e) {
    final items = e.values.toList();
    final length = items.length;
    final tagItems = new List<TagItem>(e.items.length);

    final sq = _makeSQ(parent, e.code, tagItems);
    for (var i = 0; i < length; i++) {
      final tItem = TagItem.convert(parent, items[i], sq);
      tagItems[i] = tItem;
    }
    sq.values = tagItems;
    return sq;
  }
}
