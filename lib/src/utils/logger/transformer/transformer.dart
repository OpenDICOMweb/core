//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/logger/log_record.dart';

// ignore_for_file: public_member_api_docs

/// Base class for [LogRecord] transformers.
/// Implements the identify transform [LogRecord] -> [LogRecord].
class Transformer {
  Transformer();

  Object call(LogRecord record) => record;

  @override
  String toString() => 'Log Transformer($runtimeType)';
}
