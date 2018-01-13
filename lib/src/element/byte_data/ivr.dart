// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset//errors.dart';
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dicom.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/float.dart';
import 'package:core/src/element/base/integer.dart';
import 'package:core/src/element/base/pixel_data.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/element/byte_data/bd_element.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/vf_fragments.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/uid/well_known/transfer_syntax.dart';
import 'package:core/src/vr/vr.dart';

int _getValuesLength(int vfLengthField, int sizeInBytes) {
  final length = vfLengthField ~/ sizeInBytes;
  assert(
      vfLengthField >= 0 && vfLengthField.isEven && (vfLengthField % sizeInBytes == 0));
  return length;
}

const int _vfLengthOffset = 4;
const int _vfOffset = 8;

abstract class Ivr<V> implements BDElement<V> {
  @override
  ByteData get bd;
  @override
  int get vfLength;
  int get valuesLength;
  @override
  Iterable<V> get values;
  @override
  set values(Iterable<V> vList) => unsupportedError();

  @override
  bool operator ==(Object other) {
    if (other is Ivr) {
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

  @override
  int get hashCode => system.hasher.byteData(bd);

  /// Returns _true_ if this Element is encoded as Explicit VR Little Endian;
  /// otherwise, it is encoded as Implicit VR Little Endian, which is retired.
  @override
  bool get isEvr => false;

  //Urgent fix:
  @override
  int get deIdIndex => 0;
  @override
  int get ieIndex => 0;
  bool get allowInvalid => true;
  bool get allowMalformed => true;

  /// Returns the length in bytes of _this_ Element.
  int get eLength => bd.lengthInBytes;

  @override
  int get vrCode => tag.vrCode;
  @override
  int get vrIndex => tag.vrIndex;
  @override
  int get vfLengthOffset => _vfLengthOffset;
  @override
  int get vfOffset => _vfOffset;

  /// Returns the Value Field Length field.
  @override
  int get vfLengthField => bd.getUint16(_vfLengthOffset, Endian.little);

  @override
  Uint8List get vfBytesWithPadding => bd.buffer.asUint8List(bd.offsetInBytes);

  @override
  Uint8List get vfBytes => bd.buffer.asUint8List(bd.offsetInBytes, vfLength);

  @override
  ByteData get vfByteDataWithPadding => bd.buffer.asByteData(bd.offsetInBytes);

  @override
  ByteData get vfByteData => bd.buffer.asByteData(bd.offsetInBytes, vfLength);
  
  static Null _sqError(ByteData bd, [int vrIndex]) => invalidElementIndex(vrIndex);

  static BDElement make(int code, int vrIndex, ByteData bd) =>
      _ivrBDMakers[vrIndex](bd, vrIndex);

  static final List<DecodeBinaryVF> _ivrBDMakers = <DecodeBinaryVF>[
    _sqError, // stop reformat
    // Maybe Undefined Lengths
    OBivr.make, OWivr.make, UNivr.make,

    // IVR Long
    ODivr.make, OFivr.make, OLivr.make,
    UCivr.make, URivr.make, UTivr.make,

    // IVR Short
    TMivr.make, ASivr.make, ATivr.make,
    CSivr.make, DAivr.make, DSivr.make,
    DTivr.make, FDivr.make, FLivr.make,
    ISivr.make, LOivr.make, LTivr.make,
    PNivr.make, SHivr.make, SLivr.make,
    SSivr.make, STivr.make, TMivr.make,
    UIivr.make, ULivr.make, USivr.make,
  ];

  static Element makePixelData(int code, int vrIndex, ByteData bd,
      [TransferSyntax ts, VFFragments fragments]) {
    if (code != kPixelData) return invalidKey(code, 'Invalid Tag Code for PixelData');
    switch (vrIndex) {
      case kOBIndex:
        return OBivrPixelData.make(bd, vrIndex, ts, fragments);
      case kUNIndex:
        return UNivrPixelData.make(bd, vrIndex, ts, fragments);
      case kOWIndex:
        return OWivrPixelData.make(bd, vrIndex, ts, fragments);
      default:
        return invalidVRIndex(vrIndex, null, null);
    }
  }

  /// Returns a new [SQivr], where [bd] is [ByteData] for complete sequence.
  static SQivr makeSequence(
          int code, ByteData bd, Dataset parent, Iterable<Item> items) =>
      new SQivr(bd, parent, items);
}

// **** IVR Float Elements (FL, FD, OD, OF)

class FLivr extends FL with Common, Ivr<double>, Float32Mixin {
  @override
  final ByteData bd;

  FLivr(this.bd);

  @override
  Iterable<double> get values => Float32Base.listFromByteData(vfByteData);

  static FLivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new FLivr(bd);
  }
}

class OFivr extends OF with Common, Ivr<double>, Float32Mixin {
  @override
  final ByteData bd;

