// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';

void main() {
  final v = Uid.isDicom(TransferSyntax.kDeflatedExplicitVRLittleEndian);
  print('V: $v');

}