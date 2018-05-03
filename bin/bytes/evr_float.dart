// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:core/src/element/bytes/bd_test_utils.dart';

void main() {
  Server.initialize(throwOnError: true, level: Level.debug);

  final vList = <double>[1.0];
  final float32List = new Float32List.fromList(vList);

  final bytes = new Bytes.typedDataView(float32List);
  final bytes1 = Float32.toBytes(vList);
  final fl = makeFL(kRecommendedDisplayFrameRateInFloat, vList);
 // final short = EvrShortBytes.make(kInversionTimes, kFDCode, bytes);
  printEvr(fl, kFLCode, bytes1);

 // final uint8List1 = new Bytes.typedDataView(float32List);
  final of = makeOF(kVectorGridData, vList);
 // final long = EvrLongBytes.make(kInversionTimes, kFDCode, uint8List1);
  printEvr(of, kOFCode, bytes);

}

/*
EvrBytes makeFD(int code, List<double> vList) {
  final v = (vList is Float64List) ? vList : new Float64List.fromList(vList);
  return makeFD(code, kFDCode, new Bytes.typedDataView(v));
}
*/

void printEvr(EvrElement e, int actualVRCode, Bytes vf) {
  final bytes = e.bytes;
//  print('${e.bytes.asUint8List()}');
  print('$e');
  print('\n        length: ${e.length} bytes: ${bytes.length} '
            'vfOffset(${e.vfOffset}) + vfLength(${ vf.length}) '
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


void printIvr(EvrBytes e, Uint8List uint8List) {
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
