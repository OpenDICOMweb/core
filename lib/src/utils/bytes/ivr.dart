//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;

class IvrBytes extends DicomBytes {
  IvrBytes(int eLength) : super._(eLength, Endian.little);

  IvrBytes.from(Bytes bytes, int start, int end)
      : super.from(bytes, start, end, Endian.little);

  IvrBytes.view(Bytes bytes, [int start = 0, int end, Endian endian])
      : super._view(bytes, start, end, endian) {
/*
    final s = '''
   offset: ${bytes.offset}
   length: ${bytes.length}
    start: $start
      end: $end
     code: ${dcm(code)}
 vfLength: $vfLength
bd.offset: ${_bd.offsetInBytes}  
bd.length: ${_bd.lengthInBytes}    
   endian: ${endian == Endian.little ? 'little' : 'big'} 
''';
    print(s);
*/

  }

  @override
  bool get isEvr => false;
  @override
  int get vrCode => kUNCode;
  @override
  int get vrIndex => kUNIndex;
  @override
  String get vrId => vrIdFromIndex(vrIndex);
  VR get vr => VR.kUN;
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
  IvrBytes sublist([int start = 0, int end]) =>
      new IvrBytes.from(this, start, (end ?? length) - start);

  static const int kVROffset = 4;
  static const int kVFLengthOffset = 4;
  static const int kVFOffset = 8;
  static const int kHeaderLength = 8;

  static IvrBytes makeEmpty(
    int code,
    int vfLength,
    int vrCode,
  ) {
    assert(vfLength.isEven);
    return new IvrBytes(kHeaderLength + vfLength)
      ..ivrSetHeader(code, vfLength, vrCode);
  }

  static IvrBytes makeFromBytes(
    int code,
    Bytes vfBytes,
    int vrCode,
  ) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    return new IvrBytes(kHeaderLength + vfLength)
      ..ivrSetHeader(code, vfLength, vrCode)
      ..setByteData(kVFOffset, vfBytes._bd);
  }
}
