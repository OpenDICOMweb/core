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

DicomBytes _makeShort(int code, List vList, int vrCode, bool isEvr, int eSize) {
  final vfLength = vList.length * eSize;
  return (isEvr)
      ? EvrShortBytes.makeEmpty(code, vfLength, vrCode)
      : IvrBytes.makeEmpty(code, vfLength, vrCode);
}

DicomBytes _makeShortString(
    int code, List<String> vList, int vrCode, bool isEvr) {
  final vlf = stringListLength(vList, pad: true);
  print('vList: $vList');
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

class FLbytes extends FL with ByteElement<double>, Float32Mixin {
  @override
  final DicomBytes bytes;

  FLbytes(this.bytes) : assert(bytes != null);

  static FLbytes makeFromBytes(DicomBytes bytes) => new FLbytes(bytes);

  static FLbytes fromValues(int code, List<double> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kFLCode, isEvr, FL.kSizeInBytes)
      ..writeFloat32VF(vList);
    assert(vList.length * FL.kSizeInBytes <= FL.kMaxVFLength);
    return FLbytes.makeFromBytes(bytes);
  }
}

class OFbytes extends OF with ByteElement<double>, Float32Mixin {
  @override
  final DicomBytes bytes;

  OFbytes(this.bytes);

  static OFbytes makeFromBytes(DicomBytes bytes) => new OFbytes(bytes);

