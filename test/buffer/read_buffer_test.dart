//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'bytes_test.dart', level: Level.info);
  final rng = RNG();
  group('Bytes Tests', () {
    test('DicomReadBuffer', () {
      final vList0 = ['1q221', 'sadaq223'];
      final bytes0 = Bytes.asciiFromList(vList0);
      final rBuf = DicomReadBuffer(bytes0);
      log.debug('dReadBuffer0:$rBuf');

      expect(rBuf.bytes.buf.buffer == bytes0.buffer, true);
      expect(rBuf.bytes == bytes0, true);
      expect(rBuf.length == bytes0.length, true);
      expect(rBuf.bytes.buf.buffer.lengthInBytes == bytes0.buffer.lengthInBytes,
          true);
      expect(rBuf.rIndex == 0, true);
      expect(rBuf.wIndex == bytes0.length, true);

      log.debug('dReadBuffer0.readCode(): ${rBuf.readCode()}');
    });

    test('ReadBuffer', () {
      final vList0 = rng.uint8List(1, 10);
      final bytes = Uint8.toBytes(vList0);
      final rBuf0 = ReadBuffer(bytes);
      log.debug('readBuffer0: $rBuf0');

      expect(rBuf0.rIndex == bytes.offset, true);
      expect(rBuf0.wIndex == bytes.length, true);
      expect(
          rBuf0.bytes.buf.buffer.asUint8List().elementAt(0) == vList0[0], true);
      expect(rBuf0.offset == bytes.offset, true);
      expect(rBuf0.bytes == bytes, true);

      final rBuf1 = ReadBuffer.fromList(vList0);
      log.debug('readBuffer1: $rBuf1');

      expect(rBuf1.rIndex == bytes.offset, true);
      expect(rBuf1.wIndex == bytes.length, true);
      expect(
          rBuf1.bytes.buf.buffer.asUint8List().elementAt(0) == vList0[0], true);
      expect(rBuf1.offset == bytes.offset, true);
      expect(rBuf1.bytes == bytes, true);
    });

    test('ReadBuffer.from', () {
      final vList0 = rng.uint8List(1, 10);
      final bytes = Uint8.toBytes(vList0);
      final readBuffer0 = ReadBuffer(bytes);
      log.debug('readBuffer0: $readBuffer0');

      expect(readBuffer0.rIndex == bytes.offset, true);
      expect(readBuffer0.wIndex == bytes.length, true);
      expect(
          readBuffer0.bytes.buf.buffer.asUint8List().elementAt(0) == vList0[0],
          true);
      expect(readBuffer0.offset == bytes.offset, true);
      expect(readBuffer0.bytes == bytes, true);

      final from0 = ReadBuffer.from(readBuffer0);
      log.debug('ReadBuffer.from: $from0');

      expect(from0.rIndex == bytes.offset, true);
      expect(from0.wIndex == bytes.length, true);
      expect(
          from0.bytes.buf.buffer.asUint8List().elementAt(0) == vList0[0], true);
      expect(from0.offset == bytes.offset, true);
      expect(from0.bytes == bytes, true);
    });

    test('ReadBuffer readAscii', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint8List(1, i);
        final bytes = Uint8.toBytes(vList0);
        final readBuffer0 = ReadBuffer(bytes);
        log.debug('readBuffer0: $readBuffer0');

        final readAscii0 = readBuffer0.readAscii(vList0.length);
        log.debug('readAscii: $readAscii0');
        expect(readAscii0 == ascii.decode(vList0), true);
      }
    });

    test('ReadBuffer readUtf8', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint8List(1, i);
        final bytes = Uint8.toBytes(vList0);
        final readBuffer0 = ReadBuffer(bytes);
        log.debug('readBuffer0: $readBuffer0');

        final readUtf80 = readBuffer0.readUtf8(vList0.length);
        log.debug('readUtf8: $readUtf80');
        expect(readUtf80 == utf8.decode(vList0), true);
      }
    });

    test('ReadBuffer readUint8List', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint8List(1, i);
        final bytes = Uint8.toBytes(vList0);
        final readBuffer0 = ReadBuffer(bytes);
        log.debug('readBuffer0: $readBuffer0');

        final v = readBuffer0.readUint8List(vList0.length);
        log.debug('readUtf8: $v');
        expect(v, equals(vList0));
      }
    });

    test('ReadBuffer readUint16List', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(1, i);
        final bytes = Uint16.toBytes(vList0);
        final readBuffer0 = ReadBuffer(bytes);
        log.debug('readBuffer0: $readBuffer0');

        final v = readBuffer0.readUint16List(vList0.length);
        log.debug('readUtf16: $v');
        expect(v, equals(vList0));
      }
    });

    test('ReadBuffer readUint32List', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(1, i);
        final bytes = Uint32.toBytes(vList0);
        final readBuffer0 = ReadBuffer(bytes);
        log.debug('readBuffer0: $readBuffer0');
        final v = readBuffer0.readUint32List(vList0.length);
        log.debug('readUint32: $v');
        expect(v, equals(vList0));
      }
    });
  });
}
