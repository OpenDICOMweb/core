//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/core.dart';
import 'package:test/test.dart';


// Urgent: move any other VR tests from Tag to Test.
void main() {
  test('VR Index', () {
    expect(VR.kSQ.index == kSQIndex, true);
    expect(VR.kSQ.index == 0, true);

    expect(VR.kOB.index == kOBIndex,  true);
    expect(VR.kOB.index == 1, true);

    expect(VR.kOB.index == kVRMaybeUndefinedIndexMin, true);
    expect(VR.kOB.index == 1, true);

    expect(VR.kOW.index == kOWIndex,  true);
    expect(VR.kOW.index == 2, true);

    expect(VR.kUN.index == kUNIndex,  true);
    expect(VR.kUN.index == 3, true);

    expect(VR.kUN.index == kVRMaybeUndefinedIndexMax, true);
    expect(VR.kUN.index == 3, true);

    expect(VR.kOD.index == kODIndex,  true);
    expect(VR.kOD.index == 4, true);

    expect(VR.kSQ.index == kVRIndexMin, true);
    expect(VR.kSQ.index == 0, true);

    expect(VR.kOD.index == kVRDefinedLongIndexMin, true);
    expect(VR.kOD.index == 4, true);

    expect(VR.kOD.index == kVRDefinedLongIndexMin, true);
    expect(VR.kOD.index == 4, true);

    expect(VR.kOF.index == kOFIndex,  true);
    expect(VR.kOF.index == 5, true);

    expect(VR.kOL.index == kOLIndex,  true);
    expect(VR.kOL.index == 6, true);

    expect(VR.kUC.index == kUCIndex,  true);
    expect(VR.kUC.index == 7, true);

    expect(VR.kUR.index == kURIndex,  true);
    expect(VR.kUR.index == 8, true);

    expect(VR.kUT.index == kUTIndex,  true);
    expect(VR.kUT.index == 9, true);

    expect(VR.kUT.index == kVREvrLongIndexMax, true);
    expect(VR.kUT.index == 9, true);

    expect(VR.kAE.index == kAEIndex,  true);
    expect(VR.kAE.index == 10, true);

    expect(VR.kAE.index == kVREvrShortIndexMin, true);
    expect(VR.kAE.index == 10, true);

    expect(VR.kAS.index == kASIndex,  true);
    expect(VR.kAS.index == 11, true);

    expect(VR.kAT.index == kATIndex,  true);
    expect(VR.kAT.index == 12, true);

    expect(VR.kCS.index == kCSIndex,  true);
    expect(VR.kCS.index == 13, true);

    expect(VR.kDA.index == kDAIndex,  true);
    expect(VR.kDA.index == 14, true);

    expect(VR.kDS.index == kDSIndex,  true);
    expect(VR.kDS.index == 15, true);

    expect(VR.kDT.index == kDTIndex,  true);
    expect(VR.kDT.index == 16, true);

    expect(VR.kFD.index == kFDIndex,  true);
    expect(VR.kFD.index == 17, true);

    expect(VR.kFL.index == kFLIndex,  true);
    expect(VR.kFL.index == 18, true);

    expect(VR.kIS.index == kISIndex,  true);
    expect(VR.kIS.index == 19, true);

    expect(VR.kLO.index == kLOIndex,  true);
    expect(VR.kLO.index == 20, true);

    expect(VR.kLT.index == kLTIndex,  true);
    expect(VR.kLT.index == 21, true);

    expect(VR.kPN.index == kPNIndex,  true);
    expect(VR.kPN.index == 22, true);

    expect(VR.kSH.index == kSHIndex,  true);
    expect(VR.kSH.index == 23, true);

    expect(VR.kSL.index == kSLIndex,  true);
    expect(VR.kSL.index == 24, true);

    expect(VR.kSS.index == kSSIndex,  true);
    expect(VR.kSS.index == 25, true);

    expect(VR.kST.index == kSTIndex,  true);
    expect(VR.kST.index == 26, true);

    expect(VR.kTM.index == kTMIndex,  true);
    expect(VR.kTM.index == 27, true);

    expect(VR.kUI.index == kUIIndex,  true);
    expect(VR.kUI.index == 28, true);

    expect(VR.kUL.index == kULIndex,  true);
    expect(VR.kUL.index == 29, true);

    expect(VR.kUS.index == kUSIndex,  true);
    expect(VR.kUS.index == 30, true);

    expect(VR.kUS.index == kVREvrShortIndexMax, true);
    expect(VR.kUS.index == 30, true);

    expect(VR.kUS.index == kVRNormalIndexMax, true);
    expect(VR.kUS.index == 30, true);

    expect(VR.kOBOW.index == kOBOWIndex,  true);
    expect(VR.kOBOW.index == 31, true);

    expect(VR.kOBOW.index == kVRSpecialIndexMin, true);
    expect(VR.kOBOW.index == 31, true);

    expect(VR.kUSSS.index == kUSSSIndex,  true);
    expect(VR.kUSSS.index == 32, true);

    expect(VR.kUSSSOW.index == kUSSSOWIndex,  true);
    expect(VR.kUSSSOW.index == 33, true);

    expect(VR.kUSOW.index == kUSOWIndex,  true);
    expect(VR.kUSOW.index == 34, true);

    expect(VR.kUSOW.index == kVRSpecialIndexMax, true);
    expect(VR.kUSOW.index == 34, true);
  });
}
