//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/global.dart';
import 'package:core/src/error/issues/issues.dart';

// ignore_for_file: public_member_api_docs

/// A Parsing Error.  This class should not be used directly,
/// call [parseError] or [parseNullError] instead.
class ParseError extends Error {
  String msg;

  ParseError(this.msg);

  @override
  String toString() => getMsg(msg);

  static String getMsg(String msg) => 'ParseError: $msg';
}

/// An [Error] was encountered when parsing a [String].
///
/// _Note_: This _always_ [throw]s. The [throw] MUST always be
/// caught by the parser.
// ignore: prefer_void_to_null
Null parseError(String msg, [Issues issues]) {
  log.error(ParseError.getMsg(msg));
  if (issues != null) issues.add(msg);
  throw FormatException(msg);
}

/// A _null_ values was passed to a parser.
// ignore: prefer_void_to_null
Null parseNullError([Issues issues]) =>
    parseError('Invalid attempt to parse a null values', issues);

/// An invalid [DateTime] [Error].
class InvalidParseStringToStringError extends ParseError {
  InvalidParseStringToStringError(String msg) : super(msg);

  @override
  String toString() => _msg(msg);

  static String _msg(String s) => 'InvalidParseStringToStringError: "$s"';
}

// ignore: prefer_void_to_null
Null badParseStringToString(String msg, [Issues issues]) {
  log.error(InvalidParseStringToStringError._msg(msg));
  if (issues != null) issues.add(msg);
  if (throwOnError) throw InvalidParseStringToStringError('$msg');
  return null;
}

bool invalidParseStringToString(String msg, [Issues issues]) {
  badParseStringToString(msg, issues);
  return false;
}


/*
/// An invalid [Uuid] [String] [Error].
class InvalidUuidStringError extends ParseError {
  InvalidUuidStringError(String msg) : super(msg);

  @override
  String toString() => _msg(msg);

  static String _msg(String s) => 'InvalidUuidStringError: "$s"';
}

Null invalidUuidString(String msg, [Issues issues]) {
  log.error(InvalidUuidStringError._msg(msg));
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidUuidStringError('$msg');
  return null;
}
*/

/*
/// An invalid [Uuid] [String] [Error].
class InvalidCharacterInStringError extends ParseError {
  final String s;
  final int index;

  InvalidCharacterInStringError(this.s, this.index) : super(_msg(s, index));

  @override
  String toString() => _msg(s, index);

  static String _msg(String s, int index) {
    final cUnits = s.codeUnits;
    return 'Invalid Character("${s[index]}") in String("$s") at index($index)'
        'codeUnits: $cUnits';
  }
}
*/

/*
Null invalidCharacterInString(String s, int index, [Issues issues]) {
  final msg = InvalidCharacterInStringError._msg(s, index);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidCharacterInStringError(s, index);
  return null;
}
*/

/*
/// An invalid [Uuid] [String] [Error].
class InvalidStringError extends ParseError {
  final String s;

  InvalidStringError(this.s) : super(_msg(s));

  @override
  String toString() => _msg(s);

  static String _msg(String s) => 'Invalid String($s)';
}
*/

/*
//TODO: improve message
void invalidStringLength(String s, [Issues issues, int start, int end]) {
  final msg = 'Invalid Length: "$s", start($start), end($end)';
  if (issues != null) issues.add(msg);
  parseError(msg, issues);
}

Null invalidString(String s, [Issues issues]) {
  final msg = InvalidStringError._msg(s);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidStringError(s);
  return null;
}
*/
