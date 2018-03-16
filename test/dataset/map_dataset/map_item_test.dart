// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'map_item_test', level: Level.info);
  final rds = new MapRootDataset.empty('', kEmptyByteData, 0);

  group('MapItem', () {
    test('[] and []=', () {
      final item = new MapItem.empty(rds, null);
      final ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransFerSyntax =
          new UItag.fromStrings(PTag.kTransferSyntaxUID, [ts.asString]);
      log.debug('ui: $uiTransFerSyntax');
      item[uiTransFerSyntax.index] = uiTransFerSyntax;
      log.debug('elements: $item');
      final v = item[uiTransFerSyntax.index];
      log.debug('elements[${uiTransFerSyntax.index}] = $v');
    });

    test('insert and compare', () {
      final item = new MapItem.empty(rds, null);
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
      final item = new MapItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;
      log.debug('item : $item');

      final remove0 = item.removeAt(as0.key);
      expect(remove0, isNotNull);
      expect(item.removeAt(as0.key), isNull);
      log.debug('remove0 : $remove0');

      final remove1 = item.removeAt(ss0.key);
      expect(remove1, isNotNull);
      expect(item.removeAt(ss0.key), isNull);
      log.debug('remove1 : $remove1');

      final remove2 = item.removeAt(fd0.key);
      expect(remove2, isNotNull);
      expect(item.removeAt(fd0.key), isNull);
      log.debug('remove2 : $remove2');

      expect(item.removeAt(od0.key), isNull);
    });

    test('delete', () {
      final item = new MapItem.empty(rds, null);
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

      final remove2 = item.delete(ss0.key);
      expect(remove2, isNotNull);
      expect(item.delete(ss0.key), isNull);
      log.debug('remove1 : $remove2');

      final remove3 = item.delete(fd0.key);
      expect(remove3, isNotNull);
      expect(item.delete(fd0.key), isNull);
      log.debug('remove2 : $remove3');

      expect(item.delete(od0.key), isNull);

      system.throwOnError = true;
      final sl0 = new SLtag(PTag.kRationalNumeratorValue, [123]);
      expect(() => item.delete(sl0.key, required: true),
          throwsA(const isInstanceOf<ElementNotPresentError>()));
    });

    test('deleteAll', () {
      final item = new MapItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;

      log.debug('item: $item');

      final removeAll0 = item.deleteAll(as0.key);
      expect(removeAll0[0] == as0, true);
      expect(item.deleteAll(as0.key), <Element>[]);
      log.debug('removeAll0: $removeAll0');

      final removeAll1 = item.deleteAll(ss0.key);
      expect(removeAll1[0] == ss0, true);
      expect(item.deleteAll(ss0.key), <Element>[]);
      log.debug('removeAll1 : $removeAll1');

      final removeAll2 = item.deleteAll(fd0.key);
      expect(removeAll2[0] == fd0, true);
      expect(item.deleteAll(fd0.key), <Element>[]);
      log.debug('removeAll2 : $removeAll2');

      expect(item.deleteAll(od0.key), <Element>[]);
    });

    test('noValues', () {
      final item = new MapItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);

      item[fd0.code] = fd0;
      item[as0.code] = as0;

      var noValues0 = item.noValues(fd0.key);
      expect(noValues0 == fd0, true);
      expect(noValues0.values.isEmpty, false);

      noValues0 = item.noValues(fd0.key);
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
      final sq0 = new SQtag(PTag.kPatientSizeCodeSequence, rds1);
      item0[sq0.code] = sq0;

      final noV = item0.noValuesAll(sq0.index);
      expect(noV.isEmpty, false);

      item0[as0.code] = as0;

      var noValues0 = item0.noValuesAll(as0.key);
      expect(noValues0.isEmpty, false);

      noValues0 = item0.noValuesAll(as0.key);
      for (var e in noValues0) {
        print('noValues: $e');
        expect(e.values.isEmpty, true);
        log.debug('noValues0: $noValues0');
      }
    });

    test('update (String)', () {
      final item = new MapItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      item[as0.code] = as0;

      final update0 = item.update(as0.key, <String>[]);
      expect(update0.isEmpty, false);
    });

    test('update (int)', () {
      final item = new MapItem.empty(rds, null);
      final vList0 = [kInt16Min];
      final ss0 = new SStag(PTag.kSelectorSSValue, vList0);
      item.add(ss0);

      final vList1 = [kInt16Max];
      final update1 = item.update(ss0.key, vList1).values;
      expect(update1, equals(vList0));

      final update2 = item.update(ss0.key, <int>[]);
      expect(update2.values.isEmpty, false);
    });

    test('update (float)', () {
      final item = new MapItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      item.add(fd0);
      final update1 = item.update(fd0.key, <double>[]);
      expect(update1.isEmpty, false);
    });

    test('duplicate', () {
      final item = new MapItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final as1 = new AStag(PTag.kPatientAge, ['024Y']);
      final as2 = new AStag(PTag.kPatientAge, ['012M']);
      final ob0 = new OBtag(PTag.kICCProfile, [123], 2);
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
    });

    test('removeDuplicates', () {
      final item = new MapItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final as1 = new AStag(PTag.kPatientAge, ['024Y']);
      final as2 = new AStag(PTag.kPatientAge, ['012M']);
      final ob0 = new OBtag(PTag.kICCProfile, [123], 2);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      item
        ..add(fd0)
        ..add(fd1)
        ..add(as0)
        ..add(as1)
        ..add(as2)
        ..add(ob0)
        ..add(ae0);

//      system.level = Level.debug;
      final dup = item.history;
      log.debug('item: $item, dup: $dup');
      expect(dup, isNotNull);
      final removeDup = item.deleteDuplicates();
      log.debug('item: $item, removeDup: $removeDup');
      //expect(dup, equals(<Element>[]));
      expect(removeDup, <Element>[]);
    });

    test('getElementsInRange', () {
      final item = new MapItem.empty(rds, null);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ob0 = new OBtag(PTag.kICCProfile, [123], 2);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      item..add(fd0)..add(as0)..add(ob0)..add(ae0);

//      system.level = Level.debug;
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
      final ui0 = new UItag(PTag.kSelectorUIValue, uidList0);
      print('values: ${ui0.values}');
      expect(ui0.values, equals(uidStringList0));
      expect(ui0.value, equals(uidString0));
      print('values: ${ui0.uids}');
      expect(ui0.uids, equals(uidList0));
      expect(ui0.uids.elementAt(0), equals(uid0));

      // Test replace
      final item = new MapItem.empty(rds, null)..add(ui0);
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
      final ui0 = new UItag.fromStrings(PTag.kSelectorUIValue, uidStringList0);
      final item = new MapItem.empty(rds, null)..add(ui0);
      print('values: ${ui0.values}');
      expect(ui0.values, equals(uidStringList0));
      expect(ui0.value, equals(uidStringList0[0]));
      print('values: ${ui0.uids}');
      expect(ui0.uids, equals(uidList0));
      expect(ui0.uids.elementAt(0), equals(uidList0[0]));

      // Test replace
      final uidStringList0b = item.replace(ui0.code, uidStringList0a);
      expect(uidStringList0b, equals(uidStringList0));
      expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

      // Test replaceUid
      final uidList0b = item.replaceUids(ui0.code, uidList0a);
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
        final ui0 = new UItag(PTag.kSelectorUIValue, uidList0);
        print('ui0: $ui0');
        final item = new MapItem.empty(rds, null)..add(ui0);
        print('values: ${ui0.values}');
        expect(ui0.values, equals(uidStringList0));
        expect(ui0.value, equals(uidStringList0[0]));
        print('values: ${ui0.uids}');
        expect(ui0.uids, equals(uidList0));
        expect(ui0.uids.elementAt(0), equals(uidList0[0]));

        // Test replace
        final uidStringList0b = item.replace(ui0.code, uidStringList0a);
        expect(uidStringList0b, equals(uidStringList0));
        expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

        // Test replaceUid
        final uidList0b = item.replaceUids(ui0.code, uidList0a);
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
            new UItag.fromStrings(PTag.kSelectorUIValue, uidStringList0);
        final item = new MapItem.empty(rds, null)..add(ui0);
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
        final uidList0b = item.replaceUids(ui0.code, uidList0a);
        print('uidList0b: $uidList0b');
        expect(uidList0b, equals(uidList0b));
        expect(uidList0b.elementAt(0), equals(uidList0b[0]));
      }
    });

    test('replace', () {
      final item = new MapItem.empty(rds, null);
      final vList0 = [15.24];
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, vList0);
      item.add(fd0);

      final vList1 = [123];
      expect(item.replace(fd0.index, vList1), equals(vList0));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));

      system.throwOnError = true;
      final vList2 = ['024Y'];
      final as0 = new AStag(PTag.kPatientAge, vList2);
      final vList3 = [123];
      //expect(map.replace(as0.index, vList3), equals(vList2));
      expect(() => item.replace(as0.index, vList3, required: true),
          throwsA(const isInstanceOf<ElementNotPresentError>()));
    });

    test('replaceAll', () {
      final item = new MapItem.empty(rds, null);
      final vList0 = [15.24];
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, vList0);
      item.add(fd0);

      final vList1 = [123];
      final replaceA0 = item.replaceAll(fd0.index, vList1);
      log.debug('replaceA0 : $replaceA0');
      expect(replaceA0, equals([vList0, vList1]));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));
    });

    test('== and hashCode', () {
      final item0 = new MapItem.empty(rds, null);
      final item1 = new MapItem.empty(rds, null);
      final item2 = new MapItem.empty(rds, null);

      final cs0 = new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final cs1 = new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final cs2 = new CStag(PTag.kImageFormat, ['FOO']);

      item0[cs0.code] = cs0;
      item1[cs1.code] = cs1;
      item2[cs2.code] = cs2;

      log.debug(
          'item.hashCode: ${item0.hashCode}, map1.hashCode : ${item1.hashCode}'
          ', map2.hashCode : ${item2.hashCode}');

      expect(item0 == item1, true);
      expect(item0.hashCode, equals(item1.hashCode));

      expect(item0 == item2, false);
      expect(item0.hashCode, isNot(item2.hashCode));

      expect(item1 == item2, false);
      expect(item1.hashCode, isNot(item2.hashCode));
    });

    test('others', () {
      final item = new MapItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);

      item[as0.code] = as0;

      expect(item.toList(), equals([as0]));
      expect(item.toList(), equals([as0]));
      expect(item.keys, equals([as0.key]));
      expect(item.keys, equals([as0.key]));
      expect(item.length == as0.length, true);
    });

    test('copy', () {
      final item = new MapItem.empty(rds, null);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      item[as0.code] = as0;
      item[ss0.code] = ss0;
      item[fd0.code] = fd0;
      log.debug('item : $item');

      final copy0 = item.copy();
      log.debug('copy0: $copy0');
      expect(copy0, equals(new MapItem.from(item, rds, null)));
      expect(copy0, equals(item));
    });
  });
}
