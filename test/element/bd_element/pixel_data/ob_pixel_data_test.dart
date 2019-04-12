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
import 'package:test_tools/tools.dart';

RSG rsg = RSG(seed: 1);
RNG rng = RNG(1);

void main() {
  Server.initialize(name: 'bd_element/pixel_data', level: Level.info);

  group('OBbytesPixelData', () {
    test('OBbytes from VM.k1', () {
      for (var i = 0; i < 20; i += 2) {
        // Only generate even length lists so Value Field will be correct
        final vList0 = rng.uint8List(i, i);
        final bytes = Bytes.fromList(vList0);
        global.throwOnError = false;
        final e0 = OBbytes.fromValues(kPixelData, vList0);
        log.debug('e0: $e0');
        const ts = TransferSyntax.kExplicitVRLittleEndian;
        final e1 = OBbytesPixelData.fromBytes(e0.bytes, ts);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes == bytes, true);

        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vfBytes == bytes, true);

        expect(e0.code == e0.bytes.code, true);
        expect(e0.eLength == e0.bytes.eLength, true);
        expect(e0.vrCode == e0.bytes.vrCode, true);
        expect(e0.vrIndex == e0.bytes.vrIndex, true);
        expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
        expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
        expect(e0.vfLength == e0.bytes.vfLength, true);
        expect(e0.vfOffset == e0.bytes.vfOffset, true);
        expect(e0.vfBytes == e0.bytes.vfBytes, true);
        expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
//        expect(e0.hashCode == e0.bytes.hashCode, true);
      }
    });
  });
}
