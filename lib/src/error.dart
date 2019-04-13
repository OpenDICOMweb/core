// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

// ignore_for_file: prefer_void_to_null

/// # ODW Core Validators and Errors
///
/// ## Validators
///
/// Validators are boolean functions that take at least two arguments:
///
///  1. An object of some Type
///  2. An Issues argument, which is typically optional.
///
/// If the value of the function is _true_ the _Issues_ argument is not
/// affected, but if the value is false and the Issues argument is not
/// _null_, an error message is added to it.
///
/// ## Errors and Error Functions
///
/// This directory contains files that define [Error]s and related functions.
/// Error functions typically start with _bad..._ or _invalid..._.
///
///  - _bad..._ functions return the[Null] value.
///
///  - _invalid..._ functions return _false_.
///
/// Each function does the following:
///
/// - logs an error message
///
/// - if the _Issues_ argument is not _null_ the error message is added
///   to _issues_.
///
/// - if _throwOnError_ is _true_ an Error is thrown
///
/// - finally, either _null_ or _false_ is returned depending on the
///   function prefix, i.e. _bad_ or _invalid_.

export 'package:core/src/error/issues/issues.dart';
export 'package:core/src/error/issues/issues.dart';
export 'package:core/src/error/issues/values_issues.dart';

export 'package:core/src/error/dataset_errors.dart';
export 'package:core/src/error/date_time_errors.dart';
export 'package:core/src/error/element_errors.dart';
export 'package:core/src/error/general_errors.dart';
export 'package:core/src/error/string_errors.dart';
export 'package:core/src/error/system_errors.dart';
export 'package:core/src/error/tag_errors.dart';
export 'package:core/src/error/vr_errors.dart';
