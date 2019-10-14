//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:constants/constants.dart';
import 'package:core/src/element.dart';

// ignore_for_file: Type_annotate_public_apis

/// A representation of DICOM Value Representations (VRs).
/// _Note_: This class is internal to Core and should not be exported.
class VR {
  /// Returns _true_ if [vrIndex] is equal to [target], which MUST be a valid
  /// _VR Index_. Typically, one of the constants (k_XX_Index) is used.
  static bool isValidIndex(int vrIndex, int target) =>
      vrIndex == target || invalidVRIndex(vrIndex, target);

  /// Returns _true_ if [vrIndex] is equal to [target], which MUST be a
  /// valid _VR Index_. Typically, one of the constants (k_XX_Index) is used,
  /// or a valid _Special VR Index_. This function is only used by [OB],
  /// [OW], [SS], and [US].
  static bool isValidSpecialIndex(int vrIndex, int target) {
    if (vrIndex == target || isSpecialVRIndex(vrIndex)) return true;
    return invalidVRIndex(vrIndex, target);
  }

  /// [target] is a valid _VR Code_. One of the constants (k_XX_Index)
  /// is be used.
  static bool isValidCode(int vrCode, int target) {
    if (vrCode != target) return invalidVRCode(vrCode, target);
    return true;
  }

  /// [target] is a valid _VR Code_. One of the constants (k_XX_Index)
  /// is be used.
  static bool isValidSpecialCode(int vrCode, int target) {
    final vrIndex = vrIndexFromCode(vrCode);
    if (vrCode == target || isSpecialVRIndex(vrIndex)) return true;
    return invalidVRCode(vrCode, target);
  }
}