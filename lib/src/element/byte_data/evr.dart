// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/base.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/base/vf_fragments.dart';
import 'package:core/src/element/byte_data/bd_element.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

const int _vrOffset = 4;

abstract class EvrElement<V> implements BDElement<V> {
  @override
  Bytes get bd;
  @override
  int get vfLength;
  int get valuesLength;
  @override
  Iterable<V> get values;
  @override
  set values(Iterable<V> vList) => unsupportedError();
  bool isEqual(BDElement a, BDElement b);

  // **** End of Interface

  @override
  bool operator ==(Object other) =>
      (other is EvrElement && isEqual(this, other));

  @override
  int get hashCode => bd.hashCode;

  /// Returns _true_ if this Element is encoded as Explicit VR Little Endian;
  /// otherwise, it is encoded as Implicit VR Little Endian, which is retired.
  @override
  bool get isEvr => true;

  @override
  int get vrCode => bd.getUint16(_vrOffset);

  static Element makeFromBytes(int code, Bytes bytes, int vrIndex) =>
      _evrBDMakers[vrIndex](bytes, vrIndex);

  static final List<ElementFromBytes> _evrBDMakers = <ElementFromBytes>[
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

  static Null _sqError(Bytes bd, int vrIndex) =>
      invalidElementIndex(vrIndex);

  static Element makePixelData(int code, int vrIndex, Bytes bd,
      [TransferSyntax ts, VFFragments fragments]) {
    if (code != kPixelData)
      return invalidKey(code, 'Invalid Tag Code for PixelData');
    switch (vrIndex) {
      case kOBIndex:
        return OBevrPixelData.make(code, vrIndex, bd, ts, fragments);
      case kUNIndex:
        return UNevrPixelData.make(code, vrIndex, bd, ts, fragments);
      case kOWIndex:
        return OWevrPixelData.make(code, vrIndex, bd, ts, fragments);
      default:
        return invalidVRIndex(vrIndex, null, null);
    }
  }

  /// Returns a new [SQevr], where [bd] is [Bytes] for complete sequence.
  static SQevr makeSequence(
          int code, Bytes bd, Dataset parent, Iterable<Item> items) =>
      new SQevr(bd, parent, items);
}

// This private function should only be used by EvrShortMixin, and EvrLongMixin
int __vfLength(Bytes bd, int vfOffset) {
  final length = bd.lengthInBytes - vfOffset;
  assert(length.isEven);
  assert(bd.lengthInBytes >= vfOffset);
  assert((length >= 0 && length <= kUndefinedLength), 'length: $length');
  return length;
}

abstract class EvrShortMixin<V> {
  // **** Interface
  Bytes get bd;
  int get eLength;
  // **** End interface

  int get vfLengthOffset => _shortVFLengthOffset;
  int get vfOffset => _shortVFOffset;

  /// Returns the Value Field Length field.
  int get vfLengthField {
    assert(bd.lengthInBytes >= _shortVFOffset);
    final vflf = bd.getUint16(_shortVFLengthOffset);
//    assert(vflf == vfLength, 'vflf: $vflf != vfLength: $vfLength');
    return vflf;
  }

  int get vfLength => __vfLength(bd, _shortVFOffset);
}

// These private fields and functions should only be used by EvrShortMixin
const int _shortVFLengthOffset = 6;
const int _shortVFOffset = 8;

Bytes _removeShortPadding(Bytes bd, [int padChar = kSpace]) =>
    removePadding(bd, _shortVFOffset, padChar);

abstract class EvrLongMixin<V> {
  Bytes get bd;

  int get vfLengthOffset => _longVFLengthOffset;
  int get vfOffset => _longVFOffset;

  /// Returns the Value Field Length field.
  int get vfLengthField {
    assert(bd.lengthInBytes >= _longVFOffset);
    final vflf = bd.getUint32(_longVFLengthOffset);
    assert(vflf == vfLength || vflf == kUndefinedLength);
    return vflf;
  }

