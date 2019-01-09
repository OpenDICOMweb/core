//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

/// The Ascii (ISO IR-6) character codes and predicates.
/// A set of defined constants for Ascii code points, along with
/// a set of related predicates.

/// Control Characters
/// NUL:  Null
const int kNul = 0;
const int kNull = 0;

/// SOH:  Start of Header
const int kSoh = 1;

/// STX:  Start of Text
const int kStx = 2;

/// ETX:  End of Text
const int kEtx = 3;

/// EOT:  End of Transmission
const int kEot = 4;

/// ENQ:  Enquiry
const int kEnq = 5;

/// ACK:  Acknowledge
const int kAck = 6;

/// BEL:  Bell (beep)
const int kBel = 7;
const int kBeep = 7;

/// SO:  Shift Out
const int kSo = 14;

/// SI:  Shift In
const int kSi = 15;

/// DLE:  Data Link Escape
const int kDle = 16;

/// DC1:  Device Control 1 (XON)
const int kDci = 17;

/// DC2:  Device Control 2
const int kDc2 = 18;

/// DC3:  Device Control 3 (XOFF)
const int kDc3 = 19;

/// DC4:  Device Control 4
const int kDc4 = 20;

/// NAK:  Negative Acknowledge
const int kNak = 21;

/// SYN:  Synchronous Idle
const int kSyn = 22;

/// ETB:  End of Transmission Block
const int kEtb = 23;

/// CAN:  Cancel
const int kCan = 24;

/// EM:  End of Medium
const int kEm = 25;

/// SUB:  Substitute
const int kSub = 26;

/// ESC:  Escape
const int kEsc = 27;
const int kEscape = 27;

/// FS:  File Separator
const int kFs = 28;

/// GS:  Group Separator
const int kGs = 29;

/// RS:  Record Separator
const int kRs = 30;

/// US:  Unit Separator
const int kUs = 31;

/// DEL:  Delete
const int kDel = 127;
const int kDelete = 127;

/// Whitespace Characters
/// BS:  Backspace
const int kBs = 8;
const int kBackspace = 8;

/// HT:  Horizontal Tab
const int kHt = 9;
const int kHTab = 9;
const int kTab = 9;

/// LF:  Line Feed
const int kLf = 10;
const int kLinefeed = 10;
const int knewline = 10;

/// VT:  Vertical Tab
const int kVt = 11;
const int kVTab = 11;

/// FF:  Form Feed
const int kFf = 12;
const int kFormfeed = 12;

/// CR:  Carriage Return
const int kCr = 13;
const int kReturn = 13;

/// SP:  Space
const int kSp = 32;
const int kSpace = 32;

// Digit Characters

/// DIGIT_0:  Digit Zero
const int kDigit0 = 48;
const int k0 = 48;

/// DIGIT_1:  Digit One
const int kDigit1 = 49;
const int k1 = 49;

/// DIGIT_2:  Digit Two
const int kDigit2 = 50;
const int k2 = 50;

/// DIGIT_3:  Digit Three
const int kDdigit3 = 51;
const int k3 = 51;

/// DIGIT_4:  Digit Four
const int kDigit4 = 52;
const int k4 = 52;

/// DIGIT_5:  Digit Five
const int kDigit5 = 53;
const int k5 = 53;

/// DIGIT_6:  Digit Six
const int kDigit6 = 54;
const int k6 = 54;

/// DIGIT_7:  Digit Seven
const int kDigit7 = 55;
const int k7 = 55;

/// DIGIT_8:  Digit Eight
const int kDigit8 = 56;
const int k8 = 56;

/// DIGIT_9:  Digit Nine
const int kDigit9 = 57;
const int k9 = 57;

/// Uppercase (Capital) Letters
const int kA = 65;
const int kB = 66;
const int kC = 67;
const int kD = 68;
const int kE = 69;
const int kF = 70;
const int kG = 71;
const int kH = 72;
const int kI = 73;
const int kJ = 74;
const int kK = 75;
const int kL = 76;
const int kM = 77;
const int kN = 78;
const int kO = 79;
const int kP = 80;
const int kQ = 81;
const int kR = 82;
const int kS = 83;
const int kT = 84;
const int kU = 85;
const int kV = 86;
const int kW = 87;
const int kX = 88;
const int kY = 89;
const int kZ = 90;

