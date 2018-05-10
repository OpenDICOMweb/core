//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/utils/bytes/bytes.dart';

export 'package:core/src/utils/character/ascii.dart';
export 'package:core/src/utils/dicom.dart';
export 'package:core/src/error.dart';
export 'package:core/src/error/issues.dart';
export 'package:core/src/utils/string/hexadecimal.dart';
export 'package:core/src/vr/vr_base.dart';

// **** This file contains low-level [String] functions

bool inRange(int v, int min, int max) => v >= min && v <= max;
bool notInRange(int n, int min, int max) => !inRange(n, min, max);

/// Checks that vfLength (vfl) is in range and the right size, based on the
/// element size (eSize).
bool isValidLength(int length, int max, {bool onError(int length, int max)}) =>
    (length >= 0 && length <= max) ? true : onError(length, max);


final Bytes kEmptyBytes = Bytes.kEmptyBytes;

const List<String> kEmptyStringList = const <String>[];

const List<int> kEmptyIntList = const <int>[];

final Int8List kEmptyInt8List = new Int8List(0);
final Int16List kEmptyInt16List = new Int16List(0);
final Int32List kEmptyInt32List = new Int32List(0);
final Int64List kEmptyInt64List = new Int64List(0);

final Uint8List kEmptyUint8List = new Uint8List(0);
final Uint16List kEmptyUint16List = new Uint16List(0);
final Uint32List kEmptyUint32List = new Uint32List(0);
final Uint64List kEmptyUint64List = new Uint64List(0);

const List<double> kEmptyDoubleList = const <double>[];
final Float32List kEmptyFloat32List = new Float32List(0);
final Float64List kEmptyFloat64List = new Float64List(0);

final ByteData kEmptyByteData = new ByteData(0);


