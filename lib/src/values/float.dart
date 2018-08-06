// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/src/error/issues/issues.dart';
import 'package:core/src/global.dart';
import 'package:core/src/utils/parser.dart';

String hashDecimalString(String s, {Issues issues}) {
  final n = double.tryParse(s);
  if (n == null) return parseError('Invalid Decimal String: $s', issues);
  final sign = (Global.rng.nextBool()) ? -1 : 1;
  final hash = sign * Global.rng.nextDouble();
  return hash.toString();
}

Iterable<String> hashDecimalStringList(List<String> sList, {Issues issues}) =>
    sList.map((s) => hashDecimalString(s, issues: issues));

