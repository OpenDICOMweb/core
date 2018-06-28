//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/value/image.dart';
import 'package:core/src/value/uid.dart';

/// PixelDataMixin class
abstract class PixelData extends Integer {
/*
  @override
  Iterable<int> get values => _values;
  @override
  set values(Iterable<int> vList) => _values = vList;
  List<int> _values;
*/

  /// The FrameList for _this_.
  Iterable<Frame> get frames => _frames;
  set frames(Iterable<Frame> vList) => _frames = vList;
  FrameList _frames;

  /// The Basic Offset Table (See PS3.5) for _this_.
  Uint32List get offsets;

  /// A [Uint8List] created from [frames].
  Uint8List get bulkdata => _frames.bulkdata;

  /// The [TransferSyntax] of _this_.
  TransferSyntax get ts;

  /// Returns _true_ if [frames] are compressed.
  bool get isCompressed => ts.isEncapsulated;

  // **** End Interface

  @override
  bool get isLengthAlwaysValid => true;
  @override
  bool get isUndefinedLengthAllowed => true;

  /// Synonym for [isCompressed]. Returns _true_ if [frames] are compressed.
  ///
  /// Note: If _this_ [isCompressed] and has more than one Frame,
  ///       It should have a non-empty [offsets].
  bool get isEncapsulated => isCompressed;
}

abstract class OBPixelData extends PixelData with Uint8 {
  @override
 final Tag tag = PTag.kPixelDataOB;

  @override
  int get maxLength => OB.kMaxLength;

  @override
  List<int> get emptyList => kEmptyUint8List;

  @override
  bool checkValue(int value, {Issues issues, bool allowInvalid = false}) =>
      (allowInvalid) ? true : value >= 0 && value <= 255;

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
  static bool isValidTag(Tag tag, [Issues issues]) =>
      (tag != null && doTestElementValidity && tag == PTag.kPixelDataOB)
          ? true
          : invalidTag(tag, issues, OBPixelData);
}

abstract class UNPixelData extends PixelData with Uint8 {
  @override
  Tag get tag => PTag.kPixelDataUN;
  @override
  TransferSyntax get ts;

  @override
  int get maxLength => UN.kMaxLength;

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

abstract class OWPixelData extends PixelData with Uint16 {
  @override
  final Tag tag = PTag.kPixelDataOW;
  @override
  TransferSyntax get ts;

  @override
  int get maxLength => OW.kMaxLength;
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

/*
abstract class Uint8PixelDataMixin {
  Uint8List get _values;
  FrameList8Bit get _frames;

//  Uint8List get valuesCopy => new Uint8List.fromList(pixels);

  /// The [Uint8List] of pixels, possibly compressed.
  Uint8List get pixels => _pixels ??= _values ?? _values.pixels;
  Uint8List _pixels;


}

abstract class Uint16PixelDataMixin {
  Uint16List get _values;
  FrameList16Bit get _frames;


}
*/
