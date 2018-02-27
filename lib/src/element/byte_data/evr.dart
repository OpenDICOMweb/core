// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/errors.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/float.dart';
import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/element/base/integer/pixel_data.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/element/byte_data/bd_element.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/vf_fragments.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/string/ascii.dart';
import 'package:core/src/string/dicom_string.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/private/pc_tag.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/uid/well_known/transfer_syntax.dart';
import 'package:core/src/vr/vr.dart';

const int _vrOffset = 4;

abstract class EvrElement<V> implements BDElement<V> {
  @override
  ByteData get bd;
  @override
  int get vfLength;
  int get valuesLength;
  @override
  Iterable<V> get values;
  @override
  set values(Iterable<V> vList) => unsupportedError();
  bool isEqual(BDElement a, BDElement b);

  // **** End of Interface

/*
  @override
  bool operator ==(Object other) {
    if (other is EvrElement) {
      if (bd.lengthInBytes != other.bd.lengthInBytes) return false;

      final offset0 = bd.offsetInBytes;
      final offset1 = other.bd.offsetInBytes;
      final length = bd.lengthInBytes;
      for (var i = offset0, j = offset1; i < length; i++, j++)
        if (bd.getUint8(i) != other.bd.getUint8(j)) return false;
      return true;
    }
    return false;
  }
*/

  @override
  bool operator ==(Object other) =>
      (other is EvrElement && isEqual(this, other));

  @override
  int get hashCode => system.hasher.byteData(bd);

  /// Returns _true_ if this Element is encoded as Explicit VR Little Endian;
  /// otherwise, it is encoded as Implicit VR Little Endian, which is retired.
  @override
  bool get isEvr => true;

  @override
  int get vrCode => bd.getUint16(_vrOffset, Endian.little);

/*
  @override
  bool get hasValidLength {
    if (isLengthAlwaysValid) return true;
// Put print in to see how often it is called
// print('length: $valuesLength, minValues: $minValues, maxValues: $maxValues');
    return (valuesLength == 0) ||
        (valuesLength >= minValues &&
            (valuesLength <= maxValues) &&
            (valuesLength % columns == 0));
  }
*/

  Uint8List get asBytes =>
      bd.buffer.asUint8List(bd.offsetInBytes, bd.lengthInBytes);

  static BDElement make(int code, int vrIndex, ByteData bd) =>
      _evrBDMakers[vrIndex](bd, vrIndex);

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

  static Null _sqError(ByteData bd, [int vrIndex]) =>
      invalidElementIndex(vrIndex);

  static Element makePixelData(int code, int vrIndex, ByteData bd,
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

  /// Returns a new [SQevr], where [bd] is [ByteData] for complete sequence.
  static SQevr makeSequence(
          int code, ByteData bd, Dataset parent, Iterable<Item> items) =>
      new SQevr(bd, parent, items);
}

// This private function should only be used by EvrShortMixin, and EvrLongMixin
int __vfLength(ByteData bd, int vfOffset) {
  final length = bd.lengthInBytes - vfOffset;
  assert(length.isEven);
  assert(bd.lengthInBytes >= vfOffset);
  assert((length >= 0 && length <= kUndefinedLength), 'length: $length');
  return length;
}

abstract class EvrShortMixin<V> {
  // **** Interface
  ByteData get bd;
  int get eLength;
  // **** End interface

  int get vfLengthOffset => _shortVFLengthOffset;
  int get vfOffset => _shortVFOffset;

  /// Returns the Value Field Length field.
  int get vfLengthField {
    assert(bd.lengthInBytes >= _shortVFOffset);
    final vflf = bd.getUint16(_shortVFLengthOffset, Endian.little);
    assert(vflf == vfLength, 'vflf: $vflf != vfLength: $vfLength');
    return vflf;
  }

  int get vfLength => __vfLength(bd, _shortVFOffset);
}

// These private fields and functions should only be used by EvrShortMixin
const int _shortVFLengthOffset = 6;
const int _shortVFOffset = 8;

ByteData _removeShortPadding(ByteData bd, [int padChar = kSpace]) =>
    removePadding(bd, _shortVFOffset, padChar);

abstract class EvrLongMixin<V> {
  ByteData get bd;

  int get vfLengthOffset => _longVFLengthOffset;
  int get vfOffset => _longVFOffset;

  /// Returns the Value Field Length field.
  int get vfLengthField {
    assert(bd.lengthInBytes >= _longVFOffset);
    final vflf = bd.getUint32(_longVFLengthOffset, Endian.little);
    assert(vflf == vfLength || vflf == kUndefinedLength);
    return vflf;
  }

