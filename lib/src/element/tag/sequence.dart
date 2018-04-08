// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/errors.dart';
import 'package:core/src/utils/logger.dart';
import 'package:core/src/vr.dart';

/// A Sequence ([SQ]) Element.
///
/// A Sequence contains a [List] of [TagItem]s, where each
/// [TagItem] is a TagDataset.
class SQtag extends SQ<TagItem> with TagElement<TagItem> {
  @override
  final Tag tag;

  /// The [Dataset] that contains _this_.
  @override
  final Dataset parent;

  /// The [Iterable<ItemTag>] that are the [values] of _this_.
  @override
  Iterable<Item> values;

  /// The length of the Value Field from which this [SQtag] was decoded.
  /// If _null_ _this_ what not created from an encoding.
  @override
  final int vfLengthField;

  final Bytes bytes;

  /// Creates a new [SQtag] instance.
  SQtag(this.tag, this.parent,
      [Iterable<Item> vList, this.vfLengthField, this.bytes])
      : values = (vList == null) ? emptyTagItemList : vList;

  SQtag.fromDecoder(this.tag, this.parent,
      [this.values, this.vfLengthField, this.bytes]);

  @override
  Iterable<Item> get items => values;
  @override
  Bytes get vfBytes => unimplementedError('vfBytes in SQtag');
  
  @override
  SQtag get noValues => update(emptyTagItemList);

  @override
  SQtag get sha256 => throw new UnsupportedError('Can\t hash a sequence');

//  @override
  SQtag copySQ([Dataset parent]) {
    final nItems = new List<TagItem>(length);
    for (var i = 0; i < items.length; i++)
      nItems[i] = new TagItem.from(items.elementAt(i), parent);
    return update(nItems);
  }

  @override
  String get info => '$tag: Items:${values.length}, total Elements: $total';

  /// Returns a copy of _this_ Sequence, with a new [List] of [Item]s.
  @override
  SQtag update([Iterable<Item> vList = emptyTagItemList]) =>
      new SQtag(tag, parent, vList);

  /// Returns a copy of _this_ Sequence, with a new [List] of Tag[Item]s.
  SQtag updateSQtag(Iterable<TagItem> items, Dataset parent) =>
      new SQtag(tag, parent, items, null);

  Uint8List getValuesToBytes({bool addHeader, bool isAscii = true}) {
    throw new UnimplementedError('toDcm');
  }

  Uint8List getBytesToValues({bool addHeader, bool isAscii = true}) {
    throw new UnimplementedError('toDcm');
  }

/* Flush at V0.9.0
  /// Returns the [Element] with [key] in the [index]th Item.
  Element getElement(int key, [int index = 0]) {
    if (index < 0 || index >= items.length) return null;
    ItemTag item = items[index];
    return item[key];
  }

  /// Returns a [Iterable<Element>] containing the [Element] corresponding
  /// to the [key] in each [ItemTag] of [items].  If the [ItemTag] does not
  /// contain the [key], _null_ is inserted in the returned [Iterable<Element].
  Iterable<Element> getAllElements(int key) {
    Iterable<Element> eList = <Element>[];
    for (ItemTag item in items) eList.add(item[key]);
    return eList;
  }

  /// Returns a [Iterable<Element] containing a matching [Element] or _null_ from
  /// each [ItemTag] in order.  If an [Element] with [key] is not contained in a
  /// [ItemTag] its value is _null_ in the returned [List].
  Iterable<Element> getAllItemElements(int key) {
    Iterable<Element> list = new Iterable<Element>(items.length);
    for (int i = 0; i < items.length; i++) {
      ItemTag item = items[i];
      list[i] = item[key];
    }
    return list;
  }
*/

  @override
  String format(Formatter z) => z.fmt(this, items);

  @override
  String toString() => '$runtimeType $dcm ${tag.keyword} ${items.length} items';

  static const Iterable<Item> emptyTagItemList = const <TagItem>[];

  static SQtag make(Tag tag, Iterable<Item> values,
          [int vfLength, Dataset parent]) =>
      new SQtag(tag, parent, values, vfLength);

  static SQtag from(SQ sq, [Dataset parent]) {
    final nItems = new List<TagItem>(sq.values.length);
    parent ??= sq.parent;
    for (var i = 0; i < sq.values.length; i++) {
      final item = sq.values.elementAt(i);
      nItems[i] = new TagItem.from(item, parent);
    }
    return new SQtag(sq.tag, parent, nItems, sq.vfLengthField);
  }

/*
  static SQtag from(Element e, Dataset parent) =>
      new SQtag._fromBytes(e.tag, parent, e.values, e.vfLengthField, e.vfBytes);
*/

  static SQtag fromBytes(Tag tag, Dataset parent, List<TagItem> vList,
                           [int vfLengthField, Bytes bytes]) {
    if (tag.vrIndex != kSQIndex) return null;
    return new SQtag(tag, parent, vList, vfLengthField, bytes);
  }
}
