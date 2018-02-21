// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';

void main() {
  Server.initialize(name: 'valid_values', level: Level.debug);
  final rootDS = new TagRootDataset.empty();
  system.throwOnError = false;
  print('throwOnError: $throwOnError');
  rootDS.checkIssuesOnAdd = true;
  print('doCheckIssuesOnAdd: ${rootDS.checkIssuesOnAdd}');

  final emptyIntList = <int>[] == <int>[];
  print('[] == <int>[] = ${emptyIntList.runtimeType}: $emptyIntList');
  print('[] is List<String> - ${emptyIntList is List<String>}');
  print('[] is List<String> - ${emptyIntList is List<int>}');
  print('[] is List<double> - ${emptyIntList is List<double>}');

  const tag = PTag.kPerformedLocation;

  final d0 = <double>[];
  final d1 = <double>[.11];
  final d2 = <double>[.11, .22];
  final f0 = <double>[];
  final f1 = <double>[.11];
  final f2 = <double>[.11, .22];
  final i0 = <int>[];
  final i1 = <int>[1];
  final i2 = <int>[1, 2];
  final s0 = <String>[];
  final s1 = <String>[' foo'];
  final s2 = <String>['Foo', 'Bar'];
  final x0 = <dynamic>['foo', 'bar', 1];
  final x1 = <dynamic>[1, ' foo'];
  final x2 = <dynamic>['Foo', 1.11];

/* Flush when Element do all testing of valid values
  const vr = kSHIndex;
  print('\ntestVRIsValidValuesType');
  testVRIsValidValues(vr, d0, '$d0', expected: true);
  testVRIsValidValues(vr, d1, '$d1', expected: false);
  testVRIsValidValues(vr, d2, '$d2', expected: false);
  testVRIsValidValues(vr, f0, '$f0', expected: true);
  testVRIsValidValues(vr, f1, '$f1', expected: false);
  testVRIsValidValues(vr, f2, '$f2', expected: false);
  testVRIsValidValues(vr, i0, '$i0', expected: true);
  testVRIsValidValues(vr, i1, '$i1', expected: false);
  testVRIsValidValues(vr, i2, '$i2', expected: false);
  testVRIsValidValues(vr, s0, '$s0', expected: true);
  testVRIsValidValues(vr, s1, '$s1', expected: true);
  testVRIsValidValues(vr, s2, '$s2', expected: true);
  testVRIsValidValues(vr, x0, '$x0', expected: false);
  testVRIsValidValues(vr, x1, '$x1', expected: false);
  testVRIsValidValues(vr, x2, '$x2', expected: false);
*/

  print('\ntestTagHasValidValues');
  testTagHasValidValues(tag, d0, '$d0', expected: false);
  testTagHasValidValues(tag, d1, '$d1', expected: false);
  testTagHasValidValues(tag, d2, '$d2', expected: false);
  testTagHasValidValues(tag, f0, '$f0', expected: false);
  testTagHasValidValues(tag, f1, '$f1', expected: false);
  testTagHasValidValues(tag, f2, '$f2', expected: false);
  testTagHasValidValues(tag, i0, '$i0', expected: false);
  testTagHasValidValues(tag, i1, '$i1', expected: false);
  testTagHasValidValues(tag, i2, '$i2', expected: false);
  testTagHasValidValues(tag, s0, '$s0', expected: true);
  testTagHasValidValues(tag, s1, '$s1', expected: true);
  testTagHasValidValues(tag, s2, '$s2', expected: false);
  testTagHasValidValues<dynamic>(tag, x0, '$x0', expected: false);
  testTagHasValidValues<dynamic>(tag, x1, '$x1', expected: false);
  testTagHasValidValues<dynamic>(tag, x2, '$x2', expected: false);
}


/* Flush when Element do all testing of valid values
void testVRIsValidValues(int vrIndex, List values, String name, {bool expected}) {
  print('$vrIndex, $name: ${values.runtimeType}, Length: ${values.length}, '
      'expected: $expected');

  for (var v in values) {
    final ok = vrIndex.isValidValue(v);
    if (ok != expected) {
      print('...$values');
      print('...${vrIndex.isValidValue.runtimeType}');
      print('...Expected: $expected Was: $v\n');
    }
  }
}
*/

void testTagHasValidValues<V>(Tag tag, List<V> values, String name, {bool expected}) {
  print('$tag, $name: ${values.runtimeType}, Length: ${values.length}, '
      'expected: $expected');

  final v = tag.isValidValues<V>(values);
  if (v != expected) {
    print('...$values: ${values.runtimeType}');
    print('...${tag.isValidValues.runtimeType}');
    print('...Expected: $expected Was: $v\n');
  }
}
