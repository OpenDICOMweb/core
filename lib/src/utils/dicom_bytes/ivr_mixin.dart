//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

mixin IvrMixin {
  int get vfLength;
  int getUint32(int offset);
  bool _checkVFLengthField(int vlf, int vfLength);
  // **** End of Interface

  // int get kHeaderLength => kVFOffset;
  bool get isEvr => false;

  int get vrCode => kUNCode;

  int get vrIndex => kUNIndex;

  String get vrId => vrIdFromIndex(vrIndex);

  VR get vr => VR.kUN;

  int get vfOffset => kVFOffset;

  int get vfLengthOffset => kVFLengthOffset;

  int get vfLengthField {
    final vlf = getUint32(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  static const int kVFLengthOffset = 4;
  static const int kVFOffset = 8;
  static const int kHeaderLength = 8;
}
