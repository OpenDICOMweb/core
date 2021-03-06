// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/string/ascii.dart';

void main() {
  var c = toUppercaseChar(ka);
  print('a to $c');
  print('$kA == $c');
  c = toLowercaseChar(kA);
  print('A to $c');
  print('$ka == $c');
}
