// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';

import 'package:core/server.dart';
import 'package:tag/tag.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'string/number_test', level: Level.info);
  system.throwOnError = false;

  group('DS Tests', () {
    const goodDSList = const <List<String>>[
      const <String>['0.7591109678'],
      const <String>['-6.1e-1'],
      const <String>['560'],
      const <String>[' -6.60'],
      const <String>['+1.5e-1'],
    ];
    const badDSList = const <List<String>>[
      const <String>['\b'], //	Backspace
      const <String>['\t '], //horizontal tab (HT)
      const <String>['\n'], //linefeed (LF)
      const <String>['\f '], // form feed (FF)
      const <String>['\r '], //carriage return (CR)
      const <String>['\v'], //vertical tab
      const <String>[r'\'],
      const <String>['B\\S'],
      const <String>['1\\9'],
      const <String>['a\\4'],
      const <String>[r'^`~\\?'],
      const <String>[r'^\?'],
      const <String>['abc']
    ];
    test('DS hasValidValues Element', () {
      //hasValidValues: good values
      for (var s in goodDSList) {
        system.throwOnError = false;
        final ds0 = new DStag(PTag.kProcedureStepProgress, s);
        expect(ds0.hasValidValues, true);
      }

      //hasValidValues: bad values
      for (var s in badDSList) {
        system.throwOnError = false;
        final ds0 = new DStag(PTag.kProcedureStepProgress, s);
        expect(ds0, isNull);

        system.throwOnError = true;
        expect(() => new DStag(PTag.kProcedureStepProgress, s),
            throwsA(const isInstanceOf<InvalidStringError>()));
      }
    });

    test('DS hasValidValues random', () {
      //hasValidValues: good values
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final ds0 = new DStag(PTag.kPresentationPixelSpacing, vList0);
        log.debug('ds0:${ds0.info}');
        expect(ds0.hasValidValues, true);

        log..debug('ds0: $ds0, values: ${ds0.values}')..debug('ds0: ${ds0.info}');
        expect(ds0[0], equals(vList0[0]));
      }
    });

    test('DS hasValidValues: good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final ds0 = new DStag(PTag.kProcedureStepProgress, vList0);
        expect(ds0.hasValidValues, true);

        log..debug('ds0: $ds0, values: ${ds0.values}')..debug('ds0: ${ds0.info}');
        expect(ds0[0], equals(vList0[0]));
      }
    });

    test('DS hasValidValues: bad values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final vList0 = rsg.getDSList(3, 4);
        log.debug('$i: vList0: $vList0');
        final ds0 = new DStag(PTag.kProcedureStepProgress, vList0);
        expect(ds0, isNull);
      }
    });

    test('DS update random', () {
      //update
      system.throwOnError = false;
      final ds0 = new DStag(PTag.kCompensatorTransmissionData, []);
      expect(ds0.update(['325435.7878-', '4545.887+']), isNull);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 4);
        final ds1 = new DStag(PTag.kCompensatorTransmissionData, vList0);
        final vList1 = rsg.getDSList(3, 4);
        expect(ds1.update(vList1).values, equals(vList1));
      }
    });

    test('DS noValues random', () {
      //noValues
      final ds0 = new DStag(PTag.kProcedureStepProgress, []);
      final DStag dsNoValues = ds0.noValues;
      expect(dsNoValues.values.isEmpty, true);
      log.debug('ds0: ${ds0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 4);
        final ds0 = new DStag(PTag.kCompensatorTransmissionData, vList0);
        log.debug('ds0: $ds0');
        expect(dsNoValues.values.isEmpty, true);
        log.debug('ds0: ${ds0.noValues}');
      }
    });

    test('DS copy random', () {
      //copy
      final ds0 = new DStag(PTag.kProcedureStepProgress, []);
      final DStag ds1 = ds0.copy;
      expect(ds1 == ds0, true);
      expect(ds1.hashCode == ds0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 4);
        final ds2 = new DStag(PTag.kCompensatorTransmissionData, vList0);
        final DStag ds3 = ds2.copy;
        expect(ds3 == ds2, true);
        expect(ds3.hashCode == ds2.hashCode, true);
      }
    });

    test('DS []', () {
      // empty list and null as values
      final ds0 = new DStag(PTag.kProcedureStepProgress, []);
      expect(ds0.hasValidValues, true);
      expect(ds0.values, equals(<String>[]));

      final ds1 = new DStag(PTag.kProcedureStepProgress, null);
      log.debug('ds1: $ds1');
      expect(ds1, isNull);
    });

    test('DS hashCode and ==', () {
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;
      List<String> stringList4;
      List<String> stringList5;
      List<String> stringList6;

      log.debug('DS hashCode and ==');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDSList(1, 1);
        final ds0 = new DStag(PTag.kProcedureStepProgress, stringList0);
        final ds1 = new DStag(PTag.kProcedureStepProgress, stringList0);
        log
          ..debug('stringList0:$stringList0, ds0.hash_code:${ds0.hashCode}')
          ..debug('stringList0:$stringList0, ds1.hash_code:${ds1.hashCode}');
        expect(ds0.hashCode == ds1.hashCode, true);
        expect(ds0 == ds1, true);

        stringList1 = rsg.getDSList(1, 1);
        final ds2 = new DStag(PTag.kCineRelativeToRealTime, stringList1);
        log.debug('stringList1:$stringList1 , ds2.hash_code:${ds2.hashCode}');
        expect(ds0.hashCode == ds2.hashCode, false);
        expect(ds0 == ds2, false);

        stringList2 = rsg.getDSList(2, 2);
        final ds3 = new DStag(PTag.kImagePlanePixelSpacing, stringList2);
        log.debug('stringList2:$stringList2 , ds3.hash_code:${ds3.hashCode}');
        expect(ds0.hashCode == ds3.hashCode, false);
        expect(ds0 == ds3, false);

        stringList3 = rsg.getDSList(3, 3);
        final ds4 = new DStag(PTag.kNormalizationPoint, stringList3);
        log.debug('stringList3:$stringList3 , ds4.hash_code:${ds4.hashCode}');
        expect(ds0.hashCode == ds4.hashCode, false);
        expect(ds0 == ds4, false);

        stringList4 = rsg.getDSList(4, 4);
        final ds5 = new DStag(PTag.kDoubleExposureFieldDeltaTrial, stringList4);
        log.debug('stringList4:$stringList4 , ds5.hash_code:${ds5.hashCode}');
        expect(ds0.hashCode == ds5.hashCode, false);
        expect(ds0 == ds5, false);

        stringList5 = rsg.getDSList(6, 6);
        final ds6 = new DStag(PTag.kRTImageOrientation, stringList5);
        log.debug('stringList5:$stringList5 , ds6.hash_code:${ds6.hashCode}');
        expect(ds1.hashCode == ds6.hashCode, false);
        expect(ds1 == ds6, false);

        stringList6 = rsg.getDSList(2, 3);
        final ds7 = new DStag(PTag.kProcedureStepProgress, stringList6);
        log.debug('stringList6:$stringList6 , ds7.hash_code:${ds7.hashCode}');
        expect(ds1.hashCode == ds7.hashCode, false);
        expect(ds1 == ds7, false);
      }
    });

    test('DS valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final ds0 = new DStag(PTag.kPresentationPixelSpacing, vList0);
        expect(vList0, equals(ds0.valuesCopy));
      }
    });

    test('DS isValidLength random', () {
      //isValidLength
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final ds0 = new DStag(PTag.kPresentationPixelSpacing, vList0);
        expect(ds0.tag.isValidValuesLength(ds0.values), true);
      }
    });

    test('DS isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final ds0 = new DStag(PTag.kPresentationPixelSpacing, vList0);
// Urgent Jim to Fix
//        expect(ds0.tag.isValidValues(ds0.values), true);
        expect(ds0.hasValidValues, true);
      }
    });

    test('DS replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final ds0 = new DStag(PTag.kSamplingFrequency, vList0);
        final vList1 = rsg.getDSList(1, 1);
        expect(ds0.replace(vList1), equals(vList0));
        expect(ds0.values, equals(vList1));
      }

      final vList1 = rsg.getDSList(1, 1);
      final ds1 = new IStag(PTag.kWaveformChannelNumber, vList1);
      expect(ds1, isNull);
    });

    test('DS blank random', () {
      //test on blank()
      final vList1 = rsg.getDSList(2, 2);
      final ds2 = new DStag(PTag.kPresentationPixelSpacing, vList1);
      expect(ds2.blank, throwsA(const isInstanceOf<UnsupportedError>()));
    });

    test('DS formBytes', () {
      //fromBytes
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDSList(1, 1);
        final bytes = DS.toBytes(vList1);
        log.info0('bytes:$bytes');
        final ds1 = new DStag.fromBytes(PTag.kSamplingFrequency, bytes);
        log.info0('ds1: ${ds1.info}');
        expect(ds1.hasValidValues, true);
      }
    });

    test('DS checkLength', () {
      final vList0 = rsg.getDSList(1, 1);
      final ds0 = new DStag(PTag.kSamplingFrequency, vList0);
      for (var s in goodDSList) {
        expect(ds0.checkLength(s), true);
      }
      final ds1 = new DStag(PTag.kSamplingFrequency, vList0);
      expect(ds1.checkLength([]), true);

      final vList1 = ['+8', '-6.1e-1'];
      final ds2 = new DStag(PTag.kPatientSize, vList0);
      expect(ds2.checkLength(vList1), false);
    });

    test('DS checkValue', () {
      final vList0 = rsg.getDSList(1, 1);
      final ds0 = new DStag(PTag.kPatientSize, vList0);
      for (var s in goodDSList) {
        for (var a in s) {
          expect(ds0.checkValue(a), true);
        }
      }

      for (var s in badDSList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(ds0.checkValue(a), false);
        }
      }
    });

    group('DS Element', () {
      const dsTags = const <PTag>[
        PTag.kPatientSize,
        PTag.kPatientWeight,
        PTag.kMaterialThickness,
        PTag.kMaterialIsolationDiameter,
        PTag.kOuterDiameter,
        PTag.kInnerDiameter,
        PTag.kImagerPixelSpacing,
        PTag.kNominalScannedPixelSpacing,
        PTag.kImagePosition,
        PTag.kDoubleExposureFieldDeltaTrial,
        PTag.kDiaphragmPosition,
        PTag.kPRCSToRCSOrientation,
        PTag.kLossyImageCompressionRatio,
        PTag.kReferencedTimeOffsets,
        PTag.kGridFrameOffsetVector,
        PTag.kDVHData,
      ];

      const otherTags = const <PTag>[
        PTag.kColumnAngulationPatient,
        PTag.kAcquisitionProtocolDescription,
        PTag.kCTDIvol,
        PTag.kCTPositionSequence,
        PTag.kAcquisitionType,
        PTag.kPerformedStationAETitle,
        PTag.kSelectorSTValue,
        PTag.kDate,
        PTag.kTime
      ];

      test('Create DS.checkVR', () {
        system.throwOnError = false;
        expect(DS.checkVRIndex(kDSIndex), kDSIndex);
        expect(
            DS.checkVRIndex(kAEIndex), isNull);
        system.throwOnError = true;
        expect(() => DS.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in dsTags) {
          system.throwOnError = false;
          expect(DS.checkVRIndex(tag.vrIndex), tag.vrIndex);
        }

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(DS.checkVRIndex(tag.vrIndex), isNull);

          system.throwOnError = true;
          expect(() => DS.checkVRIndex(kAEIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('Create DS.isValidVRIndex', () {
        system.throwOnError = false;
        expect(DS.isValidVRIndex(kDSIndex), true);
        expect(DS.isValidVRIndex(kSSIndex), false);

        system.throwOnError = true;
        expect(() => DS.isValidVRIndex(kSSIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in dsTags) {
          system.throwOnError = false;
          expect(DS.isValidVRIndex(tag.vrIndex), true);
        }

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(DS.isValidVRIndex(tag.vrIndex), false);

          system.throwOnError = true;
          expect(() => DS.isValidVRIndex(tag.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('Create DS.isValidVRCode', () {
        system.throwOnError = false;
        expect(DS.isValidVRCode(kDSCode), true);
        expect(DS.isValidVRCode(kAECode), false);

        system.throwOnError = true;
        expect(() => DS.isValidVRCode(kAECode),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in dsTags) {
          expect(DS.isValidVRCode(tag.vrCode), true);
        }

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(DS.isValidVRCode(tag.vrCode), false);

          system.throwOnError = true;
          expect(() => DS.isValidVRCode(tag.vrCode),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('Create DS.isValidVFLength', () {
        expect(DS.isValidVFLength(DS.kMaxVFLength), true);
        expect(DS.isValidVFLength(DS.kMaxVFLength + 1), false);

        expect(DS.isValidVFLength(0), true);
        expect(DS.isValidVFLength(-1), false);
      });

      test('Create DS.isNotValidVFLength', () {
        expect(DS.isNotValidVFLength(DS.kMaxVFLength), false);
        expect(DS.isNotValidVFLength(DS.kMaxVFLength + 1), true);

        expect(DS.isNotValidVFLength(0), false);
        expect(DS.isNotValidVFLength(-1), true);
      });

      test('Create DS.isValidValueLength', () {
        for (var s in goodDSList) {
          for (var a in s) {
            expect(DS.isValidValueLength(a), true);
          }
        }
      });

      test('Create DS.isNotValidValueLength', () {
        for (var s in goodDSList) {
          for (var a in s) {
            expect(DS.isNotValidValueLength(a), false);
          }
        }
      });

/* Urgent Fix
      test('Create DS.isValidLength', () {
        system.throwOnError = false;
        expect(DS.isValidLength(DS.kMaxLength), true);
        expect(DS.isValidLength(DS.kMaxLength + 1), false);

        expect(DS.isValidLength(0), true);
        expect(DS.isValidLength(-1), false);
      });
*/

      test('Create DS.isValidValue', () {
        for (var s in goodDSList) {
          for (var a in s) {
            expect(DS.isValidValue(a), true);
          }
        }

        for (var s in badDSList) {
          for (var a in s) {
            system.throwOnError = false;
            expect(DS.isValidValue(a), false);
          }
        }
      });

      test('Create DS.isValidValues', () {
        system.throwOnError = false;
        for (var s in goodDSList) {
          expect(DS.isValidValues(PTag.kSelectorDSValue, s), true);
        }
        for (var s in badDSList) {
          system.throwOnError = false;
          expect(DS.isValidValues(PTag.kSelectorDSValue, s), false);

          system.throwOnError = true;
          expect(() => DS.isValidValues(PTag.kSelectorDSValue, s),
              throwsA(const isInstanceOf<InvalidStringError>()));
        }
      });

      test('Create DS.fromBytes', () {
        system.level = Level.debug;
        final vList1 = rsg.getCSList(1, 1);
        final bytes = DS.toBytes(vList1);
        log.debug('DS.fromBytes(bytes): ${DS.fromBytes(bytes)}, bytes: $bytes');
        expect(DS.fromBytes(bytes), equals(vList1));
      });

      test('Create DS.toBytes', () {
        final vList1 = rsg.getDSList(1, 1);
        log.debug('DS.toBytes(vList1): ${DS.toBytes(vList1)}');
        final val = ASCII.encode('s6V&:;s%?Q1g5v');
        expect(DS.toBytes(['s6V&:;s%?Q1g5v']), equals(val));

        if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
        log.debug('vList1:"$vList1"');
        final values = ASCII.encode(vList1[0]);
        expect(DS.toBytes(vList1), equals(values));
      });

      test('Create DS.fromBase64', () {
        system.throwOnError = false;
        final vList1 = rsg.getDSList(1, 1);

        final v0 = DS.fromBase64(vList1);
        expect(v0, isNotNull);

        final v1 = DS.fromBase64(['-6.1e-1']);
        expect(v1, isNotNull);

        final v2 = DS.fromBase64(['567']);
        expect(v2, isNotNull);
      });

      test('Create DS.toBase64', () {
        //final s = BASE64.encode(testFrame);
        final vList0 = rsg.getDSList(1, 1);
        expect(DS.toBase64(vList0), equals(vList0));

        final vList1 = ['-6.1e-1'];
        //final s0 = ASCII.encode(vList0[0]);
        expect(DS.toBase64(vList1), equals(vList1));
      });

      test('create DS.tryParse', () {
        system.throwOnError = false;
        final vList0 = rsg.getDSList(1, 1);
        expect(DS.tryParse(vList0[0]), double.parse(vList0[0]));

        final vList1 = '123';
        expect(DS.tryParse(vList1), double.parse(vList1));

        final vList2 = '12.34';
        expect(DS.tryParse(vList2), double.parse(vList2));

        final vList3 = 'abc';
        expect(DS.tryParse(vList3), isNull);

        system.throwOnError = true;
        expect(
            () => DS.tryParse(vList3), throwsA(const isInstanceOf<InvalidStringError>()));
      });

      test('create DS.tryParseList', () {
        system.throwOnError = false;
        final vList0 = rsg.getDSList(1, 1);
        final parse0 = double.parse(vList0[0]);
        expect(DS.tryParseList(vList0), <double>[parse0]);

        final vList1 = ['123'];
        final parse1 = double.parse(vList1[0]);
        expect(DS.tryParseList(vList1), <double>[parse1]);

        final vList2 = ['12.34'];
        final parse2 = double.parse(vList2[0]);
        expect(DS.tryParseList(vList2), <double>[parse2]);

        final vList3 = ['abc'];
        expect(DS.tryParseList(vList3), isNull);

        system.throwOnError = true;
        expect(() => DS.tryParseList(vList3),
            throwsA(const isInstanceOf<InvalidStringError>()));
      });

      test('Create DS.checkList', () {
        system.throwOnError = false;
        for (var i = 0; i <= 10; i++) {
          final vList = rsg.getDSList(1, 1);
          expect(DS.checkList(PTag.kSelectorDSValue, vList), vList);
        }

        final vList0 = ['-6.1e-1'];
        expect(DS.checkList(PTag.kSelectorDSValue, vList0), vList0);

        final vList1 = ['\b'];
        expect(DS.checkList(PTag.kSelectorDSValue, vList1), isNull);

        system.throwOnError = true;
        expect(() => DS.checkList(PTag.kSelectorDSValue, vList1),
            throwsA(const isInstanceOf<InvalidStringError>()));

        for (var s in goodDSList) {
          system.throwOnError = false;
          expect(DS.checkList(PTag.kSelectorDSValue, s), s);
        }
        for (var s in badDSList) {
          system.throwOnError = false;
          expect(DS.checkList(PTag.kSelectorDSValue, s), isNull);

          system.throwOnError = true;
          expect(() => DS.checkList(PTag.kSelectorDSValue, s),
              throwsA(const isInstanceOf<InvalidStringError>()));
        }
      });
    });
  });

  group('IS Tests', () {
    const goodISList = const <List<String>>[
      const <String>['+8'],
      const <String>['-6'],
      const <String>['560'],
      const <String>['0'],
      const <String>['-67'],
    ];
    const badISList = const <List<String>>[
      const <String>['\b'], //	Backspace
      const <String>['\t '], //horizontal tab (HT)
      const <String>['\n'], //linefeed (LF)
      const <String>['\f '], // form feed (FF)
      const <String>['\r '], //carriage return (CR)
      const <String>['\v'], //vertical tab
      const <String>[r'\'],
      const <String>['B\\S'],
      const <String>['1\\9'],
      const <String>['a\\4'],
      const <String>[r'^`~\\?'],
      const <String>[r'^\?'],
      const <String>['abc'],
      const <String>['23.34']
    ];
    test('IS hasValidValues Element', () {
      //hasValidValues: good values
      for (var s in goodISList) {
        system.throwOnError = false;
        final is0 = new IStag(PTag.kSeriesNumber, s);
        expect(is0.hasValidValues, true);
      }

      //hasValidValues: bad values
      for (var s in badISList) {
        system.throwOnError = false;
        final is0 = new IStag(PTag.kSeriesNumber, s);
        expect(is0, isNull);

        system.throwOnError = true;
        expect(() => new IStag(PTag.kSeriesNumber, s),
            throwsA(const isInstanceOf<InvalidStringError>()));
      }
    });
    test('IS hasValidValues random', () {
      //hasValidValues: good values
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final is0 = new IStag(PTag.kSeriesNumber, vList0);
        log.debug('is0:${is0.info}');
        expect(is0.hasValidValues, true);

        log..debug('is0: $is0, values: ${is0.values}')..debug('is0: ${is0.info}');
        expect(is0[0], equals(vList0[0]));
      }

      //hasValidValues: good values
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final is0 = new IStag(PTag.kAcquisitionNumber, vList0);
        expect(is0.hasValidValues, true);

        log..debug('is0: $is0, values: ${is0.values}')..debug('is0: ${is0.info}');
        expect(is0[0], equals(vList0[0]));
      }

      //hasValidValues: bad values
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(3, 4);
        log.debug('$i: vList0: $vList0');
        final is0 = new DStag(PTag.kSeriesNumber, vList0);
        expect(is0, isNull);
      }
    });

    test('IS update random', () {
      //update
      final is0 = new IStag(PTag.kOtherStudyNumbers, []);
      expect(is0.update(['+3, -3, -1']), isNull);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(3, 4);
        final is1 = new IStag(PTag.kOtherStudyNumbers, vList0);
        final vList1 = rsg.getISList(3, 4);
        expect(is1.update(vList1).values, equals(vList1));
      }
    });

    test('IS noValues random', () {
      //noValues
      final is0 = new IStag(PTag.kOtherStudyNumbers, []);
      final IStag isNoValues = is0.noValues;
      expect(isNoValues.values.isEmpty, true);
      log.debug('is0: ${is0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(3, 4);
        final ds0 = new IStag(PTag.kOtherStudyNumbers, vList0);
        log.debug('ds0: $ds0');
        expect(isNoValues.values.isEmpty, true);
        log.debug('ds0: ${ds0.noValues}');
      }
    });

    test('IS copy random', () {
      //copy
      final is0 = new IStag(PTag.kOtherStudyNumbers, []);
      final IStag is1 = is0.copy;
      expect(is1 == is0, true);
      expect(is1.hashCode == is0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(3, 4);
        final is2 = new IStag(PTag.kOtherStudyNumbers, vList0);
        final IStag is3 = is2.copy;
        expect(is3 == is2, true);
        expect(is3.hashCode == is2.hashCode, true);
      }
    });

    test('IS []', () {
      // empty list and null as values
      final is0 = new IStag(PTag.kOtherStudyNumbers, []);
      expect(is0.hasValidValues, true);
      expect(is0.values, equals(<String>[]));

      final is1 = new IStag(PTag.kOtherStudyNumbers, null);
      log.debug('is1: $is1');
      expect(is1, isNull);
    });

    test('IS hashCode and ==', () {
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;
      List<String> stringList4;
      List<String> stringList5;

      log.debug('IS hashCode and ==');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getISList(1, 1);
        final is0 = new IStag(PTag.kMemoryAllocation, stringList0);
        final is1 = new IStag(PTag.kMemoryAllocation, stringList0);
        log
          ..debug('stringList0:$stringList0, is0.hash_code:${is0.hashCode}')
          ..debug('stringList0:$stringList0, is1.hash_code:${is1.hashCode}');
        expect(is0.hashCode == is1.hashCode, true);
        expect(is0 == is1, true);

        stringList1 = rsg.getISList(1, 1);
        final is2 = new IStag(PTag.kNumberOfFilms, stringList1);
        log.debug('stringList1:$stringList1 , is2.hash_code:${is2.hashCode}');
        expect(is0.hashCode == is2.hashCode, false);
        expect(is0 == is2, false);

        stringList2 = rsg.getISList(2, 2);
        final is3 = new IStag(PTag.kCenterOfCircularShutter, stringList2);
        log.debug('stringList2:$stringList2 , is3.hash_code:${is3.hashCode}');
        expect(is0.hashCode == is3.hashCode, false);
        expect(is0 == is3, false);

        stringList3 = rsg.getISList(3, 3);
        final is4 = new IStag(PTag.kROIDisplayColor, stringList3);
        log.debug('stringList3:$stringList3 , is4.hash_code:${is4.hashCode}');
        expect(is0.hashCode == is4.hashCode, false);
        expect(is0 == is4, false);

        stringList4 = rsg.getISList(2, 8);
        final is5 = new IStag(PTag.kVerticesOfThePolygonalShutter, stringList4);
        log.debug('stringList4:$stringList4 , is5.hash_code:${is5.hashCode}');
        expect(is0.hashCode == is5.hashCode, false);
        expect(is0 == is5, false);

        stringList5 = rsg.getDSList(2, 3);
        final is6 = new IStag(PTag.kNumberOfFilms, stringList5);
        log.debug('stringList5:$stringList5 , is6.hash_code:${is6.hashCode}');
        expect(is0.hashCode == is6.hashCode, false);
        expect(is0 == is6, false);
      }
    });

    test('IS valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        final is0 = new IStag(PTag.kPresentationPixelAspectRatio, vList0);
        expect(vList0, equals(is0.valuesCopy));
      }
    });

    test('IS isValidLength random', () {
      //isValidLength
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        final is0 = new IStag(PTag.kPresentationPixelAspectRatio, vList0);
        expect(is0.tag.isValidValuesLength(is0.values), true);
      }
    });

    test('IS isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        final is0 = new IStag(PTag.kPresentationPixelAspectRatio, vList0);
//Urgent Jim fix
//        expect(is0.tag.isValidValues(is0.values), true);
        expect(is0.hasValidValues, true);
      }
    });

    test('IS replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final is0 = new IStag(PTag.kWaveformChannelNumber, vList0);
        final vList1 = rsg.getISList(1, 1);
        expect(is0.replace(vList1), equals(vList0));
        expect(is0.values, equals(vList1));
      }

      final vList1 = rsg.getISList(1, 1);
      final is1 = new IStag(PTag.kWaveformChannelNumber, vList1);
      expect(is1.replace([]), equals(vList1));
      expect(is1.values, equals(<String>[]));

      final is2 = new IStag(PTag.kWaveformChannelNumber, vList1);
      expect(is2.replace(null), equals(vList1));
      expect(is2.values, equals(<String>[]));
    });

    test('IS blank random', () {
      //test on blank()
      final vList1 = rsg.getISList(2, 2);
      final is0 = new IStag(PTag.kPresentationPixelSpacing, vList1);
      expect(is0, isNull);
    });

    test('IS formBytes', () {
      //fromBytes
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getISList(1, 1);
        final bytes = IS.toBytes(vList1);
        log.info0('bytes:$bytes');
        final is1 = new IStag.fromBytes(PTag.kWaveformChannelNumber, bytes);
        log.info0('is1: ${is1.info}');
        expect(is1.hasValidValues, true);
      }
    });

    test('IS checkLength', () {
      final vList0 = rsg.getISList(1, 1);
      final is0 = new IStag(PTag.kWaveformChannelNumber, vList0);
      for (var s in goodISList) {
        expect(is0.checkLength(s), true);
      }
      final is1 = new IStag(PTag.kWaveformChannelNumber, vList0);
      expect(is1.checkLength(<String>[]), true);

      final vList1 = ['+8', '-6'];
      final is2 = new IStag(PTag.kStopTrim, vList0);
      expect(is2.checkLength(vList1), false);
    });

    test('IS checkValue', () {
      final vList0 = rsg.getISList(1, 1);
      final is0 = new IStag(PTag.kStopTrim, vList0);
      for (var s in goodISList) {
        for (var a in s) {
          expect(is0.checkValue(a), true);
        }
      }

      for (var s in badISList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(is0.checkValue(a), false);
        }
      }
    });

    test('create IS.hashStringList', () {
      system.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      final is0 = new IStag(PTag.kEchoNumbers);
      expect(is0.hashStringList(vList0), isNotNull);
    });

    group('IS Element', () {
      const uiTags = const <PTag>[
        PTag.kReferencedFrameNumber,
        PTag.kStageNumber,
        PTag.kNumberOfStages,
        PTag.kViewNumber,
        PTag.kNumberOfViewsInStage,
        PTag.kStartTrim,
        PTag.kStopTrim,
        PTag.kEvaluatorNumber,
        PTag.kTransformOrderOfAxes,
        PTag.kEchoNumbers,
        PTag.kCenterOfCircularShutter,
        PTag.kVerticesOfThePolygonalShutter,
        PTag.kROIDisplayColor,
        PTag.kNumberOfContourPoints,
        PTag.kObservationNumber,
        PTag.kCurrentFractionNumber,
      ];

      const otherTags = const <PTag>[
        PTag.kColumnAngulationPatient,
        PTag.kAcquisitionProtocolDescription,
        PTag.kCTDIvol,
        PTag.kCTPositionSequence,
        PTag.kAcquisitionType,
        PTag.kPerformedStationAETitle,
        PTag.kSelectorSTValue,
        PTag.kDate,
        PTag.kTime
      ];

      test('Create IS.checkVR', () {
        system.throwOnError = false;
        expect(IS.checkVRIndex(kISIndex), kISIndex);
        expect(IS.checkVRIndex(kAEIndex,), isNull);
        system.throwOnError = true;
        expect(() => IS.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in uiTags) {
          system.throwOnError = false;
          expect(IS.checkVRIndex(tag.vrIndex), kISIndex);
        }

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(IS.checkVRIndex(tag.vrIndex), isNull);

          system.throwOnError = true;
          expect(() => IS.checkVRIndex(kAEIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('Create IS.isValidVRIndex', () {
        system.throwOnError = false;
        expect(IS.isValidVRIndex(kISIndex), true);
        expect(IS.isValidVRIndex(kSSIndex), false);

        system.throwOnError = true;
        expect(() => IS.isValidVRIndex(kSSIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in uiTags) {
          system.throwOnError = false;
          expect(IS.isValidVRIndex(tag.vrIndex), true);
        }

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(IS.isValidVRIndex(tag.vrIndex), false);

          system.throwOnError = true;
          expect(() => IS.isValidVRIndex(tag.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('Create IS.isValidVRCode', () {
        system.throwOnError = false;
        expect(IS.isValidVRCode(kISCode), true);
        expect(IS.isValidVRCode(kAECode), false);

        system.throwOnError = true;
        expect(() => IS.isValidVRCode(kAECode),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in uiTags) {
          expect(IS.isValidVRCode(tag.vrCode), true);
        }

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(IS.isValidVRCode(tag.vrCode), false);

          system.throwOnError = true;
          expect(() => IS.isValidVRCode(tag.vrCode),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('Create IS.isValidVFLength', () {
        expect(IS.isValidVFLength(IS.kMaxVFLength), true);
        expect(IS.isValidVFLength(IS.kMaxVFLength + 1), false);

        expect(IS.isValidVFLength(0), true);
        expect(IS.isValidVFLength(-1), false);
      });

      test('Create IS.isNotValidVFLength', () {
        expect(IS.isNotValidVFLength(IS.kMaxVFLength), false);
        expect(IS.isNotValidVFLength(IS.kMaxVFLength + 1), true);

        expect(IS.isNotValidVFLength(0), false);
        expect(IS.isNotValidVFLength(-1), true);
      });

/* Urgent Fix
      test('Create IS.isValidLength', () {
        system.throwOnError = false;
        expect(IS.isValidLength(IS.kMaxLength), true);
        expect(IS.isValidLength(IS.kMaxLength + 1), false);

        expect(IS.isValidLength(0), true);
        expect(IS.isValidLength(-1), false);
      });
*/

      test('Create IS.isValidValueLength', () {
        for (var s in goodISList) {
          for (var a in s) {
            expect(IS.isValidValueLength(a), true);
          }
        }
      });

      test('Create IS.isNotValidValueLength', () {
        for (var s in goodISList) {
          for (var a in s) {
            expect(IS.isNotValidValueLength(a), false);
          }
        }
      });

/* Urgent Fix
      test('Create IS.isValidLength', () {
        system.throwOnError = false;
        expect(IS.isValidLength(IS.kMaxLength), true);
        expect(IS.isValidLength(IS.kMaxLength + 1), false);

        expect(IS.isValidLength(0), true);
        expect(IS.isValidLength(-1), false);
      });
*/

      test('Create IS.isValidValue', () {
        for (var s in goodISList) {
          for (var a in s) {
            expect(IS.isValidValue(a), true);
          }
        }

        for (var s in badISList) {
          for (var a in s) {
            system.throwOnError = false;
            expect(IS.isValidValue(a), false);
          }
        }
      });

      test('Create IS.isValidValues', () {
        system.throwOnError = false;
        for (var s in goodISList) {
          expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), true);
        }
        for (var s in badISList) {
          system.throwOnError = false;
          expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), false);

          system.throwOnError = true;
          expect(() => IS.isValidValues(PTag.kBeamOrderIndexTrial, s),
              throwsA(const isInstanceOf<InvalidStringError>()));
        }
      });

      test('Create IS.fromBytes', () {
        system.level = Level.debug;
        final vList1 = rsg.getCSList(1, 1);
        final bytes = IS.toBytes(vList1);
        log.debug('IS.fromBytes(bytes): ${IS.fromBytes(bytes)}, bytes: $bytes');
        expect(IS.fromBytes(bytes), equals(vList1));
      });

      test('Create IS.toBytes', () {
        final vList1 = rsg.getISList(1, 1);
        log.debug('IS.toBytes(vList1): ${IS.toBytes(vList1)}');
        final val = ASCII.encode('s6V&:;s%?Q1g5v');
        expect(IS.toBytes(['s6V&:;s%?Q1g5v']), equals(val));

        if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
        log.debug('vList1:"$vList1"');
        final values = ASCII.encode(vList1[0]);
        expect(IS.toBytes(vList1), equals(values));
      });

      test('Create IS.fromBase64', () {
        system.throwOnError = false;
        final vList1 = rsg.getISList(1, 1);

        final v0 = IS.fromBase64(vList1);
        expect(v0, isNotNull);

        final v1 = IS.fromBase64(['123']);
        expect(v1, isNotNull);

        final v2 = IS.fromBase64(['PIA']);
        expect(v2, isNotNull);
      });

      test('Create IS.toBase64', () {
        //final s = BASE64.encode(testFrame);
        final vList0 = rsg.getISList(1, 1);
        expect(IS.toBase64(vList0), equals(vList0));

        final vList1 = ['123'];
        //final s0 = ASCII.encode(vList0[0]);
        expect(IS.toBase64(vList1), equals(vList1));
      });

      test('create IS.tryParse', () {
        system.throwOnError = false;
        final vList0 = rsg.getISList(1, 1);
        expect(IS.tryParse(vList0[0]), int.parse(vList0[0]));

        final vList1 = '123';
        expect(IS.tryParse(vList1), int.parse(vList1));

        final vList2 = '12.34';
        expect(IS.tryParse(vList2), isNull);

        final vList3 = 'abc';
        expect(IS.tryParse(vList3), isNull);

        system.throwOnError = true;
        expect(
            () => IS.tryParse(vList3), throwsA(const isInstanceOf<InvalidStringError>()));
      });

      test('create IS.tryParseList', () {
        system.throwOnError = false;
        final vList0 = rsg.getISList(1, 1);
        final parse0 = int.parse(vList0[0]);
        expect(IS.tryParseList(vList0), <int>[parse0]);

        final vList1 = ['123'];
        final parse1 = int.parse(vList1[0]);
        expect(IS.tryParseList(vList1), <int>[parse1]);

        final vList2 = ['12.34'];
        expect(IS.tryParseList(vList2), isNull);

        final vList3 = ['abc'];
        expect(IS.tryParseList(vList3), isNull);

        system.throwOnError = true;
        expect(() => IS.tryParseList(vList3),
            throwsA(const isInstanceOf<InvalidStringError>()));
      });

      test('create IS.parseBytes', () {
        system.throwOnError = false;
        final vList0 = rsg.getISList(1, 1);
        final bytes0 = IS.toBytes(vList0);
        final parse0 = int.parse(vList0[0]);
        expect(IS.parseBytes(bytes0), [parse0]);

        final vList1 = ['123'];
        final bytes1 = IS.toBytes(vList1);
        final parse1 = int.parse(vList1[0]);
        expect(IS.parseBytes(bytes1), <int>[parse1]);

        final vList2 = ['12.34'];
        final bytes2 = IS.toBytes(vList2);
        expect(IS.parseBytes(bytes2), isNull);

        final vList3 = ['abc'];
        final bytes3 = IS.toBytes(vList3);
        expect(IS.parseBytes(bytes3), isNull);

        system.throwOnError = true;
        expect(() => IS.parseBytes(bytes3),
            throwsA(const isInstanceOf<InvalidStringError>()));
      });

      test('create IS.validateValueField', () {
        system.throwOnError = false;
        final vList0 = rsg.getISList(1, 1);
        final bytes0 = IS.toBytes(vList0);
        expect(IS.validateValueField(bytes0), vList0);

        final vList1 = ['123'];
        final bytes1 = IS.toBytes(vList1);
        expect(IS.validateValueField(bytes1), vList1);

        final vList2 = ['12.34'];
        final bytes2 = IS.toBytes(vList2);
        expect(IS.validateValueField(bytes2), vList2);

        final vList3 = ['abc'];
        final bytes3 = IS.toBytes(vList3);
        expect(IS.validateValueField(bytes3), vList3);
      });

      test('Create IS.checkList', () {
        system.throwOnError = false;
        for (var i = 0; i <= 10; i++) {
          final vList = rsg.getISList(1, 1);
          expect(IS.checkList(PTag.kBeamOrderIndexTrial, vList), vList);
        }

        final vList0 = ['560'];
        expect(IS.checkList(PTag.kBeamOrderIndexTrial, vList0), vList0);

        final vList1 = ['\b'];
        expect(IS.checkList(PTag.kBeamOrderIndexTrial, vList1), isNull);

        system.throwOnError = true;
        expect(() => IS.checkList(PTag.kBeamOrderIndexTrial, vList1),
            throwsA(const isInstanceOf<InvalidStringError>()));

        for (var s in goodISList) {
          system.throwOnError = false;
          expect(IS.checkList(PTag.kBeamOrderIndexTrial, s), s);
        }
        for (var s in badISList) {
          system.throwOnError = false;
          expect(IS.checkList(PTag.kBeamOrderIndexTrial, s), isNull);

          system.throwOnError = true;
          expect(() => IS.checkList(PTag.kBeamOrderIndexTrial, s),
              throwsA(const isInstanceOf<InvalidStringError>()));
        }
      });
    });
  });
}
