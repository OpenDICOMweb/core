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
import 'package:core/src/element/base/float.dart';
import 'package:core/src/element/bytes/byte_element.dart';
import 'package:core/src/system.dart';
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

Bytes _removePadding(Bytes bytes, [int padChar = kSpace]) =>
    removePadding(bytes, _vfOffset, padChar);

abstract class IvrElement<V> implements ByteElement<V> {
  @override
  Bytes get bytes;
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
  int get hashCode => system.hasher.intList(bytes);

  /// Returns _true_ if this Element is encoded as Explicit VR Little Endian;
  /// otherwise, it is encoded as Implicit VR Little Endian, which is retired.
  @override
  bool get isEvr => false;
  @override
  Tag get tag => Tag.lookupByCode(code);
  @override
  int get vrCode => tag.vrCode;
  @override
  int get vrIndex {
    final vrIndex = tag.vrIndex;
    if (isSpecialVRIndex(vrIndex)) {
      log.debug('Using kUNIndex for $tag');
      return kUNIndex;
    }
    return vrIndex;
  }

  @override
  int get vfLengthOffset => _vfLengthOffset;
  @override
  int get vfOffset => _vfOffset;

  /// Returns the Value Field Length field.
  @override
  int get vfLengthField => bytes.getUint32(_vfLengthOffset);

  @override
  Bytes get vfBytesWithPadding =>
      bytes.toBytes(bytes.offsetInBytes + vfOffset, vfLength);

  @override
  Bytes get vfBytes => bytes.toBytes(bytes.offsetInBytes + vfOffset, vfLength);

  static Null _sqError(Bytes bytes, [int vrIndex]) =>
      invalidElementIndex(vrIndex);

  static Element makeFromBytes(int code, Bytes bytes, int vrIndex) =>
      _ivrBDMakers[vrIndex](bytes, vrIndex);

  static final List<DecodeBinaryVF> _ivrBDMakers = <DecodeBinaryVF>[
    _sqError, // stop reformat
    // Maybe Undefined Lengths
    OBivr.make, OWivr.make, UNivr.make,

    // IVR Long
    ODivr.make, OFivr.make, OLivr.make,
    UCivr.make, URivr.make, UTivr.make,

    // IVR Short
    AEivr.make, ASivr.make, ATivr.make,
    CSivr.make, DAivr.make, DSivr.make,
    DTivr.make, FDivr.make, FLivr.make,
    ISivr.make, LOivr.make, LTivr.make,
    PNivr.make, SHivr.make, SLivr.make,
    SSivr.make, STivr.make, TMivr.make,
    UIivr.make, ULivr.make, USivr.make,
  ];

  static Element makePixelData(int code, Bytes bytes, int vrIndex,
      [int vfLengthField, TransferSyntax ts, VFFragments fragments]) {
    if (code != kPixelData)
      return invalidKey(code, 'Invalid Tag Code for PixelData');
    switch (vrIndex) {
      case kOBIndex:
        return OBivrPixelData.make(bytes, vrIndex, ts, fragments);
      case kUNIndex:
        return UNivrPixelData.make(bytes, vrIndex, ts, fragments);
      case kOWIndex:
        return OWivrPixelData.make(bytes, vrIndex, ts, fragments);
      default:
        return invalidVRIndex(vrIndex, null, null);
    }
  }

  /// Returns a new [SQivr], where [bytes] is [Bytes] for complete sequence.
  static SQivr makeSequenceFromCode(
          int code, Dataset parent, Iterable<Item> items,
          [Bytes bytes]) =>
      new SQivr(bytes, parent, items);

  /// Returns a new [SQivr], where [bytes] is [Bytes] for complete sequence.
  static SQivr makeSequenceFromTag(
    Tag tag,
    Dataset parent,
    Iterable<Item> items, [
    Bytes bytes,
  ]) =>
      unsupportedError();
}

// **** IVR Float Elements (FL, FD, OD, OF)

class FLivr extends FL with Common, IvrElement<double>, BDFloat32Mixin {
  @override
  final Bytes bytes;

  FLivr(this.bytes);

  @override
  Float32List get values => vfBytes.asFloat32List();

  static FLivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFLIndex);
    return new FLivr(bytes);
  }
}

class OFivr extends OF with Common, IvrElement<double>, BDFloat32Mixin {
  @override
  final Bytes bytes;

  OFivr(this.bytes);

  @override
  int get valuesLength => _getValuesLength(vfLengthField, sizeInBytes);

  @override
  Float32List get values => vfBytes.asFloat32List();

  static OFivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kOFIndex);
    return new OFivr(bytes);
  }
}

// **** IVR 64-Bit Float Elements (OD, OF)

class FDivr extends FL with Common, IvrElement<double>, BDFloat32Mixin {
  @override
  final Bytes bytes;

  FDivr(this.bytes);

  @override
  int get valuesLength => _getValuesLength(vfLengthField, sizeInBytes);

  @override
  Float64List get values => vfBytes.asFloat64List();

