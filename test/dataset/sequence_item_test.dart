// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/sequence_item_test', level: Level.info);

  group('Items and Sequences', () {
    var itemsList = <TagItem>[];
    SQtag sq;

    final tag = PTag.lookupByCode(kInstanceCreationDate);
    final rds = new TagRootDataset();
    final date = new DAtag(tag, ['19990505']);
    rds.add(date);

    var elements = new MapAsList();
    elements[kRecognitionCode] = new SHtag(PTag.kRecognitionCode, ['foo bar']);
    elements[kInstitutionAddress] =
        new STtag(PTag.kInstitutionAddress, ['foo bar']);
    elements[kExtendedCodeMeaning] =
        new LTtag(PTag.kExtendedCodeMeaning, ['foo bar']);

    itemsList.add(new TagItem.fromList(rds, elements));

    elements = new MapAsList();
    elements[PTag.kRecognitionCode.code] =
        new SHtag(PTag.kRecognitionCode, ['abc']);
    elements[PTag.kInstitutionAddress.code] =
        new STtag(PTag.kInstitutionAddress, ['abc']);
    elements[PTag.kExtendedCodeMeaning.code] =
        new LTtag(PTag.kExtendedCodeMeaning, ['abc']);
    itemsList.add(new TagItem.fromList(null, elements));

    elements = new MapAsList();
    final lt = new LTtag(PTag.kApprovalStatusFurtherDescription, ['foo bar']);
    final lo = new LOtag(PTag.kProductName, ['foo bar']);
    final ss = new SStag(PTag.kTagAngleSecondAxis, [123]);
    final sl = new SLtag(PTag.kReferencePixelX0, [13]);
    final ob = new OBtag(PTag.kICCProfile, <int>[123, 255], 2);

    elements[lt.code] = lt;
    elements[lo.code] = lo;
    elements[ss.code] = ss;
    elements[sl.code] = sl;
    elements[ob.code] = ob;
    itemsList.add(new TagItem.fromList(rds, elements));

    //TODO: this should be adding a real parent and verifying it.
    sq = new SQtag(tag, null, itemsList, SQ.kMaxVFLength);

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
      final elements = new MapAsList();
      final fl = new FLtag(PTag.kTableOfParameterValues, [12.33, 34.4, 56.25]);
      final of = new OFtag(PTag.kVectorGridData, [132.33]);
      final fd = new FDtag(PTag.kOverallTemplateSpatialTolerance);
      final od = new ODtag(PTag.kSelectorODValue, <double>[2.33]);

      elements[fl.code] = fl;
      elements[of.code] = of;
      elements[fd.code] = fd;
      elements[od.code] = od;
      itemsList = <TagItem>[]..add(new TagItem.fromList(rds, elements));

      final sq2 = sq.update(itemsList);
      log.debug(sq2.info);
      expect(sq2.getAll(kTableOfParameterValues), isNotNull);
      expect(sq2.getAll(kVectorGridData), isNotNull);
    });

    test('Test for items,novalues', () {
      log..debug(sq.items)..debug(sq.noValues);

      final elements = new MapAsList();
      final fl =
          new FLtag(PTag.kTableOfParameterValues, <double>[12.33, 34.4, 56.25]);
      final of = new OFtag(PTag.kVectorGridData, <double>[34.4]);
      final fd = new FDtag(PTag.kOverallTemplateSpatialTolerance);
      final od = new ODtag(PTag.kSelectorODValue, <double>[2.33]);

      elements[fl.code] = fl;
      elements[of.code] = of;
      elements[fd.code] = fd;
      elements[od.code] = od;
      itemsList = <TagItem>[]..add(new TagItem.fromList(rds, elements));

      final sq2 = sq.update(itemsList);
      log..debug(sq2.items)..debug(sq2.noValues);

      final sqCopy = sq.copySQ(rds);
      log..debug(sqCopy.items)..debug(sqCopy.noValues);
      expect(sq.items, equals(sqCopy.items));
    });

    test('Test for items,novalues,vfLength and vr', () {
    //  final tag = Tag.lookup(kDeidentificationMethodCodeSequence);
    //  final invalidSQ = new SQtag(tag, rds, itemsList);
    }, skip: 'Fix Ignore fornow');
  });
}
