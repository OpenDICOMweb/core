//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils.dart';
import 'package:core/src/utils/bytes/bytes.dart';

abstract class BufferBase {
  // **** Interface
  /// The underlying [Bytes] for the buffer.
  Object get _buf;

  int get _rIndex;
  set _rIndex(int n);
  int get _wIndex;
  set _wIndex(int n) => unsupportedError();
}

