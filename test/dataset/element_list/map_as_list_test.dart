// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:tag/tag.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'map_as_list_test', level: Level.debug);

  group('MapAsList', () {
    test('[] and []=', () {
      final elements = new MapAsList();
      final ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransFerSyntax = new UItag(PTag.kTransferSyntaxUID, [ts.asString]);
      log.debug('ui: $uiTransFerSyntax');
      elements[uiTransFerSyntax.index] = uiTransFerSyntax;
      log.debug('elements: $elements');
      final v = elements[uiTransFerSyntax.index];
      log.debug('elements[${uiTransFerSyntax.index}] = $v');

/* Urgent Sharath: use or flush
      final usSamplesPerPixel = new UStag(PTag.kSamplesPerPixel, [1]);
      final csPhotometricInterpretation =
          new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final usRows = new UStag(PTag.kRows, [4]);
      final usColumns = new UStag(PTag.kColumns, [6]);
      final usBitsAllocated = new UStag(PTag.kBitsAllocated, [8]);
      final usBitsStored = new UStag(PTag.kBitsStored, [8]);
      final usHighBit = new UStag(PTag.kHighBit, [7]);
      final usPixelRepresentation = new UStag(PTag.kPixelRepresentation, [0]);
      final usPlanarConfiguration = new UStag(PTag.kPlanarConfiguration, [2]);
      final isPixelAspectRatio = new IStag(PTag.kPixelAspectRatio, ['1', '2']);
      final pixelAspectRatioValue = 1 / 2;
      final usSmallestImagePixelValue =
          new UStag(PTag.kSmallestImagePixelValue, [0]);
      final usLargestImagePixelValue =
          new UStag(PTag.kLargestImagePixelValue, [255]);
      log.debug('elements: ${elements.info}');
*/
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

    test('== and hashCode', () {
      final map0 = new MapAsList();
      final map1 = new MapAsList();
      final map2 = new MapAsList();

      final cs0 = new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final cs1 = new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
// Urgent: Sharath next line has invalid value (must be uppercase). please fix
//      final cs2 = new CStag(PTag.kImageFormat, ['foo']);

      map0[cs0.code] = cs0;
      map1[cs1.code] = cs1;
//      map2[cs2.code] = cs2;

      log.debug('map0.hashCode: ${map0.hashCode}, map1.hashCode : ${map1.hashCode}'
          ', map2.hashCode : ${map2.hashCode}');

      expect(map0 == map1, true);
      expect(map0.hashCode, equals(map1.hashCode));

      expect(map0 == map2, false);
      expect(map0.hashCode, isNot(map2.hashCode));
    });

    test('others', () {
      final map0 = new MapAsList();
      final as0 = new AStag(PTag.kPatientAge, ['024Y']);

      map0[as0.code] = as0;

      expect(map0.elements, equals([as0]));
      expect(map0.elementsList, equals([as0]));
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
