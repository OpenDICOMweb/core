//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/float32_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  group('FLtag', () {
    test('FLoat32Base toFloat32', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        expect(Float32.fromList(vList), vList);
      }
    });

    test('Float32Base fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final bd = new Bytes.typedDataView(vList0);
        expect(Float32.fromBytes(bd), equals(vList0));
      }
      final vList1 = new Float32List.fromList(<double>[]);
      final bd0 = new Bytes.typedDataView(vList1);
      expect(Float32.fromBytes(bd0), equals(<double>[]));
    });

    test('Float32Base toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(0, i);
        final vList0 = new Float32List.fromList(vList);
        final uInt8List0 = vList0.buffer.asUint8List();
        final bytes = Float32.toBytes(vList0);
        expect(bytes, equals(uInt8List0));
      }
    });

    test('Float32Base.toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final vList0 = new Float32List.fromList(vList);
        final bd0 = vList0.buffer.asByteData();
        final lBd0 = Float32.toByteData(vList0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
            .asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd0.buffer == bd0.buffer, true);

        final lBd1 = Float32.toByteData(vList0, asView: false);
        log.debug('lBd1: ${lBd1.buffer.asUint8List()}, bd0: ${bd0.buffer
            .asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, false);

        final vList1 = rng.float64List(1, 1);
        final float64List0 = new Float64List.fromList(vList1);
        final bd1 = float64List0.buffer.asByteData();
        final lBd2 = Float32.toByteData(float64List0);

        log.debug('lBd2: ${lBd2.buffer.asUint8List()}, bd1: ${bd1.buffer
            .asUint8List()}');
        expect(lBd2.buffer.asUint8List(), isNot(bd1.buffer.asUint8List()));
        expect(lBd2.buffer == bd1.buffer, false);
      }
    });

/*
test('Float32Base decodeJsonVF', () {
global.level = Level.info;
for (var i = 0; i < 10; i++) {
final vList = rng.float32List(0, i);
final vList0 = new Float32List.fromList(vList);
final uInt8List0 = vList0.buffer.asUint8List();
final base64 = cvt.base64.encode(uInt8List0);
final fl0 = Float32.fromBase64(base64);
log
..debug('  vList: $vList')
..debug('vList0: $vList0')
..debug('         fl0: $fl0');
expect(fl0, equals(vList));
expect(fl0, equals(vList0));
}
});
*/
/*

test('Float32Base toBase64', () {
for (var i = 0; i < 10; i++) {
final vList = rng.float32List(0, i);
final vList0 = new Float32List.fromList(vList);
final uInt8List0 = vList0.buffer.asUint8List();
final base64 = cvt.base64.encode(uInt8List0);
final s = Float32.toBase64(vList);
expect(s, equals(base64));
}
});
*/

/*
test('Float32Base encodeDecodeJsonVF', () {
for (var i = 1; i < 10; i++) {
final vList = rng.float32List(1, i);
final vList0 = new Float32List.fromList(vList);
final uInt8List0 = vList0.buffer.asUint8List();

// Encode
final base64 = cvt.base64.encode(uInt8List0);
log.debug('FL.base64: "$base64"');
final s = Float32.toBase64(vList);
log.debug('  FL.json: "$s"');
expect(s, equals(base64));

// Decode
final fl0 = Float32.fromBase64(base64);
log.debug('FL.base64: $fl0');
final fl1 = Float32.fromBase64(s);
log.debug('  FL.json: $fl1');
expect(fl0, equals(vList));
expect(fl0, equals(vList0));
expect(fl0, equals(fl1));
}
});
*/

    test('Float32Base fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final bd = new Bytes.typedDataView(vList0);
        expect(Float32.fromBytes(bd), equals(vList0));
      }
      final vList1 = new Float32List.fromList(<double>[]);
      final bd0 = new Bytes.typedDataView(vList1);
      expect(Float32.fromBytes(bd0), equals(<double>[]));
    });

    test('Float32Base.fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float = new Float32List.fromList(vList);
        final byteData0 = float.buffer.asByteData();
        expect(Float32.fromByteData(byteData0), equals(vList));
      }
      final float0 = new Float32List.fromList(<double>[]);
      final bd0 = float0.buffer.asByteData();
      expect(Float32.fromByteData(bd0), equals(<double>[]));
    });

    test('Float32Base fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final byte0 = new Bytes.typedDataView(vList0);
        final fb0 = Float32.fromBytes(byte0);
        final vList1 = byte0.asFloat32List();
        log.debug('formBytes: $fb0, Flaot32List: $vList1');
        expect(fb0, equals(vList1));
      }
    });

    test('Float32Bae fromValueField', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final fvF0 = Float32.fromValueField(vList);
        expect(fvF0, equals(vList));

        final fvF1 = Float32.fromValueField(null);
        expect(fvF1, equals(<double>[]));

        final fvF2 = Float32.fromValueField(<double>[]);
        expect(fvF2, equals(<double>[]));

        final fvF3 = Float32.fromValueField(<double>[123.54]);
        expect(fvF3, equals(<double>[123.54]));

        final byte0 = new Bytes.typedDataView(vList);
        final fvF4 = Float32.fromValueField(byte0);
        expect(fvF4, isNotNull);

        final bytes1 = new Bytes.typedDataView(vList);
        final fvF5 = Float32.fromValueField(bytes1);
        final data = Float32.fromBytes(bytes1);
        expect(fvF5, equals(data));
      }

      global.throwOnError = false;
      final fvF6 = Float32.fromValueField(<String>['foo']);
      expect(fvF6, isNull);

      global.throwOnError = true;
      expect(() => Float32.fromValueField(<String>['foo']),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });
  });
}
