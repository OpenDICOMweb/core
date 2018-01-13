// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/tag/tag.dart';

//typedef String _Msg(object);

//Flush if not used
//String unknownIssueTypeMsg(dynamic obj) => 'Unknown Issue Type with $obj';

String invalidPadCharMsg(String char) =>
    'Invalid padding character $char in String';

String privateGroupLengthPresentMsg(int code) =>
    'Retired Private Group Length tag ${Tag.toDcm(code)} present';

class IssueAction {
  /// A unique number (used as an index) identifying this [IssueAction].
  final int level;
  final String keyword;
  final String description;

  const IssueAction(this.level, this.keyword, this.description);

  String get info => '$keyword($level): $description';

  String get asString => '$keyword';

  @override
  String toString() => asString;

  static const IssueAction kAbort = const IssueAction(
      0,
      'Abort',
      'An error that can\'t be fixed by the receiver. An object '
      'with this type of error should not be stored or processed '
      'by the receiver.');

  static const IssueAction kQuarantine = const IssueAction(
      100,
      'Quarantine',
      'An error that might be fixed by the receiver, but that requires '
      'human intervention. An object with this type of error should not '
      'be stored or processed by the receiver, until a the error is '
      'fixed by a human');

  static const IssueAction kFix = const IssueAction(
      200,
      'Fix',
      'A fixable error, which must be fixed before the study is '
      'valid.  This type of Issue might be fixable automatically.');

  static const IssueAction kAutoFix = const IssueAction(
      300,
      'AutoFix',
      'This type of Error can be automatically fixed, without '
      'affecting the semantic content of the Element.');

  static const IssueAction kRemoveElement = const IssueAction(
      310,
      'RemoveElement',
      'The Element is retired and may be removed without affecting the '
          'semantic content of the Dataset');

  static const IssueAction kWarn = const IssueAction(
      400,
      'Warning',
      'A warning about an Issue that not strictly an Error, but '
      'which should modified to conform to the Standard.');

  static const IssueAction kInfo = const IssueAction(
      500, 'Information', 'An informational message about the Element');
}
