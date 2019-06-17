//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/Float64_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  group('Float64Base', () {
    test('Float64Base toFloat64', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        expect(Float64Mixin.fromList(vList), vList);
      }
    });

    test('Float64Base fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final bd = Bytes.typedDataView(vList0);
        expect(Float64Mixin.fromBytes(bd), equals(vList0));
      }
      final vList1 = Float64List.fromList(<double>[]);
      final bd0 = Bytes.typedDataView(vList1);
      expect(Float64Mixin.fromBytes(bd0), equals(<double>[]));
    });

    test('Float64Base toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(0, i);
        final vList0 = Float64List.fromList(vList);
        final uInt8List0 = vList0.buffer.asUint8List();
        final bytes = Float64Mixin.toBytes(vList0);
        expect(bytes, equals(uInt8List0));
      }
    });

    test('Float64Base.toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final vList0 = Float64List.fromList(vList);
        final bd0 = vList0.buffer.asByteData();
        final lBd0 = Float64Mixin.toByteData(vList0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()},'
            ' bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd0.buffer == bd0.buffer, true);

        final lBd1 = Float64Mixin.toByteData(vList0, asView: false);
        log.debug('lBd1: ${lBd1.buffer.asUint8List()},'
            ' bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, false);

        final vList1 = rng.float32List(1, 1);
        final float32List0 = Float32List.fromList(vList1);
        final bd1 = float32List0.buffer.asByteData();
        final lBd2 = Float64Mixin.toByteData(float32List0);

        log.debug('lBd2: ${lBd2.buffer.asUint8List()},'
            ' bd1: ${bd1.buffer.asUint8List()}');
        expect(lBd2.buffer.asUint8List(), isNot(bd1.buffer.asUint8List()));
        expect(lBd2.buffer == bd1.buffer, false);
      }
    });

    test('Float64Base fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final bd = Bytes.typedDataView(vList0);
        expect(Float64Mixin.fromBytes(bd), equals(vList0));
      }
      final vList1 = Float64List.fromList(<double>[]);
      final bd0 = Bytes.typedDataView(vList1);
      expect(Float64Mixin.fromBytes(bd0), equals(<double>[]));
    });

    test('Float64Base.fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final float = Float64List.fromList(vList);
        final byteData0 = float.buffer.asByteData();
        expect(Float64Mixin.fromByteData(byteData0), equals(vList));
      }
      final float0 = Float64List.fromList(<double>[]);
      final bd0 = float0.buffer.asByteData();
      expect(Float64Mixin.fromByteData(bd0), equals(<double>[]));
    });

    test('Float64Base fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final byte0 = Bytes.typedDataView(vList0);
        final fb0 = Float64Mixin.fromBytes(byte0);
        final vList1 = byte0.asFloat64List();
        log.debug('formBytes: $fb0, Flaot32List: $vList1');
        expect(fb0, equals(vList1));
      }
    });

    test('Float64Base fromValueField', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final fvF0 = Float64Mixin.fromValueField(vList);
        expect(fvF0, equals(vList));

        final fvF1 = Float64Mixin.fromValueField(null);
        expect(fvF1, equals(<double>[]));

        final fvF2 = Float64Mixin.fromValueField(<double>[]);
        expect(fvF2, equals(<double>[]));

        final fvF3 = Float64Mixin.fromValueField(<double>[123.54]);
        expect(fvF3, equals(<double>[123.54]));

        final byte0 = Bytes.typedDataView(vList);
        final fvF4 = Float64Mixin.fromValueField(byte0);
        expect(fvF4, isNotNull);

        final bytes1 = Bytes.typedDataView(vList);
        final fvF5 = Float64Mixin.fromValueField(bytes1);
        final data = Float64Mixin.fromBytes(bytes1);
        expect(fvF5, equals(data));
      }

      global.throwOnError = false;
      final fvF6 = Float64Mixin.fromValueField(<String>['foo']);
      expect(fvF6, isNull);

      global.throwOnError = true;
      expect(() => Float64Mixin.fromValueField(<String>['foo']),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('Float64Base toUint8List', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.float64List(1, i);
        final float64 = Float64List.fromList(vList0);
        final u8List0 = float64.buffer.asUint8List();
        final uInt8list0 = Float64Mixin.toUint8List(vList0);
        log.debug('uInt8List0: $uInt8list0, u8List: $u8List0');
        expect(uInt8list0, equals(u8List0));

        final uInt8list1 = Float64Mixin.toUint8List(vList0, asView: false);
        log.debug('uInt8List1: $uInt8list1, u8List: $u8List0');
        expect(uInt8list1, equals(u8List0));
      }

      final uInt8List2 = Float64Mixin.toUint8List(<double>[]);
      expect(uInt8List2 == kEmptyUint8List, true);

      final vList1 = rng.float32List(1, 1);
      final float32 = Float32List.fromList(vList1);
      final u8List1 = float32.buffer.asUint8List();
      final uInt8List3 = Float64Mixin.toUint8List(vList1);
      expect(uInt8List3, isNot(u8List1));
    });

    test('float646Base getLength', () {
      for (var i = 8; i < 80; i += 8) {
        final vList = rng.float64List(i, i);
        final getLen0 = Float64Mixin.getLength(vList.length);
        final length = vList.length ~/ Float64Mixin.kSizeInBytes;
        expect(getLen0 == length, true);
      }
    });
  });
}
