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
import 'package:core/src/element/bytes/bytes.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';

typedef Element DecodeBinaryVF(DicomBytes bytes, int vrIndex);

typedef Element BDElementMaker(int code, int vrIndex, DicomBytes bytes);

abstract class ByteElement<V> {
  DicomBytes get bytes;
  int get valuesLength;
  Iterable<V> get values;
  List<V> get emptyList;
  bool get hasValidValues;
  V operator [](int index);

  // **** End of Interface

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

  int get length => bytes.length;

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

  Bytes get vBytes => bytes.vBytes;

  int get vfBytesLast => bytes.vfBytesLast;

  Tag get tag => Tag.lookupByCode(code);
  int get vmMin => tag.vmMin;
  int get vmMax => tag.vmMax;
  int get vmColumns => tag.vmColumns;

  bool get isRetired => tag.isRetired;

  String get keyword => tag.keyword;
  String get name => tag.name;

  static ByteElement makeFromBytes(DicomBytes bytes, [Dataset ds]) {
    final code = bytes.code;
    final pCode = code & 0x1FFFF;
    if (pCode >= 0x10010 && pCode <= 0x100FF) return new PCbytes(bytes);
    final vrIndex = bytes.vrIndex;

    final tag = (ds != null)
        ? lookupTagByCode(ds, code, vrIndex)
        : Tag.lookupByCode(code);
    final tagVRIndex = tag.vrIndex;
    assert(tagVRIndex != kSQIndex);
    return _bytesBDMakers[tagVRIndex](bytes);
    //  return (pCode >= 0x11000 && pCode <= 0x1FFFF) ? new PrivateData(e) : e;
  }

  static final List<Function> _bytesBDMakers = <Function>[
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

  static ByteElement makeFromValues<V>(DicomBytes bytes, [Dataset ds]) {
    final code = bytes.code;
    final pCode = code & 0x1FFFF;
    if (pCode >= 0x10010 && pCode <= 0x100FF) return new PCbytes(bytes);
    final vrIndex = bytes.vrIndex;
    final tag = lookupTagByCode(ds, code, vrIndex);
    final tagVRIndex = tag.vrIndex;
    assert(tagVRIndex != kSQIndex);
    return _bytesValuesMakers[vrIndex](bytes, tagVRIndex);
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
  int get sizeInBytes;
  int get vfLength;
  DicomBytes get vfBytes;

  int get valuesLength => Int16.getLength(vfLength);
  int get lengthInBytes => valuesLength * sizeInBytes;

  Int16List get values => vfBytes.asInt16List();

  Int16List get emptyList => kEmptyInt16List;
}

/// 32-bit signed integer Elements (SL)
abstract class Int32Mixin {
  int get sizeInBytes;
  int get vfLength;
  DicomBytes get vfBytes;

  int get valuesLength => Int32.getLength(vfLength);
  int get lengthInBytes => valuesLength * sizeInBytes;
  Int32List get values => vfBytes.asInt32List();

  Int32List get emptyList => kEmptyInt32List;
}

/// 8-bit Integer Elements (OB, UN)
abstract class Uint8Mixin {
  int get sizeInBytes;
  int get vfLength;
  DicomBytes get vfBytes;
  int get vfBytesLast;

  bool get hasPadding => vfBytesLast == 0;
  bool get hasValidPadding => hasPadding;
  int get paddingCharacter => vfBytesLast;

  int get valuesLength => Uint8.getLength(vfLength);
  int get lengthInBytes => valuesLength * sizeInBytes;
  Uint8List get values => vfBytes.asUint8List();

  Uint8List get emptyList => kEmptyUint8List;
}

/// 16-bit unsigned integer Elements (US, OW)
abstract class Uint16Mixin {
  int get sizeInBytes;
  int get vfLength;
  DicomBytes get vfBytes;

  int get valuesLength => Uint16.getLength(vfLength);
  int get lengthInBytes => valuesLength * sizeInBytes;
  Uint16List get values => vfBytes.asUint16List();

  Uint16List get emptyList => kEmptyUint16List;
}

/// 32-bit unsigned integer Elements (AT, UL, GL, OL)
abstract class Uint32Mixin {
  int get sizeInBytes;
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Uint32.getLength(vfLength);
  //Flush when length working
  int get valuesLength => Uint32.getLength(vfLength);
  int get lengthInBytes => valuesLength * sizeInBytes;

  Uint32List get values => vfBytes.asUint32List();

  Uint32List get emptyList => kEmptyUint32List;
}

/// 32-bit Float Elements (FL, OF)
abstract class Float32Mixin {
  int get sizeInBytes;
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Float32.getLength(vfLength);
  //Flush when length working
  int get valuesLength => Float32.getLength(vfLength);

  int get lengthInBytes => valuesLength * sizeInBytes;

  Float32List get values => vfBytes.asFloat32List();

  Float32List get emptyList => kEmptyFloat32List;
}

/// Long Float Elements (FD, OD)
abstract class Float64Mixin {
  int get sizeInBytes;
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Float64.getLength(vfLength);
  //Flush when length working
  int get valuesLength => Float64.getLength(vfLength);

  int get lengthInBytes => valuesLength * sizeInBytes;

  Float64List get values => vfBytes.asFloat64List();

  Float64List get emptyList => kEmptyFloat64List;
}

/// [String] [Element]s that only have ASCII values.
abstract class StringMixin {
  int get vfLength;
  DicomBytes get vfBytes;
  int get vfBytesLast;
  String get vfString;

  /// Returns _true if [vfBytes] ends with a padding character.
  bool get hasPadding => vfLength.isEven && vfBytesLast == 0;

  /// Returns _true if the padding character, if any, is valid for _this_.
  bool get hasValidPadding => hasPadding && (padChar == kSpace);

  /// If [vfLength] is not empty and [vfLength] is not equal to zero,
  /// returns the last Uint8 element in [vfBytes]; otherwise, returns null;
  int get padChar => (vfLength != 0 && vfLength.isEven) ? vfBytesLast : null;

  /// Returns the number of values in [vfBytes].
  int get length => _stringValuesLength(vfBytes);

  //Flush when length working
  /// Returns the number of values in [vfBytes].
  int get valuesLength => _stringValuesLength(vfBytes);

  Iterable<String> get values => vfString.split('\\');

  List<String> get emptyList => kEmptyStringList;
}

/// [String] [Element]s that only have ASCII values.
abstract class AsciiMixin {
  DicomBytes get vfBytes;

  bool allowInvalid = true;

  String get vfString => vfBytes.getAscii(allowInvalid: allowInvalid);

  Iterable<String> get values => vfString.split('\\');
}

/// [String] [Element]s that may have UTF-8 values.
abstract class Utf8Mixin {
  DicomBytes get vfBytes;

  int get valuesLength => _stringValuesLength(vfBytes);

  bool allowMalformed = true;

  String get vfString => vfBytes.getUtf8(allowMalformed: allowMalformed);
}

/// Text ([String]) [Element]s that may only have 1 UTF-8 value.
abstract class TextMixin {
  DicomBytes get vBytes;

  int get valuesLength => 1;

  bool allowMalformed = true;

  String get vfString => vBytes.getUtf8(allowMalformed: allowMalformed);
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
