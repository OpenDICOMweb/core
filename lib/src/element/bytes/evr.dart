//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/value/empty_list.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/bytes/bytes_element.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr_base.dart';

abstract class EvrElement<V> implements ByteElement<V> {
  @override
  EvrBytes get bytes;
  @override
  Iterable<V> get values;
  // **** End of Interface

  /// The [index] of the [Element] Definition for _this_. It is
  /// used to locate other values in the [Element] Definition.
  @override
  int get index => code;

  @override
  set values(Iterable<V> vList) =>
      unsupportedError('ByteElements are not settable.');

  /// Returns _true_ if _this_ and [other] are the same [EvrElement], and
  /// equal byte for byte.
  @override
  bool operator ==(Object other) =>
      (other is EvrElement) ? bytes == other.bytes : false;
  @override
  int get length => bytes.length;
  @override
  int get hashCode => bytes.hashCode;
  @override
  bool get isEvr => true;
  @override
  int get code => bytes.code;
  @override
  bool get isPublic => code.isEven;
  @override
  int get vrCode => bytes.vrCode;
  @override
  int get vrIndex => bytes.vrIndex;
  @override
  int get vfLengthOffset => bytes.vfLengthOffset;
  @override
  int get vfLengthField => bytes.vfLengthField;
  @override
  int get vfLength => bytes.vfLength;
  @override
  int get vfOffset => bytes.vfOffset;
  @override
  Bytes get vfBytes => bytes.vfBytes;
  @override
  Bytes get vfBytesWOPadding => bytes.vfBytesWOPadding;
  @override
  Tag get tag => Tag.lookupByCode(code, vrIndex);
  @override
  bool get isRetired => tag.isRetired;

  static Element makeFromCode(Dataset ds, int code, EvrBytes bytes) {
    final pCode = code & 0x1FFFF;
    if (pCode >= 0x10010 && pCode <= 0x100FF) return new PCevr(bytes);
    final vrIndex = bytes.vrIndex;
    final tag = lookupTagByCode(ds, code, vrIndex);
    final tagVRIndex = tag.vrIndex;
    assert(tagVRIndex != kSQIndex);
    final ByteElement e = _evrBDMakers[vrIndex](bytes, tagVRIndex);
    return (pCode >= 0x11000 && pCode <= 0x1FFFF) ? new PrivateData(e) : e;
  }

  static final List<Function> _evrBDMakers = <Function>[
    _sqError, // stop reformat
    // Maybe Undefined Lengths
    OBevr.makeFromBytes, OWevr.makeFromBytes, UNevr.makeFromBytes,

    // EVR Long
    ODevr.makeFromBytes, OFevr.makeFromBytes, OLevr.makeFromBytes,
    UCevr.makeFromBytes, URevr.makeFromBytes, UTevr.makeFromBytes,

    // EVR Short
    AEevr.makeFromBytes, ASevr.makeFromBytes, ATevr.makeFromBytes,
    CSevr.makeFromBytes, DAevr.makeFromBytes, DSevr.makeFromBytes,
    DTevr.makeFromBytes, FDevr.makeFromBytes, FLevr.makeFromBytes,
    ISevr.makeFromBytes, LOevr.makeFromBytes, LTevr.makeFromBytes,
    PNevr.makeFromBytes, SHevr.makeFromBytes, SLevr.makeFromBytes,
    SSevr.makeFromBytes, STevr.makeFromBytes, TMevr.makeFromBytes,
    UIevr.makeFromBytes, ULevr.makeFromBytes, USevr.makeFromBytes,
  ];

  static Null _sqError(EvrBytes bytes, [int vrIndex]) =>
      invalidElementIndex(vrIndex);

  static Element makeFromBytesPixelData(int code, EvrBytes eBytes,
      [int vfLengthField, TransferSyntax ts, VFFragments fragments]) {
    if (code != kPixelData)
      return invalidKey(code, 'Invalid Tag Code for PixelData');
    final vrIndex = eBytes.vrIndex;
    switch (vrIndex) {
      case kOBIndex:
        return OBevrPixelData.makeFromBytes(code, eBytes, ts, fragments);
      case kUNIndex:
        return UNevrPixelData.makeFromBytes(code, eBytes, ts, fragments);
      case kOWIndex:
        return OWevrPixelData.makeFromBytes(code, eBytes, ts, fragments);
      default:
        return invalidVRIndex(vrIndex, null, null);
    }
  }

  /// Returns a new [SQevr], where [bytes] is [Bytes] for complete sequence.
  static SQevr makeFromBytesSequence(int code, Dataset parent,
          [Iterable<Item> items, EvrBytes bytes]) =>
      new SQevr(parent, items, bytes);
}

class FLevr extends FL with TagMixin, EvrElement<double>, Float32Mixin {
  @override
  final EvrShortBytes bytes;

  FLevr(this.bytes);

  static FLevr makeFromBytes(EvrBytes bytes) => new FLevr(bytes);
}

class OFevr extends OF with TagMixin, EvrElement<double>, Float32Mixin {
  @override
  final EvrLongBytes bytes;

  OFevr(this.bytes);

