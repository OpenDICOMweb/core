// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/base.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/base/float.dart';
import 'package:core/src/element/byte_data/bd_element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

int _getValuesLength(int vfLengthField, int sizeInBytes) {
  final length = vfLengthField ~/ sizeInBytes;
  assert(vfLengthField >= 0 &&
      vfLengthField.isEven &&
      (vfLengthField % sizeInBytes == 0));
  return length;
}

const int _vfLengthOffset = 4;
const int _vfOffset = 8;

Bytes _removePadding(Bytes bd, [int padChar = kSpace]) =>
    removePadding(bd, _vfOffset, padChar);


abstract class IvrElement<V> implements BDElement<V> {
  @override
  Bytes get bd;
  @override
  int get vfLength;
  int get valuesLength;
  @override
  Iterable<V> get values;
  @override
  set values(Iterable<V> vList) => unsupportedError();
  bool isEqual(Element a, Element b);

  @override
  bool operator ==(Object other) =>
      (other is IvrElement && isEqual(this, other));

  @override
  int get hashCode => bd.hashCode;

  /// Returns _true_ if this Element is encoded as Explicit VR Little Endian;
  /// otherwise, it is encoded as Implicit VR Little Endian, which is retired.
  @override
  bool get isEvr => false;

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
  int get vfLengthField => bd.getUint16(_vfLengthOffset);

  @override
  Bytes get vfBytesWithPadding => new Bytes.view(bd, vfOffset);

  @override
  Bytes get vfBytes => new Bytes.view(bd, vfOffset);

  static Null _sqError(Bytes bd, [int vrIndex]) =>
      invalidElementIndex(vrIndex);

  static Element makeFromBytes(int code, Bytes bytes, int vrIndex) =>
      _ivrBDMakers[vrIndex](bytes, vrIndex);

  static final List<ElementFromBytes> _ivrBDMakers = <ElementFromBytes>[
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

  static Element makePixelData(int code, int vrIndex, Bytes bd,
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

  /// Returns a new [SQivr], where [bd] is [Bytes] for complete sequence.
  static SQivr makeSequence(
          int code, Bytes bd, Dataset parent, Iterable<Item> items) =>
      new SQivr(bd, parent, items);
}

// **** IVR Float Elements (FL, FD, OD, OF)

class FLivr extends FL with Common, IvrElement<double>, BDFloat32Mixin {
  @override
  final Bytes bd;

  FLivr(this.bd);

  @override
  Iterable<double> get values => Float32.fromBytes(vfBytes);

  static FLivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new FLivr(bd);
  }
}

class OFivr extends OF with Common, IvrElement<double>, BDFloat32Mixin {
  @override
  final Bytes bd;

  OFivr(this.bd);

  @override
  int get valuesLength => _getValuesLength(vfLengthField, sizeInBytes);

  @override
  Iterable<double> get values => Float32.fromBytes(vfBytes);

  static OFivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OFivr(bd);
  }
}

// **** IVR 64-Bit Float Elements (OD, OF)

class FDivr extends FL with Common, IvrElement<double>, BDFloat32Mixin {
  @override
  final Bytes bd;

  FDivr(this.bd);

  @override
  int get valuesLength => _getValuesLength(vfLengthField, sizeInBytes);

  @override
  Iterable<double> get values => bd.asFloat64List(vfOffset);

  static FDivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new FDivr(bd);
  }
}

class ODivr extends OD with Common, IvrElement<double>, BDFloat32Mixin {
  @override
  final Bytes bd;

  ODivr(this.bd);

  @override
  Iterable<double> get values => bd.asFloat64List(vfOffset);

  static ODivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ODivr(bd);
  }
}

// **** Integer Elements

// **** 8-bit Integer Elements (OB, UN)

class OBivr extends OB with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bd;

  OBivr(this.bd);

  @override
  Iterable<int> get values => bd.asUint8List(vfOffset);

  static OBivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OBivr(bd);
  }
}

class OBivrPixelData extends OBPixelData
    with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBivrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => bd.asUint8List(vfOffset);

  static OBivrPixelData make(Bytes bd, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kFLIndex);
    return new OBivrPixelData(bd, ts, fragments);
  }
}

class UNivr extends UN with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bd;

  UNivr(this.bd);

  @override
  Iterable<int> get values => bd.asUint8List(vfOffset);

  static UNivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new UNivr(bd);
  }
}

class UNivrPixelData extends UNPixelData
    with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNivrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => bd.asUint8List(vfOffset);

  static UNivrPixelData make(Bytes bd, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kFLIndex);
    return new UNivrPixelData(bd, ts, fragments);
  }
}

// **** 16-bit Integer Elements (SS, US, OW)

class SSivr extends SS with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bd;

  SSivr(this.bd);

  @override
  Iterable<int> get values => bd.asInt8List(vfOffset);

  static SSivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new SSivr(bd);
  }
}

class USivr extends US with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bd;

  USivr(this.bd);

  @override
  Iterable<int> get values => bd.asUint16List(vfOffset);

  static USivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new USivr(bd);
  }
}

class OWivr extends OW with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bd;

  OWivr(this.bd);

  @override
  Iterable<int> get values => bd.asUint16List(vfOffset);

  static OWivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OWivr(bd);
  }
}

