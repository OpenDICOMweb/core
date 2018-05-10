//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error.dart';

bool _inRange(int v, int min, int max) => v >= min && v <= max;

/// Checks that vfLength (vfl) is in range and the right size, based on the
/// element size (eSize).
bool isValidVFLength(int vfl, int max, int eSize) =>
    (__isValidVFL(vfl, max, eSize)) ? true : invalidVFLength(vfl, max, eSize);

/// Returns true if [vfLength] is in the range 0 <= [vfLength] <= [max],
/// and [vfLength] is a multiple of of value size in bytes ([eSize]),
/// i.e. `vfLength % eSize == 0`.
bool __isValidVFL(int vfLength, int max, int eSize) =>
    (_inRange(vfLength, 0, max) && (vfLength % eSize == 0)) ? true : false;

//TODO move to Float64, Float32, etc.
int vfLengthToLength(int vfLengthField, int sizeInBytes) {
  final vlf = vfLengthField;
  final length = vlf ~/ sizeInBytes;
  assert(vlf >= 0 && vlf.isEven, 'vfLengthField: $vlf');
  assert(vlf % sizeInBytes == 0, 'vflf: $vlf sizeInBytes $sizeInBytes');
  return length;
}
