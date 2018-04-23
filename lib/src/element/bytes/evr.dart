//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/base.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/bytes.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

const int _vrOffset = 4;

abstract class EvrElement<V> implements ByteElement<V> {
  @override
  Bytes get bytes;
  @override
  int get vfLength;
  int get valuesLength;
  @override
  Iterable<V> get values;
  @override
  set values(Iterable<V> vList) => unsupportedError();
  bool isEqual(ByteElement a, ByteElement b);

  // **** End of Interface

  @override
  bool operator ==(Object other) =>
      (other is EvrElement && isEqual(this, other));

  @override
  int get hashCode => system.hasher.intList(bytes);

  /// Returns _true_ if this Element is encoded as Explicit VR Little Endian;
  /// otherwise, it is encoded as Implicit VR Little Endian, which is retired.
  @override
  bool get isEvr => true;

  @override
  int get vrCode => bytes.getUint16(_vrOffset);

  Uint8List get asBytes =>
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

  static Element makeFromBytes(int code, Bytes bytes, int vrIndex) {
    final pCode = code & 0x1FFFF;
    final e = (pCode >= 0x10010 && pCode <= 0x100FF)
        ? new PCevr(bytes)
        : _evrBDMakers[vrIndex](bytes, vrIndex);
    return (pCode >= 0x10010 && pCode <= 0x100FF) ? new PrivateData(e) : e;
  }

  static final List<DecodeBinaryVF> _evrBDMakers = <DecodeBinaryVF>[
    _sqError, // stop reformat
    // Maybe Undefined Lengths
    OBevr.make, OWevr.make, UNevr.make,

    // EVR Long
    ODevr.make, OFevr.make, OLevr.make,
    UCevr.make, URevr.make, UTevr.make,

    // EVR Short
    AEevr.make, ASevr.make, ATevr.make,
    CSevr.make, DAevr.make, DSevr.make,
    DTevr.make, FDevr.make, FLevr.make,
    ISevr.make, LOevr.make, LTevr.make,
    PNevr.make, SHevr.make, SLevr.make,
    SSevr.make, STevr.make, TMevr.make,
    UIevr.make, ULevr.make, USevr.make,
  ];

  static Null _sqError(Bytes bytes, [int vrIndex]) =>
      invalidElementIndex(vrIndex);

  static Element makePixelData(int code, Bytes eBytes, int vrIndex,
      [int vfLengthField, TransferSyntax ts, VFFragments fragments]) {
    if (code != kPixelData)
      return invalidKey(code, 'Invalid Tag Code for PixelData');
    switch (vrIndex) {
      case kOBIndex:
        return OBevrPixelData.make(code, vrIndex, eBytes, ts, fragments);
      case kUNIndex:
        return UNevrPixelData.make(code, vrIndex, eBytes, ts, fragments);
      case kOWIndex:
        return OWevrPixelData.make(code, vrIndex, eBytes, ts, fragments);
      default:
        return invalidVRIndex(vrIndex, null, null);
    }
  }

  /// Returns a new [SQevr], where [bytes] is [Bytes] for complete sequence.
  static SQevr makeSequence(int code, Dataset parent,
          [Iterable<Item> items, Bytes bytes]) =>
      new SQevr(parent, items, bytes);
}

// This private function should only be used by EvrShortMixin, and EvrLongMixin
int __vfLength(Bytes bytes, int vfOffset) {
  final vfLength = bytes.lengthInBytes - vfOffset;
  if (vfLength.isOdd) log.warn('vfLength($vfLength) is odd');
  assert(bytes.lengthInBytes >= vfOffset);
  assert(
      (vfLength >= 0 && vfLength <= kUndefinedLength), 'vfLength: $vfLength');
  return vfLength;
}

abstract class EvrShortMixin<V> {
  // **** Interface
  Bytes get bytes;
  int get eLength;
  // **** End interface

  int get vfLengthOffset => _shortVFLengthOffset;
  int get vfOffset => _shortVFOffset;

  /// Returns the Value Field Length field.
  int get vfLengthField {
    assert(bytes.lengthInBytes >= _shortVFOffset);
    final vflf = bytes.getUint16(_shortVFLengthOffset);
//    assert(vflf == vfLength, 'vflf: $vflf != vfLength: $vfLength');
    return vflf;
  }

  int get vfLength => __vfLength(bytes, _shortVFOffset);
}

// These private fields and functions should only be used by EvrShortMixin
const int _shortVFLengthOffset = 6;
const int _shortVFOffset = 8;

