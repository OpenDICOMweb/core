// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:convert';

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

import 'utility_test.dart' as utility;

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'string/special_test', level: Level.debug2);
  system.throwOnError = false;

  group('AEtag', () {
    const goodAEList = const <List<String>>[
      const <String>['d9E8tO'],
      const <String>['mrZeo|^P> -6{t, '],
      const <String>['mrZeo|^P> -6{t,'],
      const <String>['1wd7'],
      const <String>['mrZeo|^P> -6{t,']
    ];

    const badAEList = const <List<String>>[
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
      const <String>[r'^\?']
    ];

    const badAELengthList = const <String>[
      'mrZeo|^P> -6{t,mrZeo|^P> -6{t,mrZeo|^P> -6{td9E8tO'
    ];

    test('AE hasValidValues good values', () {
      for (var s in goodAEList) {
        system.throwOnError = false;
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, s);
        expect(ae0.hasValidValues, true);
      }

      system.throwOnError = false;
      final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      expect(ae0.hasValidValues, true);
      expect(ae0.values, equals(<String>[]));
    });

    test('AE hasValidValues bad values', () {
      for (var s in badAEList) {
        system.throwOnError = false;
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, s);
        expect(ae0, isNull);

        system.throwOnError = true;
        expect(() => new AEtag(PTag.kScheduledStudyLocationAETitle, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }

      system.throwOnError = false;
      final ae1 = new AEtag(PTag.kScheduledStudyLocationAETitle, null);
      log.debug('ae1: $ae1');
      expect(ae1, isNull);
    });

    test('AE hasValidValues random good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 10);
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        log.debug('ae0:${ae0.info}');
        expect(ae0.hasValidValues, true);

        log..debug('ae0: $ae0, values: ${ae0.values}')..debug('ae0: ${ae0.info}');
        expect(ae0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final ae1 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(ae1.hasValidValues, true);

        log..debug('ae1: $ae1, values: ${ae1.values}')..debug('ae1: ${ae1.info}');
        expect(ae1[0], equals(vList0[0]));
      }
    });

    test('AE hasValidValues random bad values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final vList0 = rsg.getAEList(3, 4);
        log.debug('$i: vList0: $vList0');
        final ae2 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(ae2, isNull);
      }
    });

    test('AE update random', () {
      final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      expect(ae0.update(['325435', '4545']).values, equals(['325435', '4545']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final ae1 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        final vList1 = rsg.getAEList(3, 4);
        expect(ae1.update(vList1).values, equals(vList1));
      }
    });

    test('AE noValues random', () {
      final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      final AEtag aeNoValues = ae0.noValues;
      expect(aeNoValues.values.isEmpty, true);
      log.debug('ae0: ${ae0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        log.debug('ae0: $ae0');
        expect(aeNoValues.values.isEmpty, true);
        log.debug('ae0: ${ae0.noValues}');
      }
    });

    test('AE copy random', () {
      final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      final AEtag ae1 = ae0.copy;
      expect(ae1 == ae0, true);
      expect(ae1.hashCode == ae0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final ae2 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        final AEtag ae3 = ae2.copy;
        expect(ae3 == ae2, true);
        expect(ae3.hashCode == ae2.hashCode, true);
      }
    });

    test('AE hashCode and == good values random', () {
      List<String> stringList0;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, stringList0);
        final ae1 = new AEtag(PTag.kScheduledStudyLocationAETitle, stringList0);
        log
          ..debug('stringList0:$stringList0, ae0.hash_code:${ae0.hashCode}')
          ..debug('stringList0:$stringList0, ds1.hash_code:${ae1.hashCode}');
        expect(ae0.hashCode == ae1.hashCode, true);
        expect(ae0 == ae1, true);
      }
    });

    test('AE hashCode and == bad values random', () {
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, stringList0);

        stringList1 = rsg.getAEList(1, 1);
        final ae2 = new AEtag(PTag.kPerformedStationAETitle, stringList1);
        log.debug('stringList1:$stringList1 , ae2.hash_code:${ae2.hashCode}');
        expect(ae0.hashCode == ae2.hashCode, false);
        expect(ae0 == ae2, false);

        stringList2 = rsg.getAEList(2, 3);
        final ae3 = new AEtag(PTag.kPerformedStationAETitle, stringList2);
        log.debug('stringList2:$stringList2 , ae3.hash_code:${ae3.hashCode}');
        expect(ae0.hashCode == ae3.hashCode, false);
        expect(ae0 == ae3, false);
      }
    });

    test('AE valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(vList0, equals(ae0.valuesCopy));
      }
    });

    test('AE isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(ae0.tag.isValidLength(ae0.length), true);
      }
    });

    test('AE isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        //Urgent sharath: Fix getAEList()
        //expect(ae0.tag.isValidValues(ae0.values), true);
        expect(ae0.hasValidValues, true);
      }
    });

    test('AE replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        final vList1 = rsg.getAEList(1, 1);
        expect(ae0.replace(vList1), equals(vList0));
        expect(ae0.values, equals(vList1));
      }

      final vList1 = rsg.getAEList(1, 1);
      final ae1 = new AEtag(PTag.kPerformedStationAETitle, vList1);
      expect(ae1.replace([]), equals(vList1));
      expect(ae1.values, equals(<String>[]));

      final ae2 = new AEtag(PTag.kPerformedStationAETitle, vList1);
      expect(ae2.replace(null), equals(vList1));
      expect(ae2.values, equals(<String>[]));
    });

    test('AE blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList1);
        final blank = ae0.blank(i);
        log.debug(('blank$i: ${blank.values}'));
        expect(blank.values.length == 1, true);
        log.debug('value: ${blank.value}');
        expect(blank.value.length == i, true);
        final strSpaceList = <String>[''.padRight(i, ' ')];
        log.debug('strSpaceList: $strSpaceList');
        expect(blank.values, equals(strSpaceList));
      }
    });

    test('AE formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getAEList(1, 1);
        final bytes = AE.toBytes(vList1);
        log.debug('bytes:$bytes');
        final ae1 = new AEtag.fromBytes(PTag.kPerformedStationAETitle, bytes);
        log.debug('ae1: ${ae1.info}');
        expect(ae1.hasValidValues, true);
      }
    });

    test('AE checkLength good values', () {
      final vList0 = rsg.getASList(1, 1);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      for (var s in goodAEList) {
        expect(ae0.checkLength(s), true);
      }
      final ae1 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      expect(ae1.checkLength([]), true);
    });

    test('AE checkLength bad values', () {
      final vList0 = rsg.getASList(1, 1);
      final vList1 = ['325435', '325434'];
      final ae2 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      expect(ae2.checkLength(vList1), false);
    });

    test('AE checkValue good values', () {
      final vList0 = rsg.getASList(1, 1);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      for (var s in goodAEList) {
        for (var a in s) {
          expect(ae0.checkValue(a), true);
        }
      }
    });

    test('AE checkValue bad values', () {
      final vList0 = rsg.getASList(1, 1);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      for (var s in badAEList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(ae0.checkValue(a), false);

          system.throwOnError = true;
          expect(() => ae0.checkValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });

    group('AE ', () {
      //VM.k1
      const aeTags0 = const <PTag>[
        PTag.kNetworkID,
        PTag.kPerformedStationAETitle,
        PTag.kRequestingAE,
        PTag.kOriginator,
        PTag.kDestinationAE,
      ];

      //VM.k1_n
      const aeTags1 = const <PTag>[
        PTag.kRetrieveAETitle,
        PTag.kScheduledStudyLocationAETitle,
        PTag.kScheduledStationAETitle,
        PTag.kSelectorAEValue,
      ];
      const otherTags = const <PTag>[
        PTag.kColumnAngulationPatient,
        PTag.kAcquisitionProtocolDescription,
        PTag.kCTDIvol,
        PTag.kCTPositionSequence,
        PTag.kAcquisitionType,
        PTag.kICCProfile,
        PTag.kSelectorSTValue,
        PTag.kDate,
        PTag.kTime
      ];

      final invalidVList = rsg.getAEList(AE.kMaxLength + 1, AE.kMaxLength + 1);

      test('AE checkVR good values', () {
        system.throwOnError = false;
        expect(AE.checkVRIndex(kAEIndex), kAEIndex);

        for (var tag in aeTags0) {
          system.throwOnError = false;
          expect(AE.checkVRIndex(tag.vrIndex), tag.vrIndex);
        }
      });

      test('AE checkVR bad values', () {
        system.throwOnError = false;
        expect(
            AE.checkVRIndex(
              kSSIndex,
            ),
            isNull);
        system.throwOnError = true;
        expect(() => AE.checkVRIndex(kSSIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(AE.checkVRIndex(tag.vrIndex), isNull);

          system.throwOnError = true;
          expect(() => AE.checkVRIndex(kSSIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('AE isValidVRIndex good values', () {
        system.throwOnError = false;
        expect(AE.isValidVRIndex(kAEIndex), true);

        for (var tag in aeTags0) {
          system.throwOnError = false;
          expect(AE.isValidVRIndex(tag.vrIndex), true);
        }
      });

      test('AE isValidVRIndex bad values', () {
        system.throwOnError = false;
        expect(AE.isValidVRIndex(kCSIndex), false);

        system.throwOnError = true;
        expect(() => AE.isValidVRIndex(kCSIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(AE.isValidVRIndex(tag.vrIndex), false);

          system.throwOnError = true;
          expect(() => AE.isValidVRIndex(tag.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('AE isValidVRCode good values', () {
        system.throwOnError = false;
        expect(AE.isValidVRCode(kAECode), true);

        for (var tag in aeTags0) {
          expect(AE.isValidVRCode(tag.vrCode), true);
        }
      });

      test('AE isValidVRCode bad values', () {
        system.throwOnError = false;
        expect(AE.isValidVRCode(kSSCode), false);

        system.throwOnError = true;
        expect(() => AE.isValidVRCode(kSSCode),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(AE.isValidVRCode(tag.vrCode), false);

          system.throwOnError = true;
          expect(() => AE.isValidVRCode(tag.vrCode),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('AE isValidVFLength good values', () {
        expect(AE.isValidVFLength(AE.kMaxVFLength), true);
        expect(AE.isValidVFLength(0), true);
      });

      test('AE isValidVFLength bad values', () {
        expect(AE.isValidVFLength(AE.kMaxVFLength + 1), false);
        expect(AE.isValidVFLength(-1), false);
      });

      test('AE isNotValidVFLength good values', () {
        expect(AE.isNotValidVFLength(AE.kMaxVFLength), false);
        expect(AE.isNotValidVFLength(0), false);
      });

      test('AE isNotValidVFLength bad values', () {
        expect(AE.isNotValidVFLength(AE.kMaxVFLength + 1), true);
        expect(AE.isNotValidVFLength(-1), true);
      });

      test('AE isValidValueLength good values', () {
        for (var s in goodAEList) {
          for (var a in s) {
            expect(AE.isValidValueLength(a), true);
          }
        }
        expect(AE.isValidValueLength('&t&wSB)~PIA!UIDX'), true);
        expect(AE.isValidValueLength(''), true);
      });

      test('AE isValidValueLength bad values', () {
        for (var s in badAELengthList) {
          expect(AE.isValidValueLength(s), false);
        }

        expect(
            AE.isValidValueLength(
                '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qzD2N3 2fzLzgGEH6bTY&N}JzD2N3 2fz'),
            false);
      });

      test('AE isNotValidValueLength good values', () {
        for (var s in goodAEList) {
          for (var a in s) {
            expect(AE.isNotValidValueLength(a), false);
          }
        }
      });

      test('AE isNotValidValueLength bad values', () {
        for (var s in badAELengthList) {
          expect(AE.isNotValidValueLength(s), true);
        }

        expect(
            AE.isNotValidValueLength(
                '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qmczv9LzgGEH6bTY&N}J'),
            true);
      });

      test('AE isValidVListLength VM.k1 good values', () {
        system.throwOnError = false;
        for (var i = 0; i < 10; i++) {
          final validMinVList = rsg.getAEList(1, 1);
          for (var tag in aeTags0) {
            expect(AE.isValidVListLength(tag, validMinVList), true);

            expect(AE.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
            expect(AE.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
          }
        }
      });

      test('AE isValidVListLength VM.k1 bad values', () {
        for (var i = 1; i < 10; i++) {
          final validMinVList = rsg.getAEList(2, i + 1);
          for (var tag in aeTags0) {
            system.throwOnError = false;
            expect(AE.isValidVListLength(tag, validMinVList), false);

            expect(AE.isValidVListLength(tag, invalidVList), false);

            system.throwOnError = true;
            expect(() => AE.isValidVListLength(tag, validMinVList),
                throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          }
        }
      });

      test('AE isValidVListLength VM.k1_n good values', () {
        system.throwOnError = false;
        for (var i = 1; i < 10; i++) {
          final validMinVList0 = rsg.getAEList(1, i);
          final validMaxLengthList = invalidVList.sublist(0, AE.kMaxLength);
          for (var tag in aeTags1) {
            log.debug('tag: $tag');
            expect(AE.isValidVListLength(tag, validMinVList0), true);
            expect(AE.isValidVListLength(tag, validMaxLengthList), true);
          }
        }
      });

      test('AE isValidValue good values', () {
        for (var s in goodAEList) {
          for (var a in s) {
            expect(AE.isValidValue(a), true);
          }
        }
      });

      test('AE isValidValue bad values', () {
        for (var s in badAEList) {
          for (var a in s) {
            system.throwOnError = false;
            expect(AE.isValidValue(a), false);

            system.throwOnError = true;
            expect(() => AE.isValidValue(a),
                throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
          }
        }
      });

      test('AE isValidValues good values', () {
        system.throwOnError = false;
        for (var s in goodAEList) {
          expect(AE.isValidValues(PTag.kReceivingAE, s), true);
        }
      });

      test('AE isValidValues bad values', () {
        for (var s in badAEList) {
          system.throwOnError = false;
          expect(AE.isValidValues(PTag.kReceivingAE, s), false);

          system.throwOnError = true;
          expect(() => AE.isValidValues(PTag.kReceivingAE, s),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      });

      test('AE fromBytes', () {
        system.level = Level.debug;
        final vList1 = rsg.getAEList(1, 1);
        final bytes = AE.toBytes(vList1);
        log.debug('AE.fromBytes(bytes): ${AE.fromBytes(bytes)}, bytes: $bytes');
        expect(AE.fromBytes(bytes), equals(vList1));
      });

      test('AE toBytes', () {
        final vList1 = rsg.getAEList(1, 1);
        log.debug('AE.toBytes(vList1): ${AE.toBytes(vList1)}');

        if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
        log.debug('vList1:"$vList1"');
        final values = ASCII.encode(vList1[0]);
        expect(AE.toBytes(vList1), equals(values));
      });

      test('AE fromBase64', () {
        system.throwOnError = false;
        final vList1 = rsg.getAEList(1, 1);

        final v0 = AE.fromBase64(vList1);
        expect(v0, isNotNull);

        final v1 = AE.fromBase64(['PIA5']);
        expect(v1, isNotNull);

        final v2 = AE.fromBase64(['PIA']);
        expect(v2, isNotNull);
      });

      test('AE toBase64', () {
        //final s = BASE64.encode(testFrame);
        final vList0 = rsg.getAEList(1, 1);
        expect(AE.toBase64(vList0), equals(vList0));

        final vList1 = ['dslkj'];
        //final s0 = ASCII.encode(vList0[0]);
        expect(AE.toBase64(vList1), equals(vList1));
      });

      test('AE. heckList good values', () {
        system.throwOnError = false;
        for (var i = 0; i <= 10; i++) {
          final vList = rsg.getAEList(1, 1);
          expect(AE.checkList(PTag.kReceivingAE, vList), vList);
        }

        final vList0 = ['KEZ5HZZZR2'];
        expect(AE.checkList(PTag.kReceivingAE, vList0), vList0);

        for (var s in goodAEList) {
          system.throwOnError = false;
          expect(AE.checkList(PTag.kReceivingAE, s), s);
        }
      });

      test('AE. heckList bad values', () {
        system.throwOnError = false;
        final vList1 = ['a\\4'];
        expect(AE.checkList(PTag.kReceivingAE, vList1), isNull);

        system.throwOnError = true;
        expect(() => AE.checkList(PTag.kReceivingAE, vList1),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));

        for (var s in badAEList) {
          system.throwOnError = false;
          expect(AE.checkList(PTag.kReceivingAE, s), isNull);

          system.throwOnError = true;
          expect(() => AE.checkList(PTag.kReceivingAE, s),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      });
    });
  });

  group('CStag', () {
    const goodCSList = const <List<String>>[
      const <String>['KEZ5HZZZR2'],
      const <String>['LUA '],
      const <String>['DAP3Q'],
      const <String>['GAEGBPO'],
      const <String>['EGM_']
    ];

    const badCSList = const <List<String>>[
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
      const <String>['T 2@+nEZKu/J'],
      const <String>['123.45']
    ];

    test('CS hasValidValues good values', () {
      for (var s in goodCSList) {
        system.throwOnError = false;
        final cs0 = new CStag(PTag.kLaterality, s);
        expect(cs0.hasValidValues, true);
      }
      system.throwOnError = false;
      final cs0 = new CStag(PTag.kMaskingImage, []);
      expect(cs0.hasValidValues, true);
      expect(cs0.values, equals(<String>[]));
    });

    test('CS hasValidValues bad values', () {
      for (var s in badCSList) {
        system.throwOnError = false;
        final cs0 = new CStag(PTag.kLaterality, s);
        expect(cs0, isNull);

        system.throwOnError = true;
        expect(() => new CStag(PTag.kLaterality, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }

      system.throwOnError = false;
      final cs1 = new CStag(PTag.kMaskingImage, null);
      log.debug('cs1: $cs1');
      expect(cs1, isNull);

      system.throwOnError = true;
      expect(() => new CStag(PTag.kLaterality, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('CS hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1, 2, 16);
        final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        log.debug('cs0:${cs0.info}');
        expect(cs0.hasValidValues, true);

        log..debug('cs0: $cs0, values: ${cs0.values}')..debug('cs0: ${cs0.info}');
        expect(cs0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        final cs1 = new CStag(PTag.kPatientOrientation, vList0);
        expect(cs1.hasValidValues, true);

        log..debug('cs1: $cs1, values: ${cs1.values}')..debug('cs1: ${cs1.info}');
        expect(cs1[0], equals(vList0[0]));
      }
    });

    test('CS hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final vList0 = rsg.getCSList(3, 4);
        log.debug('$i: vList0: $vList0');
        final cs2 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(cs2, isNull);
      }
    });

    test('CS update random', () {
      final cs0 = new CStag(PTag.kMaskingImage, []);
      expect(cs0.update(['325435', '4545']).values, equals(['325435', '4545']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(3, 4);
        final cs1 = new CStag(PTag.kMaskingImage, vList0);
        final vList1 = rsg.getCSList(3, 4);
        expect(cs1.update(vList1).values, equals(vList1));
      }
    });

    test('CS noValues random', () {
      final cs0 = new CStag(PTag.kMaskingImage, []);
      final CStag csNoValues = cs0.noValues;
      expect(csNoValues.values.isEmpty, true);
      log.debug('cs0: ${cs0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(3, 4);
        final cs0 = new CStag(PTag.kMaskingImage, vList0);
        log.debug('cs0: $cs0');
        expect(csNoValues.values.isEmpty, true);
        log.debug('ae0: ${cs0.noValues}');
      }
    });

    test('CS copy random', () {
      final cs0 = new CStag(PTag.kMaskingImage, []);
      final CStag cs1 = cs0.copy;
      expect(cs1 == cs0, true);
      expect(cs1.hashCode == cs0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(3, 4);
        final cs2 = new CStag(PTag.kMaskingImage, vList0);
        final CStag cs3 = cs2.copy;
        expect(cs3 == cs2, true);
        expect(cs3.hashCode == cs2.hashCode, true);
      }
    });

    test('CS hashCode and == good values random', () {
      List<String> stringList0;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kLaterality, stringList0);
        final cs1 = new CStag(PTag.kLaterality, stringList0);
        log
          ..debug('stringList0:$stringList0, cs0.hash_code:${cs0.hashCode}')
          ..debug('stringList0:$stringList0, ds1.hash_code:${cs1.hashCode}');
        expect(cs0.hashCode == cs1.hashCode, true);
        expect(cs0 == cs1, true);
      }
    });

    test('CS hashCode and == bad values random', () {
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;
      List<String> stringList4;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kLaterality, stringList0);

        stringList1 = rsg.getCSList(1, 1);
        final ae2 = new CStag(PTag.kImageLaterality, stringList1);
        log.debug('stringList1:$stringList1 , ae2.hash_code:${ae2.hashCode}');
        expect(cs0.hashCode == ae2.hashCode, false);
        expect(cs0 == ae2, false);

        stringList2 = rsg.getCSList(2, 2);
        final cs3 = new CStag(PTag.kPatientOrientation, stringList2);
        log.debug('stringList2:$stringList2 , cs3.hash_code:${cs3.hashCode}');
        expect(cs0.hashCode == cs3.hashCode, false);
        expect(cs0 == cs3, false);

        stringList3 = rsg.getCSList(4, 4);
        final cs4 = new CStag(PTag.kFrameType, stringList3);
        log.debug('stringList3:$stringList3 , cs4.hash_code:${cs4.hashCode}');
        expect(cs0.hashCode == cs4.hashCode, false);
        expect(cs0 == cs4, false);

        stringList4 = rsg.getCSList(2, 3);
        final cs5 = new CStag(PTag.kLaterality, stringList2);
        log.debug('stringList4:$stringList4 , cs5.hash_code:${cs5.hashCode}');
        expect(cs0.hashCode == cs5.hashCode, false);
        expect(cs0 == cs5, false);
      }
    });

    test('CS valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(vList0, equals(cs0.valuesCopy));
      }
    });

    test('CS isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(cs0.tag.isValidLength(cs0.length), true);
      }
    });

    test('CS isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        //Urgent sharath: Fix getCSList()
        //expect(cs0.tag.isValidValues(cs0.values), true);
        expect(cs0.hasValidValues, true);
      }
    });

    test('CS replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        final vList1 = rsg.getCSList(1, 1);
        expect(cs0.replace(vList1), equals(vList0));
        expect(cs0.values, equals(vList1));
      }

      final vList1 = rsg.getCSList(1, 1);
      final cs1 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList1);
      expect(cs1.replace([]), equals(vList1));
      expect(cs1.values, equals(<String>[]));

      final cs2 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList1);
      expect(cs2.replace(null), equals(vList1));
      expect(cs2.values, equals(<String>[]));
    });

    test('CS blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList1);
        final blank = cs0.blank(i);
        log.debug(('blank$i: ${blank.values}'));
        expect(blank.values.length == 1, true);
        log.debug('value: ${blank.value}');
        expect(blank.value.length == i, true);
        final strSpaceList = <String>[''.padRight(i, ' ')];
        log.debug('strSpaceList: $strSpaceList');
        expect(blank.values, equals(strSpaceList));
      }
    });

    test('CS formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getCSList(1, 1);
        final bytes = CS.toBytes(vList1);
        log.debug('bytes:$bytes');
        final cs1 = new CStag.fromBytes(PTag.kGeometryOfKSpaceTraversal, bytes);
        log.debug('cs1: ${cs1.info}');
        expect(cs1.hasValidValues, true);
      }
    });

    test('CS checkLength good values', () {
      final vList0 = rsg.getCSList(1, 1);
      final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      for (var s in goodCSList) {
        expect(cs0.checkLength(s), true);
      }
      final cs1 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      expect(cs1.checkLength([]), true);
    });

    test('CS checkLength bad values', () {
      final vList0 = rsg.getCSList(1, 1);
      final vList1 = ['KEZ5HZZZR2', 'LSDKFJIE34D'];
      final cs2 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      expect(cs2.checkLength(vList1), false);
    });

    test('CS checkValue good values', () {
      final vList0 = rsg.getCSList(1, 1);
      final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      for (var s in goodCSList) {
        for (var a in s) {
          expect(cs0.checkValue(a), true);
        }
      }
    });

    test('CS checkValue bad values', () {
      final vList0 = rsg.getCSList(1, 1);
      final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      for (var s in badCSList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(cs0.checkValue(a), false);

          system.throwOnError = true;
          expect(() => cs0.checkValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });

    group('CS', () {
      //VM.k1
      const csTags0 = const <PTag>[
        PTag.kFileSetID,
        PTag.kConversionType,
        PTag.kPresentationIntentType,
        PTag.kMappingResource,
        //PTag.kFileSetDescriptorFileID,//vm.k1_8
        PTag.kFieldOfViewShape,
        PTag.kRadiationSetting,
      ];

      //VM.k2
      const csTags1 = const <PTag>[
        PTag.kPatientOrientation,
        PTag.kReportStatusIDTrial,
        PTag.kSeriesType,
        PTag.kDisplaySetPatientOrientation
      ];

      //VM.k2_n
      const csTags2 = const <PTag>[PTag.kImageType];

      //VM.k4
      const csTags3 = const <PTag>[
        PTag.kFrameType,
      ];

      //VM.k1_n
      const csTags4 = const <PTag>[
        PTag.kModalitiesInStudy,
        PTag.kIndicationType,
        PTag.kScanningSequence,
        PTag.kSequenceVariant,
        PTag.kScanOptions,
        PTag.kGrid,
        PTag.kFilterMaterial,
        PTag.kSelectorCSValue,
      ];

      const otherTags = const <PTag>[
        PTag.kColumnAngulationPatient,
        PTag.kAcquisitionProtocolDescription,
        PTag.kCTDIvol,
        PTag.kCTPositionSequence,
        PTag.kPatientAge,
        PTag.kPerformedStationAETitle,
        PTag.kSelectorSTValue,
        PTag.kDate,
        PTag.kTime
      ];

      final invalidVList = rsg.getCSList(CS.kMaxLength + 1, CS.kMaxLength + 1);

      test('CS checkVR good values', () {
        system.throwOnError = false;
        expect(CS.checkVRIndex(kCSIndex), kCSIndex);

        for (var tag in csTags0) {
          system.throwOnError = false;
          expect(CS.checkVRIndex(tag.vrIndex), tag.vrIndex);
        }
      });

      test('CS checkVR bad values', () {
        system.throwOnError = false;
        expect(
            CS.checkVRIndex(
              kAEIndex,
            ),
            isNull);
        system.throwOnError = true;
        expect(() => CS.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(CS.checkVRIndex(tag.vrIndex), isNull);

          system.throwOnError = true;
          expect(() => CS.checkVRIndex(kAEIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('CS isValidVRIndex good values', () {
        system.throwOnError = false;
        expect(CS.isValidVRIndex(kCSIndex), true);

        for (var tag in csTags0) {
          system.throwOnError = false;
          expect(CS.isValidVRIndex(tag.vrIndex), true);
        }
      });

      test('CS isValidVRIndex bad values', () {
        system.throwOnError = false;
        expect(CS.isValidVRIndex(kSSIndex), false);

        system.throwOnError = true;
        expect(() => CS.isValidVRIndex(kSSIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(CS.isValidVRIndex(tag.vrIndex), false);

          system.throwOnError = true;
          expect(() => CS.isValidVRIndex(tag.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('CS isValidVRCode good values', () {
        system.throwOnError = false;
        expect(CS.isValidVRCode(kCSCode), true);

        for (var tag in csTags0) {
          expect(CS.isValidVRCode(tag.vrCode), true);
        }
      });

      test('CS isValidVRCode bad values', () {
        system.throwOnError = false;
        expect(CS.isValidVRCode(kAECode), false);

        system.throwOnError = true;
        expect(() => CS.isValidVRCode(kAECode),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(CS.isValidVRCode(tag.vrCode), false);

          system.throwOnError = true;
          expect(() => CS.isValidVRCode(tag.vrCode),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('CS sValidVFLength good values', () {
        expect(CS.isValidVFLength(CS.kMaxVFLength), true);
        expect(CS.isValidVFLength(0), true);
      });

      test('CS sValidVFLength bad values', () {
        expect(CS.isValidVFLength(CS.kMaxVFLength + 1), false);
        expect(CS.isValidVFLength(-1), false);
      });

      test('CS isNotValidVFLength good values', () {
        expect(CS.isNotValidVFLength(CS.kMaxVFLength), false);
        expect(CS.isNotValidVFLength(0), false);
      });

      test('CS isNotValidVFLength bad values', () {
        expect(CS.isNotValidVFLength(CS.kMaxVFLength + 1), true);
        expect(CS.isNotValidVFLength(-1), true);
      });

      test('CS.isValidValueLength', () {
        for (var s in goodCSList) {
          for (var a in s) {
            expect(CS.isValidValueLength(a), true);
          }
        }

        /* for (var s in badAELengthList) {
          expect(CS.isValidValueLength(s), false);
        }*/

        expect(CS.isValidValueLength('&t&wSB)~PIA!UIDX'), true);

        expect(
            CS.isValidValueLength(
                '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qzD2N3 2fzLzgGEH6bTY&N}JzD2N3 2fz'),
            false);
      });

      test('CS.isNotValidValueLength', () {
        for (var s in goodCSList) {
          for (var a in s) {
            expect(CS.isNotValidValueLength(a), false);
          }
        }

        /* for (var s in badAELengthList) {
          expect(CS.isNotValidValueLength(s), true);
        }*/

        expect(
            CS.isNotValidValueLength(
                '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qmczv9LzgGEH6bTY&N}J'),
            true);
      });

      test('CS isValidVListLength VM.k1 good values', () {
        system.throwOnError = false;
        for (var i = 0; i < 10; i++) {
          final validMinVList = rsg.getCSList(1, 1);
          for (var tag in csTags0) {
            expect(CS.isValidVListLength(tag, validMinVList), true);

            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
          }
        }
      });

      test('CS isValidVListLength VM.k1 bad values', () {
        for (var i = 1; i < 10; i++) {
          final validMinVList = rsg.getCSList(2, i + 1);
          for (var tag in csTags0) {
            system.throwOnError = false;
            expect(CS.isValidVListLength(tag, validMinVList), false);

            expect(CS.isValidVListLength(tag, invalidVList), false);

            system.throwOnError = true;
            expect(() => CS.isValidVListLength(tag, validMinVList),
                throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          }
        }
      });

      test('CS isValidVListLength VM.k2 good values', () {
        system.throwOnError = false;
        for (var i = 0; i < 10; i++) {
          final validMinVList = rsg.getCSList(2, 2);
          for (var tag in csTags1) {
            expect(CS.isValidVListLength(tag, validMinVList), true);

            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
          }
        }
      });

      test('CS isValidVListLength VM.k2 bad values', () {
        for (var i = 2; i < 10; i++) {
          final validMinVList = rsg.getCSList(3, i + 1);
          for (var tag in csTags1) {
            system.throwOnError = false;
            expect(CS.isValidVListLength(tag, validMinVList), false);

            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 1)), false);
            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMin - 1)), false);

            expect(CS.isValidVListLength(tag, invalidVList), false);

            system.throwOnError = true;
            expect(() => CS.isValidVListLength(tag, validMinVList),
                throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          }
        }
      });

      test('CS isValidVListLength VM.k2_2n good values', () {
        system.throwOnError = false;
        for (var i = 0; i < 10; i++) {
          final validMinVList = rsg.getCSList(10, 10);
          final validMaxLengthList = invalidVList.sublist(0, CS.kMaxLength);
          for (var tag in csTags2) {
            expect(CS.isValidVListLength(tag, validMinVList), true);

            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 3)), true);
            expect(CS.isValidVListLength(tag, validMaxLengthList), true);
          }
        }
      });

      test('CS isValidVListLength VM.k2_2n bad values', () {
        for (var i = 0; i < 10; i++) {
          final validMinVList = rsg.getCSList(1, 1);
          for (var tag in csTags2) {
            system.throwOnError = false;
            expect(CS.isValidVListLength(tag, validMinVList), false);

            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 2)), false);
            system.throwOnError = true;
            expect(() => CS.isValidVListLength(tag, validMinVList),
                throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          }
        }
      });

      test('CS isValidVListLength VM.k4 good values', () {
        system.throwOnError = false;
        for (var i = 0; i < 10; i++) {
          final validMinVList = rsg.getCSList(4, 4);
          for (var tag in csTags3) {
            expect(CS.isValidVListLength(tag, validMinVList), true);

            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
          }
        }
      });

      test('CS isValidVListLength VM.k4 bad values', () {
        for (var i = 4; i < 10; i++) {
          final validMinVList = rsg.getCSList(5, i + 1);
          for (var tag in csTags3) {
            system.throwOnError = false;
            expect(CS.isValidVListLength(tag, validMinVList), false);

            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMax + 1)), false);
            expect(CS.isValidVListLength(tag, invalidVList.take(tag.vmMin - 1)), false);
            expect(CS.isValidVListLength(tag, invalidVList), false);

            system.throwOnError = true;
            expect(() => CS.isValidVListLength(tag, validMinVList),
                throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          }
        }
      });

      test('CS isValidVListLength VM.k1_n good values', () {
        system.throwOnError = false;
        for (var i = 1; i < 10; i++) {
          final validMinVList0 = rsg.getCSList(1, i);
          final validMaxLengthList = invalidVList.sublist(0, CS.kMaxLength);
          for (var tag in csTags4) {
            log.debug('tag: $tag');
            expect(CS.isValidVListLength(tag, validMinVList0), true);
            expect(CS.isValidVListLength(tag, validMaxLengthList), true);
          }
        }
      });

      test('CS isValidValue good values', () {
        for (var s in goodCSList) {
          for (var a in s) {
            expect(CS.isValidValue(a), true);
          }
        }
      });

      test('CS isValidValue bad values', () {
        for (var s in badCSList) {
          for (var a in s) {
            system.throwOnError = false;
            expect(CS.isValidValue(a), false);

            system.throwOnError = true;
            expect(() => CS.isValidValue(a),
                throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
          }
        }
      });

      test('CS isValidValues good values', () {
        system.throwOnError = false;
        for (var s in goodCSList) {
          expect(CS.isValidValues(PTag.kSCPStatus, s), true);
        }
      });

      test('CS isValidValues bad values', () {
        for (var s in badCSList) {
          system.throwOnError = false;
          expect(CS.isValidValues(PTag.kSCPStatus, s), false);

          system.throwOnError = true;
          expect(() => CS.isValidValues(PTag.kSCPStatus, s),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      });

      test('CS fromBytes', () {
        system.level = Level.debug;
        final vList1 = rsg.getCSList(1, 1);
        final bytes = CS.toBytes(vList1);
        log.debug('CS.fromBytes(bytes): ${CS.fromBytes(bytes)}, bytes: $bytes');
        expect(CS.fromBytes(bytes), equals(vList1));
      });

      test('CS toBytes', () {
        final vList1 = rsg.getCSList(1, 1);
        log.debug('CS.toBytes(vList1): ${CS.toBytes(vList1)}');
        final val = ASCII.encode('s6V&:;s%?Q1g5v');
        expect(CS.toBytes(['s6V&:;s%?Q1g5v']), equals(val));

        if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
        log.debug('vList1:"$vList1"');
        final values = ASCII.encode(vList1[0]);
        expect(CS.toBytes(vList1), equals(values));
      });

      test('CS fromBase64', () {
        system.throwOnError = false;
        final vList1 = rsg.getCSList(1, 1);

        final v0 = CS.fromBase64(vList1);
        expect(v0, isNotNull);

        final v1 = CS.fromBase64(['PIA5']);
        expect(v1, isNotNull);

        final v2 = CS.fromBase64(['PIA']);
        expect(v2, isNotNull);
      });

      test('CS toBase64', () {
        //final s = BASE64.encode(testFrame);
        final vList0 = rsg.getCSList(1, 1);
        expect(CS.toBase64(vList0), equals(vList0));

        final vList1 = ['dslkj'];
        //final s0 = ASCII.encode(vList0[0]);
        expect(CS.toBase64(vList1), equals(vList1));
      });

      test('CS checkList good values', () {
        system.throwOnError = false;
        for (var i = 0; i <= 10; i++) {
          final vList = rsg.getCSList(1, 1);
          expect(CS.checkList(PTag.kSCPStatus, vList), vList);
        }

        final vList0 = ['KEZ5HZZZR2'];
        expect(CS.checkList(PTag.kSCPStatus, vList0), vList0);

        for (var s in goodCSList) {
          system.throwOnError = false;
          expect(CS.checkList(PTag.kSCPStatus, s), s);
        }
      });

      test('CS checkList bad values', () {
        system.throwOnError = false;
        final vList1 = ['\r'];
        expect(CS.checkList(PTag.kSCPStatus, vList1), isNull);

        system.throwOnError = true;
        expect(() => CS.checkList(PTag.kSCPStatus, vList1),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        for (var s in badCSList) {
          system.throwOnError = false;
          expect(CS.checkList(PTag.kSCPStatus, s), isNull);

          system.throwOnError = true;
          expect(() => CS.checkList(PTag.kSCPStatus, s),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      });
    });
  });

  group('UItag', () {
    const goodUIList = const <List<String>>[
      const <String>['1.2.840.10008.5.1.4.34.5'],
      const <String>['1.2.840.10008.1.2.4.51'],
      const <String>['1.2.840.10008.5.1.4.1.1.77.1.1'],
      const <String>['1.2.840.10008.5.1.4.1.1.66.4'],
    ];

    const badUIList = const <List<String>>[
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
      const <String>['1.a.840.10008.5.1.4.1.1.66.4'],
    ];

    test('UI hasValidValues good values', () {
      for (var s in goodUIList) {
        system.throwOnError = false;
        final ui0 = new UItag(PTag.kStudyInstanceUID, s);
        expect(ui0.hasValidValues, true);
      }
      system.throwOnError = false;
      final ui0 = new UItag(PTag.kConcatenationUID, []);
      expect(ui0.hasValidValues, true);
      expect(ui0.values, equals(<String>[]));
    });

    test('UI hasValidValues bad values', () {
      for (var s in badUIList) {
        system.throwOnError = false;
        final ui0 = new UItag(PTag.kStudyInstanceUID, s);
        expect(ui0, isNull);

        system.throwOnError = true;
        expect(() => new UItag(PTag.kStudyInstanceUID, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      system.throwOnError = false;
      final ui1 = new UItag(PTag.kConcatenationUID, null);
      log.debug('ui1: $ui1');
      expect(ui1, isNull);

      system.throwOnError = true;
      expect(() => new UItag(PTag.kStudyInstanceUID, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UI hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kStudyInstanceUID, vList0);
        log.debug('ui0:${ui0.info}');
        expect(ui0.hasValidValues, true);

        log..debug('ui0: $ui0, values: ${ui0.values}')..debug('ui0: ${ui0.info}');
        expect(ui0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 10);
        final ui1 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        expect(ui1.hasValidValues, true);

        log..debug('ui1: $ui1, values: ${ui1.values}')..debug('ui1: ${ui1.info}');
        expect(ui1[0], equals(vList0[0]));
      }
    });

    test('UI hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        log.debug('$i: vList0: $vList0');

        system.throwOnError = false;
        final ui2 = new UItag(PTag.kStudyInstanceUID, vList0);
        expect(ui2, isNull);

        system.throwOnError = true;
        expect(() => new UItag(PTag.kStudyInstanceUID, vList0),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      }
    });

    test('UI update random', () {
      system.throwOnError = false;
      final vList0 = rsg.getUIList(3, 4);
      final ui0 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
      expect(utility.testElementUpdate(ui0, vList0), true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        final ui1 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        final vList1 = rsg.getUIList(3, 4);
        expect(ui1.update(vList1).values, equals(vList1));
      }

      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final vList0 = rsg.getUIList(3, 4);
        final ui1 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        final vList1 = rsg.getAEList(3, 4);
        expect(ui1.update(vList1), isNull);

        system.throwOnError = true;
        final vList2 = rsg.getUIList(3, 4);
        final ui2 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList2);
        final vList3 = rsg.getAEList(3, 4);
        expect(
            () => ui2.update(vList3), throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      system.throwOnError = true;
      final vList2 = rsg.getUIList(3, 4);
      final ui2 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList2);
      final vList3 = ['3.2.840.10008.1.2.0'];
      expect(() => ui2.update(vList3), throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UI noValues random', () {
      final ui0 = new UItag(PTag.kRelatedGeneralSOPClassUID, []);
      final UItag uiNoValues = ui0.noValues;
      expect(uiNoValues.values.isEmpty, true);
      log.debug('ui0: ${ui0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        final ui0 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        log.debug('ui0: $ui0');
        expect(uiNoValues.values.isEmpty, true);
        log.debug('ui0: ${ui0.noValues}');
      }
    });

    test('UI copy random', () {
      final ui0 = new UItag(PTag.kRelatedGeneralSOPClassUID, []);
      final UItag ui1 = ui0.copy;
      expect(ui1 == ui0, true);
      expect(ui1.hashCode == ui0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        final ui2 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        final UItag ui3 = ui2.copy;
        expect(ui3 == ui2, true);
        expect(ui3.hashCode == ui2.hashCode, true);
      }
    });

    test('UI hashCode and == good values random', () {
      List<String> stringList0;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kConcatenationUID, stringList0);
        final ui1 = new UItag(PTag.kConcatenationUID, stringList0);
        log
          ..debug('stringList0:$stringList0, ui0.hash_code:${ui0.hashCode}')
          ..debug('stringList0:$stringList0, ui1.hash_code:${ui1.hashCode}');
        expect(ui0.hashCode == ui1.hashCode, true);
        expect(ui0 == ui1, true);
      }
    });

    test('UI hashCode and == bad values random', () {
      system.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;

      log.debug('UI hashCode and ==');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kConcatenationUID, stringList0);

        stringList1 = rsg.getUIList(1, 1);
        final ui2 = new UItag(PTag.kDimensionOrganizationUID, stringList1);
        log.debug('stringList1:$stringList1 , ui2.hash_code:${ui2.hashCode}');
        expect(ui0.hashCode == ui2.hashCode, false);
        expect(ui0 == ui2, false);

        stringList2 = rsg.getUIList(1, 10);
        final ui3 = new UItag(PTag.kRelatedGeneralSOPClassUID, stringList2);
        log.debug('stringList2:$stringList2 , ui3.hash_code:${ui3.hashCode}');
        expect(ui0.hashCode == ui3.hashCode, false);
        expect(ui0 == ui3, false);

        stringList3 = rsg.getUIList(2, 3);
        final ui4 = new UItag(PTag.kLaterality, stringList3);
        log.debug('stringList3:$stringList3 , ui4.hash_code:${ui4.hashCode}');
        expect(ui0.hashCode == ui4.hashCode, false);
        expect(ui0 == ui4, false);
      }
    });

    test('UI valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
        expect(vList0, equals(ui0.valuesCopy));
      }
    });

    test('UI isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
        expect(ui0.tag.isValidLength(ui0.length), true);
      }
    });

    test('UI isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
        expect(ui0.tag.isValidValues(ui0.values), true);
        expect(ui0.hasValidValues, true);
      }
    });

    test('UI replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
        final vList1 = rsg.getUIList(1, 1);
        expect(ui0.replace(vList1), equals(vList0));
        expect(ui0.values, equals(vList1));
      }

      final vList1 = rsg.getUIList(1, 1);
      final ui1 = new UItag(PTag.kSOPInstanceUID, vList1);
      expect(ui1.replace([]), equals(vList1));
      expect(ui1.values, equals(<String>[]));

      final ui2 = new UItag(PTag.kSOPInstanceUID, vList1);
      expect(ui2.replace(null), equals(vList1));
      expect(ui2.values, equals(<String>[]));
    });

    test('UI blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kSOPInstanceUID, vList1);
        expect(ui0.blank, throwsA(const isInstanceOf<UnsupportedError>()));
      }
    });

    test('UI formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUIList(1, 1);
        final bytes = UI.toBytes(vList1);
        log.debug('bytes:$bytes');
        final ui0 = new UItag.fromBytes(PTag.kSOPInstanceUID, bytes);
        log.debug('$i: ui0: ${ui0.info}');
        expect(ui0.hasValidValues, true);
      }
    });

    test('UI checkLength good values', () {
      final vList0 = rsg.getUIList(1, 1);
      final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
      for (var s in goodUIList) {
        expect(ui0.checkLength(s), true);
      }
      final ui1 = new UItag(PTag.kSOPInstanceUID, vList0);
      expect(ui1.checkLength([]), true);
    });

    test('UI checkLength bad values', () {
      final vList0 = rsg.getUIList(1, 1);
      final vList1 = ['1.2.840.10008.5.1.4.34.5', '1.2.840.10008.3.1.2.32.7'];
      final ui2 = new UItag(PTag.kSOPInstanceUID, vList0);
      expect(ui2.checkLength(vList1), false);
    });

    test('UI checkValue good values', () {
      final vList0 = rsg.getUIList(1, 1);
      final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
      for (var s in goodUIList) {
        for (var a in s) {
          expect(ui0.checkValue(a), true);
        }
      }
    });

    test('UI checkValue bad values', () {
      final vList0 = rsg.getUIList(1, 1);
      final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
      for (var s in badUIList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(ui0.checkValue(a), false);
        }
      }
    });

    group('UI', () {
      //VM.k1
      const uiTags0 = const <PTag>[
        PTag.kAffectedSOPInstanceUID,
        PTag.kRequestedSOPInstanceUID,
        PTag.kMediaStorageSOPClassUID,
        PTag.kTransferSyntaxUID,
        PTag.kImplementationClassUID,
        PTag.kInstanceCreatorUID,
        PTag.kSOPClassUID,
        PTag.kSOPInstanceUID,
        PTag.kOriginalSpecializedSOPClassUID,
        PTag.kCodingSchemeUID,
        PTag.kStudyInstanceUID,
        PTag.kSeriesInstanceUID,
        PTag.kDimensionOrganizationUID,
        PTag.kSpecimenUID,
      ];

      //VM.k1_n
      const uiTags1 = const <PTag>[
        PTag.kRelatedGeneralSOPClassUID,
        PTag.kFailedSOPInstanceUIDList,
        PTag.kSelectorUIValue
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

      final invalidVList = rsg.getUIList(UI.kMaxLength + 1, UI.kMaxLength + 1);

      test('UI checkVR good values', () {
        system.throwOnError = false;
        expect(UI.checkVRIndex(kUIIndex), kUIIndex);

        for (var tag in uiTags0) {
          system.throwOnError = false;
          expect(UI.checkVRIndex(tag.vrIndex), tag.vrIndex);
        }
      });

      test('UI checkVR bad values', () {
        system.throwOnError = false;
        expect(
            UI.checkVRIndex(
              kAEIndex,
            ),
            isNull);
        system.throwOnError = true;
        expect(() => UI.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(UI.checkVRIndex(tag.vrIndex), isNull);

          system.throwOnError = true;
          expect(() => UI.checkVRIndex(kAEIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('UI isValidVRIndex good values', () {
        system.throwOnError = false;
        expect(UI.isValidVRIndex(kUIIndex), true);

        for (var tag in uiTags0) {
          system.throwOnError = false;
          expect(UI.isValidVRIndex(tag.vrIndex), true);
        }
      });

      test('UI isValidVRIndex bad values', () {
        system.throwOnError = false;
        expect(UI.isValidVRIndex(kSSIndex), false);

        system.throwOnError = true;
        expect(() => UI.isValidVRIndex(kSSIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(UI.isValidVRIndex(tag.vrIndex), false);

          system.throwOnError = true;
          expect(() => UI.isValidVRIndex(tag.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('UI isValidVRCode good values', () {
        system.throwOnError = false;
        expect(UI.isValidVRCode(kUICode), true);

        for (var tag in uiTags0) {
          expect(UI.isValidVRCode(tag.vrCode), true);
        }
      });

      test('UI isValidVRCode bad values', () {
        system.throwOnError = false;
        expect(UI.isValidVRCode(kAECode), false);

        system.throwOnError = true;
        expect(() => UI.isValidVRCode(kAECode),
            throwsA(const isInstanceOf<InvalidVRError>()));
        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(UI.isValidVRCode(tag.vrCode), false);

          system.throwOnError = true;
          expect(() => UI.isValidVRCode(tag.vrCode),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('UI isValidVFLength good values', () {
        expect(UI.isValidVFLength(UI.kMaxVFLength), true);
        expect(UI.isValidVFLength(0), true);
      });

      test('UI isValidVFLength bad values', () {
        expect(UI.isValidVFLength(UI.kMaxVFLength + 1), false);
        expect(UI.isValidVFLength(-1), false);
      });

      test('UI isNotValidVFLength good values', () {
        expect(UI.isNotValidVFLength(UI.kMaxVFLength), false);
        expect(UI.isNotValidVFLength(0), false);
      });

      test('UI isNotValidVFLength good values', () {
        expect(UI.isNotValidVFLength(UI.kMaxVFLength + 1), true);
        expect(UI.isNotValidVFLength(-1), true);
      });

      test('UI isValidValueLength', () {
        for (var s in goodUIList) {
          for (var a in s) {
            expect(UI.isValidValueLength(a), true);
          }
        }
      });

      test('UI isNotValidValueLength', () {
        for (var s in goodUIList) {
          for (var a in s) {
            expect(UI.isNotValidValueLength(a), false);
          }
        }
      });

      test('UI isValidVListLength VM.k1 good values', () {
        system.throwOnError = false;
        for (var i = 0; i < 10; i++) {
          final validMinVList = rsg.getUIList(1, 1);
          for (var tag in uiTags0) {
            expect(UI.isValidVListLength(tag, validMinVList), true);

            expect(UI.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
            expect(UI.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
          }
        }
      });

      test('UI isValidVListLength VM.k1 bad values', () {
        for (var i = 1; i < 10; i++) {
          final validMinVList = rsg.getUIList(2, i + 1);
          for (var tag in uiTags0) {
            system.throwOnError = false;
            expect(UI.isValidVListLength(tag, validMinVList), false);

            expect(UI.isValidVListLength(tag, invalidVList), false);

            system.throwOnError = true;
            expect(() => UI.isValidVListLength(tag, validMinVList),
                throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          }
        }
      });

      test('UI isValidVListLength VM.k1_n good values', () {
        system.throwOnError = false;
        for (var i = 1; i < 10; i++) {
          final validMinVList0 = rsg.getUIList(1, i);
          final validMaxLengthList = invalidVList.sublist(0, UI.kMaxLength);
          for (var tag in uiTags1) {
            log.debug('tag: $tag');
            expect(UI.isValidVListLength(tag, validMinVList0), true);
            expect(UI.isValidVListLength(tag, validMaxLengthList), true);
          }
        }
      });

      test('UI isValidValue good values', () {
        for (var s in goodUIList) {
          for (var a in s) {
            expect(UI.isValidValue(a), true);
          }
        }
      });

      test('UI isValidValue bad values', () {
        for (var s in badUIList) {
          for (var a in s) {
            system.throwOnError = false;
            expect(UI.isValidValue(a), false);
          }
        }
      });

      test('UI isValidValues good values', () {
        system.throwOnError = false;
        for (var s in goodUIList) {
          expect(UI.isValidValues(PTag.kInstanceCreatorUID, s), true);
        }
      });

      test('UI isValidValues bad values', () {
        for (var s in badUIList) {
          system.throwOnError = false;
          expect(UI.isValidValues(PTag.kInstanceCreatorUID, s), false);

          system.throwOnError = true;
          expect(() => UI.isValidValues(PTag.kInstanceCreatorUID, s),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      });

      test('UI fromBytes', () {
        system.level = Level.debug;
        final vList1 = rsg.getCSList(1, 1);
        final bytes = UI.toBytes(vList1);
        log.debug('UI.fromBytes(bytes): ${UI.fromBytes(bytes)}, bytes: $bytes');
        expect(UI.fromBytes(bytes), equals(vList1));
      });

      test('UI toBytes', () {
        final vList1 = rsg.getUIList(1, 1);
        log.debug('UI.toBytes(vList1): ${UI.toBytes(vList1)}');
        final val = ASCII.encode('s6V&:;s%?Q1g5v');
        expect(UI.toBytes(['s6V&:;s%?Q1g5v']), equals(val));

        if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
        log.debug('vList1:"$vList1"');
        final values = ASCII.encode(vList1[0]);
        expect(UI.toBytes(vList1), equals(values));
      });

      test('UI fromBase64', () {
        system.throwOnError = false;
        final vList1 = rsg.getUIList(1, 1);

        final v0 = UI.fromBase64(vList1);
        expect(v0, isNotNull);

        final v1 = UI.fromBase64(['1.2.840.10008.5.1.4.34.5']);
        expect(v1, isNotNull);

        final v2 = UI.fromBase64(['1.2.840.10008.5.1.4.34.4']);
        expect(v2, isNotNull);
      });

      test('UI toBase64', () {
        //final s = BASE64.encode(testFrame);
        final vList0 = rsg.getUIList(1, 1);
        expect(UI.toBase64(vList0), equals(vList0));

        final vList1 = ['1.2.840.10008.5.1.4.34.5'];
        //final s0 = ASCII.encode(vList0[0]);
        expect(UI.toBase64(vList1), equals(vList1));
      });

      test('UI checkList good values', () {
        system.throwOnError = false;
        for (var i = 0; i <= 10; i++) {
          final vList = rsg.getUIList(1, 1);
          expect(UI.checkList(PTag.kInstanceCreatorUID, vList), vList);
        }

        final vList0 = ['1.2.840.10008.5.1.4.34.5'];
        expect(UI.checkList(PTag.kInstanceCreatorUID, vList0), vList0);

        for (var s in goodUIList) {
          system.throwOnError = false;
          expect(UI.checkList(PTag.kInstanceCreatorUID, s), s);
        }
      });

      test('UI checkList bad values', () {
        final vList1 = ['1.a.840.10008.5.1.4.1.1.66.4'];
        expect(UI.checkList(PTag.kInstanceCreatorUID, vList1), isNull);

        system.throwOnError = true;
        expect(() => UI.checkList(PTag.kInstanceCreatorUID, vList1),
            throwsA(const isInstanceOf<InvalidValuesError>()));
        system.throwOnError = false;

        for (var i = 0; i <= 10; i++) {
          for (var s in badUIList) {
            system.throwOnError = false;
            expect(UI.checkList(PTag.kInstanceCreatorUID, s), isNull);

            system.throwOnError = true;
            expect(() => UI.checkList(PTag.kInstanceCreatorUID, s),
                throwsA(const isInstanceOf<InvalidValuesError>()));
          }
        }
      });
    });
  });

  group('URtag', () {
    const goodURList = const <List<String>>[
      const <String>['http:/TVc8mR/swk/jvNtF/Uy6'],
      const <String>['iaWlVR'],
      const <String>['http:/l_YB2r8/LQIo9'],
      const <String>['_m3G9go/OkgpQ'],
      const <String>['\b'], //	Backspace
      const <String>['\t '], //horizontal tab (HT)
      const <String>['\n'], //linefeed (LF)
      const <String>['\f '], // form feed (FF)
      const <String>['\r '], //carriage return (CR)
      const <String>['\v'], //vertical tab
    ];

    const badURList = const <List<String>>[
      const <String>[' asdf sdf  ']
    ];

    test('UR hasValidValues good values', () {
      for (var s in goodURList) {
        system.throwOnError = false;
        final ur0 = new URtag(PTag.kRetrieveURI, s);
        expect(ur0.hasValidValues, true);
      }

      final ur0 = new URtag(PTag.kPixelDataProviderURL, []);
      expect(ur0.hasValidValues, true);
      expect(ur0.values, equals(<String>[]));
    });

    test('UR hasValidValues bad values', () {
      for (var s in badURList) {
        system.throwOnError = false;
        final ur0 = new URtag(PTag.kRetrieveURI, s);
        expect(ur0, isNull);

        system.throwOnError = true;
        expect(() => new URtag(PTag.kRetrieveURI, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      system.throwOnError = false;
      expect(new URtag(PTag.kPixelDataProviderURL, null), isNull);

      system.throwOnError = true;
      expect(() => new URtag(PTag.kPixelDataProviderURL, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UR hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURI, vList0);
        log.debug('ur0:${ur0.info}');
        expect(ur0.hasValidValues, true);

        log..debug('ur0: $ur0, values: ${ur0.values}')..debug('ur0: ${ur0.info}');
        expect(ur0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        log.debug('$i: vList0: $vList0');
        final ui1 = new URtag(PTag.kRetrieveURI, vList0);
        expect(ui1.hasValidValues, true);
      }
    });

    test('UR update random', () {
      final cs0 = new CStag(PTag.kMaskingImage, []);
      expect(cs0.update(['325435', '4545']).values, equals(['325435', '4545']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ui1 = new URtag(PTag.kPixelDataProviderURL, vList0);
        final vList1 = rsg.getURList(1, 1);
        expect(ui1.update(vList1).values, equals(vList1));
      }
    });

    test('UR noValues random', () {
      final ur0 = new URtag(PTag.kPixelDataProviderURL, []);
      final URtag urNoValues = ur0.noValues;
      expect(urNoValues.values.isEmpty, true);
      log.debug('ur0: ${ur0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kPixelDataProviderURL, vList0);
        log.debug('ur0: $ur0');
        expect(urNoValues.values.isEmpty, true);
        log.debug('ur0: ${ur0.noValues}');
      }
    });

    test('UR copy random', () {
      final ur0 = new URtag(PTag.kPixelDataProviderURL, []);
      final URtag ur1 = ur0.copy;
      expect(ur1 == ur0, true);
      expect(ur1.hashCode == ur0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur2 = new URtag(PTag.kPixelDataProviderURL, vList0);
        final URtag ur3 = ur2.copy;
        expect(ur3 == ur2, true);
        expect(ur3.hashCode == ur2.hashCode, true);
      }
    });

    test('UR hashCode and == good values random', () {
      List<String> stringList0;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURL, stringList0);
        final ur1 = new URtag(PTag.kRetrieveURL, stringList0);
        log
          ..debug('stringList0:$stringList0, ur0.hash_code:${ur0.hashCode}')
          ..debug('stringList0:$stringList0, ur1.hash_code:${ur1.hashCode}');
        expect(ur0.hashCode == ur1.hashCode, true);
        expect(ur0 == ur1, true);
      }
    });

    test('UR hashCode and == bad values random', () {
      for (var i = 0; i < 10; i++) {
        final stringList0 = rsg.getURList(2, 2 + i);
        final stringList1 = rsg.getURList(2, 2 + i);
        final stringList2 = rsg.getURList(2, 2 + i);

        system.throwOnError = false;
        final ur0 = new URtag(PTag.kRetrieveURL, stringList0);
        log.debug('stringList0:$stringList0');
        expect(ur0, isNull);
        final ur1 = new URtag(PTag.kPixelDataProviderURL, stringList1);
        expect(ur1, isNull);
        log.debug('stringList1:$stringList1');
        final ur2 = new URtag(PTag.kRetrieveURL, stringList2);
        log.debug('stringList2:$stringList2');
        expect(ur2, isNull);

        system.throwOnError = true;
        expect(() => new URtag(PTag.kRetrieveURL, stringList0),
                   throwsA(const isInstanceOf<InvalidValuesLength>()));
        expect(() => new URtag(PTag.kPixelDataProviderURL, stringList1),
                   throwsA(const isInstanceOf<InvalidValuesLength>()));
        expect(() => new URtag(PTag.kRetrieveURL, stringList2),
                   throwsA(const isInstanceOf<InvalidValuesLength>()));
      }
    });

    test('UR valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURL, vList0);
        expect(vList0, equals(ur0.valuesCopy));
      }
    });

    test('UR isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURL, vList0);
        expect(ur0.tag.isValidLength(ur0.length), true);
      }
    });

    test('UR isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURL, vList0);
        expect(ur0.tag.isValidValues(ur0.values), true);
        expect(ur0.hasValidValues, true);
      }
    });

    test('UR replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURL, vList0);
        final vList1 = rsg.getURList(1, 1);
        expect(ur0.replace(vList1), equals(vList0));
        expect(ur0.values, equals(vList1));
      }

      final vList1 = rsg.getURList(1, 1);
      final ur1 = new URtag(PTag.kRetrieveURL, vList1);
      expect(ur1.replace([]), equals(vList1));
      expect(ur1.values, equals(<String>[]));

      final ur2 = new URtag(PTag.kRetrieveURL, vList1);
      expect(ur2.replace(null), equals(vList1));
      expect(ur2.values, equals(<String>[]));
    });

    test('UR blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURL, vList1);
        expect(ur0.blank, throwsA(const isInstanceOf<UnsupportedError>()));
      }
    });

    test('UR formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getURList(1, 1);
        final bytes = UR.toBytes(vList1);
        log.debug('bytes:$bytes');
        final ur0 = new URtag.fromBytes(PTag.kRetrieveURL, bytes);
        log.debug('ur0: ${ur0.info}');
        expect(ur0.hasValidValues, true);
      }
    });

    test('UR checkLength good values', () {
      final vList0 = rsg.getURList(1, 1);
      final ur0 = new URtag(PTag.kRetrieveURL, vList0);
      for (var s in goodURList) {
        expect(ur0.checkLength(s), true);
      }
      final ur1 = new URtag(PTag.kRetrieveURL, vList0);
      expect(ur1.checkLength([]), true);
    });

    test('UR checkLength bad values', () {
      final vList0 = rsg.getURList(1, 1);
      final vList1 = ['1.2.840.10008.5.1.4.34.5', '1.2.840.10008.3.1.2.32.7'];
      final ur2 = new URtag(PTag.kRetrieveURL, vList0);
      expect(ur2.checkLength(vList1), false);
    });

    test('UR checkValue good values', () {
      final vList0 = rsg.getURList(1, 1);
      final ur0 = new URtag(PTag.kRetrieveURL, vList0);
      for (var s in goodURList) {
        for (var a in s) {
          expect(ur0.checkValue(a), true);
        }
      }
    });

    test('UR checkValue bad values', () {
      final vList0 = rsg.getURList(1, 1);
      final ur0 = new URtag(PTag.kRetrieveURL, vList0);
      for (var s in badURList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(ur0.checkValue(a), false);
        }
      }
    });

    group('UR', () {
      //VM.k1
      const urTags0 = const <PTag>[
        PTag.kRetrieveURL,
        PTag.kPixelDataProviderURL,
        PTag.kRetrieveURI,
        PTag.kContactURI,
      ];

      //VM.k1_n
      const urTags1 = const <PTag>[PTag.kSelectorURValue];

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

      final invalidVList = rsg.getURList(UR.kMaxLength + 1, UR.kMaxLength + 1);

      test('UR checkVR good values', () {
        system.throwOnError = false;
        expect(UR.checkVRIndex(kURIndex), kURIndex);

        for (var tag in urTags0) {
          system.throwOnError = false;
          expect(UR.checkVRIndex(tag.vrIndex), tag.vrIndex);
        }
      });

      test('UR checkVR bad values', () {
        system.throwOnError = false;
        expect(
            UR.checkVRIndex(
              kAEIndex,
            ),
            isNull);
        system.throwOnError = true;
        expect(() => UR.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(UR.checkVRIndex(tag.vrIndex), isNull);

          system.throwOnError = true;
          expect(() => UR.checkVRIndex(kAEIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('UR isValidVRIndex good values', () {
        system.throwOnError = false;
        expect(UR.isValidVRIndex(kURIndex), true);

        for (var tag in urTags0) {
          system.throwOnError = false;
          expect(UR.isValidVRIndex(tag.vrIndex), true);
        }
      });

      test('UR isValidVRIndex bad values', () {
        system.throwOnError = false;
        expect(UR.isValidVRIndex(kSSIndex), false);

        system.throwOnError = true;
        expect(() => UR.isValidVRIndex(kSSIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(UR.isValidVRIndex(tag.vrIndex), false);

          system.throwOnError = true;
          expect(() => UR.isValidVRIndex(tag.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('UR isValidVRCode good values', () {
        system.throwOnError = false;
        expect(UR.isValidVRCode(kURCode), true);

        for (var tag in urTags0) {
          expect(UR.isValidVRCode(tag.vrCode), true);
        }
      });

      test('UR isValidVRCode bad values', () {
        system.throwOnError = false;
        expect(UR.isValidVRCode(kAECode), false);

        system.throwOnError = true;
        expect(() => UR.isValidVRCode(kAECode),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(UR.isValidVRCode(tag.vrCode), false);

          system.throwOnError = true;
          expect(() => UR.isValidVRCode(tag.vrCode),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('UR isValidVFLength good values', () {
        expect(UR.isValidVFLength(UR.kMaxVFLength), true);
        expect(UR.isValidVFLength(0), true);
      });

      test('UR isValidVFLength bad values', () {
        expect(UR.isValidVFLength(UR.kMaxVFLength + 1), false);
        expect(UR.isValidVFLength(-1), false);
      });

      test('UR isNotValidVFLength good values', () {
        expect(UR.isNotValidVFLength(UR.kMaxVFLength), false);
        expect(UR.isNotValidVFLength(0), false);
      });

      test('UR isNotValidVFLength bad values', () {
        expect(UR.isNotValidVFLength(UR.kMaxVFLength + 1), true);
        expect(UR.isNotValidVFLength(-1), true);
      });

      test('UR isValidValueLength', () {
        for (var s in goodURList) {
          for (var a in s) {
            expect(UR.isValidValueLength(a), true);
          }
        }
      });

      test('UR isNotValidValueLength', () {
        for (var s in goodURList) {
          for (var a in s) {
            expect(UR.isNotValidValueLength(a), false);
          }
        }
      });

      test('UR isValidVListLength VM.k1 good values', () {
        system.throwOnError = false;
        for (var i = 0; i < 10; i++) {
          final validMinVList = rsg.getURList(1, 1);
          for (var tag in urTags0) {
            expect(UR.isValidVListLength(tag, validMinVList), true);

            expect(UR.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
            expect(UR.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
          }
        }
      });

      test('UR isValidVListLength VM.k1 bad values', () {
        for (var i = 1; i < 10; i++) {
          for (var tag in urTags0) {
            final invalidValues = rsg.getURList(2, i + 1);
            system.throwOnError = false;

            expect(UR.isValidVListLength(tag, invalidVList), false);
            expect(UR.isValidVListLength(tag, invalidValues), false);

            system.throwOnError = true;
            expect(() => UR.isValidVListLength(tag, invalidVList),
                throwsA(const isInstanceOf<InvalidValuesLengthError>()));
            expect(() => UR.isValidVListLength(tag, invalidValues),
                throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          }
        }
      });

      test('UR isValidVListLength VM.k1_n good values', () {
        system.throwOnError = false;
        for (var i = 1; i < 10; i++) {
          final validMinVList0 = rsg.getURList(1, i);
          final validMaxLengthList = invalidVList.sublist(0, UR.kMaxLength);
          for (var tag in urTags1) {
            log.debug('tag: $tag');
            expect(UR.isValidVListLength(tag, validMinVList0), true);
            expect(UR.isValidVListLength(tag, validMaxLengthList), true);
          }
        }
      });

      test('UR isValidValue good values', () {
        for (var s in goodURList) {
          for (var a in s) {
            expect(UR.isValidValue(a), true);
          }
        }
      });

      test('UR isValidValue bad values', () {
        for (var s in badURList) {
          for (var a in s) {
            system.throwOnError = false;
            expect(UR.isValidValue(a), false);
          }
        }
      });

      test('UR isValidValues good values', () {
        system.throwOnError = false;
        for (var s in goodURList) {
          expect(UR.isValidValues(PTag.kRetrieveURL, s), true);
        }
      });

      test('UR isValidValues bad values', () {
        system.throwOnError = false;
        for (var s in badURList) {
          system.throwOnError = false;
          expect(UR.isValidValues(PTag.kRetrieveURL, s), false);

          system.throwOnError = true;
          expect(() => UR.isValidValues(PTag.kRetrieveURL, s),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      });

      test('UR fromBytes', () {
        system.level = Level.debug;
        final vList1 = rsg.getCSList(1, 1);
        final bytes = UR.toBytes(vList1);
        log.debug('UR.fromBytes(bytes): ${UR.fromBytes(bytes)}, bytes: $bytes');
        expect(UR.fromBytes(bytes), equals(vList1));
      });

      test('UR toBytes', () {
        final vList1 = rsg.getURList(1, 1);
        log.debug('UR.toBytes(vList1): ${UR.toBytes(vList1)}');
        final val = ASCII.encode('s6V&:;s%?Q1g5v');
        expect(UR.toBytes(['s6V&:;s%?Q1g5v']), equals(val));

        if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
        log.debug('vList1:"$vList1"');
        final values = ASCII.encode(vList1[0]);
        expect(UR.toBytes(vList1), equals(values));
      });

      test('UR fromBase64', () {
        system.throwOnError = false;
        final vList1 = rsg.getURList(1, 1);

        final v0 = UR.fromBase64(vList1);
        expect(v0, isNotNull);

        final v1 = UR.fromBase64(['PIA5']);
        expect(v1, isNotNull);

        final v2 = UR.fromBase64(['PIA']);
        expect(v2, isNotNull);
      });

      test('UR toBase64', () {
        //final s = BASE64.encode(testFrame);
        final vList0 = rsg.getURList(1, 1);
        expect(UR.toBase64(vList0), equals(vList0));

        final vList1 = ['dslkj'];
        //final s0 = ASCII.encode(vList0[0]);
        expect(UR.toBase64(vList1), equals(vList1));
      });

      test('UR parse', () {
        system.throwOnError = false;
        final vList0 = rsg.getISList(1, 1);
        expect(UR.parse(vList0[0]), Uri.parse(vList0[0]));

        final vList1 = '123';
        expect(UR.parse(vList1), Uri.parse(vList1));

        final vList2 = '12.34';
        expect(UR.parse(vList2), Uri.parse(vList2));

        final vList3 = 'abc';
        expect(UR.parse(vList3), Uri.parse(vList3));
      });

      test('UR tryParse', () {
        system.throwOnError = false;
        final vList0 = rsg.getISList(1, 1);
        expect(UR.tryParse(vList0[0]), Uri.parse(vList0[0]));

        final vList1 = '123';
        expect(UR.tryParse(vList1), Uri.parse(vList1));

        final vList2 = '12.34';
        expect(UR.tryParse(vList2), Uri.parse(vList2));

        final vList3 = 'abc';
        expect(UR.tryParse(vList3), Uri.parse(vList3));
      });

      test('UR checkList good values', () {
        system.throwOnError = false;
        for (var i = 0; i <= 10; i++) {
          final vList = rsg.getURList(1, 1);
          expect(UR.checkList(PTag.kRetrieveURL, vList), vList);
        }

        final vList0 = ['iaWlVR'];
        expect(UR.checkList(PTag.kRetrieveURL, vList0), vList0);

        for (var s in goodURList) {
          system.throwOnError = false;
          expect(UR.checkList(PTag.kRetrieveURL, s), s);
        }
      });

      test('UR checkList bad values', () {
        system.throwOnError = false;
        final vList1 = [' asdf sdf  '];
        expect(UR.checkList(PTag.kRetrieveURL, vList1), isNull);

        system.throwOnError = true;
        expect(() => UR.checkList(PTag.kRetrieveURL, vList1),
            throwsA(const isInstanceOf<InvalidValuesError>()));
        for (var s in badURList) {
          system.throwOnError = false;
          expect(UR.checkList(PTag.kRetrieveURL, s), isNull);

          system.throwOnError = true;
          expect(() => UR.checkList(PTag.kRetrieveURL, s),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      });
    });
  });
}
