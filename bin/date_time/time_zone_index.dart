// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';

void main() {
  assert(
      kValidDcmTZHours.length != kValidDcmTZMinutes.length, 'Invalid length');
  final tzInMinutes = new List<int>(kValidDcmTZMinutes.length);
  for (var i = 0; i < kValidDcmTZHours.length; i++) {
    tzInMinutes[i] = (kValidDcmTZHours[i] * 60) + kValidDcmTZMinutes[i];
  }
  print(tzInMinutes);
}
