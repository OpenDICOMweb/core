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

void main() {
  Server.initialize(name: 'list_root_dataset_test', level: Level.info);

  group('ListRootDataset', () {
    test('[] and []=', () {
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      const ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransFerSyntax =
          new UItag.fromStrings(PTag.kTransferSyntaxUID, [ts.asString]);
      log.debug('ui: $uiTransFerSyntax');
      rds[uiTransFerSyntax.index] = uiTransFerSyntax;
      log.debug('elements: $rds');
      final v = rds[uiTransFerSyntax.index];
      log.debug('elements[${uiTransFerSyntax.index}] = $v');
    });

    test('insert and compare', () {
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      rds[as0.code] = as0;
      rds[ss0.code] = ss0;
      rds[fd0.code] = fd0;
      log.debug('rds : $rds');

      final as1 = rds[as0.code];
      expect(as1 == as0, true);

      final da1 = rds[ss0.code];
      expect(da1 == ss0, true);

      final fd1 = rds[fd0.code];
      expect(fd1 == fd0, true);
    });

    test('update (String)', () {
      system.throwOnError = false;
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      rds[as0.code] = as0;

      final update0 = rds.update(as0.code, <String>[]);
      expect(update0.isEmpty, false);
    });

    test('update (int)', () {
      system.throwOnError = false;
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      final vList0 = [kInt16Min];
      final ss0 = new SStag(PTag.kSelectorSSValue, vList0);
      //rds.add(ss0);
      rds[ss0.code] = ss0;

      final vList1 = [kInt16Max];
      final update1 = rds.update(ss0.code, vList1).values;
      expect(update1, equals(vList0));

      final update2 = rds.update(ss0.code, <int>[]);
      expect(update2.values.isEmpty, false);
    });

    test('update (float)', () {
      system.throwOnError = false;
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      rds[fd0.code] = fd0;
      final update1 = rds.update(fd0.code, <double>[]);
      expect(update1.isEmpty, false);
    });

    test('duplicate', () {
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final as1 = new AStag(PTag.kPatientAge, ['024Y']);
      final as2 = new AStag(PTag.kPatientAge, ['012M']);
      final ob0 = new OBtag(PTag.kICCProfile, [123], 2);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      rds[fd0.code] = fd0;
      rds[fd1.code] = fd1;
      rds[as0.code] = as0;
      rds[as1.code] = as1;
      rds[as2.code] = as2;
      rds[ob0.code] = ob0;
      rds[ae0.code] = ae0;

      final dup = rds.duplicates;
      log.debug('rds: $rds, dup: $dup');
      expect(dup, isNotNull);
    });

    test('removeDuplicates', () {
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final as1 = new AStag(PTag.kPatientAge, ['024Y']);
      final as2 = new AStag(PTag.kPatientAge, ['012M']);
      final ob0 = new OBtag(PTag.kICCProfile, [123], 2);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      rds[fd0.code] = fd0;
      rds[fd1.code] = fd1;
      rds[as0.code] = as0;
      rds[as1.code] = as1;
      rds[as2.code] = as2;
      rds[ob0.code] = ob0;
      rds[ae0.code] = ae0;

      final dup = rds.duplicates;
      log.debug('rds: $rds, dup: $dup');
      expect(dup, isNotNull);
      final removeDup = rds.deleteDuplicates();
      log.debug('rds: $rds, removeDup: $removeDup');
      expect(dup, equals(<Element>[]));
      expect(removeDup, <Element>[]);
    });

    test('getElementsInRange', () {
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ob0 = new OBtag(PTag.kICCProfile, [123], 2);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      rds[fd0.code] = fd0;
      rds[as0.code] = as0;
      rds[ob0.code] = ob0;
      rds[ae0.code] = ae0;

      final inRange0 = rds.getElementsInRange(0, fd0.code);
      final inRange1 = rds.getElementsInRange(0, fd0.code + 1);
      final inRange2 = rds.getElementsInRange(0, ae0.code);
      final inRange3 = rds.getElementsInRange(0, ae0.code + 1);
      log
        ..debug('rds: $rds')
        ..debug('inRange0: $inRange0')
        ..debug('inRange1: $inRange1')
        ..debug('inRange2: $inRange2')
        ..debug('inRange3: $inRange3');

      expect(inRange0, isNotNull);
    });

    test('Simple UItag, replace, and replaceUid test', () {
      const uidString0 = '1.2.840.10008.5.1.4.34.5';
      const uidString0a = '1.2.840.10008.5.1.4.34';
      final uidStringList0 = [uidString0];
      final uidStringList0a = [uidString0a];
      final uid0 = new Uid(uidString0);
      final uid0a = new Uid(uidString0a);
      final uidList0 = [uid0];
      final uidList0a = [uid0a];

      // Create element and check values and uids
      final ui0 = new UItag(PTag.kSelectorUIValue, uidList0);
      log.debug('values: ${ui0.values}');
      expect(ui0.values, equals(uidStringList0));
      expect(ui0.value, equals(uidString0));
      log.debug('values: ${ui0.uids}');
      expect(ui0.uids, equals(uidList0));
      expect(ui0.uids.elementAt(0), equals(uid0));

      // Test replace
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      rds[ui0.code] = ui0;

      final uidStringList0b = rds.replace(ui0.code, uidStringList0a);
      expect(uidStringList0b, equals(uidStringList0));
      expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

      // Test replaceUid
      final uidList0b = rds.replaceUids(ui0.code, uidList0a);
      log.debug('uidList0b: $uidList0b');
      expect(uidList0b, equals(uidList0));
      expect(uidList0b.elementAt(0), equals(uidList0[0]));
    });

    test('Simple UItag.fromString, replace, and replaceUid test', () {
      const uidString0 = '1.2.840.10008.5.1.4.34.5';
      const uidString0a = '1.2.840.10008.5.1.4.34';
      final uidStringList0 = [uidString0];
      final uidStringList0a = [uidString0a];
      final uid0 = new Uid(uidString0);
      final uid0a = new Uid(uidString0a);
      final uidList0 = [uid0];
      final uidList0a = [uid0a];

      // Create element and check values and uids
      final ui0 = new UItag.fromStrings(PTag.kSelectorUIValue, uidStringList0);
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      rds[ui0.code] = ui0;

      log.debug('values: ${ui0.values}');
      expect(ui0.values, equals(uidStringList0));
      expect(ui0.value, equals(uidStringList0[0]));
      log.debug('values: ${ui0.uids}');
      expect(ui0.uids, equals(uidList0));
      expect(ui0.uids.elementAt(0), equals(uidList0[0]));

      // Test replace
      final uidStringList0b = rds.replace(ui0.code, uidStringList0a);
      expect(uidStringList0b, equals(uidStringList0));
      expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

      // Test replaceUid
      final uidList0b = rds.replaceUids(ui0.code, uidList0a);
      log.debug('uidList0b: $uidList0b');
      expect(uidList0b, equals(uidList0));
      expect(uidList0b.elementAt(0), equals(uidList0[0]));
    });

    test('Simple Random UItag, replace, and replaceUid test', () {
      const count = 8;
      for (var i = 1; i < count; i++) {
        final uidList0 = Uid.randomList(count);
        final uidList0a = Uid.randomList(count);
        final uidStringList0 = UI.toStringList(uidList0);
        final uidStringList0a = UI.toStringList(uidList0a);

        // Create element and check values and uids
        log.debug('uidList0: $uidList0');
        final ui0 = new UItag(PTag.kSelectorUIValue, uidList0);
        log.debug('ui0: $ui0');
        final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
        rds[ui0.code] = ui0;

        log.debug('values: ${ui0.values}');
        expect(ui0.values, equals(uidStringList0));
        expect(ui0.value, equals(uidStringList0[0]));
        log.debug('values: ${ui0.uids}');
        expect(ui0.uids, equals(uidList0));
        expect(ui0.uids.elementAt(0), equals(uidList0[0]));

        // Test replace
        final uidStringList0b = rds.replace(ui0.code, uidStringList0a);
        expect(uidStringList0b, equals(uidStringList0));
        expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

        // Test replaceUid
        final uidList0b = rds.replaceUids(ui0.code, uidList0a);
        log.debug('uidList0b: $uidList0b');
        expect(uidList0b, equals(uidList0));
        expect(uidList0b.elementAt(0), equals(uidList0[0]));
      }
    });

    test('Simple Random UItag.fromString, replace, and replaceUid test', () {
      final rsg = new RSG(seed: 1);
      const count = 8;
      for (var i = 1; i < count; i++) {
        final uidStringList0 = rsg.getUIList(1, 1);
        final uidStringList0a = rsg.getUIList(1, 1);
        final uid0 = new Uid(uidStringList0[0]);
        final uid0a = new Uid(uidStringList0a[0]);
        final uidList0 = [uid0];
        final uidList0a = [uid0a];

        // Create element and check values and uids
        final ui0 =
            new UItag.fromStrings(PTag.kSelectorUIValue, uidStringList0);
        final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
        rds[ui0.code] = ui0;

        log.debug('values: ${ui0.values}');
        expect(ui0.values, equals(uidStringList0));
        expect(ui0.value, equals(uidStringList0[0]));
        log.debug('values: ${ui0.uids}');
        expect(ui0.uids, equals(uidList0));
        expect(ui0.uids.elementAt(0), equals(uidList0[0]));

        // Test replace
        final uidStringList0b = ui0.replace(uidStringList0a);
        expect(uidStringList0b, equals(uidStringList0));
        expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

        // Test replaceUid
        final uidList0b = rds.replaceUids(ui0.code, uidList0a);
        log.debug('uidList0b: $uidList0b');
        expect(uidList0b, equals(uidList0b));
        expect(uidList0b.elementAt(0), equals(uidList0b[0]));
      }
    });

    test('replace', () {
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      final vList0 = [15.24];
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, vList0);
      rds[fd0.code] = fd0;

      final vList1 = [123];
      expect(rds.replace(fd0.index, vList1), equals(vList0));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));

      system.throwOnError = true;
      final vList2 = ['024Y'];
      final as0 = new AStag(PTag.kPatientAge, vList2);
      final vList3 = [123];
      system.throwOnError = true;
      expect(() => rds.replace(as0.index, vList3, required: true),
          throwsA(const isInstanceOf<ElementNotPresentError>()));
    });

    test('replaceAll', () {
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      final vList0 = [15.24];
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, vList0);
      rds[fd0.code] = fd0;

      final vList1 = [123];
      final replaceA0 = rds.replaceAll(fd0.index, vList1);
      log.debug('replaceA0 : $replaceA0');
      expect(replaceA0, equals([vList0, vList1]));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));
    });

    test('== and hashCode', () {
      final rds0 = new ListRootDataset.empty('', kEmptyBytes, 0);
      final rds1 = new ListRootDataset.empty('', kEmptyBytes, 0);
      final rds2 = new ListRootDataset.empty('', kEmptyBytes, 0);

      final cs0 = new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final cs1 = new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final cs2 = new CStag(PTag.kImageFormat, ['FOO']);

      rds0[cs0.code] = cs0;
      rds1[cs1.code] = cs1;
      rds2[cs2.code] = cs2;

      log.debug(
          'rds.hashCode: ${rds0.hashCode}, map1.hashCode : ${rds1.hashCode}'
          ', map2.hashCode : ${rds2.hashCode}');

      expect(rds0 == rds1, true);
      expect(rds0.hashCode, equals(rds1.hashCode));

      expect(rds0 == rds2, false);
      expect(rds0.hashCode, isNot(rds2.hashCode));

      expect(rds1 == rds2, false);
      expect(rds1.hashCode, isNot(rds2.hashCode));
    });

    test('others', () {
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);

      rds[as0.code] = as0;

      expect(rds.toList(), equals([as0]));
      expect(rds.toList(), equals([as0]));
      expect(rds.codes, equals([as0.code]));
      expect(rds.codes, equals([as0.code]));
      expect(rds.length == as0.length, true);
    });

    test('copy', () {
      final rds = new ListRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      rds[as0.code] = as0;
      rds[ss0.code] = ss0;
      rds[fd0.code] = fd0;
      log.debug('rds : $rds');

      final copy0 = rds.copy();
      log.debug('copy0: $copy0');
      expect(copy0, equals(new ListRootDataset.from(rds)));
      expect(copy0, equals(rds));
    });
  });
}
