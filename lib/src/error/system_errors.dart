//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/system.dart';

// ignore_for_file: public_member_api_docs

/// System related errors.

/// Read Error
class ReadError extends Error {
  /// The error message
  final String msg;

  ReadError(this.msg);

  @override
  String toString() => message(msg);

  static String message(String msg) => 'ReadError: $msg';
}

void readError(String msg) {
  log.error(ReadError.message(msg));
  if (throwOnError)
    throw ReadError(msg);
  return null;
}




