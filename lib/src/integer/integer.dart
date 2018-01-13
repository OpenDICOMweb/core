// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:math';

const int k1KB = 1024;
const int k1MB = k1KB * 1024;
const int k1GB = k1MB * 1024;
const int k1TB = k1GB * 1024;

/// The minimum value of a signed 8-bit integer.
const int kInt8Min = -(1 << (8 - 1));

/// The maximum value of a signed 8-bit integer.
const int kInt8Max = (1 << (8 - 1)) - 1;

/// The minimum value of a signed 16-bit integer.
const int kInt16Min = -(1 << (16 - 1));

/// The maximum value of a signed 16-bit integer.
const int kInt16Max = (1 << (16 - 1)) - 1;

/// The minimum value of a signed 32-bit integer.
const int kInt32Min = -(1 << (32 - 1));

/// The maximum value of a signed 32-bit integer.
const int kInt32Max = (1 << (32 - 1)) - 1;

/// The minimum value of an unboxed, signed 32-bit integer.
const int kInt64Min = kDartMinSMInt;

/// The maximum value of an unboxed, signed 32-bit integer.
const int kInt64Max = kDartMaxSMInt;

/// The minimum value of a unsigned 16-bit integer.
const int kUint8Min = 0;

/// The maximum value of a unsigned 16-bit integer.
const int kUint8Max = 0xFF;

/// The minimum value of a unsigned 32-bit integer.
const int kUint16Min = 0;

/// The maximum value of an unsigned 16-bit integer (2^32).
const int kUint16Max = 0xFFFF;

/// The minimum value of a unsigned 32-bit integer.
const int kUint32Min = 0;

/// The maximum value of an unsigned 32-bit integer (2^32).
const int kUint32Max = 0xFFFFFFFF;

/// The minimum value of an unboxed, unsigned 64-bit integer.
const int kUint64Min = 0;

/// The maximum value of an unboxed, unsigned 64-bit integer (2^32).
const int kUint64Max = kDartMaxSMUint;

/// The minimum integer value, in Dart, that can be stored without boxing.
const int kDartMinSMInt = -4611686018427387904;

/// The maximum integer value, in Dart, that can be stored without boxing.
const int kDartMaxSMInt =  4611686018427387903;

/// The maximum unsigned integer value, in Dart, that can be stored without boxing.
const int kDartMaxSMUint =  0x3FFFFFFFFFFFFFFF;

final int kMin63BitInt = -pow(2, 62);
final int kMax63BitInt = pow(2, 62) - 1;
