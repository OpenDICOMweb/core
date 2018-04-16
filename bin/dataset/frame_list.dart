//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/core.dart';

void main() {
  const ts0 = TransferSyntax.kExplicitVRLittleEndian;
  const samplesPerPixel0 = 1;
  const rows4 = 4;
  const columns6 = 6;
  const bitsAllocated8 = 8;
  const bitsStored8 = 8;
  const highBit8 = 7;
  const pixelRepresentation0 = 0;
  const int planarConfiguration0 = null;
  const pixelAspectRatio0 = 1.0;
  const nFrames0 = 1;
  const photometricInterpretation0 = 'MONOCHROME3';

  final c8FDc = new FrameDescriptor(
      ts0,
      samplesPerPixel0,
      photometricInterpretation0,
      rows4,
      columns6,
      bitsAllocated8,
      bitsStored8,
      highBit8,
      pixelRepresentation0,
      planarConfiguration0,
      pixelAspectRatio: pixelAspectRatio0);

  final offSets = new Uint32List(0);
  final bulkData = new Uint8List(0);
  final foo = new CompressedFrameList(bulkData, offSets, nFrames0, c8FDc);
  print('foo: $foo');
}
