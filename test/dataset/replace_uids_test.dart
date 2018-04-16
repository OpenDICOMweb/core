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

void main() {
  Server.initialize(name: 'replace_uids', level: Level.info);

  group('RootDataset', () {
    test('update', () {
      final ui0 = new UItag.fromStrings(
          PTag.kStudyInstanceUID, ['1.2.840.10008.5.1.4.34.5']);
      log.debug('ui0: $ui0');

      final rootDS0 = new TagRootDataset.empty();

      // Test for element not present with system.throwOnError
      system.throwOnError = false;
      expect(rootDS0.update(ui0.tag.index, <Uid>[]), isNull);
      expect(rootDS0.update(ui0.tag.index, <Uid>[], required: true), isNull);
      expect(rootDS0.update(ui0.tag.index, <String>['1.804.35.0.89']), isNull);
      expect(
          rootDS0.update(ui0.tag.index, <String>['1.804.35.0.89'],
              required: true),
          isNull);

      system.throwOnError = true;
      expect(() => rootDS0.update(ui0.tag.index, <Uid>[], required: true),
          throwsA(const isInstanceOf<ElementNotPresentError>()));
      expect(
          () => rootDS0.update(ui0.tag.index, <String>['1.804.35.0.89'],
              required: true),
          throwsA(const isInstanceOf<ElementNotPresentError>()));
    });

    test('updateUid', () {
      //Begin: Test for updateUid on Elements with VM.k1
      system.throwOnError = false;
      final ui0 = new UItag.fromStrings(
          PTag.kStudyInstanceUID, ['1.2.840.10008.5.1.4.34.5']);
      log.debug('ui0: $ui0');

      final rootDS0 = new TagRootDataset.empty();

      // Test for element not present with system.throwOnError
      system.throwOnError = true;
      expect(rootDS0.updateUid(ui0.tag.index, <Uid>[]), isNull);

      // Test for element not present without system.throwOnError
      system.throwOnError = false;
      expect(
          rootDS0.updateUid(ui0.tag.index, <Uid>[], required: false), isNull);

      // Test for non empty list
      final uidList1 = ['2.16.840.1.113662.2.1.1519.11582'];
      final ui1 = new UItag.fromStrings(PTag.kStudyInstanceUID, uidList1);
      final rootDS1 = new TagRootDataset.empty()..add(ui1);
      log.debug('ui1: $ui1');
      final uidList1r = ['1.2.840.10008.5.1.1.16.376'];
      final v = Uid.isValidStringList(uidList1r);
      log.debug('$uidList1r isValid: $v');
      final ui1r = rootDS1.update(ui1.tag.code, uidList1r);
      log.debug('ui1r: $ui1r');
      expect(ui1r is UI, isTrue);
      expect(ui1r.values, equals(uidList1));
      expect(ui1r.value == uidList1[0], true);

      final uidList2 = ['1.2.840.10008.3.1.2.5.4'];
      final ui2 = new UItag.fromStrings(PTag.kSeriesInstanceUID, uidList2);
      final rootDS2 = new TagRootDataset.empty()..add(ui2);
      final uidList2r = ['1.2.840.10008.1.4.1.13'];
      expect(Uid.isValidStringList(uidList2r), true);
      final ui2r = rootDS2.update(ui2.tag.code, uidList2r);
      expect(ui2r is UI, true);
      expect(ui2r.values, equals(uidList2));
      expect(ui2r.value == uidList2[0], true);

      final rootDS4 = new TagRootDataset.empty();
      final uidList3 = ['2.16.840.1.113662.2.1.1519.11582'];
      final ui4 = new UItag.fromStrings(PTag.kStudyInstanceUID, uidList3);
      rootDS4.add(ui4);
      final uidList3r = ['1.2.840.10008.5.1.1.17'];
      expect(Uid.isValidStringList(uidList3r), true);
      final ui4r = rootDS4.update(ui4.tag.code, uidList3r);
      expect(ui4r is UI, true);
      expect(ui4r.values, equals(uidList3));
      expect(ui4r.value, equals(uidList3[0]));

      //Passing values greater than valid VM
      system.throwOnError = false;
      final ui4r1 =
          rootDS4.update(ui4.tag.code, <String>['1.2.840.10008.5.1.4.1.1.1']);
      log.debug('ui4r1:$ui4r1');
      expect(ui4r1, isNotNull);

      //Passing values greater than valid VM
      system.throwOnError = false;
      final ui5r = rootDS4.update(
          PTag.kAbortReason.code, <String>['1.2.840.10008.5.1.4.1.1.1']);
      log.debug('ui4r1:$ui4r1');
      expect(ui5r, isNull);

      //Testing noValue on RootDatasetTag
      final rootDSNV = new TagRootDataset.empty();
      final uidListNV = ['2.16.840.1.113662.2.1.1519.11582'];
      final uiNV = new UItag.fromStrings(PTag.kStudyInstanceUID, uidListNV);
      rootDSNV.add(uiNV);

      var old = rootDSNV.noValues(uiNV.code);
      expect(old, equals(uiNV));
      final nv = rootDSNV[kStudyInstanceUID];
      log.debug('ui1NoValue:$nv');
      expect(nv.value, null);

      final uiValues3 = rootDSNV.updateUid(uiNV.tag.index, []);
      expect(uiValues3.values, equals(<String>[]));
      //End: Elements with VM.k1

      //Test for valid list values
      final uidList4 = ['1.2.840.10008.1.2.1', '1.2.840.10008.5.1.1.9'];
      final ui6 = new UItag.fromStrings(
          PTag.kReferencedRelatedGeneralSOPClassUIDInFile, uidList4);
      final rootDS6 = new TagRootDataset.empty()..add(ui6);
      log.debug('ui6: $ui6');
      final uidList4r = [
        '1.2.840.10008.5.1.4.1.1.30',
        '1.2.840.10008.5.1.4.1.1.77.5.4'
      ];
      expect(Uid.isValidStringList(uidList4r), true);
      final ui6r = rootDS6.update(ui6.tag.index, uidList4r);
      log.debug('ui6r: $ui6r');
      expect(ui6r is UI, isTrue);
      expect(ui6r.values == uidList4, true);
      expect(ui6r.value == uidList4[0], true);

      //Testing noValue on RootDatasetTag
      final rootDSNV1 = new TagRootDataset.empty();
      final uidListNV1 = [
        '1.2.840.10008.5.1.4.1.1.1',
        '1.2.840.10008.5.1.4.1.1.5'
      ];
      final uiNV1 =
          new UItag.fromStrings(PTag.kRelatedGeneralSOPClassUID, uidListNV1);
      rootDSNV1.add(uiNV1);
      old = rootDSNV1.noValues(uiNV1.code);
      expect(old, equals(uiNV1));
      final uiNoValue4 = rootDSNV1[kRelatedGeneralSOPClassUID];
      log.debug('uiNoValue4:$uiNoValue4');
      expect(uiNoValue4.value, null);

      final uiValues5 = rootDSNV1.update(uiNV1.tag.index, <String>[]);
      expect(uiValues5.values, equals(<String>[]));
      //End: Elements with VM.k1_n

      // Applying noValues on UI Element and adding the result element to
      // RootDatasetTag
      final rootDS10 = new TagRootDataset.empty();
      final uidList9 = <String>[
        '1.2.840.10008.5.1.1.40.1',
        '1.2.840.10008.5.1.4.1.1.1'
      ];
      final ui11 =
          new UItag.fromStrings(PTag.kRelatedGeneralSOPClassUID, uidList9);
      log.debug('ui11: $ui11');
      final ui11NV = ui11.noValues;
      log.debug('ui11NV: $ui11NV');

      rootDS10.add(ui11NV);
      final ui11NVR = rootDS10.update(ui11NV.tag.index, uidList9);
      expect(ui11NVR is UI, true);
      expect(ui11NVR.values.isEmpty, true);
    });
  });
}
