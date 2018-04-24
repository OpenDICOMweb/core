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
import 'package:core/src/element/bytes/byte_element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/bytes/bytes.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

abstract class IvrElement<V> implements ByteElement<V> {
  @override
  IvrBytes get bytes;
  @override
  Iterable<V> get values;
  // **** End of Interface

  @override
  set values(Iterable<V> vList) =>
      unsupportedError('ByteElements are not settable.');

  /// Returns _true_ if _this_ and [other] are the same [IvrElement] and
  /// equal byte for byte.
  @override
  bool operator ==(Object other) =>
      (other is IvrElement) ? bytes == other.bytes : false;
  @override
  int get hashCode => bytes.hashCode;
  @override
  bool get isEvr => false;

  /// _Note_: Because this relies on [tag], the [vrCode] might be UN
  ///         more often than for EVR Elements.
  @override
  int get vrCode => tag.vrCode;

  @override
  Bytes get vfBytes => bytes.vfBytes;
  @override
  Bytes get vfBytesWithPadding => bytes.vfBytesWithPadding;

  static Element makeFromCode(Dataset ds, int code, Bytes bytes, int vrIndex) {
    assert(vrIndex != kSQIndex);
    final pCode = code & 0x1FFFF;
    if (pCode >= 0x10010 && pCode <= 0x100FF) return new PCivr(bytes);
    final tag = lookupTagByCode(ds, code, vrIndex);
    final tagVRIndex = tag.vrIndex;
    final e = _ivrBDMakers[vrIndex](bytes, tagVRIndex);
    return (pCode >= 0x11000 && pCode <= 0x1FFFF) ? new PrivateData(e) : e;
  }

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

  static Null _sqError(Bytes bytes, [int vrIndex]) =>
      invalidElementIndex(vrIndex);

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
      new SQivr(parent, items, bytes);

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

class FLivr extends FL with IvrElement<double>, Float32Mixin {
  @override
  final IvrBytes bytes;

  FLivr(this.bytes);

  static FLivr make(Bytes bytes, int vrIndex) => new FLivr(bytes);
}

class OFivr extends OF with IvrElement<double>, Float32Mixin {
  @override
  final IvrBytes bytes;

  OFivr(this.bytes);

  static OFivr make(Bytes bytes, int vrIndex) => new OFivr(bytes);
}

// **** IVR 64-Bit Float Elements (OD, OF)

class FDivr extends FL with IvrElement<double>, Float64Mixin {
  @override
  final IvrBytes bytes;

  FDivr(this.bytes);

  static FDivr make(Bytes bytes, int vrIndex) => new FDivr(bytes);
}

class ODivr extends OD with IvrElement<double>, Float64Mixin {
  @override
  final IvrBytes bytes;

  ODivr(this.bytes);

  static ODivr make(Bytes bytes, int vrIndex) => new ODivr(bytes);
}

// **** Integer Elements

// **** 8-bit Integer Elements (OB, UN)

class OBivr extends OB with IvrElement<int>, Uint8Mixin {
  @override
  final IvrBytes bytes;

  OBivr(this.bytes);

  static OBivr make(Bytes bytes, int vrIndex) => new OBivr(bytes);
}

class OBivrPixelData extends OBPixelData
    with IvrElement<int>, Uint8Mixin {
  @override
  final IvrBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBivrPixelData(this.bytes, [this.ts, this.fragments]);

  static OBivrPixelData make(Bytes bytes, int vrIndex,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OBivrPixelData(bytes, ts, fragments);
}

class UNivr extends UN with IvrElement<int>, Uint8Mixin {
  @override
  final IvrBytes bytes;

  UNivr(this.bytes);

  @override
  Uint8List get values => vfBytes.asUint8List();

  static UNivr make(Bytes bytes, int vrIndex) => new UNivr(bytes);
}

class UNivrPixelData extends UNPixelData
    with IvrElement<int>, Uint8Mixin {
  @override
  final IvrBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNivrPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  Uint8List get values => vfBytes.asUint8List();

  static UNivrPixelData make(Bytes bytes, int vrIndex,
          [TransferSyntax ts, VFFragments fragments]) =>
      new UNivrPixelData(bytes, ts, fragments);
}

// **** 16-bit Integer Elements (SS, US, OW)

class SSivr extends SS with IvrElement<int>, Int16Mixin {
  @override
  final IvrBytes bytes;

  SSivr(this.bytes);

  static SSivr make(Bytes bytes, int vrIndex) => new SSivr(bytes);
}

class USivr extends US with IvrElement<int>, Uint16Mixin {
  @override
  final IvrBytes bytes;

  USivr(this.bytes);

  static USivr make(Bytes bytes, int vrIndex) => new USivr(bytes);
}

class OWivr extends OW with IvrElement<int>, Uint16Mixin {
  @override
  final IvrBytes bytes;

  OWivr(this.bytes);

  static OWivr make(Bytes bytes, int vrIndex) => new OWivr(bytes);
}

class OWivrPixelData extends OWPixelData
    with IvrElement<int>, Uint16Mixin {
  @override
  final IvrBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OWivrPixelData(this.bytes, [this.ts, this.fragments]);

  static OWivrPixelData make(Bytes bytes, int vrIndex,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OWivrPixelData(bytes, ts, fragments);
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

/// Attribute (Element) Code (AT)
class ATivr extends AT with IvrElement<int>, Uint32Mixin {
  @override
  final IvrBytes bytes;

  ATivr(this.bytes);

  static ATivr make(Bytes bytes, int vrIndex) => new ATivr(bytes);
}

/// Other Long (OL)
class OLivr extends OL with IvrElement<int>, Uint32Mixin {
  @override
  final IvrBytes bytes;

  OLivr(this.bytes);

  static OLivr make(Bytes bytes, int vrIndex) => new OLivr(bytes);
}

/// Signed Long (SL)
class SLivr extends SL with IvrElement<int>, Int32Mixin {
  @override
  final IvrBytes bytes;

  SLivr(this.bytes);

  static SLivr make(Bytes bytes, int vrIndex) => new SLivr(bytes);
}

/// Unsigned Long (UL)
class ULivr extends UL with IvrElement<int>, Uint32Mixin {
  @override
  final IvrBytes bytes;

  ULivr(this.bytes);

  static ULivr make(Bytes bytes, int vrIndex) => new ULivr(bytes);
}

/// Group Length (GL)
class GLivr extends GL with IvrElement<int>, Uint32Mixin {
  @override
  final IvrBytes bytes;

  GLivr(this.bytes);

  static const String kVRKeyword = 'GL';
  static const String kVRName = 'Group Length';

  static GLivr make(Bytes bytes, int vrIndex) => new GLivr(bytes);
}

// **** String Elements

class AEivr extends AE with IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final IvrBytes bytes;

  AEivr(this.bytes);

  static AEivr make(Bytes bytes, int vrIndex) => new AEivr(bytes);
}

class ASivr extends AS with IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final IvrBytes bytes;

  ASivr(this.bytes);

  static ASivr make(Bytes bytes, int vrIndex) => new ASivr(bytes);
}

class CSivr extends CS with IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final IvrBytes bytes;

  CSivr(this.bytes);

  static CSivr make(Bytes bytes, int vrIndex) => new CSivr(bytes);
}

class DAivr extends DA with IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final IvrBytes bytes;