Bytes _removeShortPadding(Bytes bytes, [int padChar = kSpace]) =>
    removePadding(bytes, _shortVFOffset, padChar);

abstract class EvrLongMixin<V> {
  Bytes get bytes;

  int get vfLengthOffset => _longVFLengthOffset;
  int get vfOffset => _longVFOffset;

  /// Returns the Value Field Length field.
  int get vfLengthField {
    assert(bytes.lengthInBytes >= _longVFOffset);
    final vfl = vfLength;
    final vflf = bytes.getUint32(_longVFLengthOffset);
    assert(vflf == vfl || vflf == (vfl + 1) || vflf == kUndefinedLength,
        'vflf: $vflf vfLength: $vfl');
    if (vflf == (vfl + 1)) log.warn('** vfLengthField: Odd length field: $vfl');
    return vflf;
  }

  int get vfLength => __vfLength(bytes, _longVFOffset);
}

// These private fields and functions should only be used by EvrLongMixin
const int _longVFLengthOffset = 8;
const int _longVFOffset = 12;

Bytes _removeLongPadding(Bytes bytes, [int padChar = kSpace]) =>
    removePadding(bytes, _longVFOffset, padChar);

class FLevr extends FL
    with Common, EvrElement<double>, EvrShortMixin<double>, BDFloat32Mixin {
  @override
  final Bytes bytes;

  FLevr(this.bytes);

  @override
  Float32List get values => vfBytes.asFloat32List();

  static FLevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kFLIndex && bytes.lengthInBytes.isEven);
    return new FLevr(bytes);
  }
}

class OFevr extends OF
    with Common, EvrElement<double>, EvrLongMixin<double>, BDFloat64Mixin {
  @override
  final Bytes bytes;

  OFevr(this.bytes);

  @override
  Float32List get values => vfBytes.asFloat32List();

  static OFevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kOFIndex && bytes.lengthInBytes.isEven);
    return new OFevr(bytes);
  }
}

class FDevr extends FD
    with Common, EvrElement<double>, EvrShortMixin<double>, BDFloat64Mixin {
  @override
  final Bytes bytes;

  FDevr(this.bytes);

  @override
  Float64List get values => vfBytes.asFloat64List();

  static FDevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kFDIndex && bytes.lengthInBytes.isEven);
    return new FDevr(bytes);
  }
}

class ODevr extends OD
    with Common, EvrElement<double>, EvrLongMixin<double>, BDFloat64Mixin {
  @override
  final Bytes bytes;

  ODevr(this.bytes);

  @override
  Float64List get values => vfBytes.asFloat64List();

  static ODevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kODIndex && bytes.lengthInBytes.isEven);
    return new ODevr(bytes);
  }
}

// **** Integer Elements

class OBevr extends OB
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bytes;

  OBevr(this.bytes);

  @override
  Iterable<int> get values => vfBytes.asUint8List();

  static OBevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kOBIndex && bytes.lengthInBytes.isEven);
    return new OBevr(bytes);
  }
}

class OBevrPixelData extends OBPixelData
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBevrPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => vfBytes.asUint8List();

  static OBevrPixelData make(int code, int vrIndex, Bytes bytes,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(
        vrIndex != null || vrIndex == kOBIndex && bytes.lengthInBytes.isEven);
    return new OBevrPixelData(bytes, ts, fragments);
  }
}

class UNevr extends UN
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bytes;

  UNevr(this.bytes);

  @override
  Iterable<int> get values => vfBytes;

  static UNevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kUNIndex && bytes.lengthInBytes.isEven);
    return new UNevr(bytes);
  }
}

class UNevrPixelData extends UNPixelData
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNevrPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => vfBytes.asUint8List();

  static UNevrPixelData make(int code, int vrIndex, Bytes bytes,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(
        vrIndex != null || vrIndex == kUNIndex && bytes.lengthInBytes.isEven);
    return new UNevrPixelData(bytes, ts, fragments);
  }
}

class SSevr extends SS
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bytes;

  SSevr(this.bytes);

  @override
  Iterable<int> get values => vfBytes.asInt16List();

  static SSevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kSSIndex && bytes.lengthInBytes.isEven);
    return new SSevr(bytes);
  }
}

class USevr extends US
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bytes;

  USevr(this.bytes);

  @override
  Iterable<int> get values => vfBytes.asUint16List();

  static USevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kUSIndex && bytes.lengthInBytes.isEven);
    return new USevr(bytes);
  }
}

class OWevr extends OW
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bytes;

  OWevr(this.bytes);

  @override
  Iterable<int> get values => vfBytes.asUint16List();

  static OWevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kOWIndex && bytes.lengthInBytes.isEven);
    return new OWevr(bytes);
  }
}

