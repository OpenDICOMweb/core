//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/vr/vr_base.dart';

/// Return the VR Code field from a Bytes Element.
int getVRCodeFromBytes(Bytes bytes, [int start = 0]) {
  final offset = start + kVROffset;
  return (bytes.getUint8(offset) << 8) + bytes.getUint8(offset + 1);
}

/// Return the VR ID from a Bytes Element.
int getVRIndexFromBytes(Bytes bytes, [int start = 0]) =>
    vrIndexFromCode(getVRCodeFromBytes(bytes, start));

/// Returns _true_ if [bytes] has a Evr Long VR.
bool isEvrLongFromBytes(Bytes bytes, [int start = 0]) =>
    isEvrLongVR(getVRIndexFromBytes(bytes, start));

/// Return the VR ID from a Bytes Element.
String getVRIdFromBytes(Bytes bytes, [int start = 0]) =>
    vrIdFromCode(getVRCodeFromBytes(bytes, start));

/*
/// Return the Value Field Length Field from an EVR Short Element.
int getEvrShortVLF(Bytes bytes, [int start = 0]) => bytes.getUint16(start + 6);

/// Return the Value Field Length Field from an EVR Long Element.
int getEvrLongVLF(Bytes bytes, [int start = 0]) => bytes.getUint32(start + 8);

/// Return the Value Field Length Field from an IVR Element.
int getIvrVLF(Bytes bytes, [int start = 0]) => bytes.getUint32(start + 4);
*/
