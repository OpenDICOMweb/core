// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/date_time/primitives/date.dart';

/// Calculates the kDefaultMinEpochDay and kDefaultMaxEpochDay for System;
void main() {
  //TODO: what should these values be?
  /// const int defaultMinYear = -1000000;
  // const int defaultMaxYear = 1000000;
  const kDefaultMinYear = 0;
  const kDefaultMaxYear = 2050;
  final kDefaultMinEpochMicroseconds = dateToEpochMicroseconds(kDefaultMinYear, 1, 1);
  final kDefaultMaxEpochMicroseconds = dateToEpochMicroseconds(kDefaultMaxYear, 1, 1);

  final out = '''
  
  static const int kDefaultMinEpochDay = $kDefaultMinEpochMicroseconds;
  static const int kDefaultMaxEpochDay = $kDefaultMaxEpochMicroseconds;
  ''';

  print(out);
}
