//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:core/src/error/string_errors.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/utils/string/uuid_string.dart';
import 'package:core/src/values/uuid/errors.dart';
import 'package:core/src/values/uuid/v4generator.dart';

// ignore_for_file: public_member_api_docs

// Note: This implementation is faster than http:pub.dartlang.org/uuid
//   this one: Template(RunTime): 2101.890756302521 us.
//   pub uuid: Template(RunTime): 7402.2140221402215 us.

typedef Uint8List OnUuidBytesError(List<int> iList);
typedef Uuid OnUuidParseError(String s);
typedef Uint8List OnUuidParseToBytesError(String s);

/// Uuid Variants
enum UuidVariant { ncs, rfc4122, microsoft, reserved }

/// The type of random number generator.
enum GeneratorType { secure, pseudo, seededPseudo }

/// A Version 4 (random) Uuid.
/// See [RFC4122](https://tools.ietf.org/html/rfc4122).
///
/// As a [String] a [Uuid] is 36 US-Ascii characters long and
/// has the format:
///     'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx',
/// where each x is replaced with a random hexadecimal digit
/// from 0 to f, and y is replaced with a random hexadecimal
/// digit from 0x8 to  0xb, (i.e. 0x8, 0x9, 0xa, or 0xb).
///
/// See https://api.dartlang.org/stable/dart-math/Random-class.html.
class Uuid {
  /// A random V4 UUID generator.
  static V4Generator generator = V4Generator.secure;

  /// If _true_ uppercase letters will be used when converting
  /// [Uuid]s to [String]s; otherwise lowercase will be used.
  static bool useUppercase = false;

  /// The 16 bytes of UUID data.
  final Uint8List data;

  /// Constructs a Version 4 [Uuid]. If [isSecure] is _false_,
  /// it uses the Random RNG.  If [isSecure] is _true_, it uses
  /// the Random.secure RNG. The default is isSecure is _true_.
  Uuid() : data = generator.next;

  Uuid.pseudo() : data = V4Generator.pseudo.next;

  Uuid.seededPseudo() : data = V4Generator.seededPseudo.next;

  /// Constructs [Uuid] from a [List<int>] of 16 unsigned 8-bit [int]s.
  Uuid.fromList(List<int> iList, {OnUuidBytesError onError, bool coerce = true})
      : this.data = _uint8ListToBytes(iList, onError: onError, coerce: coerce);

  /// Two [Uuid]s are [==] if they contain equivalent [data].
  @override
  bool operator ==(Object other) {
    if (other is Uuid) {
      if (data.length != other.data.length) return false;
      for (var i = 0; i < _dataLengthInBytes; i++)
        if (data[i] != other.data[i]) return false;
      return true;
    }
    return false;
  }

  // Returns an [UnmodifiableListView] of [bytes].
  UnmodifiableListView<int> get value => UnmodifiableListView(data);

  @override
  int get hashCode => data.hashCode;

  /// Returns _true_ if _this_ is a valid Version 4 UUID, false otherwise.
  bool get isValid => _isValidV4List(data);

  /// Returns a copy of [data].
  UnmodifiableListView<int> get asUint8List => value;

  /// Returns the [Uuid] as a [String] in UUID format.
  String get asString => toString();

  /// Returns a hexadecimal [String] corresponding to _this_, but without
  /// the dashes ('-') that are present in the UUID format.
  String get asHex {
    final sb = StringBuffer();
    for (var i = 0; i < data.length; i++)
      sb.write(data[i].toRadixString(16).padLeft(2, '0').toLowerCase());
    return sb.toString();
  }

  /// Returns a [String] of decimal numbers that corresponds to _this_.
  String get asDecimal => _toDecimalString(data, '');

  /// Returns a [String] of decimal numbers that corresponds to _this_.
  String get asUid => _toDecimalString(data, '2.25.1');

  /// Returns the version number of _this_.
  int get version => data[6] >> 4;

  /// Returns true if this is a random or pseudo-random [Uuid].
  bool get isRandom => version == 4;

