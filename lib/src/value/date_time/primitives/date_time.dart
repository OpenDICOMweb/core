// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/src/system/system.dart';
import 'package:core/src/utils/string.dart';

///Returns a human-readable string for the date part of [dt].
String dtToDateString(DateTime dt, {bool asDicom = true}) {
  final y = digits4(dt.year);
  final m = digits2(dt.month);
  final d = digits2(dt.day);
  return (asDicom) ? '$y$m$d' : '$y-$m-$d';
}

///Returns a human-readable string for the time part of [dt].
String dtToTimeString(DateTime dt,
                      {bool asDicom = true, bool showFraction = false}) {
  final h = digits2(dt.hour);
  final m = digits2(dt.minute);
  final s = digits2(dt.second);
  final ms = digits3(dt.millisecond);
  final us = digits3(dt.microsecond);
  if (showFraction) {
    return (asDicom) ? '$h$m$s.$ms$us' : '$h:$m:$s.$ms$us';
  } else {
    return (asDicom) ? '$h$m$s' : '$h:$m:$s';
  }
}

///Returns a human-readable string for [dt] in Internet format.
String dtToDateTimeString(DateTime dt,
                          {bool asDicom = true, bool showFraction = false}) =>
    (asDicom)
    ? '${dtToDateString(dt)}${dtToTimeString(dt)}'
    : '${dtToDateString(dt, asDicom: asDicom)}'
        '${system.dateTimeSeparator}'
        '${dtToTimeString(dt, asDicom: asDicom, showFraction: showFraction)}';


