//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);
RNG rng = new RNG(1);

void main() {
  Server.initialize(name: 'bd_element/ob_test', level: Level.info);

  final rds = new ByteRootDataset.empty();

  group('OBbytes', () {
    const obVM1Tags0 = const <int>[
      kFileMetaInformationVersion,
      kPrivateInformation,
      kCoordinateSystemAxisValues,
      kBadPixelImage,
      kICCProfile,
      kObjectBinaryIdentifierTrial,
      kObjectDirectoryBinaryIdentifierTrial,
      kEncapsulatedDocument,
      kHPGLDocument,
      kFillPattern,
      kCertificateOfSigner,
      kSignature,
      kCertifiedTimestamp,
      kMAC,
      kEncryptedContent,
      kThreatROIBitmap,
      kDetectorCalibrationData,
      kDataSetTrailingPadding
    ];

    const obVM1_nTags1 = const <int>[
      kSelectorOBValue,
    ];

    test('OBbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        global.throwOnError = false;
        for (var code in obVM1Tags0) {
          final e0 = OBbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('OBbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint8List(1, i);
        global.throwOnError = false;
        for (var code in obVM1_nTags1) {
          final e0 = OBbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });
  });
}
