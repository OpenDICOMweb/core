// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:tag/tag.dart';
import 'package:test/test.dart';

/// Tests that were handling Float32List loss of precision correctly
void main() {
  Server.initialize(name: 'element/float_type_test', level: Level.info0);

  group('Floating Point Values', () {
    test('Create Elements from floating values', () {
      const f32Values = const <double>[2047.99, 2437.437, 764.53];

      final fl0 = new FLtag(PTag.kRecommendedDisplayFrameRateInFloat,
          new Float32List.fromList(f32Values.take(1).toList()));
      expect(fl0.values.first.toStringAsPrecision(1),
          equals((2047.99).toStringAsPrecision(1)));

      final of0 = new OFtag(PTag.kUValueData, new Float32List.fromList(f32Values));
      expect(of0.values.first.toStringAsPrecision(1),
          equals((2047.99).toStringAsPrecision(1)));
      final od0 = new ODtag(PTag.kSelectorODValue, new Float64List.fromList(f32Values));
      expect(od0.values.first.toStringAsPrecision(1),
          equals((2047.99).toStringAsPrecision(1)));
    });

    //Urgent: Please add comment on goal of this test.
    test('Create Elements from strings', () {
      //Urgent: I don't understand. Why use UTF8 encoding
      //  final fString = BASE64.encode(UTF8.encode('78678'));
      final fString = Float32Base.listToBase64(<double>[1.0, 2.0, 3.0]);

      final fl0 = FLtag.fromBase64(
          PTag.lookupByCode(kRecommendedDisplayFrameRateInFloat), fString);
      log.debug('Elements from base64: ${fl0.info}');
      final of0 = OFtag.fromBase64(PTag.lookupByCode(kUValueData), fString);
      log.debug('Elements from base64: ${of0.info}');
      //Urgent: why is this using 0x00720073 instead of kSelectorODValue?
      // od0 = new ODtag.fromBase64(PTag.lookupByCode(0x00720073), fString);
      final dString = Float64Base.listToBase64(<double>[1.0, 2.0, 3.0]);
      final od0 = ODtag.fromBase64(PTag.lookupByCode(kSelectorODValue), dString);
      log.debug('Elements from base64: ${od0.info}');
    });

    //Urgent: not real test - no expect()
    test('update Elements from strings', () {
      const floatUpdateValues = const <double>[
        546543.674, 6754764.45887, 54698.52, 787354.734768 // No reformat
      ];

      final fl0 = new FLtag(PTag.kRecommendedDisplayFrameRateInFloat,
          new Float32List.fromList(floatUpdateValues.take(1).toList()))
        ..update(new Float32List.fromList(floatUpdateValues));
      log..debug(fl0.values.elementAt(0))..debug(fl0.view());

      final of0 = new OFtag(
          PTag.lookupByCode(kUValueData), new Float32List.fromList(floatUpdateValues))
        ..update(new Float32List.fromList(floatUpdateValues));
      log..debug(of0.values.elementAt(0))..debug(of0.view());

      final fdValues = floatUpdateValues.take(1).toList();
      final fd0 = new FDtag(PTag.kPhysicalDeltaX,
          new Float64List.fromList(fdValues))
        ..update(new Float64List.fromList(fdValues));
      log..debug(fd0.value)..debug(fd0.view());

      final od0 = new ODtag(
          PTag.lookupByCode(0x00720073), new Float64List.fromList(floatUpdateValues))
        ..update(new Float64List.fromList(floatUpdateValues));
      log..debug(od0.values.elementAt(0))..debug(od0.view());
    });
  });
}
