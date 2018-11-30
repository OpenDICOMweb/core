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


mixin EvrShort {
  int get vfLength;
  int getUint16(int vfLengthOffset);
  bool _checkVFLengthField(int vlf, int vfLength);
  // **** End of Interface

  int get kVFLengthOffset => 6;
  int get kVFOffset => 8;
  int get kHeaderLength => kVFOffset;

  int get vfOffset => kVFOffset;

  int get vfLengthOffset => kVFLengthOffset;

  int get vfLengthField {
    final vlf = getUint16(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }
}

mixin EvrLong {
  int get vfLength;
  int getUint32(int kVFLengthOffset);
  bool _checkVFLengthField(int vlf, int vfLength);
  // **** End of Interface
  int get kVFLengthOffset => 8;
  int get kVFOffset => 12;
  int get kHeaderLength => kVFOffset;

  int get vfOffset => kVFOffset;

  int get vfLengthOffset => kVFLengthOffset;

  int get vfLengthField {
    final vlf = getUint32(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }
}
