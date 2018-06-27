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

RSG rsg = new RSG(seed: 1);
RNG rng = new RNG(1);

void main() {
  Server.initialize(name: 'bd_element/ui_test', level: Level.info);

  final rds = new ByteRootDataset.empty();

  group('UIbytes', () {
    //VM.k1
    const uiVM1Tags = const <int>[
      kAffectedSOPInstanceUID,
      kRequestedSOPInstanceUID,
      kMediaStorageSOPClassUID,
      kTransferSyntaxUID,
      kImplementationClassUID,
      kInstanceCreatorUID,
      kSOPClassUID,
      kSOPInstanceUID,
      kOriginalSpecializedSOPClassUID,
      kCodingSchemeUID,
      kStudyInstanceUID,
      kSeriesInstanceUID,
      kDimensionOrganizationUID,
      kSpecimenUID,
    ];

    //VM.k1_n
    const uiVM1_nTags = const <int>[
      kRelatedGeneralSOPClassUID,
      kFailedSOPInstanceUIDList,
      kSelectorUIValue
    ];

    test('UIbytes from VM.k1', () {
      global.throwOnError = false;
      global.level = Level.debug;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        for (var code in uiVM1Tags) {
          final e0 = UIbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('UIbytes from VM.k1 bad length', () {
      global.throwOnError = false;
      global.level = Level.debug;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getUIList(2, i + 1);
        for (var code in uiVM1Tags) {
          final e0 = UIbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('UIbytes from VM.k1_n', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, i);
        for (var code in uiVM1_nTags) {
          final e0 = UIbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });
  });
}
