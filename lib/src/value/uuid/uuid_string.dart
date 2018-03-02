// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/utils/ascii.dart';
import 'package:core/src/value/uuid/errors.dart';

// **** String functions for UUID [String]s.

// Uuid constants
const int kUuidStringLength = 36;
const int kUuidAsUidStringLength = 32;

// Regular expression used for basic parsing of the uuid.
const String pattern =
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-4][0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}$';

// General pattern is:
//   xxxxxxxx-xxxx-Vxxx-Nxxx-xxxxxxxxxxxx
//   dashes |8   |13  |18  |23
// where V is version, and N is node.

/// The offsets of the 4 dashes in a UUID [String}.
const List<int> kDashes = const <int>[8, 13, 18, 23];

/// The offsets of the start of the hex values in a UUID [String].
const List<int> kStarts = const <int>[0, 9, 14, 19, 24];

/// The offsets of the end of the hex values in a UUID [String].
const List<int> kEnds = const <int>[8, 13, 18, 23, kUuidStringLength];

/// The ASCII value for the dash (-) character.
//const int kDash = 0x2D;


// Returns _true_ if [uuidString] is a valid [Uuid]. If [type] is _null_
/// it just validates the format; otherwise, [type] must have a value
/// between 1 and 5.
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
  return (type == null) ? true : _isValidStringVersion(s, type);
}

/// Returns _true_
bool _isValidStringVersion(String s, int version) {
  if (version < 1 || version > 5)
    invalidUuidString('Invalid version number: $version');
  final _version = _getVersionNumberFromString(s);
  if (!_isISOVariantFromString(s) || _version != version) return false;
  // For certain versions, the checks we did up to this point are fine.
  if (_version != 3 || _version != 5) return true;
  throw new UnimplementedError('Version 3 & 5 are not yet implemented');
}

int _getVersionNumberFromString(String s) => s.codeUnitAt(14) - k0;

const List<int> _kISOVariantAsLetter = const <int>[k8, k9, ka, kb];

bool _isISOVariantFromString(String s) {
  final subType = s.codeUnitAt(19);
  return _kISOVariantAsLetter.contains(subType);
}