  int get vfLength => __vfLength(bd, _longVFOffset);
}

// These private fields and functions should only be used by EvrLongMixin
const int _longVFLengthOffset = 8;
const int _longVFOffset = 12;

ByteData _removeLongPadding(ByteData bd, [int padChar = kSpace]) =>
    removePadding(bd, _longVFOffset, padChar);

class FLevr extends FL
    with Common, EvrElement<double>, EvrShortMixin<double>, BDFloat32Mixin {
  @override
  final ByteData bd;

  FLevr(this.bd);

  @override
  Iterable<double> get values => Float32Mixin.fromByteData(vfByteData);

  static FLevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kFLIndex && bd.lengthInBytes.isEven);
    return new FLevr(bd);
  }
}

class OFevr extends OF
    with Common, EvrElement<double>, EvrLongMixin<double>, BDFloat32Mixin {
  @override
  final ByteData bd;

  OFevr(this.bd);

  @override
  Iterable<double> get values => Float32Mixin.fromByteData(vfByteData);

  static OFevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kOFIndex && bd.lengthInBytes.isEven);
    return new OFevr(bd);
  }
}

class FDevr extends FD
    with Common, EvrElement<double>, EvrShortMixin<double>, BDFloat64Mixin {
  @override
  final ByteData bd;

  FDevr(this.bd);

  @override
  Iterable<double> get values => Float64Mixin.fromByteData(vfByteData);

  static FDevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kFDIndex && bd.lengthInBytes.isEven);
    return new FDevr(bd);
  }
}

class ODevr extends OD
    with Common, EvrElement<double>, EvrLongMixin<double>, BDFloat64Mixin {
  @override
  final ByteData bd;

  ODevr(this.bd);

  @override
  Iterable<double> get values => Float64Mixin.fromByteData(vfByteData);

  static ODevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kODIndex && bd.lengthInBytes.isEven);
    return new ODevr(bd);
  }
}

// **** Integer Elements

class OBevr extends OB
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final ByteData bd;

  OBevr(this.bd);

  @override
  Iterable<int> get values => Uint8Base.fromByteData(vfByteData);

  static OBevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kOBIndex && bd.lengthInBytes.isEven);
    return new OBevr(bd);
  }
}

class OBevrPixelData extends OBPixelData
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final ByteData bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBevrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => Uint8Base.fromByteData(vfByteData);

  static OBevrPixelData make(int code, int vrIndex, ByteData bd,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kOBIndex && bd.lengthInBytes.isEven);
    return new OBevrPixelData(bd, ts, fragments);
  }
}

class UNevr extends UN
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final ByteData bd;

  UNevr(this.bd);

  @override
  Iterable<int> get values => vfBytes;

  static UNevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kUNIndex && bd.lengthInBytes.isEven);
    return new UNevr(bd);
  }
}

class UNevrPixelData extends UNPixelData
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int8Mixin {
  @override
  final ByteData bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNevrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => Uint8Base.fromByteData(vfByteData);

  static UNevrPixelData make(int code, int vrIndex, ByteData bd,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kUNIndex && bd.lengthInBytes.isEven);
    return new UNevrPixelData(bd, ts, fragments);
  }
}

class SSevr extends SS
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int16Mixin {
  @override
  final ByteData bd;

  SSevr(this.bd);

  @override
  Iterable<int> get values => Int16Base.fromByteData(vfByteData);

  static SSevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kSSIndex && bd.lengthInBytes.isEven);
    return new SSevr(bd);
  }
}

class USevr extends US
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int16Mixin {
  @override
  final ByteData bd;

  USevr(this.bd);

  @override
  Iterable<int> get values => Uint16Base.fromByteData(vfByteData);

  static USevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kUSIndex && bd.lengthInBytes.isEven);
    return new USevr(bd);
  }
}

class OWevr extends OW
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int16Mixin {
  @override
  final ByteData bd;

  OWevr(this.bd);

  @override
  Iterable<int> get values => Uint16Base.fromByteData(vfByteData);

  static OWevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kOWIndex && bd.lengthInBytes.isEven);
    return new OWevr(bd);
  }
}

class OWevrPixelData extends OWPixelData
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int16Mixin {
  @override
  final ByteData bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OWevrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => Uint16Base.fromByteData(vfByteData);

  static OWevrPixelData make(int code, int vrIndex, ByteData bd,
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
  final ByteData bd;

  ATevr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.fromByteData(vfByteData);

  static ATevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kATIndex && bd.lengthInBytes.isEven);
    return new ATevr(bd);
  }
}

/// Other Long (OL)
class OLevr extends OL
    with Common, EvrElement<int>, EvrLongMixin<int>, IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  OLevr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.fromByteData(vfByteData);

  static OLevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kOLIndex && bd.lengthInBytes.isEven);
    return new OLevr(bd);
  }
}

