// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/tag/tag.dart';

import 'parse_issues.dart';

class ValuesIssues<E> {
  final String name;
  final Tag tag;
  final List<E> values;
  List<ParseIssues> _vIssues;

  ValuesIssues(this.name, this.tag, this.values);

  ValuesIssues operator +(ParseIssues issue) {
    add(issue);
    return this;
  }

  bool get isValidLength => tag.isValidLength(values.length);

  List<ParseIssues> get issues => _vIssues ??= <ParseIssues>[];

  bool get isEmpty => issues.isEmpty;

  String get phrase {
    if (issues.isEmpty) return 'has no issues.';
    if (issues.length == 1) return 'has the following issue:\n ';
    return 'has the following issues:\n ';
  }

  ValuesIssues add(ParseIssues pIssues) {
    if (issues.isNotEmpty) issues.add(pIssues);
    return this;
  }

  /// Check the length of a value.
  String get lengthMsg {
    final length = values.length;
    final min = tag.minValues;
    if (length < min)
      return 'Invalid length($length) too short - minimun($min)\n';
    final max = tag.maxValues;
    if (length > max)
      return '${name}Invalid length($length) too long - maximum($max)\n';
    return '';
  }

  @override
  String toString() => (isValidLength && issues.isEmpty)
      ? ''
      : '$name:\n $lengthMsg ${issues.join('\n  ')}';
}
