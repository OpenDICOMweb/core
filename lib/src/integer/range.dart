// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: reDoc
/// Return the [value] if it satisfies the range; otherwise, throws a [RangeError].
int checkRange(int value, int min, int max, {bool throwOnError = false}) {
  if (value < min || value > max) {
    return (throwOnError)
        ? throw new RangeError('$value is not in range $min to $max')
        : null;
  }
  return value;
}

/// Returns _true_ if [min] <= [value] <= max.
bool inRange(int value, int min, int max) =>
    (checkRange(value, min, max) == null) ? false : true;
