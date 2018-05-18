//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset.dart';

import 'package:core/src/element/base.dart';
import 'package:core/src/element/bytes/bytes_mixin.dart';
import 'package:core/src/error.dart';
import 'package:core/src/system.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/value.dart';
import 'package:core/src/vr.dart';

// **** IVR Float Elements (FL, FD, OD, OF)

DicomBytes _makeShort<V>(
    int code, Iterable<V> vList, int vrCode, bool isEvr, int eSize) {
  final vfLength = vList.length * eSize;
  return (isEvr)
      ? EvrShortBytes.makeEmpty(code, vfLength, vrCode)
      : IvrBytes.makeEmpty(code, vfLength, vrCode);
}

DicomBytes _makeShortString(
    int code, List<String> sList, int vrCode, bool isEvr) {
  final vlf = stringListLength(sList, pad: true);
  print('vList: $sList');
  print('vlf: $vlf');
  return (isEvr)
      ? EvrShortBytes.makeEmpty(code, vlf, vrCode)
      : IvrBytes.makeEmpty(code, vlf, vrCode);
}

DicomBytes _makeLong(int code, List vList, int vrCode, bool isEvr, int eSize) {
  final vfLength = vList.length * eSize;
  return (isEvr)
      ? EvrLongBytes.makeEmpty(code, vfLength, vrCode)
      : IvrBytes.makeEmpty(code, vfLength, vrCode);
}

DicomBytes _makeLongString(
    int code, List<String> sList, int vrCode, bool isEvr) {
  final vlf = stringListLength(sList, pad: true);
  print('vList: $sList');
  print('vlf: $vlf');
  return (isEvr)
      ? EvrLongBytes.makeEmpty(code, vlf, vrCode)
      : IvrBytes.makeEmpty(code, vlf, vrCode);
}

class FLbytes extends FL with ByteElement<double>, Float32Mixin {
  @override
  final DicomBytes bytes;

  FLbytes(this.bytes) : assert(bytes != null);

  static FLbytes fromBytes(DicomBytes bytes) => new FLbytes(bytes);

  static FLbytes fromValues(int code, Iterable<double> vList,
      {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kFLCode, isEvr, FL.kSizeInBytes)
      ..writeFloat32VF(vList);
    assert(vList.length * FL.kSizeInBytes <= FL.kMaxVFLength);
    return FLbytes.fromBytes(bytes);
  }
}

class OFbytes extends OF with ByteElement<double>, Float32Mixin {
  @override
  final DicomBytes bytes;

  OFbytes(this.bytes);

  static OFbytes fromBytes(DicomBytes bytes) => new OFbytes(bytes);