  static OFevr makeFromBytes(EvrBytes bytes) => new OFevr(bytes);
}

class FDevr extends FD with TagMixin, EvrElement<double>, Float64Mixin {
  @override
  final EvrShortBytes bytes;

  FDevr(this.bytes);

  static FDevr makeFromBytes(EvrBytes bytes) => new FDevr(bytes);
}

class ODevr extends OD with TagMixin, EvrElement<double>, Float64Mixin {
  @override
  final EvrLongBytes bytes;

  ODevr(this.bytes);

  static ODevr makeFromBytes(EvrBytes bytes) => new ODevr(bytes);
}

// **** Integer Elements

class OBevr extends OB with TagMixin, EvrElement<int>, Uint8Mixin {
  @override
  final EvrLongBytes bytes;

  OBevr(this.bytes);

  static OBevr makeFromBytes(EvrBytes bytes) => new OBevr(bytes);
}

class OBevrPixelData extends OBPixelData
    with TagMixin, EvrElement<int>, Uint8Mixin {
  @override
  final EvrLongBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBevrPixelData(this.bytes, [this.ts, this.fragments]);

  static OBevrPixelData makeFromBytes(int code, EvrBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OBevrPixelData(bytes, ts, fragments);
}

class UNevr extends UN with TagMixin, EvrElement<int>, Uint8Mixin {
  @override
  final EvrLongBytes bytes;

  UNevr(this.bytes);

  static UNevr makeFromBytes(EvrBytes bytes) => new UNevr(bytes);
}

class UNevrPixelData extends UNPixelData
    with TagMixin, EvrElement<int>, Uint8Mixin {
  @override
  final EvrLongBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNevrPixelData(this.bytes, [this.ts, this.fragments]);

  static UNevrPixelData makeFromBytes(int code, EvrBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new UNevrPixelData(bytes, ts, fragments);
}

class SSevr extends SS with TagMixin, EvrElement<int>, Int16Mixin {
  @override
  final EvrShortBytes bytes;

  SSevr(this.bytes);

  static SSevr makeFromBytes(EvrBytes bytes) => new SSevr(bytes);
}

class USevr extends US with TagMixin, EvrElement<int>, Uint16Mixin {
  @override
  final EvrShortBytes bytes;

  USevr(this.bytes);

  static USevr makeFromBytes(EvrBytes bytes) => new USevr(bytes);
}

class OWevr extends OW with TagMixin, EvrElement<int>, Uint16Mixin {
  @override
  final EvrLongBytes bytes;

  OWevr(this.bytes);

  static OWevr makeFromBytes(EvrBytes bytes) => new OWevr(bytes);
}

class OWevrPixelData extends OWPixelData
    with TagMixin, EvrElement<int>, Uint16Mixin {
  @override
  final EvrLongBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OWevrPixelData(this.bytes, [this.ts, this.fragments]);

  static OWevrPixelData makeFromBytes(int code, EvrBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OWevrPixelData(bytes, ts, fragments);
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

/// Attribute (Element) Code (AT)
class ATevr extends AT with TagMixin, EvrElement<int>, Uint32Mixin {
  @override
  final EvrShortBytes bytes;

  ATevr(this.bytes);

  static ATevr makeFromBytes(EvrBytes bytes) => new ATevr(bytes);
}

/// Other Long (OL)
class OLevr extends OL with TagMixin, EvrElement<int>, Uint32Mixin {
  @override
  final EvrLongBytes bytes;

  OLevr(this.bytes);

  static OLevr makeFromBytes(EvrBytes bytes) => new OLevr(bytes);
}

/// Signed Long (SL)
class SLevr extends SL with TagMixin, EvrElement<int>, Int32Mixin {
  @override
  final EvrShortBytes bytes;

  SLevr(this.bytes);

  static SLevr makeFromBytes(EvrBytes bytes) => new SLevr(bytes);
}

/// Unsigned Long (UL)
class ULevr extends UL with TagMixin, EvrElement<int>, Uint32Mixin {
  @override
  final EvrShortBytes bytes;

  ULevr(this.bytes);

  static Element<int> makeFromBytes(EvrBytes bytes) =>
      // If the code is (gggg,0000) create a Group Length element
      (bytes.getUint16(2) == 0) ? new GLevr(bytes) : new ULevr(bytes);
}

/// Group Length (GL)
class GLevr extends GL with TagMixin, EvrElement<int>, Uint32Mixin {
  @override
  final EvrShortBytes bytes;

  GLevr(this.bytes);

  static GLevr makeFromBytes(EvrBytes bytes) => new GLevr(bytes);
}

// **** String Elements

class AEevr extends AE with TagMixin, EvrElement<String>, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  AEevr(this.bytes);

  static AEevr makeFromBytes(EvrBytes bytes) => new AEevr(bytes);
}

class ASevr extends AS with TagMixin, EvrElement<String>, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  ASevr(this.bytes);

  static ASevr makeFromBytes(EvrBytes bytes) {
    final length = bytes.length;
    if (length != 12 && length != 8)
      log.warn('Invalid Age (AS) "${bytes.getUtf8()}"');
    return new ASevr(bytes);
  }
}

class CSevr extends CS with TagMixin, EvrElement<String>, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  CSevr(this.bytes);

  static CSevr makeFromBytes(EvrBytes bytes) => new CSevr(bytes);
}

class DAevr extends DA with TagMixin, EvrElement<String>, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  DAevr(this.bytes);

  static DAevr makeFromBytes(EvrBytes bytes) {
    final length = bytes.length;
    if (length != 16 && length != 8)
      log.debug('Invalid Date (DA) "${bytes.getUtf8()}"');
    return new DAevr(bytes);
  }
}

