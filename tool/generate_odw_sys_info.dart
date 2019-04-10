//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:io';

import 'package:yaml/yaml.dart';

void main(List<String> args) {
  final inFile = File('pubspec.yaml');
  final text = inFile.readAsStringSync();
  final Map spec = loadYaml(text);
  File('lib/src/system/odw_sys_info.dart')
      .writeAsStringSync(generateSysInfo(spec));
}

String generateSysInfo(Map spec) {
  final out = '''
// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

// **** generated file ****

class OdwSysInfo {
  static const String name = '${spec['name']}';
  static const String version = '${spec['version']}';
  static const String descriptions = '${spec['description']}';
  static const List<String> authors = ${generateList(spec['authors'])};
  static const String dartSdkVersion = '${spec['environment']['sdk']}';
  static const Map<String, Object> packages = ${generateMap(spec['dependencies'])};
}
  ''';
  return out;
}

String generateValue(Object v) {
  if (v is String) return '"$v"';
  if (v is List) return generateList(v);
  if (v is Map) return generateMap(v);
  throw UnknownValueTypeError(v);
}

class UnknownValueTypeError extends Error {
  Object o;

  UnknownValueTypeError(this.o);

  @override
  String toString() => '$runtimeType: $o';
}

String generateList(List list) {
  final entries = <String>[];
  for (final value in list) {
    if (value is List) {
      entries.add('${generateList(value)}');
    } else {
      entries.add('    "$value"');
    }
  }
  return 'const [\n${entries.join(',\n')}\n    ]';
}

String generateMap(Map<String, Object> map) {
  final entries = <String>[];
  map.forEach((key, value) {
    if (value is Map) {
      entries.add('"$key": ${generateMap(value)}');
    } else {
      entries.add('    "$key": "$value"');
    }
  });
  return 'const <String, Object>{\n${entries.join(',\n')}\n    }';
}

class OdwInfo {
  static const String name = 'core';
  static const String version = '0.5.4';
  static const String dartSdkVersion = '^1.23.0';
  static const Map packages = <String, Object>{
    'crypto': '^2.0.1',
    'yaml': '^2.1.12',
    'quiver': 'any',
    'dictionary': {'version': '^0.5.4', 'path': 'C:/odw/sdk/dictionary'},
    'common': {'version': '^0.5.4', 'path': 'C:/odw/sdk/common'}
  };
}
