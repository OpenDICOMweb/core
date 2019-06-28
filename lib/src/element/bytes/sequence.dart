//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.bytes;

// ignore_for_file: public_member_api_docs
// ignore: prefer_constructors_over_static_methods

// **** Sequence Class

class SQbytes extends SQ with ElementBytes<Item> {
  @override
  final Dataset parent;

  @override
  final List<Item> values;

  @override
  final BytesElement bytes;

  SQbytes(this.parent, this.values, this.bytes);

  @override
  int get length => values.length;

  /// Returns a new [SQbytes], where [bytes] is [BytesElement]
  /// for complete sequence.
  // ignore: prefer_constructors_over_static_methods
  static SQbytes fromBytes(Dataset parent,
      [Iterable<Item> items, BytesElement bytes]) {
    final code = bytes.code;
    if (_isPrivateCreator(code)) return badVRIndex(kSQIndex, null, kLOIndex);

    final tag = lookupTagByCode(code, bytes.vrIndex, parent);
    assert(tag.vrIndex == kSQIndex, 'vrIndex: ${tag.vrIndex}');
    if (tag.vrIndex != kSQIndex)
      log.warn('** Non-Sequence Tag $tag for $bytes');
    return SQbytes(parent, items, bytes);
  }

  static bool _isPrivateCreator(int code) {
    final pCode = code & 0x1FFFF;
    return pCode >= 0x10010 && pCode <= 0x100FF;
  }

  static SQbytes fromValues(int code, List<String> vList,
          {bool isEvr = true}) =>
      unsupportedError();
}
