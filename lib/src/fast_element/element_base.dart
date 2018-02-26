// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: load Element library lazily

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/crypto.dart';
import 'package:core/src/empty_list.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/export.dart';
import 'package:core/src/vr/vr.dart';
// import 'package:core/src/element/base/bulkdata.dart';


/// The base class for DICOM Data Elements
///
/// An implementation of this class must provide the following:
///   1. An implementation of a List<V> of values, where V is
///      one of [double], [int], [String], or [Item].
///
///   2. An implementation of a TypeData Getter typedData.
///

// TODO: the following typedefs should be replaced with the new
//       inline Type declarations
/// The Type of a Method or Function that takes an Element and returns
/// a [bool].
typedef bool ElementTest(FastElementBase e);

typedef bool Condition(Dataset ds, FastElementBase e);

Iterable<V> _toList<V>(Iterable v) =>
    (v is Iterable) ? v.toList(growable: false) : v;

bool doTestValidity = true;

/// All add, replace, and remove operations should
/// be done by calling add, replace, and remove methods in [Dataset].

/// The base class for DICOM Data Elements. The type variable [V]
/// is for the type of the Values [List].

/// The base class for DICOM Data Elements. The [Type] variable [V]
/// is the [Type] of the [values] of the [FastElementBase].
abstract class FastElementBase<V> {
  final int bits;

  const FastElementBase(this.bits);

  Iterable<V> get values;

  // **** Start List implementation
  V operator [](int i) => values.elementAt(i);

  void operator []=(int i, V v) =>
      throw new UnsupportedError('Elements are immutable');

  /// Returns the number of [values] of _this_.
  int get length {
    if (values == null) return nullValueError();
    return values.length;
  }

  set length(int n) => throw new UnsupportedError('Elements are immutable');
  // *** End of List Implementation

  int get vrIndex;

  // Note: the next three are all implemented in terms of vrIndex
  int get vrCode;
  String get vrKeyword;
  String get vrName;

  int get vlfSize;
  int get maxLength;
  int get maxVFLength;
  int get sizeInBytes;
  int get padChar;
  int get vfLength => length * sizeInBytes;

  bool get isLengthAlwaysValid => false;
  /// Returns a copy of [values]
  Iterable<V> get valuesCopy => new List.from(values, growable: false);

  /// The _canonical_ empty [values] value for Floating Point Elements.
  List<V> get emptyList;

  TypedData get typedData;
  ByteData get vfByteData => typedData.buffer.asByteData();

  Uint8List get vfBytes => typedData.buffer.asUint8List();

  FastElementBase update(List<V> vList);
  FastElementBase get noValues => update(emptyList);

  bool checkValue(double value, {Issues issues, bool allowInvalid = false}) =>
      true;

  /// Returns a [Float32List] with the same length as [vList]. If
  /// [vList] is a [Float32List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  static Float32List fromList(Iterable<double> vList, {bool asView = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyFloat32List;
    if (vList is Float32List)
      return (asView) ? vList : new Float32List.fromList(vList);
    return new Float32List.fromList(vList);
  }

  /// Returns a [BASE64] [String] created from [vList];
  static String toBase64(Iterable<double> vList, {bool asView = true}) =>
      BASE64.encode(toBytes(vList, asView: asView));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toBytes(Iterable<double> vList, {bool asView = true}) =>
      _asUint8List(fromList(vList, asView: asView));

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(Iterable<double> vList, {bool asView = true}) =>
      _asByteData(fromList(vList, asView: asView));


}

// ignore_for_file: avoid_annotating_with_dynamic

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
abstract class Float extends FastElementBase<double>  {
  @override
 final Iterable<double> values;

  Float(int bits, this.values) : super(bits);

  @override
  TypedData get typedData;

  /// Returns a copy of [values]
  @override
  Iterable<double> get valuesCopy => new List.from(values, growable: false);

/*  /// The _canonical_ empty [values] value for Floating Point Elements.
  List<double> get emptyList => kEmptyList;
  static const List<double> kEmptyList = const <double>[];
 */
  @override
  ByteData get vfByteData => typedData.buffer.asByteData();

  @override
  Uint8List get vfBytes => typedData.buffer.asUint8List();

  @override
  bool checkValue(double value, {Issues issues, bool allowInvalid = false}) =>
      true;

  /// Returns _true_ if each value in [vList] is valid.
  static bool isValidValues(
      Tag tag, Iterable<double> vList, Issues issues, int maxVListLength) {
    if (!Element.isValidVListLength(tag, vList, issues, maxVListLength))
      return false;
    return true;
  }
}

/// An abstract class for 32-bit floating point [Element]s.
abstract class Float32Mixin {
  List<double> get values;
  Float update(Iterable<double> vList);

  int get sizeInBytes => kSizeInBytes;

  Float get sha256 => update(Sha256.float32(values));

  Float32List get typedData => fromList(values);

  /// Returns a view of [values].
  Float view([int start = 0, int length]) => update(
      typedData.buffer.asFloat32List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 4;


  /// Returns a [Float32List] with the same length as [vList]. If
  /// [vList] is a [Float32List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  static Float32List fromList(Iterable<double> vList, {bool asView = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyFloat32List;
    if (vList is Float32List)
      return (asView) ? vList : new Float32List.fromList(vList);
    return new Float32List.fromList(vList);
  }

