//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/float32_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  group('FLtag', () {
    test('FLoat32Base toFloat32', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        expect(Float32Mixin.fromList(vList), vList);
      }
    });

    test('Float32Base fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final bd = Bytes.typedDataView(vList0);
        expect(Float32Mixin.fromBytes(bd), equals(vList0));
      }
      final vList1 = Float32List.fromList(<double>[]);
      final bd0 = Bytes.typedDataView(vList1);
      expect(Float32Mixin.fromBytes(bd0), equals(<double>[]));
    });

    test('Float32Base toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(0, i);
        final vList0 = Float32List.fromList(vList);
        final uInt8List0 = vList0.buffer.asUint8List();
        final bytes = Float32Mixin.toBytes(vList0);
        expect(bytes, equals(uInt8List0));
      }
    });

    test('Float32Base.toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final vList0 = Float32List.fromList(vList);
        final bd0 = vList0.buffer.asByteData();
        final lBd0 = Float32Mixin.toByteData(vList0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()},'
            ' bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd0.buffer == bd0.buffer, true);

        final lBd1 = Float32Mixin.toByteData(vList0, asView: false);
        log.debug('lBd1: ${lBd1.buffer.asUint8List()},'
            ' bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, false);

        final vList1 = rng.float64List(1, 1);
        final float64List0 = Float64List.fromList(vList1);
        final bd1 = float64List0.buffer.asByteData();
        final lBd2 = Float32Mixin.toByteData(float64List0);

        log.debug('lBd2: ${lBd2.buffer.asUint8List()},'
            ' bd1: ${bd1.buffer.asUint8List()}');
        expect(lBd2.buffer.asUint8List(), isNot(bd1.buffer.asUint8List()));
        expect(lBd2.buffer == bd1.buffer, false);
      }
    });

    test('Float32Base fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final bd = Bytes.typedDataView(vList0);
        expect(Float32Mixin.fromBytes(bd), equals(vList0));
      }
      final vList1 = Float32List.fromList(<double>[]);
      final bd0 = Bytes.typedDataView(vList1);
      expect(Float32Mixin.fromBytes(bd0), equals(<double>[]));
    });

    test('Float32Base.fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float = Float32List.fromList(vList);
        final byteData0 = float.buffer.asByteData();
        expect(Float32Mixin.fromByteData(byteData0), equals(vList));
      }
      final float0 = Float32List.fromList(<double>[]);
      final bd0 = float0.buffer.asByteData();
      expect(Float32Mixin.fromByteData(bd0), equals(<double>[]));
    });

    test('Float32Base fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final byte0 = Bytes.typedDataView(vList0);
        final fb0 = Float32Mixin.fromBytes(byte0);
        final vList1 = byte0.asFloat32List();
        log.debug('formBytes: $fb0, Flaot32List: $vList1');
        expect(fb0, equals(vList1));
      }
    });

    test('Float32Bae fromValueField', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final fvF0 = Float32Mixin.fromValueField(vList);
        expect(fvF0, equals(vList));

        final fvF1 = Float32Mixin.fromValueField(null);
        expect(fvF1, equals(<double>[]));

        final fvF2 = Float32Mixin.fromValueField(<double>[]);
        expect(fvF2, equals(<double>[]));

        final fvF3 = Float32Mixin.fromValueField(<double>[123.54]);
        expect(fvF3, equals(<double>[123.54]));

        final byte0 = Bytes.typedDataView(vList);
        final fvF4 = Float32Mixin.fromValueField(byte0);
        expect(fvF4, isNotNull);

        final bytes1 = Bytes.typedDataView(vList);
        final fvF5 = Float32Mixin.fromValueField(bytes1);
        final data = Float32Mixin.fromBytes(bytes1);
        expect(fvF5, equals(data));
      }

      global.throwOnError = false;
      final fvF6 = Float32Mixin.fromValueField(<String>['foo']);
      expect(fvF6, isNull);

      global.throwOnError = true;
      expect(() => Float32Mixin.fromValueField(<String>['foo']),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('Float32Base toUint8List', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.float32List(1, i);
        final float32 = Float32List.fromList(vList0);
        final u8List0 = float32.buffer.asUint8List();
        final uInt8list0 = Float32Mixin.toUint8List(vList0);
        log.debug('uInt8List0: $uInt8list0, u8List: $u8List0');
        expect(uInt8list0, equals(u8List0));

        final uInt8list1 = Float32Mixin.toUint8List(vList0, asView: false);
        log.debug('uInt8List1: $uInt8list1, u8List: $u8List0');
        expect(uInt8list1, equals(u8List0));
      }

      final uInt8List2 = Float32Mixin.toUint8List(<double>[]);
      expect(uInt8List2 == kEmptyUint8List, true);

      final vList1 = rng.float64List(1, 1);
      final float64 = Float64List.fromList(vList1);
      final u8List1 = float64.buffer.asUint8List();
      final uInt8List3 = Float32Mixin.toUint8List(vList1);
      expect(uInt8List3, isNot(u8List1));
    });

    test('float326Base getLength', () {
      for (var i = 4; i < 40; i += 4) {
        final vList = rng.float32List(i, i);
        final getLen0 = Float32Mixin.getLength(vList.length);
        final length = vList.length ~/ Float32Mixin.kSizeInBytes;
        expect(getLen0 == length, true);
      }
    });
  });
}
