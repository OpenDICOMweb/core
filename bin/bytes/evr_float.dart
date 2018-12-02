// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/server.dart';

void main() {
  Server.initialize(throwOnError: true, level: Level.debug);

  final vList = <double>[1.0, 1.1, 1.2];

  final fl = FLbytes.fromValues(kSelectorFLValue, vList);
  assert(fl.bytes is DicomBytes);
  assert(fl.vfBytes is Bytes);
  assert(fl.hasValidValues);
  printEvr(fl, kFLCode, fl.vfBytes);

  final fl1 = FLbytes(fl.bytes);
  assert(fl1.bytes is DicomBytes);
  assert(fl1.vfBytes is Bytes);
  assert(fl1.hasValidValues);
  printEvr(fl1, kFLCode, fl1.vfBytes);

  final of = OFbytes.fromValues(kSelectorOFValue, vList);
  assert(of.bytes is DicomBytes);
  assert(of.vfBytes is Bytes);
  assert(of.hasValidValues);
  printEvr(fl1, kOFCode, of.vfBytes);

  final of1 = OFbytes(of.bytes);
  assert(of1.bytes is DicomBytes);
  assert(of1.vfBytes is Bytes);
  assert(of1.hasValidValues);
  printEvr(of1, kOFCode, of1.vfBytes);

  final fd = FDbytes.fromValues(kSelectorOFValue, vList);
  assert(fd.bytes is DicomBytes);
  assert(fd.vfBytes is Bytes);
  assert(fd.hasValidValues);
  printEvr(fd, kOFCode, fd.vfBytes);

  final fd1 = FDbytes(fd.bytes);
  assert(fd1.bytes is DicomBytes);
  assert(fd1.vfBytes is Bytes);
  assert(fd1.hasValidValues);
  printEvr(fd1, kOFCode, fd1.vfBytes);

  final od = ODbytes.fromValues(kSelectorOFValue, vList);
  assert(od.bytes is DicomBytes);
  assert(od.vfBytes is Bytes);
  assert(od.hasValidValues);
  printEvr(od, kOFCode, od.vfBytes);

  final od1 = ODbytes(od.bytes);
  assert(od1.bytes is DicomBytes);
  assert(od1.vfBytes is Bytes);
  assert(od1.hasValidValues);
  printEvr(od1, kOFCode, od1.vfBytes);
}

/*
EvrBytes makeFD(int code, List<double> vList) {
  final v = (vList is Float64List) ? vList :  Float64List.fromList(vList);
  return makeFD(code, kFDCode,  Bytes.typedDataView(v));
}
*/

void printEvr(ByteElement e, int actualVRCode, Bytes vf) {
  final bytes = e.bytes;
//  print('${e.bytes.asUint8List()}');
  print('$e');
  print('\n        length: ${e.length} bytes: ${bytes.length} '
      'vfOffset(${e.vfOffset}) + vfLength(${vf.length}) '
      '= ${e.vfOffset + e.vfLength} ');
  print('vfLengthOffset: ${e.vfLengthOffset}');
  print(' vfLengthField: ${e.vfLengthField}  actual ${bytes.vfLengthField}');
  print('      vfLength: ${e.vfLength} vf: ${vf.length}');
  print('      vfOffset: ${e.vfOffset} vf: ${vf.offset}');
  print('          code: ${dcm(e.code)}');
  print('        vrCode: ${hex16(e.vrCode)}: actual ${hex16(actualVRCode)}');
  print('      vfLength: ${e.vfLength} actual: ${vf.length}');
  print('     uint8List: ${vf.asUint8List()}');
  print('       vfBytes: ${e.vfBytes}');
  print('vfBytes actual: $vf');
  print('        values: ${e.vfBytes.asFloat32List()}');
  print('e as Uint8List: ${e.bytes.asUint8List()}');
  print('   vfUint8List: ${vf.asUint8List()}\n ****\n');
}

void printIvr(DicomBytes e, Uint8List uint8List) {
  print('${e.bd.buffer.asUint8List()}');
  print('$e');
  print('\n     length: ${8 + uint8List.length} actual ${e.length}');
  print('vfLengthOffset: ${e.vfLengthOffset}');
  print(' vfLengthField: ${e.vfLengthField}');
  print('      vfOffset: ${e.vfOffset}');
  print('          code: ${dcm(kInversionTimes)} actual ${dcm(e.code)}');

  print('      vfLength: ${uint8List.length} actual ${e.vfLength}');
  print('     uint8List: $uint8List');
  print('       vfBytes: ${e.vfBytes}');
  print('        values: ${e.vfBytes.asUint8List()}');
  print('          e as bytes: ${e.asUint8List()}');
  print('          e.v: ${e.asUint8List()}');
  print('   vfUint8List: ${e.vfUint8List}');
}
