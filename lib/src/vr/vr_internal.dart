//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/element.dart';
import 'package:core/src/error/vr_errors.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/primitives.dart';

const int kShortVF = kMaxShortVF;
const int kLongVF = kMaxLongVF;

// ignore_for_file: Type_annotate_public_apis
class VR {
  /// Returns _true_ if [vrIndex] is equal to [target], which MUST be a valid
  /// _VR Index_. Typically, one of the constants (k_XX_Index) is used.
  static bool isValidIndex(int vrIndex, Issues issues, int target) =>
      (vrIndex == target) ? true : invalidVRIndex(vrIndex, issues, target);

  /// Returns _true_ if [vrIndex] is equal to [target], which MUST be a
  /// valid _VR Index_. Typically, one of the constants (k_XX_Index) is used,
  /// or a valid _Special VR Index_. This function is only used by [OB],
  /// [OW], [SS], and [US].
  static bool isValidSpecialIndex(int vrIndex, Issues issues, int target) {
    if (vrIndex == target ||
        (vrIndex >= kVRSpecialIndexMin && vrIndex <= kVRSpecialIndexMax))
      return true;
    return invalidVRIndex(vrIndex, issues, target);
  }

  /// [target] is a valid _VR Code_. One of the constants (k_XX_Index)
  /// is be used.
  static bool isValidCode(int vrCode, Issues issues, int target) =>
      (vrCode == target) ? true : invalidVRCode(vrCode, issues, target);

  /// [target] is a valid _VR Code_. One of the constants (k_XX_Index)
  /// is be used.
  static bool isValidSpecialCode(int vrCode, Issues issues, int target) {
    if (vrCode == target ||
        (vrCode >= kVRSpecialIndexMin && vrCode <= kVRSpecialIndexMax))
      return true;
    return invalidVRCode(vrCode, issues, target);
  }
}