  OFivr(this.bd);

  @override
  int get valuesLength => _getValuesLength(vfLengthField, sizeInBytes);

  @override
  Iterable<double> get values => Float32Base.listFromByteData(vfByteData);

  static OFivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OFivr(bd);
  }
}

// **** IVR 64-Bit Float Elements (OD, OF)

class FDivr extends FL with Common, Ivr<double>, Float32Mixin {
  @override
  final ByteData bd;

  FDivr(this.bd);

  @override
  int get valuesLength => _getValuesLength(vfLengthField, sizeInBytes);

  @override
  Iterable<double> get values =>Float64Base.listFromByteData(vfByteData);

  static FDivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new FDivr(bd);
  }
}

class ODivr extends OD with Common, Ivr<double>, Float32Mixin {
  @override
  final ByteData bd;

  ODivr(this.bd);

  @override
  Iterable<double> get values => Float64Base.listFromByteData(vfByteData);

  static ODivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ODivr(bd);
  }
}

// **** Integer Elements

// **** 8-bit Integer Elements (OB, UN)

class OBivr extends OB with Common, Ivr<int>,  IntMixin, Int8Mixin {
  @override
  final ByteData bd;

  OBivr(this.bd);

  @override
  Iterable<int> get values => Uint8Base.listFromByteData(vfByteData);

  static OBivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OBivr(bd);
  }
}

class OBivrPixelData extends OBPixelData with Common, Ivr<int>, IntMixin, Int8Mixin {
  @override
  final ByteData bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBivrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values =>  Uint8Base.listFromByteData(vfByteData);

  static OBivrPixelData make(ByteData bd, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kFLIndex);
    return new OBivrPixelData(bd, ts, fragments);
  }
}

class UNivr extends UN with Common, Ivr<int>,  IntMixin, Int8Mixin {
  @override
  final ByteData bd;

  UNivr(this.bd);

  @override
  Iterable<int> get values =>  Uint8Base.listFromByteData(vfByteData);

  static UNivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new UNivr(bd);
  }
}

class UNivrPixelData extends UNPixelData with Common, Ivr<int>, IntMixin, Int8Mixin {
  @override
  final ByteData bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNivrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values =>  Uint8Base.listFromByteData(vfByteData);

  static UNivrPixelData make(ByteData bd, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kFLIndex);
    return new UNivrPixelData(bd, ts, fragments);
  }
}

// **** 16-bit Integer Elements (SS, US, OW)

class SSivr extends SS with Common, Ivr<int>,  IntMixin, Int16Mixin {
  @override
  final ByteData bd;

  SSivr(this.bd);

  @override
  Iterable<int> get values =>  Int16Base.listFromByteData(vfByteData);

  static SSivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new SSivr(bd);
  }
}

class USivr extends US with Common, Ivr<int>,  IntMixin, Int16Mixin {
  @override
  final ByteData bd;

  USivr(this.bd);

  @override
  Iterable<int> get values =>  Uint16Base.listFromByteData(vfByteData);

  static USivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new USivr(bd);
  }
}

class OWivr extends OW with Common, Ivr<int>,  IntMixin, Int16Mixin {
  @override
  final ByteData bd;

  OWivr(this.bd);

  @override
  Iterable<int> get values =>  Uint16Base.listFromByteData(vfByteData);

  static OWivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OWivr(bd);
  }
}

class OWivrPixelData extends OWPixelData with Common, Ivr<int>, IntMixin, Int16Mixin {
  @override
  final ByteData bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OWivrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values =>  Uint16Base.listFromByteData(vfByteData);

  static OWivrPixelData make(ByteData bd, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kOWIndex);
    return new OWivrPixelData(bd, ts, fragments);
  }
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

/// Attribute (Element) Code (AT)
class ATivr extends AT with Common, Ivr<int>,  IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  ATivr(this.bd);

  @override
  Iterable<int> get values =>  Uint32Base.listFromByteData(vfByteData);

  static ATivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ATivr(bd);
  }
}

/// Other Long (OL)
class OLivr extends OL with Common, Ivr<int>,  IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  OLivr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.listFromByteData(vfByteData);

  static OLivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OLivr(bd);
  }
}

/// Signed Long (SL)
class SLivr extends SL with Common, Ivr<int>,  IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  SLivr(this.bd);

  @override
  Iterable<int> get values => Int32Base.listFromByteData(vfByteData);

  static SLivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new SLivr(bd);
  }
}

/// Unsigned Long (UL)
class ULivr extends UL with Common, Ivr<int>,  IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  ULivr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.listFromByteData(vfByteData);

  static ULivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ULivr(bd);
  }
}

