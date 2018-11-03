//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/core.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'vr_index_new_test', level: Level.info);
  test('VR Index', () {
    expect(VR.kUN.index == kUNIndex, true);
    expect(isMaybeUndefinedLengthVR(kUNIndex), true);
    expect(isMaybeUndefinedLengthVR(VR.kUN.index), true);
    expect(kUNIndex == 0, true);
    expect(VR.kUN.index == 0, true);

    expect(VR.kSQ.index == kSQIndex, true);
    expect( isMaybeUndefinedLengthVR(VR.kSQ.index), true);
    expect( isMaybeUndefinedLengthVR(kSQIndex), true);

    expect(VR.kOB.index == kOBIndex, true);
    expect(isMaybeUndefinedLengthVR(kOBIndex), true);
    expect(isMaybeUndefinedLengthVR(VR.kOB.index), true);

    expect(VR.kOW.index == kOWIndex, true);





    expect(VR.kOD.index == kODIndex, true);
    expect(VR.kOD.index == 4, true);



    expect(VR.kOD.index == kODIndex, true);
    expect(isEvrLongVR(kODIndex), true);
    expect(isEvrLongVR(VR.kOD.index), true);

    expect(VR.kOF.index == kOFIndex, true);
    expect(isEvrLongVR(kODIndex), true);
    expect(isEvrLongVR(VR.kOD.index), true);

    expect(VR.kOL.index == kOLIndex, true);
    expect(isEvrLongVR(kOLIndex), true);
    expect(isEvrLongVR(VR.kOL.index), true);

    expect(VR.kUC.index == kUCIndex, true);
    expect(isEvrLongVR(kUCIndex), true);
    expect(isEvrLongVR(VR.kUC.index), true);

    expect(VR.kUR.index == kURIndex, true);
    expect(isEvrLongVR(kURIndex), true);
    expect(isEvrLongVR(VR.kUR.index), true);

    expect(VR.kUT.index == kUTIndex, true);
    expect(isEvrLongVR(kUTIndex), true);
    expect(isEvrLongVR(VR.kUT.index), true);


    expect(VR.kAE.index == kAEIndex, true);
    expect(isStringVR(kAEIndex), true);
    expect(isStringVR(VR.kAE.index), true);

    //Urgent Sharath: add expects for rest of VRs
    expect(VR.kAS.index == kASIndex, true);


    expect(VR.kAT.index == kATIndex, true);



    expect(VR.kCS.index == kCSIndex, true);


    expect(VR.kDA.index == kDAIndex, true);


    expect(VR.kDS.index == kDSIndex, true);


    expect(VR.kDT.index == kDTIndex, true);


    expect(VR.kFD.index == kFDIndex, true);


    expect(VR.kFL.index == kFLIndex, true);


    expect(VR.kIS.index == kISIndex, true);


    expect(VR.kLO.index == kLOIndex, true);


    expect(VR.kLT.index == kLTIndex, true);


    expect(VR.kPN.index == kPNIndex, true);


    expect(VR.kSH.index == kSHIndex, true);


    expect(VR.kSL.index == kSLIndex, true);


    expect(VR.kSS.index == kSSIndex, true);


    expect(VR.kST.index == kSTIndex, true);


    expect(VR.kTM.index == kTMIndex, true);


    expect(VR.kUI.index == kUIIndex, true);


    expect(VR.kUL.index == kULIndex, true);


    expect(VR.kUS.index == kUSIndex, true);


    expect(isEvrShortVRIndex(VR.kUS.index), true);


    expect(VR.kUS.index == kMaxNormalVRIndex, true);


    expect(VR.kOBOW.index == kOBOWIndex, true);


    expect(isSpecialVRIndex(VR.kOBOW.index), true);


    expect(VR.kUSSS.index == kUSSSIndex, true);


    expect(VR.kUSSSOW.index == kUSSSOWIndex, true);


    expect(VR.kUSOW.index == kUSOWIndex, true);


    expect(isSpecialVRIndex(VR.kUSOW.index), true);

  });

  test('VR isValidIndex', () {
    final vrIndex = <int>[
      AE.kVRIndex,
      CS.kVRIndex,
      SS.kVRIndex,
      ST.kVRIndex,
      DS.kVRIndex,
      DT.kVRIndex,
      UR.kVRIndex,
      OL.kVRIndex,
      OW.kVRIndex,
      OB.kVRIndex,
      AT.kVRIndex,
      DT.kVRIndex,
      TM.kVRIndex,
      DA.kVRIndex,
      IS.kVRIndex,
      LT.kVRIndex,
      PN.kVRIndex,
      FL.kVRIndex,
      OF.kVRIndex
    ];
    for (var index in vrIndex) {
      final target = index;
      final validIndex0 = VR.isValidIndex(index, null, target);
      expect(validIndex0, true);
    }

    final validIndex0 = VR.isValidIndex(AE.kVRIndex, null, 12);
    expect(validIndex0, false);

    global.throwOnError = true;
    expect(() => VR.isValidIndex(AE.kVRIndex, null, 12),
        throwsA(const TypeMatcher<InvalidVRError>()));
  });

  test('VR isValidSpecialIndex', () {
    global.throwOnError = false;
    final vrIndex = <int>[kOBOWIndex, kUSOWIndex, kUSSSOWIndex, kUSSSIndex];
    for (var index in vrIndex) {
      final validSIndex0 = VR.isValidSpecialIndex(index, null, index);
      expect(validSIndex0, true);
    }

    global.throwOnError = false;
    final validSIndex0 = VR.isValidSpecialIndex(kAEIndex, null, 12);
    expect(validSIndex0, false);

    global.throwOnError = true;
    expect(() => VR.isValidSpecialIndex(kAEIndex, null, 12),
        throwsA(const TypeMatcher<InvalidVRError>()));
  });

  test('VR isValidCode', () {
    final vrCode = <int>[
      AE.kVRCode,
      CS.kVRCode,
      SS.kVRCode,
      ST.kVRCode,
      DS.kVRCode,
      DT.kVRCode,
      UR.kVRCode,
      OL.kVRCode,
      OW.kVRCode,
      OB.kVRCode,
      AT.kVRCode,
      DT.kVRCode,
      TM.kVRCode,
      DA.kVRCode,
      IS.kVRCode,
      LT.kVRCode,
      PN.kVRCode,
      FL.kVRCode
    ];
    for (var code in vrCode) {
      final target = code;
      final validCode0 = VR.isValidCode(code, null, target);
      expect(validCode0, true);
    }

    global.throwOnError = false;
    final validCode0 = VR.isValidCode(AE.kVRCode, null, 12);
    expect(validCode0, false);

    global.throwOnError = true;
    expect(() => VR.isValidCode(AE.kVRCode, null, 12),
        throwsA(const TypeMatcher<InvalidVRError>()));
  });

  test('VR isValidSpecialIndex', () {
    global.throwOnError = false;

    final vrIndices = <int>[kOBOWIndex, kUSOWIndex, kUSSSOWIndex, kUSSSIndex];
    for (var code in vrIndices) {
      final validSIndex0 = VR.isValidSpecialIndex(code, null, code);
      expect(validSIndex0, true);
    }

    final validSIndex0 = VR.isValidSpecialIndex(kAEIndex, null, kAEIndex);
    expect(validSIndex0, true);

    global.throwOnError = true;
    expect(() => VR.isValidSpecialIndex(kAEIndex, null, kSSIndex),
        throwsA(const TypeMatcher<InvalidVRError>()));
  });
}