class OWivrPixelData extends OWPixelData
    with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bd;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OWivrPixelData(this.bd, [this.ts, this.fragments]);

  @override
  Iterable<int> get values => bd.asUint16List(vfOffset);

  static OWivrPixelData make(Bytes bd, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kOWIndex);
    return new OWivrPixelData(bd, ts, fragments);
  }
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

/// Attribute (Element) Code (AT)
class ATivr extends AT with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bd;

  ATivr(this.bd);

  @override
  Iterable<int> get values => bd.asUint32List(vfOffset);

  static ATivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ATivr(bd);
  }
}

/// Other Long (OL)
class OLivr extends OL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bd;

  OLivr(this.bd);

  @override
  Iterable<int> get values => bd.asUint32List(vfOffset);

  static OLivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new OLivr(bd);
  }
}

/// Signed Long (SL)
class SLivr extends SL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bd;

  SLivr(this.bd);

  @override
  Iterable<int> get values => bd.asInt32List(vfOffset);

  static SLivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new SLivr(bd);
  }
}

/// Unsigned Long (UL)
class ULivr extends UL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bd;

  ULivr(this.bd);

  @override
  Iterable<int> get values =>bd.asUint32List(vfOffset);

  static ULivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ULivr(bd);
  }
}

/// Group Length (GL)
class GLivr extends GL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bd;

  GLivr(this.bd);

  @override
  Iterable<int> get values => bd.asUint32List(vfOffset);

  static const String kVRKeyword = 'GL';
  static const String kVRName = 'Group Length';

  static GLivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new GLivr(bd);
  }
}

// **** String Elements

class AEivr extends AE
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final Bytes bd;

  AEivr(this.bd);

  static AEivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new AEivr(_removePadding(bd));
  }
}

class ASivr extends AS
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final Bytes bd;

  ASivr(this.bd);

  static ASivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new ASivr(bd);
  }
}

class CSivr extends CS
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final Bytes bd;

  CSivr(this.bd);

  static CSivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new CSivr(_removePadding(bd));
  }
}

class DAivr extends DA
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final Bytes bd;

  DAivr(this.bd);

  static DAivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new DAivr(bd);
  }
}

class DSivr extends DS
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final Bytes bd;

  DSivr(this.bd);

  static DSivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new DSivr(_removePadding(bd));
  }
}

class DTivr extends DT
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final Bytes bd;

  DTivr(this.bd);

  static DTivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new DTivr(_removePadding(bd));
  }
}

class ISivr extends IS
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final Bytes bd;

  ISivr(this.bd);

  static ISivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new ISivr(_removePadding(bd));
  }
}

class UIivr extends UI
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final Bytes bd;

  UIivr(this.bd);

  static UIivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd, kNull));
    return new UIivr(_removePadding(bd));
  }
}

class LOivr extends LO
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final Bytes bd;

  LOivr(this.bd);

  static LOivr make(Bytes bd, int vrIndex) {
    assert(vrIndex != null && vrIndex == kLOIndex);
    assert(checkPadding(bd));
    final v = _removePadding(bd);
    // Read code elt.
    final group = bd.getUint16(0);
    final elt = bd.getUint16(2);
    return (Tag.isPrivateGroup(group) && elt >= 0x10 && elt <= 0xFF)
           ? new PCivr(v)
           : new LOivr(v);
  }
}

class PCivr extends LO
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final Bytes bd;

  PCivr(this.bd);

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

  static PCivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new PCivr(_removePadding(bd));
  }
}

class PNivr extends PN
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final Bytes bd;

  PNivr(this.bd);

  static PNivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new PNivr(_removePadding(bd));
  }
}

class SHivr extends SH
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final Bytes bd;

  SHivr(this.bd);

  static SHivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new SHivr(_removePadding(bd));
  }
}

class LTivr extends LT
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final Bytes bd;

  LTivr(this.bd);

  @override
  Iterable<String> get values => LT.fromBytes(vfBytes);
  static LTivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new LTivr(_removePadding(bd));
  }
}

class STivr extends ST
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final Bytes bd;

  STivr(this.bd);

  static STivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new STivr(_removePadding(bd));
  }
}

class TMivr extends TM
    with Common, IvrElement<String>, BDStringMixin, AsciiMixin {
  @override
  final Bytes bd;

  TMivr(this.bd);

  static TMivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new TMivr(_removePadding(bd));
  }
}

class UCivr extends UC
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final Bytes bd;

  UCivr(this.bd);

  static UCivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new UCivr(_removePadding(bd));
  }
}

class URivr extends UR
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final Bytes bd;

  URivr(this.bd);

  static URivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new URivr(_removePadding(bd));
  }
}

class UTivr extends UT
    with Common, IvrElement<String>, BDStringMixin, Utf8Mixin {
  @override
  final Bytes bd;

  UTivr(this.bd);

  static UTivr make(Bytes bd, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    assert(checkPadding(bd));
    return new UTivr(_removePadding(bd));
  }
}

class SQivr extends SQ<int>
    with Common, IvrElement<Item> {
  @override
  final Bytes bd;
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

  static SQivr make(Bytes bd, Dataset parent, Iterable<Item> values) =>
      new SQivr(bd, parent, values);
}
