// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
library odw.sdk.core.parser;

import 'package:core/src/utils/ascii.dart';
import 'package:core/src/value/date_time.dart';
import 'package:core/src/utils/logger.dart';
import 'package:core/src/system.dart';
import 'package:core/src/utils/date_time.dart';
import 'package:core/src/utils/issues.dart';
import 'package:core/src/utils/parser/parse_errors.dart';
import 'package:core/src/utils/string/number.dart';

part 'age_parser.dart';
part 'date_parser.dart';
part 'date_time_parser.dart';
part 'number_parser.dart';
part 'parser_utils.dart';
part 'time_parser.dart';
part 'time_zone_parser.dart';

//TODO: Make sure FallThroughError functions handle Issues correctly
//TODO: Add an [onError] argument to all visible functions;
//TODO: for performance make every function that can be internal
//TODO: redo doc

//TODO: the following is the plan for all parsers int the String package.
/// DICOM Parsers
///
/// Each parser has the following signature
///     ```T Parse(String s, {int start = 0, int end, Issues issues,
///     OnParseError  onError})```
/// where
///     ```typedef T OnParseError(String);```
///
/// If ```end == null```, it defaults to ```s.length```.
/// If ```issues == null```, no [Issues] messages are generated.
/// If ```onError == null```, when an error occurs a [FormatException] will be thrown.

typedef int OnParseError(String s);

/// General Parse methodology
///
/// There are two types of parser signatures:
/// - Fixed size fields:
///
///     parse(String s, [int start = 0, Issues issues, bool isValidOnly])
///
/// - Variable size fields:
///
///     parse(String s,
///         [int start = 0, int end, int min = 0, int max,
///         Issues issues, bool isValidOnly)
///
/// For both signatures:
///
/// - `s`: is the String to be parsed. `s` must have length greater than or
/// equal to `end`
///
/// - `start` is the index of the first character, `start` defaults to `0`.
///
/// - `end`: is the index of the last character. `end` defaults to `s.length`.
/// It is an error if `end` is greater than `s.length`.
///
/// - `issues`: is an object that contains descriptions of any errors or
/// warnings that have occurred while parsing `s`. If `issues` is `null`,
/// then the parser will `throw` a `ParseError`. If `issues` is not `null`,
/// an error message will be appended to it.
///
/// - `isValidOnly`: is a boolean value indicating whether the function should
/// return true or value on success, and false or null on failure.
///
/// `start` and `end` must exactly delimit the characters to be parsed.
///
/// For the variable signature:
///
/// - `min`: is the minimum number of characters that must be parsed to succeed.
/// `s` must have a minimum length of `start` + `min`. `min` defaults to `0`.
///
/// - `max`: is the maximum number of characters that can be parsed. `s` must
/// have a maximum length of `start` + `max`. `max` defaults to `s.length`.
///
/// Variable length parsers will parse as many characters as possible.
///
/// Top level parsers must wrap internal parsers in:
///
///     try {
///     ...
///     } on FormatException {
///       return (isValidOnly) ? false : null;
///     }
///     return (isValidOnly) ? true : value;
///
/// When an internal parser encounters an error, it will either `throw` a
/// `ParseError` if `issues` is non-`null` or append an error message to
/// `issues` and continue parsing if it can.  Error messages are accumulated
/// in `issues`.
///
