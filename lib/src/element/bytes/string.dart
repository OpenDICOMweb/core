//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.bytes;

/// [String] [Element]s that only have ASCII values.
abstract class StringMixin {
  int get vfLength;
  DicomBytes get vfBytes;
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

  List<String> get values => vfString.split('\\');

  List<String> get emptyList => kEmptyStringList;
}

/// [String] [Element]s that only have ASCII values.
abstract class AsciiMixin {
  bool get hasPadding;
  int get vfLength;
  DicomBytes get vfBytes;

  bool get allowInvalid => global.allowInvalidAscii;

  String get vfString {
    final length = (hasPadding) ? vfLength - 1 : vfLength;
    return vfBytes.getAscii(length: length, allowInvalid: allowInvalid);
  }
}

// **** Ascii Classes

class AEbytes extends AE with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  AEbytes(this.bytes);

  static AEbytes fromBytes(DicomBytes bytes) => new AEbytes(bytes);

  static AEbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kAECode, isEvr);
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

  static ASbytes fromBytes(DicomBytes bytes) {
    final eLength = bytes.length;
    if (eLength != 12 && eLength != 8)
      log.warn('Invalid Age (AS) "${bytes.getUtf8()}"');
    return new ASbytes(bytes);
  }

  static ASbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kASCode, isEvr);
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

  static CSbytes fromBytes(DicomBytes bytes) => new CSbytes(bytes);

  static CSbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kCSCode, isEvr);
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

  static DAbytes fromBytes(DicomBytes bytes) {
    final eLength = bytes.length;
    if (eLength != 16 && eLength != 8)
      log.debug('Invalid Date (DA) "${bytes.getUtf8()}"');
    return new DAbytes(bytes);
  }

  static DAbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kDACode, isEvr);
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

  static DSbytes fromBytes(DicomBytes bytes) => new DSbytes(bytes);

  static DSbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kDSCode, isEvr);
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

  static DTbytes fromBytes(DicomBytes bytes) => new DTbytes(bytes);

  static DTbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kDTCode, isEvr);
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

  static ISbytes fromBytes(DicomBytes bytes) => new ISbytes(bytes);

  static ISbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kISCode, isEvr);
    if (bytes == null) return null;
    bytes.writeAsciiVF(vList);
    assert(vList.length <= IS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

const _kNull = 0;

class UIbytes extends UI with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  UIbytes(this.bytes);

  @override
  List<Uid> get uids => Uid.parseList(
      bytes.getAsciiList(offset: vfOffset, length: vfLength, padChar: _kNull));

  static UIbytes fromBytes(DicomBytes bytes) => new UIbytes(bytes);

  static UIbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kUICode, isEvr);
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

  static TMbytes fromBytes(DicomBytes bytes) => new TMbytes(bytes);

  static TMbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kTMCode, isEvr);
    if (bytes == null) return null;
    bytes.writeAsciiVF(vList);
    assert(vList.length <= TM.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** Utf8 Classes

/// [String] [Element]s that may have UTF-8 values.
abstract class Utf8Mixin {
  bool get hasPadding;
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => _stringValuesLength(vfBytes);

  bool get allowMalformed => global.allowMalformedUtf8;

  String get vfString {
    final vf = (hasPadding) ? vfBytes.sublist(0, vfLength - 1) : vfBytes;
    return vf.getUtf8(allowMalformed: allowMalformed);
  }
}

class LObytes extends LO with ByteElement<String>, StringMixin, Utf8Mixin {
  @override
  final DicomBytes bytes;

  LObytes(this.bytes);

  static Element fromBytes(DicomBytes bytes) {
    final group = bytes.getUint16(0);
    final elt = bytes.getUint16(2);
    return (group.isOdd && elt >= 0x10 && elt <= 0xFF)
        ? new PCbytes(bytes)
        : new LObytes(bytes);
  }

  static LObytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kLOCode, isEvr);
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

  static PCbytes fromBytes(DicomBytes bytes) => new PCbytes(bytes);

  static PCbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kLOCode, isEvr);
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

  static PNbytes fromBytes(DicomBytes bytes) => new PNbytes(bytes);

  static PNbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kPNCode, isEvr);
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

  static SHbytes fromBytes(DicomBytes bytes) => new SHbytes(bytes);

  static SHbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kSHCode, isEvr);
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

  static UCbytes fromBytes(DicomBytes bytes) => new UCbytes(bytes);

  static UCbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeLongString(code, vList, kUCCode, isEvr);
    if (bytes == null) return null;
    bytes.writeUtf8VF(vList);
    assert(vList.length <= UC.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** Text Classes

/// Text ([String]) [Element]s that may only have 1 UTF-8 values.
abstract class TextMixin {
  DicomBytes get vfBytes;

  int get length => 1;

  bool allowMalformed = true;

  String get vfString => vfBytes.getUtf8(allowMalformed: allowMalformed);
  String get value => vfString;
  List<String> get values => [vfString];
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

  static LTbytes fromBytes(DicomBytes bytes) => new LTbytes(bytes);

  static LTbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kLTCode, isEvr);
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

  static STbytes fromBytes(DicomBytes bytes) => new STbytes(bytes);

  static STbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kSTCode, isEvr);
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

  static URbytes fromBytes(DicomBytes bytes) => new URbytes(bytes);

  static URbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeLongString(code, vList, kURCode, isEvr);
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

  static UTbytes fromBytes(DicomBytes bytes) => new UTbytes(bytes);

  static UTbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeLongString(code, vList, kUTCode, isEvr);
    if (bytes == null) return null;
    bytes.writeTextVF(vList);
    assert(vList.length <= UT.kMaxVFLength);
    return fromBytes(bytes);
  }
}
