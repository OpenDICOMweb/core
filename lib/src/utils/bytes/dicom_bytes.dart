//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;

const int _groupOffset = 0;
const int _eltOffset = 2;

abstract class DicomMixin {
  int get vfLengthOffset;
  int get vfOffset;
  int get _length;

  Bytes view([int offset, int length, Endian endian]);
  int _getUint8(int offset);
  int _getUint16(int offset);
  int _getUint32(int offset);

  void _setUint8(int offset, int value);
  void _setUint16(int offset, int value);
  void _setUint32(int offset, int value);

  String getAscii({int offset, int length, bool allowInvalid});
  String getUtf8({int offset, int length, bool allowMalformed});
  // End Interface

  /// Returns the Tag Code from [Bytes].
  int get code {
    final group = _getUint16(_groupOffset);
    final elt = _getUint16(_eltOffset);
    final v = (group << 16) + elt;
    return v;
  }

  /// The Element Group Field
  int get group => _getUint16(_groupOffset);

  /// The Element _element_ Field.
  int get elt => _getUint16(_eltOffset);

  /// Returns the length in bytes of _this_ Element.
  int get eLength => _length;

  /// Returns the Value Field Length field of _this_.
  int get vfLengthField => _vfLengthField(vfOffset, vfLengthOffset);

  /// Returns the Value Field Length field of _this_.
  int _vfLengthField(int vfOffset, int vfLengthOffset) {
    assert(_length >= vfOffset);
    final vlf = _getUint32(vfLengthOffset);
    //TODO: remove this check if not needed
    _checkVFLengthField(vlf);
    return vlf;
  }

  void _checkVFLengthField(int vfLengthField) {
    final vfl = vfLength;
    final vlf = vfLengthField;
    if (vlf == vfl || vlf != kUndefinedLength) {
      log.warn('** vfLengthField($vfl) != vfLength($vfl');
      if (vlf == vfl + 1) log.warn('** vfLengthField: Odd length field: $vfl');
    }
  }

  /// Returns _true_ if [vfLengthField] equals [kUndefinedLength].
  bool get hasUndefinedLength => vfLengthField == kUndefinedLength;

  /// Returns the length in bytes of this Byte Element without padding.
  int get vfLength => _vfLength;
  int get _vfLength {
    final len = _length - vfOffset;
    if (len == 0 || len.isOdd) return len;
    final newLen = len - 1;
    final last = _getUint8(newLen);
    return (last == kSpace || last == kNull) ? newLen : len;
  }

  /// Returns the length in bytes of this Byte Element with padding.
  int get vfLengthWithPadding => _vfLengthWithPadding;
  int get _vfLengthWithPadding => _length - vfOffset;

  Bytes get vfBytes => view(vfOffset, _vfLength);

  Bytes get vfBytesWithPadding => view(vfOffset, _vfLengthWithPadding);

  bool allowInvalid = true;

  /// Returns an ASCII [String] with trailing [kSpace] or [kNull]
  /// removed if length is an even number.
  String get vfAsAscii =>
      getAscii(offset: vfOffset, length: _vfLength, allowInvalid: allowInvalid);

  bool allowMalformed = true;

  /// Returns a UTF-8 [String] with trailing [kSpace] or [kNull] removed
  /// if length is an even number.
  String get vfAsUtf8 => getUtf8(
      offset: vfOffset, length: _vfLength, allowMalformed: allowMalformed);

  // **** Dicom Getters
  int getCode(int offset) {
    final group = _getUint16(offset);
    final elt = _getUint16(offset + 2);
    return (group << 16) + elt;
  }

  int getVRCode(int offset) => _getVRCode(offset);
  int _getVRCode(int offset) {
    final first = _getUint8(offset);
    final second = _getUint8(offset + 1);
    return (second << 8) + first;
  }

  int getShortVLF(int offset) => _getUint16(offset);
  int getLongVLF(int offset) => _getUint32(offset);

  // **** Dicom Setters
  /// Returns the Tag Code from [Bytes].
  void setCode(int offset, int code) {
    _setUint16(offset, code >> 16);
    _setUint16(offset + 2, code & 0xFFFF);
  }

  /// Returns the Tag Code from [Bytes].
  void setVRCode(int offset, int vrCode) {
    _setUint8(offset, vrCode >> 8);
    _setUint8(offset + 2, vrCode & 0xFF);
  }


