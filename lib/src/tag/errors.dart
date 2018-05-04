//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/value/empty_list.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/utils/issues.dart';
import 'package:core/src/vr_base.dart';

class InvalidTagError extends Error {
  Tag tag;
  Type type;

  InvalidTagError(this.tag, this.type);

  @override
  String toString() => _msg(tag, type);

  static String _msg(Tag tag, Type type) => 'InvalidTag for $type: $tag';
}

void _invalidTagError(Tag tag, Issues issues, Type type) {
  final msg = InvalidTagError._msg(tag, type);
  if (issues != null) issues.add(msg);
  log.error(InvalidTagError._msg(tag, type));
  print('throwOnError: $throwOnError');
  if (throwOnError) throw new InvalidTagError(tag, type);
}

Null badTagError(Tag tag, Type type, [Issues issues]) {
  _invalidTagError(tag, issues, type);
  return null;
}

bool isValidTagError(Tag tag, Issues issues, Type type) {
  _invalidTagError(tag, issues, type);
  return false;
}

class InvalidTagTypeError extends Error {
  String msg;
  Tag tag;

  InvalidTagTypeError(this.tag, this.msg);

  @override
  String toString() => 'InvalidTagTypeError - $msg: $tag';
}

Null nonIntegerTag(int index, [Issues issues]) =>
    _doTagError(index, issues, 'Non-Integer Tag');

Null nonFloatTag(int index, [Issues issues]) =>
    _doTagError(index, issues, 'Non-Float Tag');

Null nonStringTag(int index, [Issues issues]) =>
    _doTagError(index, issues, 'Non-String Tag');

Null nonSequenceTag(int index, [Issues issues]) =>
    _doTagError(index, issues, 'Non-Sequence Tag');

Null nonUidTag(int index, [Issues issues]) =>
    _doTagError(index, issues, 'Non-Uid Tag');

Object _doTagError(int index, Issues issues,
    [String msg = 'Invalid Tag Type']) {
  final tag = Tag.lookup(index);
  final s = '$msg: $tag';
  if (issues != null) issues.add(s);
  log.error(s);
  if (throwOnError) throw new InvalidTagTypeError(tag, s);
  return null;
}

//TODO: convert this to handle both int and String and remove next two Errors
class InvalidTagKeyError<K> extends Error {
  K key;
  int vrIndex;
  String creator;

  InvalidTagKeyError(this.key, [this.vrIndex, this.creator]);

  @override
  String toString() => _msg(key, vrIndex, creator);

  static String _msg<K>(K key, [int vrIndex, String creator]) =>
      'InvalidTagKeyError: "$_value" $vrIndex creator:"$creator"';

  static String _value(Object key) {
    if (key == null) return 'null';
    if (key is String) return key;
    if (key is int) return dcm(key);
    return key;
  }
}

Null invalidTagKey<K>(K key, [int vrIndex, String creator]) {
  log.error(InvalidTagKeyError._msg(key, vrIndex, creator));
  if (throwOnError) throw new InvalidTagKeyError(key);
  return null;
}

//Flush when replaced with InvalidTagKeyError
class InvalidTagCodeError extends Error {
  int code;
  String msg;

  InvalidTagCodeError(this.code, [this.msg]);

  @override
  String toString() => _msg(code, msg);

  static String _msg(int code, String msg) =>
      'InvalidTagCodeError: "${_value(code)}": $msg';

  static String _value(int code) => (code == null) ? 'null' : dcm(code);
}

Null invalidTagCode(int code, [String msg]) {
  log.error(InvalidTagCodeError._msg(code, msg));
  if (throwOnError) throw new InvalidTagCodeError(code, msg);
  return null;
}

//Flush when replaced with InvalidTagKeyError
class InvalidTagKeywordError extends Error {
  String keyword;

  InvalidTagKeywordError(this.keyword);

  @override
  String toString() => _msg(keyword);

  static String _msg(String keyword) => 'InvalidTagKeywordError: "$keyword"';
}

Null tagKeywordError(String keyword) {
  log.error(InvalidTagKeywordError._msg(keyword));
  if (throwOnError) throw new InvalidTagKeywordError(keyword);
  return null;
}

//TODO: convert this to handle both int and String and remove next two Errors
class InvalidVRForTagError extends Error {
  Tag tag;
  int vrIndex;

  InvalidVRForTagError(this.tag, this.vrIndex);

