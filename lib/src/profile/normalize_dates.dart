// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/tag/tag_root_dataset.dart';
import 'package:core/src/date_time/date.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/tag/date_time.dart';

List<Element> normalizeDates(TagRootDataset rds, Date enrollment) {
  final old = <Element>[];
  final fmi = rds.fmi;
  final elements = rds.elements;

  for (var e in fmi) {
    if (e is DAtag) {
      print('e: $e');
      final strings = e.values;
      print('strings: $strings');
      final dates = e.dates;
      print('dates: $dates');

      final eNew = e.normalize(enrollment);
      print('eNew: $eNew');
      print('eNew.values: ${eNew.values}');

      elements.update<String>(e.index, eNew.values);
      fmi.update(e.index, eNew);
      old.add(e);
    }
  }

  for (var e in elements) {
    if (e is DAtag) {
      print('e: $e');
      final strings = e.values;
      print('strings: $strings');
      final dates = e.dates;
      print('dates: $dates');

      final eNew = e.normalize(enrollment);
      print('eNew: $eNew');
      print('eNew.values: ${eNew.values}');

      elements.update<String>(e.index, eNew.values);
      fmi.update(e.index, eNew);
      old.add(e);
    }
  }
  return old;
}
