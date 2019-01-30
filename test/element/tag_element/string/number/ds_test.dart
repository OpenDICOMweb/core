//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';
import 'package:decimal/decimal.dart';

RSG rsg = RSG(seed: 1);
RNG rng = RNG(1);

void main() {
  Server.initialize(name: 'string/ds_test', level: Level.info);
  global.throwOnError = false;

  const goodDecimalStrings = <String>[
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

  const goodDSList = <List<String>>[
    <String>['0.7591109678'],
    <String>['-6.1e-1'],
    <String>[' -6.1e-1'],
    <String>['-6.1e-1'],
    <String>['560'],
    <String>[' -6.60'],
    <String>['+1.5e-1'],
  ];

  const badDSList = <List<String>>[
    <String>['\b'],
    //	Backspace
    <String>['\t '],
    //horizontal tab (HT)
    <String>['\n'],
    //linefeed (LF)
    <String>['\f '],
    // form feed (FF)
    <String>['\r '],
    //carriage return (CR)
    <String>['\v'],
    //vertical tab
    <String>[r'\'],
    <String>['B\\S'],
    <String>['1\\9'],
    <String>['a\\4'],
    <String>[r'^`~\\?'],
    <String>[r'^\?'],
    <String>['abc']
  ];

  const badDSLengthValues = <List<String>>[
    <String>['0.7591145074654659110'],
    <String>['12393.4563234098903'],
  ];

  const badDSLengthList = <List<String>>[
    <String>['0.7591109678', '0.7591109678'],
    <String>['-6.1e-1', '123.75934548'],
    <String>['-6.1e-1', '103.75548', '234.4570'],
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
        final e0 = DStag(PTag.kProcedureStepProgress, s);
        expect(e0.hasValidValues, true);

        final e1 = DStag(PTag.kProcedureStepProgress, []);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('DS hasValidValues bad values', () {
      for (var s in badDSList) {
        global.throwOnError = false;
        final e0 = DStag(PTag.kProcedureStepProgress, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => DStag(PTag.kProcedureStepProgress, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = DStag(PTag.kProcedureStepProgress, null);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => DStag(PTag.kProcedureStepProgress, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('DS hasValidValues good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final e0 = DStag(PTag.kPresentationPixelSpacing, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final e0 = DStag(PTag.kProcedureStepProgress, vList0);
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
        final e0 = DStag(PTag.kProcedureStepProgress, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => DStag(PTag.kProcedureStepProgress, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('DS update random', () {
      global.throwOnError = false;
      final e0 = DStag(PTag.kCompensatorTransmissionData, []);
      expect(e0.update(['325435.7878-', '4545.887+']), isNull);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 4);
        final e1 = DStag(PTag.kCompensatorTransmissionData, vList0);
        final vList1 = rsg.getDSList(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('DS noValues random', () {
      final e0 = DStag(PTag.kProcedureStepProgress, []);
      final DStag dsNoValues = e0.noValues;
      expect(dsNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 4);
        final e0 = DStag(PTag.kCompensatorTransmissionData, vList0);
        log.debug('e0: $e0');
        expect(dsNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('DS copy random', () {
      final e0 = DStag(PTag.kProcedureStepProgress, []);
      final DStag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 4);
        final e2 = DStag(PTag.kCompensatorTransmissionData, vList0);
        final DStag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('DS hashCode and == good values randoom', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getDSList(1, 1);
        final e0 = DStag(PTag.kProcedureStepProgress, vList);
        final e1 = DStag(PTag.kProcedureStepProgress, vList);
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
        final e0 = DStag(PTag.kProcedureStepProgress, vList0);
        final vList1 = rsg.getDSList(1, 1);
        final e1 = DStag(PTag.kCineRelativeToRealTime, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, false);
        expect(e0 == e1, false);

        final vList2 = rsg.getDSList(2, 2);
        final e2 = DStag(PTag.kImagePlanePixelSpacing, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList3 = rsg.getDSList(3, 3);
        final e3 = DStag(PTag.kNormalizationPoint, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList4 = rsg.getDSList(4, 4);
        final e4 = DStag(PTag.kDoubleExposureFieldDeltaTrial, vList4);
        log.debug('vList4:$vList4 , e5.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);

        final vList5 = rsg.getDSList(6, 6);
        final e5 = DStag(PTag.kRTImageOrientation, vList5);
        log.debug('vList5:$vList5 , e6.hash_code:${e5.hashCode}');
        expect(e0.hashCode == e5.hashCode, false);
        expect(e0 == e5, false);

        final vList6 = rsg.getDSList(2, 3);
        final e6 = DStag(PTag.kProcedureStepProgress, vList6);
        log.debug('vList6:$vList6 , e7.hash_code:${e6.hashCode}');
        expect(e0.hashCode == e6.hashCode, false);
        expect(e0 == e6, false);
      }
    });

    test('DS valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final e0 = DStag(PTag.kPresentationPixelSpacing, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('DS isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final e0 = DStag(PTag.kPresentationPixelSpacing, vList0);
        expect(e0.hasValidLength, true);
      }
    });

    test('DS checkValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final e0 = DStag(PTag.kPresentationPixelSpacing, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('DS checkValues bad values random', () {
      final vList0 = rsg.getDSList(1, 1);
      final e1 = DStag(PTag.kProcedureStepProgress, vList0);

      for (var s in badDSList) {
        global.throwOnError = false;
        expect(e1.checkValues(s), false);

        global.throwOnError = true;
        expect(
            () => e1.checkValues(s), throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('DS replace random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final e0 = DStag(PTag.kSamplingFrequency, vList0);
        final vList1 = rsg.getDSList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getDSList(1, 1);
      final e1 = DStag(PTag.kWaveformChannelNumber, vList1);
      expect(e1, isNull);
    });

    test('DS fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDSList(1, 1);
        final bytes = Bytes.asciiFromList(vList1);
        log.debug('bytes:$bytes');
        final e1 = DStag.fromBytes(PTag.kSamplingFrequency, bytes);
        log.debug('e1: ${e1.info}');
        expect(e1.hasValidValues, true);
      }
    });

    test('DS fromValueField', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        log.debug('vList0: $vList0');
        final fvf0 = AsciiString.fromValueField(vList0, k8BitMaxLongVF);
        expect(fvf0, equals(vList0));
      }

      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList1 = rsg.getDSList(1, i);
        final fvf1 = AsciiString.fromValueField(vList1, k8BitMaxLongVF);
        expect(fvf1, equals(vList1));
      }
      global.throwOnError = false;
      final fvf1 = AsciiString.fromValueField(null, k8BitMaxLongLength);
      expect(fvf1, <String>[]);
      expect(fvf1 == kEmptyStringList, true);

      final fvf2 = AsciiString.fromValueField(<String>[], k8BitMaxLongLength);
      expect(fvf2, <String>[]);
      expect(fvf2 == kEmptyStringList, false);
      expect(fvf2.isEmpty, true);

      final fvf3 = AsciiString.fromValueField(<int>[1234], k8BitMaxLongLength);
      expect(fvf3, isNull);

      global.throwOnError = true;
      expect(() => AsciiString.fromValueField(<int>[1234], k8BitMaxLongLength),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      final vList2 = rsg.getCSList(1, 1);
      final bytes = Bytes.utf8FromList(vList2);
      final fvf4 = AsciiString.fromValueField(bytes, k8BitMaxLongLength);
      expect(fvf4, equals(vList2));
    });

    test('DS fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDSList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.ascii(listS);
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
          final bytes0 = Bytes.ascii(listS);
          final ur1 = DStag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(ur1, isNull);

          global.throwOnError = true;
          expect(() => DStag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
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
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      /*final e1 = DStag.fromValues(PTag.kSelectorDSValue, <String>[null]);
      log.debug('e1: $e1');
      expect(e1, isNull);*/

      global.throwOnError = true;
      expect(() => DStag.fromValues(PTag.kPatientSize, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('DS checkLength good values', () {
      final vList0 = rsg.getDSList(1, 1);
      final e0 = DStag(PTag.kSamplingFrequency, vList0);
      for (var s in goodDSList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = DStag(PTag.kSamplingFrequency, vList0);
      expect(e1.checkLength([]), true);
    });

    test('DS checkLength bad values', () {
      final vList0 = rsg.getDSList(1, 1);
      final vList1 = ['+8', '-6.1e-1'];
      final e2 = DStag(PTag.kPatientSize, vList0);
      expect(e2.checkLength(vList1), false);
    });

    test('DS checkValue good values', () {
      final vList0 = rsg.getDSList(1, 1);
      final e0 = DStag(PTag.kPatientSize, vList0);
      for (var s in goodDSList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });
    test('DS checkValue bad values', () {
      final vList0 = rsg.getDSList(1, 1);
      final e0 = DStag(PTag.kPatientSize, vList0);
      for (var s in badDSList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);
        }
      }
    });

    test('DS compareTo & compareValueTo', () {
      for (var i = 1; i <= 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final e0 = DStag(PTag.kPatientSize, vList0);
        final nList = [double.parse(e0.value)];
        final compare0 = e0.compareValuesTo(nList);
        expect(compare0 == 0, true);
        final e0a = DStag(PTag.kPatientSize, vList0);
        final compare1 = e0.compareTo(e0a);
        expect(compare1 == 0, true);
      }
      for (var vList1 in goodDSList) {
        final e1 = DStag(PTag.kPatientSize, vList1);
        final nList = [double.parse(e1.value)];
        final compare1 = e1.compareValuesTo(nList);
        log.debug('compare1: $compare1');
        expect(compare1 == 0, true);
        final e1a = DStag(PTag.kPatientSize, vList1);
        final compare2 = e1.compareTo(e1a);
        expect(compare2 == 0, true);
      }

      final vList2 = rsg.getDSList(1, 1);
      final e2 = DStag(PTag.kPatientSize, vList2);

      for (var n in goodDecimalStrings) {
        final nList = [double.parse(n)];
        final compare2 = e2.compareValuesTo(nList);
        log.debug('compare2: $compare2');
        if (!compare2.isNegative) {
          expect(compare2 == 1, true);
        } else {
          expect(compare2 == -1, true);
        }
        final e2a = DStag(PTag.kPatientSize, [n]);
        final compare3 = e2.compareTo(e2a);
        if (!compare3.isNegative) {
          expect(compare3 == 1, true);
        } else {
          expect(compare3 == -1, true);
        }
      }

      for (var i = 1; i <= 10; i++) {
        final vList3 = rsg.getDSList(1, i);
        final e3 = DStag(PTag.kSelectorDSValue, vList3);
        final nList = [num.parse(e3.value)];
        final compare3 = e3.compareValuesTo(nList);
        log.debug('compare0: $compare3');
        if (vList3.length > 1) {
          log.debug('compare3: $compare3');
          expect(compare3 == 1, true);
        } else {
          expect(compare3 == 0, true);
        }
        final e3a = DStag(PTag.kSelectorDSValue, vList3);
        final compare4 = e3.compareTo(e3a);
        expect(compare4 == 0, true);
      }

      final e4 = DStag(PTag.kSelectorDSValue, []);
      final compare5 = e4.compareValuesTo([12.6]);
      expect(compare5, -1);

      final e3a = DStag(PTag.kSelectorDSValue, []);
      final compare6 = e4.compareTo(e3a);
      expect(compare6 == 0, true);
    });

    //Urgent Sharath: decide what to do about Decimal. Change print to log.debug
    test('DS increment', () {
      global.throwOnError = true;
      const limit = 10000;

      for (var i = 0; i < limit; i++) {
        final vList0 = rsg.getDSList(1, 1);
        log.debug('vList0: $vList0');
        final e0 = DStag(PTag.kPatientSize, vList0);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        //print(double.parse(e0.value).toStringAsFixed(2));
        final e1 = e0.increment();
        // print(e1);
        log.debug('increment0: $e1');
        expect(e1.hasValidValues, true);
        //expect(e1.values, equals([(double.parse(e0.value) + 1).toString()]));
      }

      // with double
     // print(-0.9 + 1.0); // displays 0.30000000000000004

      // with decimal
     // print(Decimal.parse('0.2') + Decimal.parse('0.1')); // displays 0.3
    });

    test('DS decrement', () {
      global.throwOnError = false;
      final vList0 = rsg.getDSList(1, 1);
      final e0 = DStag(PTag.kPatientSize, vList0);
      final decrement0 = e0.decrement();
      log.debug('decrement0: $decrement0');
      expect(decrement0.hasValidValues, true);
    });

    test('DS append', () {
      final vList = ['111.0'];
      final e0 = DStag(PTag.kPatientSize, vList);
      final append0 = e0.append('123');
      expect(append0, isNotNull);
    });

    test('DS prepend', () {
      final vList = ['111.0'];
      final e0 = DStag(PTag.kPatientSize, vList);
      final prepend0 = e0.prepend('123');
      expect(prepend0, isNotNull);
    });

    test('DS truncate', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 4, 16);
        final e0 = DStag(PTag.kSelectorDSValue, vList0);
        final truncate0 = e0.truncate(10);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('DS match', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 4, 16);
        final e0 = DStag(PTag.kSelectorDSValue, vList0);
        const regX = r'^[0-9\.\+\-]';
        final match0 = e0.match(regX);
        expect(match0, true);
      }
    });

    test('DS check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getDSList(1, 1);
        final e0 = DStag(PTag.kPatientSize, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getDSList(2, 2);
        final e0 = DStag(PTag.kPixelSpacing, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('DS valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getDSList(1, 1);
        final e0 = DStag(PTag.kSelectorDSValue, vList);
        final e1 = DStag(PTag.kSelectorDSValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('DS valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDSList(1, i);
        final vList1 = rsg.getDSList(1, 1);
        final e0 = DStag(PTag.kSelectorDSValue, vList0);
        final e1 = DStag(PTag.kSelectorDSValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });
  });

  group('DS Element', () {
    //VM.k1
    const dsVM1Tags = <PTag>[
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
    const dsVM2Tags = <PTag>[
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
    const dsVM22nTags = <PTag>[PTag.kDVHData];

    //VM.k3
    const dsVM3Tags = <PTag>[
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
    const dsVM3_3nTags = <PTag>[
      PTag.kLeafPositionBoundaries,
      PTag.kContourData
    ];

    //VM.k4
    const dsVM4Tags = <PTag>[
      PTag.kDoubleExposureFieldDeltaTrial,
      PTag.kDiaphragmPosition
    ];

    //VM.k6
    const dsVM6Tags = <PTag>[
      PTag.kPRCSToRCSOrientation,
      PTag.kImageTransformationMatrix,
      PTag.kImageOrientation,
      PTag.kImageOrientationPatient,
      PTag.kImageOrientationSlide
    ];

    //VM.k1_n
    const dsVM1nTags = <PTag>[
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

    const badDSTags = <PTag>[
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
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in badDSTags) {
        global.throwOnError = false;
        final validT0 = DS.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => DS.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

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
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in badDSTags) {
        global.throwOnError = false;
        expect(DS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => DS.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
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
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in badDSTags) {
        global.throwOnError = false;
        expect(DS.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => DS.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('DS isValidVFLength good values', () {
      expect(DS.isValidVFLength(DS.kMaxVFLength), true);
      expect(DS.isValidVFLength(0), true);

      expect(DS.isValidVFLength(DS.kMaxVFLength, null, PTag.kSelectorDSValue),
          true);
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
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getDSList(1, 1);
      expect(DS.isValidLength(null, vList0), false);

      expect(DS.isValidLength(PTag.kSelectorDSValue, null), isNull);

      global.throwOnError = true;
      expect(() => DS.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => DS.isValidLength(PTag.kSelectorDSValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
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
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k2_2n good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(10, 10);

        for (var tag in dsVM22nTags) {
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
        for (var tag in dsVM22nTags) {
          global.throwOnError = false;
          expect(DS.isValidLength(tag, validMinVList), false);

          expect(
              DS.isValidLength(tag, invalidVList.take(tag.vmMax + 2)), false);
          global.throwOnError = true;
          expect(() => DS.isValidLength(tag, validMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
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
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k3_3n good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getDSList(9, 9);
        for (var tag in dsVM3_3nTags) {
          expect(DS.isValidLength(tag, validMinVList), true);
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
              throwsA(const TypeMatcher<InvalidValuesError>()));
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
              throwsA(const TypeMatcher<InvalidValuesError>()));
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
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('DS isValidVListLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getDSList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, DS.kMaxLength);
        for (var tag in dsVM1nTags) {
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
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('DS isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badDSLengthList) {
        global.throwOnError = false;
        expect(DS.isValidValues(PTag.kPatientSize, s), false);

        global.throwOnError = true;
        expect(() => DS.isValidValues(PTag.kPatientSize, s),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('DS fromUint8List', () {
      //  system.level = Level.info;;
      final vList0 = rsg.getDSList(1, 1);
      final bytes = Bytes.asciiFromList(vList0);
      final vList1 = bytes.stringListFromAscii();
      log.debug('DS.decodeBinaryVF(bytes): $vList1, '
          'bytes: $bytes');
      expect(bytes.stringListFromAscii(), equals(vList0));
    });

    test('DS toBytes', () {
      final vList = rsg.getDSList(1, 1);
      final v = vList[0];
      log.debug('vList0:"$v"');
      final bytes0 = Bytes.asciiFromList(vList);
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
      expect(
          () => DS.tryParse(vList3), throwsA(const TypeMatcher<StringError>()));

      expect(
          () => DS.tryParse(vList7), throwsA(const TypeMatcher<StringError>()));
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
          throwsA(const TypeMatcher<StringError>()));

      expect(() => DS.tryParseList(vList7),
          throwsA(const TypeMatcher<StringError>()));
    });

    test('DS tryParseBytes', () {
      global.throwOnError = false;
      final vList0 = rsg.getDSList(1, 1);
      final parse0 = double.parse(vList0.join('//'));
      final bytes0 = Bytes.asciiFromList(vList0);
      final tpb0 = DS.tryParseBytes(bytes0);
      log.debug('tpb0: $tpb0');
      expect(tpb0, equals([parse0]));

      final vList1 = ['123'];
      final parse1 = double.parse(vList1.join('//'));
      final bytes1 = Bytes.asciiFromList(vList1);
      expect(DS.tryParseBytes(bytes1), <double>[parse1]);

      final vList2 = ['12.34'];
      final parse2 = double.parse(vList2.join('//'));
      final bytes2 = Bytes.asciiFromList(vList2);
      expect(DS.tryParseBytes(bytes2), <double>[parse2]);

      final vList3 = ['abc'];
      final bytes3 = Bytes.asciiFromList(vList3);
      expect(DS.tryParseBytes(bytes3), isNull);

      final vList4 = [' 1245'];
      final parse4 = double.parse(vList4.join('//'));
      final bytes4 = Bytes.asciiFromList(vList4);
      expect(DS.tryParseBytes(bytes4), <double>[parse4]);

      final vList5 = ['1245 '];
      final parse5 = double.parse(vList5.join('//'));
      final bytes5 = Bytes.asciiFromList(vList5);
      expect(DS.tryParseBytes(bytes5), <double>[parse5]);

      final vList6 = [' 1245  '];
      final parse6 = double.parse(vList6.join('//'));
      final bytes6 = Bytes.asciiFromList(vList6);
      expect(DS.tryParseBytes(bytes6), <double>[parse6]);

      final vList7 = ['12 45'];
      final bytes7 = Bytes.asciiFromList(vList7);
      expect(DS.tryParseBytes(bytes7), isNull);

      global.throwOnError = true;
      expect(() => DS.tryParseBytes(bytes3),
          throwsA(const TypeMatcher<StringError>()));

      expect(() => DS.tryParseBytes(bytes7),
          throwsA(const TypeMatcher<StringError>()));
    });

    test('DS validateValueField', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      final bytes0 = Bytes.asciiFromList(vList0);
      expect(DS.validateValueField(bytes0), equals(vList0));

      final vList1 = ['123'];
      final bytes1 = Bytes.asciiFromList(vList1);
      expect(DS.validateValueField(bytes1), equals(vList1));

      final vList2 = ['12.34'];
      final bytes2 = Bytes.asciiFromList(vList2);
      expect(DS.validateValueField(bytes2), equals(vList2));

      final vList3 = ['abc'];
      final bytes3 = Bytes.asciiFromList(vList3);
      expect(DS.validateValueField(bytes3), equals(vList3));
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
          throwsA(const TypeMatcher<StringError>()));

      for (var s in badDSList) {
        global.throwOnError = false;
        expect(DS.isValidValues(PTag.kSelectorDSValue, s), false);

        global.throwOnError = true;
        expect(() => DS.isValidValues(PTag.kSelectorDSValue, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('DS isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badDSLengthList) {
        global.throwOnError = false;
        expect(DS.isValidValues(PTag.kPatientSize, s), false);

        global.throwOnError = true;
        expect(() => DS.isValidValues(PTag.kPatientSize, s),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('DS decodeBinaryStringVF', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getDSList(1, i);
        final bytes = Bytes.asciiFromList(vList1);
        final dbStr0 = bytes.stringListFromAscii();
        log.debug('dbStr0: $dbStr0');
        expect(dbStr0, vList1);

        final dbStr1 = bytes.stringListFromUtf8();
        log.debug('dbStr1: $dbStr1');
        expect(dbStr1, vList1);
      }
      final bytes = Bytes.asciiFromList([]);
      expect(bytes.stringListFromAscii(), <String>[]);
    });

    test('DS toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        global.throwOnError = false;
        final values = ascii.encode(vList0[0]);
        final tbd0 = Bytes.asciiFromList(vList0);
        final tbd1 = Bytes.asciiFromList(vList0);
        log.debug('tbd1: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodDSList) {
        for (var a in s) {
          final values = ascii.encode(a);
          final tbd2 = Bytes.asciiFromList(s);
          final tbd3 = Bytes.asciiFromList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('DS fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.asciiFromList(vList0);
        final fbd0 = bd0.stringListFromAscii();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodDSList) {
        final bd0 = Bytes.asciiFromList(s);
        final fbd0 = bd0.stringListFromAscii();
        expect(fbd0, equals(s));
      }
    });

    test('DS toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.asciiFromList(vList0);
        final bytes0 = Bytes.ascii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodDSList) {
        final toB1 = Bytes.asciiFromList(s);
        final bytes1 = Bytes.ascii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.asciiFromList(['']);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.asciiFromList([]);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.asciiFromList(null);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.asciiFromList(null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('DS isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 15; i++) {
        final vList0 = rsg.getDSList(1, i);
        final vfBytes = Bytes.utf8FromList(vList0);

        if (vList0.length == 1) {
          for (var tag in dsVM1Tags) {
            final e0 = DS.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else if (vList0.length == 2) {
          for (var tag in dsVM2Tags) {
            final e0 = DS.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else if (vList0.length == 3) {
          for (var tag in dsVM3Tags) {
            final e0 = DS.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else if (vList0.length == 4) {
          for (var tag in dsVM4Tags) {
            final e0 = DS.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else if (vList0.length == 6) {
          for (var tag in dsVM6Tags) {
            final e0 = DS.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (var tag in dsVM1nTags) {
            final e0 = DS.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rsg.getDSList(1, 1);
      final vfBytes = Bytes.utf8FromList(vList0);

      final e1 = DS.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = DS.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = DS.isValidBytesArgs(PTag.kSelectorDSValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => DS.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => DS.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
