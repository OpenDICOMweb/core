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

/// [String] [Element]s that only have ASCII values.
mixin StringMixin {
  int get vfLength;
  Bytes get vfBytes;
  int get vfBytesLast;
  String get vfString;

  /// Returns _true if [vfBytes] ends with a padding character.
  bool get hasPadding => vfLength.isEven && vfBytesLast == kSpace;

  /// Returns _true if the padding character, if any, is valid for _this_.
  bool get hasValidPadding => hasPadding && (padChar == kSpace);

  /// If [vfLength] is not empty and [vfLength] is not equal to zero,
  /// returns the last Uint8 element in [vfBytes]; otherwise, returns null;
  int get padChar => (vfLength != 0 && vfLength.isEven) ? vfBytesLast : null;

  /// Returns the number of values in [vfBytes].
  int get length => _stringValuesLength(vfBytes);

  StringList get values => StringList.from(vfString.split('\\'));

  List<String> get emptyList => kEmptyStringList;
}

/// [String] [Element]s that only have ASCII values.
mixin AsciiMixin {
  bool get hasPadding;
  int get vfLength;
  Bytes get vfBytes;

  bool get allowInvalid => global.allowInvalidAscii;

  String get vfString {
    final length = hasPadding ? vfLength - 1 : vfLength;
    return vfBytes.stringFromAscii(length: length, allowInvalid: allowInvalid);
  }
}

// **** Ascii Classes

