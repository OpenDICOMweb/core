//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

/// A [Bulkdata] [Uri] with the format '$path?bytes=$offset-$length'.
class BulkdataUri {
  final String scheme = 'https';
  final String path;
  final int offset;
  final int length;

  BulkdataUri(this.path, this.offset, this.length);

  String get query => 'bytes=$offset-$length';

  Uri get uri =>  Uri(scheme: scheme, path: path, query: query);

  @override
  String toString() => Uri.encodeFull('$uri');
}


