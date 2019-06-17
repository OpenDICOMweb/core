//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:bytes/bytes.dart';

import 'package:core/src/values/bulkdata/bulkdata_file.dart';

// ignore_for_file: public_member_api_docs

/// A DICOM _Bulkdata_
///
/// A [Bulkdata] is an entry in a [BulkdataFile].
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



