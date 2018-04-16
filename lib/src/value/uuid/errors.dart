//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/system/system.dart';
import 'package:core/src/utils/issues.dart';

class UuidError extends Error {
  String msg;

  UuidError(this.msg);

  @override
  String toString() => 'InvalidUuidListError: $msg';
}

class InvalidUuidListError extends Error {
  List<int> bytes;
  String msg;

  InvalidUuidListError(this.bytes, this.msg);

  @override
  String toString() => message(msg, bytes);

  static String message(String msg, List<int> bytes) =>
      'InvalidUuidListError: $msg: $bytes';
}

Uint8List invalidUuidListError(List<int> iList, String msg) {
  log.error(msg);
  if (throwOnError) throw new InvalidUuidListError(iList, msg);
  return null;
}

Uint8List invalidUuidStringLengthError(String s, int targetLength, [Issues issues]) {
  final msg = 'Invalid String length(${s.length} should be $targetLength';
  return _doUuidError(msg, issues);
}

Uint8List invalidUuidNullStringError([Issues issues]) {
  const msg = 'Invalid null string';
  return _doUuidError(msg, issues);
}

Uint8List invalidUuidCharacterError(String s, [String char, Issues issues]) =>
    _doUuidError('Invalid character in String: "$char"', issues);

Uint8List invalidUuidParseToBytesError(String s, int targetLength, [Issues issues]) {
  if (s == null) return invalidUuidNullStringError();
  if (s.length != targetLength) return invalidUuidStringLengthError(s, targetLength);
  return _doUuidError('"$s"', issues);
}

Null invalidUuidString(String uuid, [Issues issues]) {
  final msg = 'Invalid Uuid String Error: "$uuid"';
  return _doUuidError(msg, issues);
}

Null invalidUuid(Object uuid, [Issues issues]) {
  final msg = 'Invalid Uuid Error: "$uuid"';
  return _doUuidError(msg, issues);
}

class InvalidUuidError extends Error {
  String msg;

  InvalidUuidError(this.msg);

  @override
  String toString() => '$msg';
}

Null _doUuidError(String msg, Issues issues) {
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidUuidError(msg);
  return null;
}

