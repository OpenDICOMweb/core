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

// Urgent Jim: Replace all Tag code related functions throughout core
// Urgent Jim:  with functions from this file.

/// Primitive functions related to Tag Codes.

const int kMinGroupCode = 0x0009;
const int kMaxGroupCode = 0xFFFD;

bool isValidCode(int code) =>
    isValidPublicCode(code) || isValidPrivateCode(code);

int group(int code) => code >> 16;
//int elt(int code) => code & 0xFFFF;

// TODO: should this be 0x00020000
const int kMinTagCode = 0x00001000;
const int kMaxTagCode = 0xFFFCFFFC;
/// Returns_true_ if [code] is a valid Public Code, but
/// _does not check that [code] is defined by the DICOM Standard.
bool isPublicCode(int code) =>
    group(code).isEven && code >= kMinTagCode && code <= kMaxTagCode;

bool isNotPublicCode(int code) => !isPublicCode(code);

bool isValidPublicCode(int code) => PTag.lookupByCode(code) != null;

bool isGroupLengthCode(int code) => (code & 0xFFFF) == 0;
bool isPublicGroupLengthCode(int code) => (code & 0x1FFFF) == 0;
bool isPrivateGroupLengthCode(int code) => (code & 0x1FFFF) == 0x10000;

bool isPrivateCode(int code) => _isPrivateGroup(code);

bool _isPrivateGroup(int code) {
  final g = group(code);
  return g.isOdd && g >= kMinGroupCode && g <= kMaxGroupCode;
}


bool isInvalidPrivateCode(int code) {
  if (!_isPrivateGroup(code)) return true;
  final v = code & 0xFFFF;
  return v > 0x0000 && v < 0x0010;
}

bool isValidPrivateCode(int code) => !isInvalidPrivateCode(code);

// Here for testing only
bool isValidPrivateCodeTest(int code) {
  final v = code & 0x1FFFF;
  return (v >= 10010 && v <= 0x100FF) ||
      (v >= 0x11000 && v <= 0x1FFFF) ||
      v == 0x10000;
}

bool isPCCode(int code) {
  final v = code & 0x1FFFF;
  return v >= 0x10010 && v <= 0x100FF;
}

bool isPDCode(int code, [int creatorCode]) {
  if (creatorCode == null) {
    final v = code & 0x1FFFF;
    return v >= 0x11000 && v <= 0x1FFFF;
  } else {
    if (!isPrivateCode(creatorCode))
      return invalidPrivateCreatorTagCode(creatorCode);
    final group = creatorCode >> 16;

    if (group.isEven || code >> 16 != group) return false;
    final subgroup = pcSubgroup(creatorCode);
    if (subgroup < 0x10) return false;
    final sg = pdSubgroup(code);
    return sg == subgroup;
  }
}

int pcSubgroup(int creatorCode) => creatorCode & 0x00FF;
int pdSubgroup(int dataCode) => (dataCode & 0xFF00) >> 8;

