//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/element.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/issues.dart';
import 'package:core/src/utils/primitives.dart';

class InvalidElementError extends Error {
  final String msg;
  final Element e;

  InvalidElementError(this.msg, [this.e]);

  @override
  String toString() => msg;
}

Null badElement(String message, [Element e, Issues issues]) {
  log.error(message);
  if (issues != null) issues.add(message);
  if (throwOnError) throw new InvalidElementError(message);
  return null;
}

bool invalidElement(String message, [Element e]) {
  badElement(message, e);
  return false;
}

/// This function should be called whenever an [Element] has
/// a values field containing _null_. An [Element] that has no
/// values should have a values field containing and empty [List].
Null nullElement([String message = '']) {
  final msg = 'NullElementError: $message';
  return badElement(msg);
}

class InvalidElementIndexError extends Error {
  final int index;
  final String msg;

  InvalidElementIndexError(this.index, [this.msg]);

  @override
  String toString() => msg;
}

Null badElementIndex(int index,
    {Element e, bool required = false, Issues issues}) {
  final code = dcm(index);
  final msg = (required)
      ? 'InvalidRequiredElementIndex: $code'
      : 'InvalidElementIndex: $code';
  if (issues != null) issues.add(msg);
  return badElement(msg, e, issues);
}

bool invalidElementIndex(int index,
    {Element e, bool required = false, Issues issues}) {
  badElementIndex(index, e: e, required: required, issues: issues);
  return false;
}

class InvalidValueFieldError extends Error {
  final String msg;
  final Bytes vfBytes;

  InvalidValueFieldError(this.msg, [this.vfBytes]);

  @override
  String toString() => msg;
}

Null badValueField(String message, [Bytes vfBytes, Issues issues]) {
  final msg = _invalidVFMsg(message, vfBytes);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidValueFieldError(msg, vfBytes);
  return null;
}

String _invalidVFMsg(String msg, [Bytes vfBytes]) =>
    'Invalid Value Field Error: $msg - vfLength(${vfBytes.length})';

bool invalidValueField(String message, [Bytes vfBytes]) {
  badValueField(message, vfBytes);
  return false;
}

Null badVFLength(int vfLength, int maxVFLength,
    [int eSize, int vfLengthField]) {
  final sb = new StringBuffer('Invalid Value Field Length($vfLength):\n');
  if (vfLength > maxVFLength)
    sb.writeln('\t$vfLength exceeds maximum($maxVFLength)');
  if (eSize != null && vfLength % eSize == 0)
    sb.writeln('$vfLength is not a multiple of element size($eSize)');
  if (vfLengthField != null &&
      (vfLengthField != vfLength || vfLengthField != kUndefinedLength))
    sb.writeln('Invalid vfLengthField($vfLengthField) != vfLength($vfLength) '
        'and not equal to kUndefinedLength($kUndefinedLength');
  return badValueField('$sb');
}

bool invalidVFLength(int vfLength, int maxVFLength,
    [int eSize, int vfLengthField]) {
  badVFLength(vfLength, maxVFLength, eSize, vfLengthField);
  return false;
}

class InvalidValuesError extends Error {
  final String msg;
  final Object values;

  InvalidValuesError(this.msg, [this.values]);

  @override
  String toString() => msg;
}

Null _badValues(String msg, Object values, Issues issues) {
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidValuesError(msg, values);
  return null;
}

Null badValues(Iterable values, {Tag tag, Issues issues, String message = ''}) {
  final sb = new StringBuffer('Invalid Values Error');
  if (tag != null) sb.write(' for $tag');
  sb..write(': values = $values');
  if (message != null) sb.write('\n  $message');
  return _badValues('$sb', values, issues);
}

bool invalidValues(Iterable values, {Tag tag, Issues issues}) {
  badValues(values, tag: tag, issues: issues);
  return false;
}

Null badValuesLength<V>(Iterable<V> values, int vmMin, int vmMax,
    [Issues issues]) {
  final msg = 'InvalidValuesLengthError: vmMin($vmMin) <= ${values.length} '
      '<= vmMax($vmMax) values: $values';
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidValuesError(msg, values);
  return null;
}

bool invalidValuesLength<V>(Iterable<V> values, int vmMin, int vmMax,
    [Issues issues]) {
  badValuesLength<V>(values, vmMin, vmMax, issues);
  return false;
}

Null valueOutOfRangeError<V>(V value, Issues issues, int min, int max) {
  final msg = 'Value out of range:\n\n  values: $value';
  _badValues(msg, <V>[value], issues);
  return null;
}


class Sha256UnsupportedError extends Error {
  String message;
  Element e;

  Sha256UnsupportedError(this.message, [this.e]);

  @override
  String toString() => message;
}

Null sha256Unsupported(Element e) {
  final msg = 'SHA256 not supported for this Element: $e';
  log.error(msg);
  if (throwOnError) throw new Sha256UnsupportedError(msg, e);
  return null;
}