class AEbytes extends AE with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  AEbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static AEbytes fromBytes(DicomBytes bytes, [Charset _]) => AEbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static AEbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kAECode);
    if (bytes == null) return null;
    bytes.writeAsciiVF(vList);
    assert(vList.length <= AE.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class ASbytes extends AS with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  ASbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static ASbytes fromBytes(DicomBytes bytes, [Charset _]) {
    final eLength = bytes.length;
    if (eLength != 12 && eLength != 8)
      log.warn('Invalid Age (AS) "${bytes.stringFromAscii()}"');
    return ASbytes(bytes);
  }

  // ignore: prefer_constructors_over_static_methods
  static ASbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kASCode);
    if (bytes == null) return null;
    bytes.writeAsciiVF(vList);
    assert(vList.length <= AS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class CSbytes extends CS with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  CSbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static CSbytes fromBytes(DicomBytes bytes, [Charset _]) => CSbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static CSbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kCSCode);
    if (bytes == null) return null;
    bytes.writeAsciiVF(vList);
    assert(vList.length <= CS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class DAbytes extends DA with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  DAbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static DAbytes fromBytes(DicomBytes bytes, [Charset _]) {
    final eLength = bytes.length;
    if (eLength != 16 && eLength != 8)
      log.debug('Invalid Date (DA) "${bytes.stringFromAscii()}"');
    return DAbytes(bytes);
  }

  // ignore: prefer_constructors_over_static_methods
  static DAbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kDACode);
    if (bytes == null) return null;
    bytes.writeAsciiVF(vList);
    assert(vList.length <= DA.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class DSbytes extends DS with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  DSbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static DSbytes fromBytes(DicomBytes bytes, [Charset _]) => DSbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static DSbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kDSCode);
    if (bytes == null) return null;
    bytes.writeAsciiVF(vList, kSpace);
    assert(bytes.length - bytes.vfOffset <= DS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class DTbytes extends DT with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  DTbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static DTbytes fromBytes(DicomBytes bytes, [Charset _]) => DTbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static DTbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kDTCode);
    if (bytes == null) return null;
    bytes.writeAsciiVF(vList);
    assert(vList.length <= DT.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class ISbytes extends IS with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  ISbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static ISbytes fromBytes(DicomBytes bytes, [Charset _]) => ISbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static ISbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kISCode);
    if (bytes == null) return null;
    bytes.writeAsciiVF(vList);
    assert(vList.length <= IS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class UIbytes extends UI with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  UIbytes(this.bytes);

  @override
  List<Uid> get uids => Uid.parseList(
      bytes.stringListFromAscii(offset: vfOffset, length: vfLength));

  // ignore: prefer_constructors_over_static_methods
  static UIbytes fromBytes(DicomBytes bytes, [Charset _]) => UIbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static UIbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kUICode);
    if (bytes == null) return null;
    bytes.writeAsciiVF(vList);
    assert(vList.length <= UI.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class TMbytes extends TM with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  TMbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static TMbytes fromBytes(DicomBytes bytes, [Charset _]) => TMbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static TMbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kTMCode);
    if (bytes == null) return null;
    bytes.writeAsciiVF(vList);
    assert(vList.length <= TM.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** Utf8 Classes

/// [String] [Element]s that may have UTF-8 values.
mixin Utf8Mixin {
  bool get hasPadding;
  int get vfLength;
  Bytes get vfBytes;

  int get length => _stringValuesLength(vfBytes);

  bool get allowMalformed => global.allowMalformedUtf8;

  String get vfString {
    final vf = hasPadding ? vfBytes.sublist(0, vfLength - 1) : vfBytes;
    return vf.stringFromUtf8(allowInvalid: allowMalformed);
  }
}

class LObytes extends LO with ByteElement<String>, StringMixin, Utf8Mixin {
  @override
  final DicomBytes bytes;

  LObytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static Element fromBytes(DicomBytes bytes, [Charset _]) {
    final group = bytes.getUint16(0);
    final elt = bytes.getUint16(2);
    return (group.isOdd && elt >= 0x10 && elt <= 0xFF)
        ? PCbytes(bytes)
        : LObytes(bytes);
  }

  // ignore: prefer_constructors_over_static_methods
  static LObytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kLOCode);
    if (bytes == null) return null;
    bytes.writeUtf8VF(vList);
    assert(vList.length <= LO.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class PCbytes extends PC with ByteElement<String>, StringMixin, Utf8Mixin {
  @override
  final DicomBytes bytes;

  PCbytes(this.bytes);

  @override
  String get token => vfString;

  // ignore: prefer_constructors_over_static_methods
  static PCbytes fromBytes(DicomBytes bytes, [Charset _]) => PCbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static PCbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kLOCode);
    if (bytes == null) return null;
    bytes.writeUtf8VF(vList);
    assert(vList.length <= LO.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class PNbytes extends PN with ByteElement<String>, StringMixin, Utf8Mixin {
  @override
  final DicomBytes bytes;

  PNbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static PNbytes fromBytes(DicomBytes bytes, [Charset _]) => PNbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static PNbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kPNCode);
    if (bytes == null) return null;
    bytes.writeUtf8VF(vList);
    assert(vList.length <= PN.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class SHbytes extends SH with ByteElement<String>, StringMixin, Utf8Mixin {
  @override
  final DicomBytes bytes;

  SHbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static SHbytes fromBytes(DicomBytes bytes, [Charset _]) => SHbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static SHbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kSHCode);
    if (bytes == null) return null;
    bytes.writeUtf8VF(vList);
    assert(vList.length <= SH.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class UCbytes extends UC with ByteElement<String>, StringMixin, Utf8Mixin {
  @override
  final DicomBytes bytes;

  UCbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static UCbytes fromBytes(DicomBytes bytes, [Charset _]) => UCbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static UCbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeLongString(code, vList, endian, isEvr, kUCCode);
    if (bytes == null) return null;
    bytes.writeUtf8VF(vList);
    assert(vList.length <= UC.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** Text Classes

/// Text ([String]) [Element]s that may only have 1 UTF-8 values.
mixin TextMixin {
  Bytes get vfBytes;

  int get length => 1;

  bool allowMalformed = true;

  String get vfString => vfBytes.stringFromUtf8(allowInvalid: allowMalformed);
  String get value => vfString;
  StringList get values => StringList.from([vfString]);
}

int _stringValuesLength(Bytes vfBytes) {
  if (vfBytes.isEmpty) return 0;
  var count = 1;
  for (var i = 0; i < vfBytes.length; i++)
    if (vfBytes[i] == kBackslash) count++;
  return count;
}

class LTbytes extends LT with ByteElement<String>, TextMixin {
  @override
  final DicomBytes bytes;

  LTbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static LTbytes fromBytes(DicomBytes bytes, [Charset _]) => LTbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static LTbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kLTCode);
    if (bytes == null) return null;
    bytes.writeTextVF(vList);
    assert(vList.length <= LT.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class STbytes extends ST with ByteElement<String>, TextMixin {
  @override
  final DicomBytes bytes;

  STbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static STbytes fromBytes(DicomBytes bytes, [Charset _]) => STbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static STbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, endian, isEvr, kSTCode);
    if (bytes == null) return null;
    bytes.writeTextVF(vList);
    assert(vList.length <= ST.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class URbytes extends UR with ByteElement<String>, TextMixin {
  @override
  final DicomBytes bytes;

  URbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static URbytes fromBytes(DicomBytes bytes, [Charset _]) => URbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  static URbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeLongString(code, vList, endian, isEvr, kURCode);
    if (bytes == null) return null;
    bytes.writeTextVF(vList);
    assert(vList.length <= UR.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class UTbytes extends UT with ByteElement<String>, TextMixin {
  @override
  final DicomBytes bytes;

  UTbytes(this.bytes);

  // ignore: prefer_constructors_over_static_methods
  static UTbytes fromBytes(DicomBytes bytes, [Charset _]) => UTbytes(bytes);

  // ignore: prefer_constructors_over_static_method
  static UTbytes fromValues(int code, List<String> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes = _makeLongString(code, vList, endian, isEvr, kUTCode);
    if (bytes == null) return null;
    bytes.writeTextVF(vList);
    assert(vList.length <= UT.kMaxVFLength);
    return fromBytes(bytes);
  }
}