class OWevrPixelData extends OWPixelData
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OWevrPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => vfBytes.asUint16List();

  static OWevrPixelData make(int code, int vrIndex, Bytes bytes,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(
        vrIndex != null || vrIndex == kOWIndex && bytes.lengthInBytes.isEven);
    return new OWevrPixelData(bytes, ts, fragments);
  }
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

/// Attribute (Element) Code (AT)
class ATevr extends AT
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bytes;

  ATevr(this.bytes);

  @override
  Iterable<int> get values => vfBytes.asUint32List();

  static ATevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kATIndex && bytes.lengthInBytes.isEven);
    return new ATevr(bytes);
  }
}

/// Other Long (OL)
class OLevr extends OL
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bytes;

  OLevr(this.bytes);

  @override
  Iterable<int> get values => vfBytes.asUint32List();

  static OLevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kOLIndex && bytes.lengthInBytes.isEven);
    return new OLevr(bytes);
  }
}

/// Signed Long (SL)
class SLevr extends SL
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bytes;

  SLevr(this.bytes);

  @override
  Iterable<int> get values => vfBytes.asUint32List();

  static SLevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kSLIndex && bytes.lengthInBytes.isEven);
    return new SLevr(bytes);
  }
}

/// Unsigned Long (UL)
class ULevr extends UL
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bytes;

  ULevr(this.bytes);

  @override
  Iterable<int> get values => vfBytes.asUint32List();

  static Element<int> make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kULIndex && bytes.lengthInBytes.isEven);
    return (bytes.getUint16(2) == 0) ? new GLevr(bytes) : new ULevr(bytes);
  }
}

/// Group Length (GL)
class GLevr extends GL
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bytes;

  GLevr(this.bytes);

  @override
  Iterable<int> get values => vfBytes.asUint32List();

  static GLevr make(Bytes bytes, int vrIndex) {
    assert(
        vrIndex != null || vrIndex == kULIndex && bytes.lengthInBytes.isEven);
    return new GLevr(bytes);
  }
}

// **** String Elements

class AEevr extends AE
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<int>,
        ByteStringMixin,
        AsciiMixin {
  @override
  final Bytes bytes;

  AEevr(this.bytes);

  static AEevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null || vrIndex == kAEIndex);
    return new AEevr(_removeShortPadding(bytes));
  }
}

class ASevr extends AS
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        AsciiMixin {
  @override
  final Bytes bytes;

  ASevr(this.bytes);

  static ASevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null || vrIndex == kASIndex);
    if (bytes.lengthInBytes != 12 && bytes.lengthInBytes != 8) {
      final length = bytes.lengthInBytes;
      log.warn('Invalid Age (AS) "${bytes.getUtf8(8, length - 8)}"');
    }
    return new ASevr(bytes);
  }
}

class CSevr extends CS
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        AsciiMixin {
  @override
  final Bytes bytes;

  CSevr(this.bytes);

  static CSevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null || vrIndex == kCSIndex);
    return new CSevr(_removeShortPadding(bytes));
  }
}

class DAevr extends DA
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        AsciiMixin {
  @override
  final Bytes bytes;

  DAevr(this.bytes);

  static DAevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null || vrIndex == kDAIndex);
    final length = bytes.lengthInBytes;
    if (length != 16 && length != 8)
      log.debug('Invalid Date (DA) "${bytes.getUtf8(8, length - 8)}"');
    return new DAevr(bytes);
  }
}

class DSevr extends DS
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        AsciiMixin {
  @override
  final Bytes bytes;

  DSevr(this.bytes);

  static DSevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null || vrIndex == kDSIndex);
    return new DSevr(_removeShortPadding(bytes));
  }
}

class DTevr extends DT
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        AsciiMixin {
  @override
  final Bytes bytes;

  DTevr(this.bytes);

  static DTevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null || vrIndex == kDTIndex);

    return new DTevr(_removeShortPadding(bytes));
  }
}

class ISevr extends IS
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        AsciiMixin {
  @override
  final Bytes bytes;

  ISevr(this.bytes);

  static ISevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null || vrIndex == kISIndex);

    return new ISevr(_removeShortPadding(bytes));
  }
}

class UIevr extends UI
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        AsciiMixin {
  @override
  final Bytes bytes;

  UIevr(this.bytes);

  static UIevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kUIIndex);
    return new UIevr(_removeShortPadding(bytes, kNull));
  }
}