  // Variant returns UUID layout variant.
  UuidVariant get variant {
    if ((data[8] & 0x80) == 0x00) return UuidVariant.ncs;
    if (((data[8] & 0xc0) | 0x80) == 0x80) return UuidVariant.rfc4122;
    if (((data[8] & 0xe0) | 0xc0) == 0xc0) return UuidVariant.microsoft;
    return UuidVariant.microsoft;
  }

  /// Returns the [Uuid] [String] that corresponds to _this_.  By default,
  /// the hexadecimal characters are in lowercase; however, if
  /// [useUppercase] is _true_ the returned [String] is in uppercase.
  @override
  String toString() => _toUuidFormat(data);

  /// Sets the values of the default generator
  static bool setGenerator(GeneratorType type) {
    switch (type) {
      case GeneratorType.secure:
        generator = V4Generator.secure;
        break;
      case GeneratorType.pseudo:
        generator = V4Generator.pseudo;
        break;
      case GeneratorType.seededPseudo:
        generator = V4Generator.seededPseudo;
        break;
      default:
        throw UuidError('Invalid Uuid Generator Type: $type');
    }
    return true;
  }

  static String get generatePseudoDcmString => toUid(V4Generator.pseudo.next);

  static String get generateSecureDcmString => toUid(V4Generator.secure.next);

  /// Returns _true_ if a secure (_Random.secure_)
  /// random number generator is being used.
  static bool get isSecure => generator.isSecure;

  /// Returns the integer [seed] provided to the pseudo (non-secure)
  /// random number generator.
  static int get seed => generator.seed;

  /// Returns _true_ if [s] is a valid [Uuid] [String]. If [version] is _null_
  /// it just validates the format; otherwise, [version] must have a values
  /// between 1 and 5.
  static bool isValidString(String s, [int version]) =>
      isValidUuidString(s, version);

/*
  static bool _isValidString(String s, [int version]) {
    if (s.length != kUuidStringLength) return false;
    for (var pos in kDashes) if (s.codeUnitAt(pos) != kDash) return false;
    final lc = s.toLowerCase();
    for (var i = 0; i < kStarts.length; i++) {
      final start = kStarts[i];
      final end = kEnds[i];
      for (var j = start; j < end; j++) {
        final c = lc.codeUnitAt(j);
        if (!isHexChar(c)) return false;
      }
    }
    return (version == null) ? true : _isValidStringVersion(lc, version);
  }

  static bool isValidUuidString(String uuidString, [int type]) {
    if (uuidString.length != kUuidStringLength) return false;
    for (var pos in kDashes)
      if (uuidString.codeUnitAt(pos) != kDash) return false;
    final s = uuidString.toLowerCase();
    for (var i = 0; i < kStarts.length; i++) {
      final start = kStarts[i];
      final end = kEnds[i];
      for (var j = start; j < end; j++) {
        final c = s.codeUnitAt(j);
        if (!isHexChar(c)) return false;
      }
    }
    return (type == null) ? true : _isValidStringVersion(s, type);
  }
*/

/*
  /// Returns _true_
  static bool _isValidStringVersion(String s, int version) {
    if (version < 1 || version > 5)
      invalidUuidString('Invalid version number: $version');
    final _version = _getVersionNumberFromString(s);
    if (!_isISOVariantFromString(s) || _version != version) return false;
    // For certain versions, the checks we did up to this point are fine.
    if (_version != 3 || _version != 5) return true;
    throw UnimplementedError('Version 3 & 5 are not yet implemented');
  }

  static int _getVersionNumberFromString(String s) => s.codeUnitAt(14) - k0;

  static const List<int> _kISOVariantAsLetter = const <int>[k8, k9, ka, kb];

  static bool _isISOVariantFromString(String s) {
    final subType = s.codeUnitAt(19);
    return _kISOVariantAsLetter.contains(subType);
  }
*/

  static bool isNotValidString(String s, [int version]) =>
      !isValidString(s, version);

  /// Returns _true_ if [data] is a valid [Uuid] for [version]. If
  /// [version] is _null_ returns _true_ for any valid version.
  static bool isValidData(List<int> data, [int version]) =>
      _isValidUuid(data, version);

  /// Returns _true_ if [data] is NOT valid.
  static bool isNotValidData(List<int> data, [int version]) =>
      !isValidData(data, version);

