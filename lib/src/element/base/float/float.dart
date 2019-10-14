//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:bytes/bytes.dart';
import 'package:base/base.dart';
import 'package:collection/collection.dart';
import 'package:core/src/error.dart';
import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/base/crypto.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/utils.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/vr/vr_internal.dart';

// ignore_for_file: public_member_api_docs

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
abstract class Float extends Element<double> {
  @override
  List<double> get values;

  // **** End of Interface ****

  @override
  int get vfLength => length * sizeInBytes;

  /// Returns a copy of [values]
  @override
  List<double> get valuesCopy => List.from(values, growable: false);

  /// The _canonical_ empty [values] values for Floating Point Elements.
  @override
  List<double> get emptyList => kEmptyList;

  @override
  ByteData get vfByteData => typedData.buffer.asByteData();

  @override
  Bytes get vfBytes => Bytes.typedDataView(typedData);

  @override
  Float get noValues => update(kEmptyList);

//  @override
//  Uint8List get bulkdata => typedData.buffer.asUint8List();

  @override
  bool checkValue(double v, {Issues issues, bool allowInvalid = false}) => true;

  /// Returns a [view] of this [Element] with [values] replaced by [TypedData].
  Float view([int start = 0, int length]);

  @override
  String toString() => '$runtimeType ${dcm(code)} ($vr) $values';

  /// The canonical empty [List] for [Float]s.
  static List<double> kEmptyList = <double>[];

  /// Returns _true_ if [tag] and each values in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, Issues issues,
      int maxVListLength, Type type) {
    assert(tag != null);
    if (vList == null) return invalidValues(vList, issues, tag);
    return Element.isValidLength(tag, vList, issues, maxVListLength, type);
  }
}

/// A mixin class for 32-bit floating point [Element]s.
mixin Float32Mixin {
  List<double> get values;
  Element<double> update([Iterable<double> vList]);
  // **** End of Interface ****

  /// The number of bytes in a [Float32Mixin] element.

  int get lengthInBytes => length * sizeInBytes;
  int get length => values.length;

  Uint8List get bulkdata => typedData.buffer.asUint8List();

  /// The number of bytes in a [Float32Mixin] element.
  int get sizeInBytes => 4;

  Float32List get typedData =>
      (values is Float32List) ? values : fromList(values);

  Float get sha256 => update(Sha256.float32(values));

  /// Returns a [Float32List.view] of [values].
  Float view([int start = 0, int length]) => update(
      typedData.buffer.asFloat32List(start, _toLength(length, values.length)));

  bool equal(Bytes a, Bytes b) {
    for (var i = 0; i < a.length; i += 4) {
      final x = a.getFloat32(i);
      final y = b.getFloat32(i);
      if (x != y) return false;
    }
    return true;
  }

  /// The number of bytes in a [Float64Mixin] element.
  static int kSizeInBytes = 4;

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList]. If [asView] is _true_
  /// and [vList] is a [Float32List] a view of [vList] is returned;
  /// otherwise, a new Float64List] is created from vList and returned.
  static Bytes toBytes(Iterable<double> vList, {bool asView = true}) =>
      Bytes.typedDataView(fromList(vList, asView: asView));

  /// Returns a [Uint8List] created from [vList].  If [asView] is _true_
  /// and [vList] is a [Float32List] a view of [vList] is returned;
  /// otherwise, a new Float64List] is created from vList and returned.
  static Uint8List toUint8List(Iterable<double> vList, {bool asView = true}) =>
      _asUint8List(fromList(vList, asView: asView));

  /// Returns a [ByteData] created from [vList].  If [asView] is _true_
  /// and [vList] is a [Float32List] a view of [vList] is returned;
  /// otherwise, a new Float64List] is created from vList and returned.
  static ByteData toByteData(Iterable<double> vList, {bool asView = true}) =>
      _asByteData(fromList(vList, asView: asView));

  /// Returns a [base64] [String] created from [vList]. If [asView] is _true_
  /// and [vList] is a [Float32List] a view of [vList] is returned;
  /// otherwise, a new Float64List] is created from vList and returned.
  static String toBase64(Iterable<double> vList, {bool asView = true}) =>
      cvt.base64.encode(toBytes(vList, asView: asView));

  /// Returns a [Float32List] with the same length as [vList]. If
  /// [vList] is a [Float32List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  static Float32List fromList(Iterable<double> vList, {bool asView = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyFloat32List;
    if (vList is Float32List && asView) return vList;
    final List<double> v = (vList is! List<double>) ? vList.toList() : vList;
    return Float32List.fromList(v);
  }

  /// Returns a [Float32List] created from [bytes]. If [asView] is
  /// _true_, then a view of the [bytes] is returned; otherwise,
  /// a [Float32List] copy of [bytes] is returned.
  /// No values checking is done.
  static Float32List fromBytes(Bytes bytes, {bool asView = true}) =>
      bytes.asFloat32List();

  /// Returns a [Float32List] from a [base64] [String].
  /// No values checking is done.
  static Float32List fromBase64(String s) =>
      (s.isEmpty) ? kEmptyFloat32List : fromUint8List(cvt.base64.decode(s));

  /// Returns a [Float32List] from a [Uint8List]. If [asView]
  /// is _true_, then  a [Float32List] view of [list] is returned;
  /// otherwise, a copy of [list] is returned.
  /// No values checking is done.
  static Float32List fromUint8List(Uint8List list, {bool asView = true}) =>
      _fromByteData(_asByteData(list), asView: asView);

  /// Returns a [Float32List] created from a [ByteData]. If
  /// [asView] is _true_, then  a [Float64List] view of [bd] is returned;
  /// otherwise, a [Float32List] copy of [bd] is returned.
  /// No values checking is done.
  static Float32List fromByteData(ByteData bd, {bool asView = true}) =>
      _fromByteData(bd, asView: asView);

  /// /// Returns a [Float32List] from a [ByteData].
  static Float32List _fromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyFloat32List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final nList = Float32List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getFloat32(oib, Endian.little);
      return nList;
    }
    final f32List = bd.buffer.asFloat32List(bd.offsetInBytes, length);
    return asView ? f32List : Float32List.fromList(f32List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;

  static List<double> fromValueField(Iterable vf) {
    if (vf == null) return kEmptyDoubleList;
    if (vf is Float32List ||
        vf is Iterable<double> ||
        vf.isEmpty ||
        vf is FloatBulkdataRef) return vf;
    if (vf is Bytes) return vf.asFloat32List();
    if (vf is Uint8List) return fromUint8List(vf);
    return badValues(vf);
  }
}

