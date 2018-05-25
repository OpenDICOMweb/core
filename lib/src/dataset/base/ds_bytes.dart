//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';

/// Dataset Bytes ([DSBytes]).
abstract class DSBytes {
  // **** Interface ****

  /// The [Bytes] containing this Dataset.
  Bytes get bytes;

  /// The index of the first byte of the Dataset in [bytes].
  int get dsStart => bytes.offset;

  /// The number of bytes from the beginning to the end of the Dataset.
  int get dsLength => bytes.length;

  /// The index of the last byte of the Dataset in [bytes].
  int get dsEnd => dsStart + dsLength;

  /// The length of the entire Dataset including header, trailer, preamble, etc.
  // int get eLength => bd.length;

  /// Returns the length in bytes of the Value Field.
  int get vfLength;

  /// Returns the Value Field Length field, if any.
  int get vfLengthField;

  /// Returns _true_ if the Value Field Length field contained
  /// [kUndefinedLength].
  bool get hasULength => vfLengthField == kUndefinedLength;

  /// The number of bytes from the beginning of the Element to the Value Field.
  int get vfOffset;

  // **** End Interface ****

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is DSBytes) {
      if (dsEnd != other.dsEnd) return false;
      for (var i = 0; i < dsEnd; i++)
        if (bytes.getUint8(i) != other.bytes.getUint8(i)) return false;
      return true;
    }
    return false;
  }

  @override
  int get hashCode => bytes.hashCode;

  /// Returns the Value Field as a [Bytes].
  Bytes get vfBytes => bytes;

  /// Returns the Value Field as a [Uint8List].
  Uint8List get vfAsUint8List =>
      bytes.buffer.asUint8List(bytes.offset, bytes.length);

  // **** Internal Stuff ****

  /// Return a Uint16 value at [offset].
  int getUint8(int offset) => bytes.getUint8(offset);

  /// Return a Uint16 value at [offset].
  int getUint16(int offset) => bytes.getUint16(offset);

  /// Return a Uint32 value at [offset].
  int getUint32(int offset) => bytes.getUint32(offset);

  int getToken() {
    final group = getUint16(0);
    final elt = getUint16(2);
    return (group << 16) + elt;
  }

/*
  @override
  String toString() =>
      '$runtimeType: ${bytes.endian} $dsStart-$dsEnd:${bytes.length}';
*/

  @override
  String toString() => '$runtimeType: $bytes';
}

/// Root Dataset Bytes ([RDSBytes]).
class RDSBytes extends DSBytes {
  final int vfLengthFieldOffset = -1;
  @override
  final int vfOffset = kValueFieldOffset;

  /// The [Bytes] for a RootDataset. It spans from the first byte
  /// successfully read to the end of the last byte successfully read.
  /// The [bytes].buffer might have bytes before and/or after this [bytes].
  @override
  final Bytes bytes;

  final bool hasPrefix;

  /// The [Bytes] from index 0 to end of last FMI element in [bytes].
  /// If FMI was not successfully read this will be null.
  final int fmiEnd;

  RDSBytes(this.bytes, this.fmiEnd, {this.hasPrefix = true});

  RDSBytes.empty()
      : bytes = kEmptyBytes,
        fmiEnd = 0,
        hasPrefix = false;

  Bytes get preamble => bytes.asBytes(kPreambleOffset, kPreambleLength);

  Bytes get prefix => bytes.asBytes(kPrefixOffset, kPrefixLength);

  int get startDelimiter => getUint32(kPrefixOffset);

  int get fmiStart => bytes.offset;
  int get rdsStart => fmiEnd;
  int get rdsEnd => dsEnd;

  Uint8List get fmiBytes => (hasPrefix)
      ? bytes.buffer.asUint8List(bytes.offset, 132)
      : kEmptyUint8List;

  @override
  int get vfLength => dsLength - 132;
  @override
  int get vfLengthField => vfLength;

  @override
  Uint8List get vfAsUint8List =>
      bytes.buffer.asUint8List(bytes.offset + kHeaderSize, bytes.length);

  @override
  String toString() {
    final fmiLength = fmiEnd - 132;
    final dsLength = dsEnd - dsStart;
    return '$runtimeType: FMI 132-$fmiEnd:$fmiLength '
        'RDS $dsStart-$dsEnd:$dsLength';
  }

//  static const int kToken = kDcmPrefix;
  static const int kPreambleOffset = 0;
  static const int kPreambleLength = 128;
  static const int kPrefixOffset = 128;
  static const int kPrefixLength = 4;
  static const int kValueFieldOffset = 132;
  static const int kHeaderSize = 132;

  static final RDSBytes kEmpty = new RDSBytes.empty();

  static RDSBytes make(Bytes bd, [int fmiEnd]) => new RDSBytes(bd, fmiEnd);
}

/// Item Dataset Bytes ([IDSBytes]).
class IDSBytes extends DSBytes {
  final int vfLengthFieldOffset = kVFLengthFieldOffset;
  @override
  final int vfOffset = kValueFieldOffset;
  @override

  /// The [Bytes] from which _this_ was read.
  final Bytes bytes;

  IDSBytes(this.bytes);

  IDSBytes.empty() : bytes = kEmptyBytes;

  int get startDelimiter => getUint32(kStartDelimiterOffset);

  /// The actual length of the Value Field for _this_
  @override
  int get vfLength => dsLength - 8;

  /// Returns the value in the Value Field Length field.
  @override
  int get vfLengthField => bytes.getUint32(kVFLengthFieldOffset);

  int get endDelimiter =>
      (hasULength) ? getUint32(dsLength - kTrailerSize) : null;
  int get trailerLengthField =>
      (hasULength) ? getUint32(dsLength - kTrailerSize) : 0;

  bool get isValidItem =>
      startDelimiter == kStartDelimiter && hasValidEndDelimiter;

  bool get hasValidEndDelimiter => (hasULength)
      ? endDelimiter == kEndDelimiter && trailerLengthField == 0
      : true;

  /// Returns _true_ if the Value Field Length field
  /// contained [kUndefinedLength].
  @override
  bool get hasULength => vfLengthField == kUndefinedLength;

  int get trailerLength => (hasULength) ? kTrailerSize : 0;

  @override
  Bytes get vfBytes => bytes.asBytes(bytes.offset + kValueFieldOffset, dsEnd);

  static const int kStartDelimiterOffset = 0;
  static const int kVFLengthFieldOffset = 4;
  static const int kValueFieldOffset = 8;
  static const int kHeaderSize = 8;
  static const int kTrailerSize = 8;
  static const int kStartDelimiter = kItem32BitLE;
  static const int kEndDelimiter = kItemDelimitationItem32BitLE;

  static final IDSBytes kEmpty = new IDSBytes.empty();

  static IDSBytes make(Bytes bd) => new IDSBytes(bd);
}
