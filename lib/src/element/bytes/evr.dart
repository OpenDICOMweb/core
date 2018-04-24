//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//


import 'package:core/src/base.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/bytes/byte_element.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

abstract class EvrElement<V> implements ByteElement<V> {
  @override
  EvrBytes get bytes;
  @override
  Iterable<V> get values;
  // **** End of Interface

  @override
  set values(Iterable<V> vList) =>
      unsupportedError('ByteElements are not settable.');

  /// Returns _true_ if _this_ and [other] are the same [EvrElement], and
  /// equal byte for byte.
  @override
  bool operator ==(Object other) =>
      (other is EvrElement) ? bytes == other.bytes : false;
  @override
  int get hashCode => bytes.hashCode;
  @override
  bool get isEvr => true;
  @override
  int get vrCode => bytes.vrCode;
  @override
  Bytes get vfBytes => bytes.vfBytes;
  @override
  Bytes get vfBytesWithPadding => bytes.vfBytesWithPadding;

  static Element makeFromCode(Dataset ds, int code, Bytes bytes, int vrIndex) {
    assert(vrIndex != kSQIndex);
    final pCode = code & 0x1FFFF;
    if (pCode >= 0x10010 && pCode <= 0x100FF) return new PCevr(bytes);

    final tag = lookupTagByCode(ds, code, vrIndex);
    final tagVRIndex = tag.vrIndex;
    final e = _evrBDMakers[vrIndex](bytes, tagVRIndex);
    return (pCode >= 0x11000 && pCode <= 0x1FFFF) ? new PrivateData(e) : e;
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




class FLevr extends FL with EvrElement<double>, Float32Mixin {
  @override
  final EvrShortBytes bytes;

  FLevr(this.bytes);

  static FLevr make(Bytes bytes, int vrIndex) => new FLevr(bytes);
}

class OFevr extends OF with EvrElement<double>, Float32Mixin {
  @override
  final EvrLongBytes bytes;

  OFevr(this.bytes);

  static OFevr make(Bytes bytes, int vrIndex) => new OFevr(bytes);
}

class FDevr extends FD with EvrElement<double>, Float64Mixin {
  @override
  final EvrShortBytes bytes;

  FDevr(this.bytes);

  static FDevr make(Bytes bytes, int vrIndex) => new FDevr(bytes);
}

class ODevr extends OD with EvrElement<double>, Float64Mixin {
  @override
  final EvrLongBytes bytes;

  ODevr(this.bytes);

  static ODevr make(Bytes bytes, int vrIndex) => new ODevr(bytes);
}

// **** Integer Elements

class OBevr extends OB with EvrElement<int>, Uint8Mixin {
  @override
  final EvrLongBytes bytes;

  OBevr(this.bytes);

  static OBevr make(Bytes bytes, int vrIndex) => new OBevr(bytes);
}

class OBevrPixelData extends OBPixelData
    with EvrElement<int>, Uint8Mixin {
  @override
  final EvrLongBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBevrPixelData(this.bytes, [this.ts, this.fragments]);

  static OBevrPixelData make(int code, int vrIndex, Bytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OBevrPixelData(bytes, ts, fragments);
}

class UNevr extends UN with EvrElement<int>, Uint8Mixin {
  @override
  final EvrLongBytes bytes;

  UNevr(this.bytes);

  static UNevr make(Bytes bytes, int vrIndex) => new UNevr(bytes);
}

class UNevrPixelData extends UNPixelData
    with EvrElement<int>, Uint8Mixin {
  @override
  final EvrLongBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNevrPixelData(this.bytes, [this.ts, this.fragments]);

  static UNevrPixelData make(int code, int vrIndex, Bytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new UNevrPixelData(bytes, ts, fragments);
}

class SSevr extends SS with EvrElement<int>, Int16Mixin {
  @override
  final EvrShortBytes bytes;

  SSevr(this.bytes);

  static SSevr make(Bytes bytes, int vrIndex) => new SSevr(bytes);
}

class USevr extends US with EvrElement<int>, Uint16Mixin {
  @override
  final EvrShortBytes bytes;

  USevr(this.bytes);

  static USevr make(Bytes bytes, int vrIndex) => new USevr(bytes);
}

class OWevr extends OW with EvrElement<int>, Uint16Mixin {
  @override
  final EvrLongBytes bytes;

  OWevr(this.bytes);

  static OWevr make(Bytes bytes, int vrIndex) => new OWevr(bytes);
}

class OWevrPixelData extends OWPixelData
    with EvrElement<int>, Uint16Mixin {
  @override
  final EvrLongBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OWevrPixelData(this.bytes, [this.ts, this.fragments]);

  static OWevrPixelData make(int code, int vrIndex, Bytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OWevrPixelData(bytes, ts, fragments);
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

/// Attribute (Element) Code (AT)
class ATevr extends AT with EvrElement<int>, Uint32Mixin {
  @override
  final EvrShortBytes bytes;

  ATevr(this.bytes);

  static ATevr make(Bytes bytes, int vrIndex) => new ATevr(bytes);
}

/// Other Long (OL)
class OLevr extends OL with EvrElement<int>, Uint32Mixin {
  @override
  final EvrLongBytes bytes;

  OLevr(this.bytes);

  static OLevr make(Bytes bytes, int vrIndex) => new OLevr(bytes);
}

/// Signed Long (SL)
class SLevr extends SL with EvrElement<int>, Int32Mixin {
  @override
  final EvrShortBytes bytes;

  SLevr(this.bytes);

  static SLevr make(Bytes bytes, int vrIndex) => new SLevr(bytes);
}

/// Unsigned Long (UL)
class ULevr extends UL with EvrElement<int>, Uint32Mixin {
  @override
  final EvrShortBytes bytes;

  ULevr(this.bytes);

  static Element<int> make(Bytes bytes, int vrIndex) =>
      // If the code is (gggg,0000) create a Group Length element
      (bytes.getUint16(2) == 0) ? new GLevr(bytes) : new ULevr(bytes);
}

/// Group Length (GL)
class GLevr extends GL with EvrElement<int>, Uint32Mixin {
  @override
  final EvrShortBytes bytes;

  GLevr(this.bytes);

  static GLevr make(Bytes bytes, int vrIndex) => new GLevr(bytes);
}

// **** String Elements

class AEevr extends AE with EvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  AEevr(this.bytes);

  static AEevr make(Bytes bytes, int vrIndex) => new AEevr(bytes);
}

class ASevr extends AS with EvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  ASevr(this.bytes);

  static ASevr make(Bytes bytes, int vrIndex) {
    final length = bytes.length;
    if (length != 12 && length != 8)
      log.warn('Invalid Age (AS) "${bytes.getUtf8()}"');
    return new ASevr(bytes);
  }
}

class CSevr extends CS with EvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  CSevr(this.bytes);

  static CSevr make(Bytes bytes, int vrIndex) => new CSevr(bytes);
}

class DAevr extends DA with EvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  DAevr(this.bytes);

  static DAevr make(Bytes bytes, int vrIndex) {
    final length = bytes.length;
    if (length != 16 && length != 8)
      log.debug('Invalid Date (DA) "${bytes.getUtf8()}"');
    return new DAevr(bytes);
  }
}

class DSevr extends DS with EvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  DSevr(this.bytes);

  static DSevr make(Bytes bytes, int vrIndex) => new DSevr(bytes);
}

class DTevr extends DT with EvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  DTevr(this.bytes);

