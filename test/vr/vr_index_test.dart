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
  Server.initialize(name: 'vr_index_test', level: Level.info);
  test('VR Index', () {
    expect(VR.kUN.index == kUNIndex, true);
    expect(isMaybeUndefinedLengthVR(kUNIndex), true);
    expect(isMaybeUndefinedLengthVR(VR.kUN.index), true);
    expect(kUNIndex == 0, true);
    expect(VR.kUN.index == 0, true);

    expect(VR.kSQ.index == kSQIndex, true);
    expect(isMaybeUndefinedLengthVR(VR.kSQ.index), true);
    expect(isMaybeUndefinedLengthVR(kSQIndex), true);

    expect(VR.kOB.index == kOBIndex, true);
    expect(isMaybeUndefinedLengthVR(kOBIndex), true);
    expect(isMaybeUndefinedLengthVR(VR.kOB.index), true);
    expect(isValidOBIndex(kOBIndex), true);
    expect(isValidOBIndex(VR.kOB.index), true);

    expect(VR.kOW.index == kOWIndex, true);
    expect(isMaybeUndefinedLengthVR(kOWIndex), true);
    expect(isMaybeUndefinedLengthVR(VR.kOW.index), true);
    expect(kOWIndex == 3, true);
    expect(VR.kOW.index == 3, true);
    expect(isValidOWIndex(kOWIndex), true);
    expect(isValidOWIndex(VR.kOW.index), true);

    expect(VR.kOD.index == kODIndex, true);
    expect(VR.kOD.index == 4, true);
    expect(isEvrLongVR(kODIndex), true);
    expect(isEvrLongVR(VR.kOD.index), true);
    expect(isFloatVR(kODIndex), true);
    expect(isFloatVR(VR.kOD.index), true);

    expect(VR.kOF.index == kOFIndex, true);
    expect(isEvrLongVR(kOFIndex), true);
    expect(isEvrLongVR(VR.kOF.index), true);
    expect(isFloatVR(kODIndex), true);
    expect(isFloatVR(VR.kOF.index), true);

    expect(VR.kOL.index == kOLIndex, true);
    expect(isEvrLongVR(kOLIndex), true);
    expect(isEvrLongVR(VR.kOL.index), true);

    expect(VR.kUC.index == kUCIndex, true);
    expect(isEvrLongVR(kUCIndex), true);
    expect(isEvrLongVR(VR.kUC.index), true);
    expect(isLongStringVR(kUCIndex), true);
    expect(isLongStringVR(VR.kUC.index), true);

    expect(VR.kUR.index == kURIndex, true);
    expect(isEvrLongVR(kURIndex), true);
    expect(isEvrLongVR(VR.kUR.index), true);
    expect(isLongStringVR(kURIndex), true);
    expect(isLongStringVR(VR.kUR.index), true);

    expect(VR.kUT.index == kUTIndex, true);
    expect(isEvrLongVR(kUTIndex), true);
    expect(isEvrLongVR(VR.kUT.index), true);
    expect(isLongStringVR(kUTIndex), true);
    expect(isLongStringVR(VR.kUT.index), true);

    expect(VR.kAE.index == kAEIndex, true);
    expect(isStringVR(kAEIndex), true);
    expect(isStringVR(VR.kAE.index), true);
    expect(isShortStringVR(kAEIndex), true);
    expect(isShortStringVR(VR.kAE.index), true);

    expect(VR.kAS.index == kASIndex, true);
    expect(isStringVR(kASIndex), true);
    expect(isStringVR(VR.kAS.index), true);
    expect(isShortStringVR(kASIndex), true);
    expect(isShortStringVR(VR.kAS.index), true);

    expect(VR.kAT.index == kATIndex, true);
    expect(isEvrShortVRIndex(kATIndex), true);
    expect(isEvrShortVRIndex(VR.kAT.index), true);

    expect(VR.kCS.index == kCSIndex, true);
    expect(isStringVR(kCSIndex), true);
    expect(isStringVR(VR.kCS.index), true);
    expect(isShortStringVR(kCSIndex), true);
    expect(isShortStringVR(VR.kCS.index), true);

    expect(VR.kDA.index == kDAIndex, true);
    expect(isStringVR(kDAIndex), true);
    expect(isStringVR(VR.kDA.index), true);
    expect(isShortStringVR(kDAIndex), true);
    expect(isShortStringVR(VR.kDA.index), true);

    expect(VR.kDS.index == kDSIndex, true);
    expect(isStringVR(kDSIndex), true);
    expect(isStringVR(VR.kDS.index), true);
    expect(isShortStringVR(kDSIndex), true);
    expect(isShortStringVR(VR.kDS.index), true);

    expect(VR.kDT.index == kDTIndex, true);
    expect(isStringVR(kDTIndex), true);
    expect(isStringVR(VR.kDT.index), true);
    expect(isShortStringVR(kDTIndex), true);
    expect(isShortStringVR(VR.kDT.index), true);

    expect(VR.kFD.index == kFDIndex, true);
    expect(isFloatVR(kFDIndex), true);
    expect(isFloatVR(VR.kFD.index), true);

    expect(VR.kFL.index == kFLIndex, true);
    expect(isFloatVR(kFDIndex), true);
    expect(isFloatVR(VR.kFD.index), true);

    expect(VR.kIS.index == kISIndex, true);
    expect(isStringVR(kISIndex), true);
    expect(isStringVR(VR.kIS.index), true);
    expect(isShortStringVR(kISIndex), true);
    expect(isShortStringVR(VR.kIS.index), true);

    expect(VR.kLO.index == kLOIndex, true);
    expect(isStringVR(kLOIndex), true);
    expect(isStringVR(VR.kLO.index), true);
    expect(isShortStringVR(kLOIndex), true);
    expect(isShortStringVR(VR.kLO.index), true);

    expect(VR.kLT.index == kLTIndex, true);
    expect(isStringVR(kLTIndex), true);
    expect(isStringVR(VR.kLT.index), true);
    expect(isShortStringVR(kLTIndex), true);
    expect(isShortStringVR(VR.kLT.index), true);

    expect(VR.kPN.index == kPNIndex, true);
    expect(isStringVR(kPNIndex), true);
    expect(isStringVR(VR.kPN.index), true);
    expect(isShortStringVR(kPNIndex), true);
    expect(isShortStringVR(VR.kPN.index), true);

    expect(VR.kSH.index == kSHIndex, true);
    expect(isStringVR(kSHIndex), true);
    expect(isStringVR(VR.kSH.index), true);
    expect(isShortStringVR(kSHIndex), true);
    expect(isShortStringVR(VR.kSH.index), true);

    expect(VR.kSL.index == kSLIndex, true);
    expect(isEvrShortVRIndex(kSLIndex), true);
    expect(isEvrShortVRIndex(VR.kSL.index), true);

    expect(VR.kSS.index == kSSIndex, true);
    expect(isEvrShortVRIndex(kSSIndex), true);
    expect(isEvrShortVRIndex(VR.kSS.index), true);
    expect(isValidSSIndex(kSSIndex), true);
    expect(isValidSSIndex(VR.kSS.index), true);

    expect(VR.kST.index == kSTIndex, true);
    expect(isStringVR(kSTIndex), true);
    expect(isStringVR(VR.kST.index), true);
    expect(isShortStringVR(kSTIndex), true);
    expect(isShortStringVR(VR.kST.index), true);

    expect(VR.kTM.index == kTMIndex, true);
    expect(isStringVR(kTMIndex), true);
    expect(isStringVR(VR.kTM.index), true);
    expect(isShortStringVR(kTMIndex), true);
    expect(isShortStringVR(VR.kTM.index), true);

    expect(VR.kUI.index == kUIIndex, true);
    expect(isStringVR(kUIIndex), true);
    expect(isStringVR(VR.kUI.index), true);
    expect(isShortStringVR(kUIIndex), true);
    expect(isShortStringVR(VR.kUI.index), true);

    expect(VR.kUL.index == kULIndex, true);
    expect(isEvrShortVRIndex(kULIndex), true);
    expect(isEvrShortVRIndex(VR.kUL.index), true);

    expect(VR.kUS.index == kUSIndex, true);
    expect(isEvrShortVRIndex(kUSIndex), true);
    expect(isEvrShortVRIndex(VR.kUS.index), true);
    expect(VR.kUS.index == kMaxNormalVRIndex, true);
    expect(isValidUSIndex(kUSIndex), true);
    expect(isValidUSIndex(VR.kUS.index), true);

    expect(VR.kOBOW.index == kOBOWIndex, true);
    expect(isSpecialVRIndex(kOBOWIndex), true);
    expect(isSpecialVRIndex(VR.kOBOW.index), true);
    expect(isValidOBIndex(kOBOWIndex), true);
    expect(isValidOBIndex(VR.kOBOW.index), true);
    expect(isValidOWIndex(kOBOWIndex), true);
    expect(isValidOWIndex(VR.kOBOW.index), true);

    expect(VR.kUSSS.index == kUSSSIndex, true);
    expect(isSpecialVRIndex(kUSSSIndex), true);
    expect(isSpecialVRIndex(VR.kUSSS.index), true);
    expect(isValidUSIndex(kUSSSIndex), true);
    expect(isValidUSIndex(VR.kUSSS.index), true);

    expect(VR.kUSSSOW.index == kUSSSOWIndex, true);
    expect(isSpecialVRIndex(kUSSSOWIndex), true);
    expect(isSpecialVRIndex(VR.kUSSSOW.index), true);
    expect(isValidOWIndex(kUSSSOWIndex), true);
    expect(isValidOWIndex(VR.kUSSSOW.index), true);
    expect(isValidSSIndex(kUSSSOWIndex), true);
    expect(isValidSSIndex(VR.kUSSSOW.index), true);
    expect(isValidUSIndex(kUSSSOWIndex), true);
    expect(isValidUSIndex(VR.kUSSSOW.index), true);

    expect(VR.kUSOW.index == kUSOWIndex, true);
    expect(isSpecialVRIndex(kUSOWIndex), true);
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
