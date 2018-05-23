//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert';

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'string/ds_test', level: Level.info);
  global.throwOnError = false;

  const goodDecimalStrings = const <String>[
    '567',
    ' 567',
    '567 ',
    ' 567 ',
    '-6.60',
    '-6.60 ',
    ' -6.60 ',
    ' -6.60 ',
    '+6.60',
    '+6.60 ',
    ' +6.60 ',
    ' +6.60 ',
    '0.7591109678',
    '-6.1e-1',
    ' -6.1e-1',
    '-6.1e-1 ',
    ' -6.1e-1 ',
    '+6.1e+1',
    ' +6.1e+1',
    '+6.1e+1 ',
    ' +6.1e+1 ',
    '+1.5e-1',
    ' +1.5e-1',
    '+1.5e-1 ',
    ' +1.5e-1 '
  ];

  group('Decimal String Tests', () {
    test('DS isValidValue good values', () {
      for (var s in goodDecimalStrings) {
        global.throwOnError = false;
        log.debug('s: "$s"');
        final n = DS.tryParse(s);
        log.debug('n: $n');
        expect(n, isNotNull);
        expect(DS.isValidValue(s), true);
      }
    });
  });

  const goodDSList = const <List<String>>[
    const <String>['0.7591109678'],
    const <String>['-6.1e-1'],
    const <String>[' -6.1e-1'],
    const <String>['-6.1e-1'],
    const <String>['560'],
    const <String>[' -6.60'],
    const <String>['+1.5e-1'],
  ];

  const badDSList = const <List<String>>[
    const <String>['\b'],
    //	Backspace
    const <String>['\t '],
    //horizontal tab (HT)
    const <String>['\n'],
    //linefeed (LF)
    const <String>['\f '],
    // form feed (FF)
    const <String>['\r '],
    //carriage return (CR)
    const <String>['\v'],
    //vertical tab
    const <String>[r'\'],
    const <String>['B\\S'],
    const <String>['1\\9'],
    const <String>['a\\4'],
    const <String>[r'^`~\\?'],
    const <String>[r'^\?'],
    const <String>['abc']
  ];

  const badDSLengthValues = const <List<String>>[
    const <String>['0.7591145074654659110'],
    const <String>['12393.4563234098903'],
  ];

  const badDSLengthList = const <List<String>>[
    const <String>['0.7591109678', '0.7591109678'],
    const <String>['-6.1e-1', '123.75934548'],
    const <String>['-6.1e-1', '103.75548', '234.4570'],
  ];

  group('DS Tests', () {
    test('DS isValidValue good values', () {
      for (var vList in goodDSList) {
        global.throwOnError = false;
        log.debug('s: "$vList"');
        expect(DS.isValidValue(vList[0]), true);
      }
    });

    test('DS hasValidValues good values', () {
      for (var s in goodDSList) {
        global.throwOnError = false;
        log.debug('s: "$s"');
        final e0 = new DStag(PTag.kProcedureStepProgress, s);
        expect(e0.hasValidValues, true);

        final e1 = new DStag(PTag.kProcedureStepProgress, []);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('DS hasValidValues bad values', () {
      for (var s in badDSList) {
        global.throwOnError = false;
        final e0 = new DStag(PTag.kProcedureStepProgress, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new DStag(PTag.kProcedureStepProgress, s),
            throwsA(const isInstanceOf<StringError>()));
      }

      global.throwOnError = false;
      final e1 = new DStag(PTag.kProcedureStepProgress, null);
      log.debug('e1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => new DStag(PTag.kProcedureStepProgress, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });
    test('DS hasValidValues good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final e0 = new DStag(PTag.kPresentationPixelSpacing, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final e0 = new DStag(PTag.kProcedureStepProgress, vList0);
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }
    });

    test('DS hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getDSList(3, 4);
        log.debug('$i: vList0: $vList0');
        final e0 = new DStag(PTag.kProcedureStepProgress, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new DStag(PTag.kProcedureStepProgress, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('DS update random', () {
      global.throwOnError = false;
      final e0 = new DStag(PTag.kCompensatorTransmissionData, []);
      expect(e0.update(['325435.7878-', '4545.887+']), isNull);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 4);
        final e1 = new DStag(PTag.kCompensatorTransmissionData, vList0);
        final vList1 = rsg.getDSList(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('DS noValues random', () {
      final e0 = new DStag(PTag.kProcedureStepProgress, []);
      final DStag dsNoValues = e0.noValues;
      expect(dsNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 4);
        final e0 = new DStag(PTag.kCompensatorTransmissionData, vList0);
        log.debug('e0: $e0');
        expect(dsNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('DS copy random', () {
      final e0 = new DStag(PTag.kProcedureStepProgress, []);
      final DStag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 4);
        final e2 = new DStag(PTag.kCompensatorTransmissionData, vList0);
        final DStag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('DS hashCode and == good values randoom', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getDSList(1, 1);
        final e0 = new DStag(PTag.kProcedureStepProgress, vList);
        final e1 = new DStag(PTag.kProcedureStepProgress, vList);
        log
          ..debug('vList:$vList, e0.hash_code:${e0.hashCode}')
          ..debug('vList:$vList, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('DS hashCode and == bad values randoom', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final e0 = new DStag(PTag.kProcedureStepProgress, vList0);
        final vList1 = rsg.getDSList(1, 1);
        final e1 = new DStag(PTag.kCineRelativeToRealTime, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, false);
        expect(e0 == e1, false);

        final vList2 = rsg.getDSList(2, 2);
        final e2 = new DStag(PTag.kImagePlanePixelSpacing, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList3 = rsg.getDSList(3, 3);
        final e3 = new DStag(PTag.kNormalizationPoint, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList4 = rsg.getDSList(4, 4);
        final e4 = new DStag(PTag.kDoubleExposureFieldDeltaTrial, vList4);
        log.debug('vList4:$vList4 , e5.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);

        final vList5 = rsg.getDSList(6, 6);
        final e5 = new DStag(PTag.kRTImageOrientation, vList5);
        log.debug('vList5:$vList5 , e6.hash_code:${e5.hashCode}');
        expect(e0.hashCode == e5.hashCode, false);
        expect(e0 == e5, false);

        final vList6 = rsg.getDSList(2, 3);
        final e6 = new DStag(PTag.kProcedureStepProgress, vList6);
        log.debug('vList6:$vList6 , e7.hash_code:${e6.hashCode}');
        expect(e0.hashCode == e6.hashCode, false);
        expect(e0 == e6, false);
      }
    });

    test('DS valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final e0 = new DStag(PTag.kPresentationPixelSpacing, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('DS isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final e0 = new DStag(PTag.kPresentationPixelSpacing, vList0);
        expect(e0.hasValidLength, true);
      }
    });

    test('DS isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final e0 = new DStag(PTag.kPresentationPixelSpacing, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('DS replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final e0 = new DStag(PTag.kSamplingFrequency, vList0);
        final vList1 = rsg.getDSList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getDSList(1, 1);
      final e1 = new DStag(PTag.kWaveformChannelNumber, vList1);
      expect(e1, isNull);
    });

    test('DS fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDSList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final e1 = DStag.fromBytes(bytes, PTag.kSamplingFrequency);
        log.debug('e1: ${e1.info}');
        expect(e1.hasValidValues, true);
      }
    });

    test('DS fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDSList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final ur1 = DStag.fromBytes(bytes0, PTag.kSelectorDSValue);
          log.debug('ur1: ${ur1.info}');
          expect(ur1.hasValidValues, true);
        }
      }
    });

    test('DS fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDSList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final ur1 = DStag.fromBytes(bytes0, PTag.kSelectorAEValue);
          expect(ur1, isNull);

          global.throwOnError = true;
          expect(() => DStag.fromBytes(bytes0, PTag.kSelectorAEValue),
              throwsA(const isInstanceOf<InvalidTagError>()));
        }
      }
    });

    test('DS fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final e0 = DStag.fromValues(PTag.kPatientSize, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        global.throwOnError = false;
        final e1 = DStag.fromValues(PTag.kPatientSize, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('DS fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        global.throwOnError = false;
        final e0 = DStag.fromValues(PTag.kPatientSize, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => DStag.fromValues(PTag.kPatientSize, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      /*final e1 = DStag.fromValues(PTag.kSelectorDSValue, <String>[null]);
      log.debug('e1: $e1');
      expect(e1, isNull);*/

      global.throwOnError = true;
      expect(() => DStag.fromValues(PTag.kPatientSize, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('DS checkLength good values', () {
      final vList0 = rsg.getDSList(1, 1);
      final e0 = new DStag(PTag.kSamplingFrequency, vList0);
      for (var s in goodDSList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new DStag(PTag.kSamplingFrequency, vList0);
      expect(e1.checkLength([]), true);
    });

    test('DS checkLength bad values', () {
      final vList0 = rsg.getDSList(1, 1);
      final vList1 = ['+8', '-6.1e-1'];
      final e2 = new DStag(PTag.kPatientSize, vList0);
      expect(e2.checkLength(vList1), false);
    });

    test('DS checkValue good values', () {
      final vList0 = rsg.getDSList(1, 1);
      final e0 = new DStag(PTag.kPatientSize, vList0);
      for (var s in goodDSList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });
    test('DS checkValue bad values', () {
      final vList0 = rsg.getDSList(1, 1);
      final e0 = new DStag(PTag.kPatientSize, vList0);
      for (var s in badDSList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);
        }
      }
    });
  });

  group('DS Element', () {
    //VM.k1
    const dsVM1Tags = const <PTag>[
      PTag.kPatientSize,
      PTag.kPatientWeight,
      PTag.kOuterDiameter,
      PTag.kInnerDiameter,
      PTag.kDVHMinimumDose,
      PTag.kDVHMaximumDose,
      PTag.kROIVolume,
      PTag.kROIPhysicalPropertyValue,
      PTag.kMeasuredDoseValue,
      PTag.kSpecifiedTreatmentTime,
      PTag.kDeliveredMeterset,
      PTag.kEndMeterset
    ];

    //VM.k2
    const dsVM2Tags = const <PTag>[
      PTag.kImagerPixelSpacing,
      PTag.kNominalScannedPixelSpacing,
      PTag.kDetectorBinning,
      PTag.kDetectorElementPhysicalSize,
      PTag.kDetectorElementSpacing,
      PTag.kFieldOfViewOrigin,
      PTag.kPixelSpacing,
      PTag.kZoomCenter,
      PTag.kPresentationPixelSpacing,
      PTag.kImagePlanePixelSpacing
    ];

    //VM.k2_2n
    const dsVM2_2nTags = const <PTag>[PTag.kDVHData];

    //VM.k3
    const dsVM3Tags = const <PTag>[
      PTag.kImageTranslationVector,
      PTag.kImagePosition,
      PTag.kImagePositionPatient,
      PTag.kXRayImageReceptorTranslation,
      PTag.kNormalizationPoint,
      PTag.kDVHNormalizationPoint,
      PTag.kDoseReferencePointCoordinates,
      PTag.kIsocenterPosition
    ];

    //VM.k3_3n
    const dsVM3_3nTags = const <PTag>[
      PTag.kLeafPositionBoundaries,
      PTag.kContourData
    ];

    //VM.k4
    const dsVM4Tags = const <PTag>[
      PTag.kDoubleExposureFieldDeltaTrial,
      PTag.kDiaphragmPosition
    ];

    //VM.k6
    const dsVM6Tags = const <PTag>[
      PTag.kPRCSToRCSOrientation,
      PTag.kImageTransformationMatrix,
      PTag.kImageOrientation,
      PTag.kImageOrientationPatient,
      PTag.kImageOrientationSlide
    ];

    //VM.k1_n
    const dsVM1_nTags = const <PTag>[
      PTag.kMaterialThickness,
      PTag.kMaterialIsolationDiameter,
      PTag.kCoordinateSystemTransformTranslationMatrix,
      PTag.kDACGainPoints,
      PTag.kDACTimePoints,
      PTag.kEnergyWindowTotalWidth,
      PTag.kContrastFlowRate,
      PTag.kFrameTimeVector,
      PTag.kTableVerticalIncrement,
      PTag.kRotationOffset,
      PTag.kFocalSpots,
      PTag.kPositionerPrimaryAngleIncrement,
      PTag.kPositionerSecondaryAngleIncrement,
      PTag.kFramePrimaryAngleVector,
    ];

    const badDSTags = const <PTag>[
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

    final invalidVList = rsg.getDSList(DS.kMaxLength + 1, DS.kMaxLength + 1);

    test('DS isValidTag good values', () {
      global.throwOnError = false;
      expect(DS.isValidTag(PTag.kSelectorDSValue), true);

      for (var tag in dsVM1Tags) {
        final validT0 = DS.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('DS isValidTag bad values', () {
      global.throwOnError = false;
      expect(DS.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => DS.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in badDSTags) {
        global.throwOnError = false;
        final validT0 = DS.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => DS.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });
/*

    test('DS checkVRIndex good values', () {
      global.throwOnError = false;
      expect(DS.checkVRIndex(kDSIndex), kDSIndex);

      for (var tag in dsTags0) {
        global.throwOnError = false;
        expect(DS.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('DS checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(DS.checkVRIndex(kAEIndex), isNull);
      global.throwOnError = true;
      expect(() => DS.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DS.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => DS.checkVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DS checkVRCode good values', () {
      global.throwOnError = false;
      expect(DS.checkVRCode(kDSCode), kDSCode);

      for (var tag in dsTags0) {
        global.throwOnError = false;
        expect(DS.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('DS checkVRCode bad values', () {
      global.throwOnError = false;
      expect(DS.checkVRCode(kAECode), isNull);
      global.throwOnError = true;
      expect(() => DS.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DS.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => DS.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
*/

    test('DS isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(DS.isValidVRIndex(kDSIndex), true);

      for (var tag in dsVM1Tags) {
        global.throwOnError = false;
        expect(DS.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('DS isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(DS.isValidVRIndex(kSSIndex), false);

      global.throwOnError = true;
      expect(() => DS.isValidVRIndex(kSSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in badDSTags) {
        global.throwOnError = false;
        expect(DS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => DS.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DS isValidVRCode good values', () {
      global.throwOnError = false;
      expect(DS.isValidVRCode(kDSCode), true);

      for (var tag in dsVM1Tags) {
        expect(DS.isValidVRCode(tag.vrCode), true);
      }
    });

    test('DS isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(DS.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => DS.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in badDSTags) {
        global.throwOnError = false;
        expect(DS.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => DS.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DS isValidVFLength good values', () {
      expect(DS.isValidVFLength(DS.kMaxVFLength), true);
      expect(DS.isValidVFLength(0), true);
    });

    test('DS isValidVFLength bad values', () {
      expect(DS.isValidVFLength(DS.kMaxVFLength + 1), false);
      expect(DS.isValidVFLength(-1), false);
    });

    test('DS isValidValueLength good values', () {
      for (var s in goodDSList) {
        for (var a in s) {
          expect(DS.isValidValueLength(a), true);
        }
      }

      expect(DS.isValidValueLength('15428.23214570'), true);
    });

    test('DS isValidValueLength bad values', () {
      global.throwOnError = false;
      for (var s in badDSLengthValues) {
        for (var a in s) {
          log.debug(a);
          expect(DS.isValidValueLength(a), false);
        }
      }
      expect(DS.isValidValueLength('15428.2342342432432'), false);
    });

    test('DS isValidVListLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(1, 1);
        for (var tag in dsVM1Tags) {
          expect(DS.isValidLength(tag, validMinVList), true);

          expect(DS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(DS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('DS isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getDSList(2, i + 1);
        for (var tag in dsVM1Tags) {
          global.throwOnError = false;
          expect(DS.isValidLength(tag, validMinVList), false);

          expect(DS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => DS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k2 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(2, 2);
        for (var tag in dsVM2Tags) {
          expect(DS.isValidLength(tag, validMinVList), true);

          expect(DS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(DS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('DS isValidVListLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList = rsg.getDSList(3, i + 1);
        for (var tag in dsVM2Tags) {
          global.throwOnError = false;
          expect(DS.isValidLength(tag, validMinVList), false);

          expect(
              DS.isValidLength(tag, invalidVList.take(tag.vmMax + 1)), false);
          expect(
              DS.isValidLength(tag, invalidVList.take(tag.vmMin - 1)), false);

          expect(DS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => DS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k2_2n good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(10, 10);

        for (var tag in dsVM2_2nTags) {
          log..debug('tag: $tag')..debug('max: ${tag.maxValues}');
          final validMaxLengthList = invalidVList.sublist(0, tag.maxValues);

          log.debug('list: ${validMaxLengthList.length}');
          expect(DS.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('DS isValidVListLength VM.k2_2n bad values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(1, 1);
        for (var tag in dsVM2_2nTags) {
          global.throwOnError = false;
          expect(DS.isValidLength(tag, validMinVList), false);

          expect(
              DS.isValidLength(tag, invalidVList.take(tag.vmMax + 2)), false);
          global.throwOnError = true;
          expect(() => DS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k3 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(3, 3);
        for (var tag in dsVM3Tags) {
          expect(DS.isValidLength(tag, validMinVList), true);

          expect(DS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(DS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('DS isValidVListLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final validMinVList = rsg.getDSList(4, i + 1);
        for (var tag in dsVM3Tags) {
          global.throwOnError = false;
          expect(DS.isValidLength(tag, validMinVList), false);

          expect(
              DS.isValidLength(tag, invalidVList.take(tag.vmMax + 1)), false);
          expect(
              DS.isValidLength(tag, invalidVList.take(tag.vmMin - 1)), false);
          expect(DS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => DS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k3_3n good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(9, 9);
        for (var tag in dsVM3_3nTags) {
          expect(DS.isValidLength(tag, validMinVList), true);

          //expect(DS.isValidLength(tag, invalidVList.take(tag.vmMax + 4)), true);
        }
      }
    });

    test('DS isValidVListLength VM.k3_3n bad values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(1, 1);
        for (var tag in dsVM3_3nTags) {
          global.throwOnError = false;
          expect(DS.isValidLength(tag, validMinVList), false);

          expect(
              DS.isValidLength(tag, invalidVList.take(tag.vmMax + 2)), false);

          global.throwOnError = true;
          expect(() => DS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k4 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(4, 4);
        for (var tag in dsVM4Tags) {
          expect(DS.isValidLength(tag, validMinVList), true);

          expect(DS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(DS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('DS isValidVListLength VM.k4 bad values', () {
      for (var i = 4; i < 10; i++) {
        final validMinVList = rsg.getDSList(5, i + 1);
        for (var tag in dsVM4Tags) {
          global.throwOnError = false;
          expect(DS.isValidLength(tag, validMinVList), false);

          expect(
              DS.isValidLength(tag, invalidVList.take(tag.vmMax + 1)), false);
          expect(
              DS.isValidLength(tag, invalidVList.take(tag.vmMin - 1)), false);
          expect(DS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => DS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k6 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(6, 6);
        for (var tag in dsVM6Tags) {
          expect(DS.isValidLength(tag, validMinVList), true);

          expect(DS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(DS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('DS isValidVListLength VM.k6 bad values', () {
      for (var i = 6; i < 10; i++) {
        final validMinVList = rsg.getDSList(7, i + 1);
        for (var tag in dsVM6Tags) {
          global.throwOnError = false;
          expect(DS.isValidLength(tag, validMinVList), false);

          expect(DS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => DS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getDSList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, DS.kMaxLength);
        for (var tag in dsVM1_nTags) {
          log.debug('tag: $tag');
          expect(DS.isValidLength(tag, validMinVList0), true);
          expect(DS.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('DS isValidValue good values', () {
      for (var s in goodDSList) {
        for (var a in s) {
          expect(DS.isValidValue(a), true);
        }
      }
    });

    test('DS isValidValue bad values', () {
      for (var s in badDSList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(DS.isValidValue(a), false);
        }
      }
    });

    test('DS isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodDSList) {
        expect(DS.isValidValues(PTag.kSelectorDSValue, s), true);
      }
    });

    test('DS isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badDSList) {
        global.throwOnError = false;
        expect(DS.isValidValues(PTag.kSelectorDSValue, s), false);

        global.throwOnError = true;
        expect(() => DS.isValidValues(PTag.kSelectorDSValue, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('DS isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badDSLengthList) {
        global.throwOnError = false;
        expect(DS.isValidValues(PTag.kPatientSize, s), false);

        global.throwOnError = true;
        expect(() => DS.isValidValues(PTag.kPatientSize, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('DS fromUint8List', () {
      //  system.level = Level.info;;
      final vList0 = rsg.getDSList(1, 1);
      final bytes = Bytes.fromAsciiList(vList0);
      final vList1 = bytes.getAsciiList();
      log.debug('DS.decodeBinaryVF(bytes): $vList1, '
          'bytes: $bytes');
      expect(bytes.getAsciiList(), equals(vList0));
    });

    test('DS toBytes', () {
      global.level = Level.debug;
      final vList = rsg.getDSList(1, 1);
      final v = vList[0];
      log.debug('vList0:"$v"');
      final bytes0 = Bytes.fromAsciiList(vList);
      log.debug('DS.toBytes("$v"): $bytes0');
      //if (vList[0].length.isOdd) vList[0] = '$v';
      final values = ascii.encode(v);
      expect(bytes0.asUint8List(), equals(values));
    });

    test('DS tryParse', () {
      global.throwOnError = false;
      final vList0 = rsg.getDSList(1, 1);
      expect(DS.tryParse(vList0[0]), double.parse(vList0[0]));

      const vList1 = '123';
      expect(DS.tryParse(vList1), double.parse(vList1));

      const vList2 = '12.34';
      expect(DS.tryParse(vList2), double.parse(vList2));

      const vList3 = 'abc';
      expect(DS.tryParse(vList3), isNull);

      const vList4 = ' 1245';
      expect(DS.tryParse(vList4), double.parse(vList4));

      const vList5 = '1245 ';
      expect(DS.tryParse(vList5), double.parse(vList5));

      const vList6 = ' 1245  ';
      expect(DS.tryParse(vList6), double.parse(vList6));

      const vList7 = '12 45';
      expect(DS.tryParse(vList7), isNull);

      global.throwOnError = true;
      expect(() => DS.tryParse(vList3),
          throwsA(const isInstanceOf<StringError>()));

      expect(() => DS.tryParse(vList7),
          throwsA(const isInstanceOf<StringError>()));
    });

    test('DS tryParseList', () {
      global.throwOnError = false;
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

      final vList4 = [' 1245'];
      final parse3 = double.parse(vList4[0]);
      expect(DS.tryParseList(vList4), <double>[parse3]);

      final vList5 = ['1245 '];
      final parse4 = double.parse(vList4[0]);
      expect(DS.tryParseList(vList5), <double>[parse4]);

      final vList6 = [' 1245  '];
      final parse5 = double.parse(vList4[0]);
      expect(DS.tryParseList(vList6), <double>[parse5]);

      final vList7 = ['12 45'];
      expect(DS.tryParseList(vList7), isNull);

      global.throwOnError = true;
      expect(() => DS.tryParseList(vList3),
          throwsA(const isInstanceOf<StringError>()));

      expect(() => DS.tryParseList(vList7),
          throwsA(const isInstanceOf<StringError>()));
    });

    test('DS isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getDSList(1, 1);
        expect(DS.isValidValues(PTag.kSelectorDSValue, vList), true);
      }
      for (var s in goodDSList) {
        global.throwOnError = false;
        expect(DS.isValidValues(PTag.kSelectorDSValue, s), true);
      }
      final vList0 = ['-6.1e-1'];
      expect(DS.isValidValues(PTag.kSelectorDSValue, vList0), true);
    });

    test('DS isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['\b'];
      expect(DS.isValidValues(PTag.kSelectorDSValue, vList1), false);

      global.throwOnError = true;
      expect(() => DS.isValidValues(PTag.kSelectorDSValue, vList1),
          throwsA(const isInstanceOf<StringError>()));

      for (var s in badDSList) {
        global.throwOnError = false;
        expect(DS.isValidValues(PTag.kSelectorDSValue, s), false);

        global.throwOnError = true;
        expect(() => DS.isValidValues(PTag.kSelectorDSValue, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('DS isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badDSLengthList) {
        global.throwOnError = false;
        expect(DS.isValidValues(PTag.kPatientSize, s), false);

        global.throwOnError = true;
        expect(() => DS.isValidValues(PTag.kPatientSize, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('DS decodeBinaryStringVF', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getDSList(1, i);
        final bytes = Bytes.fromAsciiList(vList1);
        final dbStr0 = bytes.getAsciiList();
        log.debug('dbStr0: $dbStr0');
        expect(dbStr0, vList1);

        final dbStr1 = bytes.getUtf8List();
        log.debug('dbStr1: $dbStr1');
        expect(dbStr1, vList1);
      }
      final bytes = Bytes.fromAsciiList([]);
      expect(bytes.getAsciiList(), <String>[]);
    });

    test('DS toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        global.throwOnError = false;
        final values = ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('tbd1: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodDSList) {
        for (var a in s) {
          final values = ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('DS fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodDSList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('DS toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(vList0);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodDSList) {
        final toB1 = Bytes.fromAsciiList(s);
        final bytes1 = Bytes.fromAscii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.fromAsciiList(['']);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.fromAsciiList([]);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.fromAsciiList(null);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.fromAsciiList(null),
          throwsA(const isInstanceOf<GeneralError>()));
    });
  });
}