/// FL
abstract class FL extends Float with Float32Mixin {
  static const int kVRIndex = kFLIndex;
  static const int kVRCode = kFLCode;
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k32BitMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Floating Point Single';
  static const String kVRKeyword = 'FL';

  static const Type kType = FL;

  @override
  int get vlfSize => kVLFSize;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isLengthAlwaysValid => kIsLengthAlwaysValid;
  @override
  bool get isUndefinedLengthAllowed => kIsUndefinedLengthAllowed;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null && isValidTag(tag) && isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [FL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, FL);

  /// Returns _true_ if [vrIndex] is valid for [FL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVR(int vrIndex) => VR.isValidIndex(vrIndex, kFLIndex);

  /// Returns _true_ if [vrCode] is valid for [FL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode) => VR.isValidCode(vrCode, kFLCode);

  /// Returns _true_ if [vfLength] is valid for this [FL].
  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [FL].
  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (vList == null) return nullValueError();
    if (tag.isValidLength(vList, issues)) return true;
    return invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  /// Returns _true_ if each values in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    return isValidVR(tag.vrIndex) &&
        Float.isValidValues(tag, vList, issues, kMaxLength, FL);
  }
}

abstract class OF extends Float with Float32Mixin {
  static const int kVRIndex = kOFIndex;
  static const int kVRCode = kOFCode;
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 4;
  static const int kMaxVFLength = k32BitMaxLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static const bool kIsLengthAlwaysValid = true;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Other Float';
  static const String kVRKeyword = 'OF';

  static const Type kType = OF;

