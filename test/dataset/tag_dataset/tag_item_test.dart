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
  Server.initialize(name: 'tag_item_test', level: Level.info);
  final rds = new TagRootDataset.empty('', kEmptyBytes, 0);

  group('TagItem', () {
    test('[] and []=', () {
      final item = new TagItem.empty(rds, null);
      const ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransFerSyntax =
          new UItag(PTag.kTransferSyntaxUID, [ts.asString]);
      log.debug('ui: $uiTransFerSyntax');
      item[uiTransFerSyntax.index] = uiTransFerSyntax;
      log.debug('elements: $item');
      final v = item[uiTransFerSyntax.index];
      log.debug('elements[${uiTransFerSyntax.index}] = $v');
    });

    test('insert and compare', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;
      log.debug('item : $item');

      final as1 = item[as0.code];
      expect(as1 == as0, true);

      final da1 = item[ss0.code];
      expect(da1 == ss0, true);

      final fd1 = item[fd0.code];
      expect(fd1 == fd0, true);
    });

    test('removeAt', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;
      log.debug('item : $item');

      final remove0 = item.removeAt(as0.code);
      expect(remove0, isNotNull);
      expect(item.removeAt(as0.code), isNull);
      log.debug('remove0 : $remove0');

      final remove1 = item.removeAt(ss0.code);
      expect(remove1, isNotNull);
      expect(item.removeAt(ss0.code), isNull);
      log.debug('remove1 : $remove1');

      final remove2 = item.removeAt(fd0.code);
      expect(remove2, isNotNull);
      expect(item.removeAt(fd0.code), isNull);
      log.debug('remove2 : $remove2');

      expect(item.removeAt(od0.code), isNull);
    });

    test('delete', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

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

      final remove2 = item.delete(ss0.code);
      expect(remove2, isNotNull);
      expect(item.delete(ss0.code), isNull);
      log.debug('remove1 : $remove2');

      final remove3 = item.delete(fd0.code);
      expect(remove3, isNotNull);
      expect(item.delete(fd0.code), isNull);
      log.debug('remove2 : $remove3');

      expect(item.delete(od0.code), isNull);

      global.throwOnError = true;
      final sl0 = new SLtag(PTag.kRationalNumeratorValue, [123]);
      expect(() => item.delete(sl0.code, required: true),
          throwsA(const TypeMatcher<ElementNotPresentError>()));
    });

    test('deleteAll', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;

      log.debug('item: $item');

      final removeAll0 = item.deleteAll(as0.code);
      expect(removeAll0[0] == as0, true);
      expect(item.deleteAll(as0.code), <Element>[]);
      log.debug('removeAll0: $removeAll0');

      final removeAll1 = item.deleteAll(ss0.code);
      expect(removeAll1[0] == ss0, true);
      expect(item.deleteAll(ss0.code), <Element>[]);
      log.debug('removeAll1 : $removeAll1');

      final removeAll2 = item.deleteAll(fd0.code);
      expect(removeAll2[0] == fd0, true);
      expect(item.deleteAll(fd0.code), <Element>[]);
      log.debug('removeAll2 : $removeAll2');

      expect(item.deleteAll(od0.code), <Element>[]);
    });

    test('remove', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;
      log.debug('item : $item');

      expect(item.elements.contains(as0), true);
      final remove0 = item.remove(as0);
      log..debug('remove0: $remove0')..debug('item: $item');
      expect(item.elements.contains(as0), false);

      expect(item.elements.contains(ss0), true);
      final remove1 = item.remove(ss0);
      log..debug('remove1: $remove1')..debug('item: $item');
      expect(item.elements.contains(ss0), false);

      expect(item.elements.contains(fd0), true);
      final remove2 = item.remove(fd0);
      log..debug('remove2: $remove2')..debug('item: $item');
      expect(item.elements.contains(fd0), false);
    });

    test('noValues', () {
      final item = new TagItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);

      item[fd0.code] = fd0;
      item[as0.code] = as0;

      var noValues0 = item.noValues(fd0.code);
      expect(noValues0 == fd0, true);
      expect(noValues0.values.isEmpty, false);

      noValues0 = item.noValues(fd0.code);
      expect(noValues0.values.isEmpty, true);
      log.debug('noValues0: $noValues0');
    });

    test('noValuesAll', () {
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final item0 = new TagItem.empty(rds, null)..add(as0);

      final rds1 = new TagRootDataset.empty();
      final itemList = <Item>[];
      item0[kRecognitionCode] = new SHtag(PTag.kRecognitionCode, ['foo bar']);
      item0[kInstitutionAddress] =
          new STtag(PTag.kInstitutionAddress, ['foo bar']);
      item0[kExtendedCodeMeaning] =
          new LTtag(PTag.kExtendedCodeMeaning, ['foo bar']);

      itemList.add(new TagItem.fromList(rds1, item0.elements));
      final sq0 = new SQtag(rds1, PTag.kPatientSizeCodeSequence);
      item0[sq0.code] = sq0;

      final noV = item0.noValuesAll(sq0.index);
      expect(noV.isEmpty, false);

      item0[as0.code] = as0;

      var noValues0 = item0.noValuesAll(as0.code);
      expect(noValues0.isEmpty, false);

      noValues0 = item0.noValuesAll(as0.code);
      for (var e in noValues0) {
        expect(e.values.isEmpty, true);
        log.debug('noValues0: $noValues0');
      }
    });

    test('update (String)', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      item[as0.code] = as0;

      final update0 = item.update(as0.code, <String>[]);
      expect(update0.isEmpty, false);
    });

    test('updateF(String)', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      item[as0.code] = as0;

      final update0 = item.updateF<String>(as0.index, (n) => n);
      log.debug('as0: $as0, update0: $update0');
      expect(update0.isEmpty, false);
    });

    test('update (int)', () {
      final item = new TagItem.empty(rds, null);
      final vList0 = [kInt16Min];
      final ss0 = new SStag(PTag.kSelectorSSValue, vList0);
      item.add(ss0);

      final vList1 = [kInt16Max];
      final update1 = item.update(ss0.code, vList1).values;
      expect(update1, equals(vList0));

      final update2 = item.update(ss0.code, <int>[]);
      expect(update2.values.isEmpty, false);
    });

    test('updateF (int)', () {
      final item = new TagItem.empty(rds, null);
      final vList0 = [kInt16Min];
      final ss0 = new SStag(PTag.kSelectorSSValue, vList0);
      item.add(ss0);

      final update2 = item.updateF<int>(ss0.index, (n) => n);
      expect(update2.values.isEmpty, false);
    });

    test('update (float)', () {
      final item = new TagItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      item.add(fd0);
      final update1 = item.update(fd0.code, <double>[]);
      expect(update1.isEmpty, false);
    });

    test('updateF (float)', () {
      final item = new TagItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      item.add(fd0);

      final update1 = item.updateF<double>(fd0.index, (n) => n);
      expect(update1.isEmpty, false);
    });

    test('duplicate', () {
      final item = new TagItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final as1 = new AStag(PTag.kPatientAge, ['024Y']);
      final as2 = new AStag(PTag.kPatientAge, ['012M']);
      final ob0 = new OBtag(PTag.kICCProfile, [123]);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      global.throwOnError = false;
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
    });

    test('removeDuplicates', () {
      final item = new TagItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final as1 = new AStag(PTag.kPatientAge, ['024Y']);
      final as2 = new AStag(PTag.kPatientAge, ['012M']);
      final ob0 = new OBtag(PTag.kICCProfile, [123]);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

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
      //expect(dup, equals(<Element>[]));
      expect(removeDup, <Element>[]);
    });

    test('getElementsInRange', () {
      final item = new TagItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ob0 = new OBtag(PTag.kICCProfile, [123]);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      item..add(fd0)..add(as0)..add(ob0)..add(ae0);

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
      expect(ui0.values, equals(uidStringList0));
      expect(ui0.value, equals(uidString0));
      expect(ui0.uids, equals(uidList0));
      expect(ui0.uids.elementAt(0), equals(uid0));

      // Test replace
      final item = new TagItem.empty(rds, null)..add(ui0);
      final uidStringList0b = item.replace(ui0.code, uidStringList0a);
      expect(uidStringList0b, equals(uidStringList0));
      expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

      // Test replaceUid
      final uidList0b = item.replaceUids(ui0.code, uidList0a);
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
      final item = new TagItem.empty(rds, null)..add(ui0);
      expect(ui0.values, equals(uidStringList0));
      expect(ui0.value, equals(uidStringList0[0]));
      expect(ui0.uids, equals(uidList0));
      expect(ui0.uids.elementAt(0), equals(uidList0[0]));

      // Test replace
      final uidStringList0b = item.replace(ui0.code, uidStringList0a);
      expect(uidStringList0b, equals(uidStringList0));
      expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

      // Test replaceUid
      final uidList0b = item.replaceUids(ui0.code, uidList0a);
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
        final ui0 = new UItag.fromUids(PTag.kSelectorUIValue, uidList0);
        final item = new TagItem.empty(rds, null)..add(ui0);
        expect(ui0.values, equals(uidStringList0));
        expect(ui0.value, equals(uidStringList0[0]));
        expect(ui0.uids, equals(uidList0));
        expect(ui0.uids.elementAt(0), equals(uidList0[0]));

        // Test replace
        final uidStringList0b = item.replace(ui0.code, uidStringList0a);
        expect(uidStringList0b, equals(uidStringList0));
        expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

        // Test replaceUid
        final uidList0b = item.replaceUids(ui0.code, uidList0a);
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
        final ui0 = new UItag(PTag.kSelectorUIValue, uidStringList0);
        final item = new TagItem.empty(rds, null)..add(ui0);
        expect(ui0.values, equals(uidStringList0));
        expect(ui0.value, equals(uidStringList0[0]));
        expect(ui0.uids, equals(uidList0));
        expect(ui0.uids.elementAt(0), equals(uidList0[0]));

        // Test replace
        final uidStringList0b = ui0.replace(uidStringList0a);
        expect(uidStringList0b, equals(uidStringList0));
        expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

        // Test replaceUid
        final uidList0b = item.replaceUids(ui0.code, uidList0a);
        expect(uidList0b, equals(uidList0b));
        expect(uidList0b.elementAt(0), equals(uidList0b[0]));
      }
    });

    test('replace', () {
      final item = new TagItem.empty(rds, null);
      final vList0 = [15.24];
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, vList0);
      item.add(fd0);

      final vList1 = [1.23];
      expect(item.replace(fd0.index, vList1), equals(vList0));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));

      global.throwOnError = true;
      final vList2 = ['024Y'];
      final as0 = new AStag(PTag.kPatientAge, vList2);
      final vList3 = [123];
      //expect(map.replace(as0.index, vList3), equals(vList2));
      expect(() => item.replace(as0.index, vList3, required: true),
          throwsA(const TypeMatcher<ElementNotPresentError>()));
    });

    test('replaceF', () {
      final item = new TagItem.empty(rds, null);
      final vList0 = [15.24];
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, vList0);
      item.add(fd0);

      expect(item.replaceF<int>(fd0.index, (n) => n), equals(vList0));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList0));

      global.throwOnError = true;
      final vList2 = ['024Y'];
      final as0 = new AStag(PTag.kPatientAge, vList2);
      expect(() => item.replaceF<String>(as0.index, (n) => n, required: true),
          throwsA(const TypeMatcher<ElementNotPresentError>()));
    });

    test('replaceAll', () {
      final item = new TagItem.empty(rds, null);
      final vList0 = [15.24];
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, vList0);
      item.add(fd0);

      final vList1 = [1.23];
      final replaceA0 = item.replaceAll(fd0.index, vList1);
      log.debug('replaceA0 : $replaceA0');
      expect(replaceA0, equals([vList0, vList1]));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));
    });

    test('== and hashCode', () {
      final item0 = new TagItem.empty(rds, null);
      final item1 = new TagItem.empty(rds, null);
      final item2 = new TagItem.empty(rds, null);

      final cs0 = new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final cs1 = new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final cs2 = new CStag(PTag.kImageFormat, ['FOO']);

      item0[cs0.code] = cs0;
      item1[cs1.code] = cs1;
      item2[cs2.code] = cs2;

      log.debug(
          'item.hashCode: ${item0.hashCode}, item1.hashCode : ${item1.hashCode}'
          ', item1.hashCode : ${item2.hashCode}');

      expect(item0 == item1, true);
      expect(item0.hashCode, equals(item1.hashCode));

      expect(item0 == item2, false);
      expect(item0.hashCode, isNot(item2.hashCode));

      expect(item1 == item2, false);
      expect(item1.hashCode, isNot(item2.hashCode));
    });

    test('others', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);

      item[as0.code] = as0;

      expect(item.toList(), equals([as0]));
      expect(item.toList(), equals([as0]));
      expect(item.codes, equals([as0.code]));
      expect(item.codes, equals([as0.code]));
      expect(item.length == as0.length, true);
    });

    test('getUid', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final uidList = ['1.2.840.10008.5.1.1.16.376'];
      final ui0 = new UItag(PTag.kStudyInstanceUID, uidList);
      final ui1 = new UItag(PTag.kSelectorUIValue, uidList);
      final un0 = new UNtag(PTag.kNoName0, [123]);

      item[as0.code] = as0;
      item..add(ui0)..add(un0);

      global.throwOnError = false;
      final uid0 = item.getUid(ui0.index);
      expect(uid0.toString() == uidList[0], true);

      final uid1 = item.getUid(ui1.index);
      expect(uid1, isNull);

      global.throwOnError = true;
      expect(() => item.getUid(ui1.index, required: true),
          throwsA(const TypeMatcher<ElementNotPresentError>()));

      global.throwOnError = false;
      final uid2 = item.getUid(as0.index);
      expect(uid2, isNull);

      global.throwOnError = true;
      expect(() => item.getUid(as0.index),
          throwsA(const TypeMatcher<InvalidElementError>()));
    });

    test('getValue', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

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
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

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
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      item[as0.code] = as0;

      final update0 = item.updateAll<String>(as0.index, vList: as0.values);
      expect(update0.isEmpty, false);
    });

    test('updateAllF(string)', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      item[as0.code] = as0;

      final update0 = item.updateAllF<String>(as0.index, (n) => n);
      expect(update0.isEmpty, false);
    });

    test('updateAll (int)', () {
      final item = new TagItem.empty(rds, null);
      final vList0 = [kInt16Min];
      final ss0 = new SStag(PTag.kSelectorSSValue, vList0);
      item.add(ss0);

      final update2 = item.updateAll<int>(ss0.index, vList: <int>[]);
      expect(update2.isEmpty, false);
    });

    test('updateAllF (int)', () {
      final item = new TagItem.empty(rds, null);
      final vList0 = [kInt16Min];
      final ss0 = new SStag(PTag.kSelectorSSValue, vList0);
      item.add(ss0);

      final update2 = item.updateAllF<int>(ss0.index, (n) => n);
      expect(update2.isEmpty, false);
    });

    test('updateAll (float)', () {
      final item = new TagItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      item.add(fd0);

      final update1 = item.updateAll<double>(fd0.index, vList: <double>[]);
      expect(update1.isEmpty, false);
    });

    test('updateAllF (float)', () {
      final item = new TagItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      item.add(fd0);

      final update1 = item.updateAllF<double>(fd0.index, (n) => n);
      expect(update1.isEmpty, false);
    });

    test('hasElementsInRange', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kSelectorASValue, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

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

      final item0 = new TagItem.empty(rds, null);
      final inRange4 = item0.hasElementsInRange(0, od0.code);
      expect(inRange4, false);
    });

    test('deleteCodes', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

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

    test('getTag', () {
      final item = new TagItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;
      log..debug('item : $item')..debug('item.Codes: ${item.codes}');

      final getTag0 = item.getTag(as0.index);
      log..debug('as0 :${as0.info}')..debug('getTag0: $getTag0');
      expect(getTag0, equals(as0.tag));
      expect(getTag0.code, equals(as0.tag.code));

      final getTag1 = item.getTag(ss0.index);
      log..debug('ss0 :${ss0.info}')..debug('getTag1 $getTag1');
      expect(getTag1, equals(ss0.tag));

      final getTag3 = item.getTag(fd0.index);
      log..debug('fd0 :${fd0.info}')..debug('getTag1 $getTag1');
      expect(getTag3, equals(fd0.tag));
    });
  });
}
