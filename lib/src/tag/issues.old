// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

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
    for (var i = 0; i < issues.length; i++) sb.write('  ${i + 1}: ${issues[i]}\n');
    return sb.toString();
  }

  @override
  String toString() => '$runtimeType: $issues\n  ${issues.join('\n  ')}';
}