/// Lowercase Letters with "k" prefix
const int ka = 97;
const int kb = 98;
const int kc = 99;
const int kd = 100;
const int ke = 101;
const int kf = 102;
const int kg = 103;
const int kh = 104;
const int ki = 105;
const int kj = 106;
const int kk = 107;
const int kl = 108;
const int km = 109;
const int kn = 110;
const int ko = 111;
const int kp = 112;
const int kq = 113;
const int kr = 114;
const int ks = 115;
const int kt = 116;
const int ku = 117;
const int kv = 118;
const int kw = 119;
const int kx = 120;
const int ky = 121;
const int kz = 122;

// Punctuation Characters
/// EXCLAM:  Exclamation Mark
const int kExclam = 33;
const int kExclamationMark = 33;
const int kExclamation = 33;

/// QUOTE:  Quotation Mark
const int kDQ = 34;
const int kDQuote = 34;
const int kQuotationMark = 34;
const int kQUOTATION = 34;
const int kDoubleQuote = 34;

/// NUMBER:  Number Sign
const int kNumber = 35;
const int kNumberSign = 35;
const int kSharp = 35;

/// DOLLAR:  Dollar Sign
const int k$ = 36;
const int kDollar = 36;
const int kDollarSign = 36;

/// PERCENT:  Percent Sign
const int kPercent = 37;
const int kPercentSign = 37;

/// AMPER:  Ampersand
const int kAmper = 38;
const int kAmpersand = 38;

/// SQUOTE:  Single Quote,Apostrophe
const int kSQ = 39;
const int kSQuote = 39;
const int kApostrophe = 39;
const int kSingleQuote = 39;

/// LParen:  Left Parentheses
const int kLParen = 40;
const int kLeftParentheses = 40;

/// RPAREN:  Rigth Parentheses
const int kRParen = 41;
const int kRightParentheses = 41;

/// STAR:  Asterisk
const int kStar = 42;
const int kAsterisk = 42;

/// PLUS:  Plus Sign
const int kPlus = 43;
const int kPlusSign = 43;

/// COMMA:  Comma
const int kComma = 44;

/// MINUS:  Hyphen, Minus Sign
const int kMinus = 45;
const int kMinusSign = 45;
const int kDash = 45;
const int kHyphen = 45;

/// PERIOD:  Period, Full Stop
const int kPeriod = 46;
const int kDot = 46;
const int kFullStop = 46;

/// SLASH:  Solidus, Slash
const int kSlash = 47;
const int kSolidus = 47;

/// COLON:  Colon
const int kColon = 58;

/// SEMI:  Semicolon
const int kSemi = 59;
const int kSemicolon = 59;

/// LESS:  Less-Than Sign, Left Angle Bracket
const int kLess = 60;
const int kLessThanSign = 60;
const int kLessThan = 60;
const int kLeftAngle = 60;

/// EQUAL:  Equals Sign
const int kEqual = 61;
const int kEqualSign = 61;

/// GREATER:  Greater-Than Sign, Right Angle Bracket
const int kGreater = 62;
const int kGreaterThanSign = 62;
const int kGreaterThan = 62;
const int kRightAngle = 62;

/// QUESTION:  Question Mark
const int kQuestion = 63;
const int kQuestionMark = 63;

/// At Sign:  Commercial At Sign
const int kAtSign = 64;
const int kCommercialAtSign = 64;
const int kAt = 64;

/// Left Square Bracket
const int kLSquare = 91;
const int kLeftSquareBracket = 91;

/// Backslash:  Reverse Solidus
const int kBackslash = 92;
const int kReverseSolidus = 92;

/// Right Square Bracket
const int kRSquare = 93;
const int kRSquareBracket = 93;

/// Circumflex:  Circumflex Accent
const int kCircumflex = 94;
const int kCircumflexAccent = 94;

/// Underscore:  Low Line, Underline,
// ignore: constant_identifier_names
const int k_ = 95;
const int kUnderline = 95;
const int kUnderscore = 95;
const int kLowLine = 95;

