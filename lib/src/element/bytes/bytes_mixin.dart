//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/bytes.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/value/uid.dart';

typedef Element DecodeBinaryVF(DicomBytes bytes, int vrIndex);

typedef Element BDElementMaker(int code, int vrIndex, DicomBytes bytes);

abstract class ByteElement<V> {
  DicomBytes get bytes;

  /// The length of values;
  int get length;
  Iterable<V> get values;
  List<V> get emptyList;
  bool get hasValidValues;
  V operator [](int index);

  // **** End of Interface

  set values(Iterable<V> vList) => unsupportedError();

  /// Returns _true_ if _this_ and [other] are the same [ByteElement],
  /// and equal byte for byte.
  @override
  bool operator ==(Object other) =>
      (other is ByteElement) ? bytes == other.bytes : false;
  @override
  int get hashCode => bytes.hashCode;

  /// The [index] of the [Element] Definition for _this_. It is
  /// used to locate other values in the [Element] Definition.
  int get index => code;

  /// The length in bytes of this [ByteElement]
  int get eLength => bytes.length;

  bool get isEvr => bytes.isEvr;

  int get code => bytes.code;

  bool get isPublic => code.isEven;
  bool get isPrivate => !isPublic;
  int get vrCode => bytes.vrCode;

  int get vrIndex => bytes.vrIndex;

  int get vfLengthOffset => bytes.vfLengthOffset;

  int get vfLengthField => bytes.vfLengthField;

  int get vfLength => bytes.vfLength;

  int get vfOffset => bytes.vfOffset;

  Bytes get vfBytes => bytes.vfBytes;

//  Bytes get vBytes => bytes.vBytes;

  int get vfBytesLast => bytes.vfBytesLast;

  Tag get tag => Tag.lookupByCode(code);
  int get vmMin => tag.vmMin;
  int get vmMax => tag.vmMax;
  int get vmColumns => tag.vmColumns;

  bool get isRetired => tag.isRetired;

  String get keyword => tag.keyword;
  String get name => tag.name;

  static bool _isPrivateCreator(int code) {
    final pCode = code & 0x1FFFF;
    return pCode >= 0x10010 && pCode <= 0x100FF;
  }

  static PC _getPCFromBytes(DicomBytes bytes, int code) {
    final token = bytes.vfBytes.getUtf8();
    final tag = PCTag.lookupByToken(code, bytes.vrIndex, token);
    return new PCbytes(bytes);
  }

  static Tag _getTag(int code, int vrIndex, Dataset ds) => (ds != null)
      ? lookupTagByCode(code, vrIndex, ds)
      : Tag.lookupByCode(code, vrIndex);

  static Element makeFromDicomBytes(DicomBytes bytes, Dataset ds) {
    final code = bytes.code;
    if (_isPrivateCreator(code)) return new PCbytes(bytes);

    final tag = _getTag(code, bytes.vrIndex, ds);
    final tagVRIndex = tag.vrIndex;
    return _bytesMakers[tagVRIndex](bytes);
  }

  static final List<Function> _bytesMakers = <Function>[
    SQbytes.fromBytes, // stop reformat
    // Maybe Undefined Lengths
    OBbytes.fromBytes, OWbytes.fromBytes, UNbytes.fromBytes,

    // EVR Long
    ODbytes.fromBytes, OFbytes.fromBytes, OLbytes.fromBytes,
    UCbytes.fromBytes, URbytes.fromBytes, UTbytes.fromBytes,

    // EVR Short
    AEbytes.fromBytes, ASbytes.fromBytes, ATbytes.fromBytes,
    CSbytes.fromBytes, DAbytes.fromBytes, DSbytes.fromBytes,
    DTbytes.fromBytes, FDbytes.fromBytes, FLbytes.fromBytes,
    ISbytes.fromBytes, LObytes.fromBytes, LTbytes.fromBytes,
    PNbytes.fromBytes, SHbytes.fromBytes, SLbytes.fromBytes,
    SSbytes.fromBytes, STbytes.fromBytes, TMbytes.fromBytes,
    UIbytes.fromBytes, ULbytes.fromBytes, USbytes.fromBytes
  ];