  static OFbytes fromValues(int code, List<double> vList, {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kOFCode, isEvr, OF.kSizeInBytes)
      ..writeFloat32VF(vList);
    assert(vList.length * OF.kSizeInBytes <= OF.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

// **** IVR 64-Bit Float Elements (OD, OF)

class FDbytes extends FD with ByteElement<double>, Float64Mixin {
  @override
  final DicomBytes bytes;

  FDbytes(this.bytes);

  static FDbytes makeFromBytes(DicomBytes bytes) => new FDbytes(bytes);

  static FDbytes fromValues(int code, List<double> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kFDCode, isEvr, FD.kSizeInBytes)
      ..writeFloat64VF(vList);
    assert(vList.length * FD.kSizeInBytes <= FD.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class ODbytes extends OD with ByteElement<double>, Float64Mixin {
  @override
  final DicomBytes bytes;

  ODbytes(this.bytes);

  static ODbytes makeFromBytes(DicomBytes bytes) => new ODbytes(bytes);

  static ODbytes fromValues(int code, List<double> vList, {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kODCode, isEvr, OD.kSizeInBytes)
      ..writeFloat64VF(vList);
    assert(vList.length * OD.kSizeInBytes <= OD.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

// **** Integer Elements
// **** 8-bit Integer Elements (OB, UN)

class OBbytes extends OB with ByteElement<int>, Uint8Mixin {
  @override
  final DicomBytes bytes;

  OBbytes(this.bytes);

  static OBbytes makeFromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      (bytes.code == kPixelData)
          ? OBbytesPixelData(bytes, ts, fragments)
          : new OBbytes(bytes);

  static OBbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kOBCode, isEvr, OB.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * OB.kSizeInBytes <= OB.kMaxVFLength);
    return makeFromBytes(bytes);
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

  static OBbytesPixelData makeFromBytes(int code, DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OBbytesPixelData(bytes, ts, fragments);
}

class UNbytes extends UN with ByteElement<int>, Uint8Mixin {
  @override
  final DicomBytes bytes;

  UNbytes(this.bytes);

  static UNbytes makeFromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      (bytes.code == kPixelData)
          ? UNbytesPixelData(bytes, ts, fragments)
          : new UNbytes(bytes);

  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kUNCode, isEvr, UN.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * UN.kSizeInBytes <= UN.kMaxVFLength);
    return makeFromBytes(bytes);
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

  static UNbytesPixelData makeFromBytes(int code, DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new UNbytesPixelData(bytes, ts, fragments);
}

// **** 16-bit Integer Elements (SS, US, OW)

class SSbytes extends SS with ByteElement<int>, Int16Mixin {
  @override
  final DicomBytes bytes;

  SSbytes(this.bytes);

  static SSbytes makeFromBytes(DicomBytes bytes) => new SSbytes(bytes);

  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kSSCode, isEvr, SS.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * SS.kSizeInBytes <= SS.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class USbytes extends US with ByteElement<int>, Uint16Mixin {
  @override
  final DicomBytes bytes;

  USbytes(this.bytes);

  static USbytes makeFromBytes(DicomBytes bytes) => new USbytes(bytes);

  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kUSCode, isEvr, US.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * US.kSizeInBytes <= US.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class OWbytes extends OW with ByteElement<int>, Uint16Mixin {
  @override
  final DicomBytes bytes;

  OWbytes(this.bytes);

  static OWbytes makeFromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      (bytes.code == kPixelData)
          ? OWbytesPixelData(bytes, ts, fragments)
          : new UNbytes(bytes);

  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kOWCode, isEvr, OW.kSizeInBytes)
      ..writeUint16VF(vList);
    assert(vList.length * OW.kSizeInBytes <= OW.kMaxVFLength);
    return makeFromBytes(bytes);
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

  static OWbytesPixelData makeFromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OWbytesPixelData(bytes, ts, fragments);
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

/// Attribute (Element) Code (AT)
class ATbytes extends AT with ByteElement<int>, Uint32Mixin {
  @override
  final DicomBytes bytes;

  ATbytes(this.bytes);

  static ATbytes makeFromBytes(DicomBytes bytes) => new ATbytes(bytes);

  static ATbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kATCode, isEvr, AT.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * AT.kSizeInBytes <= AT.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

/// Other Long (OL)
class OLbytes extends OL with ByteElement<int>, Uint32Mixin {
  @override
  final DicomBytes bytes;

  OLbytes(this.bytes);

  static OLbytes makeFromBytes(DicomBytes bytes) => new OLbytes(bytes);

  static OLbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kOLCode, isEvr, OL.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * OL.kSizeInBytes <= OL.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

/// Signed Long (SL)
class SLbytes extends SL with ByteElement<int>, Int32Mixin {
  @override
  final DicomBytes bytes;

  SLbytes(this.bytes);

  static SLbytes makeFromBytes(DicomBytes bytes) => new SLbytes(bytes);

  static SLbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kSLCode, isEvr, SL.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * SL.kSizeInBytes <= SL.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

/// Unsigned Long (UL)
class ULbytes extends UL with ByteElement<int>, Uint32Mixin {
  @override
  final DicomBytes bytes;

  ULbytes(this.bytes);

  static ULbytes makeFromBytes(DicomBytes bytes) =>
      // If the code is (gggg,0000) create a Group Length element
      (bytes.getUint16(2) == 0) ? new GLbytes(bytes) : new ULbytes(bytes);

  static ULbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kULCode, isEvr, UL.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * UL.kSizeInBytes <= UL.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

/// Group Length (GL)
class GLbytes extends ULbytes {
  GLbytes(DicomBytes bytes) : super(bytes);

  static const String kVRKeyword = 'GL';
  static const String kVRName = 'Group Length';

  static GLbytes makeFromBytes(DicomBytes bytes) => new GLbytes(bytes);

  static GLbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kSSCode, isEvr, SS.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * SS.kSizeInBytes <= SS.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

// **** Ascii Classes

class AEbytes extends AE with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  AEbytes(this.bytes);

  static AEbytes makeFromBytes(DicomBytes bytes) => new AEbytes(bytes);

  static AEbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kAECode, isEvr, 1)
      ..writeAsciiVF(vList);
    assert(vList.length <= AE.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class ASbytes extends AS with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  ASbytes(this.bytes);

  static ASbytes makeFromBytes(DicomBytes bytes) {
    final length = bytes.length;
    if (length != 12 && length != 8)
      log.warn('Invalid Age (AS) "${bytes.getUtf8()}"');
    return new ASbytes(bytes);
  }

  static ASbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kASCode, isEvr, 1)
      ..writeAsciiVF(vList);
    assert(vList.length <= AS.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class CSbytes extends CS with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  CSbytes(this.bytes);

  static CSbytes makeFromBytes(DicomBytes bytes) => new CSbytes(bytes);

  static CSbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kCSCode, isEvr, 1)
      ..writeAsciiVF(vList);
    assert(vList.length <= CS.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class DAbytes extends DA with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  DAbytes(this.bytes);

  static DAbytes makeFromBytes(DicomBytes bytes) {
    final length = bytes.length;
    if (length != 16 && length != 8)
      log.debug('Invalid Date (DA) "${bytes.getUtf8()}"');
    return new DAbytes(bytes);
  }

  static DAbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kDACode, isEvr, 1)
      ..writeAsciiVF(vList);
    assert(vList.length <= DA.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class DSbytes extends DS with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  DSbytes(this.bytes);

  static DSbytes makeFromBytes(DicomBytes bytes) => new DSbytes(bytes);

  static DSbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShortString(code, vList, kDSCode, isEvr)
      ..writeAsciiVF(vList, kSpace);
//    assert(bytes.length - vfOffset <= DS.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class DTbytes extends DT with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  DTbytes(this.bytes);

  static DTbytes makeFromBytes(DicomBytes bytes) => new DTbytes(bytes);

  static DTbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kDTCode, isEvr, 1)
      ..writeAsciiVF(vList);
    assert(vList.length <= DT.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class ISbytes extends IS with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  ISbytes(this.bytes);

  static ISbytes makeFromBytes(DicomBytes bytes) => new ISbytes(bytes);

  static ISbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kISCode, isEvr, 1)
      ..writeAsciiVF(vList);
    assert(vList.length <= IS.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class UIbytes extends UI with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  UIbytes(this.bytes);

  @override
  Iterable<Uid> get uids => Uid.parseList(bytes.getAsciiList());

  static UIbytes makeFromBytes(DicomBytes bytes) => new UIbytes(bytes);

  static UIbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kUICode, isEvr, 1)
      ..writeAsciiVF(vList);
    assert(vList.length <= UI.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class TMbytes extends TM with ByteElement<String>, StringMixin, AsciiMixin {
  @override
  final DicomBytes bytes;

  TMbytes(this.bytes);

  static TMbytes makeFromBytes(DicomBytes bytes) => new TMbytes(bytes);

  static TMbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kTMCode, isEvr, 1)
      ..writeAsciiVF(vList);
    assert(vList.length <= TM.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

// **** Utf8 Classes

class LObytes extends LO with ByteElement<String>, StringMixin, Utf8Mixin {
  @override
  final DicomBytes bytes;

  LObytes(this.bytes);

  static Element makeFromBytes(DicomBytes bytes) {
    final group = bytes.getUint16(0);
    final elt = bytes.getUint16(2);
    return (group.isOdd && elt >= 0x10 && elt <= 0xFF)
        ? new PCbytes(bytes)
        : new LObytes(bytes);
  }

  static LObytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kLOCode, isEvr, 1)
      ..writeUtf8VF(vList);
    assert(vList.length <= LO.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class PCbytes extends PC with ByteElement<String>, StringMixin, Utf8Mixin {
  @override
  final DicomBytes bytes;

  PCbytes(this.bytes);

  @override
  String get token => vfString;

  static PCbytes makeFromBytes(DicomBytes bytes) => new PCbytes(bytes);

  static PCbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kLOCode, isEvr, 1)
      ..writeUtf8VF(vList);
    assert(vList.length <= LO.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class PNbytes extends PN with ByteElement<String>, StringMixin, Utf8Mixin {
  @override
  final DicomBytes bytes;

  PNbytes(this.bytes);

  static PNbytes makeFromBytes(DicomBytes bytes) => new PNbytes(bytes);

  static PNbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kPNCode, isEvr, 1)
      ..writeUtf8VF(vList);
    assert(vList.length <= PN.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class SHbytes extends SH with ByteElement<String>, StringMixin, Utf8Mixin {
  @override
  final DicomBytes bytes;

  SHbytes(this.bytes);

  static SHbytes makeFromBytes(DicomBytes bytes) => new SHbytes(bytes);

  static SHbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kSHCode, isEvr, 1)
      ..writeUtf8VF(vList);
    assert(vList.length <= SH.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class UCbytes extends UC with ByteElement<String>, StringMixin, Utf8Mixin {
  @override
  final DicomBytes bytes;

  UCbytes(this.bytes);

  static UCbytes makeFromBytes(DicomBytes bytes) => new UCbytes(bytes);

  static UCbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kUCCode, isEvr, 1)..writeUtf8VF(vList);
    assert(vList.length <= UC.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

// **** Text Classes

class LTbytes extends LT with ByteElement<String>, TextMixin {
  @override
  final DicomBytes bytes;

  LTbytes(this.bytes);

  static LTbytes makeFromBytes(DicomBytes bytes) => new LTbytes(bytes);

  static LTbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kLTCode, isEvr, 1)
      ..writeTextVF(vList);
    assert(vList.length <= LT.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class STbytes extends ST with ByteElement<String>, TextMixin {
  @override
  final DicomBytes bytes;

  STbytes(this.bytes);

  static STbytes makeFromBytes(DicomBytes bytes) => new STbytes(bytes);

  static STbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kSTCode, isEvr, 1)
      ..writeTextVF(vList);
    assert(vList.length <= ST.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class URbytes extends UR with ByteElement<String>, TextMixin {
  @override
  final DicomBytes bytes;

  URbytes(this.bytes);

  static URbytes makeFromBytes(DicomBytes bytes) => new URbytes(bytes);

  static URbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kURCode, isEvr, 1)..writeTextVF(vList);
    assert(vList.length <= UR.kMaxVFLength);
    return makeFromBytes(bytes);
  }
}

class UTbytes extends UT with ByteElement<String>, TextMixin {
  @override
  final DicomBytes bytes;

  UTbytes(this.bytes);

  static UTbytes makeFromBytes(DicomBytes bytes) => new UTbytes(bytes);

  static UTbytes fromValues(int code, List<String> vList, {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kUTCode, isEvr, 1)..writeTextVF(vList);
    assert(vList.length <= UT.kMaxVFLength);
    return makeFromBytes(bytes);
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
  static SQbytes makeFromBytes(Dataset parent,
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


  static PrivateData makeFromBytes<V>(Dataset ds, Bytes bytes) {
    assert(bytes.length.isEven);
    final e = ByteElement.makeFromCode(ds, bytes);
    return new PrivateData(e);
  }
}
*/
