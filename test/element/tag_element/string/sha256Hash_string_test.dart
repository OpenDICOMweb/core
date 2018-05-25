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
  Server.initialize(name: 'element/sha256Hash_string_test', level: Level.info);
  group('String Elements', () {
    test('String Text', () {
      final vList0 = rsg.getSTList(1, 1);
      final e0 = new STtag(PTag.kDerivationDescription, vList0);
      final e1 = new STtag(PTag.kDerivationDescription, vList0);
      final e2 = new STtag(PTag.kCADFileFormat, vList0);

      final sha0 = Sha256.stringList(vList0);
      log
        ..debug('vList0: $vList0, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}, e1.sha256Hash: ${e1.sha256}, '
            'e2.sha256Hash: ${e2.sha256}');
      expect(e0.sha256, equals(e0.update(sha0)));
      expect(e0.sha256, equals(e1.sha256));

      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));

      final vList1 = rsg.getLTList(1, 1);
      final e3 = new LTtag(PTag.kAcquisitionProtocolDescription, vList1);
      final e4 = new LTtag(PTag.kAcquisitionProtocolDescription, vList1);
      final e5 = new LTtag(PTag.kImageComments, vList1);

      final sha1 = Sha256.stringList(vList1);
      log
        ..debug('vList1: $vList1, sha1: $sha1')
        ..debug('e3.sha256Hash: ${e3.sha256}, e4.sha256Hash: ${e4.sha256},'
            ' e5.sha256Hash: ${e5.sha256}');
      expect(e3.sha256, equals(e3.update(sha1)));
      expect(e3.sha256, equals(e4.sha256));
      expect(e3.sha256, equals(e5.sha256));
      expect(e3.hash, equals(e3.sha256));
    });

    test('Special String', () {
      final vList0 = rsg.getAEList(1, 1);
      final e0 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
      final e1 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
      final e2 = new AEtag(PTag.kScheduledStationAETitle, vList0);

      final sha0 = Sha256.stringList(vList0);
      log
        ..debug('vList0: $vList0, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}, e1.sha256Hash: ${e1.sha256}, '
            'e2.sha256Hash: ${e2.sha256}');
      expect(e0.sha256, equals(e0.update(sha0)));

      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));

      final vList1 = rsg.getCSList(1, 1, 2, 16);
      final e3 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList1);
      final e4 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList1);
      final e5 = new CStag(PTag.kRectilinearPhaseEncodeReordering, vList1);

      final sha1 = Sha256.stringList(vList1);
      log
        ..debug('vList1: $vList1;, sha1: $sha1')
        ..debug('e3.sha256Hash: ${e3.sha256}, e4.sha256Hash: ${e4.sha256},'
            ' e5.sha256Hash: ${e5.sha256}');
      expect(e3.sha256, equals(e3.update(sha1)));
      expect(e3.sha256, equals(e4.sha256));
      expect(e3.sha256, equals(e5.sha256));
      expect(e3.hash, equals(e3.sha256));

      final vList2 = rsg.getURList(1, 1);
      final e6 = new URtag(PTag.kRetrieveURI, vList2);
      final e7 = new URtag(PTag.kRetrieveURI, vList2);
      final e8 = new URtag(PTag.kContactURI, vList2);

      final sha3 = Sha256.stringList(vList2);
      log
        ..debug('vList2: $vList2;, sha3: $sha3')
        ..debug('e6.sha256Hash: ${e6.sha256}, e7.sha256Hash: ${e7.sha256},'
            ' e8.sha256Hash: ${e8.sha256}');
      expect(e6.sha256, equals(e6.update(sha3)));
      expect(e6.sha256, equals(e7.sha256));
      expect(e6.sha256, equals(e8.sha256));
      expect(e6.hash, equals(e6.sha256));
    });

    test('other Strings', () {
      final vList0 = rsg.getLOList(1, 1);
      final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
      final e1 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
      final e2 = new LOtag(PTag.kDimensionIndexPrivateCreator, vList0);

      final sha1 = Sha256.stringList(vList0);
      log
        ..debug('vList0: $vList0;, sha1: $sha1')
        ..debug('e0: $e0')
        ..debug('e0.sha256Hash: ${e0.sha256}, e1.sha256Hash: ${e1.sha256}, '
            'e2.sha256Hash: ${e2.sha256}');
      expect(e0.sha256, equals(e0.update(sha1)));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));

      final vList1 = rsg.getPNList(1, 1);
      final e3 = new PNtag(PTag.kRequestingPhysician, vList1);
      final e4 = new PNtag(PTag.kRequestingPhysician, vList1);
      final e5 = new PNtag(PTag.kOrderEnteredBy, vList1);

      final sha2 = Sha256.stringList(vList1);
      log
        ..debug('vList1: $vList1;, sha2: $sha2')
        ..debug('e3.sha256Hash: ${e3.sha256}, e4.sha256Hash: ${e4.sha256}, '
            'e5.sha256Hash: ${e5.sha256}');
      expect(e3.sha256, equals(e3.update(sha2)));
      expect(e3.sha256, equals(e4.sha256));
      expect(e3.sha256, equals(e5.sha256));
      expect(() => e3.hash, throwsA(const isInstanceOf<UnsupportedError>()));

      final vList2 = rsg.getSHList(1, 1);
      final e6 = new SHtag(PTag.kMultiCoilElementName, vList2);
      final e7 = new SHtag(PTag.kMultiCoilElementName, vList2);
      final e8 = new SHtag(PTag.kMultiplexGroupLabel, vList2);

      final sha3 = Sha256.stringList(vList2);
      log
        ..debug('vList2: $vList2;, sha3: $sha3')
        ..debug('e6.sha256Hash: ${e6.sha256}, e7.sha256Hash: ${e7.sha256}'
            ',e8.sha256Hash: ${e8.sha256}');
      expect(e6.sha256, equals(e6.update(sha3)));
      expect(e6.sha256, equals(e7.sha256));
      expect(e6.sha256, equals(e8.sha256));
      expect(e6.hash, equals(e6.sha256));

      final vList3 = rsg.getUCList(1, 1);
      final e9 = new UCtag(PTag.kStrainDescription, vList3);
      final e10 = new UCtag(PTag.kStrainDescription, vList3);
      final e11 = new UCtag(PTag.kGeneticModificationsDescription, vList3);

      final sha4 = Sha256.stringList(vList3);
      log
        ..debug('vList3: $vList3;, sha4: $sha4')
        ..debug('e9.sha256Hash: ${e9.sha256}, e10.sha256Hash: ${e10.sha256}, '
            'e11.sha256Hash: ${e11.sha256}');
      expect(e9.sha256, equals(e9.update(sha4)));
      expect(e9.sha256, equals(e10.sha256));
      expect(e9.sha256, equals(e11.sha256));
      expect(e9.hash, equals(e9.sha256));

      final vList4 = rsg.getUTList(1, 1);
      final e12 = new UTtag(PTag.kUniversalEntityID, vList4);
      final e13 = new UTtag(PTag.kUniversalEntityID, vList4);
      final e14 = new UTtag(PTag.kSpecimenDetailedDescription, vList4);

      final sha5 = Sha256.stringList(vList4);
      log
        ..debug('vList4: $vList4;, sha5: $sha5')
        ..debug('e12.sha256Hash: ${e12.sha256}, e13.sha256Hash: ${e13.sha256},'
            'e14.sha256Hash: ${e14.sha256}');
      expect(e12.sha256, equals(e12.update(sha5)));
      expect(e12.sha256, equals(e13.sha256));
      expect(e12.sha256, equals(e14.sha256));
      expect(e12.hash, equals(e12.sha256));
    });
  });
}
