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

RSG rsg = new RSG(seed: 1);
RNG rng = new RNG(1);

void main() {
  Server.initialize(name: 'string/lt_test', level: Level.info);
  global.throwOnError = false;

  const goodLTList = const <List<String>>[
    const <String>['\t '], //horizontal tab (HT)
    const <String>['\n'], //linefeed (LF)
    const <String>['\f '], // form feed (FF)
    const <String>['\r '], //carriage return (CR)
    const <String>['!mSMXWVy`]/Du'],
    const <String>['`0Y^~x?+]Q91']
  ];
  const badLTList = const <List<String>>[
    const <String>['\b'], //	Backspace
  ];

  group('LTtag', () {
    test('LT decodeBinaryTextVF', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getLTList(1, 1);
        final bytes = Bytes.fromUtf8List(vList1);
        final dbTxt0 = bytes.getUtf8List();
        log.debug('dbTxt0: $dbTxt0');
        expect(dbTxt0, equals(vList1));

        final dbTxt1 = bytes.getUtf8List();
        log.debug('dbTxt1: $dbTxt1');
        expect(dbTxt1, equals(vList1));
      }
    });

    test('LT hasValidValues good values', () {
      for (var s in goodLTList) {
        global.throwOnError = false;
        final e0 = new LTtag(PTag.kAcquisitionProtocolDescription, s);
        expect(e0.hasValidValues, true);
      }
      global.throwOnError = false;
      final e0 = new LTtag(PTag.kImageComments, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('LT hasValidValues bad values', () {
      for (var s in badLTList) {
        global.throwOnError = false;
        final e0 = new LTtag(PTag.kAcquisitionProtocolDescription, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new LTtag(PTag.kAcquisitionProtocolDescription, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('LT hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kAcquisitionProtocolDescription, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }
    });

    test('LT hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getLTList(3, 4);
        log.debug('$i: vList0: $vList0');
        final e1 = new LTtag(PTag.kAcquisitionProtocolDescription, vList0);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => new LTtag(PTag.kAcquisitionProtocolDescription, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = new LTtag(PTag.kImageComments, null);
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => new LTtag(PTag.kAcquisitionProtocolDescription, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('LT update random', () {
      final lt = new LTtag(PTag.kImageComments, []);
      expect(lt.update(['Nm, Bhb/q0Sm']).values, equals(['Nm, Bhb/q0Sm']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e1 = new LTtag(PTag.kImageComments, vList0);
        final vList1 = rsg.getLTList(1, 1);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('LT noValues random', () {
      final e0 = new LTtag(PTag.kImageComments, []);
      final LTtag ltNoValues = e0.noValues;
      expect(ltNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kImageComments, vList0);
        log.debug('e0: $e0');
        expect(ltNoValues.values.isEmpty, true);
        log.debug('as0: ${e0.noValues}');
      }
    });

    test('LT copy random', () {
      final e0 = new LTtag(PTag.kImageComments, []);
      final LTtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e2 = new LTtag(PTag.kImageComments, vList0);
        final LTtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('LT hashCode and == good values random', () {
      log.debug('LT hashCode and == ');
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kImageComments, vList0);
        final e1 = new LTtag(PTag.kImageComments, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('LT hashCode and == bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kImageComments, vList0);
        final vList1 = rsg.getLTList(1, 1);
        final e1 = new LTtag(PTag.kFrameComments, vList1);
        log.debug('vList1:$vList1 , e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, false);
        expect(e0 == e1, false);

        final vList2 = rsg.getLOList(2, 3);
        final e2 = new LTtag(PTag.kImageComments, vList2);
        log.debug('vList2:$vList2 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);
      }
    });

    test('LT valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kImageComments, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('LT isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kImageComments, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('LT isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kImageComments, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('LT replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kImageComments, vList0);
        final vList1 = rsg.getLTList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getLTList(1, 1);
      final e1 = new LTtag(PTag.kImageComments, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new LTtag(PTag.kImageComments, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('LT blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kImageComments, vList1);
        for (var i = 1; i < 10; i++) {
          final blank = e0.blank(i);
          log.debug(('blank$i: ${blank.values}'));
          expect(blank.values.length == 1, true);
          expect(blank.value.length == i, true);
          final strSpaceList = <String>[''.padRight(i, ' ')];
          log.debug('strSpaceList: $strSpaceList');
          expect(blank.values, equals(strSpaceList));
        }
      }
    });

    test('LT fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getLTList(1, 1);
        log.debug('vList1:$vList1');
        final bytes = Bytes.fromUtf8List(vList1);
        log.debug('bytes:$bytes');
        final e0 = LTtag.fromBytes(PTag.kImageComments, bytes);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('LT fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getLTList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e1 = LTtag.fromBytes(PTag.kSelectorLTValue, bytes0);
          log.debug('e1: ${e1.info}');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('LT fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getLTList(1, 10);
        for (var s in vList) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(s);
          final e1 = LTtag.fromBytes(PTag.kSelectorCSValue, bytes0);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => LTtag.fromBytes(PTag.kSelectorCSValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('LT fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = LTtag.fromValues(PTag.kImageComments, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = LTtag.fromValues(PTag.kImageComments, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('LT fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(2, 2);
        global.throwOnError = false;
        final e0 = LTtag.fromValues(PTag.kImageComments, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => LTtag.fromValues(PTag.kImageComments, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = LTtag.fromValues(PTag.kImageComments, <String>[null]);
      log.debug('mak1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => LTtag.fromValues(PTag.kImageComments, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('LT checkLength good values', () {
      final vList0 = rsg.getLTList(1, 1);
      final e0 = new LTtag(PTag.kImageComments, vList0);
      for (var s in goodLTList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new LTtag(PTag.kImageComments, vList0);
      expect(e1.checkLength([]), true);

      final vList1 = rsg.getLTList(1, 1);
      log.debug('vList1: $vList1');
      final e2 = new LTtag(PTag.kExtendedCodeMeaning, vList1);

      for (var s in goodLTList) {
        log.debug('s: "$s"');
        expect(e2.checkLength(s), true);
      }
    });

    test('LT checkLength bad values', () {
      global.throwOnError = false;
      final vList2 = ['\b', '024Y'];
      final e3 = new LTtag(PTag.kImageComments, vList2);
      expect(e3, isNull);
    });

    test('LT checkValue good values', () {
      final vList0 = rsg.getLTList(1, 1);
      final e0 = new LTtag(PTag.kImageComments, vList0);
      for (var s in goodLTList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('LT checkValue bad values', () {
      final vList0 = rsg.getLTList(1, 1);
      final e0 = new LTtag(PTag.kImageComments, vList0);
      for (var s in badLTList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('LT append', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kSelectorLTValue, vList0);
        const vList1 = 'foo';
        final append0 = e0.append(vList1);
        log.debug('append0: $append0');
        expect(append0, isNotNull);
      }
    });

    test('LT prepend', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kSelectorLTValue, vList0);
        const vList1 = 'foo';
        final prepend0 = e0.prepend(vList1);
        log.debug('prepend0: $prepend0');
        expect(prepend0, isNotNull);
      }
    });

    test('LT truncate', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1, 16);
        final e0 = new LTtag(PTag.kSelectorLTValue, vList0);
        final truncate0 = e0.truncate(10);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('LT match', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = new LTtag(PTag.kSelectorLTValue, vList0);
        final match0 = e0.match(r'.*');
        expect(match0, true);
      }
    });

    test('LT valueFromBytes', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final bytes = Bytes.fromUtf8List(vList0);
        final e0 = new LTtag(PTag.kSelectorLTValue, vList0);
        final vfb0 = e0.valuesFromBytes(bytes);
        expect(vfb0, equals(vList0));
      }
    });
  });

  group('LT', () {
    //VM.k1
    const ltVM1Tags = const <PTag>[
      PTag.kIdentifyingComments,
      PTag.kAdditionalPatientHistory,
      PTag.kPatientComments,
      PTag.kMaterialNotes,
      PTag.kCalibrationNotes,
      PTag.kPulserNotes,
      PTag.kReceiverNotes,
      PTag.kPreAmplifierNotes,
      PTag.kProbeDriveNotes,
      PTag.kAcquisitionComments,
      PTag.kDetectorMode,
      PTag.kGridAbsorbingMaterial,
      PTag.kExposureControlModeDescription,
      PTag.kRequestedProcedureComments,
      PTag.kMediaDisposition,
      PTag.kBarcodeValue,
      PTag.kCompensatorDescription,
      PTag.kArbitrary,
      PTag.kTextComments
    ];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kInstructionPerformedDateTime,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    final invalidVList = rsg.getLTList(LT.kMaxLength + 1, LT.kMaxLength + 1);

    test('LT fromBytes', () {
      global.throwOnError = false;
      final vList1 = rsg.getLTList(1, 1);
      final bytes = Bytes.fromUtf8List(vList1);
      log.debug('LT.fromBytes(bytes):  $bytes');
      expect(bytes.getUtf8List(), equals(vList1));
    });

    test('LT isValidTag good values', () {
      global.throwOnError = false;
      expect(LT.isValidTag(PTag.kSelectorLTValue), true);

      for (var tag in ltVM1Tags) {
        final validT0 = LT.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('LT isValidTag bad values', () {
      global.throwOnError = false;
      expect(LT.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => LT.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = LT.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => LT.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('LT isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(LT.isValidVRIndex(kLTIndex), true);

      for (var tag in ltVM1Tags) {
        global.throwOnError = false;
        expect(LT.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('LT isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(LT.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => LT.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(LT.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => LT.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('LT isValidVRCode good values', () {
      global.throwOnError = false;
      expect(LT.isValidVRCode(kLTCode), true);

      for (var tag in ltVM1Tags) {
        expect(LT.isValidVRCode(tag.vrCode), true);
      }
    });

    test('LT isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(LT.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => LT.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(LT.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => LT.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('LT isValidVFLength good values', () {
      expect(LT.isValidVFLength(LT.kMaxVFLength), true);
      expect(LT.isValidVFLength(0), true);

      expect(LT.isValidVFLength(LT.kMaxVFLength, null, PTag.kSelectorLTValue),
          true);
    });

    test('LT isValidVFLength bad values', () {
      expect(LT.isValidVFLength(LT.kMaxVFLength + 1), false);
      expect(LT.isValidVFLength(-1), false);

      expect(LT.isValidVFLength(LT.kMaxVFLength, null, PTag.kSelectorISValue),
          false);
    });

    test('LT isValidValueLength good values', () {
      for (var s in goodLTList) {
        for (var a in s) {
          expect(LT.isValidValueLength(a), true);
        }
      }

      expect(LT.isValidValueLength('a'), true);
    });

    test('LT isValidValueLength bad values', () {
      expect(LT.isValidValueLength(''), true);
    });

    test('LT isNotValidValueLength good values', () {
      for (var s in goodLTList) {
        for (var a in s) {
          expect(LT.isValidValueLength(a), true);
        }
      }
    });

    test('LT isNotValidValueLength bad values', () {
      expect(
          LT.isValidValueLength(
              '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qmczv9LzgGEH6bTY&N}J'),
          true);
    });

    test('LT isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getLTList(1, 1);
        for (var tag in ltVM1Tags) {
          expect(LT.isValidLength(tag, vList), true);

          expect(LT.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(LT.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('LT isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLTList(2, i + 1);
        for (var tag in ltVM1Tags) {
          global.throwOnError = false;
          expect(LT.isValidLength(tag, vList0), false);

          expect(LT.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => LT.isValidLength(tag, vList0),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getLTList(1, 1);
      expect(LT.isValidLength(null, vList0), false);

      expect(LT.isValidLength(PTag.kSelectorLTValue, null), isNull);

      global.throwOnError = true;
      expect(() => LT.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => LT.isValidLength(PTag.kSelectorLTValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('LT isValidValue good values', () {
      for (var s in goodLTList) {
        for (var a in s) {
          expect(LT.isValidValue(a), true);
        }
      }

      for (var s in badLTList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(LT.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => LT.isValidValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('LT isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodLTList) {
        expect(LT.isValidValues(PTag.kExtendedCodeMeaning, s), true);
      }
      for (var s in badLTList) {
        global.throwOnError = false;
        expect(LT.isValidValues(PTag.kExtendedCodeMeaning, s), false);

        global.throwOnError = true;
        expect(() => LT.isValidValues(PTag.kExtendedCodeMeaning, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('LT toUint8List', () {
      final vList1 = rsg.getLTList(1, 1);
      log.debug('Bytes.fromUtf8List(vList1): ${Bytes.fromUtf8List(vList1)}');
      /* final val = ascii.encode('s6V&:;s%?Q1g5v');
        expect(Bytes.fromUtf8List(['s6V&:;s%?Q1g5v']), equals(val));*/
      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ascii.encode(vList1[0]);
      expect(Bytes.fromUtf8List(vList1), equals(values));
    });

    test('LT isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getLTList(1, 1);
        expect(LT.isValidValues(PTag.kExtendedCodeMeaning, vList), true);
      }

      final vList0 = ['!mSMXWVy`]/Du'];
      expect(LT.isValidValues(PTag.kExtendedCodeMeaning, vList0), true);

      final vList1 = ['\b'];
      expect(LT.isValidValues(PTag.kExtendedCodeMeaning, vList1), false);

      global.throwOnError = true;
      expect(() => LT.isValidValues(PTag.kExtendedCodeMeaning, vList1),
          throwsA(const TypeMatcher<StringError>()));

      for (var s in goodLTList) {
        global.throwOnError = false;
        expect(LT.isValidValues(PTag.kExtendedCodeMeaning, s), true);
      }
      for (var s in badLTList) {
        global.throwOnError = false;
        expect(LT.isValidValues(PTag.kExtendedCodeMeaning, s), false);

        global.throwOnError = true;
        expect(() => LT.isValidValues(PTag.kExtendedCodeMeaning, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('LT toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        global.throwOnError = false;
        final values = ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromUtf8List(vList0);
        final tbd1 = Bytes.fromUtf8List(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodLTList) {
        for (var a in s) {
          final values = ascii.encode(a);
          final tbd2 = Bytes.fromUtf8List(s);
          final tbd3 = Bytes.fromUtf8List(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('LT fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final s0 = vList0[0];
        global.throwOnError = false;
        final bytes0 = Bytes.fromUtf8(s0);
        final s1 = bytes0.getUtf8();
        log.debug('s1: $s1, s0: $s0');
        expect(s1, equals(s0));
      }
      for (var vList1 in goodLTList) {
        final s0 = vList1[0];
        final bytes1 = Bytes.fromUtf8(s0);
        final s1 = bytes1.getUtf8();
        expect(s1, equals(s0));
      }
    });

    test('LT toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        global.throwOnError = false;
        final toB0 = Bytes.fromUtf8List(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodLTList) {
        final toB1 = Bytes.fromUtf8List(s, kMaxShortVF);
        final bytes1 = Bytes.fromAscii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      final toB2 = Bytes.fromUtf8List([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.fromUtf8List([], kMaxShortVF);
      expect(toB3, equals(<String>[]));
      global.throwOnError = false;
      final toB4 = Bytes.fromUtf8List(null, kMaxShortVF);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.fromUtf8List(null, kMaxShortVF),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('LT fromValueField', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final fvf0 = Text.fromValueField(vList0, k8BitMaxLongVF);
        expect(fvf0, equals(vList0));
      }

      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList1 = rsg.getLTList(1, i);
        final fvf1 = Text.fromValueField(vList1, k8BitMaxLongVF);
        if (vList1.length == 1) {
          expect(fvf1, equals(vList1));
        } else {
          expect(fvf1, isNull);
          global.throwOnError = true;
          expect(() => Text.fromValueField(vList1, k8BitMaxLongLength),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final fvf1 = Text.fromValueField(null, k8BitMaxLongLength);
      expect(fvf1, <String>[]);
      expect(fvf1 == kEmptyStringList, true);

      final fvf2 = Text.fromValueField(<String>[], k8BitMaxLongLength);
      expect(fvf2, <String>[]);
      expect(fvf2 == kEmptyStringList, false);
      expect(fvf2.isEmpty, true);

      final fvf3 = Text.fromValueField(<int>[1234], k8BitMaxLongLength);
      expect(fvf3, isNull);

      global.throwOnError = true;
      expect(() => Text.fromValueField(<int>[1234], k8BitMaxLongLength),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      final vList2 = rsg.getLTList(1, 1);
      final bytes = Bytes.fromUtf8List(vList2);
      final fvf4 = Text.fromValueField(bytes, k8BitMaxLongLength);
      expect(fvf4, equals(vList2));

      final vList3 = rng.uint8List(1, 1);
      final fvf5 = Text.fromValueField(vList3, k8BitMaxLongLength);
      expect(fvf5, equals([ascii.decode(vList3)]));
    });
  });
}
