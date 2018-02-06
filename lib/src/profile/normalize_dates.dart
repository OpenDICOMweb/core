// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/date_time/date.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/string.dart';

List<Element> normalizeDates(RootDataset rds, Date enrollment) {
  final old = <Element>[];
  final fmi = rds.fmi;
  final elements = rds.elements;

  for(var e in fmi) {
    if (e is DA) {
      print('e: $e');
      final strings = e.values;
      final dates = e.dates;
      for(var date in dates) {
        final eNew = e.normalize(enrollment);
        print('eNew: $eNew');
        print('eNew.values: ${eNew.values}');
        elements.update<String>(e.index, eNew.values);
        fmi.update(e.index, eNew);
      }
      old.add(e);
    }
  }

  for(var e in elements) {
    if (e is DA) {
      print('e: $e');
      final strings = e.values;
      print('values: $strings');
      final dates = e.dates;
      print('dates: $strings');
      for(var date in dates) {
        final eNew = e.normalize(enrollment);
        print('eNew: $eNew');
        print('eNew.values: ${eNew.values}');
        elements.update<String>(e.index, eNew.values);
        fmi.update(e.index, eNew);
      }
      old.add(e);
    }
  }
  return old;
}