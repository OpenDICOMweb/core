// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:core/core.dart';

import '../../tool/copyright.dart';

void main() {
  makeDeIdDateClasses();
}

const String imports = '''
import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/p_tag.dart';
''';

const String outDir = 'C:/acr/odw/sdk/core/tool/profile/output';
const String outFile = '$outDir//deid_remove.dart';

String makeDeIdDateClasses() {
  final sb0 = new StringBuffer('$copyright\n$imports\n')
    ..writeln('const List<int> deIdRemoveCodes = const <int>[');

  final sb1 = new StringBuffer()
    ..writeln('const List<PTag> deIdRemoveTags = const <PTag>[');

  final sb2 = new StringBuffer()
    ..writeln('const Map<int, String> deIdRemoveCodeToKeywordMap = '
        'const <int, String>{');

  for (var v in DeIdTags.map.values) {
    if (v.name == 'X' &&
        v.tag.vrIndex != kDAIndex &&
        v.tag.vrIndex != kUIIndex) {
      sb0.writeln('  k${v.tag.keyword},');
      sb1.writeln('  PTag.k${v.tag.keyword},');
      sb2.writeln("  ${hex32(v.tag.code)}: '${v.tag.keyword}',");
    }
  }

  sb0.writeln('];\n\n');
  sb1.writeln('];\n\n');
  sb2.writeln('};\n\n');
  final out = '$sb0$sb1$sb2';
  new File(outFile)..writeAsStringSync(out);
  print(out);
  return out;
}