  int get vfLength => __vfLength(bd, _longVFOffset);
}

// These private fields and functions should only be used by EvrLongMixin
const int _longVFLengthOffset = 8;
const int _longVFOffset = 12;

Bytes _removeLongPadding(Bytes bd, [int padChar = kSpace]) =>
    removePadding(bd, _longVFOffset, padChar);

class FLevr extends FL
    with Common, EvrElement<double>, EvrShortMixin<double>, BDFloat32Mixin {
  @override
  final Bytes bd;

  FLevr(this.bd);

  @override
  Iterable<double> get values => vfBytes.asFloat32List();

  static FLevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kFLIndex && bd.lengthInBytes.isEven);
    return new FLevr(bd);
  }
}

class OFevr extends OF
    with Common, EvrElement<double>, EvrLongMixin<double>, BDFloat64Mixin {
  @override
  final Bytes bd;

  OFevr(this.bd);
/*
  {
    print('OFevr bd: ${bd.buffer.asUint8List()}');
    print('OFevr e: $this');
    final v = this[0];
    print('OFevr e[0]: $v');
  }
*/

  @override
  Iterable<double> get values => vfBytes.asFloat32List();

  static OFevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kOFIndex && bd.lengthInBytes.isEven);
    return new OFevr(bd);
  }
}

class FDevr extends FD
    with Common, EvrElement<double>, EvrShortMixin<double>, BDFloat64Mixin {
  @override
  final Bytes bd;

  FDevr(this.bd);

  @override
  Iterable<double> get values => vfBytes.asFloat64List();

  static FDevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kFDIndex && bd.lengthInBytes.isEven);
    return new FDevr(bd);
  }
}

class ODevr extends OD
    with Common, EvrElement<double>, EvrLongMixin<double>, BDFloat64Mixin {
  @override
  final Bytes bd;

  ODevr(this.bd);

  @override
  Iterable<double> get values => vfBytes.asFloat64List();

  static ODevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kODIndex && bd.lengthInBytes.isEven);
    return new ODevr(bd);
  }
}

// **** Integer Elements

class OBevr extends OB
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bd;

  OBevr(this.bd);

  @override
  Iterable<int> get values => bd.asUint8List();

  static OBevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kOBIndex && bd.lengthInBytes.isEven);
    return new OBevr(bd);
  }
}

class OBevrPixelData extends OBPixelData
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBevrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => bd.asUint8List();

  static OBevrPixelData make(int code, int vrIndex, Bytes bd,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kOBIndex && bd.lengthInBytes.isEven);
    return new OBevrPixelData(bd, ts, fragments);
  }
}

class UNevr extends UN
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bd;

  UNevr(this.bd);

  @override
  Iterable<int> get values => vfBytes;

  static UNevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kUNIndex && bd.lengthInBytes.isEven);
    return new UNevr(bd);
  }
}

class UNevrPixelData extends UNPixelData
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNevrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => bd.asUint8List();

  static UNevrPixelData make(int code, int vrIndex, Bytes bd,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kUNIndex && bd.lengthInBytes.isEven);
    return new UNevrPixelData(bd, ts, fragments);
  }
}

class SSevr extends SS
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bd;

  SSevr(this.bd);

  @override
  Iterable<int> get values => bd.asInt16List();

  static SSevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kSSIndex && bd.lengthInBytes.isEven);
    return new SSevr(bd);
  }
}

class USevr extends US
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bd;

  USevr(this.bd);

  @override
  Iterable<int> get values => bd.asUint16List();

  static USevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kUSIndex && bd.lengthInBytes.isEven);
    return new USevr(bd);
  }
}

class OWevr extends OW
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bd;

  OWevr(this.bd);

  @override
  Iterable<int> get values => bd.asUint16List();

  static OWevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kOWIndex && bd.lengthInBytes.isEven);
    return new OWevr(bd);
  }
}

class OWevrPixelData extends OWPixelData
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OWevrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => bd.asUint16List();

  static OWevrPixelData make(int code, int vrIndex, Bytes bd,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kOWIndex && bd.lengthInBytes.isEven);
    return new OWevrPixelData(bd, ts, fragments);
  }
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

/// Attribute (Element) Code (AT)
class ATevr extends AT
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bd;

  ATevr(this.bd);

  @override
  Iterable<int> get values => bd.asUint32List();

  static ATevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kATIndex && bd.lengthInBytes.isEven);
    return new ATevr(bd);
  }
}