  @override
  int get vlfSize => kVLFSize;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isLengthAlwaysValid => kIsLengthAlwaysValid;
  @override
  bool get isUndefinedLengthAllowed => kIsUndefinedLengthAllowed;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null && isValidTag(tag) && isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, OF);

  static bool isValidVR(int vrIndex) {
    if (vrIndex == kVRIndex) return true;
    return invalidVRIndex(vrIndex, kVRIndex);
  }

  static bool isValidVRCode(int vrCode) {
    if (vrCode != kVRCode) return invalidVRCode(vrCode, kVRCode);
    return true;
  }

  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (vList == null) return nullValueError();
    if (tag.isValidLength(vList, issues)) return true;
    return invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  /// Returns _true_ if each values in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, OF);
    return isValidVR(tag.vrIndex) &&
        Float.isValidValues(tag, vList, issues, kMaxLength, OF);
  }
}

/// A mixin class for 64-bit floating point [Element]s.
mixin Float64Mixin {
  List<double> get values;
  Element<double> update([Iterable<double> vList]);
  // **** End of Interface ****

  int get lengthInBytes => length * sizeInBytes;
  int get length => values.length;

  Uint8List get bulkdata => typedData.buffer.asUint8List();

  /// The number of bytes in a [Float64Mixin] element.
  int get sizeInBytes => 8;

  Float get sha256 => update(Sha256.float64(values));

  Float64List get typedData =>
      (values is Float64List) ? values : Float64List.fromList(values);

  /// Returns a [Float64List.view] of [values].
  Float view([int start = 0, int length]) => update(
      typedData.buffer.asFloat64List(start, _toLength(length, values.length)));

  bool equal(Bytes a, Bytes b) {
    for (var i = 0; i < a.length; i += 8) {
      final x = a.getFloat64(i);
      final y = b.getFloat64(i);
      if (x != y) return false;
    }
    return true;
  }

  /// The number of bytes in a [Float64Mixin] element.
  static const int kSizeInBytes = 8;

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList]. If [asView] is _true_
  /// and [vList] is a [Float64List] a view of [vList] is returned;
  /// otherwise, a new Float64List] is created from vList and returned.
  static Bytes toBytes(Iterable<double> vList, {bool asView = true}) =>
      Bytes.typedDataView(fromList(vList, asView: asView));

  /// Returns a [Uint8List] created from [vList]. If [asView] is _true_
  /// and [vList] is a [Float64List] a view of [vList] is returned;
  /// otherwise, a new Float64List] is created from vList and returned.
  static Uint8List toUint8List(Iterable<double> vList, {bool asView = true}) =>
      _asUint8List(fromList(vList, asView: asView));

  /// Returns a [ByteData] view of from [vList]. If [asView] is _true_
  /// and [vList] is a [Float64List] a view of [vList] is returned;
  /// otherwise, a new Float64List] is created from vList and returned.
  static ByteData toByteData(List<double> vList, {bool asView = true}) =>
      _asByteData(fromList(vList, asView: asView));

  /// Returns a [base64] [String] created from [vList].
  static String toBase64(Iterable<double> vList) =>
      cvt.base64.encode(toBytes(vList));

  /// Returns a [Float64List] with the same length as [vList]. If
  /// [vList] is a [Float64List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  static Float64List fromList(Iterable<double> vList, {bool asView = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyFloat64List;
    if (vList is Float64List && asView) return vList;
    final List<double> v = (vList is! List<double>) ? vList.toList() : vList;
    return Float64List.fromList(v);
  }

  /// Returns a [Float64List] created from [bytes]. If [asView] is
  /// _true_, then a view of the [bytes] is returned; otherwise,
  /// a [Float64List] copy of [bytes] is returned.
  /// No values checking is done.
  static Float64List fromBytes(Bytes bytes, {bool asView = true}) =>
      bytes.asFloat64List();

  /// Returns a [Float64List] created from a [base64] [String].
  /// No values checking is done.
  static Float64List fromBase64(String s) =>
      (s.isEmpty) ? kEmptyFloat64List : fromUint8List(cvt.base64.decode(s));

  /// Returns a [Float64List] from a [Uint8List]. If [asView]
  /// is _true_, then  a [Float64List] view of [list] is returned;
  /// otherwise, a copy of [list] is returned.
  /// No values checking is done.
  static Float64List fromUint8List(Uint8List list, {bool asView = true}) =>
      _fromByteData(_asByteData(list), asView: asView);

  /// Returns a [Float64List] created from a [ByteData]. If
  /// [asView] is _true_, then  a [Float64List] view of [bd] is returned;
  /// otherwise, a [Float64List] copy of [bd] is returned.
  /// No values checking is done.
  static Float64List fromByteData(ByteData bd, {bool asView = true}) =>
      _fromByteData(bd, asView: asView);

  /// Returns a [Float64List] from a [ByteData].
  static Float64List _fromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyFloat64List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final nList = Float64List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getFloat64(oib, Endian.little);
      return nList;
    }
    final f64List = bd.buffer.asFloat64List(bd.offsetInBytes, length);
    return asView ? f64List : Float64List.fromList(f64List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;

  static List<double> fromValueField(Iterable vf) {
    if (vf == null) return kEmptyDoubleList;
    if (vf is Float64List ||
        vf is Iterable<double> ||
        vf.isEmpty ||
        vf is FloatBulkdataRef) return vf;
    if (vf is Bytes) return vf.asFloat64List();
    if (vf is Uint8List) return fromUint8List(vf);
    return badValues(vf);
  }
}

