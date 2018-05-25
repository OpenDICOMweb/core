//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/value/uid.dart';

/// PixelDataMixin class
abstract class PixelData {
  Tag get tag;
  int get code;
  int get vfLengthField;
  int get vfLength;
  Bytes get vfBytes;

  /// The [List<int>] of pixels.
  List<int> get pixels;
  TransferSyntax get ts;

  /// Returns _true_ if [pixels] are compressed.
  bool get isCompressed;

  // **** End Interface

  /// Synonym for pisCompressed].
  bool get isEncapsulated => isCompressed;

}

abstract class OBPixelData extends OB
    with PixelData, Uint8PixelDataMixin {
  @override
  TransferSyntax get ts;

  @override
  bool get isCompressed => ts.isEncapsulated;
  /// Returns _true_ if both [tag] and [vList] are valid for this [OB].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts, Issues issues]) {
    if (!isValidTag(tag, issues)) return false;
    return OB.isValidArgs(tag, vList, vfLengthField, ts, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OB].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
      [Issues issues]) {
    if (!isValidTag(tag, issues)) return false;
    return OB.isValidBytesArgs(tag, vfBytes, vfLengthField, issues);
  }

  /// Returns _true_ if [tag] is valid for [OBPixelData].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  // _Note_: The only valid [Tag] for this class is [Tag.kPixelDataOB].
  static bool isValidTag(Tag tag, [Issues issues]) =>
      (tag != null && doTestElementValidity && tag == PTag.kPixelDataOB)
          ? true
          : invalidTag(tag, issues, OBPixelData);
}

abstract class UNPixelData extends UN
    with PixelData, Uint8PixelDataMixin {
  @override
  TransferSyntax get ts;

  @override
  bool get isCompressed => ts.isEncapsulated;

  /// Returns _true_ if both [tag] and [vList] are valid for this [UN].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts, Issues issues]) {
    if (!isValidTag(tag, issues)) return false;
    return UN.isValidArgs(tag, vList, vfLengthField, ts, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UN].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
      [Issues issues]) {
    if (!isValidTag(tag, issues)) return false;
    return UN.isValidBytesArgs(tag, vfBytes, vfLengthField, issues);
  }

  /// Returns _true_ if [tag] is valid for [UN].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      (tag != null && doTestElementValidity && tag == PTag.kPixelDataUN)
          ? true
          : invalidTag(tag, issues, UNPixelData);
}

abstract class OWPixelData extends OW
    with PixelData, Uint16PixelDataMixin {
  @override
  TransferSyntax get ts;

  @override
  bool get isCompressed => ts.isEncapsulated;
  /// Returns _true_ if both [tag] and [vList] are valid for this [OW].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts, Issues issues]) {
    if (!isValidTag(tag, issues)) return false;
    return OW.isValidArgs(tag, vList, vfLengthField, ts, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OW].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
      [Issues issues]) {
    if (!isValidTag(tag, issues)) return false;
    return OW.isValidBytesArgs(tag, vfBytes, vfLengthField, issues);
  }

  /// Returns _true_ if [tag] is valid for [OW].
  /// If [doTestElementValidity] is _false_ then no validation is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      (tag != null && doTestElementValidity && tag == PTag.kPixelDataOW)
          ? true
          : invalidTag(tag, issues, OWPixelData);
}

abstract class Uint8PixelDataMixin {
  Iterable<int> get values;

  Uint8List get valuesCopy => new Uint8List.fromList(pixels);

  /// The [Uint8List] of pixels, possibly compressed.
  Uint8List get pixels => _pixels ??= Uint8.fromList(values);
  Uint8List _pixels;
}

abstract class Uint16PixelDataMixin {
  Iterable<int> get values;

  Uint16List get valuesCopy => new Uint16List.fromList(pixels);

  /// The [Uint16List] of pixels, possibly compressed.
  Uint16List get pixels => _pixels ??= Uint16.fromList(values);
  Uint16List _pixels;
}
