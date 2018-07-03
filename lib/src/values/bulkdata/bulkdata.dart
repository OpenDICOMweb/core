//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/utils/bytes.dart';

const String bulkdataFileExtension = '.bd';

class Bulkdata {
  /// Dicom Tag Code
  int code;
  /// The byte offset of this in the Bulkdata File.
  int offset;
  /// Value Field
  Bytes vf;

  Bulkdata(this.code, this.offset, this.vf);

  int get length => vf.length;
}

// '$baseUrl/$path
class BulkdataUri {
  final String scheme = 'https';
  final String path;
  final String query;
  final int offset;
  final int length;

  BulkdataUri(this.path, this.offset, this.length)
  : query = 'bytes=$offset-$length';

  Uri get uri =>  new Uri(scheme: scheme, path: path, query: query);

  @override
  String toString() => Uri.encodeFull('$uri');
}