  static DTevr make(Bytes bytes, int vrIndex) => new DTevr(bytes);
}

class ISevr extends IS with EvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  ISevr(this.bytes);

  static ISevr make(Bytes bytes, int vrIndex) => new ISevr(bytes);
}

class UIevr extends UI with EvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  UIevr(this.bytes);

  static UIevr make(Bytes bytes, int vrIndex) => new UIevr(bytes);
}

class LOevr extends LO with EvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final EvrShortBytes bytes;

  LOevr(this.bytes);

  static Element make(Bytes bytes, int vrIndex) {
    final group = bytes.getUint16(0);
    final elt = bytes.getUint16(2);
    return (group.isOdd && elt >= 0x10 && elt <= 0xFF)
        ? new PCevr(bytes)
        : new LOevr(bytes);
  }
}

class PCevr extends PC with EvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final EvrShortBytes bytes;

  PCevr(this.bytes);

  @override
  String get token => vfString;

  static PCevr make(Bytes bytes, int vrIndex) => new PCevr(bytes);

  // Urgent: remove when working
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

class PNevr extends PN with EvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final EvrShortBytes bytes;

  PNevr(this.bytes);

  static PNevr make(Bytes bytes, int vrIndex) => new PNevr(bytes);
}

class SHevr extends SH with EvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final EvrShortBytes bytes;

  SHevr(this.bytes);

  static SHevr make(Bytes bytes, int vrIndex) => new SHevr(bytes);
}

class LTevr extends LT with EvrElement<String>, ByteStringMixin, TextMixin {
  @override
  final EvrShortBytes bytes;

  LTevr(this.bytes);

  static LTevr make(Bytes bytes, int vrIndex) => new LTevr(bytes);
}

class STevr extends ST with EvrElement<String>, ByteStringMixin, TextMixin {
  @override
  final EvrShortBytes bytes;

  STevr(this.bytes);

  static STevr make(Bytes bytes, int vrIndex) => new STevr(bytes);
}

class TMevr extends TM with EvrElement<String>, ByteStringMixin, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  TMevr(this.bytes);

  static TMevr make(Bytes bytes, int vrIndex) => new TMevr(bytes);
}

class UCevr extends UC with EvrElement<String>, ByteStringMixin, Utf8Mixin {
  @override
  final EvrLongBytes bytes;

  UCevr(this.bytes);

  static UCevr make(Bytes bytes, int vrIndex) => new UCevr(bytes);
}

class URevr extends UR with EvrElement<String>, ByteStringMixin, TextMixin {
  @override
  final EvrLongBytes bytes;

  URevr(this.bytes);

  static URevr make(Bytes bytes, int vrIndex) => new URevr(bytes);
}

class UTevr extends UT with EvrElement<String>, ByteStringMixin, TextMixin {
  @override
  final EvrLongBytes bytes;

  UTevr(this.bytes);

  static UTevr make(Bytes bytes, int vrIndex) => new UTevr(bytes);
}

class SQevr extends SQ with EvrElement<Item> {
  @override
  final Dataset parent;
  @override
  Iterable<Item> values;
  @override
  final EvrLongBytes bytes;

  SQevr(this.parent, this.values, this.bytes);

  @override
  int get valuesLength => values.length;

  static SQevr make(Dataset parent,
          [SQ sequence, Iterable<Item> values, Bytes bytes]) =>
      new SQevr(parent, values, bytes);
}
