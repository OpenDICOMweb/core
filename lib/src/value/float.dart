// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/src/system/system.dart';
import 'package:core/src/utils/issues.dart';
import 'package:core/src/utils/parser.dart';

String hashDecimalString(String s, {Issues issues}) {
  final n = double.parse(s, _onHashDecimalError);
  if (n == null) return parseError('Invalid Decimal String: $s', issues);
  final sign = (System.rng.nextBool()) ? -1 : 1;
  final hash = sign * System.rng.nextDouble();
  return hash.toString();
}

// ignore: avoid_returning_null,
double _onHashDecimalError(String s) => null;

Iterable<String> hashDecimalStringList(List<String> sList, {Issues issues}) =>
    sList.map((s) => hashDecimalString(s, issues: issues));

