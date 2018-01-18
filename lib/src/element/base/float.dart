// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/crypto.dart';
import 'package:core/src/empty_list.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/tag_lib.dart';
import 'package:core/src/vr/vr.dart';

// ignore_for_file: avoid_annotating_with_dynamic

int _toLength(int length, int vLength) =>
    (length == null || length > vLength) ? vLength : length;

bool _inRange(int v, int min, int max) => v >= min && v <= max;

bool _isValidVFLength(int vfl, int min, int max, int sizeInBytes) =>
    _inRange(vfl, min, max) && (vfl % sizeInBytes == 0);

// **** Float Elements

// Design notes:
//  1. List<double> does not need to have values checked
//  2. _tdList returns a TypedData List of the appropriate Type.

/// All public constructors should take either List<double> or
/// FloatXXList from [TypedData].
///
/// Note: When
///     ```[new] Foo.fromBytes(key, bytes)```
/// is invoked [values] is always a [Uint8List]; however, when
///     ```[new] Foo(key, [List<double>])```
/// is invoked [values] may be either [TypedData] or [List<double>].
abstract class FloatBase extends Element<double> {
  @override
  Iterable<double> get values;
  @override
  set values(Iterable<double> vList) => unsupportedError('IntBase.values');

  bool get isBinary => true;

  @override
  int get vfLength => length * sizeInBytes;

  @override
  int get padChar => unsupportedError('Float does not have a padChar');

  /// Returns a copy of [values]
  @override
  Iterable<double> get valuesCopy => new List.from(values, growable: false);

  /// The _canonical_ empty [values] value for Floating Point Elements.
  @override
  Iterable<double> emptyList = const <double>[];

  @override
  ByteData get vfByteData => typedData.buffer.asByteData();

  @override
  Uint8List get vfBytes => typedData.buffer.asUint8List();

  @override
  FloatBase get noValues => update(emptyList);

  @override
  bool checkValue(double value, {Issues issues, bool allowInvalid = false}) => true;

  /// Returns a [view] of this [Element] with [values] replaced by [TypedData].
  FloatBase view([int start = 0, int length]);

  @override
  FloatBase update([Iterable<double> vList = kEmptyDoubleList]);

  @override
  FloatBase updateF(Iterable<double> f(Iterable<double> vList));

  @override
  Iterable<double> replace([Iterable<double> vList = kEmptyDoubleList]) =>
      _replace(vList ?? kEmptyDoubleList);

  @override
  Iterable<double> replaceF(Iterable<double> f(Iterable<double> vList)) =>
      _replace(f(values) ?? kEmptyDoubleList);

  // This is a space & speed optimization - rather than [super.replace].
  Iterable<double> _replace(Iterable<double> vList) {
    // final v = (vList is! Iterable<double>) ? toF64List(vList) : vList;
    final old = values;
    values = vList;
    return old;
  }

  /// Returns _true_ if each value in [vList] is valid.
  static bool isValidValues(
      Tag tag, Iterable<double> vList, Issues issues, int maxVListLength) {
    if (!Element.isValidVListLength(tag, vList, issues, maxVListLength)) return false;

/* TODO: Delete when sure only doubles will be passed
    for (var v in vList)
      if (!isValidValue(v)) {
        invalidValuesError(vList, issues: issues);
        return false;
      }
*/
    return true;
  }
}

