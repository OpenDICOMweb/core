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
  Server.initialize(name: 'string/number_test', level: Level.info);
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
        final ds0 = new DStag(PTag.kProcedureStepProgress, s);
        expect(ds0.hasValidValues, true);

        final ds1 = new DStag(PTag.kProcedureStepProgress, []);
        expect(ds1.hasValidValues, true);
        expect(ds1.values, equals(<String>[]));
      }
    });

    test('DS hasValidValues bad values', () {
      for (var s in badDSList) {
        global.throwOnError = false;
        final ds0 = new DStag(PTag.kProcedureStepProgress, s);
        expect(ds0, isNull);

        global.throwOnError = true;
        expect(() => new DStag(PTag.kProcedureStepProgress, s),
            throwsA(const isInstanceOf<StringError>()));
      }

      global.throwOnError = false;
      final ds1 = new DStag(PTag.kProcedureStepProgress, null);
      log.debug('ds1: $ds1');
      expect(ds1, isNull);

      global.throwOnError = true;
      expect(() => new DStag(PTag.kProcedureStepProgress, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });
    test('DS hasValidValues good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final ds0 = new DStag(PTag.kPresentationPixelSpacing, vList0);
        log.debug('ds0:${ds0.info}');
        expect(ds0.hasValidValues, true);

        log
          ..debug('ds0: $ds0, values: ${ds0.values}')
          ..debug('ds0: ${ds0.info}');
        expect(ds0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final ds0 = new DStag(PTag.kProcedureStepProgress, vList0);
        expect(ds0.hasValidValues, true);

        log
          ..debug('ds0: $ds0, values: ${ds0.values}')
          ..debug('ds0: ${ds0.info}');
        expect(ds0[0], equals(vList0[0]));
      }
    });

    test('DS hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getDSList(3, 4);
        log.debug('$i: vList0: $vList0');
        final ds0 = new DStag(PTag.kProcedureStepProgress, vList0);
        expect(ds0, isNull);

        global.throwOnError = true;
        expect(() => new DStag(PTag.kProcedureStepProgress, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('DS update random', () {
      global.throwOnError = false;
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

    test('DS hashCode and == good values randoom', () {
      List<String> stringList0;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDSList(1, 1);
        final ds0 = new DStag(PTag.kProcedureStepProgress, stringList0);
        final ds1 = new DStag(PTag.kProcedureStepProgress, stringList0);
        log
          ..debug('stringList0:$stringList0, ds0.hash_code:${ds0.hashCode}')
          ..debug('stringList0:$stringList0, ds1.hash_code:${ds1.hashCode}');
        expect(ds0.hashCode == ds1.hashCode, true);
        expect(ds0 == ds1, true);
      }
    });

    test('DS hashCode and == bad values randoom', () {
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;
      List<String> stringList4;
      List<String> stringList5;
      List<String> stringList6;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDSList(1, 1);
        final ds0 = new DStag(PTag.kProcedureStepProgress, stringList0);
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
        expect(ds0.hashCode == ds6.hashCode, false);
        expect(ds0 == ds6, false);

        stringList6 = rsg.getDSList(2, 3);
        final ds7 = new DStag(PTag.kProcedureStepProgress, stringList6);
        log.debug('stringList6:$stringList6 , ds7.hash_code:${ds7.hashCode}');
        expect(ds0.hashCode == ds7.hashCode, false);
        expect(ds0 == ds7, false);
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
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final ds0 = new DStag(PTag.kPresentationPixelSpacing, vList0);
        expect(ds0.tag.isValidLength(ds0.length), true);
      }
    });

    test('DS isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final ds0 = new DStag(PTag.kPresentationPixelSpacing, vList0);
        expect(ds0.checkValues(ds0.values), true);
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
      final ds1 = new DStag(PTag.kWaveformChannelNumber, vList1);
      expect(ds1, isNull);
    });

    test('DS fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDSList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final ds1 = DStag.fromBytes(PTag.kSamplingFrequency, bytes);
        log.debug('ds1: ${ds1.info}');
        expect(ds1.hasValidValues, true);
      }
    });

    test('DS fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDSList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final ur1 = DStag.fromBytes(PTag.kSelectorDSValue, bytes0);
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
          final ur1 = DStag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(ur1, isNull);

          global.throwOnError = true;
          expect(() => DStag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      }
    });

    test('DS make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final make0 = DStag.fromValues(PTag.kPatientSize, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        global.throwOnError = false;
        final make1 = DStag.fromValues(PTag.kPatientSize, <String>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<String>[]));
      }
    });

    test('DS make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        global.throwOnError = false;
        final make0 = DStag.fromValues(PTag.kPatientSize, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => DStag.fromValues(PTag.kPatientSize, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      /*final make1 = DStag.fromValues(PTag.kSelectorDSValue, <String>[null]);
      log.debug('make1: $make1');
      expect(make1, isNull);*/

      global.throwOnError = true;
      expect(() => DStag.fromValues(PTag.kPatientSize, <String>[null]),
          throwsA(const isInstanceOf<FormatException>()));
    });

    test('DS checkLength good values', () {
      final vList0 = rsg.getDSList(1, 1);
      final ds0 = new DStag(PTag.kSamplingFrequency, vList0);
      for (var s in goodDSList) {
        expect(ds0.checkLength(s), true);
      }
      final ds1 = new DStag(PTag.kSamplingFrequency, vList0);
      expect(ds1.checkLength([]), true);
    });

    test('DS checkLength bad values', () {
      final vList0 = rsg.getDSList(1, 1);
      final vList1 = ['+8', '-6.1e-1'];
      final ds2 = new DStag(PTag.kPatientSize, vList0);
      expect(ds2.checkLength(vList1), false);
    });

    test('DS checkValue good values', () {
      final vList0 = rsg.getDSList(1, 1);
      final ds0 = new DStag(PTag.kPatientSize, vList0);
      for (var s in goodDSList) {
        for (var a in s) {
          expect(ds0.checkValue(a), true);
        }
      }
    });
    test('DS checkValue bad values', () {
      final vList0 = rsg.getDSList(1, 1);
      final ds0 = new DStag(PTag.kPatientSize, vList0);
      for (var s in badDSList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(ds0.checkValue(a), false);
        }
      }
    });
  });

  group('DS Element', () {
    //VM.k1
    const dsTags0 = const <PTag>[
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
    const dsTags1 = const <PTag>[
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
    const dsTags2 = const <PTag>[PTag.kGridFrameOffsetVector, PTag.kDVHData];

    //VM.k3
    const dsTags3 = const <PTag>[
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
    const dsTags4 = const <PTag>[
      PTag.kLeafPositionBoundaries,
      PTag.kContourData
    ];

    //VM.k4
    const dsTags5 = const <PTag>[
      PTag.kDoubleExposureFieldDeltaTrial,
      PTag.kDiaphragmPosition
    ];

    //VM.k6
    const dsTags6 = const <PTag>[
      PTag.kPRCSToRCSOrientation,
      PTag.kImageTransformationMatrix,
      PTag.kImageOrientation,
      PTag.kImageOrientationPatient,
      PTag.kImageOrientationSlide
    ];

    //VM.k1_n
    const dsTags7 = const <PTag>[
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

    final invalidVList = rsg.getDSList(DS.kMaxLength + 1, DS.kMaxLength + 1);

    test('DS isValidTag good values', () {
      global.throwOnError = false;
      expect(DS.isValidTag(PTag.kSelectorDSValue), true);

      for (var tag in dsTags0) {
        final validT0 = DS.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('DS isValidTag bad values', () {
      global.throwOnError = false;
      expect(DS.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => DS.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = DS.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => DS.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

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

    test('DS isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(DS.isValidVRIndex(kDSIndex), true);

      for (var tag in dsTags0) {
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

      for (var tag in otherTags) {
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

      for (var tag in dsTags0) {
        expect(DS.isValidVRCode(tag.vrCode), true);
      }
    });

    test('DS isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(DS.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => DS.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
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

    test('DS isNotValidVFLength good values', () {
      expect(DS.isNotValidVFLength(DS.kMaxVFLength), false);
      expect(DS.isNotValidVFLength(0), false);
    });

    test('DS isNotValidVFLength bad values', () {
      expect(DS.isNotValidVFLength(DS.kMaxVFLength + 1), true);
      expect(DS.isNotValidVFLength(-1), true);
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
      for (var s in badDSLengthValues) {
        for (var a in s) {
          log.debug(a);
          expect(DS.isValidValueLength(a), false);
        }
      }
      expect(DS.isValidValueLength('15428.2342342432432'), false);
    });

    test('DS isNotValidValueLength good values', () {
      for (var s in goodDSList) {
        for (var a in s) {
          expect(DS.isNotValidValueLength(a), false);
        }
      }
    });

    test('DS isNotValidValueLength bad values', () {
      for (var s in badDSLengthValues) {
        for (var a in s) {
          expect(DS.isNotValidValueLength(a), true);
        }
      }
    });

    test('DS isValidVListLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(1, 1);
        for (var tag in dsTags0) {
          expect(DS.isValidVListLength(tag, validMinVList), true);

          expect(
              DS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              DS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('DS isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getDSList(2, i + 1);
        for (var tag in dsTags0) {
          global.throwOnError = false;
          expect(DS.isValidVListLength(tag, validMinVList), false);

          expect(DS.isValidVListLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => DS.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k2 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(2, 2);
        for (var tag in dsTags1) {
          expect(DS.isValidVListLength(tag, validMinVList), true);

          expect(
              DS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              DS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('DS isValidVListLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList = rsg.getDSList(3, i + 1);
        for (var tag in dsTags1) {
          global.throwOnError = false;
          expect(DS.isValidVListLength(tag, validMinVList), false);

          expect(DS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 1)),
              false);
          expect(DS.isValidVListLength(tag, invalidVList.take(tag.vmMin - 1)),
              false);

          expect(DS.isValidVListLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => DS.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k2_2n good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(10, 10);
        final validMaxLengthList = invalidVList.sublist(0, DS.kMaxLength);
        for (var tag in dsTags2) {
          expect(DS.isValidVListLength(tag, validMinVList), true);

          expect(DS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 3)),
              true);
          expect(DS.isValidVListLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('DS isValidVListLength VM.k2_2n bad values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(1, 1);
        for (var tag in dsTags2) {
          global.throwOnError = false;
          expect(DS.isValidVListLength(tag, validMinVList), false);

          expect(DS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 2)),
              false);
          global.throwOnError = true;
          expect(() => DS.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k3 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(3, 3);
        for (var tag in dsTags3) {
          expect(DS.isValidVListLength(tag, validMinVList), true);

          expect(
              DS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              DS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('DS isValidVListLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final validMinVList = rsg.getDSList(4, i + 1);
        for (var tag in dsTags3) {
          global.throwOnError = false;
          expect(DS.isValidVListLength(tag, validMinVList), false);

          expect(DS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 1)),
              false);
          expect(DS.isValidVListLength(tag, invalidVList.take(tag.vmMin - 1)),
              false);
          expect(DS.isValidVListLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => DS.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k3_3n good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(9, 9);
        for (var tag in dsTags4) {
          expect(DS.isValidVListLength(tag, validMinVList), true);

          expect(DS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 4)),
              true);
        }
      }
    });

    test('DS isValidVListLength VM.k3_3n bad values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(1, 1);
        for (var tag in dsTags4) {
          global.throwOnError = false;
          expect(DS.isValidVListLength(tag, validMinVList), false);

          expect(DS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 2)),
              false);

          global.throwOnError = true;
          expect(() => DS.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k4 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(4, 4);
        for (var tag in dsTags5) {
          expect(DS.isValidVListLength(tag, validMinVList), true);

          expect(
              DS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              DS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('DS isValidVListLength VM.k4 bad values', () {
      for (var i = 4; i < 10; i++) {
        final validMinVList = rsg.getDSList(5, i + 1);
        for (var tag in dsTags5) {
          global.throwOnError = false;
          expect(DS.isValidVListLength(tag, validMinVList), false);

          expect(DS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 1)),
              false);
          expect(DS.isValidVListLength(tag, invalidVList.take(tag.vmMin - 1)),
              false);
          expect(DS.isValidVListLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => DS.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k6 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(6, 6);
        for (var tag in dsTags6) {
          expect(DS.isValidVListLength(tag, validMinVList), true);

          expect(
              DS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              DS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('DS isValidVListLength VM.k6 bad values', () {
      for (var i = 6; i < 10; i++) {
        final validMinVList = rsg.getDSList(7, i + 1);
        for (var tag in dsTags6) {
          global.throwOnError = false;
          expect(DS.isValidVListLength(tag, validMinVList), false);

          expect(DS.isValidVListLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => DS.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getDSList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, DS.kMaxLength);
        for (var tag in dsTags7) {
          log.debug('tag: $tag');
          expect(DS.isValidVListLength(tag, validMinVList0), true);
          expect(DS.isValidVListLength(tag, validMaxLengthList), true);
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
      final vList0 = rsg.getDSList(1, 1);
      final bytes0 = Bytes.fromAsciiList(vList0);
      log.debug('DS.toBytes(vList0): $bytes0');
      if (vList0[0].length.isOdd) vList0[0] = '${vList0[0]} ';
      log.debug('vList1:"$vList0"');
      final values = ascii.encode(vList0[0]);
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

    test('DS isValidValues goood values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getDSList(1, 1);
        expect(DS.isValidValues(PTag.kSelectorDSValue, vList), vList);
      }
      for (var s in goodDSList) {
        global.throwOnError = false;
        expect(DS.isValidValues(PTag.kSelectorDSValue, s), s);
      }
      final vList0 = ['-6.1e-1'];
      expect(DS.isValidValues(PTag.kSelectorDSValue, vList0), vList0);
    });

    test('DS isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['\b'];
      expect(DS.isValidValues(PTag.kSelectorDSValue, vList1), isNull);

      global.throwOnError = true;
      expect(() => DS.isValidValues(PTag.kSelectorDSValue, vList1),
          throwsA(const isInstanceOf<StringError>()));

      for (var s in badDSList) {
        global.throwOnError = false;
        expect(DS.isValidValues(PTag.kSelectorDSValue, s), isNull);

        global.throwOnError = true;
        expect(() => DS.isValidValues(PTag.kSelectorDSValue, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('DS isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badDSLengthList) {
        global.throwOnError = false;
        expect(DS.isValidValues(PTag.kPatientSize, s), isNull);

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
        final fbd0 = Bytes.fromByteData(bd0.bd);
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
        final sList0 = rsg.getDSList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(sList0);
        final bytes0 = Bytes.fromAscii(sList0.join('\\'));
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

  const goodIntegerStrings = const <String>[
    '+8',
    ' +8',
    '+8 ',
    ' +8 ',
    '-8',
    ' -8',
    '-8 ',
    ' -8 ',
    '-6',
    '560',
    '0',
    '-67',
  ];

  group('Integer String Tests', () {
    test('Is valid integer string -  good values', () {
      global.level = Level.info;
      for (var s in goodIntegerStrings) {
        global.throwOnError = false;
        log.debug('s: "$s"');
        final n = IS.tryParse(s);
        log.debug('n: $n');
        expect(n, isNotNull);
        expect(DS.isValidValue(s), true);
      }
    });
  });

  const goodISList = const <List<String>>[
    const <String>['+8'],
    const <String>['-6'],
    const <String>['560'],
    const <String>['0'],
    const <String>['-67'],
  ];
  const badISList = const <List<String>>[
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
    const <String>['abc'],
    const <String>['23.34']
  ];

  const badISLengthValues = const <List<String>>[
    const <String>['+823434534645645654'],
    const <String>['234345343400098090'],
  ];

  const badISLengthList = const <List<String>>[
    const <String>['+823434534645645654', '823434534645645654'],
    const <String>['234345343400098090', '35345435']
  ];

  group('IStag', () {
    test('IS hasValidValues good values', () {
      for (var s in goodISList) {
        global.throwOnError = false;
        final is0 = new IStag(PTag.kSeriesNumber, s);
        expect(is0.hasValidValues, true);
      }

      final is1 = new IStag(PTag.kOtherStudyNumbers, []);
      expect(is1.hasValidValues, true);
      expect(is1.values, equals(<String>[]));
    });

    test('IS hasValidValues bad values', () {
      for (var s in badISList) {
        global.throwOnError = false;
        final is0 = new IStag(PTag.kSeriesNumber, s);
        expect(is0, isNull);

        global.throwOnError = true;
        expect(() => new IStag(PTag.kSeriesNumber, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });
    test('IS hasValidValues good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final is0 = new IStag(PTag.kSeriesNumber, vList0);
        log.debug('is0:${is0.info}');
        expect(is0.hasValidValues, true);

        log
          ..debug('is0: $is0, values: ${is0.values}')
          ..debug('is0: ${is0.info}');
        expect(is0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final is0 = new IStag(PTag.kAcquisitionNumber, vList0);
        expect(is0.hasValidValues, true);

        log
          ..debug('is0: $is0, values: ${is0.values}')
          ..debug('is0: ${is0.info}');
        expect(is0[0], equals(vList0[0]));
      }
    });

    test('IS hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getISList(3, 4);
        log.debug('$i: vList0: $vList0');
        final is0 = new IStag(PTag.kSeriesNumber, vList0);
        expect(is0, isNull);

        global.throwOnError = true;
        expect(() => new IStag(PTag.kSeriesNumber, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final is1 = new IStag(PTag.kOtherStudyNumbers, null);
      log.debug('is1: $is1');
      expect(is1, isNull);

      global.throwOnError = true;
      expect(() => new IStag(PTag.kOtherStudyNumbers, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('IS update random', () {
      global.throwOnError = false;
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

    test('IS hashCode and == good values random', () {
      List<String> stringList0;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getISList(1, 1);
        final is0 = new IStag(PTag.kMemoryAllocation, stringList0);
        final is1 = new IStag(PTag.kMemoryAllocation, stringList0);
        log
          ..debug('stringList0:$stringList0, is0.hash_code:${is0.hashCode}')
          ..debug('stringList0:$stringList0, is1.hash_code:${is1.hashCode}');
        expect(is0.hashCode == is1.hashCode, true);
        expect(is0 == is1, true);
      }
    });

    test('IS hashCode and == bad  values random', () {
      global.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;
      List<String> stringList4;
      List<String> stringList5;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getISList(1, 1);
        final is0 = new IStag(PTag.kMemoryAllocation, stringList0);
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

        stringList5 = rsg.getISList(2, 3);
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
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        final is0 = new IStag(PTag.kPresentationPixelAspectRatio, vList0);
        expect(is0.tag.isValidLength(is0.length), true);
      }
    });

    test('IS isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        final is0 = new IStag(PTag.kPresentationPixelAspectRatio, vList0);
        expect(is0.checkValues(is0.values), true);
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
      global.throwOnError = false;
      final vList1 = rsg.getISList(2, 2);
      final is0 = new IStag(PTag.kPresentationPixelSpacing, vList1);
      expect(is0, isNull);
    });

    test('IS fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getISList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final is1 = IStag.fromBytes(PTag.kWaveformChannelNumber, bytes);
        log.debug('is1: ${is1.info}');
        expect(is1.hasValidValues, true);
      }
    });

    test('IS fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getISList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final ur1 = IStag.fromBytes(PTag.kSelectorISValue, bytes0);
          log.debug('ur1: ${ur1.info}');
          expect(ur1.hasValidValues, true);
        }
      }
    });

    test('IS fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getISList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final ur1 = IStag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(ur1, isNull);

          global.throwOnError = true;
          expect(() => IStag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      }
    });

    test('IS make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final make0 = IStag.fromValues(PTag.kWaveformChannelNumber, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        global.throwOnError = false;
        final make1 = IStag.fromValues(PTag.kWaveformChannelNumber, <String>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<String>[]));
      }
    });

    test('IS make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        global.throwOnError = false;
        final make0 = IStag.fromValues(PTag.kWaveformChannelNumber, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => IStag.fromValues(PTag.kWaveformChannelNumber, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = true;
      expect(
          () => IStag.fromValues(PTag.kWaveformChannelNumber, <String>[null]),
          throwsA(const isInstanceOf<FormatException>()));
    });

    test('IS checkLength good values', () {
      final vList0 = rsg.getISList(1, 1);
      final is0 = new IStag(PTag.kWaveformChannelNumber, vList0);
      for (var s in goodISList) {
        expect(is0.checkLength(s), true);
      }
      final is1 = new IStag(PTag.kWaveformChannelNumber, vList0);
      expect(is1.checkLength([]), true);
    });

    test('IS checkLength bad values', () {
      final vList0 = rsg.getISList(1, 1);
      final vList1 = ['+8', '-6'];
      final is0 = new IStag(PTag.kStopTrim, vList0);
      expect(is0.checkLength(vList1), false);
    });

    test('IS checkValue good values', () {
      final vList0 = rsg.getISList(1, 1);
      final is0 = new IStag(PTag.kStopTrim, vList0);
      for (var s in goodISList) {
        for (var a in s) {
          expect(is0.checkValue(a), true);
        }
      }
    });

    test('IS checkValue bad values', () {
      final vList0 = rsg.getISList(1, 1);
      final is0 = new IStag(PTag.kStopTrim, vList0);
      for (var s in badISList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(is0.checkValue(a), false);
        }
      }
    });

    test('IS hashStringList', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      final is0 = new IStag(PTag.kEchoNumbers);
      expect(is0.hashStringList(vList0), isNotNull);
    });
  });

  group('IS Element', () {
    //VM.k1
    const isTags0 = const <PTag>[
      PTag.kStageNumber,
      PTag.kNumberOfStages,
      PTag.kViewNumber,
      PTag.kNumberOfViewsInStage,
      PTag.kStartTrim,
      PTag.kStopTrim,
      PTag.kEvaluatorNumber,
      PTag.kNumberOfContourPoints,
      PTag.kObservationNumber,
      PTag.kCurrentFractionNumber,
    ];

    //VM.k2
    const isTags1 = const <PTag>[
      PTag.kCenterOfCircularShutter,
      PTag.kCenterOfCircularCollimator,
      PTag.kGridAspectRatio,
      PTag.kPixelAspectRatio,
      PTag.kAxialMash,
      PTag.kPresentationPixelAspectRatio,
    ];

    //VM.k2_2n
    const isTags2 = const <PTag>[
      PTag.kVerticesOfThePolygonalShutter,
      PTag.kVerticesOfThePolygonalCollimator,
      PTag.kVerticesOfTheOutlineOfPupil,
    ];

    //VM.k3
    const isTags3 = const <PTag>[
      PTag.kROIDisplayColor,
    ];

    //VM.k1_n
    const isTags4 = const <PTag>[
      PTag.kReferencedFrameNumber,
      PTag.kTransformOrderOfAxes,
      PTag.kEchoNumbers,
      PTag.kUpperLowerPixelValues,
      PTag.kSelectorISValue,
      PTag.kSelectorSequencePointerItems,
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

    final invalidVList = rsg.getISList(IS.kMaxLength + 1, IS.kMaxLength + 1);

    test('IS isValidTag good values', () {
      global.throwOnError = false;
      expect(IS.isValidTag(PTag.kSelectorISValue), true);

      for (var tag in isTags0) {
        final validT0 = IS.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('IS isValidTag bad values', () {
      global.throwOnError = false;
      expect(IS.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => IS.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = IS.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => IS.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('IS checkVRIndex good values', () {
      global.throwOnError = false;
      expect(IS.checkVRIndex(kISIndex), kISIndex);

      for (var tag in isTags0) {
        global.throwOnError = false;
        expect(IS.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('IS checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          IS.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => IS.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(IS.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => IS.checkVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('IS checkVRCode good values', () {
      global.throwOnError = false;
      expect(IS.checkVRCode(kISCode), kISCode);

      for (var tag in isTags0) {
        global.throwOnError = false;
        expect(IS.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('IS checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          IS.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => IS.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(IS.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => IS.checkVRCode(kAECode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('IS isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(IS.isValidVRIndex(kISIndex), true);

      for (var tag in isTags0) {
        global.throwOnError = false;
        expect(IS.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('IS isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(IS.isValidVRIndex(kSSIndex), false);

      global.throwOnError = true;
      expect(() => IS.isValidVRIndex(kSSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(IS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => IS.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('IS isValidVRCode good values', () {
      global.throwOnError = false;
      expect(IS.isValidVRCode(kISCode), true);

      for (var tag in isTags0) {
        expect(IS.isValidVRCode(tag.vrCode), true);
      }
    });

    test('IS isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(IS.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => IS.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(IS.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => IS.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('IS isValidVFLength good values', () {
      expect(IS.isValidVFLength(IS.kMaxVFLength), true);
      expect(IS.isValidVFLength(0), true);
    });

    test('IS isValidVFLength bad values', () {
      expect(IS.isValidVFLength(IS.kMaxVFLength + 1), false);
      expect(IS.isValidVFLength(-1), false);
    });

    test('IS isNotValidVFLength good values', () {
      expect(IS.isNotValidVFLength(IS.kMaxVFLength), false);
      expect(IS.isNotValidVFLength(0), false);
    });

    test('IS isNotValidVFLength bad values', () {
      expect(IS.isNotValidVFLength(IS.kMaxVFLength + 1), true);
      expect(IS.isNotValidVFLength(-1), true);
    });

    test('IS isValidVListLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getISList(1, 1);
        for (var tag in isTags0) {
          expect(IS.isValidVListLength(tag, validMinVList), true);

          expect(
              IS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              IS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('IS isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getISList(2, i + 1);
        for (var tag in isTags0) {
          global.throwOnError = false;
          expect(IS.isValidVListLength(tag, validMinVList), false);

          expect(IS.isValidVListLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => IS.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('IS isValidVListLength VM.k2 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getISList(2, 2);
        for (var tag in isTags1) {
          expect(IS.isValidVListLength(tag, validMinVList), true);

          expect(
              IS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              IS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('IS isValidVListLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList = rsg.getISList(3, i + 1);
        for (var tag in isTags1) {
          global.throwOnError = false;
          expect(IS.isValidVListLength(tag, validMinVList), false);

          expect(IS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 1)),
              false);
          expect(IS.isValidVListLength(tag, invalidVList.take(tag.vmMin - 1)),
              false);

          expect(IS.isValidVListLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => IS.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('IS isValidVListLength VM.k2_2n good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getISList(10, 10);
        final validMaxLengthList = invalidVList.sublist(0, IS.kMaxLength);
        for (var tag in isTags2) {
          expect(IS.isValidVListLength(tag, validMinVList), true);

          expect(IS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 3)),
              true);
          expect(IS.isValidVListLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('IS isValidVListLength VM.k2_2n bad values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getISList(1, 1);
        for (var tag in isTags2) {
          global.throwOnError = false;
          expect(IS.isValidVListLength(tag, validMinVList), false);

          expect(IS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 2)),
              false);
          global.throwOnError = true;
          expect(() => IS.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('IS isValidVListLength VM.k3 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getISList(3, 3);
        for (var tag in isTags3) {
          expect(IS.isValidVListLength(tag, validMinVList), true);

          expect(
              IS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              IS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('IS isValidVListLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final validMinVList = rsg.getISList(4, i + 1);
        for (var tag in isTags3) {
          global.throwOnError = false;
          expect(IS.isValidVListLength(tag, validMinVList), false);

          expect(IS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 1)),
              false);
          expect(IS.isValidVListLength(tag, invalidVList.take(tag.vmMin - 1)),
              false);
          expect(IS.isValidVListLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => IS.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('IS isValidVListLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getISList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, IS.kMaxLength);
        for (var tag in isTags4) {
          log.debug('tag: $tag');
          expect(IS.isValidVListLength(tag, validMinVList0), true);
          expect(IS.isValidVListLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('IS isValidValueLength good values', () {
      for (var s in goodISList) {
        for (var a in s) {
          expect(IS.isValidValueLength(a), true);
        }
      }
    });

    test('IS isValidValueLength bad values', () {
      for (var s in badISLengthValues) {
        for (var a in s) {
          expect(IS.isValidValueLength(a), false);
        }
      }
    });

    test('IS isNotValidValueLength good values', () {
      for (var s in goodISList) {
        for (var a in s) {
          expect(IS.isNotValidValueLength(a), false);
        }
      }
    });

    test('IS isNotValidValueLength bad values', () {
      for (var s in badISLengthValues) {
        for (var a in s) {
          expect(IS.isNotValidValueLength(a), true);
        }
      }
    });

    test('IS isValidValue good values', () {
      for (var s in goodISList) {
        for (var a in s) {
          expect(IS.isValidValue(a), true);
        }
      }
    });

    test('IS isValidValue bad values', () {
      for (var s in badISList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(IS.isValidValue(a), false);
        }
      }
    });

    test('IS isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodISList) {
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), true);
      }
    });

    test('IS isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badISList) {
        global.throwOnError = false;
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), false);

        global.throwOnError = true;
        expect(() => IS.isValidValues(PTag.kBeamOrderIndexTrial, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('IS isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badISLengthList) {
        global.throwOnError = false;
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), false);

        global.throwOnError = true;
        expect(() => IS.isValidValues(PTag.kBeamOrderIndexTrial, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('IS fromAsciiList', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getISList(1, 1);
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('toUint8Listbytes): ${Bytes.from(bytes)}, bytes: $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('Bytes.fromAsciiList', () {
      final vList1 = rsg.getISList(1, 1);
      log.debug('Bytes.fromAsciiList(vList1): ${Bytes.fromAsciiList(vList1)}');
      final val = ascii.encode('s6V&:;s%?Q1g5v');
      expect(Bytes.fromAsciiList(['s6V&:;s%?Q1g5v']), equals(val));

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ascii.encode(vList1[0]);
      expect(Bytes.fromAsciiList(vList1), equals(values));
    });

    test('IS tryParse', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      expect(IS.tryParse(vList0[0]), int.parse(vList0[0]));

      const vList1 = '123';
      expect(IS.tryParse(vList1), int.parse(vList1));

      const vList2 = '12.34';
      expect(IS.tryParse(vList2), isNull);

      const vList3 = 'abc';
      expect(IS.tryParse(vList3), isNull);

      global.throwOnError = true;
      expect(() => IS.tryParse(vList3),
          throwsA(const isInstanceOf<StringError>()));
    });

    test('IS tryParseList', () {
      global.throwOnError = false;
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

      global.throwOnError = true;
      expect(() => IS.tryParseList(vList3),
          throwsA(const isInstanceOf<StringError>()));
    });

    test('IS parseBytes', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      final bytes0 = Bytes.fromAsciiList(vList0);
      final parse0 = int.parse(vList0[0]);
      expect(IS.tryParseBytes(bytes0), [parse0]);

      final vList1 = ['123'];
      final bytes1 = Bytes.fromAsciiList(vList1);
      final parse1 = int.parse(vList1[0]);
      expect(IS.tryParseBytes(bytes1), <int>[parse1]);

      final vList2 = ['12.34'];
      final bytes2 = Bytes.fromAsciiList(vList2);
      expect(IS.tryParseBytes(bytes2), isNull);

      final vList3 = ['abc'];
      final bytes3 = Bytes.fromAsciiList(vList3);
      expect(IS.tryParseBytes(bytes3), isNull);

      global.throwOnError = true;
      expect(() => IS.tryParseBytes(bytes3),
          throwsA(const isInstanceOf<StringError>()));
    });

    test('IS validateValueField', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      final bytes0 = Bytes.fromAsciiList(vList0);
      expect(IS.validateValueField(bytes0), vList0);

      final vList1 = ['123'];
      final bytes1 = Bytes.fromAsciiList(vList1);
      expect(IS.validateValueField(bytes1), vList1);

      final vList2 = ['12.34'];
      final bytes2 = Bytes.fromAsciiList(vList2);
      expect(IS.validateValueField(bytes2), vList2);

      final vList3 = ['abc'];
      final bytes3 = Bytes.fromAsciiList(vList3);
      expect(IS.validateValueField(bytes3), vList3);
    });

    test('IS isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getISList(1, 1);
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, vList), vList);
      }

      final vList0 = ['560'];
      expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, vList0), vList0);

      for (var s in goodISList) {
        global.throwOnError = false;
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), s);
      }
    });

    test('IS isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['\b'];
      expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, vList1), isNull);

      global.throwOnError = true;
      expect(() => IS.isValidValues(PTag.kBeamOrderIndexTrial, vList1),
          throwsA(const isInstanceOf<StringError>()));

      for (var s in badISList) {
        global.throwOnError = false;
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), isNull);

        global.throwOnError = true;
        expect(() => IS.isValidValues(PTag.kBeamOrderIndexTrial, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('IS isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badISLengthList) {
        global.throwOnError = false;
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), isNull);

        global.throwOnError = true;
        expect(() => IS.isValidValues(PTag.kBeamOrderIndexTrial, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('IS toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        global.throwOnError = false;
        final values = ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug(
          'tbd0: ${tbd0.buffer.asUint8List()}, values: $values',
        );
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodISList) {
        for (var a in s) {
          final values = ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('IS fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = Bytes.from(bd0);
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodISList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = Bytes.from(bd0);
        expect(fbd0, equals(s));
      }
    });

    test('IS toBytes ', () {
      for (var i = 0; i < 10; i++) {
        final sList0 = rsg.getISList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(sList0);
        final bytes0 = Bytes.fromAscii(sList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodISList) {
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
