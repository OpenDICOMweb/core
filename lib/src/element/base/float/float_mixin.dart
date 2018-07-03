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
import 'package:core/src/element/base/utils.dart';
import 'package:core/src/element/base/float/float.dart';
import 'package:core/src/error/element_errors.dart';
import 'package:core/src/utils/bytes/bytes.dart';
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: avoid_annotating_with_dynamic

/// A mixin class for 32-bit floating point [Element]s.
abstract class Float32 {
  Float32List get values;
  Float update([Iterable<double> vList]);
  // **** End of Interface ****

  /// The number of bytes in a [Float32] element.
  int get sizeInBytes => kSizeInBytes;

  int get length => values.length;

  int get lengthInBytes => length * sizeInBytes;

  Float get sha256 => update(Sha256.float32(values));

  Float32List get typedData =>
      (values is Float32List) ? values : new Float32List.fromList(values);

  Float32List get emptyList => kEmptyFloat32List;

  /// Returns a [Float32List.view] of [values].
  Float view([int start = 0, int length]) => update(
      typedData.buffer.asFloat32List(start, _toLength(length, values.length)));

  /// The number of bytes in a [Float32] element.
  static const int kSizeInBytes = 4;

  bool equal(DicomBytes a, DicomBytes b) {
    for (var i = 0; i < a.length; i += 4) {
      final x = a.getFloat32(i);
      final y = b.getFloat32(i);
      if (x != y) return false;
    }
    return true;
  }

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList]. If [asView] is _true_
  /// and [vList] is a [Float32List] a view of [vList] is returned;
  /// otherwise, a new Float64List] is created from vList and returned.
  static Bytes toBytes(Iterable<double> vList, {bool asView = true}) =>
      new Bytes.typedDataView(fromList(vList, asView: asView));

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
      base64.encode(toBytes(vList, asView: asView));

  /// Returns a [Float32List] with the same length as [vList]. If
  /// [vList] is a [Float32List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  static Float32List fromList(Iterable<double> vList, {bool asView = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyFloat32List;
    if (vList is Float32List && asView) return vList;
    final List<double> v = (vList is! List<double>) ? vList.toList() : vList;
    return new Float32List.fromList(v);
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
      (s.isEmpty) ? kEmptyFloat32List : fromUint8List(base64.decode(s));

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

/// A mixin class for 64-bit floating point [Element]s.
abstract class Float64 {
  Float64List get values;
  Float update([Iterable<double> vList]);
  // **** End of Interface ****

  /// The number of bytes in a [Float64] element.
  int get sizeInBytes => kSizeInBytes;

  int get length => values.length;

  int get lengthInBytes => length * sizeInBytes;

  Float get sha256 => update(Sha256.float64(values));

  Float64List get typedData =>
      (values is Float64List) ? values : new Float64List.fromList(values);

  Float64List get emptyList => kEmptyFloat64List;

  /// Returns a [Float64List.view] of [values].
  Float view([int start = 0, int length]) => update(
      typedData.buffer.asFloat64List(start, _toLength(length, values.length)));

  /// The number of bytes in a [Float64] element.
  static const int kSizeInBytes = 8;

  bool equal(Bytes a, Bytes b) {
    for (var i = 0; i < a.length; i += 8) {
      final x = a.getFloat64(i);
      final y = b.getFloat64(i);
      if (x != y) return false;
    }
    return true;
  }

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList]. If [asView] is _true_
  /// and [vList] is a [Float64List] a view of [vList] is returned;
  /// otherwise, a new Float64List] is created from vList and returned.
  static Bytes toBytes(Iterable<double> vList, {bool asView = true}) =>
      new Bytes.typedDataView(fromList(vList, asView: asView));

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
      base64.encode(toBytes(vList));

  /// Returns a [Float64List] with the same length as [vList]. If
  /// [vList] is a [Float64List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  static Float64List fromList(Iterable<double> vList, {bool asView = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyFloat64List;
    if (vList is Float64List && asView) return vList;
    final List<double> v = (vList is! List<double>) ? vList.toList() : vList;
    return new Float64List.fromList(v);
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
      (s.isEmpty) ? kEmptyFloat64List : fromUint8List(base64.decode(s));

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
