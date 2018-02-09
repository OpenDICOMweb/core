// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/tag/tag_root_dataset.dart';
import 'package:core/src/date_time/date.dart';
import 'package:core/src/date_time/primitives/constants.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/string.dart';

List<Element> normalizeDates(TagRootDataset rds, Date enrollment) {
  final old = <Element>[];
  final fmi = rds.fmi;
  final elements = rds.elements;

  print('**** Normalizing FMI Dates');
  for (var e in fmi) {
    if (e is DA) {
      print('  e: $e');
      final strings = e.values;
      print('    strings: $strings');
      final dates = e.dates;
      print('    dates: $dates');

      final eNew = e.normalize(enrollment);
      print('  eNew: $eNew');
      print('    eNew.dates: ${eNew.dates}');

      elements.update<String>(e.index, eNew.values);
      fmi.update(e.index, eNew);
      old.add(e);
    }
  }

  print('**** Normalizing Dataset Dates');
  final acr = Date.acrBaseline;
  final enroll = enrollment.microseconds;
  final diff = enroll - acr;
  print('diff: $diff US ${diff ~/ kMicrosecondsPerDay}');
  for (var e in elements) {
    if (e is DA) {
      print('  e: $e');
//      final strings = e.values;
//    print('    strings: $strings');
      final oDates = e.dates;
      final oDay = oDates.elementAt(0).epochDay;
      print('    old: $oDates $oDay');

      final eNew = e.normalize(enrollment);
      final nDates = eNew.dates;
      final nDay = nDates.elementAt(0).epochDay;
 //     print('  eNew: $eNew');
      print('    new: ${eNew.dates} $nDay');
      print('   diff: ${oDay - nDay}');

      elements.update<String>(e.index, eNew.values);
      fmi.update(e.index, eNew);
      old.add(e);
    }
  }
  print('old: (${old.length})$old');
  return old;
}
