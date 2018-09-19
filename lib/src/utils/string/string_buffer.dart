//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/utils/character/ascii.dart';
import 'package:core/src/values/integer.dart';

// ignore_for_file: public_member_api_docs

//TODO: finish this package  or remove

List<int> _copyBuffer(List<int> oldBuf, List<int> newBuf) {
  for (var i = 0; i < oldBuf.length; i++) newBuf[i] = oldBuf[i];
  return newBuf;
}

int _getNewBufferLength(String s) =>
    (s == null || s.length < 32) ? 64 : s.length * 2;

abstract class StringBufferBase {
  // **** Interface ****
  List<int> get _sBuffer;

  /// Returns [c] if it is a valid character code; otherwise, throw and
  /// [InvalidValueError].
  int _checkValue(int c);

  /// Increases the size of the current buffer and returns the [remaining].
  int growBuffer();

  List<int> _getData();
  // **** End Interface ****

  int get _maxLength => 0xFFFF;
  int _index = 0;

  // Unsafe - [c] and [_index] must be valid;
  void _put(int c) {
    _sBuffer[_index] = c;
    _index++;
  }

  List<int> get typedData => _sBuffer;

  /// Returns the character ([int]) at [index];
  int operator [](int index) => _sBuffer[index];

  void operator []=(int index, int c) => _sBuffer[index] = _checkValue(c);

  int get length => _sBuffer.length;

  int get index => (_index >= length) ? _grow() : _index;
  int get remaining => _sBuffer.length - _index;

  String get info => '$runtimeType($length): "${toString()}"';

  void writeCharCode(int code) {
    final i = index;
    _sBuffer[i] = _checkValue(code);
    _index++;
  }

  /// Appends [s] to the end of the [StringBuffer].
  void write(String s) {
    _ensureSpace(s.length);
    for (var i = 0; i < s.length; i++) _put(s.codeUnitAt(i));
  }

  void writeLn(String s) {
    _ensureSpace(s.length + 1);
    write(s);
    _put(knewline);
  }

  String padString(int length, String padChar) => ''.padRight(length, padChar);

  /// Returns the length of the unwritten part of the buffer.
  int _ensureSpace(int length) => (remaining < length) ? _grow() : remaining;

  /// If necessary increases the size of the buffer up to [_maxLength]. If
  /// ```[length] >= [maxLength]``` throws a [StringBufferOverflowError].
  /// Returns the length of the unused part of the [StringBuffer].
  int _grow() {
    if (_sBuffer.length < _maxLength) {
      return growBuffer();
    } else {
      throw new StringBufferOverflowError(this);
    }
  }

  /// Returns the contents of the [StringBuffer] as a [String].
  @override
  String toString() => new String.fromCharCodes(_getData());
}

class AsciiBuffer extends StringBufferBase implements TypedData {
  @override
  Uint8List _sBuffer;

  AsciiBuffer([String s]) : _sBuffer = new Uint8List(_getNewBufferLength(s)) {
    if (s != null && s != '') write(s);
  }

  @override
  ByteBuffer get buffer => _sBuffer.buffer;
  @override
  int get offsetInBytes => _sBuffer.offsetInBytes;
  @override
  int get lengthInBytes => _sBuffer.lengthInBytes;
  @override
  int get elementSizeInBytes => _sBuffer.elementSizeInBytes;

  @override
  int _checkValue(int c) => (c < 0 || c > 255) ? invalidCharacterError(c) : c;

  @override
  int growBuffer() {
    _sBuffer = _copyBuffer(_sBuffer, new Uint8List(length * 2));
    return remaining;
  }

  @override
  Uint8List _getData() => _sBuffer.buffer.asUint8List(0, _index);
}

class Utf8Buffer extends StringBufferBase implements TypedData {
  @override
  Uint16List _sBuffer;

  Utf8Buffer([int length = 16]) : _sBuffer = new Uint16List(length);

  @override
  ByteBuffer get buffer => _sBuffer.buffer;
  @override
  int get offsetInBytes => _sBuffer.offsetInBytes;
  @override
  int get lengthInBytes => _sBuffer.lengthInBytes;
  @override
  int get elementSizeInBytes => _sBuffer.elementSizeInBytes;

  @override
  void writeCharCode(int code) => _sBuffer[index] = _checkValue(code);

  @override
  int _checkValue(int c) =>
      (c < 0 || c > kUint16Max) ? invalidCharacterError(c) : c;

  @override
  int growBuffer() {
    _sBuffer = _copyBuffer(_sBuffer, new Uint16List(length * 2));
    return remaining;
  }

  @override
  Uint8List _getData() => _sBuffer.buffer.asUint8List(0, _index);
}

Null indexOverflow(int index, int length) =>
    throw new RangeError('Index overflow: index($index) >= length($length)');

class StringBufferOverflowError extends Error {
  StringBufferBase buffer;

  StringBufferOverflowError(this.buffer);

  @override
  String toString() => 'Buffer Overflow Error: ${buffer.info}';
}

class InvalidValueError extends Error {
  String type;
  Object value;

  InvalidValueError(this.type, this.value);

  @override
  String toString() => 'InvalidValueError($type): $value';
}

int invalidCharacterError(int char) {
  throw new InvalidValueError('character', char);
}
