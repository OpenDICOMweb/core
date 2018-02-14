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
import 'package:core/src/logger/log_level.dart';
import 'package:core/src/system/system.dart';

List<Element> normalizeDates(TagRootDataset rds, Date enrollment) {
  final old = <Element>[];

  final fmi = rds.fmi;
  for (var e in fmi) {
    if (e is DA) {
      final eNew = e.normalize(enrollment);
      if (system.level == Level.debug) {
        print('**** Normalizing FMI Dates');
        printNormalized(e, eNew, enrollment);
      }
      fmi.replaceValues<String>(e.index, eNew);
      old.add(e);
    }
  }

  for (var e in rds) {
    if (e is DA) {
      final eNew = e.normalize(enrollment);
      if (system.level == Level.debug) {
        print('**** Normalizing Dataset Dates');
        printNormalized(e, eNew, enrollment);
      }
      rds.elements.replaceValues<String>(e.index, eNew.values);
      old.add(e);
    }
  }
  print('old: (${old.length})$old');
  return old;
}

void printNormalized(DA eOld, DA eNew, Date enrollment) {
  final acr = Date.acrBaseline;
  final enroll = enrollment.microseconds;
  final diff = enroll - acr;
  final oDates = eOld.dates;
  final nDates = eNew.dates;
  final oDay = oDates.elementAt(0).epochDay;
  final nDay = nDates.elementAt(0).epochDay;
  print('''   
  eOld: $eOld
  eNew: $eNew
  diff: uSecs $diff days ${diff ~/ kMicrosecondsPerDay}
   old: $oDates $oDay
   new: $nDates $nDay
  diff: ${oDay - nDay}
''');
}