  /// Returns a Uuid created from [s], if [s] is in valid Uuid format;
  /// otherwise, if [onError] is not _null_ calls [onError]([s])
  /// and returns its values. If [onError] is _null_, then a
  /// [UuidError] is thrown.
  static Uuid parse(String s, {Uint8List data, OnUuidParseError onError}) {
    final bytes = _parseToBytes(s, data, (s) => null, kUuidStringLength);
    if (bytes == null) {
      return (onError == null) ? null : onError(s);
    }
    return Uuid.fromList(bytes);
  }

  /// Unparses (converts [Uuid] to a [String]) [bytes] of bytes and
  /// outputs a proper UUID string.
  static String _toUuidFormat(Uint8List bytes) {
    var i = 0;
    final byteToHex =
        useUppercase ? _byteToUppercaseHex : _byteToLowercaseHex;
    return '${byteToHex[bytes[i++]]}${byteToHex[bytes[i++]]}'
        '${byteToHex[bytes[i++]]}${byteToHex[bytes[i++]]}-'
        '${byteToHex[bytes[i++]]}${byteToHex[bytes[i++]]}-'
        '${byteToHex[bytes[i++]]}${byteToHex[bytes[i++]]}-'
        '${byteToHex[bytes[i++]]}${byteToHex[bytes[i++]]}-'
        '${byteToHex[bytes[i++]]}${byteToHex[bytes[i++]]}'
        '${byteToHex[bytes[i++]]}${byteToHex[bytes[i++]]}'
        '${byteToHex[bytes[i++]]}${byteToHex[bytes[i++]]}';
  }

  /// Returns [bytes] as a UID [String] prefixed by [prefix].
  ///
  /// _Note_: The default [prefix] is '2.25.'.
  static String toUid(Uint8List bytes, [String prefix = '2.25.1']) =>
      _toDecimalString(bytes, prefix);

  // to make sure no string such as 2.25.0...'
  // is returned.
  /// Returns [bytes] as a decimal [String], with leading zeros removed,
  /// prefixed by [prefix].
  static String _toDecimalString(Uint8List bytes, String prefix) {
    assert(bytes.length == 16);
    final sb = StringBuffer(prefix);
    final v = bytes.buffer.asUint32List();
    for (var i = 0; i < v.length; i++) sb.write(v[i].toString());
    final s = sb.toString();
    int start;
    for (var i = 0; i < s.length; i++) {
      if (s[i] != '0') {
        start = i;
        break;
      }
    }
    return (start == 0) ? s : s.substring(start);
  }
}

// **** Internal Procedures ****

const int _dataLengthInBytes = 16;

// **** Utility functions for binary UUID values

/// This only validates ISO (IETF) [Uuid]s, i.e. those with Variant values = 2.
bool _isValidUuid(List<int> bytes, [int version]) {
  if (version != null && (version < 1 || version > 5))
    throw UuidError('Invalid version number: $version');
  final ok =
      bytes.length == 16 && _isISOVariant(bytes) && _hasValidVersion(bytes);
  if (!ok || (version != null && _version(bytes) != version)) return false;
  if (version != 5 || version != 3) return true;
  //Enhancement add V3 & V5
  // In order to do this we need getters and setters for the various fields.
  throw UnimplementedError('Version 3 & 5 UUIDs are not yet supported');
}

int _getVariant(Uint8List bytes) => bytes[8] >> 6;
bool _isISOVariant(Uint8List bytes) => _getVariant(bytes) == 2;

int _version(Uint8List bytes) => bytes[6] >> 4;

bool _isVersion4(Uint8List bytes) => bytes[6] >> 4 == 4;
bool _hasValidVersion(Uint8List bytes) =>
    _version(bytes) > 0 && _version(bytes) < 6;

bool _isValidV4List(Uint8List bytes) =>
    bytes.length == 16 && _isISOVariant(bytes) && _isVersion4(bytes);

// Converts uuid data to valid ISO Variant and Version 4.
// _Note_: Does not check that length == 16.
void _setToVersion4(Uint8List bytes) {
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
}

