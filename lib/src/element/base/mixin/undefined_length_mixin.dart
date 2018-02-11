// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/src/tag/constants.dart';

// OB, OW, UN, and SQ,
abstract class UndefinedLengthMixin {
  int get vfLengthField;

  bool get undefinedLengthAllowed => true;

  /// Returns _false_ for all elements except SQ, OB, OW and UN,
  /// Most Elements do not allow the kUndefinedLength value in
  /// Value Fields Lengths.
  bool get hadULength => vfLengthField == 0xFFFFFFFF;

  /// _Deprecated_: use [hadULength] instead.
  @deprecated
  bool get hadUndefinedLength => vfLengthField == kUndefinedLength;
}
