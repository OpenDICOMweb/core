//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:io';

import 'package:core/core.dart';

import '../../tool/copyright.dart';

void main() {
  makeDeIdDateClasses();
}

const String outDir = 'C:/acr/odw/sdk/core/tool/profile/output';
const String outFile = '$outDir//deid_dates.dart';
const String imports = '''
import 'package:core/src/constants.dart';
import 'package:core/src/tag.dart';
''';

String makeDeIdDateClasses() {
  final sb0 = StringBuffer('$copyright\n$imports\n')
    ..writeln('const List<int> deIdDateCodes = const <int>[');

  final sb1 = StringBuffer()
    ..writeln('const List<PTag> deIdDateTags = const <PTag>[');

  final sb2 = StringBuffer()
    ..writeln('const Map<int, String> deIdDateCodeToKeywordMap = '
        'const <int, String>{');

  for (final v in DeIdTags.map.values) {
    if (v.tag.vrIndex == kDAIndex) {
      sb0.writeln('  k${v.tag.keyword},');
      sb1.writeln('  PTag.k${v.tag.keyword},');
      sb2.writeln("  ${hex32(v.tag.code)}: '${v.tag.keyword}',");
    }
  }

  sb0.writeln('];\n\n');
  sb1.writeln('];\n\n');
  sb2.writeln('};\n\n');
  final out = '$sb0$sb1$sb2';
  File(outFile).writeAsStringSync(out);
  print(out);
  return out;
}
