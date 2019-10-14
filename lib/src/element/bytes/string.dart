//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.bytes;

// ignore_for_file: public_member_api_docs
// ignore_for_file: prefer_constructors_over_static_methods

// Urgent: how does this mixin relate to others
/// [String] [Element]s that only have ASCII values.
mixin StringMixin {
  int get vfLength;
  Bytes get vfBytes;
  String get vfString;

  /// Returns _true if [vfBytes] ends with a padding character.
  bool get hasPadding => vfLength.isEven && vfBytesLast == kSpace;

  /// Returns _true if the padding character, if any, is valid for _this_.
  bool get hasValidPadding => hasPadding && (padChar == kSpace);

  /// If [vfLength] is not empty and [vfLength] is not equal to zero,
  /// returns the last Uint8 element in [vfBytes]; otherwise, returns null;
  int get padChar => (vfLength != 0 && vfLength.isEven) ? vfBytesLast : null;

  /// Returns the last Uint8 element in [vfBytes], if [vfBytes]
  /// is not empty; otherwise, returns _null_.
  int get vfBytesLast {
    final len = vfLength;
    return (len == 0) ? null : vfBytes[len - 1];
  }

  /// Returns the number of values in [vfBytes].
  int get length => _stringValuesLength(vfBytes);

  StringList get values => StringList.from(vfString.split('\\'));

  List<String> get emptyList => kEmptyStringList;

  static int _stringValuesLength(Bytes vfBytes) {
    if (vfBytes.isEmpty) return 0;
    var count = 1;
    for (var i = 0; i < vfBytes.length; i++)
      if (vfBytes[i] == kBackslash) count++;
    return count;
  }
}

/// [String] [Element]s that only have ASCII values.
mixin AsciiMixin {
  bool get hasPadding;
  int get vfLength;
  Bytes get vfBytes;

  String get vfString {
    final length = hasPadding ? vfLength - 1 : vfLength;
    return vfBytes.getAscii(0, length);
  }
}

// **** Ascii Classes

class AEbytes extends AE with ElementBytes<String>, StringMixin, AsciiMixin {
  @override
  final BytesElement be;

  AEbytes(this.be);

  static AEbytes fromBytes(Bytes bytes, [Ascii _]) => AEbytes(bytes);

