// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:convert' as cvt;
import 'dart:io';
import 'dart:typed_data';

import 'package:core/src/utils/bytes/bytes.dart';
import 'package:core/src/value/bulkdata/bulkdata.dart';

final Uint8List kBulkdataFileToken = cvt.ascii.encode('Bulkdata');

class BulkdataFile {
  String path;
  Bytes bytes;
  BulkdataIndex index;
  int vfStart;

  factory BulkdataFile(String path, Bytes bytes) {
    final token = bytes.getUint8List(0, 8);
    if (token != kBulkdataFileToken)
      throw new ArgumentError('$bytes is not a Bytedata file');
    final length = bytes.getUint32(8);
    final index = new BulkdataIndex(bytes.getUint32List(12, length));
    final vfStart = 12 + (length * 32);

    return new BulkdataFile._(path, bytes, index, vfStart);
  }

  BulkdataFile._(this.path, this.bytes, this.index, this.vfStart);

  Bulkdata operator [](int i) {
    final entry = index[i];
    final code = entry[0];
    final offset = entry[1];
    final length = entry[2];
    final vf = bytes.asBytes(vfStart + offset, length);
    return new Bulkdata(code, i, vf);
  }

  Bulkdata lookupByCode(int code) {
    final length = index.length ~/ 3;
    for (var i = 0; i < length; i += 3) {
      if (index[i][0] == code) {
        final offset = vfStart + index[i][1];
        final length = index[i][2];
        final vf = bytes.asBytes(offset, length);
        return new Bulkdata(code, i, vf);
      }
    }
    return null;
  }

  static Future<BulkdataFile> readFile(File file, {bool doAsync = true}) async {
    final bytes = (doAsync) ? await file.readAsBytes() : file.readAsBytesSync();
    return new BulkdataFile(file.path, bytes);
  }

  static Future<BulkdataFile> readPath(String fPath,
          {bool doAsync = true}) async =>
      await readFile(new File(fPath), doAsync: doAsync);
}

///
class BulkdataIndex {
  Uint32List entries;

  factory BulkdataIndex(Uint32List entries) {
    if ((entries.length % 12) != 0)
      throw new ArgumentError('Invalid Bulkdata Index');
    return new BulkdataIndex._(entries);
  }

  BulkdataIndex._(this.entries);

  Uint32List operator [](int i) =>
      (i < 0 || i >= length) ? null : entries.buffer.asUint32List(i * 12, 12);

  int get length => entries[0];
}
