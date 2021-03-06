// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/issues.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/uid/uid.dart';

/// Logs an Error entry, and then if [throwOnError] is _true_ throws an
/// [InvalidUidError]; otherwise, returns _null_.
Null invalidUidString(String uid, [Issues issues]) {
  final lastIndex = uid.length - 1;
  final pad = uid.codeUnitAt(lastIndex);
  String msg;
  if (pad == 0) {
    final v = uid.substring(0, lastIndex);
     msg = 'Invalid Null character in Uid String Error: "$v*"';
  } else {
    msg = 'Invalid Uid String Error: "$msg"';
  }
  return _doUidError(msg, issues);
}

/// Logs an Error entry, and then if [throwOnError] is _true_ throws an
/// [InvalidUidError]; otherwise, returns _null_.
Null invalidUid(Uid uid, [Issues issues]) {
  final msg = 'Invalid Uid Error: "$uid"';
  return _doUidError(msg, issues);
}

/// Logs an Error entry, and then if [throwOnError] is _true_ throws an
/// [InvalidUidError]; otherwise, returns _null_.
Null invalidUidList(List<Uid> uidList, [Issues issues]) {
  final msg = 'Invalid List<Uid> Error: $uidList';
  return _doUidError(msg, issues);
}

/// Logs an Error entry, and then if [throwOnError] is _true_ throws an
/// [InvalidUidError]; otherwise, returns _null_.
Null invalidDuplicateUid(Uid uid, [Issues issues]) {
  final msg = 'Invalid Duplicate Uid Error: "$uid"';
  return _doUidError(msg, issues);
}

/// Invalid UID Error - thrown when a [Uid], Uid [String], or [List<Uid>]
/// does not have the correct format.
class InvalidUidError extends Error {
  String msg;

  InvalidUidError(this.msg);

  @override
  String toString() => '$msg';
}

Null _doUidError(String msg, Issues issues) {
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidUidError(msg);
  return null;
}

