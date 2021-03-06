// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

void main() {
  Server.initialize(name: 'dataset/tag_dataset_test', level: Level.info);
  final rsg = new RSG(seed: 1);
  final rng = new RNG(1);

  system.throwOnError = false;

  group('Data set adding different types of elements', () {
    Dataset rootDS = new TagRootDataset();

    test('Create a data set object from map', () {
      Tag tag = PTag.lookupByCode(kStudyDate, kDAIndex); // Study Date
      final date = new DAtag(tag, ['19990505']);
      rootDS.add(date);

      //  element.modify(1, 10, 4);
      expect(date.checkValue('3758'), false);
//Urgent Sharath: next line is greater than maxYear
      //expect(date.tag.isValidValue('25240528'), true);
      expect(date.checkValue('20240528'), true);

      tag = PTag.lookupByCode(kSeriesDate, kDAIndex); // Series Date
      rootDS.add(new DAtag(tag, ['19990505']));

      tag = PTag.lookupByCode(kAcquisitionDate); // Acquisition Date
      rootDS.add(new DAtag(tag, ['19990505']));

      tag = PTag.lookupByCode(kContentDate); // Image Date
      rootDS.add(new DAtag(tag, ['19990505']));

      tag = PTag.lookupByCode(kStudyTime); // Study Time
      rootDS = new TagRootDataset();
      var time = new TMtag(tag, ['105234.530000']);
      log.debug('Time: ${time.info}');
      expect(time.hasValidValues, true);
      rootDS.add(time);
      log.debug('time0: ${rootDS[kStudyTime].info}');

      tag = PTag.lookupByCode(kSeriesTime); // Series Time
      rootDS.add(new TMtag(tag, ['105234.530000']));

      tag = PTag.lookupByCode(kAcquisitionTime); //   Acquisition Time
      rootDS.add(new TMtag(tag, ['105234.530000']));

      tag = PTag.lookupByCode(kContentTime); // Image Time
      rootDS.add(new TMtag(tag, ['105234.530000']));

      tag = PTag.lookupByCode(kOverlayTime); // Overlay Time
      log.debug('kOverlayTime: $tag');
      time = new TMtag(tag, ['105234.530000']);
      log.debug('Time: ${time.info}');
      rootDS
        ..add(time)
        ..delete(time.tag.code, required: false);

      // Uids (UI)
      tag = PTag.lookupByCode(kMediaStorageSOPClassUID); // Media Storage SOP Class UID
      rootDS.add(new UItag(tag, [kCTImageStorage]));

      tag = PTag
          .lookupByCode(kMediaStorageSOPInstanceUID); // Media Storage SOP Instance UID

      rootDS.add(new UItag(
          tag, ['2.16.840.1.113662.2.1.4519.41582.4105152.419990505.410523251']));
      tag = PTag.lookupByCode(kTransferSyntaxUID); // Transfer Syntax UID
      rootDS.add(new UItag(tag, [kExplicitVRLittleEndian]));
      tag = PTag.lookupByCode(kStudyInstanceUID); // Study Instance UID
      rootDS.add(new UItag(tag, ['2.16.840.1.113662.2.1.1519.11582.1990505.1105152']));
    });
  });

  group('DataSet methods - 1', () {
    final rootDS0 = new TagRootDataset();

    final tag1 = PTag.lookupByCode(kStudyInstanceUID);
    final tag2 = PTag.lookupByCode(kTransferSyntaxUID);
    final tag3 = PTag.lookupByCode(kMediaStorageSOPInstanceUID);
    final tag4 = PTag.lookupByCode(kSeriesTime);
    var tag5 = PTag.lookupByCode(kAcquisitionDate);
    rootDS0
      ..add(new UItag(tag1, ['2.16.840.1.113662.2.1.1519.11582.1990505.1105152']))
      ..add(new UItag(tag2, [kExplicitVRLittleEndian]))
      ..add(new UItag(
          tag3, ['2.16.840.1.113662.2.1.4519.41582.4105152.419990505.410523251']))
      ..add(new TMtag(tag4, ['105234.530000']))
      ..add(new DAtag(tag5, ['19990505']));
/* Urgent Jim: move to profile.dart

    test('test for Retained', () {
      rootDS0.retainCode(kStudyInstanceUID);
      log.debug('Retained : ${rootDS0.retainedCodes}');
    });

    test('test for RetainTag', () {
      tag2 = PTag.lookupByCode(kTransferSyntaxUID);
      rootDS0.retain(tag2);
      log.debug('Retained : ${rootDS0.retainedCodes}');
    });

    test('test for retain', () {
      rootDS0.retain(kMediaStorageSOPInstanceUID);
      log.debug('Retained : ${rootDS0.retainedCodes}');
    });

    test('test for retain', () {
      tag1 = PTag.lookupByCode(kStudyInstanceUID);
      rootDS0.retain(tag1);
      log.debug('Retained : ${rootDS0.retainedCodes}');
    });

    test('test for retainAll', () {
      const List<Tag> tags = const [
        PTag.kStudyInstanceUID,
        PTag.kTransferSyntaxUID,
        PTag.kMediaStorageSOPInstanceUID
      ];
      rootDS0.retainAll(tags);
      log.debug('Retained : ${rootDS0.retainedCodes}');
    });

    test('test for retainAllTags', () {
      tag1 = PTag.lookupByCode(kStudyInstanceUID);
      tag2 = PTag.lookupByCode(kTransferSyntaxUID);
      tag3 = PTag.lookupByCode(kMediaStorageSOPInstanceUID);
      rootDS0.retainAll([tag1, tag2, tag3]);
      log.debug('Retained : ${rootDS0.retainedCodes}');
    });
*/
    test('test for remove', () {
      tag5 = PTag.lookupByCode(kSeriesTime);
      var removedElement = rootDS0.elements[kSeriesTime];
      log
        ..debug('removedElement: $removedElement')
        ..debug('removedElement code: ${removedElement.tag.code}');
      final e = rootDS0.delete(removedElement.tag.code);
      log.debug('removed e: $e');
      expect(e, equals(removedElement));
      removedElement = rootDS0.elements[kSeriesTime];
      expect(rootDS0.delete(tag5.code), equals(removedElement));
    });

    test('test for copy', () {
      final dsNew = rootDS0.copy();
      log
        ..debug('rootDS0: ${rootDS0.info}')
        ..debug('dsNew: ${dsNew.info}')
        ..debug('dsNew: $dsNew')
        ..debug('rootDS.elements: ${rootDS0.elements}')
        ..debug('dsNew.elements: ${dsNew.elements}');
      expect(dsNew.elements, equals(rootDS0.elements));

      final ds1 = rootDS0.copy(rootDS0.parent);
      log.debug('ds1: $ds1');
      final ds2 = rootDS0.copy(null);
      log.debug('ds2.elements: ${ds2.elements}');

      expect(ds2.elements, equals(rootDS0.elements));
      expect(rootDS0 == ds1, true);
      expect(rootDS0 == ds2, true);
      expect(rootDS0.elements == ds1.elements, true);
      expect(rootDS0.elements == ds2.elements, true);
      expect(ds1.elements == ds2.elements, true);
      log
        ..debug('rootDS0: ${rootDS0.info}')
        ..debug('ds1: ${ds1.info}')
        ..debug('ds2: ${ds2.info}')
        ..debug('rootDS0.hashCode: ${rootDS0.hashCode}')
        ..debug('ds1.hashCode: ${ds1.hashCode}')
        ..debug('ds2.hashCode: ${ds2.hashCode}');
      expect(rootDS0.hashCode == ds2.hashCode, true);
    });

    test('== and hashcode', () {
      // rootDS0
      final rootDS0 = new TagRootDataset();
      final tag1 = PTag.lookupByCode(kStudyInstanceUID);
      final tag2 = PTag.lookupByCode(kTransferSyntaxUID);
      final tag3 = PTag.lookupByCode(kMediaStorageSOPInstanceUID);
      final tag4 = PTag.lookupByCode(kSeriesTime);
      final tag5 = PTag.lookupByCode(kAcquisitionDate);
      rootDS0
        ..add(new UItag(tag1, ['2.16.840.1.113662.2.1.1519.11582.1990505.1105152']))
        ..add(new UItag(tag2, [kExplicitVRLittleEndian]))
        ..add(new UItag(
            tag3, ['2.16.840.1.113662.2.1.4519.41582.4105152.419990505.410523251']))
        ..add(new TMtag(tag4, ['105234.530000']))
        ..add(new DAtag(tag5, ['19990505']));

      // rootDS1
      final rootDS1 = new TagRootDataset()
        ..add(new UItag(tag1, ['2.16.840.1.113662.2.1.1519.11582.1990505.1105152']))
        ..add(new UItag(tag2, [kExplicitVRLittleEndian]))
        ..add(new UItag(
            tag3, ['2.16.840.1.113662.2.1.4519.41582.4105152.419990505.410523251']))
        ..add(new TMtag(tag4, ['105234.530000']))
        ..add(new DAtag(tag5, ['19990505']));

      expect(rootDS0 == rootDS1, true);
      expect(rootDS0.hashCode == rootDS1.hashCode, true);

      // rootDS2
      final rootDS2 = new TagRootDataset()
        ..add(new UItag(tag1, ['2.16.840.1.113662.2.1.1519.11582.1990505.1105152']))
        ..add(new UItag(tag2, [kExplicitVRLittleEndian]))
        ..add(new UItag(
            tag3, ['2.16.840.1.113662.2.1.4519.41582.4105152.419990505.410523251']));

      expect(rootDS0 == rootDS2, false);
      expect(rootDS1 == rootDS2, false);
      expect(rootDS0.hashCode == rootDS2.hashCode, false);
      expect(rootDS1.hashCode == rootDS2.hashCode, false);

      // rootDS3 (empty dataset)
      final rootDS3 = new TagRootDataset();
      expect(rootDS0 == rootDS3, false);
      expect(rootDS0.hashCode == rootDS3.hashCode, false);
    });

    test('test for noValue', () {
      // Setup and confirm
      final tag1 = PTag.lookupByCode(kStudyInstanceUID);
      final studyUid0 = new UItag(tag1, ['1.2.840.10008.0']);
      final rds0 = new TagRootDataset()..add(studyUid0);
      expect(rds0[kStudyInstanceUID], equals(studyUid0));

      // No Value
      final studyUid1 = rds0.noValues(tag1.code);
      expect(studyUid0, equals(studyUid1));
      final noValuesElement = rds0[tag1.code];
      log.debug('No Values : $noValuesElement');
      expect(noValuesElement.values.isEmpty, true);
      system.throwOnError = true;
    });
  });

  group('DataSet methods - 2', () {
    system.throwOnError = false;

    test('add', () {
      final rds = new TagRootDataset();
      final stringAEList0 = rsg.getAEList(1, 10);
      final ae0 = new AEtag(PTag.kRetrieveAETitle, stringAEList0);
      final ae1 = new AEtag(PTag.kRetrieveAETitle, stringAEList0);
      final ae2 = new AEtag(PTag.kRetrieveAETitle, stringAEList0);
      system.throwOnError = true;
      rds.allowDuplicates = false;
      log
        ..debug('allowDuplicates: ${rds.allowDuplicates}')
        ..debug('system.throwOnError: $system.throwOnError')
        ..debug('ae0: ${ae0.info} isValid: ${ae0.isValid}');
      rds.add(ae0);
      log.debug('rds: $rds');
      expect(() => rds.add(ae0), throwsA(const isInstanceOf<DuplicateElementError>()));

      try {
        rds.add(ae0);
        // ignore: avoid_catching_errors
      } on DuplicateElementError {
        log.debug('Caught DuplicateElementError');
      }

      rds.allowDuplicates = false;
      log.debug('allow: ${rds.allowDuplicates}');
      system.throwOnError = true;
      // Adding same element twice
      expect(() => rds.add(ae0), throwsA(const isInstanceOf<DuplicateElementError>()));
      expect(rds[ae0.key] == ae0, true);

      // Adding element with same [id]
      expect(() => rds.add(ae2), throwsA(const isInstanceOf<DuplicateElementError>()));
      expect(rds[ae2.key] == ae0, true);

      // Adding Invalid element
      expect(() => rds.add(ae1), throwsA(const isInstanceOf<DuplicateElementError>()));
      expect(rds[ae1.key] == ae0, true);

      system.throwOnError = false;
      log.debug('system.throwOnError: $system.throwOnError');
      expect(rds.add(ae0), isNull);
      expect(rds.add(ae1), isNull);
      expect(rds.add(ae2), isNull);
    });

    test('update', () {
      final stringAEList0 = rsg.getAEList(1, 10);
      final ae0 = new AEtag(PTag.kRetrieveAETitle, stringAEList0);
      log.debug('stringAEList0: $stringAEList0, ae0.values: ${ae0.values}');
      expect(ae0.values, equals(stringAEList0));

      final stringSTList0 = rsg.getSTList(1, 1);
      final st0 = new STtag(PTag.kMetaboliteMapDescription, stringSTList0);

      final stringDSList0 = rsg.getDSList(2, 2);
      final ds0 = new DStag(PTag.kPresentationPixelSpacing, stringDSList0);

      final rootDS = new TagRootDataset()..add(ae0)..add(st0)..add(ds0);
      log.debug('rootDS: $rootDS');

      final stringAEList1 = rsg.getAEList(1, 10);
      log.debug('stringAEList1: $stringAEList1');
      final aeOld = rootDS.lookup(ae0.tag.code);
      log.debug('aeOld: ${aeOld.info}');
      var old = rootDS.update(ae0.tag.code, stringAEList1);
      expect(old, isNotNull);
      expect(ae0 == old, true);
      final ae1 = rootDS.lookup(old.index);
      log
        ..debug('ae1: ${ae1.info}')
        ..debug('stringAEList1: $stringAEList1, ae1.values: ${ae1.values}');
      expect(ae1.values, equals(stringAEList1));

      final stringSTList1 = rsg.getSTList(1, 1);
      old = rootDS.update<String>(st0.tag.code, stringSTList1);
      expect(old, isNotNull);
      expect(st0 == old, true);
      final st1 = rootDS.lookup(old.index);
      log.debug('stringSTList1: $stringSTList1, st1.values: ${st1.values}');
      expect(st1.values, equals(stringSTList1));

      final stringDSList1 = rsg.getDSList(2, 2);
      old = rootDS.update<String>(ds0.tag.code, stringDSList1);
      expect(old, isNotNull);
      expect(ds0 == old, true);
      final ds1 = rootDS.lookup(old.index);
      log.debug('stringDSList1: $stringDSList1, ds1.values: ${ds1.values}');
      expect(ds1.values, equals(stringDSList1));

      system.throwOnError = false;
      final te0 = rootDS.update<String>(kQueryRetrieveLevel, stringDSList1);
      expect(te0, isNull);
      old = rootDS.update<String>(kCompoundGraphicInstanceID, stringDSList1);
      expect(old, isNull);

      expect(rootDS.update<String>(kQueryRetrieveLevel, stringDSList1), isNull);
      expect(rootDS.update<String>(kCompoundGraphicInstanceID, stringDSList1), isNull);

      system.throwOnError = true;

      expect(
          () =>
              rootDS.update<String>(kQueryRetrieveLevel, stringDSList1, required: false),
          throwsA(const isInstanceOf<ElementNotPresentError>()));

      expect(
          () => rootDS.update<String>(kQueryRetrieveLevel, stringDSList1, required: true),
          throwsA(const isInstanceOf<InvalidElementIndexError>()));

      expect(
          () => rootDS.update<String>(kCompoundGraphicInstanceID, stringDSList1,
              required: false),
          throwsA(const isInstanceOf<ElementNotPresentError>()));

      expect(
          () => rootDS.update<String>(kCompoundGraphicInstanceID, stringDSList1,
              required: true),
          throwsA(const isInstanceOf<InvalidElementIndexError>()));
    });

    test('listsEqual', () {
      final vList0 = rsg.getUCList(1, 1);
      final uc0 = new UCtag(PTag.kStrainDescription, vList0);
      final uc1 = new UCtag(PTag.kStrainDescription, vList0);

      expect(Element.vListEqual(uc0.vfBytes, uc1.vfBytes), true);

      final vList1 = rsg.getUCList(1, 1);
      final uc2 = new UCtag(PTag.kStrainDescription, vList1);
      final uc3 = new UCtag(PTag.kStrainDescription, vList1);

      expect(Element.vListEqual(uc2.vfBytes, uc3.vfBytes), true);
    });

    test('total', () {
      final rootDS0 = new TagRootDataset();
      final valuesList = <TagItem>[];

      // Make Item with 3 Elements
      final elements0 = new MapAsList();
      elements0[kRecognitionCode] = new SHtag(PTag.kRecognitionCode, ['foo bar']);
      elements0[kInstitutionAddress] = new STtag(PTag.kInstitutionAddress, ['foo bar']);
      elements0[kExtendedCodeMeaning] = new LTtag(PTag.kExtendedCodeMeaning, ['foo bar']);
      valuesList.add(new TagItem.fromList(rootDS0, elements0));
      expect(elements0.length == 3, true);

      // Make Item with 5 Elements
      final elements1 = new MapAsList();
      final lt = new LTtag(PTag.kApprovalStatusFurtherDescription, ['foo bar']);
      final lo = new LOtag(PTag.kProductName, ['foo bar']);
// Urgent: Sharath invalid values please fix
//      final ss = new SStag(PTag.kTagAngleSecondAxis, <int>[123, 345]);
//      final sl = new SLtag(PTag.kReferencePixelX0, <int>[13, 29, 67, 55]);

      system.throwOnError = false;
      //Next line throws InvalidValuesError because 345 is not valid
      final ob0 = new OBtag(PTag.kICCProfile, [123, 345], 2);
      expect(ob0, isNull);
      system.throwOnError = true;
      expect(() =>new OBtag(PTag.kICCProfile, [123, 345], 2),
                 throwsA(const isInstanceOf<InvalidValuesError>()));


      final ob = new OBtag(PTag.kICCProfile, [123, 255], 2);

      elements1[lt.code] = lt;
      elements1[lo.code] = lo;
// Urgent: Sharath related to line 408 and 409 above please fix
//      elements1[ss.code] = ss;
//      elements1[sl.code] = sl;
      elements1[ob.code] = ob;
      valuesList.add(new TagItem.fromList(rootDS0, elements1));
//      expect(elements1.length == 5, true);

      // Create SQtag and add to rootDS0
      final sqTag = PTag.kReferencedStudySequence;
      final sq = new SQtag(sqTag, rootDS0, valuesList, SQ.kMaxVFLength);
      log..debug('sq: ${sq.info}');
      expect(sq.length == 2, true);

      //Sequence Elements
      rootDS0.add(sq);
      // Only 1 Element at top level
      expect(rootDS0.length == 1, true);

      /// 2 Items with 8 elements + sq itself = 9
      log
        ..debug('rootDS: ${rootDS0.info}')
        ..debug('rootDS: ${rootDS0.elements}')
        ..debug('total: ${rootDS0.total}');
// Urgent: Sharath related to line 471 and 472 above please fix
//      expect(rootDS0.total == 9, true);

      final sq1 = rootDS0.lookup(sqTag.code);
      expect((sq == sq1), true);

      log.debug('rootDS0.total: ${rootDS0.total}, sq.total: ${sq.total}');
//      expect(sq1.total == 9, true); // No of Items in SQtag
      final List<double> float32List0 = rng.float32List(1, 1);
      final fl0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, float32List0);
      rootDS0.add(fl0);

      final stringList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);
      rootDS0.add(lo0);
      log
        ..debug('length: ${rootDS0.length}, total: ${rootDS0.total} ')
        ..debug('rootDS0.total: ${rootDS0.total}, sq.total: ${sq.total}');
      // No of SQtag Elements in top level of rootDS0
      expect(rootDS0.length == 3, true);
//      expect(rootDS0.total == 11, true);
    });

    test('removeDuplicates', () {
      final un0 = new UNtag(PTag.kAirCounts, [1]);
      final un1 = new UNtag(PTag.kAirCounts, [2]);
// Urgent: Sharath next 2 lines throw InvalidVRIndex please fix
//      final aeUN0 = new AEtag(PTag.kDarkCurrentCounts, ['3']);
//      final aeUN1 = new AEtag(PTag.kAirCounts, ['3']);

      final rds = new TagRootDataset();
      log.debug('system.throwOnError: $system.throwOnError');
      rds.add(un0);
      log.debug('rds.elements.length: ${rds.elements.length}, rds.duplicates.length: '
          '${rds.elements.history.duplicates.length}');

      rds.allowDuplicates = false;
      expect(() => rds.add(un1), throwsA(const isInstanceOf<DuplicateElementError>()));
// Urgent: Sharath related to line 471 and 472 above please fix
//      rds.add(aeUN0);
//    expect(() => rds.add(aeUN1), throwsA(const isInstanceOf<DuplicateElementError>()));

      rds.allowDuplicates = true;
      expect(rds.add(un1), isNull);
// Urgent: Sharath related to line 471 and 472 above please fix
//      expect(rds.add(aeUN1), isNull);

      log
        ..debug('rds.elements.length: ${rds.elements.length}, rds.duplicates.length: '
            '${rds.elements.history.duplicates.length}')
        ..debug('rds.total: ${rds.total}');
      rds.elements.history.duplicates = <Element>[];
      log.debug('rds.elements.length: ${rds.elements.length}, rds.duplicates.length: '
          '${rds.elements.history.duplicates.length}');

      system.throwOnError = false;
      log.debug('system.throwOnError:$system.throwOnError');
      expect(rds.add(un1), isNull);
// Urgent: Sharath related to line 471 and 472 above please fix
//      expect(rds.add(aeUN1), isNull);
    });
  });

  group('All ListValues', () {
    system.throwOnError = false;

    test('getIntList', () {
      const int16Min = const [kInt16Min];
      final ss0 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      final sh0 = new SHtag(PTag.kPerformedLocation, ['fgh']);
      final fl0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, [123.45]);
      final rootDS0 = new TagRootDataset()..add(ss0)..add(sh0)..add(fl0);

      log.debug('system.throwOnError:$system.throwOnError');
      //integer type VR
      expect(rootDS0.getIntList(kTagAngleSecondAxis), equals(int16Min));

      system.throwOnError = true;
      //string type VR
      expect(() => rootDS0.getIntList(kPerformedLocation),
          throwsA(const isInstanceOf<InvalidTagTypeError>()));

      //float type VR
      expect(() => rootDS0.getIntList(kAbsoluteChannelDisplayScale),
          throwsA(const isInstanceOf<InvalidTagTypeError>()));

      system.throwOnError = false;
      log.debug('system.throwOnError:$system.throwOnError');
      expect(rootDS0.getIntList(kAbsoluteChannelDisplayScale), isNull);
    });

    test('getIntValue', () {
      system.throwOnError = false;
      const int32Min = const [kInt16Min];
      final sl0 = new SLtag(PTag.kReferencePixelX0, int32Min);
// Urgent: Sharath  sl2 is invalid please fix
//      final sl2 = new SLtag(PTag.kDisplayedAreaTopLeftHandCorner, [1, 2, 3]);
      final sl2 = new SLtag(PTag.kDisplayedAreaTopLeftHandCorner, [1, 2]);
      final lt2 = new LTtag(PTag.kDetectorDescription, ['foo']);
      final fl3 = new FLtag(PTag.kAbsoluteChannelDisplayScale, [123.45]);
      final rootDS0 = new TagRootDataset()
        ..add(sl0)
        ..add(sl2)
        ..add(lt2)
        ..add(fl3);
      log
        ..debug('fl3: ${fl3.values.runtimeType}: ${fl3.values} '
            '${fl3.values is List<double>}')
        ..debug('system.throwOnError: $system.throwOnError');
      //integer type VR
      expect(rootDS0.getInt(kReferencePixelX0), equals(int32Min[0]));

      system.throwOnError = true;
      rootDS0.allowInvalidValues = false;
      //integer type VR : with VM more then one
// Urgent: Sharath  please fix, my fix on line 537 made this not wor
//      expect(() => rootDS0.getIntList(kDisplayedAreaTopLeftHandCorner, required: true),
//          throwsA(const isInstanceOf<InvalidElementError>()));
//      expect(() => rootDS0.getInt(kDisplayedAreaTopLeftHandCorner, required: true),
//          throwsA(const isInstanceOf<InvalidValuesLengthError>()));

      //string type VR
      expect(() => rootDS0.getInt(kDetectorDescription),
          throwsA(const isInstanceOf<InvalidTagTypeError>()));

      //float type VR
      expect(() => rootDS0.getInt(kAbsoluteChannelDisplayScale),
          throwsA(const isInstanceOf<InvalidTagTypeError>()));

      system.throwOnError = false;
      log.debug('system.throwOnError:$system.throwOnError');
      expect(rootDS0.getInt(kDisplayedAreaTopLeftHandCorner), isNull);
      expect(rootDS0.getInt(kDetectorDescription), isNull);
      expect(rootDS0.getInt(kAbsoluteChannelDisplayScale), isNull);
    });

    test('getStringList', () {
      final stringList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);
      final ss2 = new SStag(PTag.kTagAngleSecondAxis, [12]);
      final fl3 = new FLtag(PTag.kAbsoluteChannelDisplayScale, [123.45]);
      final rootDS0 = new TagRootDataset()..add(lo0)..add(ss2)..add(fl3);

      log
        ..debug('system.throwOnError:$system.throwOnError')
        //string type VR
        ..debug('hasValueValues lo0: ${lo0.hasValidValues}')
        ..debug('hasValueValues strngList0:'
            ' ${PTag.kReceiveCoilManufacturerName.isValidValues(stringList0)}');
      final values = rootDS0.getStringList(kReceiveCoilManufacturerName);
      log
        ..debug('values: $values')
        ..debug('isString: ${isStringVR(PTag.kReceiveCoilManufacturerName.vrIndex)}')
        ..debug(isStringVR(PTag.kReceiveCoilManufacturerName.vrIndex));
      expect(rootDS0.getStringList(kReceiveCoilManufacturerName), equals(stringList0));

      system.throwOnError = true;
      //integer type VR
      expect(() => rootDS0.getStringList(kTagAngleSecondAxis),
          throwsA(const isInstanceOf<TypeError>()));

      //float type VR
      expect(() => rootDS0.getStringList(kAbsoluteChannelDisplayScale),
          throwsA(const isInstanceOf<TypeError>()));
    });

    test('getStringValue', () {
      final stringList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);
      final ds2 = new DStag(PTag.kImagerPixelSpacing, ['123', '345']);
      final ss2 = new SStag(PTag.kTagAngleSecondAxis, [12]);
      final fl3 = new FLtag(PTag.kAbsoluteChannelDisplayScale, [123.45]);
      final rootDS0 = new TagRootDataset()..add(lo0)..add(ss2)..add(ds2)..add(fl3);

      log.debug('system.throwOnError:$system.throwOnError');
      //string type VR
      expect(rootDS0.getString(kReceiveCoilManufacturerName), equals(stringList0[0]));

      system.throwOnError = true;
      //string type VR : with VM more than 1
      expect(() => rootDS0.getString(kImagerPixelSpacing, required: true),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));

      //integer type VR
      expect(() => rootDS0.getString(kTagAngleSecondAxis),
          throwsA(const isInstanceOf<TypeError>()));

      //float type VR
      expect(() => rootDS0.getString(kAbsoluteChannelDisplayScale),
          throwsA(const isInstanceOf<TypeError>()));

      system.throwOnError = false;
      log.debug('system.throwOnError:$system.throwOnError');
    });

    test('getFloatList', () {
      final List<double> float32List0 = rng.float32List(1, 1);
      final fl0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, float32List0);
      final sl2 = new SLtag(PTag.kReferencePixelX0, [458]);
      final da2 = new DAtag(PTag.kStudyDate, ['20151212']);
      final rootDS0 = new TagRootDataset()..add(fl0)..add(sl2)..add(da2);

      log.debug('system.throwOnError:$system.throwOnError');
      //float type VR
      expect(rootDS0.getFloatList(kAbsoluteChannelDisplayScale), equals(float32List0));

      system.throwOnError = true;
      //integer type VR
      expect(() => rootDS0.getFloatList(kReferencePixelX0),
          throwsA(const isInstanceOf<TypeError>()));

      //string type VR
      expect(() => rootDS0.getFloatList(kStudyDate),
          throwsA(const isInstanceOf<TypeError>()));
    });

    test('getFloatValue', () {
      final List<double> float32List0 = rng.float32List(1, 1);
      final fl0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, float32List0);
      final fl1 = new FLtag(PTag.kAnatomicStructureReferencePoint, [123.78, 456.99]);
      final sl0 = new SLtag(PTag.kReferencePixelX0, [458]);
      final da0 = new DAtag(PTag.kStudyDate, ['20151212']);
      final rootDS0 = new TagRootDataset()..add(fl0)..add(fl1)..add(sl0)..add(da0);

      log.debug('system.throwOnError:$system.throwOnError');
      //float type VR
      expect(rootDS0.getFloat(kAbsoluteChannelDisplayScale), equals(float32List0[0]));

      system.throwOnError = true;
      //string type VR : with VM more than 1
      expect(() => rootDS0.getFloat(kAnatomicStructureReferencePoint),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));

      //integer type VR
      expect(() => rootDS0.getFloat(kReferencePixelX0),
          throwsA(const isInstanceOf<TypeError>()));

      //string type VR
      expect(
          () => rootDS0.getFloat(kStudyDate), throwsA(const isInstanceOf<TypeError>()));
    });

    test('[] and []=', () {
      final stringList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);
      final ut0 = new UTtag(PTag.kUniversalEntityID, ['dfg']);
      final rootDS0 = new TagRootDataset()..add(lo0)..add(ut0);

      log.debug('system.throwOnError:$system.throwOnError');
      //[]
      final element0 = rootDS0[lo0.code];
      log.debug('lo0: $lo0, Element0: $element0');
      expect(element0 == lo0, true);
      expect(element0, equals(lo0));

      final element1 = rootDS0[ut0.code];
      log.debug('ut0: $ut0, Element1: $element1');
      expect(element1 == ut0, true);
      expect(element1, equals(ut0));

      final element2 = rootDS0[kIdentifierTypeCode];
      log.debug('Element2: $element2');
      expect(element2, isNull);

      //[]=
      final stringList1 = rsg.getLTList(1, 1);
      final lt0 = new LTtag(PTag.kAcquisitionProtocolDescription, stringList1);

      //adding a new element
      rootDS0[lt0.key] = lt0;
      log.debug(rootDS0);
      expect(rootDS0.total == 3, true);

      //adding a duplicate element
      system.throwOnError = true;
      rootDS0.allowDuplicates = false;
      //expect((rootDS0[lo0.key] = lo0) == lo0, true);
      expect(() => rootDS0[lo0.key] = lo0,
          throwsA(const isInstanceOf<DuplicateElementError>()));

      rootDS0.allowDuplicates = true;
      expect((rootDS0[lo0.key] = lo0) == lo0, true);

      system.throwOnError = false;
      log.debug('system.throwOnError:${system.throwOnError }');
      expect(rootDS0[lo0.key] = lo0, lo0);
      //rootDS0[lo0.tag]=ut0;
    });

    test('hasDuplicates', () {
      final rootDS0 = new TagRootDataset();

      final stringList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);
      rootDS0.add(lo0);

      final List<double> float32List0 = rng.float32List(1, 1);
      final fl0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, float32List0);
      rootDS0.add(fl0);

      log.debug('system.throwOnError:${system.throwOnError }');

      //no duplicates
      expect(rootDS0.hasDuplicates, false);

      final un0 = new UNtag(PTag.kAirCounts, [1]);
      final un1 = new UNtag(PTag.kAirCounts, [1, 2, 3]);

      system.throwOnError = true;
      rootDS0.add(un0);
      log.debug('rds.elements.length: ${rootDS0.elements.length}, rds.duplicates.length: '
          '${rootDS0.elements.history.duplicates.length}');
      //adding duplicates
      rootDS0.allowDuplicates = false;
      expect(
          () => rootDS0.add(un1), throwsA(const isInstanceOf<DuplicateElementError>()));

      rootDS0.allowDuplicates = true;
      expect(rootDS0.add(un1), isNull);

      system.throwOnError = false;
      log.debug('system.throwOnError:$system.throwOnError');
      expect(rootDS0.add(un1), isNull);

      //has Duplicates
      expect(rootDS0.hasDuplicates, true);
    });

    test('isRoot and root', () {
      //isRoot
      final rootDS0 = new TagRootDataset();
      expect(rootDS0.isRoot, true);

      final stringList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);
      rootDS0.add(lo0);
      expect(rootDS0.isRoot, true);

      //root
      final rootNew = rootDS0.root;
      log.debug('rootDS0: $rootDS0, rootNew: $rootNew');
      expect(rootDS0, equals(rootNew));
    });

    test('length', () {
      final stringList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);
      final fl2 = new FLtag(PTag.kAnatomicStructureReferencePoint, [123.78, 456.99]);
      final rootDS0 = new TagRootDataset()..add(lo0)..add(fl2);

      log.debug('rootDS0.length: ${rootDS0.length}');
      expect(rootDS0.length == rootDS0.elements.length, true);
    });

    test('elements', () {
      final stringList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);
      final st2 = new STtag(PTag.kMetaboliteMapDescription, ['dfg']);
      final rootDS0 = new TagRootDataset()..add(lo0)..add(st2);

      final Iterable<Element> elms = [lo0, st2];
      log
        ..debug('rootDS0.elements: ${rootDS0.elements}')
        ..debug('elms: $elms')
        ..debug('elements: ${rootDS0.elements}');
      expect(rootDS0.elements.elementsList, equals(elms));
    });

    test('keys and ids', () {
      final stringList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);
      final lo1 = new LOtag(PTag.kDataSetSubtype, stringList0);

      final List<double> float32List0 = rng.float32List(1, 1);
      final fl0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, float32List0);
      final rootDS0 = new TagRootDataset()..add(lo0)..add(lo1)..add(fl0);

      log
        ..debug(kReceiveCoilManufacturerName)
        ..debug('rootDS0.tags: ${rootDS0.keys}, rootDS0.elements.keys: '
            '${rootDS0.elements.keys}');

      expect(rootDS0.keys, equals(rootDS0.elements.keys));
    });
  });
}