  static AEbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortAscii(code, vList, kAECode, type, AE.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class ASbytes extends AS with ElementBytes<String>, StringMixin, AsciiMixin {
  @override
  final BytesElement be;

  ASbytes(this.be);

  static ASbytes fromBytes(Bytes bytes, [Ascii _]) {
    final eLength = bytes.length;
    if (eLength != 12 && eLength != 8)
      log.warn('Invalid Age (AS) "${bytes.getAscii()}"');
    return ASbytes(bytes);
  }

  static ASbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortAscii(code, vList, kASCode, type, AS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class CSbytes extends CS with ElementBytes<String>, StringMixin, AsciiMixin {
  @override
  final BytesElement be;

  CSbytes(this.be);

  static CSbytes fromBytes(Bytes bytes, [Ascii _]) => CSbytes(bytes);

  static CSbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortAscii(code, vList, kCSCode, type, CS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class DAbytes extends DA with ElementBytes<String>, StringMixin, AsciiMixin {
  @override
  final BytesElement be;

  DAbytes(this.be);

  static DAbytes fromBytes(Bytes bytes, [Ascii _]) {
    final eLength = bytes.length;
    if (eLength != 16 && eLength != 8)
      log.debug('Invalid Date (DA) "${bytes.getAscii()}"');
    return DAbytes(bytes);
  }

  static DAbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortAscii(code, vList, kDACode, type, DA.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class DSbytes extends DS with ElementBytes<String>, StringMixin, AsciiMixin {
  @override
  final BytesElement be;

  DSbytes(this.be);

  static DSbytes fromBytes(Bytes bytes, [Ascii _]) => DSbytes(bytes);

  static DSbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortAscii(code, vList, kDSCode, type, DS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class DTbytes extends DT with ElementBytes<String>, StringMixin, AsciiMixin {
  @override
  final BytesElement be;

  DTbytes(this.be);

  static DTbytes fromBytes(Bytes bytes, [Ascii _]) => DTbytes(bytes);

  static DTbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortAscii(code, vList, kDTCode, type, DT.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class ISbytes extends IS with ElementBytes<String>, StringMixin, AsciiMixin {
  @override
  final BytesElement be;

  ISbytes(this.be);

  static ISbytes fromBytes(Bytes bytes, [Ascii _]) => ISbytes(bytes);

  static ISbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortAscii(code, vList, kISCode, type, IS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class UIbytes extends UI with ElementBytes<String>, StringMixin, AsciiMixin {
  @override
  final BytesElement be;

  UIbytes(this.be);

  @override
  List<Uid> get uids => Uid.parseList(be.getAsciiList(vfOffset, vfLength));

  static UIbytes fromBytes(Bytes bytes, [Ascii _]) => UIbytes(bytes);

  static UIbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortAscii(code, vList, kUICode, type, UI.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class TMbytes extends TM with ElementBytes<String>, StringMixin, AsciiMixin {
  @override
  final BytesElement be;

  TMbytes(this.be);

  static TMbytes fromBytes(Bytes bytes, [Ascii _]) => TMbytes(bytes);

  static TMbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortAscii(code, vList, kTMCode, type, TM.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** Utf8 Classes

/// [String] [Element]s that may have UTF-8 values.
mixin Utf8Mixin {
  bool get hasPadding;
  int get vfLength;
  Bytes get vfBytes;

  // Urgent: remove padding
  String get vfString {
    final length = hasPadding ? vfLength - 1 : vfLength;
    return vfBytes.getUtf8(0, length);
  }
}

class LObytes extends LO with ElementBytes<String>, StringMixin, Utf8Mixin {
  @override
  final BytesElement be;

  LObytes(this.be);

  static Element fromBytes(Bytes bytes, [Ascii _]) {
    final group = bytes.getUint16(0);
    final elt = bytes.getUint16(2);
    return (group.isOdd && elt >= 0x10 && elt <= 0xFF)
        ? PCbytes(bytes)
        : LObytes(bytes);
  }

  static LObytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortUtf8(code, vList, kLOCode, type, LO.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class PCbytes extends PC with ElementBytes<String>, StringMixin, Utf8Mixin {
  @override
  final BytesElement be;

  PCbytes(this.be);

  @override
  String get token => vfString;

  static PCbytes fromBytes(Bytes bytes, [Ascii _]) => PCbytes(bytes);

  static PCbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortUtf8(code, vList, kLOCode, type, LO.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class PNbytes extends PN with ElementBytes<String>, StringMixin, Utf8Mixin {
  @override
  final BytesElement be;

  PNbytes(this.be);

  static PNbytes fromBytes(Bytes bytes, [Ascii _]) => PNbytes(bytes);

  static PNbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortUtf8(code, vList, kPNCode, type, PN.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class SHbytes extends SH with ElementBytes<String>, StringMixin, Utf8Mixin {
  @override
  final BytesElement be;

  SHbytes(this.be);

  static SHbytes fromBytes(Bytes bytes, [Ascii _]) => SHbytes(bytes);

  static SHbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortUtf8(code, vList, kSHCode, type, SH.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class UCbytes extends UC with ElementBytes<String>, StringMixin, Utf8Mixin {
  @override
  final BytesElement be;

  UCbytes(this.be);

  static UCbytes fromBytes(Bytes bytes, [Ascii _]) => UCbytes(bytes);

  static UCbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeLongUtf8(code, vList, kUCCode, type, UC.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** Text Classes

/// Text ([String]) [Element]s that may only have 1 UTF-8 values.
mixin TextMixin {
  bool get hasPadding;
  int get vfLength;
  Bytes get vfBytes;

  String get vfString {
    final length = hasPadding ? vfLength - 1 : vfLength;
    return vfBytes.getUtf8(0, length);
  }

  String get value => vfString;
  StringList get values => StringList.from([vfString]);
}

class LTbytes extends LT with ElementBytes<String>, StringMixin, TextMixin {
  @override
  final BytesElement be;

  LTbytes(this.be);

  static LTbytes fromBytes(Bytes bytes, [Ascii _]) => LTbytes(bytes);

  static LTbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortText(code, vList, kLTCode, type, LT.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class STbytes extends ST with ElementBytes<String>, StringMixin, TextMixin {
  @override
  final BytesElement be;

  STbytes(this.be);

  static STbytes fromBytes(Bytes bytes, [Ascii _]) => STbytes(bytes);

  static STbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeShortText(code, vList, kUSCode, type, ST.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class URbytes extends UR with ElementBytes<String>, StringMixin, TextMixin {
  @override
  final BytesElement be;

  URbytes(this.be);

  static URbytes fromBytes(Bytes bytes, [Ascii _]) => URbytes(bytes);

  static URbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeLongText(code, vList, kURCode, type, UR.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class UTbytes extends UT with ElementBytes<String>, StringMixin, TextMixin {
  @override
  final BytesElement be;

  UTbytes(this.be);

  static UTbytes fromBytes(Bytes bytes, [Ascii _]) => UTbytes(bytes);

  static UTbytes fromValues(
      int code, List<String> vList, BytesElementType type) {
    final bytes = _makeLongText(code, vList, kUTCode, type, UT.kMaxVFLength);
    return fromBytes(bytes);
  }
}

BytesElement _makeShortAscii(int code, List<String> vList, int vrCode,
    BytesElementType type, int maxLength) {
  final vfBytes = AsciiString.toBytes(vList);
  return _makeShortElt(code, vfBytes, vrCode, type, maxLength);
}

/* Flush when working
BytesElement _makeLongAscii(int code, List<String> vList, int vrCode,
    BytesElementType type, int maxLength) {
  final vfBytes = AsciiString.toBytes(vList);
  return _makeShortElement(code, vfBytes, vrCode, type, maxLength);
}
*/

BytesElement _makeShortUtf8(int code, List<String> vList, int vrCode,
    BytesElementType type, int maxLength) {
  final vfBytes = Utf8String.toBytes(vList);
  return _makeShortElt(code, vfBytes, vrCode, type, maxLength);
}

BytesElement _makeLongUtf8(int code, List<String> vList, int vrCode,
    BytesElementType type, int maxLength) {
  final vfBytes = Utf8String.toBytes(vList);
  return _makeLongElt(code, vfBytes, vrCode, type, maxLength);
}

BytesElement _makeShortText(int code, List<String> vList, int vrCode,
    BytesElementType type, int maxLength) {
  assert(vList.length <= 1);
  final value = vList.isEmpty ? '' : vList[0];
  final vfBytes = Text.toBytes(value);
  return _makeShortElt(code, vfBytes, vrCode, type, maxLength);
}

BytesElement _makeLongText(int code, List<String> vList, int vrCode,
    BytesElementType type, int maxLength) {
  assert(vList.length <= 1);
  final value = vList.isEmpty ? '' : vList[0];
  final vfBytes = Text.toBytes(value);
  return _makeShortElt(code, vfBytes, vrCode, type, maxLength);
}
