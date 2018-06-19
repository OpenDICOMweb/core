//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/error/issues.dart';
import 'package:core/src/global.dart';

/// A class for handling string errors.
class StringError extends Error {
  String msg;

  StringError(this.msg);

  @override
  String toString() => msg;
}

Null _doStringError(String msg, Issues issues) {
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new StringError(msg);
  return null;
}

/// General [Error] message for [String]s. Returns _null_.
Null badString(String message, [Issues issues]) {
  final msg = 'StringError: $message';
  return _doStringError(msg, issues);
}

/// General [Error] message for [String]s. Returns _false_.
bool invalidString(String message, [Issues issues]) {
  badString(message, issues);
  return false;
}

Null badStringLength(String s, [Issues issues, int start, int end]) {
  final msg = 'Invalid Length: "$s", start($start), end($end)';
  return badString(msg);
}

/// An invalid [String.length] [Error], returning _false_.
bool invalidStringLength(String s, [Issues issues, int start, int end]) {
  badStringLength(s, issues);
  return false;
}

Null badAgeString(String message, [Issues issues]) {
  badString('InvalidAgeStringError: $message');
  return null;
}

int badAgeParse(String message, [Issues issues]) {
  badString('InvalidAgeStringError: $message');
  return -1;
}

bool invalidAgeString(String msg, [Issues issues]) {
  badAgeString(msg, issues);
  return false;
}

Null badDateString(String message, [Issues issues]) {
  badString('InvalidDateStringError: $message', issues);
  return null;
}

bool invalidDateString(String message, [Issues issues]) {
  badDateString(message, issues);
  return false;
}

Null badTimeString(String message, [Issues issues]) =>
    badString('InvalidTimeStringError: $message');

bool invalidTimeString(String message, [Issues issues]) {
  badTimeString(message, issues);
  return false;
}

Null badTimeZoneString(String message, [Issues issues]) =>
    badString('InvalidTimeZoneStringError: $message');

Null invalidTimeZoneString(String message, [Issues issues]) {
  badTimeZoneString(message, issues);
  return null;
}

Null badDateTimeString(String message, [Issues issues]) =>
    badString('InvalidDateTimeStringError: $message');

bool invalidDcmDateTimeString(String message, [Issues issues]) {
  badDateTimeString(message, issues);
  return false;
}

/// An invalid character in [String] [Error], returning _null_.
Null badCharacterInString(String s, int index, [Issues issues]) {
  final char = s[index];
  final unit = s.codeUnitAt(index);
  final msg = 'InvalidCharacter: "$char" ($unit) at index($index) in "$s"';
  return badString(msg);
}

/// An invalid character in [String] [Error], returning _false_.
bool invalidCharacterInString(String s, int index, [Issues issues]) {
  badCharacterInString(s, index, issues);
  return false;
}

/// An invalid [Uri] [String] [Error], returning _null_.
Null badUriString(String message, [Issues issues]) =>
    badString('InvalidUriStringError: $message');

/// An invalid [Uri] [String] [Error], returning _false_.
bool invalidUriString(String message, [Issues issues]) {
  badUriString(message, issues);
  return false;
}

/// An invalid [Uuid] [String] [Error], returning _null_.
Null badUuidString(String message, [Issues issues]) =>
    badString('InvalidUuidStringError: $message');

/// An invalid [Uuid] [String] [Error], returning _false_.
bool invalidUuidString(String uuid, [Issues issues]) {
  final msg = 'Invalid Uuid String Error: "$uuid"';
  return _doStringError(msg, issues);
}

Null badUuidStringLength(String s, int targetLength, [Issues issues]) {
  final msg = 'Invalid String length(${s.length} should be $targetLength';
  return _doStringError(msg, issues);
}

Null badUuidNullString([Issues issues]) {
  const msg = 'Invalid null string';
  return _doStringError(msg, issues);
}

Null badUuidCharacter(String s, [String char, Issues issues]) =>
    _doStringError('Invalid character in String: "$char"', issues);

Null badUuidParse(String s, int targetLength, [Issues issues]) {
  if (s == null) return badUuidNullString();
  if (s.length != targetLength) return badUuidStringLength(s, targetLength);
  return _doStringError('"$s"', issues);
}

/// General [Error] message for [String]s. Returns _null_.
Null badStringList(String message, [Issues issues]) {
  final msg = 'StringListError: $message';
  return _doStringError(msg, issues);
}

/// General [Error] message for [String]s. Returns _null_.
bool invalidStringList(String message, [Issues issues]) {
  final msg = 'StringListError: $message';
  badStringList(msg, issues);
  return false;
}
