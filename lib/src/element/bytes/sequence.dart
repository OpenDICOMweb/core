//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.bytes;

// **** Sequence Class

class SQbytes extends SQ with ByteElement<Item> {
  @override
  final Dataset parent;
  @override
  Iterable<Item> values;
  @override
  final DicomBytes bytes;

  SQbytes(this.parent, this.values, this.bytes);

  @override
  int get length => values.length;

  /// Returns a new [SQbytes], where [bytes] is [DicomBytes]
  /// for complete sequence.
  static SQbytes fromBytes(Dataset parent,
          [Iterable<Item> values, DicomBytes bytes]) =>
      new SQbytes(parent, values, bytes);

  static SQbytes fromValues(int code, List<String> vList,
          {bool isEvr = true}) =>
      unsupportedError();
}

