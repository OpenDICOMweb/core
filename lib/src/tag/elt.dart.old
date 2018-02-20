// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: are all of these needed.  This would be faster if some were private.

/// Methods to use with a DICOM Elt (aka element), a 16-bit integer.
///
/// The [Elt] methods expect their argument to be a 16-bit tag.code.element number.
class Elt {
  static const int kElementMask = 0x0000FFFF;

  /// Returns the least significant 16 bits of the [tagCode].
  static int fromTag(int tagCode) => tagCode & kElementMask;

  /// Returns _true_ if [v] fits in 16-bits.
  static bool isValid(int v) => (0 <= v && v <= 0xFFFF) ? true : false;

  static int check(int v) => isValid(v) ? v : null;

  static bool isPrivateCreator(int elt) => 0x10 <= elt && elt <= 0xFF;

  static int pcBase(int pcElt) => (isPrivateCreator(pcElt)) ? pcElt << 8 : null;

  static int pcLimit(int pcElt) =>
      (pcElt == null) ? null : pcBase(pcElt) + 0xFF;

  static bool isPrivateData(int elt) => 0x1000 <= elt && elt <= 0xFFFF;

  static bool isValidPrivateData(int pdElt, int pcElt) {
    //  print('pd($pdElt), pc($pcElt)');
    if (pdElt == null) return false;
    final base = pcBase(pcElt);
    final limit = pcLimit(pcElt);
    //  print('base($base), limit($limit)');
    if (base == null || limit == null) return false;
    return pcBase(pcElt) <= pdElt && pdElt <= pcLimit(pcElt);
  }
}