Uint8List _uint8ListToBytes(List<int> data,
    {OnUuidBytesError onError, bool coerce = true}) {
  if (data.length != 16)
    return badUuidList('Invalid Length(${data.length})', data);
  final bytes = _getDataBuffer(data);
  if (coerce) _setToVersion4(bytes);
  return bytes;
}

/// Parses the [String] [s] into a list of byte values.
/// Can optionally be provided a [Uint8List] to write into.
Uint8List _parseToBytes(
    String s, Uint8List data, OnUuidBytesError onError, int targetLength) {
  //if (s == null ||
  // (s.length != targetLength && s.length != kUuidAsUidStringLength))
  if (s == null || s.length != targetLength)
    return badUuidParse(s, targetLength);
  final bytes = _getDataBuffer(data);
  try {
    if (targetLength == 36) {
      if (s[8] != '-' || s[13] != '-' || s[18] != '-' || s[23] != '-')
        return badUuidParse(s, targetLength);
      _toBytes(s, bytes, 0, 0, 8);
      _toBytes(s, bytes, 4, 9, 13);
      _toBytes(s, bytes, 6, 14, 18);
      _toBytes(s, bytes, 8, 19, 23);
      _toBytes(s, bytes, 10, 24, kUuidStringLength);
    } else if (targetLength == kUuidAsUidStringLength) {
      _toBytes(s, bytes, 0, 0, kUuidAsUidStringLength);
    } else {
      return badUuidStringLength(s, targetLength);
    }
  } on UuidError {
    return badUuidCharacter(s);
  }
  return bytes;
}

/// Returns a valid [Uuid] data buffer. If [uuid] is _null_ a new
/// data buffer is created. If [uuid] is not _null_ and has length
/// 16, it is returned; otherwise, [badUuidList] is called.
Uint8List _getDataBuffer(List<int> uuid) {
  if (uuid == null) return Uint8List(16);
  if (uuid.length != 16)
    return badUuidList('Invalid Uuid List length: ${uuid.length}', uuid);
  if (uuid is Uint8List) return uuid;
  return Uint8List.fromList(uuid);
}

/// Converts characters from a String into the corresponding byte values.
Null _toBytes(String s, Uint8List bytes, int byteIndex, int start, int end) {
  var index = byteIndex ?? 0;
  for (var i = start; i < end; i += 2) {
    if (!isHexChar(s.codeUnitAt(i)) || !isHexChar(s.codeUnitAt(i + 1))) {
      throw UuidError('Bad UUID character: "${s[i]}${s[i + 1]}" in "$s"');
    }
    bytes[index++] = _hexToByte[s.substring(i, i + 2)];
  }
}

// *** Generated by 'tools/generate_conversions.dart' ***

//TODO Jim: add to string package
/// Returns the Hex [String] equivalent to an 8-bit [int].
const List<String> _byteToLowercaseHex = [
  '00', '01', '02', '03', '04', '05', '06', '07', // No reformat
  '08', '09', '0a', '0b', '0c', '0d', '0e', '0f',
  '10', '11', '12', '13', '14', '15', '16', '17',
  '18', '19', '1a', '1b', '1c', '1d', '1e', '1f',
  '20', '21', '22', '23', '24', '25', '26', '27',
  '28', '29', '2a', '2b', '2c', '2d', '2e', '2f',
  '30', '31', '32', '33', '34', '35', '36', '37',
  '38', '39', '3a', '3b', '3c', '3d', '3e', '3f',
  '40', '41', '42', '43', '44', '45', '46', '47',
  '48', '49', '4a', '4b', '4c', '4d', '4e', '4f',
  '50', '51', '52', '53', '54', '55', '56', '57',
  '58', '59', '5a', '5b', '5c', '5d', '5e', '5f',
  '60', '61', '62', '63', '64', '65', '66', '67',
  '68', '69', '6a', '6b', '6c', '6d', '6e', '6f',
  '70', '71', '72', '73', '74', '75', '76', '77',
  '78', '79', '7a', '7b', '7c', '7d', '7e', '7f',
  '80', '81', '82', '83', '84', '85', '86', '87',
  '88', '89', '8a', '8b', '8c', '8d', '8e', '8f',
  '90', '91', '92', '93', '94', '95', '96', '97',
  '98', '99', '9a', '9b', '9c', '9d', '9e', '9f',
  'a0', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7',
  'a8', 'a9', 'aa', 'ab', 'ac', 'ad', 'ae', 'af',
  'b0', 'b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7',
  'b8', 'b9', 'ba', 'bb', 'bc', 'bd', 'be', 'bf',
  'c0', 'c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7',
  'c8', 'c9', 'ca', 'cb', 'cc', 'cd', 'ce', 'cf',
  'd0', 'd1', 'd2', 'd3', 'd4', 'd5', 'd6', 'd7',
  'd8', 'd9', 'da', 'db', 'dc', 'dd', 'de', 'df',
  'e0', 'e1', 'e2', 'e3', 'e4', 'e5', 'e6', 'e7',
  'e8', 'e9', 'ea', 'eb', 'ec', 'ed', 'ee', 'ef',
  'f0', 'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7',
  'f8', 'f9', 'fa', 'fb', 'fc', 'fd', 'fe', 'ff'
];

