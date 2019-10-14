//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:bytes/bytes.dart';

import 'package:core/src/values.dart';

// ignore_for_file: public_member_api_docs

/// PixelDataMixin class
mixin PixelDataMixin {
  /// The [TransferSyntax] of _this_.
  TransferSyntax get ts;
  int get length;
  int get sizeInBytes;

  // **** End Interface

  int get code => kPixelData;

  /// The [Tag] for this Element.
  Tag get tag => PTag.kPixelData;

  /// The Value Field length.
  int get vfLength => length * sizeInBytes;

  /// The length is always value for OB, OW, and UN.
  bool get isLengthAlwaysValid => true;

  /// The undefined lengths are always allowed for OB, OW, and UN.
  bool get isUndefinedLengthAllowed => true;

  /// Returns _true_ if compressed.
  ///
  /// Note: If _this_ [isCompressed] and has more than one Frame,
  ///       It should have a non-empty [offsets].
  bool get isCompressed => ts.isEncapsulated;

  /// Synonym for [isCompressed]. Returns _true_ if compressed.
  bool get isEncapsulated => isCompressed;
}

mixin OBPixelData {
  Tag get tag => PTag.kPixelDataOB;

  List<int> get emptyList => kEmptyUint8List;

  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      allowInvalid || v >= 0 && v <= 255;

  /// Returns _true_ if both [tag] and [vList] are valid for this [OB].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidArgs(Iterable<int> vList,
          [TransferSyntax ts, int vfLengthField, Issues issues]) =>
      OB.isValidArgs(PTag.kPixelDataOB, vList, vfLengthField, ts, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OB].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidBytesArgs(Bytes vfBytes, int vfLengthField,
          [Issues issues]) =>
      OB.isValidBytesArgs(PTag.kPixelDataOB, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [OBPixelData].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  // _Note_: The only valid [Tag] for this class is [Tag.kPixelDataOB].
  static bool isValidTag(Tag tag, [Issues issues]) {
    final ok = tag != null && doTestElementValidity && tag == PTag.kPixelDataOB;
    return ok ? ok : invalidTag(tag, issues, OBPixelData);
  }
}

mixin UNPixelData {
  Tag get tag => PTag.kPixelDataUN;

  /// Returns _true_ if both [tag] and [vList] are valid for this [UN].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidArgs(Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts, Issues issues]) {
    if (!isValidTag(PTag.kPixelDataUN, issues)) return false;
    return UN.isValidArgs(PTag.kPixelDataUN, vList, vfLengthField, ts, issues);
  }

  /// Returns _true_ if [vfBytes] is valid for [UN].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidBytesArgs(Bytes vfBytes, int vfLengthField,
      [Issues issues]) {
    if (!isValidTag(PTag.kPixelDataUN, issues)) return false;
    return UN.isValidBytesArgs(
        PTag.kPixelDataUN, vfBytes, vfLengthField, issues);
  }

  /// Returns _true_ if [tag] is valid for [UN].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidTag(Tag tag, [Issues issues]) {
    final ok = tag != null && doTestElementValidity && tag == PTag.kPixelDataUN;
    return ok ? ok : invalidTag(tag, issues, UNPixelData);
  }
}

mixin OWPixelData {
  final Tag tag = PTag.kPixelDataOW;

  /// Returns _true_ if [vList] is valid for this [OW].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidArgs(Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts, Issues issues]) =>
      OW.isValidArgs(PTag.kPixelDataOW, vList, vfLengthField, ts, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OW].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidBytesArgs(Bytes vfBytes, int vfLengthField,
          [Issues issues]) =>
      OW.isValidBytesArgs(PTag.kPixelDataOW, vfBytes, vfLengthField, issues);

  /// Returns _true_ if [tag] is valid for [OW].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidTag(Tag tag, [Issues issues]) {
    final ok = tag != null && doTestElementValidity && tag == PTag.kPixelDataOW;
    return ok ? ok : invalidTag(tag, issues, OWPixelData);
  }
}
