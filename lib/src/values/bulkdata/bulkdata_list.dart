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


class BulkdataList {
  final Uint8List token = ascii.encode('Bulkdata');
  List<Bulkdata> entries = <Bulkdata>[];
  int offset = 0;
  int lengthInBytes = 0;

  BulkdataList();

  Bulkdata operator [](int i) => entries[i];

  int get length => entries.length;

  /// Return a URL for the [Bulkdata] Value FIeld that is add to _this_.
  Bulkdata add(int code, Bytes valueField) {
    final bd = new Bulkdata(code, entries.length, valueField);
    lengthInBytes += valueField.length;
    entries.add(bd);
    return bd;
  }

  // Returns a [Uint32List] where each entry is 12 bytes long.
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

/*
  Future writeFile(File file, {bool doAsync = true}) async {
    final wb = new DicomWriteBuffer();
    final index = getIndex();
    wb
      // Write identifer 'Bulkdata'
      ..writeUint8List(token)
      // Write length of Index
      ..writeUint32(index.length);

    // Write Index
    for (var i = 0; i < index.length; i++) wb.writeUint32(index[i]);

    // Write Bulkdata
    for (var i = 0; i < entries.length; i++) wb.write(entries[i].vf);

    wb.asUint8List(0, wb.length);

    if (doAsync) {
      await file.writeAsBytes(wb.asUint8List());
    } else {
      file.writeAsBytesSync(wb.asUint8List());
    }
  }

  void writePath(String s) => writeFile(new File(bulkdataPath(s)));

  String bulkdataPath(String s) {
    final dir = path.dirname(s);
    final base = path.basenameWithoutExtension(s);
    return '$dir$base$bulkdataFileExtension';
  }
*/

}