class DSevr extends DS with TagMixin, EvrElement<String>, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  DSevr(this.bytes);

  static DSevr makeFromBytes(EvrBytes bytes) => new DSevr(bytes);
}

class DTevr extends DT with TagMixin, EvrElement<String>, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  DTevr(this.bytes);

  static DTevr makeFromBytes(EvrBytes bytes) => new DTevr(bytes);
}

class ISevr extends IS with TagMixin, EvrElement<String>, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  ISevr(this.bytes);

  static ISevr makeFromBytes(EvrBytes bytes) => new ISevr(bytes);
}

class UIevr extends UI with TagMixin, EvrElement<String>, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  UIevr(this.bytes);

  static UIevr makeFromBytes(EvrBytes bytes) => new UIevr(bytes);
}

class LOevr extends LO with TagMixin, EvrElement<String>, Utf8Mixin {
  @override
  final EvrShortBytes bytes;

  LOevr(this.bytes);

  static Element makeFromBytes(EvrBytes bytes) {
    final group = bytes.getUint16(0);
    final elt = bytes.getUint16(2);
    return (group.isOdd && elt >= 0x10 && elt <= 0xFF)
        ? new PCevr(bytes)
        : new LOevr(bytes);
  }
}

class PCevr extends PC with TagMixin, EvrElement<String>, Utf8Mixin {
  @override
  final EvrShortBytes bytes;

  PCevr(this.bytes);

  @override
  String get token => vfString;

  static PCevr makeFromBytes(EvrBytes bytes) => new PCevr(bytes);

  // Urgent: remove when working
/*  static PCevr makeFromBytesEmptyPrivateCreator(int pdTag) {
    final group = Tag.privateGroup(pdTag);
    final sgNumber = (pdTag & 0xFFFF) >> 8;
    final bytes = new EvrShortBytes(8)
      ..setUint16(0, group)
      ..setUint16(0, sgNumber)
      ..setUint8(4, kLOIndex)
      //     ..setUint8(5, kO)
      ..setUint16(6, 0);
    return new PCevr(bytes);
  }
  */
}

class PNevr extends PN with TagMixin, EvrElement<String>, Utf8Mixin {
  @override
  final EvrShortBytes bytes;

  PNevr(this.bytes);

  static PNevr makeFromBytes(EvrBytes bytes) => new PNevr(bytes);
}

class SHevr extends SH with TagMixin, EvrElement<String>, Utf8Mixin {
  @override
  final EvrShortBytes bytes;

  SHevr(this.bytes);

  static SHevr makeFromBytes(EvrBytes bytes) => new SHevr(bytes);
}

class LTevr extends LT with TagMixin, EvrElement<String>, TextMixin {
  @override
  final EvrShortBytes bytes;

  LTevr(this.bytes);

  static LTevr makeFromBytes(EvrBytes bytes) => new LTevr(bytes);
}

class STevr extends ST with TagMixin, EvrElement<String>, TextMixin {
  @override
  final EvrShortBytes bytes;

  STevr(this.bytes);

  static STevr makeFromBytes(EvrBytes bytes) => new STevr(bytes);
}

class TMevr extends TM with TagMixin, EvrElement<String>, AsciiMixin {
  @override
  final EvrShortBytes bytes;

  TMevr(this.bytes);

  static TMevr makeFromBytes(EvrBytes bytes) => new TMevr(bytes);
}

class UCevr extends UC with TagMixin, EvrElement<String>, Utf8Mixin {
  @override
  final EvrLongBytes bytes;

  UCevr(this.bytes);

  static UCevr makeFromBytes(EvrBytes bytes) => new UCevr(bytes);
}

class URevr extends UR with TagMixin, EvrElement<String>, TextMixin {
  @override
  final EvrLongBytes bytes;

  URevr(this.bytes);

  static URevr makeFromBytes(EvrBytes bytes) => new URevr(bytes);
}

class UTevr extends UT with TagMixin, EvrElement<String>, TextMixin {
  @override
  final EvrLongBytes bytes;

  UTevr(this.bytes);

  static UTevr makeFromBytes(EvrBytes bytes) => new UTevr(bytes);
}

class SQevr extends SQ with TagMixin, EvrElement<Item> {
  @override
  final Dataset parent;
  @override
  Iterable<Item> values;
  @override
  final EvrLongBytes bytes;

  SQevr(this.parent, this.values, this.bytes);

  @override
  int get valuesLength => values.length;

  static SQevr makeFromBytes(Dataset parent,
          [SQ sequence, Iterable<Item> values, EvrBytes bytes]) =>
      new SQevr(parent, values, bytes);
}