  void setShortVLF(int offset, int vlf) => _setUint16(offset, vlf);
  void setLongVLF(int offset, int vlf) => _setUint32(offset, vlf);

  /// Write a short EVR header.
  void evrSetShortHeader(int offset, int code, int vrCode, int vlf) {
    _setUint16(offset, code >> 16);
    _setUint16(offset + 2, code & 0xFFFF);
    _setUint8(offset + 4, vrCode >> 8);
    _setUint8(offset + 5, vrCode & 0xFF);
    _setUint16(offset + 6, vlf);
  }

  /// Write a short EVR header.
  void evrSetLongHeader(int offset, int code, int vrCode, int vlf) {
    _setUint16(offset, code >> 16);
    _setUint16(offset + 2, code & 0xFFFF);
    _setUint8(offset + 4, vrCode >> 8);
    _setUint8(offset + 5, vrCode & 0xFF);
// This field is ze ro, but GC takes care of  that
//    _setUint16(offset + 6, 0);
    _setUint32(offset + 8, 0);
  }

  /// Write a short EVR header.
  void ivrSetHeader(int offset, int code, int vrCode, int vlf) {
    _setUint16(offset, code >> 16);
    _setUint16(offset + 2, code & 0xFFFF);
    _setUint32(offset + 4, vlf);
  }

/*
  //Urgent: delete if not used
  //      all padding should be handled by Bytes.
  // Note: this method should only be called from String VRs, OB or UN.
  static Bytes withoutPadding(Bytes bytes, int start, int length,
      [int padChar = kSpace]) {
    assert(start.isEven && length.isEven);
    if (length == 0) return kEmptyBytes;
    int len;
    if (length.isEven) {
      final lastIndex = start + length - 1;
      final char = bytes.getUint8(lastIndex);
      len = (char == kNull || char == kSpace) ? length - 1 : length;
      if (len != length) log.debug3('Removing Padding: $char');
    }
    return new DicomBytes(bytes, start, len, bytes.endian);
  }
  */
}

bool ensureExactLength = true;

/// Returns _true_ if all bytes in [a] and [b] are the same.
/// _Note_: This assumes the [Bytes] is aligned on a 2 byte boundary.
bool uint8ListEqual(Uint8List a, Uint8List b) {
  final length = a.length;
  if (length != b.length) return false;
  for (var i = 0; i < length; i++) if (a[i] != b[i]) return false;
  return true;
}

bool _bytesEqual(Bytes a, Bytes b, [bool ignorePadding = false]) {
  if (ignorePadding) return __bytesEqual(a, b, true);
  final aLen = a.length;
  if (aLen != b.length) return false;
  for (var i = 0; i < aLen; i++) if (a[i] != b[i]) return false;
  return true;
}

/// Returns _true_ if all bytes in [a] and [b] are the same.
/// _Note_: This assumes the [Bytes] is aligned on a 2 byte boundary.
bool bytesEqual(Bytes a, Bytes b, {bool ignorePadding = false}) =>
    __bytesEqual(a, b, ignorePadding);

// TODO: test performance of _uint16Equal and _uint32Equal
bool __bytesEqual(Bytes a, Bytes b, bool ignorePadding) {
  final len0 = a.length;
  final len1 = b.length;
  if (len0.isOdd || len1.isOdd || len0 != len1) return false;
  if ((len0 % 4) == 0) {
    return _uint32Equal(a, b, ignorePadding);
  } else if ((len0 % 2) == 0) {
    return _uint16Equal(a, b, ignorePadding);
  } else {
    return _bytesEqual(a, b, ignorePadding);
  }
}

// Note: optimized to use 4 byte boundary
bool _uint16Equal(DicomBytes a, DicomBytes b, bool ignorePadding) {
  for (var i = 0; i < a.length; i += 2) {
    final x = a.getUint16(i);
    final y = b.getUint16(i);
    if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
  }
  return true;
}

// Note: optimized to use 4 byte boundary
bool _uint32Equal(Bytes a, Bytes b, bool ignorePadding) {
  for (var i = 0; i < a.length; i += 4) {
    final x = a.getUint32(i);
    final y = b.getUint32(i);
    if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
  }
  return true;
}

int errorCount = 0;

