//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.bytes;

// ignore_for_file: public_member_api_docs

/// 16-bit signed integer Elements (SS)
mixin Int16Mixin {
  Bytes get vfBytes;

  int get length {
    assert(vfBytes.length.isEven);
    return vfBytes.length ~/ 2;
  }

  Int16List get values => vfBytes.asInt16List();
}

/// 32-bit signed integer Elements (SL)
mixin Int32Mixin {
  Bytes get vfBytes;
  Int32List _values;

  int get length {
    assert(vfBytes.length % 4 == 0);
    return vfBytes.length ~/ 4;
  }


  Int32List get values => _values ??= vfBytes.asInt32List();
}

/// Unsigned 8-bit Integer Elements (OB, UN)
mixin Uint8Mixin {
  Bytes get vfBytes;

  int get length => vfBytes.length;

  Uint8List get values => vfBytes.asUint8List();
}

/// 16-bit unsigned integer Elements (US, OW)
mixin Uint16Mixin {
  Bytes get vfBytes;

  int get length {
    assert(vfBytes.length.isEven);
    return vfBytes.length ~/ 2;
  }

  Uint16List get values => vfBytes.asUint16List();
}

/// 32-bit unsigned integer Elements (AT, UL, GL, OL)
mixin Uint32Mixin {
  Bytes get vfBytes;

  int get length {
    assert(vfBytes.length % 4 == 0);
    return vfBytes.length ~/ 4;
  }

  Uint32List get values => vfBytes.asUint32List();
}