/// An abstract class for 32-bit floating point [Element]s.
abstract class Float32Base extends FloatBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  @override
  FloatBase get sha256 => update(Sha256.float32(values));

  @override
  Float32List get typedData =>
      (values is Float32List) ? values : new Float32List.fromList(values);

  /// Returns a view of [values].
  @override
  Float32Base view([int start = 0, int length]) =>
      update(typedData.buffer.asFloat32List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 4;

  /// Returns a [BASE64] [String] created from [vList];
  static String listToBase64(Iterable<double> vList) => BASE64.encode(listToBytes(vList));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List listToBytes(Iterable<double> vList, {bool asView = true}) {
    final td = _toFloat32List(vList);
    return td?.buffer?.asUint8List(td.offsetInBytes, td.lengthInBytes);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData listToByteData(Iterable<double> vList, {bool asView = true}) {
    final td = _toFloat32List(vList);
    return td?.buffer?.asByteData(td.offsetInBytes, td.lengthInBytes);
  }

  static Float32List toFloat32List(Iterable<double> vList, {bool asView = true}) =>
      _toFloat32List(vList);

  static Float32List _toFloat32List(Iterable<double> vList, {bool asView = true}) {
    assert(vList != null);
    return (vList is Float32List) ? vList : new Float32List.fromList(vList);
  }

  /// Returns a [Float32List] from a [BASE64] [String].
  static Float32List listFromBase64(String s) =>
      (s.isEmpty) ? kEmptyFLoat32List : listFromBytes(BASE64.decode(s));

  /// Returns a [Float32List] from a [Uint8List].
  static Float32List listFromBytes(Uint8List bytes, {bool asView = true}) =>
      _listFromByteData(bytes.buffer.asByteData());

  /// Returns a [Float32List] from a [ByteData].
  static Float32List listFromByteData(ByteData bd, {bool asView = true}) =>
      _listFromByteData(bd);

  /// /// Returns a [Float32List] from a [ByteData].
  static Float32List _listFromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyFLoat32List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final nList = new Float32List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getFloat32(oib, Endian.little);
      return nList;
    }
    final f32List = bd.buffer.asFloat32List(bd.offsetInBytes, length);
    return (asView) ? f32List : new Float32List.fromList(f32List);
  }

  static bool _isNotAligned(TypedData vList) => (vList.offsetInBytes % kSizeInBytes) != 0;
}

