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
import 'package:core/src/tag/tag.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/vr/vr_base.dart';

class InvalidTagError extends Error {
  String message;
  Tag tag;
  Type type;

  InvalidTagError(this.message, [this.tag, this.type]);

  @override
  String toString() => message;
}

/// Returns _true_ if [tag].vrIndex is equal to [targetVR], which MUST
/// be a valid _VR Index_. Typically, one of the constants (k_XX_Index)
/// is used.
bool isValidTag(Tag tag, Issues issues, int targetVR, Type type) =>
    (doTestElementValidity && tag.vrIndex != targetVR)
        ? invalidTag(tag, issues, type)
        : true;

/// Returns _true_ if [tag].vrIndex is equal to [targetVR], which MUST
/// be a valid _VR Index_. Typically, one of the constants (k_XX_Index)
/// is used.
bool isValidSpecialTag(Tag tag, Issues issues, int targetVR, Type type) {
  final vrIndex = tag.vrIndex;
  return (doTestElementValidity &&
          (vrIndex == targetVR ||
              (vrIndex >= kVRSpecialIndexMin && vrIndex <= kVRSpecialIndexMax)))
      ? true
      : invalidTag(tag, issues, type);
}

Null badTag(Tag tag, Issues issues, Type type) {
  final msg = 'InvalidTag for $type: $tag';
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidTagError(msg, tag, type);
  return null;
}

bool invalidTag(Tag tag, Issues issues, Type type) {
  badTag(tag, issues, type);
  return false;
}

String _value(Object key) {
  if (key == null) return 'null';
  if (key is String) return key;
  if (key is int) return dcm(key);
  return key;
}

Null badKey<K>(K key, [int vrIndex, String creator]) {
  final msg = 'InvalidTagKeyError: "${_value(key)}" $vrIndex '
      'creator:"$creator"';
  log.error(msg);
  if (throwOnError) throw new InvalidTagError(msg);
  return null;
}

Null badCode(int code, [String message, Tag tag]) {
  final t = (tag == null) ? '' : '$tag';
  final msg = 'InvalidTagCodeError: "${dcm(code)}": $message $t';
  log.error(msg);
  if (throwOnError) throw new InvalidTagError(msg);
  return null;
}

bool invalidCode(int code, [String message, Tag tag]) {
  badCode(code, message, tag);
  return false;
}

Null keywordError(String keyword) {
  final msg = 'InvalidTagKeywordError: "$keyword"';
  log.error(msg);
  if (throwOnError) throw new InvalidTagError(msg);
  return null;
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

/// An invalid DICOM Group number [Error].
class InvalidGroupError extends Error {
  String msg;

  InvalidGroupError(this.msg);

  @override
  String toString() => msg;
}

Null badGroupError(int group, [Issues issues]) {
  final msg = 'Invalid DICOM Group Error: ${hex16(group)}';
  if (log != null) log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidGroupError(msg);
  return null;
}

bool invalidGroupError(int group, [Issues issues]) {
  badGroupError(group, issues);
  return false;
}
