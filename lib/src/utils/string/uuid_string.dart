//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error/string_errors.dart';
import 'package:core/src/utils/character/ascii.dart';

/// UUID [String]s. See https://tools.ietf.org/html/rfc4122.

/// The length of a standard UUID [String].
const int kUuidStringLength = 36;

/// The length of a DICOM UUID UID [String].
const int kUuidAsUidStringLength = 32;

/// Regular expression used for basic parsing of the uuid.
const String pattern =
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-4][0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}$';

// General pattern is:
//   xxxxxxxx-xxxx-Vxxx-Nxxx-xxxxxxxxxxxx
//   dashes |8   |13  |18  |23
// where V is version, and N is node.

/// The offsets of the 4 dashes in a UUID [String}.
const List<int> kDashes = <int>[8, 13, 18, 23];

/// The offsets of the start of the hex values in a UUID [String].
const List<int> kStarts = <int>[0, 9, 14, 19, 24];

/// The offsets of the end of the hex values in a UUID [String].
const List<int> kEnds = <int>[8, 13, 18, 23, kUuidStringLength];


/// Returns _true_ if [uuidString] is a valid UUID [String]. If [type]
/// is _null_ it just validates the format; otherwise, [type] must have
/// a value between 1 and 5.
bool isValidUuidString(String uuidString, [int type]) {
  if (uuidString.length != kUuidStringLength) return false;
  for (var pos in kDashes)
    if (uuidString.codeUnitAt(pos) != kDash) return false;
  final s = uuidString.toLowerCase();
  for (var i = 0; i < kStarts.length; i++) {
    final start = kStarts[i];
    final end = kEnds[i];
    for (var j = start; j < end; j++) {
      final c = s.codeUnitAt(j);
      if (!isHexChar(c)) return false;
    }
  }
  if (type != null) return _isValidStringVersion(s, type);
  return true;
}

/// Returns _true_ if the version of the UUID [String] are equal to [version].
bool _isValidStringVersion(String s, int version) {
  if (version < 1 || version > 5)
    invalidUuidString('Invalid version number: $version');
  final _version = _getVersionNumberFromString(s);
  if (!_isISOVariantFromString(s) || _version != version) return false;
  // For certain versions, the checks we did up to this point are fine.
  if (_version != 3 || _version != 5) return true;
  throw UnimplementedError('Version 3 & 5 are not yet implemented');
}

int _getVersionNumberFromString(String s) => s.codeUnitAt(14) - kDigit0;

bool _isISOVariantFromString(String s) {
  final subType = s.codeUnitAt(19);
  return _kISOVariantAsLetter.contains(subType);
}

/// The ASCII values for the dash (-) character, 0x2D in ASCII or UTF8
const List<int> _kISOVariantAsLetter = <int>[k8, k9, ka, kb];

