//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/vr.dart';

bool isValidValueLength(
    String value, Issues issues, int minLength, int maxLength) {
  if (value == null) {
    if (issues != null) issues.add('Invalid null values');
    return false;
  }
  final length = value.length;
  if (length < minLength || length > maxLength) {
    if (issues != null) {
      if (length < minLength)
        issues.add('Invalid Value($value) under minimum($minLength)');
      if (length < minLength)
        issues.add('Invalid Value($value) over maximum($maxLength)');
    }
    return false;
  }
  return true;
}

/// Returns _true_ if [tag].vrIndex is equal to [targetVR], which MUST
/// be a valid _VR Index_. Typically, one of the constants (k_XX_Index)
/// is used.
bool isValidTag(Tag tag, Issues issues, int targetVR, Type type) =>
    (doTestElementValidity && tag.vrIndex != targetVR)
        ? invalidTag(tag, issues, type)
        : true;

/// Returns _true_ if [vrIndex] is equal to [target], which MUST be a valid
/// _VR Index_. Typically, one of the constants (k_XX_Index) is used.
bool isValidVRIndex(int vrIndex, Issues issues, int target) =>
    (vrIndex == target) ? true : VR.invalidIndex(vrIndex, issues, target);

/// Returns [vrIndex] if it is equal to [target], which MUST be a valid
/// _VR Index_. Typically, one of the constants (k_XX_Index) is used.
int checkVRIndex(int vrIndex, Issues issues, int target) =>
    (vrIndex == target) ? vrIndex : VR.badIndex(vrIndex, issues, target);

/// [target] is a valid _VR Code_. One of the constants (k_XX_Index)
/// is be used.
bool isValidVRCode(int vrCode, Issues issues, int target) =>
    (vrCode == target) ? true : VR.invalidCode(vrCode, issues, target);

/// Checks that vfLength (vfl) is in range and the right size, based on the
/// element size (eSize).
bool isValidVFL(int vfl, int max, [Issues issues]) =>
    (vfl >= 0 && vfl <= max) ? true : invalidStringVFLength(vfl, max, issues);

Null badStringVFLength(int vfLength, int maxVFLength, [Issues issues]) {
  final s = 'Invalid String VFL($vfLength): '
      '$vfLength exceeds maximum($maxVFLength)';

  return badValueField(s, null, issues);
}

bool invalidStringVFLength(int vfLength, int maxVFLength, [Issues issues]) {
  badStringVFLength(vfLength, maxVFLength, issues);
  return false;
}
