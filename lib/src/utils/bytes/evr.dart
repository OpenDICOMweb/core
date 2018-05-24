//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;

abstract class EvrBytes extends DicomBytes {
  factory EvrBytes.from(Bytes bytes, int start, int vrIndex, int end) {
    if (vrIndex >= kVREvrShortIndexMin && vrIndex <= kVREvrShortIndexMax) {
      return new EvrShortBytes.from(bytes, start, end);
    } else if (vrIndex >= kVRIndexMin && vrIndex <= kVREvrLongIndexMax) {
      return new EvrLongBytes.from(bytes, start, end);
    } else {
      return badVRIndex(vrIndex, null, null, null);
    }
  }

  EvrBytes._(int eLength, Endian endian) : super._(eLength, endian);

  EvrBytes._from(Bytes bytes, int start, int end, Endian endian)
      : super.from(bytes, start, end, endian ?? Endian.host);

  factory EvrBytes.view(
      Bytes bytes, int start, int vrIndex, int end, Endian endian) {
    if (vrIndex >= kVREvrShortIndexMin && vrIndex <= kVREvrShortIndexMax) {
      return new EvrShortBytes.view(bytes, start, end, endian);
    } else if (vrIndex >= kVRIndexMin && vrIndex <= kVREvrLongIndexMax) {
      return new EvrLongBytes.view(bytes, start, end, endian);
    } else {
      return badVRIndex(vrIndex, null, null, null);
    }
  }

  EvrBytes._view(Bytes bytes, int offset, int length, Endian endian)
      : super._view(bytes, offset, length, endian);

  @override
  bool get isEvr => true;
  @override
  int get vrCode => _bd.getUint16(kVROffset, endian);
  @override
  int get vrIndex => vrIndexFromCode(vrCode);
  @override
  String get vrId => vrIdFromIndex(vrIndex);
  VR get vr => vrByIndex[vrIndex];

  static const int kVROffset = 4;
}

class EvrShortBytes extends EvrBytes {
  EvrShortBytes(int eLength, [Endian endian]) : super._(eLength, endian);

  EvrShortBytes.from(Bytes bytes, [int start = 0, int end, Endian endian])
      : super._from(bytes, start, end, endian) {
    final s = '''
   offset: ${bytes.offset}
   length: ${bytes.length}
    start: $start
      end: $end
bd.offset: ${_bd.offsetInBytes}  
bd.length: ${_bd.lengthInBytes}    
   endian: ${endian == Endian.little ? 'little' : 'big'} 
    ''';
    print(s);
  }

  EvrShortBytes.view(Bytes bytes, [int start = 0, int end, Endian endian])
      : super._view(bytes, start, end, endian) {

    final s = '''
   offset: ${bytes.offset}
   length: ${bytes.length}
    start: $start
      end: $end
bd.offset: ${_bd.offsetInBytes}  
bd.length: ${_bd.lengthInBytes}    
   endian: ${endian == Endian.little ? 'little' : 'big'} 
    ''';
    print(s);


  }

  @override
  int get vfOffset => kVFOffset;
  @override
  int get vfLengthOffset => kVFLengthOffset;

  @override
  int get vfLengthField {
    final vlf = getUint16(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrShortBytes sublist([int start = 0, int end]) =>
      new EvrShortBytes.from(this, start, (end ?? length) - start, endian);

  static const int kVFLengthOffset = 6;
  static const int kVFOffset = 8;
  static const int kHeaderLength = kVFOffset;

  static EvrShortBytes makeEmpty(int code, int vfLength, int vrCode,
      [Endian endian]) {
    final e = new EvrShortBytes(kHeaderLength + vfLength, endian)
      ..evrSetShortHeader(code, vfLength, vrCode);
    return e;
  }

  static EvrShortBytes makeFromBytes(int code, Bytes vfBytes, int vrCode,
      [Endian endian = Endian.little]) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = new EvrShortBytes(kHeaderLength + vfLength, endian)
      ..evrSetShortHeader(code, vfLength, vrCode)
      ..setByteData(kVFOffset, vfBytes._bd);
    return e;
  }
}

class EvrLongBytes extends EvrBytes {
  EvrLongBytes(int eLength, [Endian endian]) : super._(eLength, endian);

  EvrLongBytes.from(Bytes bytes, [int start = 0, int end, Endian endian])
      : super._from(bytes, start, end, endian);

  EvrLongBytes.view(Bytes bytes, [int start = 0, int end, Endian endian])
      : super._view(bytes, start, end, endian) {

    final s = '''
   offset: ${bytes.offset}
   length: ${bytes.length}
    start: $start
      end: $end
bd.offset: ${_bd.offsetInBytes}  
bd.length: ${_bd.lengthInBytes}    
   endian: ${endian == Endian.little ? 'little' : 'big'} 
    ''';
    print(s);


  }

  @override
  int get vfOffset => kVFOffset;
  @override
  int get vfLengthOffset => kVFLengthOffset;

  @override
  int get vfLengthField {
    final vlf = getUint32(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrLongBytes sublist([int start = 0, int end]) =>
      new EvrLongBytes.from(this, start, (end ?? length) - start, endian);

  static const int kVROffset = 4;
  static const int kVFLengthOffset = 8;
  static const int kVFOffset = 12;
  static const int kHeaderLength = kVFOffset;

  static EvrLongBytes makeEmpty(int code, int vfLength, int vrCode,
      [Endian endian]) {
    //assert(vfLength.isEven);
    final e = new EvrLongBytes(kHeaderLength + vfLength, endian)
      ..evrSetLongHeader(code, vfLength, vrCode);
    return e;
  }

  static EvrLongBytes makeFromBytes(int code, Bytes vfBytes, int vrCode,
      [Endian endian]) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = new EvrLongBytes(kHeaderLength + vfLength, endian)
      ..evrSetLongHeader(code, vfLength, vrCode)
      ..setByteData(kVFOffset, vfBytes._bd);
    return e;
  }
}
