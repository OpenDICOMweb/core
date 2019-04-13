//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error/issues/issues.dart';
import 'package:core/src/global.dart';

// ignore_for_file: public_member_api_docs
// ignore_for_file: prefer_void_to_null

class UuidError extends Error {
  String msg;

  UuidError(this.msg);

  @override
  String toString() => 'InvalidUuidListError: $msg';
}

Null badUuid(String message, [Issues issues]) {
  log.error(message);
  if (issues != null) issues.add(message);
  if (throwOnError) throw UuidError(message);
  return null;
}

Null badUuidList(String message, List<int> iList) {
  final msg = 'InvalidUuidListError: $message: $iList';
  log.error(msg);
  if (throwOnError) throw UuidError(msg);
  return null;
}

Null invalidUuid(Object uuid, [Issues issues]) {
  final msg = 'Invalid Uuid Error: "$uuid"';
  return _doUuidError(msg, issues);
}

Null _doUuidError(String msg, Issues issues) {
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw UuidError(msg);
  return null;
}
