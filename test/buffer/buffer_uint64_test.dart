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

  group('Bytes Uint16 Tests', () {
    test('DicomReadBuffer', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rng.uint64List(1, i);
        final bytes1 = Bytes.fromList(vList1);
        final rBuf = DicomReadBuffer(bytes1);
        log.debug('dReadBuffer1: $rBuf');

        expect(rBuf.bytes.buf.buffer == bytes1.buffer, true);
        expect(rBuf.bytes == bytes1, true);
        expect(rBuf.length == bytes1.length, true);
        expect(
            rBuf.bytes.buf.buffer.lengthInBytes == bytes1.buffer.lengthInBytes,
            true);
        expect(rBuf.rIndex == 0, true);
        expect(rBuf.wIndex == bytes1.length, true);
      }
    });
  });
}