/// FL
abstract class FL extends Float32Base {
  @override
  //Urgent Jim Fix
  //VR get vr => vrFromIndex(kVRIndex);
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;

//  static const VR kVR = VR.kFL;
  static const int kVRIndex = kFLIndex;
  static const int kVRCode = kFLCode;
  static const String kVRKeyword = 'FL';
  static const String kVRName = 'Floating Point Single';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static bool isValidArgs(Tag tag, Iterable<double> vList) =>
      (isValidTag(tag) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVR(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVR(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVRIndex(vrIndex, issues, kVRIndex);

  /// Returns
  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(length, min, max, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag.vrIndex != kVRIndex) {
      invalidVRIndexForTag(tag, kVRIndex);
      return false;
    }
    return tag.isValidValuesLength(vList, issues);
  }

  /// Returns _true_ if each value in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      FloatBase.isValidValues(tag, vList, issues, kMaxLength);

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;
}

abstract class OF extends Float32Base {
  @override
  //Urgent Jim Fix
  //VR get vr => vrFromIndex(kVRIndex);
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vflSize => 4;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  bool get isLengthAlwaysValid => true;
  @override
  int get vfLength => length * sizeInBytes;

//  static const VR kVR = VR.kOF;
  static const int kVRIndex = kOFIndex;
  static const int kVRCode = kOFCode;
  static const String kVRKeyword = 'OF';
  static const String kVRName = 'Other Float';
  static const int kSizeInBytes = 4;
  static const int kShiftValue = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax32BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static bool isValidArgs(Tag tag, Iterable<double> vList) =>
      (isValidTag(tag) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVRIndex(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidLength(int vfl) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      FloatBase.isValidValues(tag, vList, issues, kMaxLength);
}

/// An abstract class for 64-bit floating point [Element]s.
abstract class Float64Base extends FloatBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  @override
  FloatBase get sha256 => update(Sha256.float64(values));

  @override
  Float64List get typedData =>
      (values is Float64List) ? values : new Float64List.fromList(values);

  /// Returns a [Float64List.view] of [values].
  @override
  Float64Base view([int start = 0, int length]) {
    if (!checkLength(values)) return invalidValuesLengthError(tag, values);
    return update(
        typedData.buffer.asFloat64List(start, _toLength(length, values.length)));
  }

  static const int kSizeInBytes = 8;

  /// Returns a [BASE64] [String] created from [vList];
  static String listToBase64(Iterable<double> vList, {bool check = true}) =>
      BASE64.encode(listToBytes(vList));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List listToBytes(Iterable<double> vList, {bool check = true}) {
    final td = _toFloat64List(vList);
    return td?.buffer?.asUint8List(td.offsetInBytes, td.lengthInBytes);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData listToByteData(Iterable<double> vList, {bool check = true}) {
    final td = _toFloat64List(vList);
    return td?.buffer?.asByteData(td.offsetInBytes, td.lengthInBytes);
  }

  static Float64List toFloat64List(Iterable<double> vList, {bool check = true}) =>
      _toFloat64List(vList);

  static Float64List _toFloat64List(Iterable<double> vList, {bool check = true}) {
    assert(vList != null);
    return (vList is Float64List) ? vList : new Float64List.fromList(vList);
  }

  /// Returns a [Float64List] from a [BASE64] [String].
  static Float64List listFromBase64(String s, {bool asView = true}) =>
      (s.isEmpty) ? kEmptyFloat64List : listFromBytes(BASE64.decode(s));

  /// Returns a [Float64List] from a [Uint8List].
  static Float64List listFromBytes(Uint8List bytes, {bool asView = true}) =>
      _listFromByteData(bytes.buffer.asByteData());

  /// Returns a [Float64List] from a [ByteData].
  static Float64List listFromByteData(ByteData bd, {bool asView = true}) =>
      _listFromByteData(bd);

  /// /// Returns a [Float64List] from a [ByteData].
  static Float64List _listFromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyFloat64List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final nList = new Float64List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getFloat64(oib, Endian.little);
      return nList;
    }
    final f64List = bd.buffer.asFloat64List(bd.offsetInBytes, length);
    return (asView) ? f64List : new Float64List.fromList(f64List);
  }

  static bool _isAligned(TypedData vList) => (vList.offsetInBytes % kSizeInBytes) == 0;

  static bool _isNotAligned(TypedData vList) => !_isAligned(vList);
}

abstract class FD extends Float64Base {
//  @override
  //Urgent Jim Fix
  //VR get vr => vrFromIndex(kVRIndex);
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;

//  static const VR kVR = VR.kFD;
  static const int kVRIndex = kFDIndex;
  static const int kVRCode = kFDCode;
  static const String kVRKeyword = 'FD';
  static const String kVRName = 'Floating Point Double';
  static const int kSizeInBytes = 8;
  static const int kShiftValue = 3;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static bool isValidArgs(Tag tag, Iterable<double> vList) =>
      (isValidTag(tag) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int index, [Issues issues]) {
    if (index == kVRIndex) return true;
    invalidVRIndex(index, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVRIndex(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(length, min, max, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      FloatBase.isValidValues(tag, vList, issues, kMaxLength);
}

abstract class OD extends Float64Base {
//  @override
  //Urgent Jim Fix
  //VR get vr => vrFromIndex(kVRIndex);
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vflSize => 4;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  bool get isLengthAlwaysValid => true;

//  static const VR kVR = VR.kOD;
  static const int kVRIndex = kODIndex;
  static const int kVRCode = kODCode;
  static const String kVRKeyword = 'OD';
  static const String kVRName = 'Other Double';
  static const int kSizeInBytes = 8;
  static const int kShiftValue = 3;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax64BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static bool isValidArgs(Tag tag, Iterable<double> vList) =>
      (isValidTag(tag) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int index, [Issues issues]) {
    if (index == kVRIndex) return true;
    invalidVRIndex(index, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVRIndex(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidLength(int vfl) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      FloatBase.isValidValues(tag, vList, issues, kMaxLength);
}
