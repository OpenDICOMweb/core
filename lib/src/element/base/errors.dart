//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/element.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/issues.dart';
import 'package:core/src/value/empty_list.dart';
import 'package:core/src/value/frame.dart';

/// A [NullElementError] should be thrown whenever an [Element] has
/// a values field containing _null_. An [Element] that has no
/// values should have a values field containing and empty [List].
class NullElementError extends Error {
  String msg;

  NullElementError(this.msg);

  @override
  String toString() => _msg(msg);

  static String _msg([String msg = '']) => 'NullElementError: $msg';
}

Null nullElementError([String msg = '']) {
  log.error(NullElementError._msg(msg));
  if (throwOnError) throw new NullElementError(msg);
  return null;
}

class InvalidElementIndexError extends Error {
  final int index;
  final String msg;

  InvalidElementIndexError(this.index, [this.msg]);

  @override
  String toString() => msg;
}

Null invalidElementIndex(int index, {Element element, bool required = false}) {
  final code = dcm(index);
  final msg = (required)
      ? 'InvalidRequiredElementIndex: $code'
      : 'InvalidElementIndex: $code';
  log.error(msg);
  if (throwOnError) throw new InvalidElementIndexError(index);
  return null;
}

class InvalidElementError extends Error {
  final Element e;
  final String msg;
  final Issues issues;

  InvalidElementError(this.e, [this.msg, this.issues]);

  @override
  String toString() => _msg(e, msg);

  static String _msg(Element e, [String msg]) => (e == null)
      ? 'null'
      : 'InvalidElementError:\n\n  element: ${e.info}\n   values: ${e.values}';
}

Null invalidElementError(Element e, [String msg]) {
  final issues = new Issues('InvalidElementError: $e')..add(msg);
  log.error(issues);
  if (throwOnError) throw new InvalidElementError(e, msg, issues);
  return null;
}

class InvalidValueFieldError extends Error {
  final Uint8List vfBytes;
  final String msg;

  InvalidValueFieldError(this.vfBytes, this.msg);

  @override
  String toString() => msg;
}

Null invalidValueField(String msg, Uint8List vfBytes) {
  final s =
      'Invalid Value Field Error: $msg - vfLength(${vfBytes.lengthInBytes})';
  log.error(msg);
  if (throwOnError) throw new InvalidValueFieldError(vfBytes, s);

  return null;
}

class InvalidVFLengthError extends Error {
  final int length;
  final String msg;

  InvalidVFLengthError(this.length, [this.msg]);

  @override
  String toString() => msg;
}

Null badVFLength(int vfLength, int maxVFLength,
    [int eSize, int vfLengthField]) {
  final sb = new StringBuffer('Invalid Value Field Length:\n');
  if (vfLength > maxVFLength)
    sb.writeln('\t$vfLength exceeds maximum($maxVFLength)');
  if (eSize != null && vfLength % eSize == 0)
    sb.writeln('$vfLength is not a multiple of element size($eSize)');
  if (vfLengthField != null &&
      (vfLengthField != vfLength || vfLengthField != kUndefinedLength))
    sb.writeln('Invalid vfLengthField($vfLengthField) != vfLength($vfLength) '
        'and not equal to kUndefinedLength($kUndefinedLength');
  final s = '$sb';
  log.error(s);
  if (throwOnError) throw new InvalidVFLengthError(vfLength, s);
  return null;
}

bool isValidVFLengthError(int vfLength, int maxVFLength,
    [int eSize, int vfLengthField]) {
  badVFLength(vfLength, maxVFLength);
  return false;
}

// Change name to InvalidValuesLengthError when Tag is removed
class InvalidValuesLength<V> extends Error {
  final int vmMin;
  final int vmMax;
  final Iterable<V> values;

  InvalidValuesLength(this.vmMin, this.vmMax, this.values) {
    if (log != null) log.error(toString());
  }

  @override
  String toString() => _msg(vmMin, vmMax, values);

  static String _msg<V>(int vmMin, int vmMax, Iterable<V> values) =>
      'InvalidValuesLengthError: vmMin($vmMin) <= ${values.length} '
      '<= vmMax($vmMax) values: $values';
}

Null invalidValuesLength<V>(int vmMin, int vmMax, Iterable<V> values,
    [Issues issues]) {
  final msg = InvalidValuesLength._msg(vmMin, vmMax, values);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidValuesLength(vmMin, vmMax, values);
  return null;
}

class InvalidValuesError extends Error {
  final String msg;
  final Iterable values;

  InvalidValuesError(this.msg, this.values);

  @override
  String toString() => msg;
}