/// Returns the Hex [String] equivalent to an 8-bit [int].
const List<String> _byteToUppercaseHex = [
  '00', '01', '02', '03', '04', '05', '06', '07', // No reformat
  '08', '09', '0A', '0B', '0C', '0D', '0E', '0F',
  '10', '11', '12', '13', '14', '15', '16', '17',
  '18', '19', '1A', '1B', '1C', '1D', '1E', '1F',
  '20', '21', '22', '23', '24', '25', '26', '27',
  '28', '29', '2A', '2B', '2C', '2D', '2E', '2F',
  '30', '31', '32', '33', '34', '35', '36', '37',
  '38', '39', '3A', '3B', '3C', '3D', '3E', '3F',
  '40', '41', '42', '43', '44', '45', '46', '47',
  '48', '49', '4A', '4B', '4C', '4D', '4E', '4F',
  '50', '51', '52', '53', '54', '55', '56', '57',
  '58', '59', '5A', '5B', '5C', '5D', '5E', '5F',
  '60', '61', '62', '63', '64', '65', '66', '67',
  '68', '69', '6A', '6B', '6C', '6D', '6E', '6F',
  '70', '71', '72', '73', '74', '75', '76', '77',
  '78', '79', '7A', '7B', '7C', '7D', '7E', '7F',
  '80', '81', '82', '83', '84', '85', '86', '87',
  '88', '89', '8A', '8B', '8C', '8D', '8E', '8F',
  '90', '91', '92', '93', '94', '95', '96', '97',
  '98', '99', '9A', '9B', '9C', '9D', '9E', '9F',
  'A0', 'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7',
  'A8', 'A9', 'AA', 'AB', 'AC', 'AD', 'AE', 'AF',
  'B0', 'B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7',
  'B8', 'B9', 'BA', 'BB', 'BC', 'BD', 'BE', 'BF',
  'C0', 'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7',
  'C8', 'C9', 'CA', 'CB', 'CC', 'CD', 'CE', 'CF',
  'D0', 'D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7',
  'D8', 'D9', 'DA', 'DB', 'DC', 'DD', 'DE', 'DF',
  'E0', 'E1', 'E2', 'E3', 'E4', 'E5', 'E6', 'E7',
  'E8', 'E9', 'EA', 'EB', 'EC', 'ED', 'EE', 'EF',
  'F0', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7',
  'F8', 'F9', 'FA', 'FB', 'FC', 'FD', 'FE', 'FF'
];