  DAivr(this.bytes);

  static DAivr make(Bytes bytes, int vrIndex) => new DAivr(bytes);
}

class DSivr extends DS with IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final IvrBytes bytes;

  DSivr(this.bytes);

  static DSivr make(Bytes bytes, int vrIndex) => new DSivr(bytes);
}

class DTivr extends DT with IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final IvrBytes bytes;

  DTivr(this.bytes);

  static DTivr make(Bytes bytes, int vrIndex) => new DTivr(bytes);
}

class ISivr extends IS with IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final IvrBytes bytes;

  ISivr(this.bytes);

  static ISivr make(Bytes bytes, int vrIndex) => new ISivr(bytes);
}

class UIivr extends UI with IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final IvrBytes bytes;

  UIivr(this.bytes);

  static UIivr make(Bytes bytes, int vrIndex) => new UIivr(bytes);
}

class LOivr extends LO with IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final IvrBytes bytes;

  LOivr(this.bytes);

  static LOivr make(Bytes bytes, int vrIndex) {
    final group = bytes.getUint16(0);
    final elt = bytes.getUint16(2);
    return (group.isOdd && elt >= 0x10 && elt <= 0xFF)
        ? new PCivr(bytes)
        : new LOivr(bytes);
  }
}

class PCivr extends PC with IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final IvrBytes bytes;

  PCivr(this.bytes);

  @override
  String get token => vfString;

  static PCivr make(Bytes bytes, int vrIndex) => new PCivr(bytes);

  // Urgent: remove when working
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

class PNivr extends PN with IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final IvrBytes bytes;

  PNivr(this.bytes);

  static PNivr make(Bytes bytes, int vrIndex) => new PNivr(bytes);
}

class SHivr extends SH with IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final IvrBytes bytes;

  SHivr(this.bytes);
  static SHivr make(Bytes bytes, int vrIndex) => new SHivr(bytes);
}

class LTivr extends LT with IvrElement<String>, ByteStringMixin, TextMixin {
  @override
  final IvrBytes bytes;

  LTivr(this.bytes);

  static LTivr make(Bytes bytes, int vrIndex) => new LTivr(bytes);
}

class STivr extends ST with IvrElement<String>, ByteStringMixin, TextMixin {
  @override
  final IvrBytes bytes;

  STivr(this.bytes);

  static STivr make(Bytes bytes, int vrIndex) => new STivr(bytes);
}

class TMivr extends TM with IvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final IvrBytes bytes;

  TMivr(this.bytes);

  static TMivr make(Bytes bytes, int vrIndex) => new TMivr(bytes);
}

class UCivr extends UC with IvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final IvrBytes bytes;

  UCivr(this.bytes);

  static UCivr make(Bytes bytes, int vrIndex) => new UCivr(bytes);
}

class URivr extends UR with IvrElement<String>, ByteStringMixin, TextMixin {
  @override
  final IvrBytes bytes;

  URivr(this.bytes);

  static URivr make(Bytes bytes, int vrIndex) => new URivr(bytes);
}

class UTivr extends UT with IvrElement<String>, ByteStringMixin, TextMixin {
  @override
  final IvrBytes bytes;

  UTivr(this.bytes);

  static UTivr make(Bytes bytes, int vrIndex) => new UTivr(bytes);
}

class SQivr extends SQ with IvrElement<Item> {
  @override
  final Dataset parent;
  @override
  Iterable<Item> values;
  @override
  final IvrBytes bytes;

  SQivr(this.parent, this.values, this.bytes);

  @override
  int get valuesLength => values.length;

  static SQivr make(Dataset parent, Iterable<Item> values, Bytes bytes) =>
      new SQivr(parent, values, bytes);
}
