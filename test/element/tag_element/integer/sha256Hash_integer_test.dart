// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:tag/tag.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/sha256Hash_integer_test', level: Level.info0);
  group('Integer Elements', () {
    const int32V1 = const <int>[kInt32Max];
    const uInt8V1 = const <int>[kUint8Min];
    const uInt16V1 = const <int>[kUint16Min];
    const uInt32V1 = const <int>[kUint32Max];
    test('SS', () {
      final listInt = <int>[123];
      final ss0 = new SStag(PTag.kTagAngleSecondAxis, listInt);
      final ss1 = new SStag(PTag.kTagAngleSecondAxis, listInt);
      final ss2 = new SStag(PTag.kPixelIntensityRelationshipSign, listInt);

      final sha0 = Sha256.int16(listInt);
      log
        ..debug('listInt: $listInt, sha0: $sha0')
        ..debug('ss0.sha256Hash: ${ss0.sha256}');

      expect(ss0.sha256, equals(ss0.update(sha0)));
      expect(ss0.sha256, equals(ss1.sha256));
      expect(ss0.sha256, equals(ss2.sha256));
      expect(ss0.hash, equals(ss0.sha256));
    });

    test('SL', (){
      final sl0 = new SLtag(PTag.kReferencePixelX0, int32V1);
      final sl1 = new SLtag(PTag.kReferencePixelX0, int32V1);
      final sl2 = new SLtag(PTag.kReferencePixelY0, int32V1);

      final sha0 = Sha256.int32(int32V1);
      log
        ..debug('int32V1: $int32V1, sha0: $sha0')
        ..debug('ss0.sha256Hash: ${sl0.sha256}');

      expect(sl0.sha256, equals(sl0.update(sha0)));
      expect(sl0.sha256, equals(sl1.sha256));
      expect(sl0.sha256, equals(sl2.sha256));
      expect(sl0.hash, equals(sl0.sha256));

    });

    test('OB', (){
      final ob0 = new OBtag(PTag.kPrivateInformation, uInt8V1, uInt8V1.length);
      final ob1 = new OBtag(PTag.kPrivateInformation, uInt8V1, uInt8V1.length);
      final ob2 = new OBtag(PTag.kCoordinateSystemAxisValues, uInt8V1, uInt8V1.length);

      final sha0 = Sha256.uint8(uInt8V1);
      log
        ..debug('uInt8V1: $uInt8V1, sha0: $sha0')
        ..debug('ss0.sha256Hash: ${ob0.sha256}');

      expect(ob0.sha256, equals(ob0.update(sha0)));
      expect(ob0.sha256, equals(ob1.sha256));
      expect(ob0.sha256, equals(ob2.sha256));
      expect(ob0.hash, equals(ob0.sha256));

    });

    test('US', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16V1);
      final us1 = new UStag(PTag.kRepresentativeFrameNumber, uInt16V1);
      final us2 = new UStag(PTag.kFrameNumbersOfInterest, uInt16V1);

      final sha0 = Sha256.uint16(uInt16V1);
      log
        ..debug('uInt16V1: $uInt16V1, sha0: $sha0')
        ..debug('ss0.sha256Hash: ${us0.sha256}');

      expect(us0.sha256, equals(us0.update(sha0)));
      expect(us0.sha256, equals(us1.sha256));
      expect(us0.sha256, equals(us2.sha256));
      expect(us0.hash, equals(us0.sha256));
    });

    test('OW Element', () {
      final ow0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16V1);
      final ow1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16V1);
      final ow2 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16V1);

      final sha0 = Sha256.uint16(uInt16V1);
      log
        ..debug('uInt16V1: $uInt16V1, sha0: $sha0')
        ..debug('ss0.sha256Hash: ${ow0.sha256}');

      expect(ow0.sha256, equals(ow0.update(sha0)));
      expect(ow0.sha256, equals(ow1.sha256));
      expect(ow0.sha256, equals(ow2.sha256));
      expect(ow0.hash, equals(ow0.sha256));

    });

    test('UL Elements', () {
      final ul0 = new ULtag(PTag.kPixelComponentMask, uInt32V1);
      final ul1 = new ULtag(PTag.kPixelComponentMask, uInt32V1);
      final ul2 = new ULtag(PTag.kPixelComponentRangeStart, uInt32V1);

      final sha0 = Sha256.uint32(uInt32V1);
      log
        ..debug('uInt32V1: $uInt32V1, sha0: $sha0')
        ..debug('ss0.sha256Hash: ${ul0.sha256}');

      expect(ul0.sha256, equals(ul0.update(sha0)));
      expect(ul0.sha256, equals(ul1.sha256));
      expect(ul0.sha256, equals(ul2.sha256));
      expect(ul0.hash, equals(ul0.sha256));
    });

    test('AT Elements', () {
      final at0 = new ATtag(PTag.kOriginalImageIdentification, uInt32V1);
      final at1 = new ATtag(PTag.kOriginalImageIdentification, uInt32V1);
      final at2 = new ATtag(PTag.kDimensionIndexPointer, uInt32V1);

      final sha0 = Sha256.uint32(uInt32V1);
      log
        ..debug('uInt32V1: $uInt32V1, sha0: $sha0')
        ..debug('ss0.sha256Hash: ${at0.sha256}');

      expect(at0.sha256, equals(at0.update(sha0)));
      expect(at0.sha256, equals(at1.sha256));
      expect(at0.sha256, equals(at2.sha256));
      expect(at0.hash, equals(at0.sha256));
    });

    test('OL Elements', () {
      final ol0 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32V1);
      final ol1 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32V1);
      final ol2 = new OLtag(PTag.kLongTrianglePointIndexList, uInt32V1);

      final sha0 = Sha256.uint32(uInt32V1);
      log
        ..debug('uInt32V1: $uInt32V1, sha0: $sha0')
        ..debug('ss0.sha256Hash: ${ol0.sha256}');

      expect(ol0.sha256, equals(ol0.update(sha0)));
      expect(ol0.sha256, equals(ol1.sha256));
      expect(ol0.sha256, equals(ol2.sha256));
      expect(ol0.hash, equals(ol0.sha256));
    });
  });
}
