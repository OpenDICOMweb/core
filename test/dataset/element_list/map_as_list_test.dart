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
  Server.initialize(name: 'map_as_list_test', level: Level.info);

  group('MapAsList', () {
    test('[] and []=', () {
      final elements = new MapAsList();
      final ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransFerSyntax =
          new UItag.fromStrings(PTag.kTransferSyntaxUID, [ts.asString]);
      log.debug('ui: $uiTransFerSyntax');
      elements[uiTransFerSyntax.index] = uiTransFerSyntax;
      log.debug('elements: $elements');
      final v = elements[uiTransFerSyntax.index];
      log.debug('elements[${uiTransFerSyntax.index}] = $v');
    });

    test('insert and compare', () {
      final map0 = new MapAsList();
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      map0[as0.code] = as0;
      map0[ss0.code] = ss0;
      map0[fd0.code] = fd0;
      log.debug('map0 : $map0');

      final as1 = map0[as0.code];
      expect(as1 == as0, true);

      final da1 = map0[ss0.code];
      expect(da1 == ss0, true);

      final fd1 = map0[fd0.code];
      expect(fd1 == fd0, true);
    });

    test('removeAt', () {
      final map0 = new MapAsList();
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

      map0[as0.code] = as0;
      map0[ss0.code] = ss0;
      map0[fd0.code] = fd0;
      log.debug('map0 : $map0');

      final remove0 = map0.removeAt(as0.key);
      expect(remove0, isNotNull);
      expect(map0.removeAt(as0.key), isNull);
      log.debug('remove0 : $remove0');

      final remove1 = map0.removeAt(ss0.key);
      expect(remove1, isNotNull);
      expect(map0.removeAt(ss0.key), isNull);
      log.debug('remove1 : $remove1');

      final remove2 = map0.removeAt(fd0.key);
      expect(remove2, isNotNull);
      expect(map0.removeAt(fd0.key), isNull);
      log.debug('remove2 : $remove2');

      expect(map0.removeAt(od0.key), isNull);
    });

    test('delete', () {
      final map0 = new MapAsList();
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

      map0[as0.code] = as0;
      map0[ss0.code] = ss0;
      map0[fd0.code] = fd0;
      log.debug('map0 : $map0');

      final remove0 = map0.delete(as0.key);
      expect(remove0, isNotNull);
      expect(map0.delete(as0.key), isNull);
      log.debug('remove0 : $remove0');

      final remove1 = map0.delete(ss0.key);
      expect(remove1, isNotNull);
      expect(map0.delete(ss0.key), isNull);
      log.debug('remove1 : $remove1');

      final remove2 = map0.delete(fd0.key);
      expect(remove2, isNotNull);
      expect(map0.delete(fd0.key), isNull);
      log.debug('remove2 : $remove2');

      expect(map0.delete(od0.key), isNull);

      system.throwOnError = true;
      final sl0 = new SLtag(PTag.kRationalNumeratorValue, [123]);
      expect(() => map0.delete(sl0.key, required: true),
          throwsA(const isInstanceOf<ElementNotPresentError>()));
    });

    test('deleteAll', () {
      final map0 = new MapAsList();
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final od0 = new ODtag(PTag.kSelectorODValue, [15.24]);

      map0[as0.code] = as0;
      map0[ss0.code] = ss0;
      map0[fd0.code] = fd0;

      log.debug('map0: $map0');

      final removeAll0 = map0.deleteAll(as0.key);
      expect(removeAll0[0] == as0, true);
      expect(map0.deleteAll(as0.key), <Element>[]);
      log.debug('removeAll0: $removeAll0');

      final removeAll1 = map0.deleteAll(ss0.key);
      expect(removeAll1[0] == ss0, true);
      expect(map0.deleteAll(ss0.key), <Element>[]);
      log.debug('removeAll1 : $removeAll1');

      final removeAll2 = map0.deleteAll(fd0.key);
      expect(removeAll2[0] == fd0, true);
      expect(map0.deleteAll(fd0.key), <Element>[]);
      log.debug('removeAll2 : $removeAll2');

      expect(map0.deleteAll(od0.key), <Element>[]);
    });

    test('noValues', () {
      final map0 = new MapAsList();
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);

      map0[fd0.code] = fd0;
      map0[as0.code] = as0;

/*
      var noValues0 = map0.noValues(fd0.key);
      expect(noValues0 == fd0, true);
      expect(noValues0.values.isEmpty, false);

      noValues0 = map0.noValues(fd0.key);
      expect(noValues0.values.isEmpty, true);
      log.debug('noValues0: $noValues0');
*/

    }, skip: 'MapAsList no longer handles noValues');

    test('noValuesAll', () {
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final map0 = new MapAsList()..add(as0);

      final rds = new TagRootDataset.empty();
      final valuesList = <TagItem>[];
      map0[kRecognitionCode] = new SHtag(PTag.kRecognitionCode, ['foo bar']);
      map0[kInstitutionAddress] =
          new STtag(PTag.kInstitutionAddress, ['foo bar']);
      map0[kExtendedCodeMeaning] =
          new LTtag(PTag.kExtendedCodeMeaning, ['foo bar']);

      valuesList.add(new TagItem.fromList(rds, map0));
      final sq0 = new SQtag(PTag.kPatientSizeCodeSequence, rds);
      map0[sq0.code] = sq0;
//      final noV = map0.noValuesAll(sq0.index);
//      print(noV);

      map0[as0.code] = as0;

/*
      var noValues0 = map0.noValuesAll(as0.key);
      expect(noValues0.isEmpty, false);

      noValues0 = map0.noValuesAll(as0.key);
      for (var e in noValues0) {
        print('noValues: $e');
        expect(e.values.isEmpty, true);
        log.debug('noValues0: $noValues0');
      }
*/
    });

    test('update (String)', () {
      final map0 = new MapAsList();
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      map0[as0.code] = as0;

      final update0 = map0.update(as0.key, <String>[]);
      expect(update0.isEmpty, false);
    });

    test('update (int)', () {
      final map0 = new MapAsList();
      final vList0 = [kInt16Min];
      final ss0 = new SStag(PTag.kSelectorSSValue, vList0);
      map0.add(ss0);

      final vList1 = [kInt16Max];
      final update1 = map0.update(ss0.key, vList1).values;
      expect(update1, equals(vList0));

      final update2 = map0.update(ss0.key, <int>[]);
      expect(update2.values.isEmpty, false);
    });

    test('update (float)', () {
      final map0 = new MapAsList();
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      map0.add(fd0);
      final update1 = map0.update(fd0.key, <double>[]);
      expect(update1.isEmpty, false);
    });

    test('duplicate', () {
      final map0 = new MapAsList();
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final as1 = new AStag(PTag.kPatientAge, ['024Y']);
      final as2 = new AStag(PTag.kPatientAge, ['012M']);
      final ob0 = new OBtag(PTag.kICCProfile, [123], 2);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      map0
        ..add(fd0)
        ..add(fd1)
        ..add(as0)
        ..add(as1)
        ..add(as2)
        ..add(ob0)
        ..add(ae0);

      final dup = map0.duplicates;
      log.debug('map0: $map0, dup: $dup');
      expect(dup, isNotNull);
    });

    test('removeDuplicates', () {
      final map0 = new MapAsList();
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final fd1 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final as1 = new AStag(PTag.kPatientAge, ['024Y']);
      final as2 = new AStag(PTag.kPatientAge, ['012M']);
      final ob0 = new OBtag(PTag.kICCProfile, [123], 2);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      map0
        ..add(fd0)
        ..add(fd1)
        ..add(as0)
        ..add(as1)
        ..add(as2)
        ..add(ob0)
        ..add(ae0);

//      system.level = Level.debug;
      final dup = map0.duplicates;
      log.debug('map0: $map0, dup: $dup');
      expect(dup, isNotNull);
      final removeDup = map0.removeDuplicates();
      log.debug('map0: $map0, removeDup: $removeDup');
      expect(dup, equals(<Element>[]));
      expect(removeDup, <Element>[]);
    });

    test('getElementsInRange', () {
      final map0 = new MapAsList();
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ob0 = new OBtag(PTag.kICCProfile, [123], 2);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, ['3']);

      map0..add(fd0)..add(as0)..add(ob0)..add(ae0);

//      system.level = Level.debug;
      final inRange0 = map0.getElementsInRange(0, fd0.code);
      final inRange1 = map0.getElementsInRange(0, fd0.code + 1);
      final inRange2 = map0.getElementsInRange(0, ae0.code);
      final inRange3 = map0.getElementsInRange(0, ae0.code + 1);
      log
        ..debug('map0: $map0')
        ..debug('inRange0: $inRange0')
        ..debug('inRange1: $inRange1')
        ..debug('inRange2: $inRange2')
        ..debug('inRange3: $inRange3');

      expect(inRange0, isNotNull);
    });

    test('Simple UItag, replace, and replaceUid test', () {
      final uidString0 = '1.2.840.10008.5.1.4.34.5';
//      final uidString0a = '1.2.840.10008.5.1.4.34';
      final uidStringList0 = [uidString0];
//      final uidStringList0a = [uidString0a];
      final uid0 = new Uid(uidString0);
//      final uid0a = new Uid(uidString0a);
      final uidList0 = [uid0];
//      final uidList0a = [uid0a];

      // Create element and check values and uids
      final ui0 = new UItag(PTag.kSelectorUIValue, uidList0);
//      final map0 = new MapAsList()..add(ui0);
      print('values: ${ui0.values}');
      expect(ui0.values, equals(uidStringList0));
      expect(ui0.value, equals(uidString0));
      print('values: ${ui0.uids}');
      expect(ui0.uids, equals(uidList0));
      expect(ui0.uids.elementAt(0), equals(uid0));


/*
      // Test replace
      final uidStringList0b = map0.replace(ui0.code, uidStringList0a);
      expect(uidStringList0b, equals(uidStringList0));
      expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

      // Test replaceUid
      final uidList0b = map0.replaceUid(ui0.code, uidList0a);
      print('uidList0b: $uidList0b');
      expect(uidList0b, equals(uidStringList0a));
      expect(uidList0b.elementAt(0), equals(uidStringList0a[0]));
*/

    }, skip: 'MapAsList no longer handles replace or replaceUid');

    test('Simple UItag.fromString, replace, and replaceUid test', () {
      final uidString0 = '1.2.840.10008.5.1.4.34.5';
//      final uidString0a = '1.2.840.10008.5.1.4.34';
      final uidStringList0 = [uidString0];
//      final uidStringList0a = [uidString0a];
      final uid0 = new Uid(uidString0);
//      final uid0a = new Uid(uidString0a);
      final uidList0 = [uid0];
//      final uidList0a = [uid0a];

      // Create element and check values and uids
      final ui0 = new UItag.fromStrings(PTag.kSelectorUIValue, uidStringList0);
//      final map0 = new MapAsList()..add(ui0);
      print('values: ${ui0.values}');
      expect(ui0.values, equals(uidStringList0));
      expect(ui0.value, equals(uidStringList0[0]));
      print('values: ${ui0.uids}');
      expect(ui0.uids, equals(uidList0));
      expect(ui0.uids.elementAt(0), equals(uidList0[0]));

/*
      // Test replace
      final uidStringList0b = map0.replace(ui0.code, uidStringList0a);
      expect(uidStringList0b, equals(uidStringList0));
      expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

      // Test replaceUid
      final uidList0b = map0.replaceUid(ui0.code, uidList0a);
      print('uidList0b: $uidList0b');
      expect(uidList0b, equals(uidStringList0a));
      expect(uidList0b.elementAt(0), equals(uidStringList0a[0]));
*/

    }, skip: 'MapAsList no longer handles replace or replaceUid');

    test('Simple Random UItag, replace, and replaceUid test', () {
/*
      final count = 8;
      for(var i = 1; i < count; i++) {
        final uidList0 = Uid.randomList(count);
        final uidList0a = Uid.randomList(count);
        final uidStringList0 = UI.toStringList(uidList0);
        final uidStringList0a = UI.toStringList(uidList0a);

       // Create element and check values and uids
        print('uidList0: $uidList0');
        final ui0 = new UItag(PTag.kSelectorUIValue, uidList0);
        print('ui0: $ui0');
        final map0 = new MapAsList()
          ..add(ui0);
        print('values: ${ui0.values}');
        expect(ui0.values, equals(uidStringList0));
        expect(ui0.value, equals(uidStringList0[0]));
        print('values: ${ui0.uids}');
        expect(ui0.uids, equals(uidList0));
        expect(ui0.uids.elementAt(0), equals(uidList0[0]));

        // Test replace
        final uidStringList0b = map0.replace(ui0.code, uidStringList0a);
        expect(uidStringList0b, equals(uidStringList0));
        expect(uidStringList0b.elementAt(0), equals(uidStringList0[0]));

        // Test replaceUid
        final uidList0b = map0.replaceUid(ui0.code, uidList0a);
        print('uidList0b: $uidList0b');
        expect(uidList0b, equals(uidStringList0a));
        expect(uidList0b.elementAt(0), equals(uidStringList0a[0]));
      }
*/
    }, skip: 'MapAsList no longer handles replace or replaceUid');

    test('Simple Random UItag.fromString, replace, and replaceUid test', () {
      final rsg = new RSG(seed: 1);
      final count = 8;
      for(var i = 1; i < count; i++) {
        final uidStringList0 = rsg.getUIList(1, 1);
        final uidStringList0a = rsg.getUIList(1, 1);
        final uid0 = new Uid(uidStringList0[0]);
//        final uid0a = new Uid(uidStringList0a[0]);
        final uidList0 = [uid0];
//        final uidList0a = [uid0a];

        // Create element and check values and uids
        final ui0 = new UItag.fromStrings(
            PTag.kSelectorUIValue, uidStringList0);
//        final map0 = new MapAsList()..add(ui0);
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

/*
        // Test replaceUid
        final uidList0b = map0.replaceUid(ui0.code, uidList0a);
        print('uidList0b: $uidList0b');
        expect(uidList0b, equals(uidStringList0a));
        expect(uidList0b.elementAt(0), equals(uidStringList0a[0]));
*/

      }
    }, skip: 'MapAsList no longer handles replace or replaceUid');

    test('replace', () {
      final map = new MapAsList();
      final vList0 = [15.24];
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, vList0);
      map.add(fd0);

/*
      final vList1 = [123];
      expect(map.replace(fd0.index, vList1), equals(vList0));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));

      system.throwOnError = true;
      final vList2 = ['024Y'];
      final as0 = new AStag(PTag.kPatientAge, vList2);
      final vList3 = [123];
      //expect(map.replace(as0.index, vList3), equals(vList2));
      expect(() => map.replace(as0.index, vList3, required: true),
          throwsA(const isInstanceOf<ElementNotPresentError>()));
*/

    }, skip: 'MapAsList no longer handles replace or replaceUid');

    test('replaceAll', () {
      final map = new MapAsList();
      final vList0 = [15.24];
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, vList0);
      map.add(fd0);

/*
      final vList1 = [123];
      final replaceA0 = map.replaceAll(fd0.index, vList1);
      log.debug('replaceA0 : $replaceA0');
      expect(replaceA0, equals([vList0, vList1]));
      log.debug('fd0.values: ${fd0.values}');
      expect(fd0.values, equals(vList1));
*/

    }, skip: 'MapAsList no longer handles replace or replaceUid');

    test('== and hashCode', () {
      final map0 = new MapAsList();
      final map1 = new MapAsList();
      final map2 = new MapAsList();

      final cs0 = new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final cs1 = new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final cs2 = new CStag(PTag.kImageFormat, ['FOO']);

      map0[cs0.code] = cs0;
      map1[cs1.code] = cs1;
      map2[cs2.code] = cs2;

      log.debug(
          'map0.hashCode: ${map0.hashCode}, map1.hashCode : ${map1.hashCode}'
          ', map2.hashCode : ${map2.hashCode}');

      expect(map0 == map1, true);
      expect(map0.hashCode, equals(map1.hashCode));

      expect(map0 == map2, false);
      expect(map0.hashCode, isNot(map2.hashCode));

      expect(map1 == map2, false);
      expect(map1.hashCode, isNot(map2.hashCode));
    });

    test('others', () {
      final map0 = new MapAsList();
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);

      map0[as0.code] = as0;

      expect(map0.asList, equals([as0]));
      expect(map0.asList, equals([as0]));
      expect(map0.keys, equals([as0.key]));
      expect(map0.keysList, equals([as0.key]));
      expect(map0.length == as0.length, true);
    });

    test('copy', () {
      final map0 = new MapAsList();
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);
      final ss0 = new SStag(PTag.kPixelIntensityRelationshipSign, [123]);
      final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);

      map0[as0.code] = as0;
      map0[ss0.code] = ss0;
      map0[fd0.code] = fd0;
      log.debug('map0 : $map0');

      final copy0 = map0.copy();
      log.debug('copy0: $copy0');
      expect(copy0, equals(new MapAsList.from(map0)));
      expect(copy0, equals(map0));
    });
  });
}
