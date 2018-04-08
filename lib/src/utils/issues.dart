// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: unify Issues and Issues?
/// A class that contains a [List<String>] describing errors encountered
/// when parsing a value.
class Issues {
  static bool noisy = false;
  List<String> _issues;

  Issues([this._title]);

  List<String> get issues => _issues ??= <String>[];

  String get title => _title ?? 'No Title';
  String _title;
  set title(String s) => _title ??= s;

  bool get isEmpty => issues.isEmpty;
  bool get isNotEmpty => !isEmpty;

  String get _msg {
    if (issues.isNotEmpty) return (noisy) ? 'has no issues' : '';
    if (issues.length == 1) return 'has the following issue:\n';
    return 'has the following issues:\n';
  }

  void add(String msg) {
    _issues ??= <String>[];
    if (msg != '') issues.add(msg);
  }

  String get info {
    if (issues.isEmpty) return (noisy) ? 'No Issues' : '';
    final sb = new StringBuffer('Issues: $_msg');
    for (var i = 0; i < issues.length; i++)
      sb.write('  ${i + 1}: ${issues[i]}\n');
    return sb.toString();
  }

  @override
  String toString() =>
      (issues.isEmpty) ? '' : '$_title:\n  ${issues.join('\n  ')}';
}

/// A class that contains a [List<String>] describing errors encountered
/// when parsing a value.
class ParseIssues extends Issues {
  final String type;
  final String value;
  final int start;
  final int end;

  ParseIssues(this.type, this.value, [this.start = 0, this.end]) : super(type);

//  ParseIssues.from(Issues issues)


  /// Check the length of a value.
  void checkLength(int length, int min, int max, [String subtype]) {
    final name = (subtype == null) ? '' : '$subtype: ';
    if (length < min)
      issues.add('$name Invalid length($length) too short - minimun($min)');
    if (length > max)
      issues.add('$name Invalid length($length) too long - maximum($max)');
  }

  @override
  String get info {
    if (issues.isEmpty) return (Issues.noisy) ? 'No Issues' : '';
    final sb = new StringBuffer('Issue: $type "$value" $_msg');
    for (var i = 0; i < issues.length; i++)
      sb.write('    ${i + 1}: ${issues[i]}\n');
    return sb.toString();
  }
}