  static Element makeMaybeUndefinedFromDicomBytes(DicomBytes bytes,
      [Dataset ds, int vfLengthField]) {
    final code = bytes.code;
    // Note: This shouldn't happen, but it does.
    if (_isPrivateCreator(code)) return new PCbytes(bytes);

    final vrIndex = bytes.vrIndex;
    assert(vrIndex >= 0 && vrIndex < 4);
    final tag = _getTag(code, vrIndex, ds);
    final tagVRIndex = tag.vrIndex;
    return _undefinedBytesMakers[tagVRIndex](bytes, ds, vfLengthField);
  }

  // Elements that may have undefined lengths.
  static final List<Function> _undefinedBytesMakers = <Function>[
    SQbytes.fromBytes, // stop reformat
    OBbytes.fromBytes, OWbytes.fromBytes, UNbytes.fromBytes
  ];

  static Element makeSQFromDicomBytes(
      Dataset parent, List<Item> items, DicomBytes bytes) {
    final code = bytes.code;
    if (_isPrivateCreator(code)) return badVRIndex(kSQIndex, null, kLOIndex);

    final tag = _getTag(code, bytes.vrIndex, parent);
    if (tag.vrIndex != kSQIndex)
      log.warn('** Non-Sequence Tag $tag for $bytes');
    return SQbytes.fromBytes(parent, items, bytes);
  }

  static Element makePixelDataFromDicomBytes(DicomBytes bytes,
      [Dataset ds, TransferSyntax ts, VFFragments fragments]) {
    final code = bytes.code;
    final tag = _getTag(code, bytes.vrIndex, ds);
    if (code != kPixelData) return badCode(code, 'Not Pixel Data', tag);
    return _undefinedBytesMakers[tag.vrIndex](bytes, ds, ts, fragments);
  }

  /// Returns a new [Element] based on the arguments.
  static Element makeFromValues(int code, int vrIndex, Iterable vList,
      {bool isEvr = true, Dataset ds}) {
    if (_isPrivateCreator(code))
      return PCbytes.fromValues(code, vList, isEvr: isEvr);
    final tag = _getTag(code, vrIndex, ds);
    final tagVRIndex = tag.vrIndex;
    return _bytesValuesMakers[vrIndex](code, vList, tagVRIndex);
  }

  static final List<Function> _bytesValuesMakers = <Function>[
    SQbytes.fromValues, // stop reformat
    // Maybe Undefined Lengths
    OBbytes.fromValues, OWbytes.fromValues, UNbytes.fromValues,

    // EVR Long
    OBbytes.fromValues, OFbytes.fromValues, OLbytes.fromValues,
    UCbytes.fromValues, URbytes.fromValues, UTbytes.fromValues,

    // EVR Short
    AEbytes.fromValues, ASbytes.fromValues, ATbytes.fromValues,
    CSbytes.fromValues, DAbytes.fromValues, DSbytes.fromValues,
    DTbytes.fromValues, FDbytes.fromValues, FLbytes.fromValues,
    ISbytes.fromValues, LObytes.fromValues, LTbytes.fromValues,
    PNbytes.fromValues, SHbytes.fromValues, SLbytes.fromValues,
    SSbytes.fromValues, STbytes.fromValues, TMbytes.fromValues,
    UIbytes.fromValues, ULbytes.fromValues, USbytes.fromValues,
  ];
}

/// 16-bit signed integer Elements (SS)
abstract class Int16Mixin {
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Int16.getLength(vfLength);

  Int16List get values => vfBytes.asInt16List();
}

/// 32-bit signed integer Elements (SL)
abstract class Int32Mixin {
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Int32.getLength(vfLength);

  Int32List get values => vfBytes.asInt32List();
}