class LOevr extends LO
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        Utf8Mixin {
  @override
  final Bytes bytes;

  LOevr(this.bytes);

  static Element make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kLOIndex);

    final v = _removeShortPadding(bytes);
    // Read code elt.
    final group = bytes.getUint16(0);
    final elt = bytes.getUint16(2);
    return (Tag.isPrivateGroup(group) && elt >= 0x10 && elt <= 0xFF)
        ? new PCevr(v)
        : new LOevr(v);
  }
}

class PCevr extends PC
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        Utf8Mixin {
  @override
  final Bytes bytes;

  PCevr(this.bytes);

  /// Returns a [PCTag].
  @override
  Tag get tag {
    if (Tag.isPCCode(code)) {
      final token = vfBytes.getUtf8();
      final tag = Tag.lookupByCode(code, kLOIndex, token);
      return tag;
    }
    log.debug('PC code ${dcm(code)}');
    return invalidKey(code, 'Invalid Tag Code ${toDcm(code)}');
  }

  @override
  String get id => vfBytesAsAscii;

  static PCevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kLOIndex);

    return new PCevr(_removeShortPadding(bytes));
  }

  static PCevr makeEmptyPrivateCreator(int pdTag, int vrIndex) {
    final group = Tag.privateGroup(pdTag);
    final sgNumber = (pdTag & 0xFFFF) >> 8;
    final bytes = new Bytes(8)
      ..setUint16(0, group)
      ..setUint16(0, sgNumber)
      ..setUint8(4, kLOIndex)
      //     ..setUint8(5, kO)
      ..setUint16(6, 0);
    return new PCevr(bytes);
  }
}

class PNevr extends PN
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        Utf8Mixin {
  @override
  final Bytes bytes;

  PNevr(this.bytes);

  static PNevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kPNIndex);

    return new PNevr(_removeShortPadding(bytes));
  }
}

class SHevr extends SH
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        Utf8Mixin {
  @override
  final Bytes bytes;

  SHevr(this.bytes);

  static SHevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kSHIndex);

    return new SHevr(_removeShortPadding(bytes));
  }
}

class LTevr extends LT
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        Utf8Mixin {
  @override
  final Bytes bytes;

  LTevr(this.bytes);

  @override
  Iterable<String> get values => [vfBytes.getUtf8()];
  static LTevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kLTIndex);

    return new LTevr(_removeShortPadding(bytes));
  }
}

class STevr extends ST
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        Utf8Mixin {
  @override
  final Bytes bytes;

  STevr(this.bytes);

  static STevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kSTIndex);

    return new STevr(_removeShortPadding(bytes));
  }
}

class TMevr extends TM
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        ByteStringMixin,
        AsciiMixin {
  @override
  final Bytes bytes;

  TMevr(this.bytes);

  static TMevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kTMIndex,
        'vrIndex: $vrIndex, vr: ${vrIdByIndex[vrIndex]}');

    return new TMevr(_removeShortPadding(bytes));
  }
}

class UCevr extends UC
    with
        Common,
        EvrElement<String>,
        EvrLongMixin<String>,
        ByteStringMixin,
        Utf8Mixin {
  @override
  final Bytes bytes;

  UCevr(this.bytes);

  static UCevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kUCIndex);

    return new UCevr(_removeLongPadding(bytes));
  }
}

class URevr extends UR
    with
        Common,
        EvrElement<String>,
        EvrLongMixin<String>,
        ByteStringMixin,
        Utf8Mixin {
  @override
  final Bytes bytes;

  URevr(this.bytes);

  static URevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kURIndex);

    return new URevr(_removeLongPadding(bytes));
  }
}

class UTevr extends UT
    with
        Common,
        EvrElement<String>,
        EvrLongMixin<String>,
        ByteStringMixin,
        Utf8Mixin {
  @override
  final Bytes bytes;

  UTevr(this.bytes);

  static UTevr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kUTIndex);

    return new UTevr(_removeLongPadding(bytes));
  }
}

class SQevr extends SQ<int>
    with Common, EvrElement<Item>, EvrLongMixin<String> {
  @override
  final Dataset parent;
  @override
  final Iterable<Item> values;
  @override
  final Bytes bytes;

  SQevr(this.parent, this.values, this.bytes);

  @override
  int get valuesLength => values.length;

  @override
  SQ update([Iterable<Item> vList]) => unsupportedError();
  @override
  SQ updateF(Iterable<Item> f(Iterable<Item> vList)) => unsupportedError();

  static SQevr make(Dataset parent,
          [SQ sequence, Iterable<Item> values, Bytes bytes]) =>
      new SQevr(parent, values, bytes);
}
