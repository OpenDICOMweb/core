//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/dicom.dart';
import 'package:core/src/vr/new_vr/vr_code.dart';
import 'package:core/src/vr/new_vr/vr_index.dart';

// ignore_for_file: type_annotate_public_apis, public_member_api_docs

class VR<T> {
  final int index; // done   // done
  final String id; // done called vrKeyword
  final int code;
  final int vlfSize;
  final int maxVFLength;

  const VR(this.index, this.id, this.code, this.vlfSize, this.maxVFLength);

  VR operator [](int vrIndex) => vrByIndex[vrIndex];

  // Sequence == 0,
  static const VR kSQ = VRSequence.kSQ;

  // Begin EVR Long integers
  static const VR kUN = VRInt.kUN;
  static const VR kOB = VRInt.kOB;
  static const VR kOW = VRInt.kOW;

  // End maybe Undefined Length
  static const VR kOL = VRInt.kOL;

  // EVR Long floats
  static const VR kOD = VRFloat.kOD;
  static const VR kOF = VRFloat.kOF;

  // EVR Long Strings
  static const VR kUC = VRUtf8.kUC;
  static const VR kUR = VRText.kUR;
  static const VR kUT = VRText.kUT;

  // End Evr Long
  // Begin EVR Short
  // Short Numbers
  static const VR kSS = VRInt.kSS;
  static const VR kUS = VRInt.kUS;
  static const VR kSL = VRInt.kSL;
  static const VR kUL = VRInt.kUL;
  static const VR kAT = VRInt.kAT;
  static const VR kFL = VRFloat.kFL;
  static const VR kFD = VRFloat.kFD;

  // Short Strings
  static const VR kSH = VRUtf8.kSH;
  static const VR kLO = VRUtf8.kLO;
  static const VR kST = VRText.kST;
  static const VR kLT = VRText.kLT;

  // Short Number Strings
  static const VR kDS = VRAscii.kDS;
  static const VR kIS = VRAscii.kIS;

  // Short Date/Time
  static const VR kAS = VRAscii.kAS;
  static const VR kDA = VRAscii.kDA;
  static const VR kDT = VRAscii.kDT;
  static const VR kTM = VRAscii.kTM;

  // Special Strings
  static const VR kAE = VRAscii.kAE;
  static const VR kCS = VRAscii.kCS;
  static const VR kPN = VRAscii.kPN;
  static const VR kUI = VRAscii.kUI;

  static const VR kOBOW = VRSpecial.kOBOW;
  static const VR kUSSS = VRSpecial.kUSSS;
  static const VR kUSSSOW = VRSpecial.kUSSSOW;
  static const VR kUSOW = VRSpecial.kUSOW;

  static const List<VR> byIndex = <VR>[
    VR.kUN,
    // Begin maybe undefined length
    VR.kSQ, // Sequence == 0,
    // Begin EVR Long integers
    VR.kOB, VR.kOW,
    // End maybe Undefined Length
    VR.kOL,
    // EVR Long floats
    VR.kOD, VR.kOF,
    // EVR Long Strings
    VR.kUC, VR.kUR, VR.kUT,
    // End Evr Long
    // Begin EVR Short
    // Short Numbers
    VR.kSS, VR.kUS, VR.kSL, VR.kUL, VR.kAT, VR.kFL, VR.kFD,
    // Short Strings
    VR.kSH, VR.kLO, VR.kST, VR.kLT,
    // Short Number Strings
    VR.kDS, VR.kIS,
    // Short Date/Time
    VR.kAS, VR.kDA, VR.kDT, VR.kTM,
    // Special Strings
    VR.kAE, VR.kCS, VR.kPN, VR.kUI,
    // End Evr Short
    // EVR Special VRs
    //'OBOW', 'USSS', 'USSSOW', 'USOW'
  ];
}

class VRFloat extends VR<double> {
  final int sizeInBytes; // size in bytes

  const VRFloat(int index, String id, int code, int vlfSize, int maxVFLength,
      this.sizeInBytes)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ sizeInBytes;

  static const VRFloat kFL =
      VRFloat(kFLIndex, 'FL', kFLCode, 2, kMaxShortVF, 4);
  static const VRFloat kFD =
      VRFloat(kFDIndex, 'FD', kFDCode, 2, kMaxShortVF, 8);
  static const VRFloat kOF = VRFloat(kOFIndex, 'OF', kOFCode, 4, kMaxLongVF, 4);
  static const VRFloat kOD = VRFloat(kODIndex, 'OD', kODCode, 4, kMaxLongVF, 8);
}

class VRInt extends VR<int> {
  final int sizeInBytes; // size in bytes

  const VRInt(int index, String id, int code, int vlfSize, int maxVFLength,
      this.sizeInBytes)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ sizeInBytes;

  static const VRInt kUN = VRInt(kUNIndex, 'UN', kUNCode, 4, kMaxLongVF, 1);
  static const VRInt kOB = VRInt(kOBIndex, 'OB', kOBCode, 4, kMaxLongVF, 1);

  static const VRInt kSS = VRInt(kSSIndex, 'SS', kSSCode, 2, kMaxShortVF, 2);
  static const VRInt kUS = VRInt(kUSIndex, 'US', kUSCode, 2, kMaxShortVF, 2);
  static const VRInt kOW = VRInt(kOWIndex, 'OW', kOWCode, 4, kMaxLongVF, 2);

