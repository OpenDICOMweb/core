//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: public_member_api_docs

bool _inRange(int v, int min, int max) => v >= min && v <= max;

//TODO move to Float64, Float32, etc.
int vfLengthToLength(int vfLengthField, int sizeInBytes) {
  final vlf = vfLengthField;
  final length = vlf ~/ sizeInBytes;
  assert(vlf >= 0 && vlf.isEven, 'vfLengthField: $vlf');
  assert(vlf % sizeInBytes == 0, 'vflf: $vlf sizeInBytes $sizeInBytes');
  return length;
}

/// Returns _true_  if [vfLength] is a valid Value Field length.
bool isValidFixedVFL(int vfLength, int maxVFLength, int eSize,
        [Issues issues]) =>
    (vfLength >= 0 && vfLength <= maxVFLength)
        ? true
        : invalidFixedVFLength(vfLength, maxVFLength, eSize, issues);

/// Checks that vfLength (vfl) is in range and the right size, based on the
/// element size (eSize).
bool isValidFixedVFLength(int vfl, int max, int eSize, Issues issues) =>
    (__isValidVFL(vfl, max, eSize))
        ? true
        : invalidFixedVFLength(vfl, max, eSize, issues);

/// Returns true if [vfLength] is in the range 0 <= [vfLength] <= [max],
/// and [vfLength] is a multiple of of values size in bytes ([eSize]),
/// i.e. `vfLength % eSize == 0`.
bool __isValidVFL(int vfLength, int max, int eSize) =>
    (_inRange(vfLength, 0, max) && (vfLength % eSize == 0)) ? true : false;

Null _badVFL(StringBuffer sb, int vfLength, int maxVFLength, int eSize,
    [Issues issues]) {
  final sb = new StringBuffer('Invalid VFL($vfLength):\n');
  if (vfLength > maxVFLength)
    sb.writeln('\t$vfLength exceeds maximum($maxVFLength)');
  if (eSize != null && vfLength % eSize == 0)
    sb.writeln('$vfLength is not a multiple of element size($eSize)');
  return badValueField('$sb');
}

Null badFixedVFLength(int vfLength, int maxVFLength, int eSize,
    [Issues issues]) {
  final sb = new StringBuffer('Invalid Value Field Length($vfLength):\n');
  return _badVFL(sb, vfLength, maxVFLength, eSize, issues);
}

bool invalidFixedVFLength(int vfLength, int maxVFLength, int eSize,
    [Issues issues]) {
  badFixedVFLength(vfLength, maxVFLength, eSize, issues);
  return false;
}

bool invalidVFLength(int vfLength, int maxVFLength, [Issues issues]) {
  badFixedVFLength(vfLength, maxVFLength, null, issues);
  return false;
}

Null badUVFLength(int vfLength, int maxVFLength, int eSize,
    [Issues issues]) {
  final sb = new StringBuffer('Invalid Value Field Length($vfLength):\n');
  return _badVFL(sb, vfLength, maxVFLength, eSize, issues);
}

bool invalidUVFLength(
    int vfLength, int maxVFLength, int eSize, [Issues issues]) {
  badUVFLength(vfLength, maxVFLength, eSize, issues);
  return false;
}

bool isValidTagAux(Tag tag, Issues issues, int targetVRIndex, Type type) =>
    (tag != null && tag.vrIndex == targetVRIndex)
        ? true
        : invalidTag(tag, issues, type);
