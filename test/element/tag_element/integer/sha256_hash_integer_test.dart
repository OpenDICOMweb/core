//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart' hide group;
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
      final e0 = SStag(PTag.kTagAngleSecondAxis, listInt);
      final e1 = SStag(PTag.kTagAngleSecondAxis, listInt);
      final e2 = SStag(PTag.kPixelIntensityRelationshipSign, listInt);

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
      final e0 = SLtag(PTag.kReferencePixelX0, int32V1);
      final e1 = SLtag(PTag.kReferencePixelX0, int32V1);
      final e2 = SLtag(PTag.kReferencePixelY0, int32V1);

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
      final e0 = OBtag(PTag.kPrivateInformation, uInt8V1);
      final e1 = OBtag(PTag.kPrivateInformation, uInt8V1);
      final e2 =
          OBtag(PTag.kCoordinateSystemAxisValues, uInt8V1);

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
      final e0 = UStag(PTag.kRepresentativeFrameNumber, uInt16V1);
      final e1 = UStag(PTag.kRepresentativeFrameNumber, uInt16V1);
      final e2 = UStag(PTag.kFrameNumbersOfInterest, uInt16V1);

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
      final e0 = OWtag(PTag.kRedPaletteColorLookupTableData, uInt16V1);
      final e1 = OWtag(PTag.kRedPaletteColorLookupTableData, uInt16V1);
      final e2 = OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16V1);

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
      final e0 = ULtag(PTag.kPixelComponentMask, uInt32V1);
      final e1 = ULtag(PTag.kPixelComponentMask, uInt32V1);
      final e2 = ULtag(PTag.kPixelComponentRangeStart, uInt32V1);

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
      final e0 = ATtag(PTag.kOriginalImageIdentification, uInt32V1);
      final e1 = ATtag(PTag.kOriginalImageIdentification, uInt32V1);
      final e2 = ATtag(PTag.kDimensionIndexPointer, uInt32V1);

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
      final e0 = OLtag(PTag.kLongPrimitivePointIndexList, uInt32V1);
      final e1 = OLtag(PTag.kLongPrimitivePointIndexList, uInt32V1);
      final e2 = OLtag(PTag.kLongTrianglePointIndexList, uInt32V1);

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
