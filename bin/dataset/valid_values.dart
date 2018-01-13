// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


import 'package:core/server.dart';
import 'package:tag/tag.dart';

// Urgent Sharath: move to tag
// Urgent Sharath: Create something like this for element if it doesn't already exist.
void main() {
  final rootDS = new TagRootDataset();
  system.throwOnError = true;
  print('throwOnError: $throwOnError');
  rootDS.checkIssuesOnAdd = true;
  print('doCheckIssuesOnAdd: ${rootDS.checkIssuesOnAdd}');

/*
  const List<int> int32Min = const [Int32.minValue];
  const List<int> int16Min = const [Int16.minValue];

  final SL sl0 = new SL(PTag.kReferencePixelX0, int32Min);
  final SL sl2 = new SL(PTag.kDisplayedAreaTopLeftHandCorner, [1, 2]);
  final LT lt2 = new LT(PTag.kDetectorDescription, [' foo' ]);
  final FL fl3 = new FL(PTag.kAbsoluteChannelDisplayScale, [123.45]);
  final SS ss0 = new SS(PTag.kTagAngleSecondAxis, int16Min);
  final SH sh0 = new SH(PTag.kPerformedLocation, [' fgh' ]);
  final FL fl0 = new FL(PTag.kAbsoluteChannelDisplayScale, [123.45]);
*/

  final v = <int>[] == <int>[];
  print('[] == <int>[] = ${v.runtimeType}: $v');
  print('[] is List<String> - ${v is List<String>}');
  print('[] is List<String> - ${v is List<int>}');
  print('[] is List<double> - ${v is List<double>}');

  const vrIndex = kSHIndex;
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

  //Urgent Sharath: move to Element
  print('\ntestVRIsValidValuesType');
  testVRIsValidValues(vrIndex, d0, ' $d0', expected: true);
  testVRIsValidValues(vrIndex, d1, ' $d1', expected: false);
  testVRIsValidValues(vrIndex, d2, ' $d2', expected: false);
  testVRIsValidValues(vrIndex, f0, ' $f0', expected: true);
  testVRIsValidValues(vrIndex, f1, ' $f1', expected: false);
  testVRIsValidValues(vrIndex, f2, ' $f2', expected: false);
  testVRIsValidValues(vrIndex, i0, ' $i0', expected: true);
  testVRIsValidValues(vrIndex, i1, ' $i1', expected: false);
  testVRIsValidValues(vrIndex, i2, ' $i2', expected: false);
  testVRIsValidValues(vrIndex, s0, ' $s0', expected: true);
  testVRIsValidValues(vrIndex, s1, ' $s1', expected: true);
  testVRIsValidValues(vrIndex, s2, ' $s2', expected: true);
  testVRIsValidValues(vrIndex, x0, ' $x0', expected: false);
  testVRIsValidValues(vrIndex, x1, ' $x1', expected: false);
  testVRIsValidValues(vrIndex, x2, ' $x2', expected: false);

  print('\ntestTagHasValidValues');
  testTagHasValidValues(tag, d0, ' $d0', expected: true);
  testTagHasValidValues(tag, d1, ' $d1', expected: false);
  testTagHasValidValues(tag, d2, ' $d2', expected: false);
  testTagHasValidValues(tag, f0, ' $f0', expected: true);
  testTagHasValidValues(tag, f1, ' $f1', expected: false);
  testTagHasValidValues(tag, f2, ' $f2', expected: false);
  testTagHasValidValues(tag, i0, ' $i0', expected: true);
  testTagHasValidValues(tag, i1, ' $i1', expected: false);
  testTagHasValidValues(tag, i2, ' $i2', expected: false);
  testTagHasValidValues(tag, s0, ' $s0', expected: true);
  testTagHasValidValues(tag, s1, ' $s1', expected: true);
  testTagHasValidValues(tag, s2, ' $s2', expected: false);
  testTagHasValidValues<dynamic>(tag, x0, ' $x0', expected: false);
  testTagHasValidValues<dynamic>(tag, x1, ' $x1', expected: false);
  testTagHasValidValues<dynamic>(tag, x2, ' $x2', expected: false);
}

void testVRIsValidValues(int vrIndex, List values, String name, {bool expected}) {
  print('$vrIndex, $name: ${values.runtimeType}, Length: ${values.length}, '
      'expected: $expected');

/* TODO: convert to Element
  final v = vr.isValidValuesType(values);
  if (v != expected) {
    print('...$values');
    print('...${vr.isValidValuesType.runtimeType}');
    print('...Expected: $expected Was: $v\n');
  }
*/

}

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
