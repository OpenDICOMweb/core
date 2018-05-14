//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/base/crypto.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/element/base/integer/utils.dart';
import 'package:core/src/element/base/utils.dart';
import 'package:core/src/error/element_errors.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
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
      vList != null && (doTestElementValidity ? isValidValues(tag, vList) : true);

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

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase.isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase.isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
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
      vList != null && (doTestElementValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) => true;

  static bool isValidVRCode(int vrCode, [Issues issues]) => true;

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : VR.badIndex(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase.isValidValue(v, issues, kMinValue, kMaxValue);

  // UN values are always true, since the read VR is unknown
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase.isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
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
      vList != null && (doTestElementValidity ? isValidValues(tag, vList) : true);

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

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase.isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase.isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// A mixin class for 32-bit unsigned integer [Element]s.
abstract class Uint32 {
  int get length;
  Iterable<int> get values;
  IntBase update([Iterable<int> vList]);

  int get sizeInBytes => kSizeInBytes;
  int get lengthInBytes => length * sizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  Uint32List get typedData => fromList(values);

  IntBase get sha256 => update(Sha256.uint32(typedData));

  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      IntBase.isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  IntBase view([int start = 0, int length]) => update(
      typedData.buffer.asUint32List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  bool equal(Bytes a, Bytes b) {
    for (var i = 0; i < a.length; i += 4) {
      final x = a.getUint32(i);
      final y = b.getUint32(i);
      if (x != y) return false;
    }
    return true;
  }

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList];
  static Bytes toBytes(Iterable<int> vList,
                       {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asBytes(bList);
  }

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toUint8List(Iterable<int> vList,
                               {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null :asUint8List(bList);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(List<int> vList,
                             {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asByteData(bList);
  }

  /// Returns a [base64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
                         {bool asView = true, bool check = true}) {
    final bytes = toBytes(vList, asView: asView, check: check);
    return (bytes == null) ? null : base64.encode(bytes);
  }

  /// Returns a [Uint32List] with the same length as [vList]. If
  /// [vList] is a [Uint32List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  ///
  /// If [vList] is not a [Uint32List], then if [vList] has valid values,
  /// a new [Uint32List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [badValues] is called.
  static Uint32List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyUint32List;
    if (vList is Uint32List)
      return (asView) ? vList : new Uint32List.fromList(vList);
    if (check) {
      final td = new Uint32List(vList.length);
      return copyList(vList, td, kMinValue, kMaxValue);
    }
    return new Uint32List.fromList(vList);
  }

  /// Returns a [Uint16List] from a [Bytes].
  static Uint32List fromBytes(Bytes bytes,
          {bool asView = true, bool check = true}) =>
      bytes.asUint32List();

  /// Returns a [Uint32List] from a [base64] [String].
  static Uint32List fromBase64(String s, {bool asView = true}) =>
      (s.isEmpty) ? kEmptyUint32List : fromUint8List(base64.decode(s));

  /// Returns a [Uint32List] from a [Uint8List].
  static Uint32List fromUint8List(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(asByteData(bytes), asView: asView);

  /// Returns a [Uint32List] from a [ByteData].
  static Uint32List fromByteData(ByteData bd, {bool asView = true}) =>
      _fromByteData(bd, asView: asView);

  /// /// Returns a [Uint32List] from a [ByteData].
  static Uint32List _fromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyUint32List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final nList = new Uint32List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getInt32(oib, Endian.little);
      return nList;
    }
    final u32List = bd.buffer.asUint32List(bd.offsetInBytes, length);
    return (asView) ? u32List : new Uint32List.fromList(u32List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;

  static List<int> fromValueField(Iterable vf) {
    if (vf == null) return kEmptyUint32List;
    if (vf is Uint32List ||
        vf is List<int> ||
        vf.isEmpty ||
        vf is IntBulkdataRef) return vf;
    if (vf is Bytes) return vf.asUint32List();
    if (vf is Uint8List) return fromUint8List(vf);
    return badValues(vf);
  }
}

int _toLength(int length, int vLength) =>
    (length == null || length > vLength) ? vLength : length;

bool _inRange(int v, int min, int max) => v >= min && v <= max;
