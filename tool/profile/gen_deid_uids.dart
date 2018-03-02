// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:core/core.dart';

import '../../tool/copyright.dart';

void main() {
  makeDeIdUidList();
  makeDeIdNonUidList();
}

const String outputDir = 'C:/acr/odw/sdk/core/tool/profile/output';

const String imports = '''
import 'package:core/src/constants.dart';
import 'package:core/src/tag.dart';
''';


String makeDeIdList() {
  final sb = new StringBuffer()
    ..writeln('static const List<DeIdProfile> deIdTags = const <DeIdProfile>[');
  for (var v in DeIdTags.map.values) sb.writeln('  k${v.tag.keyword},');
  sb.writeln('];\n');
  final out = '$sb';
  print(out);
  return out;
}

String makeDeIdUidList() {

  final sb0 = new StringBuffer('$copyright\n$imports\n')
    ..writeln('const List<int> deIdUidCodes = const <int>[');

  final sb1 = new StringBuffer()
    ..writeln('const List<PTag> deIdUidTags = const <PTag>[');

  final sb2 = new StringBuffer()
    ..writeln('const Map<int, String> deIdUidCodeToKeywordMap = '
                  'const <int, String>{');

  for (var v in DeIdTags.map.values) {
    if (v.tag.name.contains('UID')) {
      sb0.writeln('  k${v.tag.keyword},');
      sb1.writeln('  PTag.k${v.tag.keyword},');
      sb2.writeln("  ${hex32(v.tag.code)}: '${v.tag.keyword}',");
    }
  }

  sb0.writeln('];\n\n');
  sb1.writeln('];\n\n');
  sb2.writeln('};\n\n');
  final out = '$sb0$sb1$sb2';
  new File('$outputDir/deid_uids.dart')..writeAsStringSync(out);
  print(out);
  return out;
}

String makeDeIdNonUidList() {
  final sb0 = new StringBuffer('$copyright\n$imports\n')
    ..writeln('const List<int> deIdNonUidCodes = const <int>[');

  final sb1 = new StringBuffer()
    ..writeln('const List<PTag> deIdNotUidTags = const <PTag>[');

  final sb2 = new StringBuffer()
    ..writeln('const Map<int, String> deIdNonUidCodeToKeywordMap = '
                  'const <int, String>{');

  for (var v in DeIdTags.map.values) {
    if (!v.tag.name.contains('UID')) {
      sb0.writeln('  k${v.tag.keyword},');
      sb1.writeln('  PTag.k${v.tag.keyword},');
      sb2.writeln("  ${hex32(v.tag.code)}: '${v.tag.keyword}',");
    }
  }

  sb0.writeln('];\n\n');
  sb1.writeln('];\n\n');
  sb2.writeln('};\n\n');
  final out = '$sb0$sb1$sb2';
  final outDir = '$outputDir/deid_uids.dart';
  print('outDir: $outDir');
  new File('$outputDir/deid_non_uids.dart')..writeAsStringSync(out);

  print(out);
  return out;
}

typedef StringBuffer ListMaker(StringBuffer sb);

StringBuffer makeUidTagList(StringBuffer sb) {
  for (var v in DeIdTags.map.values) {
    print('name: "${v.tag.name}"');
    if (!v.tag.name.contains('UID')) {
      sb.writeln('  k${v.tag.keyword},');
    }
  }
  return sb;
}

StringBuffer makeUidCodeToKeywordMap(StringBuffer sb) {
  for (var v in DeIdTags.map.values) {
    print('name: "${v.tag.name}"');
    if (!v.tag.name.contains('UID')) {
      sb.writeln('  ${dcm(v.tag.code)}: "${v.tag.keyword}",');
    }
  }
  return sb;
}
