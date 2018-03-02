// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/src/utils/logger/log_record.dart';

/// Base class for [LogRecord] transformers.
/// Implements the identify transform [LogRecord] -> [LogRecord].
class Transformer {

  Transformer();

  dynamic call(LogRecord record) => record;

  @override
  String toString() => 'Log Transformer($runtimeType)';

}
