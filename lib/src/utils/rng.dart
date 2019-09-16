//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:math';
import 'dart:typed_data';

import 'package:constants/constants.dart';
import 'package:core/src/values.dart';
import 'package:core/src/utils/character/ascii.dart';

// ignore_for_file: public_member_api_docs

/// Random Number Generator with useful utilities.
//TODO: document
class RNG {
  final bool isSecure;
  final int defaultMinStringLength;
  final int defaultMaxStringLength;
  final int defaultMinListLength;
  final int defaultMaxListLength;

  final int seed;
  final Random generator;

  /// Creates a Random Number Generator ([RNG]) using Dart's [Random].
  factory RNG([int seed]) => RNG.withDefaults(isSecure: false, seed: seed);

  /// Creates a **_secure_** Random Number Generator ([RNG]) using Dart's
  /// [Random.secure].
  factory RNG.secure() => RNG.withDefaults(isSecure: true);

  RNG.withDefaults({
    this.isSecure = false,
    this.seed,
    this.defaultMinStringLength = 4,
    this.defaultMaxStringLength = 1024,
    this.defaultMinListLength = 1,
    this.defaultMaxListLength = 256,
  }) : generator = isSecure ? Random.secure() : Random(seed);

  /// Returns a random boolean ([bool]).
  bool get nextBool => generator.nextBool();

  /// Returns a random 8-bit signed integer ([int]).
  int get nextInt8 => _nextInt32(kInt8Min, kInt8Max);

  /// Returns a random 16-bit signed integer ([int]).
  int get nextInt16 => _nextInt32(kInt16Min, kInt16Max);

  /// Returns a random 32-bit signed integer ([int]).
  int get nextInt32 => _nextInt32(kInt32Min, kInt32Max);

  /// Returns a random 64-bit signed integer ([int]).
  int get nextInt64 => _nextSMUint();

  /// Returns a random 7-bit unsigned integer ([int]), i.e. an ASCII code unit.
  int get nextUint7 => _nextUint32(0, 127);

  /// Returns a random 8-bit unsigned integer ([int]).
  int get nextUint8 => _nextUint32(0, kUint8Max);

  /// Returns a random 16-bit unsigned integer ([int]).
  int get nextUint16 => _nextUint32(0, kUint16Max);

  /// Returns a random 32-bit unsigned integer ([int]).
  int get nextUint32 => _nextUint32(0, kUint32Max);

  /// Returns a random 64-bit unsigned integer ([int]).
  int get nextUint64 => _nextSMUint();

  /// Returns a [double] between 0 and 1.
  double get nextDouble => generator.nextDouble();

  //TODO: Unit test.
  /// Returns a [double] between the most-negative and most-positive 32-bit
  /// signed integers.
  double get nextFloat => nextDouble * nextInt32;

  static final Float32List _float32 = Float32List(1);

  /// Returns a double in the range of an IEEE 32-bit floating point number.
  double get nextFloat32 {
    final n = nextDouble;
    _float32[0] = n;
    //TODO: remove after confirming NaNs are not generated
    // ignore: only_throw_errors
    if (_float32[0].isNaN) throw 'NaN: ${_float32[0]}';
    return _float32[0];
  }

  /// Synonym for [nextDouble].
  double get nextFloat64 => nextDouble;

  /// Returns an ASCII character (code point), i.e. in range 0 - 127 inclusive.
  int get nextAscii => nextUint7;

  /// Returns a visible (printing) ASCII character (code point),
  /// i.e. in range 32 - 126 inclusive.
  int get nextAsciiVChar => _nextUint32(kSpace, kTilde);

  int get nextAsciiDigit => _nextUint32(k0, k9);

  // TODO: Unit test
  int get nextAsciiWordChar => _nextAsciiWordChar();

  int _nextAsciiWordChar() {
    final c = _nextUint32(k0, kz);
    if (isWordChar(c)) return c;
    return _nextAsciiWordChar();
  }

  /// Returns a Utf8 code point, i.e. between 32 and 255.
  int get nextUtf8 => _nextUint32(32, 255);

  String get nextDigit => String.fromCharCode(nextAsciiDigit);

  // TODO: Unit test
  int get nextMicrosecond => _nextMicrosecond();

  int _nextMicrosecond() {
    final us = _nextSMInt();
    if (isValidEpochMicroseconds(us)) return us;
    return _nextMicrosecond();
  }

