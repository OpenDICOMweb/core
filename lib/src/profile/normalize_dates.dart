// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/date_time/date.dart';
import 'package:core/src/date_time/primitives/constants.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/logger/log_level.dart';
import 'package:core/src/profile/de_id/deid_dates.dart';
import 'package:core/src/system/system.dart';

/// Normalize all [Date]s in [RootDataset]. The _normalized_ [Date]
/// is base on the [enrollment] [Date].
///
/// _Note_: There are no Dates in FMI, so it is not changed.
List<Element> normalizeDates(RootDataset rds, Date enrollment) {
  final old = <Element>[];

  for (var e in rds) {
    if (e is DA) {
      final eNew = e.normalize(enrollment);
      if (system.level == Level.debug) {
        printNormalized(e, eNew, enrollment);
      }
      rds.replaceValues<String>(e.index, eNew.values);
      old.add(e);
    }
  }
  print('old: (${old.length})$old');
  return old;
}

/// Normalize the de-identification [Date]s specified in PS3.15
/// in [RootDataset]. The _normalized_ [Date] is base on the
/// [enrollment] [Date].
///
/// _Note_: There are no Dates in FMI, so it is not changed.
List<Element> normalizeDeIdDates(RootDataset rds, Date enrollment) {
  final old = <Element>[];
  for (var code in deIdDateCodes) {
    final DA e = rds.lookup(code);
    if (e != null) {
      final eNew = e.normalize(enrollment);
      rds.replace(e.index, eNew);
      old.add(e);
    }
  }
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
Normalizing Dataset Dates:
  eOld: $eOld
  eNew: $eNew
  diff: uSecs $diff days ${diff ~/ kMicrosecondsPerDay}
   old: $oDates $oDay
   new: $nDates $nDay
  diff: ${oDay - nDay}
''');
}
