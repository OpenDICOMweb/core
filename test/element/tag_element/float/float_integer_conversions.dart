// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

//TODO: remove number when random is moved to system.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/float32_test', level: Level.info0);
  final rng = new RNG(1);

  //Urgent: this kind of global variable leads to bugs - please move inside tests
//  List<double> float32List;

  //Urgent: this doesn't test anything - no expects - please fix
  test('Float32Base.toFloat32List', () {
    final float64List = rng.float64List(10, 20);
    final float32List = Float32Base.toFloat32List(float64List);

    for (var i = 0; i < float64List.length; i++) {
      //Urgent: please remove or convert to log... all print statements
      print('float64List[$i]: ${float64List[i]}, float32List[$i]: ${float32List[i]}');
    }
  });

  //Urgent is this correct? What is it testing
  test('Int32Base.toInt16List', () {
    final int32List0 = rng.int32List(10, 20);
    final int32List1 = [Int32Base.kMaxValue + 1];
    for (var i = 0; i < int32List0.length; i++) {
      if (int32List0[i] > Int16Base.kMaxValue) int32List1.add(int32List0[i]);
    }

    final int16List0 = Int16Base.toInt16List(int32List1, check: false);
    expect(int16List0, isNotNull);

    log.debug('int16List: $int16List0');
    for (var i = 0; i < int32List1.length; i++) {
      log.debug('int16List[$i]: ${int16List0[i]}, int16List[$i]: ${int16List0[i]}');
    }

    //Urgent Jim: make list in Jira
    final int16List1 = Int16Base.toInt16List(int32List1, check: true);
    expect(int16List1, isNull);

  });

  test('Int32Base.toInt32List', () {
    final int64List0 = [Int32Base.kMinValue - 1, Int32Base.kMaxValue + 1];
    final int16List = Int32Base.toInt32List(int64List0);
    expect(int16List, isNull);
  });

  test('Uint8Base.toUint8List', () {
    final int8List0 = [Uint8Base.kMinValue - 1, Uint8Base.kMaxValue];
    final int8List1 = Uint8Base.toUint8List(int8List0);
    expect(int8List1, isNull);

//    final int8List2 = [Uint8Base.kMinValue, Uint8Base.kMaxValue + 1];
    final int8List3 = Uint8Base.toUint8List(int8List0);
    expect(int8List3, isNull);
  });
}
