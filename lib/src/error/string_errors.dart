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
import 'package:core/src/values.dart';

// ignore_for_file: public_member_api_docs
// ignore_for_file: prefer_void_to_null

// Functions starting with 'bad...' return null
// Functions starting with 'invalid...' return false
// otherwise, they do the same thing

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
  if (throwOnError) throw StringError(msg);
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

/// [String.length] [Error] message. Returns _null_.
Null badStringLength(String s, [Issues issues, int start = 0, int end]) {
  end ??= s.length;
  final msg = 'Invalid Length: "$s", start($start), end($end)';
  return badString(msg);
}

/// [String.length] [Error] message. Returns _false_.
bool invalidStringLength(String s, [Issues issues, int start, int end]) {
  badStringLength(s, issues);
  return false;
}

/// Age String [Error] message. Returns _null_.
Null badAgeString(String message, [Issues issues]) {
  badString('InvalidAgeStringError: $message');
  return null;
}

/// [Age.parse] [Error] message. Returns _null_.
int badAgeParse(String message, [Issues issues]) {
  badString('InvalidAgeStringError: $message');
  return -1;
}

/// Age String [Error] message. Returns _false_.
bool invalidAgeString(String msg, [Issues issues]) {
  badAgeString(msg, issues);
  return false;
}

/// Date String [Error] message. Returns _null_.
Null badDateString(String message, [Issues issues]) {
  badString('InvalidDateStringError: "$message"', issues);
  return null;
}

/// Date String [Error] message. Returns _false_.
bool invalidDateString(String message, [Issues issues]) {
  badDateString(message, issues);
  return false;
}

/// Time String [Error] message. Returns _null_.
Null badTimeString(String message, [Issues issues]) =>
    badString('InvalidTimeStringError: $message');

/// Time String [Error] message. Returns _false_.
bool invalidTimeString(String message, [Issues issues]) {
  badTimeString(message, issues);
  return false;
}

/// TimeZone String [Error] message. Returns _null_.
Null badTimeZoneString(String message, [Issues issues]) =>
    badString('InvalidTimeZoneStringError: $message');

/// TimeZone String [Error] message. Returns _false_.
bool invalidTimeZoneString(String message, [Issues issues]) {
  badTimeZoneString(message, issues);
  return false;
}

/// DateTime String [Error] message. Returns _null_.
Null badDateTimeString(String message, [Issues issues]) =>
    badString('InvalidDateTimeStringError: $message');

/// DateTime String [Error] message. Returns _false_.
bool invalidDcmDateTimeString(String message, [Issues issues]) {
  badDateTimeString(message, issues);
  return false;
}

/// An invalid character in [String] [Error], returning _null_.
Null badCharacterInString(String s, int index, [Issues issues]) {
  final char = s[index];
  final unit = s.codeUnitAt(index);
  final msg = 'InvalidCharacter: "$char"($unit) at index($index) '
      'in [${s.length}]"$s"';
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
Null badUuidString(String uuid, [Issues issues]) =>
    badString('Invalid Uuid String Error: "$uuid"');

/// An invalid [Uuid] [String] [Error], returning _false_.
bool invalidUuidString(String uuid, [Issues issues]) {
  _doStringError(uuid, issues);
  return false;
}

/// [Uuid] String [Error] message. Returns _null_.
Null badUuidStringLength(String s, int targetLength, [Issues issues]) {
  final msg = 'Invalid String length(${s.length} should be $targetLength';
  return _doStringError(msg, issues);
}

/// [Uuid] _null_ String [Error] message. Returns _null_.
Null badUuidNullString([Issues issues]) =>
    _doStringError('Invalid null string', issues);

/// Bad character in [Uuid] String [Error] message. Returns _null_.
Null badUuidCharacter(String s, [String char, Issues issues]) =>
    _doStringError('Invalid character in String: "$char"', issues);

/// [Uuid.parse] String [Error] message. Returns _null_.
Null badUuidParse(String s, int targetLength, [Issues issues]) {
  if (s == null) return badUuidNullString();
  if (s.length != targetLength) return badUuidStringLength(s, targetLength);
  return _doStringError('"$s"', issues);
}

/// General [Error] message for [String] [List]s. Returns _null_.
Null badStringList(String message, [Issues issues]) =>
    _doStringError('StringListError: $message', issues);

/// General [Error] message for [String] [List]s. Returns _false_.
bool invalidStringList(String message, [Issues issues]) {
  badStringList(message, issues);
  return false;
}