abstract class FD extends Float with Float64Mixin {
  static const int kVRIndex = kFDIndex;
  static const int kVRCode = kFDCode;
  static const int kSizeInBytes = 8;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k64BitMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Floating Point Double';
  static const String kVRKeyword = 'FD';

  static const Type kType = FD;

  @override
  int get vlfSize => kVLFSize;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isLengthAlwaysValid => kIsLengthAlwaysValid;
  @override
  bool get isUndefinedLengthAllowed => kIsUndefinedLengthAllowed;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null && isValidTag(tag) && isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, FD);

  static bool isValidVR(int vrIndex) {
    if (vrIndex != kVRIndex) return invalidVRIndex(vrIndex, kVRIndex);
    return true;
  }

  static bool isValidVRCode(int vrCode) {
    if (vrCode != kVRCode) return invalidVRCode(vrCode, kVRCode);
    return true;
  }

  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (vList == null) return nullValueError();
    if (tag.isValidLength(vList, issues)) return true;
    return invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  /// Returns _true_ if each values in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    return isValidVR(tag.vrIndex) &&
        Float.isValidValues(tag, vList, issues, kMaxLength, FD);
  }
}

abstract class OD extends Float with Float64Mixin {
  static const int kVRIndex = kODIndex;
  static const int kVRCode = kODCode;
  static const int kSizeInBytes = 8;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k64BitMaxLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static const bool kIsLengthAlwaysValid = true;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Other Double';
  static const String kVRKeyword = 'OD';

  static const Type kType = OD;

  @override
  int get vlfSize => kVLFSize;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isLengthAlwaysValid => kIsLengthAlwaysValid;
  @override
  bool get isUndefinedLengthAllowed => kIsUndefinedLengthAllowed;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null && isValidTag(tag) && isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, OD);

  static bool isValidVR(int vrIndex) {
    if (vrIndex == kVRIndex) return true;
    return invalidVRIndex(vrIndex, kVRIndex);
  }

  static bool isValidVRCode(int vrCode) {
    if (vrCode != kVRCode) return invalidVRCode(vrCode, kVRCode);
    return true;
  }

  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  static bool isValidLength(int vfl) => true;

  /// Returns _true_ if [values] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVR(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength, OD);

  static bool isNotValidValues(Tag tag, Iterable<double> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

class FloatBulkdataRef extends DelegatingList<double> with BulkdataRef<double> {
  @override
  final int code;
  @override
  final Uri uri;
  List<double> _values;

  FloatBulkdataRef(this.code, this.uri, [this._values]) : super(_values);

  FloatBulkdataRef.fromString(this.code, String s, [this._values])
      : uri = Uri.parse(s),
        super(_values);

  List<double> get delegate => _values;

  @override
  List<double> get values => _values ??= getBulkdata(code, uri);
}

int _toLength(int length, int vLength) =>
    (length == null || length > vLength) ? vLength : length;

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

/// Returns true if [vfLength] is in the range 0 <= [vfLength] <= [max],
/// and [vfLength] is a multiple of of values size in bytes ([sizeInBytes]),
/// i.e. `vfLength % eSize == 0`.
bool _isValidVFLength(int vfLength, int max, int sizeInBytes) =>
    vfLength >= 0 && vfLength <= max && (vfLength % sizeInBytes) == 0;