/// Signed Long (SL)
class SLevr extends SL
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  SLevr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.fromByteData(vfByteData);

  static SLevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kSLIndex && bd.lengthInBytes.isEven);
    return new SLevr(bd);
  }
}

/// Unsigned Long (UL)
class ULevr extends UL
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  ULevr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.fromByteData(vfByteData);

  static Element<int> make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kULIndex && bd.lengthInBytes.isEven);
    return (bd.getUint16(2) == 0) ? new GLevr(bd) : new ULevr(bd);
  }
}

/// Group Length (GL)
class GLevr extends GL
    with Common, EvrElement<int>, EvrShortMixin<int>, IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  GLevr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.fromByteData(vfByteData);

  static GLevr make(ByteData bd, int vrIndex) {
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
  final ByteData bd;

  AEevr(this.bd);

  static AEevr make(ByteData bd, int vrIndex) {
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
  final ByteData bd;

  ASevr(this.bd);

  static ASevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kASIndex);
    if (bd.lengthInBytes != 4)
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
  final ByteData bd;

  CSevr(this.bd);

  static CSevr make(ByteData bd, int vrIndex) {
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
  final ByteData bd;

  DAevr(this.bd);

  static DAevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null || vrIndex == kDAIndex);
    if (bd.lengthInBytes != 16)
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
  final ByteData bd;

  DSevr(this.bd);

  static DSevr make(ByteData bd, int vrIndex) {
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
  final ByteData bd;

  DTevr(this.bd);

  static DTevr make(ByteData bd, int vrIndex) {
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
  final ByteData bd;

  ISevr(this.bd);

  static ISevr make(ByteData bd, int vrIndex) {
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
  final ByteData bd;

  UIevr(this.bd);

  static UIevr make(ByteData bd, int vrIndex) {
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
  final ByteData bd;

  LOevr(this.bd);

  static Element make(ByteData bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kLOIndex);
    assert(checkPadding(bd));
    final v = _removeShortPadding(bd);
    // Read code elt.
    final group = bd.getUint16(0, Endian.little);
    final elt = bd.getUint16(2, Endian.little);
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
  final ByteData bd;

  PCevr(this.bd);

  /// Returns a [PCTag].
  @override
  Tag get tag {
    if (Tag.isPCCode(code)) {
      final token = vfBytesAsAscii;
      final tag = PCTag.lookupByCode(code, kLOIndex, token);
      return tag;
    }
    return invalidKey(code, 'Invalid Tag Code ${dcm(code)}');
  }

  @override
  String get id => vfBytesAsAscii;

  static PCevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kLOIndex);
    assert(checkPadding(bd));
    return new PCevr(_removeShortPadding(bd));
  }

  static PCevr makeEmptyPrivateCreator(int pdTag, int vrIndex) {
    final group = Tag.privateGroup(pdTag);
    final sgNumber = (pdTag & 0xFFFF) >> 8;
    final bd = new ByteData(8)
      ..setUint16(0, group, Endian.little)
      ..setUint16(0, sgNumber, Endian.little)
      ..setUint8(4, kL)
      ..setUint8(5, kO)
      ..setUint16(6, 0, Endian.little);
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
  final ByteData bd;

  PNevr(this.bd);

  static PNevr make(ByteData bd, int vrIndex) {
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
  final ByteData bd;

  SHevr(this.bd);

  static SHevr make(ByteData bd, int vrIndex) {
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
        TextMixin {
  @override
  final ByteData bd;

  LTevr(this.bd);

  @override
  Iterable<String> get values => LT.fromByteData(vfByteData);
  static LTevr make(ByteData bd, int vrIndex) {
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
        TextMixin {
  @override
  final ByteData bd;

  STevr(this.bd);

  static STevr make(ByteData bd, int vrIndex) {
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
  final ByteData bd;

  TMevr(this.bd);

  static TMevr make(ByteData bd, int vrIndex) {
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
  final ByteData bd;

  UCevr(this.bd);

  static UCevr make(ByteData bd, int vrIndex) {
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
        TextMixin {
  @override
  final ByteData bd;

  URevr(this.bd);

  static URevr make(ByteData bd, int vrIndex) {
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
        TextMixin {
  @override
  final ByteData bd;

  UTevr(this.bd);

  static UTevr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kUTIndex);
    assert(checkPadding(bd));
    return new UTevr(_removeLongPadding(bd));
  }
}

class SQevr extends SQ<int>
    with Common, EvrElement<Item>, EvrLongMixin<String> {
  @override
  final ByteData bd;
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

  static SQevr make(ByteData bd, Dataset parent, Iterable<Item> values) =>
      new SQevr(bd, parent, values);
}