  static FDivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kFDIndex);
    return new FDivr(bytes);
  }
}

class ODivr extends OD with Common, IvrElement<double>, BDFloat32Mixin {
  @override
  final Bytes bytes;

  ODivr(this.bytes);

  @override
  Float64List get values => vfBytes.asFloat64List();

  static ODivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kODIndex);
    return new ODivr(bytes);
  }
}

// **** Integer Elements

// **** 8-bit Integer Elements (OB, UN)

class OBivr extends OB with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bytes;

  OBivr(this.bytes);

  @override
  Uint8List get values => vfBytes.asUint8List();

  static OBivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kOBIndex);
    return new OBivr(bytes);
  }
}

class OBivrPixelData extends OBPixelData
    with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBivrPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  Uint8List get values => vfBytes.asUint8List();

  static OBivrPixelData make(Bytes bytes, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kOBIndex);
    return new OBivrPixelData(bytes, ts, fragments);
  }
}

class UNivr extends UN with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bytes;

  UNivr(this.bytes);

  @override
  Uint8List get values => vfBytes.asUint8List();

  static UNivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kUNIndex);
    return new UNivr(bytes);
  }
}

class UNivrPixelData extends UNPixelData
    with Common, IvrElement<int>, IntMixin, Int8Mixin {
  @override
  final Bytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNivrPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  Uint8List get values => vfBytes.asUint8List();

  static UNivrPixelData make(Bytes bytes, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kUNIndex);
    return new UNivrPixelData(bytes, ts, fragments);
  }
}

// **** 16-bit Integer Elements (SS, US, OW)

class SSivr extends SS with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bytes;

  SSivr(this.bytes);

  @override
  Int16List get values => vfBytes.asInt16List();

  static SSivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kSSIndex);
    return new SSivr(bytes);
  }
}

class USivr extends US with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bytes;

  USivr(this.bytes);

  @override
  Uint16List get values => vfBytes.asUint16List();

  static USivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kUSIndex);
    return new USivr(bytes);
  }
}

class OWivr extends OW with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bytes;

  OWivr(this.bytes);

  @override
  Uint16List get values => vfBytes.asUint16List();

  static OWivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kOWIndex);
    return new OWivr(bytes);
  }
}

class OWivrPixelData extends OWPixelData
    with Common, IvrElement<int>, IntMixin, Int16Mixin {
  @override
  final Bytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OWivrPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  Uint16List get values => vfBytes.asUint16List();

  static OWivrPixelData make(Bytes bytes, int vrIndex,
      [TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex != null || vrIndex == kOWIndex);
    return new OWivrPixelData(bytes, ts, fragments);
  }
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

/// Attribute (Element) Code (AT)
class ATivr extends AT with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bytes;

  ATivr(this.bytes);

  @override
  Uint32List get values => vfBytes.asUint32List();

  static ATivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kATIndex);
    return new ATivr(bytes);
  }
}

/// Other Long (OL)
class OLivr extends OL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bytes;

  OLivr(this.bytes);

  @override
  Uint32List get values => vfBytes.asUint32List();

  static OLivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kOLIndex);
    return new OLivr(bytes);
  }
}

/// Signed Long (SL)
class SLivr extends SL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bytes;

  SLivr(this.bytes);

  @override
  Int32List get values => vfBytes.asInt32List();

  static SLivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kSLIndex);
    return new SLivr(bytes);
  }
}

/// Unsigned Long (UL)
class ULivr extends UL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bytes;

  ULivr(this.bytes);

  @override
  Uint32List get values => vfBytes.asUint32List();

  static ULivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kULIndex);
    return new ULivr(bytes);
  }
}

/// Group Length (GL)
class GLivr extends GL with Common, IvrElement<int>, IntMixin, Int32Mixin {
  @override
  final Bytes bytes;

  GLivr(this.bytes);

  @override
  Uint32List get values => vfBytes.asUint32List();

  static const String kVRKeyword = 'GL';
  static const String kVRName = 'Group Length';

  static GLivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kULIndex);
    return new GLivr(bytes);
  }
}

// **** String Elements

class AEivr extends AE
    with Common, IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final Bytes bytes;

  AEivr(this.bytes);

  static AEivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kAEIndex);

    return new AEivr(_removePadding(bytes));
  }
}

class ASivr extends AS
    with Common, IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final Bytes bytes;

  ASivr(this.bytes);

  static ASivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kASIndex);
    return new ASivr(bytes);
  }
}

class CSivr extends CS
    with Common, IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final Bytes bytes;

  CSivr(this.bytes);

  static CSivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kCSIndex);
    return new CSivr(_removePadding(bytes));
  }
}

class DAivr extends DA
    with Common, IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final Bytes bytes;

  DAivr(this.bytes);

  static DAivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kDAIndex);
    return new DAivr(bytes);
  }
}

