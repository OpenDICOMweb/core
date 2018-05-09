//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/bytes.dart';

abstract class BinaryElement {
  static const int kCodeOffset = 0;

  static const int kNull = 0;
  static const int kSpace = 32;
  static const int kUndefinedLength = 0xFFFFFFFF;

  Bytes bytes;
  int get vfOffset;
  int get padChar;
  void padCharWarning(int char, int padChar);

  // **** End of Interface ****

  /// The length in bytes of this Element
  int get length => bytes.length;

  int get code => bytes.code;

  int get vfLengthField => bytes.getUint32(vfOffset);

  bool get hadULength => vfLengthField == kUndefinedLength;


  /// The actual length in bytes of the Value Field. It does
  /// not include any padding characters.
  int get vfLength => bytes.length = vfOffset;

  /// The Value Field [Bytes] with padding.
  Bytes get vfBytes => bytes.asBytes(vfOffset);

  int get vfLastOffset => vfLength - 1;

  int get vfBytesLast => vfBytes.getUint8(vfLastOffset);

  /// The Value Field length without padding.
  int get vLength {
   if ( padChar == null || vfLength == 0) return vfLength;
   final char = vfBytesLast;
   if ( char == kSpace || char == kNull) {
     if  (char != padChar) padCharWarning(char, padChar);
   return vfBytesLast;
   }
   return vfLength;
  }

  /// The Value Field [Bytes] without padding.
  Bytes get vBytes;
}

abstract class IvrElement extends BinaryElement {
  static const int kVFLengthOffset = 4;

  @override
  int get vfOffset => 4;

}

abstract class EvrElement extends BinaryElement {
  static const int kVRCodeOffset = 4;

  int get vrCode => bytes.getUint16(kVRCodeOffset);
}

abstract class EvrShortElement extends EvrElement {
  static const int kVFLengthOffset = 6;

  @override
  int get vfOffset => 8;
}

abstract class EvrLongElement extends EvrElement {
  static const int kVFLengthOffset = 6;

  @override
  int get vfOffset => 12;
}