  static OFbytes fromValues(int code, List<double> vList, {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kOFCode, isEvr, OF.kSizeInBytes)
      ..writeFloat32VF(vList);
    assert(vList.length * OF.kSizeInBytes <= OF.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** IVR 64-Bit Float Elements (OD, OF)

class FDbytes extends FD with ByteElement<double>, Float64Mixin {
  @override
  final DicomBytes bytes;

  FDbytes(this.bytes);

  static FDbytes fromBytes(DicomBytes bytes) => new FDbytes(bytes);

  static FDbytes fromValues(int code, List<double> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kFDCode, isEvr, FD.kSizeInBytes)
      ..writeFloat64VF(vList);
    assert(vList.length * FD.kSizeInBytes <= FD.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class ODbytes extends OD with ByteElement<double>, Float64Mixin {
  @override
  final DicomBytes bytes;

  ODbytes(this.bytes);

  static ODbytes fromBytes(DicomBytes bytes) => new ODbytes(bytes);

  static ODbytes fromValues(int code, List<double> vList, {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kODCode, isEvr, OD.kSizeInBytes)
      ..writeFloat64VF(vList);
    assert(vList.length * OD.kSizeInBytes <= OD.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** Integer Elements
// **** 8-bit Integer Elements (OB, UN)

class OBbytes extends OB with ByteElement<int>, Uint8Mixin {
  @override
  final DicomBytes bytes;

  OBbytes(this.bytes);

  static OBbytes fromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      (bytes.code == kPixelData)
          ? OBbytesPixelData(bytes, ts, fragments)
          : new OBbytes(bytes);

  static OBbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kOBCode, isEvr, OB.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * OB.kSizeInBytes <= OB.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class OBbytesPixelData extends OBPixelData with ByteElement<int>, Uint8Mixin {
  @override
  final DicomBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBbytesPixelData(this.bytes, [this.ts, this.fragments]);

  static OBbytesPixelData fromBytes(int code, DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OBbytesPixelData(bytes, ts, fragments);
}

class UNbytes extends UN with ByteElement<int>, Uint8Mixin {
  @override
  final DicomBytes bytes;

  UNbytes(this.bytes);

  static UNbytes fromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      (bytes.code == kPixelData)
          ? UNbytesPixelData(bytes, ts, fragments)
          : new UNbytes(bytes);

  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kUNCode, isEvr, UN.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * UN.kSizeInBytes <= UN.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class UNbytesPixelData extends UNPixelData with ByteElement<int>, Uint8Mixin {
  @override
  final DicomBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNbytesPixelData(this.bytes, [this.ts, this.fragments]);

  static UNbytesPixelData fromBytes(int code, DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new UNbytesPixelData(bytes, ts, fragments);
}

// **** 16-bit Integer Elements (SS, US, OW)

class SSbytes extends SS with ByteElement<int>, Int16Mixin {
  @override
  final DicomBytes bytes;

  SSbytes(this.bytes);

  static SSbytes fromBytes(DicomBytes bytes) => new SSbytes(bytes);

  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kSSCode, isEvr, SS.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * SS.kSizeInBytes <= SS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class USbytes extends US with ByteElement<int>, Uint16Mixin {
  @override
  final DicomBytes bytes;

  USbytes(this.bytes);

  static USbytes fromBytes(DicomBytes bytes) => new USbytes(bytes);

  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kUSCode, isEvr, US.kSizeInBytes)
      ..writeUint16VF(vList);
    assert(vList.length * US.kSizeInBytes <= US.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class OWbytes extends OW with ByteElement<int>, Uint16Mixin {
  @override
  final DicomBytes bytes;

  OWbytes(this.bytes);

  static OWbytes fromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      (bytes.code == kPixelData)
          ? OWbytesPixelData(bytes, ts, fragments)
          : new UNbytes(bytes);

  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kOWCode, isEvr, OW.kSizeInBytes)
      ..writeUint16VF(vList);
    assert(vList.length * OW.kSizeInBytes <= OW.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class OWbytesPixelData extends OWPixelData with ByteElement<int>, Uint16Mixin {
  @override
  final DicomBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OWbytesPixelData(this.bytes, [this.ts, this.fragments]);

  static OWbytesPixelData fromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OWbytesPixelData(bytes, ts, fragments);
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

/// Attribute (Element) Code (AT)
class ATbytes extends AT with ByteElement<int>, Uint32Mixin {
  @override
  final DicomBytes bytes;

  ATbytes(this.bytes);

  static ATbytes fromBytes(DicomBytes bytes) => new ATbytes(bytes);

  static ATbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kATCode, isEvr, AT.kSizeInBytes)
      ..writeUint32VF(vList);
    assert(vList.length * AT.kSizeInBytes <= AT.kMaxVFLength);
    return fromBytes(bytes);
  }
}

/// Other Long (OL)
class OLbytes extends OL with ByteElement<int>, Uint32Mixin {
  @override
  final DicomBytes bytes;

  OLbytes(this.bytes);

  static OLbytes fromBytes(DicomBytes bytes) => new OLbytes(bytes);

  static OLbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kOLCode, isEvr, OL.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * OL.kSizeInBytes <= OL.kMaxVFLength);
    return fromBytes(bytes);
  }
}

/// Signed Long (SL)
class SLbytes extends SL with ByteElement<int>, Int32Mixin {
  @override
  final DicomBytes bytes;

  SLbytes(this.bytes);

  static SLbytes fromBytes(DicomBytes bytes) => new SLbytes(bytes);

  static SLbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kSLCode, isEvr, SL.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * SL.kSizeInBytes <= SL.kMaxVFLength);
    return fromBytes(bytes);
  }
}

/// Unsigned Long (UL)
class ULbytes extends UL with ByteElement<int>, Uint32Mixin {
  @override
  final DicomBytes bytes;

  ULbytes(this.bytes);

  static ULbytes fromBytes(DicomBytes bytes) =>
      // If the code is (gggg,0000) create a Group Length element
      (bytes.getUint16(2) == 0) ? new GLbytes(bytes) : new ULbytes(bytes);

  static ULbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kULCode, isEvr, UL.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * UL.kSizeInBytes <= UL.kMaxVFLength);
    return fromBytes(bytes);
  }
}

/// Group Length (GL)
class GLbytes extends ULbytes {
  GLbytes(DicomBytes bytes) : super(bytes);

  static const String kVRKeyword = 'GL';
  static const String kVRName = 'Group Length';

  static GLbytes fromBytes(DicomBytes bytes) => new GLbytes(bytes);

  static GLbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kSSCode, isEvr, SS.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * SS.kSizeInBytes <= SS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** Ascii Classes

class AEbytes extends AE with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  AEbytes(this.bytes);

  static AEbytes fromBytes(DicomBytes bytes) => new AEbytes(bytes);

  static AEbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kAECode, isEvr)
      ..writeAsciiVF(vList);
    print('bytes: $bytes');
    assert(vList.length <= AE.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class ASbytes extends AS with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  ASbytes(this.bytes);

  static ASbytes fromBytes(DicomBytes bytes) {
    final length = bytes.length;
    if (length != 12 && length != 8)
      log.warn('Invalid Age (AS) "${bytes.getUtf8()}"');
    return new ASbytes(bytes);
  }

  static ASbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kASCode, isEvr)
      ..writeAsciiVF(vList);
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
    final bytes = _makeShortString(code, vList, kCSCode, isEvr)
      ..writeAsciiVF(vList);
    assert(vList.length <= CS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class DAbytes extends DA with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  DAbytes(this.bytes);

  static DAbytes fromBytes(DicomBytes bytes) {
    final length = bytes.length;
    if (length != 16 && length != 8)
      log.debug('Invalid Date (DA) "${bytes.getUtf8()}"');
    return new DAbytes(bytes);
  }

  static DAbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kDACode, isEvr)
      ..writeAsciiVF(vList);
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
    final bytes = _makeShortString(code, vList, kDSCode, isEvr)
      ..writeAsciiVF(vList, kSpace);
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
    final bytes = _makeShortString(code, vList, kDTCode, isEvr)
      ..writeAsciiVF(vList);
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
    final bytes = _makeShortString(code, vList, kISCode, isEvr)
      ..writeAsciiVF(vList);
    assert(vList.length <= IS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class UIbytes extends UI with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  UIbytes(this.bytes);

  @override
  Iterable<Uid> get uids => Uid.parseList(bytes.getAsciiList());

  static UIbytes fromBytes(DicomBytes bytes) => new UIbytes(bytes);

  static UIbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kUICode, isEvr)
      ..writeAsciiVF(vList);
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
    final bytes = _makeShortString(code, vList, kTMCode, isEvr)
      ..writeAsciiVF(vList);
    assert(vList.length <= TM.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** Utf8 Classes

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
    final bytes = _makeShortString(code, vList, kLOCode, isEvr)
      ..writeUtf8VF(vList);
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
    final bytes = _makeShortString(code, vList, kLOCode, isEvr)
      ..writeUtf8VF(vList);
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
    final bytes = _makeShortString(code, vList, kPNCode, isEvr)
      ..writeUtf8VF(vList);
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
    final bytes = _makeShortString(code, vList, kSHCode, isEvr)
      ..writeUtf8VF(vList);
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
    final bytes = _makeLongString(code, vList, kUCCode, isEvr)
      ..writeUtf8VF(vList);
    assert(vList.length <= UC.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** Text Classes

class LTbytes extends LT with ByteElement<String>, TextMixin {
  @override
  final DicomBytes bytes;

  LTbytes(this.bytes);

  static LTbytes fromBytes(DicomBytes bytes) => new LTbytes(bytes);

  static LTbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kLTCode, isEvr)
      ..writeTextVF(vList);
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
    final bytes = _makeShortString(code, vList, kSTCode, isEvr)
      ..writeTextVF(vList);
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
    final bytes = _makeLongString(code, vList, kURCode, isEvr)
      ..writeTextVF(vList);
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
    final bytes = _makeLongString(code, vList, kUTCode, isEvr)
      ..writeTextVF(vList);
    assert(vList.length <= UT.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** Sequence Class

class SQbytes extends SQ with ByteElement<Item> {
  @override
  final Dataset parent;
  @override
  Iterable<Item> values;
  @override
  final DicomBytes bytes;

  SQbytes(this.parent, this.values, this.bytes);

  @override
  int get valuesLength => values.length;

  /// Returns a new [SQbytes], where [bytes] is [DicomBytes]
  /// for complete sequence.
  static SQbytes fromBytes(Dataset parent,
          [SQ sequence, Iterable<Item> values, DicomBytes bytes]) =>
      new SQbytes(parent, values, bytes);

  static SQbytes fromValues(int code, List<String> vList,
          {bool isEvr = true}) =>
      unsupportedError();
}

/*
abstract class PrivateData<V> extends Element<V> with ByteElement<V> {
  final Element e;

  PrivateData(this.e);

  @override
  Object operator[](int index) => e[index];

  @override
  DicomBytes get bytes => e.bytes;
  @override
  bool get isEvr => e.isEvr;
  @override
  int get index => e.index;
  @override
  int get code => e.code;
  @override
  Tag get tag => Tag.lookupByCode(code);
  @override
  int get vfLengthOffset => e.vfLengthOffset;
  @override
  int get vfOffset => e.vfOffset;
  @override
  DicomBytes get vfBytes => e.vfBytes;
  @override
  int get vfBytesLast => e.vfBytesLast;
  @override
  DicomBytes get vBytes => e.vBytes;
  @override
  int get valuesLength => e.length;
  @override
  Iterable<V> get values => e.values;
  @override
  List<V> get emptyList => e.emptyList;

  @override
  bool get hasValidValues => e.hasValidValues;
  /// Returns _true_ if [value] is valid for _this_.
  bool checkValue(V v, {Issues issues, bool allowInvalid = false}) =>
  e.checkValue(v, issues: issues, allowInvalid: allowInvalid);


  static PrivateData fromBytes<V>(Dataset ds, Bytes bytes) {
    assert(bytes.length.isEven);
    final e = ByteElement.makeFromCode(ds, bytes);
    return new PrivateData(e);
  }
}
*/
