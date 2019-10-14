//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = RSG(seed: 1);
RNG rng = RNG(1);

void main() {
  Server.initialize(name: 'element_bytes/pixel_data', level: Level.info);
  const type = BytesElementType.leLongEvr;

  group('OWbytes', () {
    test('OWbytes from VM.k1', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(1, i);
        final bytes = Bytes.typedDataView(vList0);
        global.throwOnError = false;
        final e0 = OWbytes.fromValues(kPixelData, vList0, type);
        log.debug('e0: $e0');
        const ts = TransferSyntax.kExplicitVRLittleEndian;
        final e1 = OWbytesPixelData.fromBytes(e0.be, ts);
        log.debug('e1: $e1');
        expect(e0 is Element, true);
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes == bytes, true);

        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vfBytes == bytes, true);

        expect(e0.code == e0.be.code, true);
        expect(e0.length == e0.be.length, true);
        expect(e0.vrCode == e0.be.vrCode, true);
        expect(e0.vrIndex == e0.be.vrIndex, true);
        expect(e0.vfLengthOffset == e0.be.vfLengthOffset, true);
        expect(e0.vfLengthField == e0.be.vfLengthField, true);
        expect(e0.vfLength == e0.be.vfLength, true);
        expect(e0.vfOffset == e0.be.vfOffset, true);
        expect(e0.vfBytes == e0.be.vfBytes, true);
        expect(e0.vfBytesLast == e0.be.vfBytesLast, true);
//        expect(e0.hashCode == e0.bytes.hashCode, true);
      }
    });
  });
}