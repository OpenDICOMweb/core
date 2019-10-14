//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:base/base.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = RSG(seed: 1);

void main() {
  Server.initialize(name: 'list_root_dataset_test', level: Level.info);

  group('ListRootDataset', () {
    test('[] and []=', () {
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      const ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransFerSyntax = UItag(PTag.kTransferSyntaxUID, [ts.asString]);
      log..debug('ts: "${ts.asString}"')..debug('ui: $uiTransFerSyntax');
      rds[uiTransFerSyntax.index] = uiTransFerSyntax;
      log.debug('elements: $rds');
      final v = rds[uiTransFerSyntax.index];
      log.debug('elements[${uiTransFerSyntax.index}] = $v');
      expect(uiTransFerSyntax, equals(v));
    });

    test('insert and compare', () {
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);

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
      global.throwOnError = false;
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      rds[as0.code] = as0;

      final update0 = rds.update(as0.code, <String>[]);
      expect(update0.isEmpty, false);
    });

    test('update (int)', () {
      global.throwOnError = false;
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final vList0 = [kInt16Min];
      final ss0 = SStag(PTag.kSelectorSSValue, vList0);
      //rds.add(ss0);
      rds[ss0.code] = ss0;

      final vList1 = [kInt16Max];
      final update1 = rds.update(ss0.code, vList1).values;
      expect(update1, equals(vList0));

      final update2 = rds.update(ss0.code, <int>[]);
      expect(update2.values.isEmpty, false);
    });

    test('update (float)', () {
      global.throwOnError = false;
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);

      rds[fd0.code] = fd0;
      final update1 = rds.update(fd0.code, <double>[]);
      expect(update1.isEmpty, false);
    });

    test('duplicates', () {
      global.doTestElementValidity = true;
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final as1 = AStag(PTag.kPatientAge, ['024Y']);
      final as2 = AStag(PTag.kPatientAge, ['012M']);
      final ob0 = OBtag(PTag.kICCProfile, [123]);
      final ae0 = AEtag(PTag.kPerformedStationAETitle, ['3']);

      global.throwOnError = false;
      rds..add(fd0)..add(fd1)..add(as0)..add(as1)..add(as2)..add(ob0)..add(ae0);

/*
      rds[fd0.code] = fd0;
      rds[fd1.code] = fd1;
      rds[as0.code] = as0;
      rds[as1.code] = as1;
      rds[as2.code] = as2;
      rds[ob0.code] = ob0;
      rds[ae0.code] = ae0;
*/

      final dup = rds.duplicates;
      log.debug('rds: $rds, dup: $dup');
      expect(dup, isNotNull);
      expect(dup, equals(rds.history.duplicates));
      expect(rds.hasDuplicates, true);
      expect(rds.hasDuplicates == dup.isNotEmpty, true);
    });

    test('removeDuplicates', () {
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final as1 = AStag(PTag.kPatientAge, ['024Y']);
      final as2 = AStag(PTag.kPatientAge, ['012M']);
      final ob0 = OBtag(PTag.kICCProfile, [123]);
      final ae0 = AEtag(PTag.kPerformedStationAETitle, ['3']);

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
      expect(rds.hasDuplicates, false);
      expect(dup.isEmpty, true);
    });

    test('remove', () {
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final as1 = AStag(PTag.kPatientAge, ['024Y']);
      final as2 = AStag(PTag.kSelectorASValue, ['012M']);
      final ob0 = OBtag(PTag.kICCProfile, [123]);
      final ae0 = AEtag(PTag.kPerformedStationAETitle, ['3']);

      rds..add(fd0)..add(fd1)..add(as0)..add(as1)..add(as2)..add(ob0)..add(ae0);
      assert(rds.length == 5);
      final rem = rds.remove(fd0);
      log.debug('rem: $rem');
      assert(rds.length == 4);
      expect(rds.hasDuplicates, true);
    });

    test('getElementsInRange', () {
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final ob0 = OBtag(PTag.kICCProfile, [123]);
      final ae0 = AEtag(PTag.kPerformedStationAETitle, ['3']);

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
      final uid0 = Uid(uidString0);
      final uid0a = Uid(uidString0a);
      final uidList0 = [uid0];
      final uidList0a = [uid0a];

      // Create element and check values and uids
      final ui0 = UItag.fromUids(PTag.kSelectorUIValue, uidList0);
      log.debug('values: ${ui0.values}');
      expect(ui0.values.values, equals(uidStringList0));
      expect(ui0.value, equals(uidString0));
      log.debug('values: ${ui0.uids}');
      expect(ui0.uids, equals(uidList0));
      expect(ui0.uids.elementAt(0), equals(uid0));

      // Test replace
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
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
      final uid0 = Uid(uidString0);
      final uid0a = Uid(uidString0a);
      final uidList0 = [uid0];
      final uidList0a = [uid0a];

      // Create element and check values and uids
      final ui0 = UItag(PTag.kSelectorUIValue, uidStringList0);
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
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
        final ui0 = UItag.fromUids(PTag.kSelectorUIValue, uidList0);
        log.debug('ui0: $ui0');
        final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
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
      final rsg = RSG(seed: 1);
      const count = 8;
      for (var i = 1; i < count; i++) {
        final uidStringList0 = rsg.getUIList(1, 1);
        final uidStringList0a = rsg.getUIList(1, 1);
        final uid0 = Uid(uidStringList0[0]);
        final uid0a = Uid(uidStringList0a[0]);
        final uidList0 = [uid0];
        final uidList0a = [uid0a];

        // Create element and check values and uids
        final ui0 = UItag(PTag.kSelectorUIValue, uidStringList0);
        final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
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
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final vList0 = [15.24];
      final fd0 = FDtag(PTag.kBlendingWeightConstant, vList0);
      rds[fd0.code] = fd0;

      final vList1 = [1.23];
      expect(rds.replace(fd0.index, vList1), equals(vList0));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));

      global.throwOnError = true;
      final vList2 = ['024Y'];
      final as0 = AStag(PTag.kPatientAge, vList2);
      final vList3 = [123];
      global.throwOnError = true;
      expect(() => rds.replace(as0.index, vList3, required: true),
          throwsA(const TypeMatcher<ElementNotPresentError>()));
    });

    test('replaceAll', () {
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final vList0 = [15.24];
      final fd0 = FDtag(PTag.kBlendingWeightConstant, vList0);
      rds[fd0.code] = fd0;

      final vList1 = [1.23];
      final replaceA0 = rds.replaceAll(fd0.index, vList1);
      log.debug('replaceA0 : $replaceA0');
      expect(replaceA0, equals([vList0, vList1]));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));
    });

    test('== and hashCode', () {
      final rds0 = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final rds1 = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final rds2 = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);

      final cs0 = CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final cs1 = CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final cs2 = CStag(PTag.kImageFormat, ['FOO']);

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
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);

      rds[as0.code] = as0;

      expect(rds.toList(), equals([as0]));
      expect(rds.toList(), equals([as0]));
      expect(rds.codes, equals([as0.code]));
      expect(rds.codes, equals([as0.code]));
      expect(rds.length == as0.length, true);
    });

    test('copy', () {
      final rds = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);

      rds[as0.code] = as0;
      rds[ss0.code] = ss0;
      rds[fd0.code] = fd0;
      log.debug('rds : $rds');

      final copy0 = rds.copy();
      log.debug('copy0: $copy0');
      expect(copy0, equals(ListRootDataset.from(rds)));
      expect(copy0, equals(rds));
    });

    test('noValues', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);

      item[fd0.code] = fd0;
      item[as0.code] = as0;

      var noValues0 = item.noValues(fd0.code);
      expect(noValues0 == fd0, true);
      expect(noValues0.values.isEmpty, false);

      noValues0 = item.noValues(fd0.code);
      log.debug('noValues0: ${noValues0.values}');
      expect(noValues0.values.isEmpty, true);
    });

    test('removeAt', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = ODtag(PTag.kSelectorODValue, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;
      log.debug('item : $item');

      final remove0 = item.removeAt(as0.index);
      expect(remove0, isNotNull);
      expect(item.removeAt(as0.index), isNull);
      log.debug('remove0 : $remove0');

      final remove1 = item.removeAt(ss0.index);
      expect(remove1, isNotNull);
      expect(item.removeAt(ss0.index), isNull);
      log.debug('remove1 : $remove1');

      final remove2 = item.removeAt(fd0.index);
      expect(remove2, isNotNull);
      expect(item.removeAt(fd0.index), isNull);
      log.debug('remove2 : $remove2');

      expect(item.removeAt(od0.index), isNull);
    });

    test('delete', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = ODtag(PTag.kSelectorODValue, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;
      log.debug('item : $item');

      final remove0 = item.delete(as0.code);
      log.debug('remove0 : $remove0');
      expect(remove0, isNotNull);
      final remove1 = item.delete(as0.code);
      log.debug('remove1 : $remove1');
      expect(remove1, isNull);
      log.debug('remove0 : $remove0');

      final remove2 = item.delete(ss0.index);
      expect(remove2, isNotNull);
      expect(item.delete(ss0.index), isNull);
      log.debug('remove1 : $remove2');

      final remove3 = item.delete(fd0.index);
      expect(remove3, isNotNull);
      expect(item.delete(fd0.index), isNull);
      log.debug('remove2 : $remove3');

      expect(item.delete(od0.index), isNull);

      global.throwOnError = true;
      final sl0 = SLtag(PTag.kRationalNumeratorValue, [123]);
      expect(() => item.delete(sl0.index, required: true),
          throwsA(const TypeMatcher<ElementNotPresentError>()));
    });

    test('deleteAll', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = ODtag(PTag.kSelectorODValue, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;

      log.debug('item: $item');

      final removeAll0 = item.deleteAll(as0.index);
      expect(removeAll0[0] == as0, true);
      expect(item.deleteAll(as0.index), <Element>[]);
      log.debug('removeAll0: $removeAll0');

      final removeAll1 = item.deleteAll(ss0.index);
      expect(removeAll1[0] == ss0, true);
      expect(item.deleteAll(ss0.index), <Element>[]);
      log.debug('removeAll1 : $removeAll1');

      final removeAll2 = item.deleteAll(fd0.index);
      expect(removeAll2[0] == fd0, true);
      expect(item.deleteAll(fd0.index), <Element>[]);
      log.debug('removeAll2 : $removeAll2');

      expect(item.deleteAll(od0.index), <Element>[]);
    });

    test('getElementsInRange', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final ob0 = OBtag(PTag.kICCProfile, [123]);
      final ae0 = AEtag(PTag.kPerformedStationAETitle, ['3']);

      item[fd0.code] = fd0;
      item[as0.code] = as0;
      item[ob0.code] = ob0;

      final inRange0 = item.getElementsInRange(0, fd0.code);
      final inRange1 = item.getElementsInRange(0, fd0.code + 1);
      final inRange2 = item.getElementsInRange(0, ae0.code);
      final inRange3 = item.getElementsInRange(0, ae0.code + 1);
      log
        ..debug('item: $item')
        ..debug('inRange0: $inRange0')
        ..debug('inRange1: $inRange1')
        ..debug('inRange2: $inRange2')
        ..debug('inRange3: $inRange3');

      expect(inRange0, isNotNull);
    });

    test('removeDuplicates', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final as1 = AStag(PTag.kPatientAge, ['024Y']);
      final as2 = AStag(PTag.kPatientAge, ['012M']);
      final ob0 = OBtag(PTag.kICCProfile, [123]);
      final ae0 = AEtag(PTag.kPerformedStationAETitle, ['3']);

      /*item[fd0.code] = fd0;
      item[fd1.code] = fd1;
      item[as0.code] = as0;
      item[as1.code] = as1;
      item[as2.code] = as2;
      item[ob0.code] = ob0;
      item[ae0.code] = ae0;*/

      item
        ..add(fd0)
        ..add(fd1)
        ..add(as0)
        ..add(as1)
        ..add(as2)
        ..add(ob0)
        ..add(ae0);

      final dup = item.history;
      log.debug('item: $item, dup: $dup');
      expect(dup, isNotNull);
      final removeDup = item.deleteDuplicates();
      log.debug('item: $item, removeDup: $removeDup');
      expect(removeDup, <Element>[]);
      expect(item.hasDuplicates, false);
      expect(dup.duplicates.isEmpty, true);
    });

    test('getValue', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;

      global.throwOnError = false;
      final getValues0 = item.getValue<int>(ss0.index);
      log.debug('getValues0: $getValues0');
      expect(getValues0, equals(ss0.value));

      final getValues1 = item.getValue<String>(as0.index);
      log.debug('getValues1: $getValues1');
      expect(getValues1.toString(), equals(as0.value));

      final getValues2 = item.getValue<double>(fd0.index);
      expect(getValues2, isNull);

      global.throwOnError = true;
      expect(() => item.getValues<double>(fd0.index, required: true),
          throwsA(const TypeMatcher<ElementNotPresentError>()));
    });

    test('getValues', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;

      global.throwOnError = false;
      final getValues0 = item.getValues<int>(ss0.index);
      log.debug('getValues0: $getValues0');
      expect(getValues0, equals(ss0.values));

      final getValues1 = item.getValues<String>(as0.index);
      log.debug('getValues1: $getValues1');
      expect(getValues1, equals(as0.values));

      final getValues2 = item.getValues<double>(fd0.index);
      expect(getValues2, isNull);

      global.throwOnError = true;
      expect(() => item.getValues<double>(fd0.index, required: true),
          throwsA(const TypeMatcher<ElementNotPresentError>()));
    });

    test('updateAll(string)', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      item[as0.code] = as0;

      final update0 = item.updateAll<String>(as0.index, vList: as0.values);
      expect(update0.isEmpty, false);
    });

    test('updateAllF(string)', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      item[as0.code] = as0;

      final update0 = item.updateAllF<String>(as0.index, (n) => n);
      expect(update0.isEmpty, false);
    });

    test('updateAll (int)', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final vList0 = [kInt16Min];
      final ss0 = SStag(PTag.kSelectorSSValue, vList0);
      item.add(ss0);

      final update2 = item.updateAll<int>(ss0.index, vList: <int>[]);
      expect(update2.isEmpty, false);
    });

    test('updateAllF (int)', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final vList0 = [kInt16Min];
      final ss0 = SStag(PTag.kSelectorSSValue, vList0);
      item.add(ss0);

      final update2 = item.updateAllF<int>(ss0.index, (n) => n);
      expect(update2.isEmpty, false);
    });

    test('updateAll (float)', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      item.add(fd0);

      final update1 = item.updateAll<double>(fd0.index, vList: <double>[]);
      expect(update1.isEmpty, false);
    });

    test('updateAllF (float)', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      item.add(fd0);

      final update1 = item.updateAllF<double>(fd0.index, (n) => n);
      expect(update1.isEmpty, false);
    });

    test('hasElementsInRange', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kSelectorASValue, ['024Y']);
      final ss0 = SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = ODtag(PTag.kSelectorODValue, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;
      log.debug('item : $item');

      final inRange0 = item.hasElementsInRange(0, as0.code);
      final inRange1 = item.hasElementsInRange(0, as0.code + 1);
      final inRange2 = item.hasElementsInRange(0, ss0.code);
      final inRange3 = item.hasElementsInRange(0, ss0.code + 1);

      log
        ..debug('inRange0: $inRange0')
        ..debug('inRange1: $inRange1')
        ..debug('inRange2: $inRange2')
        ..debug('inRange3: $inRange3');

      expect(inRange0, true);
      expect(inRange1, true);
      expect(inRange2, true);
      expect(inRange3, true);

      final item0 = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final inRange4 = item0.hasElementsInRange(0, od0.code);
      expect(inRange4, false);
    });

    test('deleteCodes', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final as0 = AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = FDtag(PTag.kBlendingWeightConstant, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;
      log..debug('item : $item')..debug('item.Codes: ${item.codes}');

      expect(item.codes.isEmpty, false);
      expect(item.codes.first == as0.code, true);
      expect(item.codes.last == fd0.code, true);

      final deleteCodes0 = item.deleteCodes(item.codes.toList());
      log
        ..debug('item.codes: ${item.codes}')
        ..debug('deleteCodes0: $deleteCodes0');
      expect(item.codes.isEmpty, true);

      final deleteCodes1 = item.deleteCodes([as0.code]);
      log.debug('deleteCodes1: $deleteCodes1');
      expect(deleteCodes1, equals(<Element>[]));

      final deleteCodes2 = item.deleteCodes([ss0.code]);
      log.debug('deleteCodes2: $deleteCodes2');
      expect(deleteCodes2, equals(<Element>[]));

      final deleteCodes3 = item.deleteCodes([fd0.code]);
      log.debug('deleteCodes3: $deleteCodes3');
      expect(deleteCodes3, equals(<Element>[]));
    });

    test('getUidList', () {
      final item = ListRootDataset.empty('', Bytes.kEmptyBytes, 0);
      final stringList0 = rsg.getUIList(1, 1);
      final ui0 = UItag(PTag.kSpecimenUID, stringList0);
      item[ui0.code] = ui0;

      expect(item.getUidList(kSpecimenUID), equals(Uid.parseList(stringList0)));

      global.throwOnError = false;
      expect(item.getUidList(kFalseNegativesQuantity, required: true), isNull);

      global.throwOnError = true;
      expect(() => item.getUidList(kFalseNegativesQuantity, required: true),
          throwsA(const TypeMatcher<ElementNotPresentError>()));
    });
  });
}
