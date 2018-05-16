//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';

import 'package:core/src/element/primitives/code.dart';

bool isValidSubgroup(int subgroup) => subgroup >= 0x10 && subgroup <= 0xFF;

int getCreatorSubgroup(int code) {
  assert(isPrivateCreatorCode(code));
  final sg = (code & 0xFF);
  return isValidSubgroup(sg) ? sg : null;
}

bool isInSubgroup(int code, int subgroup) =>
    isValidSubgroup(subgroup) ? getCreatorSubgroup(code) == subgroup : false;

bool isPrivateGroupLengthCode(int code) {
  assert(isValidCode(code));
  return (code & kPGMask) == 0x10000;
}

bool isPrivateCreatorCode(int code) {
  assert(isValidCode(code));
  return isValidSubgroup(code & kPGMask);
}

bool isNotPrivateCreatorCode(int code) => !isPrivateCreatorCode(code);

bool isPrivateDataCode(int code) {
  assert(isValidCode(code));
  final subgroup = (code & kPGMask);
  return subgroup >= 0x11000 && subgroup <= 0x1FFFF;
}

int getPCCode(int pdCode) {
  assert(isPrivateDataCode(pdCode));
  final pcCode = pdCode >> 16 + (pdCode & 0xFF00) >> 8;
  assert(isPrivateCreatorCode(pcCode));
  return pcCode;
}

String getPrivateCreatorName(Dataset ds, int pdCode) {
  assert(isPrivateDataCode(pdCode));
  final pcCode = getPCCode(pdCode);
  final e = ds.lookup(pcCode);
  if (e == null) return null;
  return (e.isPrivateCreator) ? e.asString : badPrivateCreatorElement(e);
}

class InvalidElement extends Error {

}

Null badPrivateCreatorElement(Element e) {

}