/// Group Length (GL)
class GLivr extends GL with Common, Ivr<int>,  IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  GLivr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.listFromByteData(vfByteData);

  static const String kVRKeyword = 'GL';
  static const String kVRName = 'Group Length';

  static GLivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new GLivr(bd);
  }
}

// **** String Elements

class AEivr extends AE with Common, Ivr<String>,  StringMixin, AsciiMixin {
  @override
  final ByteData bd;

  AEivr(this.bd);

  static AEivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new AEivr(bd);
  }
}

class ASivr extends AS with Common, Ivr<String>,  StringMixin, AsciiMixin {
  @override
  final ByteData bd;

  ASivr(this.bd);

  static ASivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ASivr(bd);
  }
}

class CSivr extends CS with Common, Ivr<String>,  StringMixin, AsciiMixin {
  @override
  final ByteData bd;

  CSivr(this.bd);

  static CSivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new CSivr(bd);
  }
}

class DAivr extends DA with Common, Ivr<String>,  StringMixin, AsciiMixin {
  @override
  final ByteData bd;

  DAivr(this.bd);

  static DAivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new DAivr(bd);
  }
}

class DSivr extends DS with Common, Ivr<String>,  StringMixin, AsciiMixin {
  @override
  final ByteData bd;

  DSivr(this.bd);

  static DSivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new DSivr(bd);
  }
}

class DTivr extends DT with Common, Ivr<String>,  StringMixin, AsciiMixin {
  @override
  final ByteData bd;

  DTivr(this.bd);

  static DTivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new DTivr(bd);
  }
}

class ISivr extends IS with Common, Ivr<String>,  StringMixin, AsciiMixin {
  @override
  final ByteData bd;

  ISivr(this.bd);

  static ISivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ISivr(bd);
  }
}

class UIivr extends UI with Common, Ivr<String>,  StringMixin, AsciiMixin {
  @override
  final ByteData bd;

  UIivr(this.bd);

  static UIivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new UIivr(bd);
  }
}

class LOivr extends LO with Common, Ivr<String>,  StringMixin, Utf8Mixin {
  @override
  final ByteData bd;

  LOivr(this.bd);

  static LOivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new LOivr(bd);
  }
}

class PCivr extends PC with Common, Ivr<String>,  StringMixin, Utf8Mixin {
  @override
  final ByteData bd;

  PCivr(this.bd);

  static PCivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new PCivr(bd);
  }
}

class PNivr extends PN with Common, Ivr<String>,  StringMixin, Utf8Mixin {
  @override
  final ByteData bd;

  PNivr(this.bd);

  static PNivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new PNivr(bd);
  }
}

class SHivr extends SH with Common, Ivr<String>,  StringMixin, Utf8Mixin {
  @override
  final ByteData bd;

  SHivr(this.bd);

  static SHivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new SHivr(bd);
  }
}

class LTivr extends LT with Common, Ivr<String>,  StringMixin, TextMixin {
  @override
  final ByteData bd;

  LTivr(this.bd);

  @override
  Iterable<String> get values => LT.fromByteData(vfByteData);
  static LTivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new LTivr(bd);
  }
}

class STivr extends ST with Common, Ivr<String>,  StringMixin, TextMixin {
  @override
  final ByteData bd;

  STivr(this.bd);

  static STivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new STivr(bd);
  }
}

class TMivr extends TM with Common, Ivr<String>,  StringMixin, AsciiMixin {
  @override
  final ByteData bd;

  TMivr(this.bd);

  static TMivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new TMivr(bd);
  }
}

class UCivr extends UC with Common, Ivr<String>,  StringMixin, Utf8Mixin {
  @override
  final ByteData bd;

  UCivr(this.bd);

  static UCivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new UCivr(bd);
  }
}

class URivr extends UR with Common, Ivr<String>,  StringMixin, TextMixin {
  @override
  final ByteData bd;

  URivr(this.bd);

  static URivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new URivr(bd);
  }
}

class UTivr extends UT with Common, Ivr<String>,  StringMixin, TextMixin {
  @override
  final ByteData bd;

  UTivr(this.bd);

  static UTivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new UTivr(bd);
  }
}

class SQivr extends SQ<Item> with Ivr<Item> {
  @override
  final ByteData bd;
  @override
  final Dataset parent;
  @override
  final Iterable<Item> values;

  SQivr(this.bd, this.parent, this.values);

  @override
  int get valuesLength => values.length;

  @override
  SQ update([Iterable<Item> vList]) => unsupportedError();
  @override
  SQ updateF(Iterable<Item> f(Iterable<Item> vList)) => unsupportedError();

  static SQivr make(ByteData bd, Dataset parent, Iterable<Item> values) =>
      new SQivr(bd, parent, values);
}
