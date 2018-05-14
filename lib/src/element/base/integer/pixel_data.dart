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
// import 'package:core/src/element/base/vf_fragments.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/value/uid.dart';

import 'package:core/src/error/element_errors.dart';
import 'package:core/src/vr.dart';

/// PixelDataMixin class
abstract class PixelData {
  Tag get tag;
  int get code;
  int get vfLengthField;
  Bytes get vfBytes;

/*
  /// Returns the [VFFragments] for this Element, if any; otherwise,
  /// returns _null_.  Only kPixelData Elements can have [fragments].
  VFFragments get fragments;
*/

  /// The [List<int>] of pixels.
  List<int> get pixels;
  TransferSyntax get ts;

  // **** End Interface

//  int get vfOffset => ts.isEvr ? 12 : 8;

  /// Returns _true_ if encapsulated (i.e. compressed).
//  bool get isCompressed => fragments != null;

//  bool get isEncapsulated => isCompressed;

/*
  Uint32List get offsets =>
      _offsets ??= (fragments == null) ? null : fragments.offsets;
  Uint32List _offsets;
*/

//  Uint8List get bulkdata => fragments.bulkdata;
}

abstract class OBPixelData extends IntBase
    with OBMixin, Uint8, PixelData, Uint8PixelDataMixin {
  /// Returns _true_ if [tag] is valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      (doTestElementValidity && tag == PixelDataTag.kPixelDataOB)
          ? true
          : invalidTag(tag, issues, OBPixelData);

  /// Returns _true_ if both [tag] and [vList] are valid for this [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts, Issues issues]) {
    if (tag == null) return invalidTag(tag, null, OB);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        OB.isValidVFLength(vList.length, vfLengthField, issues, tag) &&
        OB.isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
      [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, OB);
    return vfBytes != null &&
        doTestElementValidity &&
        OB.isValidTag(tag, issues) &&
        OB.isValidVFLength(vfBytes.length, vfLengthField, issues, tag);
  }

  /// Returns _true_ if [vrIndex] is valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      OB.isValidVRIndex(vrIndex, issues);

  /// Returns _true_ if [vrCode] is valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      OB.isValidVRCode(vrCode, issues);

  /// Returns _true_ if [vfLength] is valid for this [OB].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, int vfLengthField,
          [Issues issues, Tag tag]) =>
      OB.isValidVFLength(vfLength, vfLengthField, issues, tag);

  /// Returns _true_ if [vList].length is valid for [OB].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) =>
      OB.isValidLength(tag, vList, issues);

  /// Returns _true_ if [value] is valid for [OB].
  static bool isValidValue(int value, [Issues issues]) =>
      OB.isValidValue(value, issues);

  /// Returns _true_ if [tag] has a VR of [OB] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      OB.isValidValues(tag, vList, issues);
}

abstract class UNPixelData extends IntBase
    with UNMixin, Uint8, PixelData, Uint8PixelDataMixin {
  /// Returns _true_ if [tag] is valid for [UN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      (doTestElementValidity && tag == PixelDataTag.kPixelDataUN)
          ? true
          : invalidTag(tag, issues, UNPixelData);

  /// Returns _true_ if both [tag] and [vList] are valid for this [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts, Issues issues]) {
    if (tag == null) return invalidTag(tag, null, OB);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        UN.isValidVFLength(vList.length, vfLengthField, issues, tag) &&
        UN.isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
      [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, OB);
    return vfBytes != null &&
        doTestElementValidity &&
        UN.isValidTag(tag, issues) &&
        UN.isValidVFLength(vfBytes.length, vfLengthField, issues, tag);
  }

  /// Returns _true_ if [vrIndex] is valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      UN.isValidVRIndex(vrIndex, issues);

  /// Returns _true_ if [vrCode] is valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      UN.isValidVRCode(vrCode, issues);

  /// Returns _true_ if [vfLength] is valid for this [OB].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, int vfLengthField,
          [Issues issues, Tag tag]) =>
      UN.isValidVFLength(vfLength, vfLengthField, issues, tag);

  /// Returns _true_ if [vList].length is valid for [OB].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) =>
      UN.isValidLength(tag, vList, issues);

  /// Returns _true_ if [value] is valid for [OB].
  static bool isValidValue(int value, [Issues issues]) =>
      UN.isValidValue(value, issues);

  /// Returns _true_ if [tag] has a VR of [OB] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      UN.isValidValues(tag, vList, issues);
}

abstract class OWPixelData extends IntBase
    with OWMixin, Uint16, PixelData, Uint16PixelDataMixin {
  /// Returns _true_ if [tag] is valid for [OW].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      (doTestElementValidity && tag == PixelDataTag.kPixelDataOW)
          ? true
          : invalidTag(tag, issues, OWPixelData);

  /// Returns _true_ if both [tag] and [vList] are valid for this [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts, Issues issues]) {
    if (tag == null) return invalidTag(tag, null, OB);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        OW.isValidVFLength(vList.length, vfLengthField, issues, tag) &&
        OW.isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
      [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, OB);
    return vfBytes != null &&
        doTestElementValidity &&
        OW.isValidTag(tag, issues) &&
        OW.isValidVFLength(vfBytes.length, vfLengthField, issues, tag);
  }

  /// Returns _true_ if [vrIndex] is valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      OW.isValidVRIndex(vrIndex, issues);

  /// Returns _true_ if [vrCode] is valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      OW.isValidVRCode(vrCode, issues);

  /// Returns _true_ if [vfLength] is valid for this [OB].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, int vfLengthField,
          [Issues issues, Tag tag]) =>
      OW.isValidVFLength(vfLength, vfLengthField, issues, tag);

  /// Returns _true_ if [vList].length is valid for [OB].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) =>
      OW.isValidLength(tag, vList, issues);

  /// Returns _true_ if [value] is valid for [OB].
  static bool isValidValue(int value, [Issues issues]) =>
      OW.isValidValue(value, issues);

  /// Returns _true_ if [tag] has a VR of [OB] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      OW.isValidValues(tag, vList, issues);
}

abstract class Uint8PixelDataMixin {
  Iterable<int> get values;
//  bool get isEncapsulated;
//  VFFragments get fragments;

  Uint8List get valuesCopy => new Uint8List.fromList(pixels);

  /// The [Uint8List] of pixels, possibly compressed.
  Uint8List get pixels => _pixels ??=
//      (isEncapsulated) ? fragments.bulkdata : Uint8.fromList(values);
      Uint8.fromList(values);
  Uint8List _pixels;
}

abstract class Uint16PixelDataMixin {
  Iterable<int> get values;
//  bool get isEncapsulated;
//  VFFragments get fragments;

  Uint16List get valuesCopy => new Uint16List.fromList(pixels);

  /// The [Uint16List] of pixels, possibly compressed.
  Uint16List get pixels => _pixels ??=
//      (isEncapsulated) ? fragments.bulkdata : Uint16.fromList(values);
      Uint16.fromList(values);
  Uint16List _pixels;
}
