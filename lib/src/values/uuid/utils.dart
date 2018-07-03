//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

/*  Flush at V0.9.0 if not needed
import 'dart:math';
import 'dart:typed_data';

/// Unparses (converts) a [Uuid]'s [Uint8List] values to a 32-character

/// [String] without dashes.
String _toUuidString(Uint8List bytes, {int offset = 0, bool useUppercase = false}) {
	StringBuffer sb = new StringBuffer();
	List<String> byteToHex = (useUppercase) ? _byteToUppercaseHex : _byteToLowercaseHex;
	for (int i = offset; i < offset + 16; i++) sb.write(byteToHex[bytes[i]]);
	return sb.toString();
}


Uint8List _getBytes(Random rng) {
  final bytes = new Uint8List(16);
  final int32 = bytes.buffer.asUint32List();
  for (var i = 0; i < 4; i++) int32[i] = rng.nextInt(0xFFFFFFFF);
  _setToVersion4(bytes);
  return bytes;
}
/


// Converts uuid data to valid ISO Variant and Version 4.
// _Note_: Does not check that length == 16.
void _setToVersion4(Uint8List bytes) {
	bytes[6] = (bytes[6] & 0x0f) | 0x40;
	bytes[8] = (bytes[8] & 0x3f) | 0x80;
}

void _setVersion(List<int> bytes) => (bytes[6] & 0x0f) | 0x40;

void _setVariantToIETF(List<int> bytes) => (bytes[8] & 0xbf) | 0x80;
void _setVariantToNCS(List<int> bytes) => bytes[8] | 0x80;
void _setVariantToMicrosoft(List<int> bytes) => (bytes[8] & 0x1f) | 0xC0;
void _setVariantToReserved(List<int> bytes) => (bytes[8] & 0x1f) | 0xE0;

// The most significant bit of octet 8: 1 0 x
/// Returns the UUID Version number from a UUID [String].
/// Extracts the version from the UUID, which is (by definition) the M in
///    xxxxxxxx-xxxx-Mxxx-Nxxx-xxxxxxxxxxxx
/// The version is equal to the 'M' in the format above. It must have
/// a values between 1 and 4 inclusive.
String _getVersionAsString(String s) => s[14];
*/
