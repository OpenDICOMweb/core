// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:core/src/base.dart';
import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/errors.dart';
import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/element/base/vf_fragments.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/errors.dart';
import 'package:core/src/vr.dart';

class IntBulkdataRef extends DelegatingList<int> with BulkdataRef<int>{
  @override
  int code;
  @override
  Uri uri;
  List<int> _values;

  IntBulkdataRef(this.code, this.uri, [this._values]) : super(_values);

  IntBulkdataRef.fromString(this.code, String s, [this._values])
      : uri = Uri.parse(s),
        super(_values);

  List<int> get delegate => _values;

  @override
  List<int> get values => _values ??= getBulkdata(code, uri);
}

abstract class IntBase extends Element<int> {
  @override
  Iterable<int> get values;
  @override
  IntBase update([Iterable<int> vList]);

  @override
  set values(Iterable<int> vList) => unsupportedError('IntBase.values');

  @override
  int get padChar => 0;

  bool get isBinary => true;

  /// Returns a copy of [values]
  @override
  Iterable<int> get valuesCopy => new List.from(values, growable: false);

  /// The _canonical_ empty [values] value for Floating Point Elements.
  @override
  List<int> get emptyList => kEmptyList;
  static const List<int> kEmptyList = const <int>[];

  @override
  IntBase get noValues => update(kEmptyList);

  @override
  ByteData get vfByteData => typedData.buffer
      .asByteData(typedData.offsetInBytes, typedData.lengthInBytes);

  @override
  Bytes get vfBytes => new Bytes.typedDataView(typedData);

  VFFragments get fragments => unsupportedError();

  /// Returns a [view] of this [Element] with [values] replaced by [TypedData].
  IntBase view([int start = 0, int length]);

  static bool isValidValue(int v, Issues issues, int min, int max) =>
      _isValidValue(v, issues, min, max);

  static bool _isValidValue(int v, Issues issues, int min, int max) {
    if (v < min || v > max) {
      if (issues != null) {
        if (v < min) issues.add('Invalid Value($v) under minimum($min)');
        if (v < min) issues.add('Invalid Value($v) over maximum($max)');
      }
      return false;
    }
    return true;
  }

  static bool isValidValues(Tag tag, Iterable<int> vList, Issues issues,
          int minVLength, int maxVLength, int maxVFListLength) =>
      _isValidValues(
          tag, vList, issues, minVLength, maxVLength, maxVFListLength);

  static bool _isValidValues(Tag tag, Iterable<int> vList, Issues issues,
      int minVLength, int maxVLength, int maxVFListLength) {
    if (!Element.isValidVListLength(tag, vList, issues, maxVFListLength))
      return false;
    var result = true;
    for (var v in vList)
      result = _isValidValue(v, issues, minVLength, maxVLength);
    if (result == false) {
      invalidValuesError(vList, issues: issues);
      return false;
    }
    return result;
  }

  // TODO: this is the same as in Float create a number_mixing and move
  //       common functions there
  @override
  String getValuesAsString(int max) {
    final v = values;
    if (v == null) return nullElementError();
    final vList = (v.length > max) ? v.take(max) : v;
    final s = '[${vList.join(', ')}]';
    return '(${vList.length})$s';
  }
}

/// Signed Short [Element].
abstract class SS extends IntBase with Int16 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get sizeInBytes => kSizeInBytes;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;

//  static const VR kVR = VR.kSS;
  static const int kVRIndex = kSSIndex;
  static const int kVRCode = kSSCode;
  static const String kVRKeyword = 'SS';
  static const String kVRName = 'Signed Short';
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVFLSize = 2;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSOWIndex)
      return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Signed Long ([SL]) [Element].
abstract class SL extends IntBase with Int32 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get sizeInBytes => kSizeInBytes;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;

//  static const VR kVR = VR.kSL;
  static const int kVRIndex = kSLIndex;
  static const int kVRCode = kSLCode;
  static const String kVRKeyword = 'SL';
  static const String kVRName = 'Signed Long';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Other Byte [Element].
