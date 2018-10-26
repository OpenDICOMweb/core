//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/character/ascii.dart';

// ignore_for_file: public_member_api_docs

/// DICOM Character Set Predicates

/// *Specific Character Set*
///
/// The VRs LO, LT, SH, ST, PN, UC and UT may have their character
/// set modified by the Attribute Specific Character Set (0008,0005) Tag.
///
/// *Backslash as Value Field Separator*
///
/// The _backslash_ '\' $backslash ($reverseSolidus)] character is used
/// as a Value Field (VF) separator for all [String] based VRs, except
/// LT, ST, UR, and UT.
///
/// Returns _true_ is [c] is a visible (printable) ASCII character code.
bool _isDcrChar(int c) => (c >= kSpace) && (c < kDelete);

///
/// Returns _true_ if [c] is in DICOM's Default Character Repertoire (DCR)
/// without backspace (/);  otherwise _false_. Used for VRs of LO, PN, SH,
/// and UC. Backslash(\) not allowed, as it is used as a values separator for
/// these [String] types.
bool isDcmStringChar(int c) =>
    (c >= kSpace && c < kBackslash) || (c > kBackslash && c < kDelete);

int checkDcmStringChar(int c) => (isDcmStringChar(c)) ? c : null;

bool isDcmStringCharWithEscape(int c, {bool isEscapeAllowed = false}) =>
    isDcmStringChar(c) || (isEscapeAllowed && c == kEscape);

/// Returns _true_ if [c] is a DICOM Text Character. Used for VRs of LT,
/// ST, UR, and UT. Backslash (\) is allowed in these [String]s.
bool isDcmTextChar(int c) =>
    _isDcrChar(c) ||
    c == kLinefeed ||
    c == kReturn ||
    c == kFormfeed ||
    c == kHTab;

int checkDcmTextChar(int c) => (isDcmTextChar(c)) ? c : null;

/// Returns _true_ if c is legal in an AE Title; otherwise, _false_.
const CharPredicate isAEChar = isDcmStringChar;
const CharChecker checkAEChar = checkDcmStringChar;

/// Returns _true_ if [c] is legal in Code String; otherwise, _false_,
bool isCSChar(int c) =>
    isUppercaseChar(c) || isDigitChar(c) || (c == kSpace) || (c == kUnderscore);

int checkCSChar(int c) => (isCSChar(c)) ? c : false;

///Returns _true_ if c is legal in a DICOM Date VR DA.
/*
CharPredicate isDAChar = isDigitChar;
int checkDAChar(int c) => (isDigitChar(c)) ? c : false;
*/
///Returns _true_ if [c] is legal in a DICOM Date VR DA.
bool isDSChar(int c) =>
    isDigitChar(c) || isSignChar(c) || isDotChar(c) || isExponentChar(c);
int checkDSChar(int c) => (isDSChar(c)) ? c : false;

///Returns _true_ if c is legal in a DICOM DateTime VR DT.
/*
bool isDTChar(int c) => isTMChar(c) || isSignChar(c);
int checkDTChar(int c) => (isDTChar(c)) ? c : false;
*/

///Returns _true_ if [c] is legal in a DICOM Integer VR IS.
bool isISChar(int c) => isDigitChar(c) || isSignChar(c);
int checkISChar(int c) => (isISChar(c)) ? c : false;

///Returns _true_ if c is legal in a DICOM String with VR LO.
const CharPredicate isLOChar = isDcmStringChar;
const CharChecker checkLOChar = checkDcmStringChar;

///Returns _true_ if c is legal in a DICOM String with VR LT.
const CharPredicate isLTChar = isDcmTextChar;
const CharChecker checkLTChar = checkDcmTextChar;

///Returns _true_ if c is legal in a DICOM Person Name VR PN.
const CharPredicate isPNChar = isDcmStringChar;
const CharChecker checkPNChar = checkDcmStringChar;

///Returns _true_ if c is legal in a DICOM String with VR SH.
const CharPredicate isSHChar = isDcmStringChar;
const CharChecker checkSHChar = checkDcmStringChar;

///Returns _true_ if c is legal in a DICOM String with VR LT.
const CharPredicate isSTChar = isDcmTextChar;
const CharChecker checkSTChar = checkDcmTextChar;

bool _isDigitOrDot(int c) => isDigitChar(c) || (c == kDot);
int _checkDigitOrDot(int c) => (_isDigitOrDot(c)) ? c : null;

/*
///Returns _true_ if c is legal in a DICOM String with Time VR TM.
const CharPredicate isTMChar = _isDigitOrDot;
const CharChecker checkTMChar = _checkDigitOrDot;
*/
///Returns _true_ if c is legal in a DICOM String with VR UC.
const CharPredicate isUCChar = isDcmStringChar;
const CharChecker checkUCChar = checkDcmStringChar;

///Returns _true_ if c is legal in a DICOM String with VR UI.
const CharPredicate isUIChar = _isDigitOrDot;
const CharChecker checkUIChar = _checkDigitOrDot;

///Returns _true_ if c is legal in a DICOM String with VR UR.
const CharPredicate isURChar = isDcmTextChar;
const CharChecker checkURChar = checkDcmTextChar;

///Returns _true_ if c is legal in a DICOM String with VR UT.
const CharPredicate isUTChar = isDcmTextChar;
const CharChecker checkUTChar = checkDcmTextChar;