/// 8-bit Integer Elements (OB, UN)
abstract class Uint8Mixin {
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Uint8.getLength(vfLength);

  Uint8List get values => vfBytes.asUint8List();
}

/// 16-bit unsigned integer Elements (US, OW)
abstract class Uint16Mixin {
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Uint16.getLength(vfLength);

  Uint16List get values => vfBytes.asUint16List();
}

/// 32-bit unsigned integer Elements (AT, UL, GL, OL)
abstract class Uint32Mixin {
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Uint32.getLength(vfLength);

  Uint32List get values => vfBytes.asUint32List();
}

/// 32-bit Float Elements (FL, OF)
abstract class Float32Mixin {
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Float32.getLength(vfLength);

  Iterable<double> get values => vfBytes.asFloat32List();
}

/// Long Float Elements (FD, OD)
abstract class Float64Mixin {
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Float64.getLength(vfLength);

  Iterable<double> get values => vfBytes.asFloat64List();
}

/// [String] [Element]s that only have ASCII values.
abstract class StringMixin {
  int get vfLength;
  DicomBytes get vfBytes;
  int get vfBytesLast;
  String get vfString;

  /// Returns _true if [vfBytes] ends with a padding character.
  bool get hasPadding => vfLength.isEven && vfBytesLast == kSpace;

  /// Returns _true if the padding character, if any, is valid for _this_.
  bool get hasValidPadding => hasPadding && (padChar == kSpace);

  /// If [vfLength] is not empty and [vfLength] is not equal to zero,
  /// returns the last Uint8 element in [vfBytes]; otherwise, returns null;
  int get padChar => (vfLength != 0 && vfLength.isEven) ? vfBytesLast : null;

  /// Returns the number of values in [vfBytes].
  int get length => _stringValuesLength(vfBytes);

  Iterable<String> get values => vfString.split('\\');

  List<String> get emptyList => kEmptyStringList;
}

/// [String] [Element]s that only have ASCII values.
abstract class AsciiMixin {
  bool get hasPadding;
  int get vfLength;
  DicomBytes get vfBytes;

  bool allowInvalid = true;

  String get vfString {
    final vf = (hasPadding) ? vfBytes.sublist(0, vfLength - 1) : vfBytes;
    return vf.getAscii(allowInvalid: allowInvalid);
  }

  Iterable<String> get values => vfString.split('\\');
}

/// [String] [Element]s that may have UTF-8 values.
abstract class Utf8Mixin {
  bool get hasPadding;
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => _stringValuesLength(vfBytes);

  bool allowMalformed = true;

  String get vfString {
    final vf = (hasPadding) ? vfBytes.sublist(0, vfLength - 1) : vfBytes;
    return vf.getUtf8(allowMalformed: allowMalformed);
  }
}

/// Text ([String]) [Element]s that may only have 1 UTF-8 value.
abstract class TextMixin {
  DicomBytes get vfBytes;

  int get length => 1;

  bool allowMalformed = true;

  String get vfString => vfBytes.getUtf8(allowMalformed: allowMalformed);
  String get value => vfString;
  Iterable<String> get values => [vfString];
}

int _stringValuesLength(Bytes vfBytes) {
  if (vfBytes.isEmpty) return 0;
  var count = 1;
  for (var i = 0; i < vfBytes.length; i++)
    if (vfBytes[i] == kBackslash) count++;
  return count;
}

/// PixelDataMixin class
abstract class BytePixelData {
  Tag get tag;
  int get code;
  int get vfLengthField;
  int get vfLength;
  Bytes get vfBytes;
  VFFragments get fragments;

  /// The [List<int>] of pixels.
  List<int> get pixels;
  TransferSyntax get ts;

  /// Returns _true_ if [pixels] are compressed.
  bool get isCompressed;

  // **** End Interface

  /// Synonym for pisCompressed].
  bool get isEncapsulated => isCompressed;
}
