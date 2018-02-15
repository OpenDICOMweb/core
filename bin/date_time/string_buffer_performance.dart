// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';

void main() {

  final t1 = new Timer();
  for (var y = 1950; y < 2050; y++)
    for (var m = 1; m < 13; m++)
      for (var d = 1; d < 32; d++)
        _dateToString1(y, m, d);
  t1.start();
  print('t1 elapsed: ${t1.elapsed}');

  final t2 = new Timer();
  for (var y = 1950; y < 2050; y++)
    for (var m = 1; m < 13; m++)
      for (var d = 1; d < 32; d++)
        _dateToString2(y, m, d);
  t2.start();
  print('t2 elapsed: ${t2.elapsed}');
}

String _dateToString1(int y, int m, int d, {bool asDicom = false}) {
  final yy = digits4(y);
  final mm = digits2(m);
  final dd = digits2(d);
  return (asDicom) ? '$yy$mm$dd' : '$yy-$mm-$dd';
}

String _dateToString2(int y, int m, int d, {bool asDicom = true}) {
  final sb = new StringBuffer(digits4(y));
  if (!asDicom)
    sb.write('-');
  sb.write(digits2(m));
  if (!asDicom)
    sb..write('-');
  sb.write(digits2(d));
  return sb.toString();
}
