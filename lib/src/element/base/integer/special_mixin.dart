//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:collection/collection.dart';
import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/vr.dart';

class IntBulkdataRef extends DelegatingList<int> with BulkdataRef<int> {
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

abstract class OBMixin {
  int get vrIndex => kVRIndex;

  int get vrCode => kVRCode;

  String get vrKeyword => kVRKeyword;

  String get vrName => kVRName;

  int get vflSize => 4;

  int get maxVFLength => kMaxVFLength;

  int get maxLength => kMaxLength;

  bool get isLengthAlwaysValid => true;

  int get padChar => 0;

//  static const VR kVR = VR.kOB;
  static const int kVRIndex = kOBIndex;
  static const int kVRCode = kOBCode;
  static const String kVRKeyword = 'OB';
  static const String kVRName = 'Other Byte';
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null &&
      (doTestElementValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag, [Issues issues]) {
    if (_isValidVRIndex(tag.vrIndex)) return true;
    invalidTag(tag, issues, OB);
    return false;
  }

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (_isValidVRIndex(vrIndex)) return true;
    VR.badIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool _isValidVRIndex(int vrIndex) =>
      vrIndex == kOBIndex || vrIndex == kOBOWIndex;

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexByCode[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    return VR.invalidCode(vrCode, issues, kVRIndex);
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : VR.badIndex(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase.isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase.isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength, OB);
}

/// Unknown (UN) [Element].
abstract class UNMixin {
  int get vrIndex => kVRIndex;
  int get vrCode => kVRCode;
  String get vrKeyword => kVRKeyword;
  String get vrName => kVRName;
  int get vflSize => 4;
  int get maxVFLength => kMaxShortVF;
  int get maxLength => kMaxLength;
  bool get isLengthAlwaysValid => true;
  int get padChar => 0;

//  static const VR kVR = VR.kUN;
  static const int kVRIndex = kUNIndex;
  static const int kVRCode = kUNCode;
  static const String kVRKeyword = 'UN';
  static const String kVRName = 'Unknown';
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = kMaxLongVF;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null &&
      (doTestElementValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) => true;

  static bool isValidVRCode(int vrCode, [Issues issues]) => true;

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : VR.badIndex(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase.isValidValue(v, issues, kMinValue, kMaxValue);

  // UN values are always true, since the read VR is unknown
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase.isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength, UN);
}

/// Unknown (OW) [Element].
abstract class OWMixin {
  int get vrIndex => kVRIndex;
  int get vrCode => kVRCode;
  String get vrKeyword => kVRKeyword;
  String get vrName => kVRName;
  int get vflSize => 4;
  int get maxLength => kMaxLength;
  int get maxVFLength => kMaxLongVF;
  bool get isLengthAlwaysValid => true;

  static const int kVRIndex = kOWIndex;
  static const int kVRCode = kOWCode;
  static const String kVRKeyword = 'OW';
  static const String kVRName = 'Other Word';
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = k16BitMaxLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null &&
      (doTestElementValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kOWIndex ||
        vrIndex == kOBOWIndex ||
        vrIndex == kUSSSOWIndex ||
        vrIndex == kUNIndex) return true;
    VR.badIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexByCode[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    return VR.invalidCode(vrCode, issues, kVRIndex);
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : VR.badIndex(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase.isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase.isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength, OW);
}

int _toLength(int length, int vLength) =>
    (length == null || length > vLength) ? vLength : length;

bool _inRange(int v, int min, int max) => v >= min && v <= max;
