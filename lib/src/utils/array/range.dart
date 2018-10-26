// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

/// Returns a [List<int}] from [start] to [end] by [step].
List<int> iRange(int start, int end, [int step = 1]) {
  final result = <int>[];
  var v = start;
  for (var i = start; i < end; i += step) {
    result.add(v);
    v += step;
  }
  return result;
}