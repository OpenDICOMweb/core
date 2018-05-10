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
  Server.initialize(name: 'map_root_dataset_test', level: Level.info);

  group('MapRootDataset', () {
    test('[] and []=', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      const ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransFerSyntax =
          new UItag(PTag.kTransferSyntaxUID, [ts.asString]);
      log.debug('ui: $uiTransFerSyntax');
      rds[uiTransFerSyntax.index] = uiTransFerSyntax;
      log.debug('elements: $rds');
      final v = rds[uiTransFerSyntax.index];
      log.debug('elements[${uiTransFerSyntax.index}] = $v');
    });

    test('insert and compare', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
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

    test('removeAt', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

      rds[as0.code] = as0;
      rds[ss0.code] = ss0;
      rds[fd0.code] = fd0;
      log.debug('rds : $rds');

      final remove0 = rds.removeAt(as0.code);
      expect(remove0, isNotNull);
      expect(rds.removeAt(as0.code), isNull);
      log.debug('remove0 : $remove0');

      final remove1 = rds.removeAt(ss0.code);
      expect(remove1, isNotNull);
      expect(rds.removeAt(ss0.code), isNull);
      log.debug('remove1 : $remove1');

      final remove2 = rds.removeAt(fd0.code);
      expect(remove2, isNotNull);
      expect(rds.removeAt(fd0.code), isNull);
      log.debug('remove2 : $remove2');

      expect(rds.removeAt(od0.code), isNull);
    });

    test('delete', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

      rds[as0.code] = as0;
      rds[ss0.code] = ss0;
      rds[fd0.code] = fd0;
      log.debug('rds : $rds');

      final remove0 = rds.delete(as0.code);
      log.debug('remove0 : $remove0');
      expect(remove0, isNotNull);
      final remove1 = rds.delete(as0.code);
      log.debug('remove1 : $remove1');
      expect(remove1, isNull);
      log.debug('remove0 : $remove0');

      final remove2 = rds.delete(ss0.code);
      expect(remove2, isNotNull);
      expect(rds.delete(ss0.code), isNull);
      log.debug('remove1 : $remove2');

      final remove3 = rds.delete(fd0.code);
      expect(remove3, isNotNull);
      expect(rds.delete(fd0.code), isNull);
      log.debug('remove2 : $remove3');

      expect(rds.delete(od0.code), isNull);

      global.throwOnError = true;
      final sl0 = new SLtag(PTag.kRationalNumeratorValue, [123]);
      expect(() => rds.delete(sl0.code, required: true),
          throwsA(const isInstanceOf<ElementNotPresentError>()));
    });

    test('deleteAll', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

      rds[as0.code] = as0;
      rds[ss0.code] = ss0;
      rds[fd0.code] = fd0;

      log.debug('rds: $rds');

      final removeAll0 = rds.deleteAll(as0.code);
      expect(removeAll0[0] == as0, true);
      expect(rds.deleteAll(as0.code), <Element>[]);
      log.debug('removeAll0: $removeAll0');

      final removeAll1 = rds.deleteAll(ss0.code);
      expect(removeAll1[0] == ss0, true);
      expect(rds.deleteAll(ss0.code), <Element>[]);
      log.debug('removeAll1 : $removeAll1');

      final removeAll2 = rds.deleteAll(fd0.code);
      expect(removeAll2[0] == fd0, true);
      expect(rds.deleteAll(fd0.code), <Element>[]);
      log.debug('removeAll2 : $removeAll2');

      expect(rds.deleteAll(od0.code), <Element>[]);
    });

    test('noValues', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);

      rds[fd0.code] = fd0;
      rds[as0.code] = as0;

      var noValues0 = rds.noValues(fd0.code);
      expect(noValues0 == fd0, true);
      expect(noValues0.values.isEmpty, false);

      noValues0 = rds.noValues(fd0.code);
      expect(noValues0.values.isEmpty, true);
      log.debug('noValues0: $noValues0');
    });

    test('noValuesAll', () {
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0)..add(as0);

      final rds1 = new TagRootDataset.empty();
      final valuesList = <TagItem>[];
      rds[kRecognitionCode] = new SHtag(PTag.kRecognitionCode, ['foo bar']);
      rds[kInstitutionAddress] =
          new STtag(PTag.kInstitutionAddress, ['foo bar']);
      rds[kExtendedCodeMeaning] =
          new LTtag(PTag.kExtendedCodeMeaning, ['foo bar']);

      valuesList.add(new TagItem.fromList(rds1, rds));
      final sq0 = new SQtag(rds1, PTag.kPatientSizeCodeSequence);
      rds[sq0.code] = sq0;

      final noV = rds.noValuesAll(sq0.index);
      expect(noV.isEmpty, false);

      rds[as0.code] = as0;

      var noValues0 = rds.noValuesAll(as0.code);
      expect(noValues0.isEmpty, false);

      noValues0 = rds.noValuesAll(as0.code);
      for (var e in noValues0) {
        print('noValues: $e');
        expect(e.values.isEmpty, true);
        log.debug('noValues0: $noValues0');
      }
    });

    test('update (String)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      rds[as0.code] = as0;

      final update0 = rds.update(as0.code, <String>[]);
      expect(update0.isEmpty, false);
    });

    test('updateF(String)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      rds[as0.code] = as0;

      final update0 = rds.updateF<String>(as0.index, (n) => n);
      log.debug('update0: $update0');
      expect(update0.isEmpty, false);
    });

    test('update (int)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final vList0 = [kInt16Min];
      final ss0 = new SStag(PTag.kSelectorSSValue, vList0);
      rds.add(ss0);

      final vList1 = [kInt16Max];
      final update1 = rds.update(ss0.code, vList1).values;
      expect(update1, equals(vList0));

      final update2 = rds.update(ss0.code, <int>[]);
      expect(update2.values.isEmpty, false);
    });

    test('updateF (int)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final vList0 = [kInt16Min];
      final ss0 = new SStag(PTag.kSelectorSSValue, vList0);
      rds.add(ss0);

      final update2 = rds.updateF<int>(ss0.index, (n) => n);
      expect(update2.values.isEmpty, false);
    });

    test('update (float)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      rds.add(fd0);
      final update1 = rds.update(fd0.code, <double>[]);
      expect(update1.isEmpty, false);
    });

    test('updateF (float)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      rds.add(fd0);

      final update1 = rds.updateF<double>(fd0.index, (n) => n);
      expect(update1.isEmpty, false);
    });

    test('duplicate', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final as1 = new AStag(PTag.kPatientAge, ['024Y']);
      final as2 = new AStag(PTag.kPatientAge, ['012M']);
      final ob0 = new OBtag(PTag.kICCProfile, [123]);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      global.throwOnError = false;
      rds..add(fd0)..add(fd1)..add(as0)..add(as1)..add(as2)..add(ob0)..add(ae0);

      final dup = rds.duplicates;
      log.debug('rds: $rds, dup: $dup');
      expect(dup, isNotNull);
    });

    test('removeDuplicates', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final as1 = new AStag(PTag.kPatientAge, ['024Y']);
      final as2 = new AStag(PTag.kPatientAge, ['012M']);
      final ob0 = new OBtag(PTag.kICCProfile, [123]);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      rds..add(fd0)..add(fd1)..add(as0)..add(as1)..add(as2)..add(ob0)..add(ae0);

//      system.level = Level.info;
      final dup = rds.duplicates;
      log.debug('rds: $rds, dup: $dup');
      expect(dup, isNotNull);
      final removeDup = rds.deleteDuplicates();
      log.debug('rds: $rds, removeDup: $removeDup');
      expect(dup, equals(<Element>[]));
      expect(removeDup, <Element>[]);
    });

    test('getElementsInRange', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ob0 = new OBtag(PTag.kICCProfile, [123]);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      rds..add(fd0)..add(as0)..add(ob0)..add(ae0);

//      system.level = Level.info;
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
      final ui0 = new UItag.fromUids(PTag.kSelectorUIValue, uidList0);
      print('values: ${ui0.values}');
      expect(ui0.values, equals(uidStringList0));
      expect(ui0.value, equals(uidString0));
      print('values: ${ui0.uids}');
      expect(ui0.uids, equals(uidList0));
      expect(ui0.uids.elementAt(0), equals(uid0));

      // Test replace
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0)..add(ui0);
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
      final ui0 = new UItag(PTag.kSelectorUIValue, uidStringList0);
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0)..add(ui0);
      print('values: ${ui0.values}');
      expect(ui0.values, equals(uidStringList0));
      expect(ui0.value, equals(uidStringList0[0]));
      print('values: ${ui0.uids}');
      expect(ui0.uids, equals(uidList0));
      expect(ui0.uids.elementAt(0), equals(uidList0[0]));

      // Test replace
      final uidStringList0b = rds.replace(ui0.code, uidStringList0a);
      expect(uidStringList0b, equals(uidStringList0));
      expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

      // Test replaceUid
      final uidList0b = rds.replaceUids(ui0.code, uidList0a);
      print('uidList0b: $uidList0b');
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
        print('uidList0: $uidList0');
        final ui0 = new UItag.fromUids(PTag.kSelectorUIValue, uidList0);
        print('ui0: $ui0');
        final rds = new MapRootDataset.empty('', kEmptyBytes, 0)..add(ui0);
        print('values: ${ui0.values}');
        expect(ui0.values, equals(uidStringList0));
        expect(ui0.value, equals(uidStringList0[0]));
        print('values: ${ui0.uids}');
        expect(ui0.uids, equals(uidList0));
        expect(ui0.uids.elementAt(0), equals(uidList0[0]));

        // Test replace
        final uidStringList0b = rds.replace(ui0.code, uidStringList0a);
        expect(uidStringList0b, equals(uidStringList0));
        expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

        // Test replaceUid
        final uidList0b = rds.replaceUids(ui0.code, uidList0a);
        print('uidList0b: $uidList0b');
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
            new UItag(PTag.kSelectorUIValue, uidStringList0);
        final rds = new MapRootDataset.empty('', kEmptyBytes, 0)..add(ui0);
        print('values: ${ui0.values}');
        expect(ui0.values, equals(uidStringList0));
        expect(ui0.value, equals(uidStringList0[0]));
        print('values: ${ui0.uids}');
        expect(ui0.uids, equals(uidList0));
        expect(ui0.uids.elementAt(0), equals(uidList0[0]));

        // Test replace
        final uidStringList0b = ui0.replace(uidStringList0a);
        expect(uidStringList0b, equals(uidStringList0));
        expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

        // Test replaceUid
        final uidList0b = rds.replaceUids(ui0.code, uidList0a);
        print('uidList0b: $uidList0b');
        expect(uidList0b, equals(uidList0b));
        expect(uidList0b.elementAt(0), equals(uidList0b[0]));
      }
    });

    test('replace', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final vList0 = [15.24];
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, vList0);
      rds.add(fd0);

      final vList1 = [123];
      expect(rds.replace(fd0.index, vList1), equals(vList0));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));

      global.throwOnError = true;
      final vList2 = ['024Y'];
      final as0 = new AStag(PTag.kPatientAge, vList2);
      final vList3 = [123];
      //expect(map.replace(as0.index, vList3), equals(vList2));
      expect(() => rds.replace(as0.index, vList3, required: true),
          throwsA(const isInstanceOf<ElementNotPresentError>()));
    });

    test('replaceAll', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final vList0 = [15.24];
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, vList0);
      rds.add(fd0);

      final vList1 = [123];
      final replaceA0 = rds.replaceAll(fd0.index, vList1);
      log.debug('replaceA0 : $replaceA0');
      expect(replaceA0, equals([vList0, vList1]));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));
    });

    test('== and hashCode', () {
      final rds0 = new MapRootDataset.empty('', kEmptyBytes, 0);
      final rds1 = new MapRootDataset.empty('', kEmptyBytes, 0);
      final rds2 = new MapRootDataset.empty('', kEmptyBytes, 0);

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
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);

      rds[as0.code] = as0;

      expect(rds.toList(), equals([as0]));
      expect(rds.toList(), equals([as0]));
      expect(rds.codes, equals([as0.code]));
      expect(rds.codes, equals([as0.code]));
      expect(rds.length == as0.length, true);
    });

    test('copy', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      rds[as0.code] = as0;
      rds[ss0.code] = ss0;
      rds[fd0.code] = fd0;
      log.debug('rds : $rds');

      final copy0 = rds.copy();
      log.debug('copy0: $copy0');
      expect(copy0, equals(new MapRootDataset.from(rds)));
      expect(copy0, equals(rds));
    });

    test('getValue', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      rds[as0.code] = as0;
      rds[ss0.code] = ss0;

      global.throwOnError = false;
      final getValues0 = rds.getValue<int>(ss0.index);
      log.debug('getValues0: $getValues0');
      expect(getValues0, equals(ss0.value));

      final getValues1 = rds.getValue<String>(as0.index);
      log.debug('getValues1: $getValues1');
      expect(getValues1.toString(), equals(as0.value));

      final getValues2 = rds.getValue<double>(fd0.index);
      expect(getValues2, isNull);

      global.throwOnError = true;
      expect(() => rds.getValues<double>(fd0.index, required: true),
          throwsA(const isInstanceOf<ElementNotPresentError>()));
    });

    test('getValues', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      rds[as0.code] = as0;
      rds[ss0.code] = ss0;

      global.throwOnError = false;
      final getValues0 = rds.getValues<int>(ss0.index);
      log.debug('getValues0: $getValues0');
      expect(getValues0, equals(ss0.values));

      final getValues1 = rds.getValues<String>(as0.index);
      log.debug('getValues1: $getValues1');
      expect(getValues1, equals(as0.values));

      final getValues2 = rds.getValues<double>(fd0.index);
      expect(getValues2, isNull);

      global.throwOnError = true;
      expect(() => rds.getValues<double>(fd0.index, required: true),
          throwsA(const isInstanceOf<ElementNotPresentError>()));
    });

    test('hasElementsInRange', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kSelectorASValue, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

      rds[as0.code] = as0;
      rds[ss0.code] = ss0;
      rds[fd0.code] = fd0;
      log.debug('rds : $rds');

      final inRange0 = rds.hasElementsInRange(0, as0.code);
      final inRange1 = rds.hasElementsInRange(0, as0.code + 1);
      final inRange2 = rds.hasElementsInRange(0, ss0.code);
      final inRange3 = rds.hasElementsInRange(0, ss0.code + 1);

      log
        ..debug('inRange0: $inRange0')
        ..debug('inRange1: $inRange1')
        ..debug('inRange2: $inRange2')
        ..debug('inRange3: $inRange3');

      expect(inRange0, true);
      expect(inRange1, true);
      expect(inRange2, true);
      expect(inRange3, true);

      final rds0 = new MapRootDataset.empty('', kEmptyBytes, 0);
      final inRange4 = rds0.hasElementsInRange(0, od0.code);
      expect(inRange4, false);
    });

    test('deleteCodes', () {
      global.level = Level.debug;
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      rds[as0.code] = as0;
      rds[ss0.code] = ss0;
      rds[fd0.code] = fd0;
      log..debug('rds : $rds')..debug('rds.Codes: ${rds.codes}');

      expect(rds.codes.isEmpty, false);
      expect(rds.codes.first == as0.code, true);
      expect(rds.codes.last == fd0.code, true);

      final deleteCodes0 = rds.deleteCodes(rds.codes.toList());
      log
        ..debug('rds.codes: ${rds.codes}')
        ..debug('deleteCodes0: $deleteCodes0');
      expect(rds.codes.isEmpty, true);

      final deleteCodes1 = rds.deleteCodes([as0.code]);
      log.debug('deleteCodes1: $deleteCodes1');
      expect(deleteCodes1, equals(<Element>[]));

      final deleteCodes2 = rds.deleteCodes([ss0.code]);
      log.debug('deleteCodes2: $deleteCodes2');
      expect(deleteCodes2, equals(<Element>[]));

      final deleteCodes3 = rds.deleteCodes([fd0.code]);
      log.debug('deleteCodes3: $deleteCodes3');
      expect(deleteCodes3, equals(<Element>[]));
    });

    test('updateAll(string)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      rds[as0.code] = as0;

      final update0 = rds.updateAll<String>(as0.index, vList: as0.values);
      expect(update0.isEmpty, false);
    });

    test('updateAllF(string)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      rds[as0.code] = as0;

      final update0 = rds.updateAllF<String>(as0.index, (n) => n);
      expect(update0.isEmpty, false);
    });

    test('updateAll (int)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final vList0 = [kInt16Min];
      final ss0 = new SStag(PTag.kSelectorSSValue, vList0);
      rds.add(ss0);

      final update2 = rds.updateAll<int>(ss0.index, vList: <int>[]);
      expect(update2.isEmpty, false);
    });

    test('updateAllF (int)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final vList0 = [kInt16Min];
      final ss0 = new SStag(PTag.kSelectorSSValue, vList0);
      rds.add(ss0);

      final update2 = rds.updateAllF<int>(ss0.index, (n) => n);
      expect(update2.isEmpty, false);
    });

    test('updateAll (float)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      rds.add(fd0);

      final update1 = rds.updateAll<double>(fd0.index, vList: <double>[]);
      expect(update1.isEmpty, false);
    });

    test('updateAllF (float)', () {
      final rds = new MapRootDataset.empty('', kEmptyBytes, 0);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      rds.add(fd0);

      final update1 = rds.updateAllF<double>(fd0.index, (n) => n);
      expect(update1.isEmpty, false);
    });
  });
}
