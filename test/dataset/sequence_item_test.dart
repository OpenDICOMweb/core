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
  Server.initialize(name: 'element/sequence_item_test', level: Level.info);

  group('Items and Sequences', () {
    var itemsList = <TagItem>[];

    var rds = new TagRootDataset.empty();
    final date = new DAtag(PTag.kInstanceCreationDate, ['19990505']);
    rds.add(date);

    //  var elements = new TagRootDataset.empty();
    rds[kRecognitionCode] = new SHtag(PTag.kRecognitionCode, ['foo bar']);
    rds[kInstitutionAddress] = new STtag(PTag.kInstitutionAddress, ['foo bar']);
    rds[kExtendedCodeMeaning] =
        new LTtag(PTag.kExtendedCodeMeaning, ['foo bar']);

    itemsList.add(new TagItem.fromList(rds, rds));

    rds = new TagRootDataset.empty();
    rds[PTag.kRecognitionCode.code] = new SHtag(PTag.kRecognitionCode, ['abc']);
    rds[PTag.kInstitutionAddress.code] =
        new STtag(PTag.kInstitutionAddress, ['abc']);
    rds[PTag.kExtendedCodeMeaning.code] =
        new LTtag(PTag.kExtendedCodeMeaning, ['abc']);
    itemsList.add(new TagItem.fromList(null, rds));

    rds = new TagRootDataset.empty();
    final lt = new LTtag(PTag.kApprovalStatusFurtherDescription, ['foo bar']);
    final lo = new LOtag(PTag.kProductName, ['foo bar']);
    final ss = new SStag(PTag.kTagAngleSecondAxis, [123]);
    final sl = new SLtag(PTag.kReferencePixelX0, [13]);
    final ob = new OBtag(PTag.kICCProfile, <int>[123, 255]);

    rds[lt.code] = lt;
    rds[lo.code] = lo;
    rds[ss.code] = ss;
    rds[sl.code] = sl;
    rds[ob.code] = ob;
    itemsList.add(new TagItem.fromList(rds, rds));

    //Urgent: this should be adding a real parent and verifying it.
    final sq = new SQtag(null, PTag.kMRImageFrameTypeSequence, itemsList);

    test('Test for getAllTItemElements', () {
      expect(sq.getAll(kRecognitionCode), isNotNull);
      expect(sq.getAll(kInstitutionAddress), isNotNull);
      expect(sq.getAll(kExtendedCodeMeaning), isNotNull);
      expect(sq.getAll(kApprovalStatusFurtherDescription), isNotNull);
      expect(sq.getAll(kTagAngleSecondAxis), isNotNull);
    });

    test('Test for getAll', () {
      expect(sq.getAll(kRecognitionCode), isNotNull);
      expect(sq.getAll(kInstitutionAddress), isNotNull);
      expect(sq.getAll(kExtendedCodeMeaning), isNotNull);
      expect(sq.getAll(kApprovalStatusFurtherDescription), isNotNull);
      expect(sq.getAll(kTagAngleSecondAxis), isNotNull);

      log.debug(sq.getAll(kSelectorODValue));
    });

    test('Test for getElement', () {
      final e = sq.getElement(kRecognitionCode);
      log.debug('e: $e');
      expect(e, isNotNull);

      expect(sq.getElement(kRecognitionCode, 2), isNull);

      final ob = sq.getElement(kICCProfile, 1);
      log.debug('e: $ob');
      // kICCProfile is OB and has a
      expect(sq.getElement(kICCProfile, 2), isNotNull);
    });

    test('Test for copySequence', () {
      final sqCopy = sq.copySQ(rds);
      log.debug(sqCopy.info);
      expect(sqCopy.getAll(kRecognitionCode), isNotNull);

      expect(sqCopy.getAll(kInstitutionAddress), isNotNull);

      final icc = sqCopy.getElement(kICCProfile, 1);
      log.debug('iss: $icc');
      expect(icc, isNull);
      expect(sqCopy.getElement(kICCProfile, 20), isNull);
    });

    test('Test for values', () {
      expect(itemsList, equals(sq.items));

      final sq2 = sq.update(itemsList);
      expect(itemsList, equals(sq2.items));
      expect(sq.items, equals(sq2.items));

      final sqCopy = sq.copySQ(rds);
      expect(itemsList, equals(sqCopy.items));
      expect(sq.items, equals(sqCopy.items));
    });

    test('Test for update', () {
      final rds0 = new TagRootDataset.empty();
      final fl = new FLtag(PTag.kTableOfParameterValues, [12.33, 34.4, 56.25]);
      final of = new OFtag(PTag.kVectorGridData, [132.33]);
      final fd = new FDtag(PTag.kOverallTemplateSpatialTolerance);
      final od = new ODtag(PTag.kSelectorODValue, <double>[2.33]);

      rds0[fl.code] = fl;
      rds0[of.code] = of;
      rds0[fd.code] = fd;
      rds0[od.code] = od;
      itemsList = <TagItem>[]..add(new TagItem.fromList(rds, rds0));

      final sq2 = sq.update(itemsList);
      log.debug(sq2.info);
      expect(sq2.getAll(kTableOfParameterValues), isNotNull);
      expect(sq2.getAll(kVectorGridData), isNotNull);
    });

    test('Test for items,novalues', () {
      log..debug('sq.items: ${sq.items}')..debug('sq.noValues: ${sq.noValues}');

      final rds0 = new TagRootDataset.empty();
      final fl =
          new FLtag(PTag.kTableOfParameterValues, <double>[12.33, 34.4, 56.25]);
      final of = new OFtag(PTag.kVectorGridData, <double>[34.4]);
      final fd = new FDtag(PTag.kOverallTemplateSpatialTolerance);
      final od = new ODtag(PTag.kSelectorODValue, <double>[2.33]);

      rds0[fl.code] = fl;
      rds0[of.code] = of;
      rds0[fd.code] = fd;
      rds0[od.code] = od;
      itemsList = <TagItem>[]..add(new TagItem.fromList(rds, rds0));
      final sq2 = sq.update(itemsList);
      expect(sq2.values.isEmpty, false);
      log.debug('sq2.items: ${sq2.items}');

      final noValues0 = sq2.noValues;
      log.debug('sq2.noValues: $noValues0');
      expect(noValues0.values.isEmpty, true);

      final sqCopy = sq.copySQ(rds);
      log.debug('sqCopy.items: ${sqCopy.items}');
      expect(sqCopy.values.isEmpty, false);

      final noValues1 = sqCopy.noValues;
      log.debug('sqCopy.noValues: $noValues1');
      expect(sq.items, equals(sqCopy.items));
      expect(noValues1.values.isEmpty, true);
    });

    test('Test for lookup', () {
      final rds0 = new TagRootDataset.empty();
      final fl =
          new FLtag(PTag.kTableOfParameterValues, <double>[12.33, 34.4, 56.25]);
      final sh = new SHtag(PTag.kRecognitionCode, ['foo bar']);
      final fd = new FDtag(PTag.kOverallTemplateSpatialTolerance);
      final od = new ODtag(PTag.kSelectorODValue, <double>[2.33]);

      rds0[fl.code] = fl;
      rds0[sh.code] = sh;
      rds0[fd.code] = fd;

      final itemsList = <TagItem>[]..add(new TagItem.fromList(rds0, rds0));
      final sq = new SQtag(null, PTag.kMRImageFrameTypeSequence, itemsList);

      global.throwOnError = false;
      final lookup0 = sq.lookup(fl.index);
      log.debug('lookup0: $lookup0');
      expect(lookup0, equals(fl));

      final lookup1 = sq.lookup(sh.index);
      log.debug('lookup1: $lookup1');
      expect(lookup1, equals(sh));

      final lookup2 = sq.lookup(od.index);
      log.debug('lookup2:$lookup2');
      expect(lookup2, isNull);

      final lookup3 = sq.lookup(od.index, required: true);
      log.debug('lookup3:$lookup3');
      expect(lookup3, isNull);

      global.throwOnError = true;
      expect(() => sq.lookup(od.index, required: true),
          throwsA(const TypeMatcher<ElementNotPresentError>()));
    });

    test('Test for lookupAll', () {
      final rds0 = new TagRootDataset.empty();
      final fl =
          new FLtag(PTag.kTableOfParameterValues, <double>[12.33, 34.4, 56.25]);
      final sh = new SHtag(PTag.kRecognitionCode, ['foo bar']);
      final fd = new FDtag(PTag.kOverallTemplateSpatialTolerance);
      final od = new ODtag(PTag.kSelectorODValue, <double>[2.33]);

      rds0[fl.code] = fl;
      rds0[sh.code] = sh;
      rds0[fd.code] = fd;

      final itemsList = <TagItem>[]..add(new TagItem.fromList(rds0, rds0));
      final sq = new SQtag(
          null, PTag.kMRImageFrameTypeSequence, itemsList);

      global.throwOnError = false;
      final lookup0 = sq.lookupAll(fl.index);
      log.debug('lookup0: $lookup0');
      expect(lookup0, equals([fl]));

      final lookup1 = sq.lookupAll(sh.index);
      log.debug('lookup1: $lookup1');
      expect(lookup1, equals([sh]));

      final lookup2 = sq.lookupAll(od.index);
      log.debug('lookup2:$lookup2');
      expect(lookup2, <double>[]);

      final lookup3 = sq.lookupAll(od.index, required: true);
      log.debug('lookup3:$lookup3');
      expect(lookup2, <double>[]);

      global.throwOnError = true;
      expect(() => sq.lookupAll(od.index, required: true),
          throwsA(const TypeMatcher<ElementNotPresentError>()));
    });
  });

  group('SQ', () {
    //VM.k1
    const sqTags0 = const <PTag>[
      PTag.kLanguageCodeSequence,
      PTag.kIssuerOfAccessionNumberSequence,
      PTag.kInstitutionCodeSequence,
      PTag.kCodingSchemeIdentificationSequence,
      PTag.kEquivalentCodeSequence,
      PTag.kContextGroupIdentificationSequence,
      PTag.kMappingResourceIdentificationSequence,
      PTag.kProcedureCodeSequence,
      PTag.kReferencedStudySequence,
      PTag.kReferencedVisitSequence,
      PTag.kPatientPrimaryLanguageCodeSequence,
      PTag.kReceiveProbeSequence,
      PTag.kChannelSettingsSequence,
      PTag.kMRImagingModifierSequence,
    ];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolDescription,
      PTag.kCTDIvol,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    test('SQ isValidTag good values', () {
      global.throwOnError = false;
      final isValidTag0 = SQ.isValidTag(PTag.kMRImageFrameTypeSequence);
      expect(isValidTag0, true);

      for (var tag in sqTags0) {
        final isValidTag0 = SQ.isValidTag(tag);
        expect(isValidTag0, true);
      }
    });

    test('SQ isValidTag bad values', () {
      global.throwOnError = false;
      final isValidTag0 = SQ.isValidTag(PTag.kSelectorSHValue);
      expect(isValidTag0, false);

      global.throwOnError = true;
      expect(() => SQ.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final isValidTag0 = SQ.isValidTag(tag);
        expect(isValidTag0, false);

        global.throwOnError = true;
        expect(() => SQ.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('SQ isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(SQ.isValidVRIndex(kSQIndex), true);
      for (var tag in sqTags0) {
        global.throwOnError = false;
        expect(SQ.isValidVRIndex(tag.vrIndex), true);
      }
    });
    test('SQ isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(SQ.isValidVRIndex(kAEIndex), false);

      global.throwOnError = true;
      expect(() => SQ.isValidVRIndex(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SQ.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => SQ.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('SQ isValidVRCode good values', () {
      global.throwOnError = false;
      expect(SQ.isValidVRCode(kSQCode), true);

      for (var tag in sqTags0) {
        expect(SQ.isValidVRCode(tag.vrCode), true);
      }
    });

    test('SQ isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(SQ.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => SQ.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SQ.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => SQ.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('SQ checkVRIndex good values', () {
      global.throwOnError = false;
      expect(SQ.checkVRIndex(kSQIndex), kSQIndex);

      for (var tag in sqTags0) {
        global.throwOnError = false;
        expect(SQ.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('SQ checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          SQ.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => SQ.checkVRIndex(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SQ.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => SQ.checkVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('SQ checkVRCode good values', () {
      global.throwOnError = false;
      expect(SQ.checkVRCode(kSQCode), kSQCode);

      for (var tag in sqTags0) {
        global.throwOnError = false;
        expect(SQ.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('SQ checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          SQ.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => SQ.checkVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SQ.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => SQ.checkVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('SQ isValidVFLength good values', () {
      expect(SQ.isValidVFLength(SQ.kMaxVFLength), true);
      expect(SQ.isValidVFLength(0), true);
    });

    test('SQ isValidVFLength bad values', () {
      expect(SQ.isValidVFLength(SQ.kMaxVFLength + 1), false);
      expect(SQ.isValidVFLength(-1), false);
    });
  });
}