  /// Returns a [Float32List] from a [BASE64] [String].
  static Float32List fromBase64(String s) =>
      (s.isEmpty) ? kEmptyFloat32List : fromBytes(BASE64.decode(s));

  /// Returns a [Float32List] from a [Uint8List].
  static Float32List fromBytes(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(bytes.buffer.asByteData());

  /// Returns a [Float32List] from a [ByteData].
  static Float32List fromByteData(ByteData bd, {bool asView = true}) =>
      _fromByteData(bd);

  /// /// Returns a [Float32List] from a [ByteData].
  static Float32List _fromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyFloat32List;
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

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;
}

/// FL
abstract class FL extends Float with Float32Mixin {
  FL(int bits, Iterable<double> values) : super(bits, values);
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
  int get maxVFLength => kMaxVFLength;

  static const int kVRIndex = kFLIndex;
  static const int kVRCode = kFLCode;
  static const String kVRKeyword = 'FL';
  static const String kVRName = 'Floating Point Single';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static bool isValidArgs(Tag tag, Iterable<double> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

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

  static int checkVRIndex(int vrIndex, [Issues issues]) => (vrIndex == kVRIndex)
                                                           ? vrIndex
                                                           : invalidVRIndex(vrIndex, issues, kVRIndex);

  /// Returns
  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length,
                              [int min = 0, int max = kMaxVFLength]) =>
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
      isValidVRIndex(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength);

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;
}

abstract class OF extends Float with Float32Mixin {
  OF(int bits, Iterable<double> vList) : super(bits, vList);
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
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

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

  static int checkVRIndex(int vrIndex, [Issues issues]) => (vrIndex == kVRIndex)
                                                           ? vrIndex
                                                           : invalidVRIndex(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidLength(int vfl) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength);
}

/// An abstract class for 64-bit floating point [Element]s.
abstract class Float64Mixin {
  Iterable<double> get values;
  Float update([Iterable<double> vList]);

  int get sizeInBytes => kSizeInBytes;

  Float get sha256 => update(Sha256.float64(values));

  Float64List get typedData =>
      (values is Float64List) ? values : new Float64List.fromList(values);

  /// Returns a [Float64List.view] of [values].
  Float view([int start = 0, int length]) => update(
      typedData.buffer.asFloat64List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 8;

  /// Returns a [BASE64] [String] created from [vList];
  static String toBase64(Iterable<double> vList) =>
      BASE64.encode(toBytes(vList));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toBytes(Iterable<double> vList, {bool asView = true}) =>
      _asUint8List(fromList(vList, asView: asView));

  /// Returns a [ByteData] view of from [vList].
  static ByteData toByteData(List<double> vList, {bool asView = true}) =>
      _asByteData(fromList(vList, asView: asView));

  /// Returns a [Float64List] with the same length as [vList]. If
  /// [vList] is a [Float64List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  static Float64List fromList(Iterable<double> vList, {bool asView = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyFloat64List;
    if (vList is Float64List)
      return (asView) ? vList : new Float64List.fromList(vList);
    return new Float64List.fromList(vList);
  }

  /// Returns a [Float64List] from a [BASE64] [String].
  static Float64List fromBase64(String s, {bool asView = true}) =>
      (s.isEmpty) ? kEmptyFloat64List : fromBytes(BASE64.decode(s));

  /// Returns a [Float64List] from a [Uint8List].
  static Float64List fromBytes(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(_asByteData(bytes), asView: asView);

  /// Returns a [Float64List] from a [ByteData].
  static Float64List fromByteData(ByteData bd, {bool asView = true}) =>
      _fromByteData(bd, asView: asView);

  /// /// Returns a [Float64List] from a [ByteData].
  static Float64List _fromByteData(ByteData bd, {bool asView = true}) {
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

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;
}

abstract class FD extends Float with Float64Mixin {
  FD(int bits, Iterable<double> values) : super(bits, values);
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
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

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

  static int checkVRIndex(int vrIndex, [Issues issues]) => (vrIndex == kVRIndex)
                                                           ? vrIndex
                                                           : invalidVRIndex(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length,
                              [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(length, min, max, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength);
}

abstract class OD extends Float with Float64Mixin {
  OD(int bits, Iterable<double> values) : super(bits, values);
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
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

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

  static int checkVRIndex(int vrIndex, [Issues issues]) => (vrIndex == kVRIndex)
                                                           ? vrIndex
                                                           : invalidVRIndex(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidLength(int vfl) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength);
}

int _toLength(int length, int vLength) =>
    (length == null || length > vLength) ? vLength : length;

bool _inRange(int v, int min, int max) => v >= min && v <= max;

bool _isValidVFLength(int vfl, int min, int max, int sizeInBytes) =>
    _inRange(vfl, min, max) && (vfl % sizeInBytes == 0);

Uint8List _asUint8List(TypedData td) {
  if (td == null) return null;
  if (td.lengthInBytes == 0) return kEmptyUint8List;
  return td.buffer.asUint8List(td.offsetInBytes, td.lengthInBytes);
}

/// Returns a [ByteData] created from [td];
ByteData _asByteData(TypedData td) {
  if (td == null) return null;
  if (td.lengthInBytes == 0) return kEmptyByteData;
  return td.buffer.asByteData(td.offsetInBytes, td.lengthInBytes);
}