  /// Returns a random String with sign + 1 - 11 digits
  String nextIntString([int minLength = 1, int maxLength = 12]) {
    RangeError.checkValidRange(1, minLength, maxLength);
    RangeError.checkValidRange(minLength, maxLength, 12);
    final len = _getLength(minLength, maxLength);
    if (len == 1) return nextDigit;
    final sb = StringBuffer();

    final sign = nextBool;
    if (sign == true) {
      sb.writeCharCode(kMinusSign);
    } else {
      sb.writeCharCode(kPlusSign);
    }

    sb.writeCharCode(nextAsciiDigit);
    for (var i = sb.length; i < len; i++) sb.writeCharCode(nextAsciiDigit);
    final s = sb.toString();
    RangeError.checkValidRange(1, s.length, 16);
    return s;
  }

  String nextAsciiWord([int minLength = 1, int maxLength = 16]) {
    final len = _getLength(minLength, maxLength);
    final sb = StringBuffer();
    for (var i = 0; i < len; i++) {
      final c = nextAsciiWordChar;
      // ignore: only_throw_errors
      if (!isWordChar(c)) throw 'Invalid Word Char: $c';
      sb.writeCharCode(c);
    }
    final s = sb.toString();
    return s;
  }

  static bool _always(int c) => true;

  /// Returns an ASCII character (code point). [predicate]
  /// defaults to always _true_.
  int nextAsciiSatisfying([bool Function(int) predicate = _always]) {
    final c = nextUint7;
    return (predicate(c)) ? c : nextAsciiSatisfying(predicate);
  }

  /// Returns a 32-bit random number between [min] and [max] inclusive.
  int _nextUint32(int minimum, int maximum) {
    final limit = maximum - minimum;
    assert(limit <= 0xFFFFFFFF);
    return generator.nextInt(limit + 1) + minimum;
  }

  static const int kMinRandomInt = 1;
  static const int kMaxRandomIntExclusive = 1 << 32;
  static const int kMaxRandomIntInclusive = kMaxRandomIntExclusive - 1;
  static const int kMinRandom31BitIntExclusive = -0x40000000;
  static const int kMinRandom31BitIntInclusive =
      kMinRandom31BitIntExclusive + 1;
  static const int kMaxRandom31BitIntExclusive = 0x40000000;
  static const int kMaxRandom31BitIntInclusive =
      kMaxRandom31BitIntExclusive - 1;

  /// Returns a 63-bit integer (DartSMInt) in the range from [min]
  /// to [max] inclusive.
  ///
  /// Note: [min] and [max] can be negative, but [min] must be less than [max].
  int nextInt([int min = kUint64Min, int max = kUint16Max]) {
    RangeError.checkValueInInterval(min, kUint16Min, kUint16Max, 'min');
    RangeError.checkValueInInterval(max, min, kUint16Max, 'max');
    var limit = _getLimit(min, max);
    if (limit > kUint16Max) limit = kUint16Max;
    if (limit < 0 || limit > kUint16Max)
      // ignore: only_throw_errors
      throw 'Invalid range error: '
          '$kUint16Min > $max - $min = $limit < $kUint16Max';
    final n = (limit < kUint32Max)
        ? __nextUint32(limit)
        : _nextSMUint().remainder(limit);
    return n + min;
  }

  // Returns a 32-bit unsigned integer in the range from -[limit] to [limit]
  // inclusive. _Note_: 0 <= [limit] <= 0xFFFFFFFF.
  int __nextUint32(int limit) => generator.nextInt(limit + 1);

  // Always returns a positive integer that is less than Int32Max.
  int _getLimit(int min, int max) {
    assert(min >= kUint16Min && max <= kUint16Max && min <= max);
    final limit = max - min;
    return (limit < 0) ? -limit : limit;
  }

  // Returns a 32-bit signed integer in the range from -[limit] to [limit]
  // inclusive. _Note_: 0 <= [limit] <= 0xFFFFFFFF.
  int _nextInt32([int min = kInt32Min, int max = kInt32Max]) {
    assert(min != null && max != null);
    final limit = _getLimit32(min, max);
    return generator.nextInt(limit + 1) + min;
  }

  // Always returns a positive integer that is less than Int32Max.
  int _getLimit32(int min, int max) {
    assert(min >= kInt32Min);
    assert(max <= kInt32Max);
    var limit = max - min;
    if (limit < 0) limit = -limit;
    if (limit > kUint32Max) limit = kUint32Max;
    return limit;
  }

  // TODO: See _nextSMInt issue is same
  /// Returns a 64-bit random unsigned integer _n_, in the range
  /// 0 >= n <= [kUint16Max]
  int _nextSMUint() {
    final upper = generator.nextInt(kMaxRandom30BitInt);
    final lower = generator.nextInt(kMaxRandomIntExclusive);
    final n = (upper << 32) | lower;
    assert(n >= 0 && n <= kUint16Max);
    return n;
  }

