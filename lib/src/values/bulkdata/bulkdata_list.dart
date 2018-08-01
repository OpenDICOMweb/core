//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/utils/bytes.dart';
import 'package:core/src/values/bulkdata/bulkdata.dart';
import 'package:core/src/values/bulkdata/bulkdata_uri.dart';
import 'package:path/path.dart';

/// A list of [Bulkdata] that keeps track of the
class BulkdataList {
  final Uint8List token = ascii.encode('Bulkdata');
  final String path;
  List<Bulkdata> entries = <Bulkdata>[];
  /// The current offset in bytes of the end of _this_.
  int offset = 0;
  int lengthInBytes = 0;

  BulkdataList(String filePath) : path = absolute(filePath);

  Bulkdata operator [](int i) => entries[i];

  int get length => entries.length;

  /// Return a URL for the [Bulkdata] Value Field that is added to _this_.
  BulkdataUri add(int code, Bytes valueField) {
    final bd = new Bulkdata(code, entries.length, valueField);
    lengthInBytes += valueField.length;
    entries.add(bd);
    return new BulkdataUri(path, offset, valueField.length);
  }

  /// Returns a [Uint32List] where each entry is 12 bytes long.
  /// The returned [Uint32List] is equivalent to a DICOM Basic Offset Table.
  Uint32List getIndex() {
    final length = entries.length * 12;
    final bd = new ByteData(length);

    var offset = 0;
    for (var i = 0, j = 0; i < entries.length; i++, j += 12) {
      bd
        ..setUint32(j, entries[i].code)
        ..setUint32(j + 4, offset)
        ..setUint32(j + 8, entries[i].length);
      offset += length;
    }
    return bd.buffer.asUint32List();
  }
}