/// Other Long (OL)
class OLevr extends OL
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bd;

  OLevr(this.bd);

  @override
  Iterable<int> get values => bd.asUint32List();

  static OLevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kOLIndex && bd.lengthInBytes.isEven);
    return new OLevr(bd);
  }
}

/// Signed Long (SL)
class SLevr extends SL
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bd;

  SLevr(this.bd);

  @override
  Iterable<int> get values => bd.asInt32List();

  static SLevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kSLIndex && bd.lengthInBytes.isEven);
    return new SLevr(bd);
  }
}

/// Unsigned Long (UL)
class ULevr extends UL
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bd;

  ULevr(this.bd);

  @override
  Iterable<int> get values => bd.asUint32List();

  static Element<int> make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kULIndex && bd.lengthInBytes.isEven);
    return (bd.getUint16(2) == 0) ? new GLevr(bd) : new ULevr(bd);
  }
}

/// Group Length (GL)
class GLevr extends GL
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bd;

  GLevr(this.bd);

  @override
  Iterable<int> get values => bd.asUint32List();

  static GLevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kULIndex && bd.lengthInBytes.isEven);
    return new GLevr(bd);
  }
}

// **** String Elements

class AEevr extends AE
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<int>,
        BDStringMixin,
        AsciiMixin {
  @override
  final Bytes bd;

  AEevr(this.bd);

  static AEevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kAEIndex);
    assert(checkPadding(bd));
    return new AEevr(_removeShortPadding(bd));
  }
}

class ASevr extends AS
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        AsciiMixin {
  @override
  final Bytes bd;

  ASevr(this.bd);

  static ASevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kASIndex);
    if (bd.lengthInBytes != 12)
      log.error('Invalid Age (AS) length: ${bd.lengthInBytes}');
    return new ASevr(bd);
  }
}

class CSevr extends CS
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        AsciiMixin {
  @override
  final Bytes bd;

  CSevr(this.bd);

  static CSevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kCSIndex);
    assert(checkPadding(bd));
    return new CSevr(_removeShortPadding(bd));
  }
}

class DAevr extends DA
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        AsciiMixin {
  @override
  final Bytes bd;

  DAevr(this.bd);

  static DAevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kDAIndex);
    if (bd.lengthInBytes != 16 && bd.lengthInBytes != 8)
      log.error('Invalid Date (DA) length: ${bd.lengthInBytes}');
    return new DAevr(bd);
  }
}

class DSevr extends DS
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        AsciiMixin {
  @override
  final Bytes bd;

  DSevr(this.bd);

  static DSevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kDSIndex);
    return new DSevr(_removeShortPadding(bd));
  }
}

class DTevr extends DT
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        AsciiMixin {
  @override
  final Bytes bd;

  DTevr(this.bd);

  static DTevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kDTIndex);
    assert(checkPadding(bd));
    return new DTevr(_removeShortPadding(bd));
  }
}

class ISevr extends IS
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        AsciiMixin {
  @override
  final Bytes bd;

  ISevr(this.bd);

  static ISevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kISIndex);
    assert(checkPadding(bd));
    return new ISevr(_removeShortPadding(bd));
  }
}

class UIevr extends UI
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        AsciiMixin {
  @override
  final Bytes bd;

  UIevr(this.bd);

  static UIevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kUIIndex);
    assert(checkPadding(bd, kNull));
    return new UIevr(_removeShortPadding(bd, kNull));
  }
}