/// Grave:  Grave Accent
const int kGrave = 96;
const int kGraveAccent = 96;

/// LBrace:  Left Curly Bracket, Left Brace
const int kLBrace = 123;
const int kLeftCurlyBracket = 123;
const int kLCurley = 123;

/// VBar:  Vertical Line, Vertical Bar
const int kVBar = 124;
const int kVerticalLine = 124;
const int kVLine = 124;
const int kVerticalBar = 124;

/// RBrace:  Right Curly Bracket, Right Brace
const int kRBrace = 125;
const int kRightCurlyBracket = 125;
const int kRCurly = 125;

/// Tilde
const int kTilde = 126;

/// The type of a character predicate.
typedef CharPredicate = bool Function(int c);

/// The type of a character checker.
typedef CharChecker = int Function(int c);

// **** Predicates ****

/// Returns True if the [c] is an Ascii control character.
bool isControlChar(int c) => ((c >= 0) && (c <= kUs)) || (c == kDelete);

/// Returns True if the [c] is a decimal digit.
bool isDigitChar(int c) => (c >= k0) && (c <= k9);

/// Returns True if the [c] is a hexadecimal digit.
bool isHexChar(int c) =>
    (k0 <= c && c <= k9) || (kA <= c && c <= kF) || (ka <= c && c <= kf);

/// Returns _true_ if [c] is an uppercase character.
bool isUppercaseChar(int c) => (c >= kA) && (c <= kZ);

/// Returns _true_ if [c] is an lowercase character.
bool isLowercaseChar(int c) => c >= ka && c <= kz;

/// Returns _true_ if [c] is an alphabetic character.
bool isAlphabeticChar(int c) => isUppercaseChar(c) || isLowercaseChar(c);

/// Returns _true_ if [c] is an alphanumeric character.
bool isAlphanumericChar(int c) => isAlphabeticChar(c) || isDigitChar(c);

/// Returns _true_ if [c] is an regex \w character, i.e. alphanumeric or '_'.
bool isWordChar(int c) => isAlphanumericChar(c) || c == kUnderscore;

/// Returns _true_ if [c] is the ASCII space (' ') character.
bool isSpaceChar(int c) => c == kSpace;

/// Returns _true_ if [c] is a whitespace character.
bool isWhitespaceChar(int c) => (c == kSpace) || (c == kTab); //Horizontal Tab

/// Returns _true_ if [c] is a visible (printable)character.
/// These are the Ascii characters from 0x21 to 0x7E.
bool isVisibleChar(int c) => (c > kSpace) && (c < kDelete);

/// Synonym for [isVisibleChar].
bool isVChar(int c) => isVisibleChar(c);

/// Returns _true_ if [c] is an Ascii Escape character.
bool isEscapeChar(int c) => c == kEscape;

/// Returns _true_ if [c] is sign [c] (+, -).
bool isSignChar(int c) => c == kMinus || c == kPlus;

/// Returns _true_ if [c] is decimal point ".".
bool isDotChar(int c) => c == kDot;

/// Returns _true_ if [c] is exponent marker "E" or "e".
bool isExponentChar(int c) => c == kE || c == ke;

/// Returns _true_ if [c] is a legal DICOM UID (OID).
bool isOidChar(int c) => isDigitChar(c) || (c == kDot);

/// Returns _true_ if [c] is a legal Uuid [String].
bool isUuidChar(int c) => isDigitChar(c) || (c == kDash);

/// Returns _true_ if [s] is _null_ or empty [""].
bool isEmpty(String s) => (s == null) || (s == '');

/// If [c] is a lowercase character, returns the corresponding
/// Uppercase character; otherwise, returns [c] unmodified.
int toUppercaseChar(int c) => (isLowercaseChar(c)) ? c - 32 : c;

/// If [c] is an Uppercase character, returns the corresponding
/// Lowercase character; otherwise, returns [c] unmodified.
int toLowercaseChar(int c) => (isUppercaseChar(c)) ? c + 32 : c;

/// Returns the integer values of a DIGIT or _null_.
int digitToInt(int c) => (isDigitChar(c)) ? c - k0 : null;
