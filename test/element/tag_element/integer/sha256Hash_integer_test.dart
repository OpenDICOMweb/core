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
  Server.initialize(name: 'element/sha256Hash_integer_test', level: Level.info);
  group('Integer Elements', () {
    const int32V1 = const <int>[kInt32Max];
    const uInt8V1 = const <int>[kUint8Min];
    const uInt16V1 = const <int>[kUint16Min];
    const uInt32V1 = const <int>[kUint32Max];

    test('SS', () {
      final listInt = <int>[123];
      final e0 = new SStag(PTag.kTagAngleSecondAxis, listInt);
      final e1 = new SStag(PTag.kTagAngleSecondAxis, listInt);
      final e2 = new SStag(PTag.kPixelIntensityRelationshipSign, listInt);

      final sha0 = Sha256.int16(listInt);
      log
        ..debug('listInt: $listInt, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}');

      expect(e0.sha256, equals(e0.update(sha0)));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });

    test('SL', () {
      final e0 = new SLtag(PTag.kReferencePixelX0, int32V1);
      final e1 = new SLtag(PTag.kReferencePixelX0, int32V1);
      final e2 = new SLtag(PTag.kReferencePixelY0, int32V1);

      final sha0 = Sha256.int32(int32V1);
      log
        ..debug('int32V1: $int32V1, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}');

      expect(e0.sha256, equals(e0.update(sha0)));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });

    test('OB', () {
      final e0 = new OBtag(PTag.kPrivateInformation, uInt8V1, uInt8V1.length);
      final e1 = new OBtag(PTag.kPrivateInformation, uInt8V1, uInt8V1.length);
      final e2 =
          new OBtag(PTag.kCoordinateSystemAxisValues, uInt8V1, uInt8V1.length);

      final sha0 = Sha256.uint8(uInt8V1);
      log
        ..debug('uint8V1: $uInt8V1, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}');

      expect(e0.sha256, equals(e0.update(sha0)));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });

    test('US', () {
      final e0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16V1);
      final e1 = new UStag(PTag.kRepresentativeFrameNumber, uInt16V1);
      final e2 = new UStag(PTag.kFrameNumbersOfInterest, uInt16V1);

      final sha0 = Sha256.uint16(uInt16V1);
      log
        ..debug('uint16V1: $uInt16V1, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}');

      expect(e0.sha256, equals(e0.update(sha0)));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });

    test('OW Element', () {
      final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16V1);
      final e1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16V1);
      final e2 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16V1);

      final sha0 = Sha256.uint16(uInt16V1);
      log
        ..debug('uint16V1: $uInt16V1, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}');

      expect(e0.sha256, equals(e0.update(sha0)));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });

    test('UL Elements', () {
      final e0 = new ULtag(PTag.kPixelComponentMask, uInt32V1);
      final e1 = new ULtag(PTag.kPixelComponentMask, uInt32V1);
      final e2 = new ULtag(PTag.kPixelComponentRangeStart, uInt32V1);

      final sha0 = Sha256.uint32(uInt32V1);
      log
        ..debug('uint32V1: $uInt32V1, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}');

      expect(e0.sha256, equals(e0.update(sha0)));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });

    test('AT Elements', () {
      final e0 = new ATtag(PTag.kOriginalImageIdentification, uInt32V1);
      final e1 = new ATtag(PTag.kOriginalImageIdentification, uInt32V1);
      final e2 = new ATtag(PTag.kDimensionIndexPointer, uInt32V1);

      final sha0 = Sha256.uint32(uInt32V1);
      log
        ..debug('uint32V1: $uInt32V1, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}');

      expect(e0.sha256, equals(e0.update(sha0)));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });

    test('OL Elements', () {
      final e0 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32V1);
      final e1 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32V1);
      final e2 = new OLtag(PTag.kLongTrianglePointIndexList, uInt32V1);

      final sha0 = Sha256.uint32(uInt32V1);
      log
        ..debug('uint32V1: $uInt32V1, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}');

      expect(e0.sha256, equals(e0.update(sha0)));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });
  });
}