class DSivr extends DS
    with Common, IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final Bytes bytes;

  DSivr(this.bytes);

  static DSivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kDSIndex);
    return new DSivr(_removePadding(bytes));
  }
}

class DTivr extends DT
    with Common, IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final Bytes bytes;

  DTivr(this.bytes);

  static DTivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kDTIndex);
    return new DTivr(_removePadding(bytes));
  }
}

class ISivr extends IS
    with Common, IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final Bytes bytes;

  ISivr(this.bytes);

  static ISivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kISIndex);
    return new ISivr(_removePadding(bytes));
  }
}

class UIivr extends UI
    with Common, IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final Bytes bytes;

  UIivr(this.bytes);

  static UIivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kUIIndex);
    return new UIivr(_removePadding(bytes));
  }
}

class LOivr extends LO
    with Common, IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final Bytes bytes;

  LOivr(this.bytes);

  static LOivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex != null && vrIndex == kLOIndex);
    final v = _removePadding(bytes);
    // Read code elt.
    final group = bytes.getUint16(0);
    final elt = bytes.getUint16(2);
    return (Tag.isPrivateGroup(group) && elt >= 0x10 && elt <= 0xFF)
        ? new PCivr(v)
        : new LOivr(v);
  }
}

class PCivr extends LOivr
    with Common, IvrElement<String>, ByteStringMixin, Utf8Mixin {
  PCivr(Bytes bytes) : super(bytes);

  @override
  String get vrKeyword => PC.kVRKeyword;
  @override
  String get vrName => PC.kVRKeyword;
  @override
  String get name => 'Private Creator - $id';

  int get sgNumber => code & 0xFF;

  /// Returns a [PCTag].
  @override
  Tag get tag {
    if (Tag.isPCCode(code)) {
      final token = vfBytesAsUtf8;
      final tag = Tag.lookupByCode(code, kLOIndex, token);
      return tag;
    }
    return invalidKey(code, 'Invalid Tag Code ${toDcm(code)}');
  }

  String get id => vfBytesAsAscii;

  static PCivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kLOIndex);
    return new PCivr(_removePadding(bytes));
  }

  static PCivr makeEmptyPrivateCreator(int pdTag, int vrIndex) {
    final group = Tag.privateGroup(pdTag);
    final sgNumber = (pdTag & 0xFFFF) >> 8;
    final bytes = new Bytes(8)
      ..setUint16(0, group)
      ..setUint16(0, sgNumber)
      ..setUint16(4, kLOIndex)
      //     ..setUint8(5, kO)
      ..setUint16(6, 0);
    return new PCivr(bytes);
  }
}

class PNivr extends PN
    with Common, IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final Bytes bytes;

  PNivr(this.bytes);

  static PNivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kPNIndex);
    return new PNivr(_removePadding(bytes));
  }
}

class SHivr extends SH
    with Common, IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final Bytes bytes;

  SHivr(this.bytes);
  static SHivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kSHIndex);

    return new SHivr(_removePadding(bytes));
  }
}

class LTivr extends LT
    with Common, IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final Bytes bytes;

  LTivr(this.bytes);

  @override
  List<String> get values => [vfBytes.getUtf8()];
  static LTivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kLTIndex);
    return new LTivr(_removePadding(bytes));
  }
}

class STivr extends ST
    with Common, IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final Bytes bytes;

  STivr(this.bytes);

  static STivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kSTIndex);
    return new STivr(_removePadding(bytes));
  }
}

class TMivr extends TM
    with Common, IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final Bytes bytes;

  TMivr(this.bytes);

  static TMivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kTMIndex || vrIndex == kUNIndex,
        'vrIndex: $vrIndex');
    return new TMivr(_removePadding(bytes));
  }
}

class UCivr extends UC
    with Common, IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final Bytes bytes;

  UCivr(this.bytes);

  static UCivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kUCIndex);
    return new UCivr(_removePadding(bytes));
  }
}

class URivr extends UR
    with Common, IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final Bytes bytes;

  URivr(this.bytes);

  static URivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kURIndex);
    return new URivr(_removePadding(bytes));
  }
}

class UTivr extends UT
    with Common, IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final Bytes bytes;

  UTivr(this.bytes);

  static UTivr make(Bytes bytes, int vrIndex) {
    assert(vrIndex == null || vrIndex == kUTIndex);
    return new UTivr(_removePadding(bytes));
  }
}

class SQivr extends SQ<int> with Common, IvrElement<Item> {
  @override
  final Bytes bytes;
  @override
  final Dataset parent;
  @override
  final Iterable<Item> values;

  SQivr(this.bytes, this.parent, this.values);

  @override
  int get valuesLength => values.length;

  @override
  SQ update([Iterable<Item> vList]) => unsupportedError();
  @override
  SQ updateF(Iterable<Item> f(Iterable<Item> vList)) => unsupportedError();

  static SQivr make(Bytes bytes, Dataset parent, Iterable<Item> values) =>
      new SQivr(bytes, parent, values);
}
