// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.


import 'package:core/server.dart';
import 'package:tag/tag.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'element/sha256Hash_string_test', level: Level.debug);
  group('String Elements', () {

    test('String Text', () {
      final stringList0 = rsg.getSTList(1, 1);
      final st0 = new STtag(PTag.kDerivationDescription, stringList0);
      final st1 = new STtag(PTag.kDerivationDescription, stringList0);
      final st2 = new STtag(PTag.kCADFileFormat, stringList0);

      final sha0 = Sha256.stringList(stringList0);
      log
        ..debug('stringList0: $stringList0, sha0: $sha0')
        ..debug('st0.sha256Hash: ${st0.sha256}, st1.sha256Hash: ${st1.sha256}, '
            'st2.sha256Hash: ${st2.sha256}');
      expect(st0.sha256, equals(st0.update(sha0)));
      expect(st0.sha256, equals(st1.sha256));

      expect(st0.sha256, equals(st2.sha256));
      expect(st0.hash, equals(st0.sha256));

      final stringList1 = rsg.getLTList(1, 1);
      final lt0 = new LTtag(PTag.kAcquisitionProtocolDescription, stringList1);
      final lt1 = new LTtag(PTag.kAcquisitionProtocolDescription, stringList1);
      final lt2 = new LTtag(PTag.kImageComments, stringList1);

      final sha1 = Sha256.stringList(stringList1);
      log
        ..debug('stringList1: $stringList1, sha1: $sha1')
        ..debug('lt0.sha256Hash: ${lt0.sha256}, lt1.sha256Hash: ${lt1.sha256},'
            ' lt2.sha256Hash: ${lt2.sha256}');
      expect(lt0.sha256, equals(lt0.update(sha1)));
      expect(lt0.sha256, equals(lt1.sha256));
      expect(lt0.sha256, equals(lt2.sha256));
      expect(lt0.hash, equals(lt0.sha256));
    });

    test('Special String', () {
      final stringList = rsg.getAEList(1, 1);
      final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, stringList);
      final ae1 = new AEtag(PTag.kScheduledStudyLocationAETitle, stringList);
      final ae2 = new AEtag(PTag.kScheduledStationAETitle, stringList);

      final sha0 = Sha256.stringList(stringList);
      log
        ..debug('stringList: $stringList, sha0: $sha0')
        ..debug('ae0.sha256Hash: ${ae0.sha256}, ae1.sha256Hash: ${ae1.sha256}, '
            'ae2.sha256Hash: ${ae2.sha256}');
      expect(ae0.sha256, equals(ae0.update(sha0)));

      expect(ae0.sha256, equals(ae1.sha256));
      expect(ae0.sha256, equals(ae2.sha256));
      expect(ae0.hash, equals(ae0.sha256));

      final stringList0 = rsg.getCSList(1, 1, 2, 16);
      final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, stringList0);
      final cs1 = new CStag(PTag.kGeometryOfKSpaceTraversal, stringList0);
      final cs2 = new CStag(PTag.kRectilinearPhaseEncodeReordering, stringList0);

      final sha1 = Sha256.stringList(stringList0);
      log
        ..debug('stringList0: $stringList0;, sha1: $sha1')
        ..debug('cs0.sha256Hash: ${cs0.sha256}, cs1.sha256Hash: ${cs1.sha256},'
            ' cs2.sha256Hash: ${cs2.sha256}');
      expect(cs0.sha256, equals(cs0.update(sha1)));
      expect(cs0.sha256, equals(cs1.sha256));
      expect(cs0.sha256, equals(cs2.sha256));
      expect(cs0.hash, equals(cs0.sha256));

      final stringList2 = rsg.getURList(1, 1);
      final ur0 = new URtag(PTag.kRetrieveURI, stringList2);
      final ur1 = new URtag(PTag.kRetrieveURI, stringList2);
      final ur2 = new URtag(PTag.kContactURI, stringList2);

      final sha3 = Sha256.stringList(stringList2);
      log
        ..debug('stringList2: $stringList2;, sha3: $sha3')
        ..debug('ur0.sha256Hash: ${ur0.sha256}, ur1.sha256Hash: ${ur1.sha256},'
            ' ur2.sha256Hash: ${ur2.sha256}');
      expect(ur0.sha256, equals(ur0.update(sha3)));
      expect(ur0.sha256, equals(ur1.sha256));
      expect(ur0.sha256, equals(ur2.sha256));
      expect(ur0.hash, equals(ur0.sha256));
    });

    test('other Strings', () {
      final stringList1 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList1);
      final lo1 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList1);
      final lo2 = new LOtag(PTag.kDimensionIndexPrivateCreator, stringList1);

      final sha1 = Sha256.stringList(stringList1);
      log
        ..debug('stringList1: $stringList1;, sha1: $sha1')
        ..debug('lo0: $lo0')
        ..debug('lo0.sha256Hash: ${lo0.sha256}, lo1.sha256Hash: ${lo1.sha256}, '
            'lo2.sha256Hash: ${lo2.sha256}');
      expect(lo0.sha256, equals(lo0.update(sha1)));
      expect(lo0.sha256, equals(lo1.sha256));
      expect(lo0.sha256, equals(lo2.sha256));
      expect(lo0.hash, equals(lo0.sha256));

      final stringList2 = rsg.getPNList(1, 1);
      final pn0 = new PNtag(PTag.kRequestingPhysician, stringList2);
      final pn1 = new PNtag(PTag.kRequestingPhysician, stringList2);
      final pn2 = new PNtag(PTag.kOrderEnteredBy, stringList2);

      final sha2 = Sha256.stringList(stringList2);
      log
        ..debug('stringList2: $stringList2;, sha2: $sha2')
        ..debug('pn0.sha256Hash: ${pn0.sha256}, pn1.sha256Hash: ${pn1.sha256}, '
            'pn2.sha256Hash: ${pn2.sha256}');
      expect(pn0.sha256, equals(pn0.update(sha2)));
      expect(pn0.sha256, equals(pn1.sha256));
      expect(pn0.sha256, equals(pn2.sha256));
      expect(() => pn0.hash, throwsA(const isInstanceOf<UnsupportedError>()));

      final stringList3 = rsg.getSHList(1, 1);
      final sh0 = new SHtag(PTag.kMultiCoilElementName, stringList3);
      final sh1 = new SHtag(PTag.kMultiCoilElementName, stringList3);
      final sh2 = new SHtag(PTag.kMultiplexGroupLabel, stringList3);

      final sha3 = Sha256.stringList(stringList3);
      log
        ..debug('stringList3: $stringList3;, sha3: $sha3')
        ..debug('sh0.sha256Hash: ${sh0.sha256}, sh1.sha256Hash: ${sh1.sha256}'
            ',sh2.sha256Hash: ${sh2.sha256}');
      expect(sh0.sha256, equals(sh0.update(sha3)));
      expect(sh0.sha256, equals(sh1.sha256));
      expect(sh0.sha256, equals(sh2.sha256));
      expect(sh0.hash, equals(sh0.sha256));

      final stringList4 = rsg.getUCList(1, 1);
      final uc0 = new UCtag(PTag.kStrainDescription, stringList4);
      final uc1 = new UCtag(PTag.kStrainDescription, stringList4);
      final uc2 = new UCtag(PTag.kGeneticModificationsDescription, stringList4);

      final sha4 = Sha256.stringList(stringList4);
      log
        ..debug('stringList4: $stringList4;, sha4: $sha4')
        ..debug('uc0.sha256Hash: ${uc0.sha256}, uc1.sha256Hash: ${uc1.sha256}, '
            'uc2.sha256Hash: ${uc2.sha256}');
      expect(uc0.sha256, equals(uc0.update(sha4)));
      expect(uc0.sha256, equals(uc1.sha256));
      expect(uc0.sha256, equals(uc2.sha256));
      expect(uc0.hash, equals(uc0.sha256));

      final stringList5 = rsg.getUTList(1, 1);
      final ut0 = new UTtag(PTag.kUniversalEntityID, stringList5);
      final ut1 = new UTtag(PTag.kUniversalEntityID, stringList5);
      final ut2 = new UTtag(PTag.kSpecimenDetailedDescription, stringList5);

      final sha5 = Sha256.stringList(stringList5);
      log
        ..debug('stringList5: $stringList5;, sha5: $sha5')
        ..debug('ut0.sha256Hash: ${ut0.sha256}, ut0.sha256Hash: ${ut1.sha256},'
            'ut2.sha256Hash: ${ut2.sha256}');
      expect(ut0.sha256, equals(ut0.update(sha5)));
      expect(ut0.sha256, equals(ut1.sha256));
      expect(ut0.sha256, equals(ut2.sha256));
      expect(ut0.hash, equals(ut0.sha256));
    });
  });
}