  @override
  String toString() => _msg(tag, vrIndex);

  static String _msg(Tag tag, int vrIndex) {
    final vr = vrIdFromIndex(vrIndex);
    return 'Error: Invalid VR (Value Representation) "$vr" for $tag';
  }
}

Null invalidVRForTag(Tag tag, int vrIndex) {
  log.error(InvalidVRForTagError._msg(tag, vrIndex));
  if (throwOnError) throw new InvalidVRForTagError(tag, vrIndex);
  return null;
}

Null invalidVRIndexForTag(Tag tag, int vrIndex) {
//	final vr = VR.lookupByIndex(vrIndex);
  log.error(InvalidVRForTagError._msg(tag, vrIndex));
  if (throwOnError) throw new InvalidVRForTagError(tag, vrIndex);
  return null;
}

Null invalidVRCodeForTag(Tag tag, int vrCode) {
  final vrIndex = vrIndexFromCode(vrCode);
  log.error(InvalidVRForTagError._msg(tag, vrIndex));
  if (throwOnError) throw new InvalidVRForTagError(tag, vrIndex);
  return null;
}

/*
class InvalidVFLengthError extends Error {
  final int length;
  final int maxVFLenght;

  InvalidVFLengthError(this.length, this.maxVFLenght) {
    if (log != null) log.error(toString());
  }

  @override
  String toString() => _msg(length, maxVFLenght);

  static String _msg(int length, int maxVFLength) =>
      'InvalidVFLengthError: lengthInBytes(${length}'
      'maxVFLength($maxVFLength)';
}

Null invalidVFLength(int length, int maxVFLength) {
  log.error(InvalidVFLengthError._msg(length, maxVFLength));
  if (throwOnError) throw new InvalidVFLengthError(length, maxVFLength);
  return null;
}
*/

class InvalidValuesTypeError<V> extends Error {
  final Tag tag;
  final Iterable<V> values;

  InvalidValuesTypeError(this.tag, this.values) {
    if (log != null) log.error(toString());
  }

  @override
  String toString() => _msg(tag, values);

  static String _msg<V>(Tag tag, Iterable<V> values) =>
      'InvalidValuesTypeError:\n  Tag(${tag.info})\n  values: $values';
}

Null invalidValuesTypeError<V>(Tag tag, Iterable<V> values) {
  log.error(InvalidValuesTypeError._msg(tag, values));
  if (throwOnError) throw new InvalidValuesTypeError(tag, values);
  return null;
}

class InvalidValuesLengthError<V> extends Error {
  final Tag tag;
  final Iterable<V> values;

  InvalidValuesLengthError(this.tag, this.values) {
    if (log != null) log.error(toString());
  }

  @override
  String toString() => _msg(tag, values);

  static String _msg<V>(Tag tag, Iterable<V> values) {
    if (tag == null || tag is! Tag) return '$tag is not a $Tag';
    // TODO: use truncated list of values
    return 'InvalidValuesLengthError:\n  $tag\n  values: $values';
  }
}

Null invalidValuesLengthError<V>(Tag tag, Iterable<V> values, [Issues issues]) {
  final msg = InvalidValuesLengthError._msg(tag, values);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidValuesLengthError(tag, values);
  return null;
}

class InvalidTagValuesError<V> extends Error {
  final Tag tag;
  final Iterable<V> values;

  InvalidTagValuesError(this.tag, this.values);

  @override
  String toString() => '${_msg(tag, values)}';

  static String _msg<V>(Tag tag, Iterable<V> values) =>
      'InvalidValuesError: ${tag.info}\n  values: $values';
}

Null invalidTagValuesError<V>(Tag tag, Iterable<V> values) {
  if (log != null) log.error(InvalidTagValuesError._msg<V>(tag, values));
  if (throwOnError) throw new InvalidTagValuesError<V>(tag, values);
  return null;
}

/// An invalid DICOM Group number [Error].
/// Note: Don't use this directly, use [invalidGroupError] instead.
class InvalidGroupError extends Error {
  int group;

  InvalidGroupError(this.group);

  @override
  String toString() => _msg(group);

  static String _msg(int group) => 'Invalid DICOM Group Error: ${hex16(group)}';
}

Null invalidGroupError(int group) {
  if (log != null) log.error(InvalidGroupError._msg(group));
  if (throwOnError) throw new InvalidGroupError(group);
  return null;
}
