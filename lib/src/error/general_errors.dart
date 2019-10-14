//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/system.dart';

// ignore_for_file: public_member_api_docs
// ignore_for_file: prefer_void_to_null

/// These are errors that are used throughout the Core package.

/// General Errors

Null unsupportedError([String msg = '']) {
  if (throwOnError) throw UnsupportedError(msg);
  return null;
}

Null unimplementedError([String msg = '']) {
  if (throwOnError) throw UnsupportedError(msg);
  return null;
}

void unsupportedSetter([String msg = '']) {
  if (throwOnError) throw UnsupportedError(msg);
  return;
}

/// An Internal system error.
class InternalError extends Error {
  final String msg;
  final Object object;
  final int errorCode;

  InternalError(this.msg, [this.object, this.errorCode = -1]) {
    Global.global.exit(errorCode, msg);
  }

  @override
  String toString() => message(msg, object, errorCode);

  static String message(String msg, Object object, int code) =>
      'InternalError($code):$msg - $object';
}

/// Internal Errors. This error always throws.
///
/// This type of Error might be handled differently on Client and Server.
void internalError(String msg, [Object o, int errorCode = -1]) {
  log.error(InternalError.message(msg, o, errorCode));
  throw InternalError(msg, o, errorCode);
}

/// A [GeneralError] is thrown when a values should not be _null_.
class GeneralError extends Error {
  String msg;

  GeneralError(this.msg);

  @override
  String toString() => msg;
}

Null nullValueError([String msg = '']) {
  final s = 'NullValueError: $msg';
  log.error(s);
  if (throwOnError) throw GeneralError(s);
  return null;
}

class InvalidKeyError<K> extends Error {
  K key;
  String msg;

  InvalidKeyError(this.key, [this.msg]);

  @override
  String toString() =>
      (msg == null) ? 'InvalidKeyError: ${keyTypeString(key)}' : msg;
}

Null invalidKey<K>(K key, [String msg]) {
  final msg = 'InvalidKeyError: ${keyTypeString(key)}';
  log.error(msg);
  if (throwOnError) throw InvalidKeyError(key);
  return null;
}

Null badTypedDataLength(int length, int maxLength, [Issues issues]) {
  final s = 'Invalid TypedData length($length): '
      '$length exceeds maximum($maxLength)';
  log.error(s);
  if (issues != null) issues.add(s);
  if (throwOnError) throw GeneralError(s);
  return null;
}

bool invalidTypedDataLength(int vfLength, int maxVFLength, [Issues issues]) {
  badTypedDataLength(vfLength, maxVFLength, issues);
  return false;
}
