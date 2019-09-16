//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils.dart';

/// Useful utilities for working with [Uid] [String]s.

///  The minimum length of a UID [String].
const int kUidMinLength = 6;

///  The maximum length of a UID [String].
const int kUidMaxLength = 64;

///  The maximum length of a UID Root [String].
const int kUidMaxRootLength = 24;

// **** Do not remove ****
//const _uidRegExpString = r'[012]((\.0)|(\.[1-9]+\d*))+';
//final RegExp _uidRegex = new RegExp(_uidRegExpString);

bool _isValidLength(int length) =>
    kUidMinLength <= length && length <= kUidMaxLength;

/// Returns [s] if it is a valid [Uid] [String]; otherwise, _null_.
bool isValidUidString(String s) {
  if (s == null || !_isValidLength(s.length) || !kUidRoots.contains(s[0]))
    return false;
  final s0 = cleanUidString(s);
  final length = s0.length;
  for (var i = 0; i < length - 1; i++) {
    final char0 = s0.codeUnitAt(i);
    if (char0 == kDot) {
      if (s0.codeUnitAt(i + 1) == k0) {
        if (i + 2 >= length) return true;
        if (s0.codeUnitAt(i + 2) != kDot) return false;
      }
    } else {
      if (!isDigitChar(char0)) return false;
    }
  }
  if (!isDigitChar(s0.codeUnitAt(length - 1))) return false;
  return true;
}

// to make sure no string such as 2.25.0...'
// return false
/// Returns _true_ if [s] is a valid UuidUid String.
///
/// Valid UuidUid Strings have the format 2.25._xy...y_ where _x_ is any
/// non-zero decimal digit and _y...y_ is a String of decimal digits with
/// length less than 39.
///
/// See http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_B.2
bool isValidUuidUid(String s) {
  if (s.indexOf(randomUuidUidRoot) != 0) return false;
  final uidPart = s.substring(5);
  final len = uidPart.length;
  if (len < 2 || len > 39) return false;

  // Check the first character is not '0'
  var char = uidPart.codeUnitAt(0);
  if (char == kDigit0 || char < kDigit1 || char > kDigit9) return false;

  // Check that subsequent characters are digits.
  for (var i = 1; i < len; i++) {
    char = uidPart.codeUnitAt(i);
    if (char < kDigit0 || char > kDigit9) return false;
  }
  return true;
}

/// Returns true if each [String] in the [List] is a valid DICOM UID.
bool isValidUidStringList(List<String> sList) {
  if (sList == null) return false;
  for (final s in sList) if (!isValidUidString(s)) return false;
  return true;
}

/// ASCII constants for '0', '1', and '2'. No other roots are valid.
const List<String> kUidRoots = <String>['0', '1', '2'];

/// The first five characters of a
const String randomUuidUidRoot = '2.25.';

/// A [Map] containing the names associated with the three UID\(OID\)
/// initial integers.
const Map<int, String> kUidRootType = <int, String>{
  0: 'ITU-T',
  1: 'ISO',
  2: 'joint-iso-itu-t'
};

//TODO: Decide if this is useful
/// A [Map] of some common UID\(OID\) root [String]s.
const Map<String, String> oidRoots = <String, String>{
  '1.2.840': 'United States of America',
  '1.16.840': 'United States of America',
  '1.2.840.': 'United States of America',
  '1.2.840.10008': 'DICOM Standard',
  '1.3.6.1': 'Internet',
  '1.3.6.1.4.1': 'IANA assigned company OIDs',
  '2.25': 'itu-iso UUID'
};

const int _kNull = 0;
const int _kSpace = 32;

/// Removes trailing null and also removes leading and trailing spaces.
String cleanUidString(String s) {
  final length = s.length;
  var start = 0;
  for (; start < length; start++) if (s.codeUnitAt(start) != _kSpace) break;

  final last = s.length - 1;
  var end = last;
  if (s.codeUnitAt(last) == _kNull) end--;

  for (; end > start; end--) if (s.codeUnitAt(end) != _kSpace) break;
  return (start == 0 && end == last) ? s : s.substring(start, end + 1);
}