class LOevr extends LO
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        Utf8Mixin {
  @override
  final Bytes bd;

  LOevr(this.bd);

  static Element make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kLOIndex);
    assert(checkPadding(bd));
    final v = _removeShortPadding(bd);
    // Read code elt.
    final group = bd.getUint16(0);
    final elt = bd.getUint16(2);
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
        BDStringMixin,
        Utf8Mixin {
  @override
  final Bytes bd;

  PCevr(this.bd);

  /// Returns a [PCTag].
  @override
  Tag get tag {
    if (Tag.isPCCode(code)) {
      final token = vfBytesAsAscii;
      final tag = PCTag.lookupByCode(code, kLOIndex, token);
      return tag;
    }
    return invalidKey(code, 'Invalid Tag Code ${toDcm(code)}');
  }

  @override
  String get id => vfBytesAsAscii;

  static PCevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kLOIndex);
    assert(checkPadding(bd));
    return new PCevr(_removeShortPadding(bd));
  }

  static PCevr makeEmptyPrivateCreator(int pdTag, int vrIndex) {
    final group = Tag.privateGroup(pdTag);
    final sgNumber = (pdTag & 0xFFFF) >> 8;
    final bd = new Bytes(8)
      ..setUint16(0, group)
      ..setUint16(0, sgNumber)
      ..setUint8(4, kL)
      ..setUint8(5, kO)
      ..setUint16(6, 0);
    return new PCevr(bd);
  }
}

class PNevr extends PN
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        Utf8Mixin {
  @override
  final Bytes bd;

  PNevr(this.bd);

  static PNevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kPNIndex);
    assert(checkPadding(bd));
    return new PNevr(_removeShortPadding(bd));
  }
}

class SHevr extends SH
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        Utf8Mixin {
  @override
  final Bytes bd;

  SHevr(this.bd);

  static SHevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kSHIndex);
    assert(checkPadding(bd));
    return new SHevr(_removeShortPadding(bd));
  }
}

class LTevr extends LT
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        Utf8Mixin {
  @override
  final Bytes bd;

  LTevr(this.bd);

  @override
  Iterable<String> get values => LT.fromBytes(vfBytes);
  static LTevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kLTIndex);
    assert(checkPadding(bd));
    return new LTevr(_removeShortPadding(bd));
  }
}

class STevr extends ST
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        Utf8Mixin {
  @override
  final Bytes bd;

  STevr(this.bd);

  static STevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kSTIndex);
    assert(checkPadding(bd));
    return new STevr(_removeShortPadding(bd));
  }
}

class TMevr extends TM
    with
        Common,
        EvrElement<String>,
        EvrShortMixin<String>,
        BDStringMixin,
        AsciiMixin {
  @override
  final Bytes bd;

  TMevr(this.bd);

  static TMevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kTMIndex,
        'vrIndex: $vrIndex, vr: ${vrIdByIndex[vrIndex]}');
    assert(checkPadding(bd));
    return new TMevr(_removeShortPadding(bd));
  }
}

class UCevr extends UC
    with
        Common,
        EvrElement<String>,
        EvrLongMixin<String>,
        BDStringMixin,
        Utf8Mixin {
  @override
  final Bytes bd;

  UCevr(this.bd);

  static UCevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kUCIndex);
    assert(checkPadding(bd));
    return new UCevr(_removeLongPadding(bd));
  }
}

class URevr extends UR
    with
        Common,
        EvrElement<String>,
        EvrLongMixin<String>,
        BDStringMixin,
        Utf8Mixin {
  @override
  final Bytes bd;

  URevr(this.bd);

  static URevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kURIndex);
    assert(checkPadding(bd));
    return new URevr(_removeLongPadding(bd));
  }
}

class UTevr extends UT
    with
        Common,
        EvrElement<String>,
        EvrLongMixin<String>,
        BDStringMixin,
        Utf8Mixin {
  @override
  final Bytes bd;

  UTevr(this.bd);

  static UTevr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kUTIndex);
    assert(checkPadding(bd));
    return new UTevr(_removeLongPadding(bd));
  }
}

class SQevr extends SQ<int>
    with Common, EvrElement<Item>, EvrLongMixin<String> {
  @override
  final Bytes bd;
  @override
  final Dataset parent;
  @override
  final Iterable<Item> values;

  SQevr(this.bd, this.parent, this.values);

  @override
  int get valuesLength => values.length;

  @override
  SQ update([Iterable<Item> vList]) => unsupportedError();
  @override
  SQ updateF(Iterable<Item> f(Iterable<Item> vList)) => unsupportedError();

  static SQevr make(Bytes bd, Dataset parent, Iterable<Item> values) =>
      new SQevr(bd, parent, values);
}
