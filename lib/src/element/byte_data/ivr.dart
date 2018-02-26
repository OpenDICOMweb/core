// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset//errors.dart';
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
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

int _getValuesLength(int vfLengthField, int sizeInBytes) {
  final length = vfLengthField ~/ sizeInBytes;
  assert(vfLengthField >= 0 &&
      vfLengthField.isEven &&
      (vfLengthField % sizeInBytes == 0));
  return length;
}

const int _vfLengthOffset = 4;
const int _vfOffset = 8;

ByteData _removePadding(ByteData bd, [int padChar = kSpace]) =>
    removePadding(bd, _vfOffset, padChar);


abstract class IvrElement<V> implements BDElement<V> {
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

  @override
  bool operator ==(Object other) =>
      (other is IvrElement && isEqual(this, other));

/*
  @override
  bool operator ==(Object other) {
    if (other is IvrElement) {
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
  int get hashCode => system.hasher.byteData(bd);

  /// Returns _true_ if this Element is encoded as Explicit VR Little Endian;
  /// otherwise, it is encoded as Implicit VR Little Endian, which is retired.
  @override
  bool get isEvr => false;

  @override
  int get vrCode => tag.vrCode;
  @override
  int get vrIndex => tag.vrIndex;


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

  static Null _sqError(ByteData bd, [int vrIndex]) =>
      invalidElementIndex(vrIndex);

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
    if (code != kPixelData)
      return invalidKey(code, 'Invalid Tag Code for PixelData');
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

class FLivr extends FL with Common, IvrElement<double>, Float32Mixin {
  @override
  final ByteData bd;

  FLivr(this.bd);

  @override
  Iterable<double> get values => Float32Base.fromByteData(vfByteData);

  static FLivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new FLivr(bd);
  }
}

class OFivr extends OF with Common, IvrElement<double>, Float32Mixin {
  @override
  final ByteData bd;

  OFivr(this.bd);

  @override
  int get valuesLength => _getValuesLength(vfLengthField, sizeInBytes);

  @override
  Iterable<double> get values => Float32Base.fromByteData(vfByteData);

  static OFivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OFivr(bd);
  }
}

// **** IVR 64-Bit Float Elements (OD, OF)

class FDivr extends FL with Common, IvrElement<double>, Float32Mixin {
  @override
  final ByteData bd;

  FDivr(this.bd);

  @override
  int get valuesLength => _getValuesLength(vfLengthField, sizeInBytes);

  @override
  Iterable<double> get values => Float64Base.fromByteData(vfByteData);

  static FDivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new FDivr(bd);
  }
}

class ODivr extends OD with Common, IvrElement<double>, Float32Mixin {
  @override
  final ByteData bd;

  ODivr(this.bd);

  @override
  Iterable<double> get values => Float64Base.fromByteData(vfByteData);

  static ODivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ODivr(bd);
  }
}

// **** Integer Elements

// **** 8-bit Integer Elements (OB, UN)

class OBivr extends OB with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final ByteData bd;

  OBivr(this.bd);

  @override
  Iterable<int> get values => Uint8Base.fromByteData(vfByteData);

  static OBivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OBivr(bd);
  }
}

class OBivrPixelData extends OBPixelData
    with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final ByteData bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBivrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => Uint8Base.fromByteData(vfByteData);

  static OBivrPixelData make(ByteData bd, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kFLIndex);
    return new OBivrPixelData(bd, ts, fragments);
  }
}

class UNivr extends UN with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final ByteData bd;

  UNivr(this.bd);

  @override
  Iterable<int> get values => Uint8Base.fromByteData(vfByteData);

  static UNivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new UNivr(bd);
  }
}

class UNivrPixelData extends UNPixelData
    with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final ByteData bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNivrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => Uint8Base.fromByteData(vfByteData);

  static UNivrPixelData make(ByteData bd, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kFLIndex);
    return new UNivrPixelData(bd, ts, fragments);
  }
}

// **** 16-bit Integer Elements (SS, US, OW)

class SSivr extends SS with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final ByteData bd;

  SSivr(this.bd);

  @override
  Iterable<int> get values => Int16Base.fromByteData(vfByteData);

  static SSivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new SSivr(bd);
  }
}

class USivr extends US with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final ByteData bd;

  USivr(this.bd);

  @override
  Iterable<int> get values => Uint16Base.fromByteData(vfByteData);

  static USivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new USivr(bd);
  }
}

class OWivr extends OW with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final ByteData bd;

  OWivr(this.bd);

  @override
  Iterable<int> get values => Uint16Base.fromByteData(vfByteData);

  static OWivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OWivr(bd);
  }
}

class OWivrPixelData extends OWPixelData
    with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final ByteData bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OWivrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => Uint16Base.fromByteData(vfByteData);

  static OWivrPixelData make(ByteData bd, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kOWIndex);
    return new OWivrPixelData(bd, ts, fragments);
  }
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

/// Attribute (Element) Code (AT)
class ATivr extends AT with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  ATivr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.fromByteData(vfByteData);

  static ATivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ATivr(bd);
  }
}

/// Other Long (OL)
class OLivr extends OL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  OLivr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.fromByteData(vfByteData);

  static OLivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OLivr(bd);
  }
}

/// Signed Long (SL)
class SLivr extends SL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  SLivr(this.bd);

  @override
  Iterable<int> get values => Int32Base.fromByteData(vfByteData);

  static SLivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new SLivr(bd);
  }
}

/// Unsigned Long (UL)
class ULivr extends UL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  ULivr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.fromByteData(vfByteData);

  static ULivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ULivr(bd);
  }
}

/// Group Length (GL)
class GLivr extends GL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final ByteData bd;

  GLivr(this.bd);

  @override
  Iterable<int> get values => Uint32Base.fromByteData(vfByteData);

  static const String kVRKeyword = 'GL';
  static const String kVRName = 'Group Length';

  static GLivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new GLivr(bd);
  }
}

// **** String Elements

class AEivr extends AE
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final ByteData bd;

  AEivr(this.bd);

  static AEivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new AEivr(_removePadding(bd));
  }
}

class ASivr extends AS
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final ByteData bd;

  ASivr(this.bd);

  static ASivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ASivr(bd);
  }
}

class CSivr extends CS
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final ByteData bd;

  CSivr(this.bd);

  static CSivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new CSivr(_removePadding(bd));
  }
}

class DAivr extends DA
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final ByteData bd;

  DAivr(this.bd);

  static DAivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new DAivr(bd);
  }
}

class DSivr extends DS
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final ByteData bd;

  DSivr(this.bd);

  static DSivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new DSivr(_removePadding(bd));
  }
}

class DTivr extends DT
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final ByteData bd;

  DTivr(this.bd);

  static DTivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new DTivr(_removePadding(bd));
  }
}

class ISivr extends IS
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final ByteData bd;

  ISivr(this.bd);

  static ISivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new ISivr(_removePadding(bd));
  }
}

class UIivr extends UI
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final ByteData bd;

  UIivr(this.bd);

  static UIivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd, kNull));
    return new UIivr(_removePadding(bd));
  }
}

class LOivr extends LO
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final ByteData bd;

  LOivr(this.bd);

  static LOivr make(ByteData bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kLOIndex);
    assert(checkPadding(bd));
    final v = _removePadding(bd);
    // Read code elt.
    final group = bd.getUint16(0, Endian.little);
    final elt = bd.getUint16(2, Endian.little);
    return (Tag.isPrivateGroup(group) && elt >= 0x10 && elt <= 0xFF)
           ? new PCivr(v)
           : new LOivr(v);
  }
}

class PCivr extends LO
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final ByteData bd;

  PCivr(this.bd);

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

  static PCivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new PCivr(_removePadding(bd));
  }
}

class PNivr extends PN
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final ByteData bd;

  PNivr(this.bd);

  static PNivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new PNivr(_removePadding(bd));
  }
}

class SHivr extends SH
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final ByteData bd;

  SHivr(this.bd);

  static SHivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new SHivr(_removePadding(bd));
  }
}

class LTivr extends LT
    with Common, IvrElement<String>, BDStringMixin, TextMixin {
  @override
  final ByteData bd;

  LTivr(this.bd);

  @override
  Iterable<String> get values => LT.fromByteData(vfByteData);
  static LTivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new LTivr(_removePadding(bd));
  }
}

class STivr extends ST
    with Common, IvrElement<String>, BDStringMixin, TextMixin {
  @override
  final ByteData bd;

  STivr(this.bd);

  static STivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new STivr(_removePadding(bd));
  }
}

class TMivr extends TM
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final ByteData bd;

  TMivr(this.bd);

  static TMivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new TMivr(_removePadding(bd));
  }
}

class UCivr extends UC
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final ByteData bd;

  UCivr(this.bd);

  static UCivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new UCivr(_removePadding(bd));
  }
}

class URivr extends UR
    with Common, IvrElement<String>, BDStringMixin, TextMixin {
  @override
  final ByteData bd;

  URivr(this.bd);

  static URivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new URivr(_removePadding(bd));
  }
}

class UTivr extends UT
    with Common, IvrElement<String>, BDStringMixin, TextMixin {
  @override
  final ByteData bd;

  UTivr(this.bd);

  static UTivr make(ByteData bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new UTivr(_removePadding(bd));
  }
}

class SQivr extends SQ<int>
    with Common, IvrElement<Item> {
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
