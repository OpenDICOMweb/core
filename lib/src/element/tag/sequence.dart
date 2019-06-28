//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/src/dataset/base.dart';
import 'package:core/src/dataset/tag.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

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

  @override
  final Bytes bytes;

  /// Creates a  [SQtag] instance.
  factory SQtag(Dataset parent, Tag tag, [Iterable<Item> vList]) =>
      SQtag._(parent, tag, vList);

  /// Creates a  [SQtag] instance.
  SQtag._(this.parent, this.tag, [Iterable<Item> vList, this.bytes])
      : _values = (vList == null)
            ? SQ.kEmptyList
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
  SQtag get noValues => update(SQ.kEmptyList);

  @override
  SQtag get sha256 => throw UnsupportedError('Can\t hash a sequence');

  @override
  String get info => '$tag: Items:${values.length}, total Elements: $total';

  /// Returns a copy of _this_ Sequence, with a  [List] of [Item]s.
  @override
  SQtag update([Iterable<Item> vList = SQ.kEmptyList]) =>
      SQtag(parent, tag, vList);

  /// Returns a copy of _this_ Sequence, with a  [List] of Tag[Item]s.
  SQtag updateSQtag(Iterable<TagItem> items, Dataset parent) =>
      SQtag(parent, tag, items);

  Uint8List getValuesToBytes({bool addHeader, bool isAscii = true}) {
    throw UnimplementedError('toDcm');
  }

  Uint8List getBytesToValues({bool addHeader, bool isAscii = true}) {
    throw UnimplementedError('toDcm');
  }

  SQtag copySQ([Dataset parent]) => convert(parent ?? this.parent, this);

  @override
  String format(Formatter z) => z.fmt(this, items);

  @override
  String toString() => '$runtimeType $dcm ${tag.keyword} ${items.length} items';

  // ignore: prefer_constructors_over_static_methods
  static SQtag fromValues(Tag tag, Iterable<Item> values,
          [int vfLength, Dataset parent]) =>
      SQtag(parent, tag, values);

  // ignore: prefer_constructors_over_static_methods
  static SQtag from(Dataset parent, SQ sq) {
    final nItems = List<TagItem>(sq.values.length);
    for (var i = 0; i < sq.values.length; i++) {
      final item = sq.values[i];
      nItems[i] = TagItem.convert(parent, item, sq);
    }
    return SQtag(parent, sq.tag, nItems);
  }

  // ignore: prefer_constructors_over_static_methods
  static SQtag fromBytes(Dataset parent, List<Item> vList, BytesElement bytes) {
    final code = bytes.code;
    if (_isPrivateCreator(code)) return badVRIndex(kSQIndex, null, kLOIndex);

    final tag = lookupTagByCode(code, bytes.vrIndex, parent);
    if (tag.vrIndex != kSQIndex) {
      log.warn('** Non-Sequence Tag $tag for $bytes');
      return null;
    }
    return SQtag(parent, tag, vList);
  }

  static bool _isPrivateCreator(int code) {
    final pCode = code & 0x1FFFF;
    return pCode >= 0x10010 && pCode <= 0x100FF;
  }

  static const _makeSQ = TagElement.sqFromCode;

  // ignore: prefer_constructors_over_static_methods
  static SQtag convert(Dataset parent, SQ e) {
    final items = e.values.toList();
    final length = items.length;
    final tagItems = List<TagItem>(e.items.length);

    final sq = _makeSQ(parent, e.code, tagItems);
    for (var i = 0; i < length; i++) {
      final tItem = TagItem.convert(parent, items[i], sq);
      tagItems[i] = tItem;
    }
    sq.values = tagItems;
    return sq;
  }
}
