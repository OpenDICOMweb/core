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


// ignore_for_file: public_member_api_docs
// ignore_for_file: prefer_void_to_null

bool _inRange(int v, int min, int max) => v >= min && v <= max;

//TODO move to Float64, Float32, etc.
int vfLengthToLength(int vfLengthField, int sizeInBytes) {
  final length = vfLengthField ~/ sizeInBytes;
  assert(vfLengthField >= 0 && vfLengthField.isEven,
      'vfLengthField: $vfLengthField');
  assert((vfLengthField % sizeInBytes) == 0,
      'vflf: $vfLengthField sizeInBytes $sizeInBytes');
  return length;
}

/// Returns _true_  if [vfLength] is a valid Value Field length.
bool isValidFixedVFL(int vfLength, int maxVFLength, int eSize,
    [Issues issues]) {
  final ok = vfLength >= 0 && vfLength <= maxVFLength;
  return ok ? ok : invalidFixedVFLength(vfLength, maxVFLength, eSize, issues);
}

/// Checks that vfLength (vfl) is in range and the right size, based on the
/// element size (eSize).
bool isValidFixedVFLength(int vfl, int max, int eSize, Issues issues) {
  final ok = _inRange(vfl, 0, max) && (vfl % eSize == 0);
  return ok ? ok : invalidFixedVFLength(vfl, max, eSize, issues);
}

Null _badVFL(StringBuffer sb, int vfLength, int maxVFLength, int eSize,
    [Issues issues]) {
  final sb = StringBuffer('Invalid VFL($vfLength):\n');
  if (vfLength > maxVFLength)
    sb.writeln('\t$vfLength exceeds maximum($maxVFLength)');
  if (eSize != null && vfLength % eSize == 0)
    sb.writeln('$vfLength is not a multiple of element size($eSize)');
  return badValueField('$sb');
}

Null badFixedVFLength(int vfLength, int maxVFLength, int eSize,
    [Issues issues]) {
  final sb = StringBuffer('Invalid Value Field Length($vfLength):\n');
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

Null badUVFLength(int vfLength, int maxVFLength, int eSize, [Issues issues]) {
  final sb = StringBuffer('Invalid Value Field Length($vfLength):\n');
  return _badVFL(sb, vfLength, maxVFLength, eSize, issues);
}

bool invalidUVFLength(int vfLength, int maxVFLength, int eSize,
    [Issues issues]) {
  badUVFLength(vfLength, maxVFLength, eSize, issues);
  return false;
}

bool isValidTagAux(Tag tag, Issues issues, int targetVRIndex, Type type) {
  if (tag != null && tag.vrIndex == targetVRIndex) return true;
  return invalidTag(tag, issues, type);
}