  // TODO:
  // This was designed for V1 with only supported 63-bit [int]s.
  // Currently the V2 DartVM supports 64-but [int]s, and this should
  // change; but JavaScript only supports 54-bit [int]s.
  // However, it is a breaking change; so, Major version must increase by 1.
  /// Returns a 63-bit random signed integer _n_, in the range
  /// [kDartMinSMInt >= n <= [kDartMaxSMInt]
  int _nextSMInt() {
    final upper = generator.nextInt(kMaxRandom30BitInt);
    final lower = generator.nextInt(kMaxRandomIntExclusive);
    var n = (upper << 32) | lower;
    n = (generator.nextBool()) ? n : -n;
    assert(n >= kUint16Min && n <= kUint16Max,
        '$kUint16Min <= $n ${n.toRadixString(16)} <= $kUint16Max');
    return n;
  }

  static const int kMaxRandom30BitInt = 0x3FFFFFFF;

  // TODO: See _nextSMInt issue is same
  /// Returns a 63-bit random number between [min] and [max] inclusive,
  /// Where [min] >= 0, and [max] >= min && [max] <= 0xFFFFFFFF.
  int nextUint([int min = 0, int max = kUint16Max]) {
    RangeError.checkValueInInterval(min, 0, kUint16Max, 'min');
    RangeError.checkValueInInterval(max, min, kUint16Max, 'max');
    var limit = max - min;
    if (limit > kUint16Max) limit = kUint16Max;
    if (limit < 0 || limit > kUint16Max)
      // ignore: only_throw_errors
      throw 'Invalid range error: 0 > $max - $min = $limit < 0xFFFFFFFF';
    return (limit < kUint32Max)
        ? generator.nextInt(limit + 1) + min
        : _nextSMUint().remainder(limit + 1);
  }

  /// Returns [String] containing visible ASCII code points, i.e. between
  /// [kSpace](32) and [kDelete] - 1(126). If [length] is specified, the
  /// returned [String] will have that [length]; otherwise, it will have
  /// a random length, between 4 and 1024 inclusive.
  Uint8List asciiString([int length]) {
    length ??= nextUint(defaultMinStringLength, 1024);
    RangeError.checkValueInInterval(length, 0, 4096, 'length');
    final v = Uint8List(length);
    for (var i = 0; i < length; i++) v[i] = nextAsciiVChar;
    return v;
  }

  /// Returns [String] of [length] containing UTF-8 code units in the range
  /// from 0 to 255. If [length] is specified, the returned [String] will
  /// have that [length]; otherwise, it will have a random length, between 4
  /// and 1024 inclusive. _Note_: While the returned [String] will contain
  /// UTF-8 code units, they will not necessarily be valid code points.
  Uint8List utf8String([int length]) {
    length ??= nextUint(defaultMinStringLength, 1024);
    RangeError.checkValueInInterval(length, 0, 4096, 'length');
    final v = Uint8List(length);
    for (var i = 0; i < length; i++) v[i] = nextUint8;
    return v;
  }

  /// Returns a random a length between [minLength] and [maxLength] inclusive.
  /// [minLength] must be greater than or equal to 0, and [maxLength] must
  /// be less than or equal to 2^31-1, i.e. the maximum 32-bit signed positive
  /// integer.
  int getLength([int minLength, int maxLength]) =>
      _getLength(minLength, maxLength);

  int _getLength([int minLength, int maxLength]) {
    if (maxLength == 0) return 0;
    final min = (minLength == null) ? defaultMinListLength : minLength;
    final max = (maxLength == null) ? defaultMaxListLength : maxLength;
    RangeError.checkValidRange(0, min, kInt32Max, 'minLength');
    RangeError.checkValidRange(min, max, kInt32Max, 'maxLength');
    return nextUint(minLength, maxLength);
  }

  /// Returns a random [List<int>] with a length between [minLength] and
  /// [maxLength] inclusive. The [List] will contain integers in the range
  /// [minValue] to [maxValue] inclusive. [minValue] and [maxValue] must be
  /// valid 32-bit integers. [minLength] defaults to 1, and [maxLength]
  /// defaults to 256.
  List<int> intList(int minValue, int maxValue,
      [int minLength, int maxLength]) {
    RangeError.checkValueInInterval(minValue, kInt32Min, kInt32Max, 'minValue');
    RangeError.checkValueInInterval(maxValue, minValue, kInt32Max, 'maxValue');
    final len = _getLength(minLength, maxLength);
    final vList = List<int>(len);
    for (var i = 0; i < len; i++) vList[i] = nextInt(minValue, maxValue);
    return vList;
  }

  ByteData byteDataList(int minValue, int maxValue,
      [int minLength, int maxLength]) {
    RangeError.checkValueInInterval(minValue, kUint8Min, kUint8Max, 'minValue');
    RangeError.checkValueInInterval(maxValue, minValue, kUint32Max, 'maxValue');
    final len = _getLength(minLength, maxLength);
    final vList = ByteData(len);
    for (var i = 0; i < len; i++)
      vList.setUint8(i, nextInt(minValue, maxValue));
    return vList;
  }

