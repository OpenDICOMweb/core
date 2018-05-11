//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/element.dart';
import 'package:core/src/error/issues.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';

class InvalidElementError extends Error {
  final String msg;
  final Element e;

  InvalidElementError(this.msg, [this.e]);

  @override
  String toString() => msg;
}

Null elementError(String message, [Element e, Issues issues]) {
  log.error(message);
  if (issues != null) issues.add(message);
  if (throwOnError) throw new InvalidElementError(message);
  return null;
}

bool invalidElement(String message, [Element e]) {
  elementError(message, e);
  return false;
}

/// This function should be called whenever an [Element] has
/// a values field containing _null_. An [Element] that has no
/// values should have a values field containing and empty [List].
Null nullElement([String message = '']) {
  final msg = 'NullElementError: $message';
  return elementError(msg);
}

Null badIntElement(Element e, [Issues issues]) {
  final msg = 'Invalid Integer Element: $e';
  return elementError(msg, e, issues);

}

Null badFloatElement(Element e, [Issues issues]) {
  final msg = 'Invalid Floating Point Element: $e';
  return elementError(msg, e, issues);
}

Null badStringElement(Element e, [Issues issues]) {
  final msg = 'Invalid String Element: $e';
  return elementError(msg, e, issues);
}

Null badSequenceElement(Element e, [Issues issues]) {
  final msg = 'Invalid Floating Point Element: $e';
  return elementError(msg, e, issues);
}

Null badUidElement(Element e, [Issues issues]) {
  final msg = 'Invalid UI (uid) Element: $e';
  return elementError(msg, e, issues);
}

Null sha256Unsupported(Element e, [Issues issues]) {
  final msg = 'SHA256 not supported for this Element: $e';
  return throw new UnsupportedError(msg);
}

/*
class InvalidElementIndexError extends Error {
  final int index;
  final String msg;

  InvalidElementIndexError(this.index, [this.msg]);

  @override
  String toString() => msg;
}
*/

Null badValueField(String message, [Bytes vfBytes, Issues issues]) {
  final msg = _invalidVFMsg(message, vfBytes);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidValueFieldError(msg, vfBytes);
  return null;
}

String _invalidVFMsg(String msg, [Bytes vfBytes]) {
  final msg1 = (vfBytes != null) ?  '- vfLength(${vfBytes.length})' : '';
    'Invalid Value Field Error: $msg$msg1';
}

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

Null _badValuesError(String msg, Object vList, Issues issues, Tag tag) {
  final s = '$msg${(tag == null) ? "" : " for $tag"}';
  log.error(s);
  if (issues != null) issues.add(s);
  if (throwOnError) throw new InvalidValuesError(s, vList);
  return null;
}

Null badValues(Iterable values, [Issues issues, Tag tag]) {
  const msg = 'Invalid Values Error';
  return _badValuesError(msg, values, issues, tag);
}

bool invalidValues(Iterable values, [Issues issues, Tag tag]) {
  badValues(values, issues, tag);
  return false;
}

Null badValuesLength(Iterable values, int vmMin, int vmMax,
    [Issues issues, Tag tag]) {
  final length = values.length;
  final s = length == null ? 'null' : '$length';
  final msg = 'InvalidValuesLengthError: '
      'vmMin($vmMin) <= $s <= vmMax($vmMax) values: $values';
  return _badValuesError(msg, values, issues, tag);
}

bool invalidValuesLength(Iterable values, int vmMin, int vmMax,
    [Issues issues]) {
  badValuesLength(values, vmMin, vmMax, issues);
  return false;
}

Null valueOutOfRangeError(Object value, Issues issues, int min, int max) {
  final msg = 'Value out of range:\n\n  values: $value';
  _badValuesError(msg, [value], issues, null);
  return null;
}