//TODO Jim: add to string package
/// Returns the 8-bit [int] equivalent to the Hex [String].
const Map<String, int> _hexToByte = {
  '00': 0, '01': 1, '02': 2, '03': 3, '04': 4, '05': 5, // No reformat
  '06': 6, '07': 7, '08': 8, '09': 9, '0a': 10, '0b': 11,
  '0c': 12, '0d': 13, '0e': 14, '0f': 15, '10': 16, '11': 17,
  '12': 18, '13': 19, '14': 20, '15': 21, '16': 22, '17': 23,
  '18': 24, '19': 25, '1a': 26, '1b': 27, '1c': 28, '1d': 29,
  '1e': 30, '1f': 31, '20': 32, '21': 33, '22': 34, '23': 35,
  '24': 36, '25': 37, '26': 38, '27': 39, '28': 40, '29': 41,
  '2a': 42, '2b': 43, '2c': 44, '2d': 45, '2e': 46, '2f': 47,
  '30': 48, '31': 49, '32': 50, '33': 51, '34': 52, '35': 53,
  '36': 54, '37': 55, '38': 56, '39': 57, '3a': 58, '3b': 59,
  '3c': 60, '3d': 61, '3e': 62, '3f': 63, '40': 64, '41': 65,
  '42': 66, '43': 67, '44': 68, '45': 69, '46': 70, '47': 71,
  '48': 72, '49': 73, '4a': 74, '4b': 75, '4c': 76, '4d': 77,
  '4e': 78, '4f': 79, '50': 80, '51': 81, '52': 82, '53': 83,
  '54': 84, '55': 85, '56': 86, '57': 87, '58': 88, '59': 89,
  '5a': 90, '5b': 91, '5c': 92, '5d': 93, '5e': 94, '5f': 95,
  '60': 96, '61': 97, '62': 98, '63': 99, '64': 100, '65': 101,
  '66': 102, '67': 103, '68': 104, '69': 105, '6a': 106, '6b': 107,
  '6c': 108, '6d': 109, '6e': 110, '6f': 111, '70': 112, '71': 113,
  '72': 114, '73': 115, '74': 116, '75': 117, '76': 118, '77': 119,
  '78': 120, '79': 121, '7a': 122, '7b': 123, '7c': 124, '7d': 125,
  '7e': 126, '7f': 127, '80': 128, '81': 129, '82': 130, '83': 131,
  '84': 132, '85': 133, '86': 134, '87': 135, '88': 136, '89': 137,
  '8a': 138, '8b': 139, '8c': 140, '8d': 141, '8e': 142, '8f': 143,
  '90': 144, '91': 145, '92': 146, '93': 147, '94': 148, '95': 149,
  '96': 150, '97': 151, '98': 152, '99': 153, '9a': 154, '9b': 155,
  '9c': 156, '9d': 157, '9e': 158, '9f': 159, 'a0': 160, 'a1': 161,
  'a2': 162, 'a3': 163, 'a4': 164, 'a5': 165, 'a6': 166, 'a7': 167,
  'a8': 168, 'a9': 169, 'aa': 170, 'ab': 171, 'ac': 172, 'ad': 173,
  'ae': 174, 'af': 175, 'b0': 176, 'b1': 177, 'b2': 178, 'b3': 179,
  'b4': 180, 'b5': 181, 'b6': 182, 'b7': 183, 'b8': 184, 'b9': 185,
  'ba': 186, 'bb': 187, 'bc': 188, 'bd': 189, 'be': 190, 'bf': 191,
  'c0': 192, 'c1': 193, 'c2': 194, 'c3': 195, 'c4': 196, 'c5': 197,
  'c6': 198, 'c7': 199, 'c8': 200, 'c9': 201, 'ca': 202, 'cb': 203,
  'cc': 204, 'cd': 205, 'ce': 206, 'cf': 207, 'd0': 208, 'd1': 209,
  'd2': 210, 'd3': 211, 'd4': 212, 'd5': 213, 'd6': 214, 'd7': 215,
  'd8': 216, 'd9': 217, 'da': 218, 'db': 219, 'dc': 220, 'dd': 221,
  'de': 222, 'df': 223, 'e0': 224, 'e1': 225, 'e2': 226, 'e3': 227,
  'e4': 228, 'e5': 229, 'e6': 230, 'e7': 231, 'e8': 232, 'e9': 233,
  'ea': 234, 'eb': 235, 'ec': 236, 'ed': 237, 'ee': 238, 'ef': 239,
  'f0': 240, 'f1': 241, 'f2': 242, 'f3': 243, 'f4': 244, 'f5': 245,
  'f6': 246, 'f7': 247, 'f8': 248, 'f9': 249, 'fa': 250, 'fb': 251,
  'fc': 252, 'fd': 253, 'fe': 254, 'ff': 255
};