  static const VRInt kSL = VRInt(kSLIndex, 'SL', kSLCode, 2, kMaxShortVF, 4);
  static const VRInt kUL = VRInt(kULIndex, 'UL', kULCode, 2, kMaxShortVF, 4);
  static const VRInt kAT = VRInt(kATIndex, 'AT', kATCode, 2, kMaxShortVF, 4);
  static const VRInt kOL = VRInt(kOLIndex, 'OL', kOLCode, 4, kMaxLongVF, 4);
}

class VRAscii extends VR<String> {
  final int minVLength;
  final int maxVLength;

  const VRAscii(int index, String id, int code, int vlfSize, int maxVFLength,
      this.minVLength, this.maxVLength)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ 2;

  static const VRAscii kDS =
      VRAscii(kDSIndex, 'DS', kDSCode, 2, kMaxShortVF, 1, 16);
  static const VRAscii kIS =
      VRAscii(kISIndex, 'IS', kISCode, 2, kMaxShortVF, 1, 12);

  static const VRAscii kAS =
      VRAscii(kASIndex, 'AS', kASCode, 2, kMaxShortVF, 4, 4);
  static const VRAscii kDA =
      VRAscii(kDAIndex, 'DA', kDACode, 2, kMaxShortVF, 8, 8);
  static const VRAscii kDT =
      VRAscii(kDTIndex, 'DT', kDTCode, 2, kMaxShortVF, 4, 26);
  static const VRAscii kTM =
      VRAscii(kTMIndex, 'TM', kTMCode, 2, kMaxShortVF, 2, 13);

  static const VRAscii kAE =
      VRAscii(kAEIndex, 'AE', kAECode, 2, kMaxShortVF, 1, 16);
  static const VRAscii kCS =
      VRAscii(kCSIndex, 'CS', kCSCode, 2, kMaxShortVF, 1, 16);
  static const VRAscii kPN =
      VRAscii(kPNIndex, 'PN', kPNCode, 2, kMaxShortVF, 1, 3 * 64);
  static const VRAscii kUI =
      VRAscii(kUIIndex, 'UI', kUICode, 2, kMaxShortVF, 5, 64);
}

class VRUtf8 extends VR<String> {
  final int minVLength;
  final int maxVLength;

  const VRUtf8(int index, String id, int code, int vlfSize, int maxVFLength,
      this.minVLength, this.maxVLength)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ 2;

  static const VRUtf8 kSH =
      VRUtf8(kSHIndex, 'SH', kSHCode, 2, kMaxShortVF, 1, 16);
  static const VRUtf8 kLO =
      VRUtf8(kLOIndex, 'LO', kLOCode, 2, kMaxShortVF, 1, 64);
  static const VRUtf8 kUC =
      VRUtf8(kUCIndex, 'UC', kUCCode, 4, kMaxLongVF, 1, kMaxLongVF);
}

class VRText extends VR<String> {
  const VRText(int index, String id, int code, int vlfSize, int maxVFLength)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => 1;

  static const VRText kST = VRText(kSTIndex, 'ST', kSTCode, 2, kMaxShortVF);
  static const VRText kLT = VRText(kLTIndex, 'LT', kLTCode, 2, kMaxShortVF);
  static const VRText kUR = VRText(kURIndex, 'UR', kURCode, 4, kMaxLongVF);
  static const VRText kUT = VRText(kUTIndex, 'UT', kUTCode, 4, kMaxLongVF);
}

class VRSequence extends VR<int> {
  const VRSequence(int index, String id, int code, int vlfSize, int maxVFLength)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => kMaxLongVF;

  static const VRSequence kSQ =
      VRSequence(kSQIndex, 'SQ', kSQCode, 4, kMaxLongVF);
}

class VRSpecial extends VR<int> {
  final List<VRInt> vrs;

  const VRSpecial(
      int index, String id, int code, int vlfSize, int maxVFLength, this.vrs)
      : super(index, id, code, vlfSize, maxVFLength);

  static const VRSpecial kOBOW =
      VRSpecial(kOBOWIndex, 'OBOW', -1, 0, 0, <VRInt>[VR.kOB, VR.kOW]);
  static const VRSpecial kUSSS =
      VRSpecial(kUSSSIndex, 'USSS', -1, 0, 0, <VRInt>[VR.kUS, VR.kSS]);
  static const VRSpecial kUSSSOW = VRSpecial(
      kUSSSOWIndex, 'kUSSSOW', -1, 0, 0, <VRInt>[VR.kUS, VR.kSS, VR.kOW]);
  static const VRSpecial kUSOW =
      VRSpecial(kUSOWIndex, 'USOW', -1, 0, 0, <VRInt>[VR.kUS, VR.kOW]);
}

const List<VR> vrByIndex = <VR>[
  VR.kUN,
  // Begin maybe undefined length
  VR.kSQ, // Sequence == 0,
  // Begin EVR Long integers
  VR.kOB, VR.kOW,
  // End maybe Undefined Length
  VR.kOL,
  // EVR Long floats
  VR.kOD, VR.kOF,
  // EVR Long Strings
  VR.kUC, VR.kUR, VR.kUT,
  // End Evr Long
  // Begin EVR Short
  // Short Numbers
  VR.kSS, VR.kUS, VR.kSL, VR.kUL, VR.kAT, VR.kFL, VR.kFD,
  // Short Strings
  VR.kSH, VR.kLO, VR.kST, VR.kLT,
  // Short Number Strings
  VR.kDS, VR.kIS,
  // Short Date/Time
  VR.kAS, VR.kDA, VR.kDT, VR.kTM,
  // Special Strings
  VR.kAE, VR.kCS, VR.kPN, VR.kUI,
  // End Evr Short
  // EVR Special VRs
  //'OBOW', 'USSS', 'USSSOW', 'USOW'
];