abstract class OB extends IntBase
    with OBMixin, Uint8 {

  @override
  int get vfLengthField;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vlfSize => 4;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;
  @override
  bool get isLengthAlwaysValid => true;
  @override
  bool get isUndefinedLengthAllowed => true;
  @override
  bool get hadULength => vfLengthField == kUndefinedLength;
  @override
  int get padChar => 0;

  static const int kVRIndex = kOBIndex;
  static const int kVRCode = kOBCode;
  static const String kVRKeyword = 'OB';
  static const String kVRName = 'Other Byte';
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax8BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag, [Issues issues]) {
    if (_isValidVRIndex(tag.vrIndex)) return true;
    invalidTagError(tag, OB, issues);
    return false;
  }

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (_isValidVRIndex(vrIndex)) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool _isValidVRIndex(int vrIndex) =>
      vrIndex == kOBIndex || vrIndex == kOBOWIndex;

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Unknown (UN) [Element].
abstract class UN extends IntBase with Uint8 {
  @override
  int get vfLengthField;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vlfSize => 4;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;
  @override
  bool get isLengthAlwaysValid => true;
  @override
  bool get isUndefinedLengthAllowed => true;
  @override
  bool get hadULength => vfLengthField == kUndefinedLength;
  @override
  int get padChar => 0;

//  static const VR kVR = VR.kUN;
  static const int kVRIndex = kUNIndex;
  static const int kVRCode = kUNCode;
  static const String kVRKeyword = 'UN';
  static const String kVRName = 'Unknown';
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax8BitLongVF;
  static const int kMaxLength = kMaxLongVF;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) => true;

  static bool isValidVRCode(int vrCode, [Issues issues]) => true;

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVRIndex(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  // UN values are always true, since the read VR is unknown
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      ((vList is Uint8List) && (vList.length <= kMaxVFLength))
          ? true
          : IntBase._isValidValues(
              tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Other Byte [Element].
abstract class US extends IntBase with Uint16 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;

//  static const VR kVR = VR.kUS;
  static const int kVRIndex = kUSIndex;
  static const int kVRCode = kUSCode;
  static const String kVRKeyword = 'US';
  static const String kVRName = 'Unsigned Short';
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSOWIndex)
      return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Unknown (OW) [Element].
abstract class OW extends IntBase with Uint16 {
  @override
  int get vfLengthField;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vlfSize => 4;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxLongVF;
  @override
  bool get isLengthAlwaysValid => true;
  @override
  bool get isUndefinedLengthAllowed => true;
  @override
  bool get hadULength => vfLengthField == kUndefinedLength;

  static const int kVRIndex = kOWIndex;
  static const int kVRCode = kOWCode;
  static const String kVRKeyword = 'OW';
  static const String kVRName = 'Other Word';
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax16BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kOWIndex ||
        vrIndex == kOBOWIndex ||
        vrIndex == kUSSSOWIndex ||
        vrIndex == kUNIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Attribute Tag [Element].
abstract class AT extends IntBase with Uint32 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;

//  static const VR kVR = VR.kAT;
  static const int kVRIndex = kATIndex;
  static const int kVRCode = kATCode;
  static const String kVRKeyword = 'AT';
  static const String kVRName = 'Attribute Tag';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Other Long [Element].
///
/// VFLength and Values length are always valid.
abstract class OL extends IntBase with Uint32 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vlfSize => 4;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  bool get isLengthAlwaysValid => true;

//  static const VR kVR = VR.kOL;
  static const int kVRIndex = kOLIndex;
  static const int kVRCode = kOLCode;
  static const String kVRKeyword = 'OL';
  static const String kVRName = 'Other Long';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax32BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Unsigned Long [Element].
abstract class UL extends IntBase with Uint32 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;

//  static const VR kVR = VR.kUL;
  static const int kVRIndex = kULIndex;
  static const int kVRCode = kULCode;
  static const String kVRKeyword = 'UL';
  static const String kVRName = 'Unsigned Long';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Group Length [Element] is a subtype of [UL]. It always has a tag
/// of the form (gggg,0000).
abstract class GL extends UL {
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRKeyword;
  int get groupLength => value;

  static const String kVRKeyword = 'GL';
  static const String kVRName = 'Group Length';

  static bool isValidValues(Tag tag, List<int> vList, [Issues issues]) =>
      tag.vrIndex == kULIndex && vList.length == 1 && UL.isValidValue(vList[0]);
}

bool _inRange(int v, int min, int max) => v >= min && v <= max;

bool _isValidVFLength(int vfl, int minBytes, int maxBytes, int sizeInBytes) =>
    _inRange(vfl, minBytes, maxBytes) && (vfl % sizeInBytes == 0);

