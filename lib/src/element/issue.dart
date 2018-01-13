// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/element/base/element.dart';
import 'package:tag/tag.dart';

enum IssueAction { abort, quarantine, error, warning, info, bestPractice }

class Issue<V> {
  final Element e;
  bool _hasBadLength = false;
  bool _hasBadWidth = false;
  final Map<int, String> _valueErrors = <int, String>{};

  Issue(this.e);

  Tag get tag => e.tag;
  Iterable get values => e.values;
  int get length => e.length;
  bool get hasBadLength => _hasBadLength = true;

  bool get hasBadWidth => _hasBadWidth = true;

  String badValue(int index, String message) => _valueErrors[index] = message;

  /// Returns an issues for these values.
  List<String> get issues {
    final msgs = <String>[]..add(lengthMsg)..add(widthMsg);
    for (var v in values) {
//Urgent Jim fix
      final issues = e.issues;
      if (issues != null) msgs.add('value $v: $issues');
    }
    return msgs;
  }

  bool get isNotEmpty => _hasBadLength || _hasBadWidth || _valueErrors.isNotEmpty;

  bool get isEmpty => !isNotEmpty;

  String get widthMsg => (!tag.isValidColumns<V>(values))
      ? 'Invalid Width for${tag.dcm}: values length($length) '
          'is not a multiple of vmWidth(${tag.isValidColumns}'
      : '';

  String get lengthMsg => (!tag.isValidValuesLength<V>(values))
      ? 'Invalid Length: min(${tag.vmMin}) <= length($length) '
          '<= max(${tag.vmMax})'
      : '';

  @override
  String toString() {
    final sb = new StringBuffer('Issues with $tag\n$lengthMsg$widthMsg');
    _valueErrors.forEach((index, value) {
      sb.write('\n\t$index: $value');
    });
    return sb.toString();
  }
}