Null badValuesError(Iterable values, {Tag tag, Issues issues, String msg}) {
  _invalidValuesError(values, tag: tag, issues: issues, msg: msg);
  return null;
}

bool isValidValuesError(Iterable values, {Tag tag, Issues issues, String msg}) {
  _invalidValuesError(values, tag: tag, issues: issues, msg: msg);
  return false;
}

void _invalidValuesError(Iterable values,
    {Tag tag, Issues issues, String msg}) {
  final sb = new StringBuffer('Invalid Values Error');
  if (tag != null) sb.write(' for $tag');
  sb..write(': values = $values');
  if (msg != null) sb.write('\n  $msg');
  final errMsg = sb.toString();
  log.error(errMsg);
  if (issues != null) issues.add(errMsg);
  if (throwOnError) throw new InvalidValuesError(errMsg, values);
}

class InvalidValueError extends Error {
  final Object value;
  final int min;
  final int max;
  final String msg;

  InvalidValueError(this.value, this.min, this.max, [this.msg]);

  @override
  String toString() => 'Value out of range:\n'
      '  min($min) value($value) <= max($max)';
}

Null valueOutOfRangeError<V>(V value, Issues issues, int min, int max) {
  final msg = 'Value out of range:\n\n  values: $value';
  if (issues != null) issues.add(msg);
  log.error(msg);
  if (throwOnError) throw new InvalidValueError(value, min, max);
  return null;
}

class InvalidFrameDescriptorError extends Error {
  final FrameDescriptor desc;

  InvalidFrameDescriptorError(this.desc);

  @override
  String toString() => _msg(desc);

  static String _msg(FrameDescriptor desc) =>
      'InvalidFrameDescriptorError: $desc';
}

Null invalidFrameDescriptorError(FrameDescriptor desc) {
  log.error(InvalidFrameDescriptorError._msg(desc));
  if (throwOnError) throw new InvalidFrameDescriptorError(desc);
  return null;
}

class InvalidFrameListError extends Error {
  final FrameList frameList;

  InvalidFrameListError(this.frameList);

  @override
  String toString() => _msg(frameList);

  static String _msg(FrameList frameList) =>
      '$InvalidFrameListError: $frameList';
}

Null invalidFrameListError(FrameList frameList) {
  log.error(InvalidFrameListError._msg(frameList));
  if (throwOnError) throw new InvalidFrameListError(frameList);
  return null;
}

/// A [NullElementError] should be thrown whenever an [Element] has
/// a values field containing _null_. An [Element] that has no
/// values should have a values field containing and empty [List].
class Sha256UnsupportedError extends Error {
  Element e;

  Sha256UnsupportedError(this.e);

  @override
  String toString() => _msg(e);

  static String _msg(Element e) => 'SHA256 not supported for this Element: $e';
}

Null sha256UnsupportedError(Element e) {
  log.error(Sha256UnsupportedError._msg(e));
  if (throwOnError) throw new Sha256UnsupportedError(e);
  return null;
}

/*
/// An invalid [Uuid] [String] [Error].
class InvalidStringError extends Error {
  final String s;

  InvalidStringError(this.s);

  @override
  String toString() => _msg(s);

  static String _msg(String s) => 'Invalid String($s)';
}

Null invalidString(String s, [Issues issues]) {
  final msg = InvalidStringError._msg(s);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidStringError(s);
  return null;
}
*/

class InvalidValueFieldLengthError extends Error {
  final Uint8List vfBytes;
  final int elementSize;

  InvalidValueFieldLengthError(this.vfBytes, this.elementSize) {
    if (log != null) log.error(toString());
  }

  @override
  String toString() => '$runtimeType: lengthInBytes(${vfBytes.length}'
      'elementSize($elementSize)';
}
/*

class ParseError extends Error {
  String msg;

  ParseError(this.msg);

  @override
  String toString() => getMsg(msg);

  static String getMsg(String msg) => 'ParseError: $msg';
}
*/

/*
/// An invalid [Uuid] [String] [Error].
class InvalidCharacterInStringError extends ParseError {
  final String s;
  final String char;
  final int index;

  InvalidCharacterInStringError(this.s, this.char, this.index)
      : super(_msg(s, char, index));

  @override
  String toString() => _msg(s, char, index);

  static String _msg(String s, String char, int index) {
    final c = char.codeUnitAt(0);
    final cUnits = s.codeUnits;
    return 'Invalid Character($c) in String($cUnits) at index($index)';
  }
}
*/

/*
Null invalidCharacterInString(String s, String char, int index,
    [Issues issues]) {
  final msg =  InvalidCharacterInStringError._msg(s, char, index);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidCharacterInStringError(s, char, index);
  return null;
}
*/