  /// Returns a random [List<int>] with a length between [minLength] and
  /// [maxLength] inclusive. The [List] will contain 8-bit signed integers.
  Int8List int8List([int minLength, int maxLength]) {
    final length = _getLength(minLength, maxLength);
    final v = Int8List(length);
    for (var i = 0; i < length; i++) v[i] = nextInt8;
    return v;
  }

  /// Returns a random [Int16List] with a length between [minLength] and
  /// [maxLength] inclusive. The [List] will contain 16-bit signed integers.
  Int16List int16List([int minLength, int maxLength]) {
    final length = _getLength(minLength, maxLength);
    final v = Int16List(length);
    for (var i = 0; i < length; i++) v[i] = nextInt16;
    return v;
  }

  /// Returns a random [Int32List] with a length between [minLength] and
  /// [maxLength] inclusive. The [List] will contain 32-bit signed integers.
  Int32List int32List([int minLength, int maxLength]) {
    final length = _getLength(minLength, maxLength);
    final v = Int32List(length);
    for (var i = 0; i < length; i++) v[i] = nextInt32;
    return v;
  }

  /// Returns a random [Int64List] with a length between [minLength] and
  /// [maxLength] inclusive. The [List] will contain 64-bit signed integers.
  Int64List int64List([int minLength, int maxLength]) {
    final length = _getLength(minLength, maxLength);
    final v = Int64List(length);
    for (var i = 0; i < length; i++) v[i] = nextInt64;
    return v;
  }

  /// Returns a random [Uint8List] with a length between [minLength] and
  /// [maxLength] inclusive. The [List] will contain 8-bit unsigned integers.
  Uint8List uint8List([int minLength, int maxLength]) {
    final length = _getLength(minLength, maxLength);
    final v = Uint8List(length);
    for (var i = 0; i < length; i++) v[i] = nextUint8;
    return v;
  }

  /// Returns a random [Uint16List] with a length between [minLength] and
  /// [maxLength] inclusive. The [List] will contain 16-bit unsigned integers.
  Uint16List uint16List([int minLength, int maxLength]) {
    final length = _getLength(minLength, maxLength);
    final v = Uint16List(length);
    for (var i = 0; i < length; i++) v[i] = nextUint16;
    return v;
  }

  /// Returns a random [Uint32List] with a length between [minLength] and
  /// [maxLength] inclusive. The [List] will contain 32-bit unsigned integers.
  Uint32List uint32List([int minLength, int maxLength]) {
    final length = _getLength(minLength, maxLength);
    final v = Uint32List(length);
    for (var i = 0; i < length; i++) v[i] = nextUint32;
    return v;
  }

  /// Returns a random [Uint64List] with a length between [minLength] and
  /// [maxLength] inclusive. The [List] will contain 64-bit unsigned integers.
  Uint64List uint64List([int minLength, int maxLength]) {
    final length = _getLength(minLength, maxLength);
    final v = Uint64List(length);
    for (var i = 0; i < length; i++) v[i] = nextUint64;
    return v;
  }

  /// Returns a random [List<double>] with a length between [minLength] and
  /// [maxLength] inclusive.
  List<double> listOfDouble([int minLength = 1, int maxLength = 1000]) {
    final len = _getLength(minLength, maxLength);
    final vList = List<double>(len);
    for (var i = 0; i < len; i++) vList[i] = nextDouble;
    return vList;
  }

  /// Returns a random [List<double>] with a length between [minLength] and
  /// [maxLength] inclusive.
  List<double> listOfFloat32([int minLength, int maxLength]) {
    final len = _getLength(minLength, maxLength);
    final vList = List<double>(len);
    for (var i = 0; i < len; i++) vList[i] = nextFloat32;
    return vList;
  }

  /// Returns a random [Float32List] with a length between [minLength] and
  /// [maxLength] inclusive. The [List] will contain 32-bit floating point
  /// numbers.
  Float32List float32List([int minLength, int maxLength]) {
    final length = _getLength(minLength, maxLength);
    final v = Float32List(length);
    for (var i = 0; i < length; i++) v[i] = nextFloat32;
    return v;
  }

  /// Returns a random [Float64List] with a length between [minLength] and
  /// [maxLength] inclusive. The [List] will contain 64-bit floating point
  /// numbers.
  Float64List float64List([int minLength, int maxLength]) {
    final length = _getLength(minLength, maxLength);
    final v = Float64List(length);
    for (var i = 0; i < length; i++) v[i] = nextFloat64;
    return v;
  }
}
