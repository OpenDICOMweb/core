// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/buffer.dart';
import 'package:core/src/utils/dicom_bytes/dicom_bytes.dart';
import 'package:core/src/utils/buffer/read_buffer_mixin.dart';
import 'package:core/src/utils/dicom_buffer/dicom_read_buffer_mixin.dart';

// ignore_for_file: public_member_api_docs

class DicomReadBuffer extends ReadBufferBase
    with ReadBufferMixin, DicomReadBufferMixin {
  @override
  final DicomBytes buffer;
  @override
  int rIndex;
  @override
  int wIndex;

  DicomReadBuffer(this.buffer, [int offset = 0, int length])
      : rIndex = offset ?? 0,
        wIndex = length ?? buffer.length;

/*  DicomReadBuffer.from(DicomReadBuffer rb,
      [int offset = 0, int length, Endian endian = Endian.little])
      : buffer = rb.from(rb.buffer, offset, length, endian),
        rIndex = offset ?? rb.buffer.offset,
        wIndex = length ?? rb.buffer.length;
  */
/*
  DicomReadBuffer.from(DicomBytes buffer,
      [int offset = 0, int length, Endian endian = Endian.little])
      : buffer = DicomBytes.from(rb.buffer, offset, length, endian),
        rIndex = offset ?? rb.buffer.offset,
        wIndex = length ?? rb.buffer.length;
*/

/*  DicomReadBuffer.fromByteData(ByteData bd,
      [int offset, int length, Endian endian = Endian.little])
      : buffer = DicomBytes.typedDataView(bd, offset, length, endian),
        rIndex = offset ?? bd.offsetInBytes,
        wIndex = length ?? bd.lengthInBytes;

  DicomReadBuffer.fromList(List<int> list, [Endian endian])
      : buffer = DicomBytes.fromList(list, endian ?? Endian.little),
        rIndex = 0,
        wIndex = list.length;

  DicomReadBuffer.fromTypedData(TypedData td,
      [int offset = 0, int length, Endian endian = Endian.little])
      : buffer = DicomBytes.typedDataView(td, offset, length, endian),
        rIndex = offset ?? td.offsetInBytes,
        wIndex = length ?? td.lengthInBytes;

  @override
  Bytes get buffer => buffer;
  DicomReadBuffer(DicomBytes buf, [int offset = 0, int length])
      : super(buf, offset, length);

  DicomReadBuffer.fromTypedData(TypedData td,
      [int offset = 0, int length, Endian endian])
      : super.fromTypedData(td, offset, length, endian);
 */
}
