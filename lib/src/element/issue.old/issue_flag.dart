// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'issue_type.dart';

class IssueFlag {
  final String keyword;
  final List<IssueType> types;
  final String name;
  final bool value;

  const IssueFlag(
    this.keyword,
    this.types,
    this.name, {
    this.value,
  });

  static const IssueFlag shouldTruncateInvalidVM = const IssueFlag(
      'shouldTruncateInvalidVM',
      const [IssueType.kInvalidVR],
      'Should Fix Invalid Value Multiplicity (VM)',
      value: true);

  static const IssueFlag shouldFixInvalidPadChars = const IssueFlag(
      'shouldFixInvalidPadChars',
      const [IssueType.kInvalidUidPadChar, IssueType.kStringInvalidPadChar],
      'Should Fix Invalid Padding Characters',
      value: true);

  static const IssueFlag shouldFixCSStrings = const IssueFlag('shouldFixCSStrings',
      const [IssueType.kCodeStringInvalidLowerCase], 'Should Fix CS Strings',
      value: true);
}
