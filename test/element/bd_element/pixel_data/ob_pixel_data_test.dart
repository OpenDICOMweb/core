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

  group('OBbytes', () {
    test('OBbytes from VM.k1', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint8List(1, i);
        final bytes = Bytes.fromList(vList0);
        global.throwOnError = false;
        final e0 = OBbytes.fromValues(kPixelData, vList0);
        //final e0 = OBbytesPixelData(bytes);
        log.debug('e0: $e0');
        const ts = TransferSyntax.kExplicitVRLittleEndian;
        final e1 = ByteElement.makePixelDataFromBytes(e0.bytes, ts);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes == bytes, true);

        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vfBytes == bytes, true);
      }
    });
  });
}
