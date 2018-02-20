// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// Methods to use with a DICOM Group, a 16-bit integer.
///
/// The [Group] methods expect their argument to be a 16-bit group number.
class Group {
  static const int kGroupMask = 0xFFFF0000;
  static const int shiftCount = 16;

  /// Groups numbers that shall not be used in PrivateTags.
  static const List<int> invalidPrivateGroups = const <int>[
    0x0001, 0x0003, 0x0005, 0x0007, 0xFFFF // Don't reformat
  ];

  /// Returns the most significant 16 bits of the tag.code.
  static int fromTag(int tagCode) => tagCode >> shiftCount;

  /// Returns _true_  if [g] is Public Group (even), or a valid Private Group.
  static bool isValid(int g) => g.isEven || isPrivate(g);

  /// Returns the Group Number is it is a valid Group Number.
  static int check(int g) => (isValid(g)) ? g : null;

  /// Returns_true_  is [g] is a valid Public Group Number.
  static bool isPublic(int g) => g.isEven && (0x0002 <= g && g <= 0xFFFC);

  static bool isNotPublic(int g) => !isPublic(g);

  /// Returns _true_  if [g] is a valid Private Group Number.
  static bool isPrivate(int g) => g.isOdd && (0x0007 < g && g < 0xFFFF);

  static bool isNotPrivate(int g) => !isPrivate(g);

  static int checkPrivate(int g) => (isPrivate(g)) ? g : null;
}
