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
    // Urgent Sharath fix: don't use global variables in tests. They make
    //   it hard to understand what is going on. Please fix!
    SQtag sq;

    // Urgent Sharath: this is not a sequence tag
    final tag = PTag.lookupByCode(kInstanceCreationDate);
    var rds = new TagRootDataset.empty();
    final date = new DAtag(tag, ['19990505']);
    rds.add(date);

  //  var elements = new TagRootDataset.empty();
    rds[kRecognitionCode] = new SHtag(PTag.kRecognitionCode, ['foo bar']);
    rds[kInstitutionAddress] =
        new STtag(PTag.kInstitutionAddress, ['foo bar']);
    rds[kExtendedCodeMeaning] =
        new LTtag(PTag.kExtendedCodeMeaning, ['foo bar']);

    itemsList.add(new TagItem.fromList(rds, rds));

    rds = new TagRootDataset.empty();
    rds[PTag.kRecognitionCode.code] =
        new SHtag(PTag.kRecognitionCode, ['abc']);
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
    final ob = new OBtag(PTag.kICCProfile, <int>[123, 255], 2);

    rds[lt.code] = lt;
    rds[lo.code] = lo;
    rds[ss.code] = ss;
    rds[sl.code] = sl;
    rds[ob.code] = ob;
    itemsList.add(new TagItem.fromList(rds, rds));

    //TODO: this should be adding a real parent and verifying it.
    sq = new SQtag(null, tag, itemsList, SQ.kMaxVFLength);

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
      print('sq: $sq');
      // Urgent Sharath fix: sq is a DAtag not an SQtag
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

      print('sq: $sq');
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
      log..debug(sq.items)..debug(sq.noValues);

      final rds0 =new TagRootDataset.empty();
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
      print('sq: $sq');
      final sq2 = sq.update(itemsList);
      log..debug(sq2.items)..debug(sq2.noValues);

      final sqCopy = sq.copySQ(rds);
      log..debug(sqCopy.items)..debug(sqCopy.noValues);
      expect(sq.items, equals(sqCopy.items));
    });
  });
}