bool _bytesMaybeNotEqual(int i, Bytes a, Bytes b, bool ignorePadding) {
  if ((a[i] == 0 && b[i] == 32) || (a[i] == 32 && b[i] == 0)) {
    log.warn('$i ${a[i]} | ${b[i]} Padding char difference');
    return (ignorePadding) ? true : false;
  } else {
    final x = a[i];
    final y = b[i];
    errorCount++;
    log.warn('''
$i: $x | $y')
	  ${hex8(x)} | ${hex8(y)}
	  "${new String.fromCharCode(x)}" | "${new String.fromCharCode(y)}"
	  ${_toBytes(i, a, b)}
''');
    if (throwOnError) {
      if (errorCount > 3) throw new ArgumentError('Unequal');
    }
  }
  return false;
}

void _toBytes(int i, Bytes a, Bytes b) {
  log
    ..warn('    $a')
    ..warn('    $b')
    ..warn('    ${a.getAscii()}')
    ..warn('    ${b.getAscii()}');
}

/*
bool checkPadding(Bytes bytes, [int padChar = kSpace]) =>
    _checkPadding(bytes, padChar);

bool _checkPadding(Bytes bytes, int padChar) {
  assert(bytes.length.isEven, 'bytes.length: ${bytes.length}');
  final lastIndex = bytes.length - 1;
  final char = bytes.getUint8(lastIndex);
  if ((char == kNull || char == kSpace) && char != padChar)
    log.debug('** Invalid PadChar: $char should be $padChar');
  return true;
}
*/

Bytes removePadding(Bytes bytes, int vfOffset, [int padChar = kSpace]) =>
    _removePadding(bytes, vfOffset, padChar);

Bytes _removePadding(Bytes bytes, int vfOffset, int padChar) {
  assert(bytes.length.isEven && bytes.length >= vfOffset,
      'bytes.length: ${bytes.length}');
  if (bytes.length == vfOffset) return bytes;
  final lastIndex = bytes.length - 1;
  final char = bytes.getUint8(lastIndex);
  if (char == kNull || char == kSpace) {
    if (char != padChar)
      log.debug1('** Invalid PadChar: $char should be $padChar');
    log.debug2('Removing Padding: $char');
    return bytes.toBytes(bytes.offset, bytes.length - 1, bytes.endian);
  }
  return bytes;
}

abstract class DicomBytes extends Bytes with DicomMixin {
  DicomBytes._(Bytes bytes, int start, int end, Endian endian)
      : super._from(bytes, start, end - start, endian ?? Endian.host);
}

abstract class EvrBytes extends DicomBytes {
  /// Creates a new [EvrBytes]
  EvrBytes._(Bytes bytes, int start, int end, Endian endian)
      : super._(bytes, start, end, endian ?? Endian.host);

  int get vrCode => _getUint16(_vrOffset);

  static const _vrOffset = 4;
}

class EvrShortBytes extends EvrBytes {
  EvrShortBytes(Bytes bytes, int start, int end, Endian endian)
      : super._(bytes, start, end, endian ?? Endian.host);

  @override
  int get vfLengthOffset => _shortVFLengthOffset;
  @override
  int get vfOffset => _shortVFOffset;

  static const int _shortVFLengthOffset = 6;
  static const int _shortVFOffset = 8;
}

class EvrLongBytes extends EvrBytes {
  EvrLongBytes(Bytes bytes, int start, int end, Endian endian)
      : super._(bytes, start, end, endian ?? Endian.host);

  @override
  int get vfLengthOffset => _longVFLengthOffset;
  @override
  int get vfOffset => _longVFOffset;

  static const int _longVFLengthOffset = 8;
  static const int _longVFOffset = 12;
}

class IvrBytes<V> extends DicomBytes {
  IvrBytes(Bytes bytes, int start, int end, Endian endian)
      : super._(bytes, start, end, endian ?? Endian.host);

  @override
  int get vfLengthOffset => _vfLengthOffset;
  @override
  int get vfOffset => _vfOffset;

  static const int _vfLengthOffset = 4;
  static const int _vfOffset = 8;
}

abstract class DicomGrowableBytes extends GrowableBytes with DicomMixin {
  /// Returns a new [Bytes] of [length].
  DicomGrowableBytes(int length,
      [Endian endian = Endian.little, int limit = kDefaultLimit])
      : super._(length, endian, limit);

  DicomGrowableBytes.typedDataView(TypedData td,
      [int offset = 0,
      int lengthInBytes,
      Endian endian = Endian.little,
      int limit = _k1GB])
      : super._tdView(td, offset, lengthInBytes, endian, limit);
}
