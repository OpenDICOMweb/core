//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/utils/buffer/buffer_base.dart';

abstract class StringBufferBase implements BufferBase {
  StringBuffer get _buf;
  int get _rIndex;
  int get _wIndex;
}

class StringWriteBuffer extends StringBufferBase {
  // **** Interface
  /// The underlying [StringBuffer] for the buffer.
  @override
  final StringBuffer _buf;
  @override
  int _rIndex;
  @override
  int _wIndex;

  StringWriteBuffer(String s) : _buf = new StringBuffer(s);



/*
  // Urgent: Jim todo
  StringReadBuffer.fromString(String s)
      : _buf = new StringBuffer(s),
        _rIndex = 0,
        _wIndex = td.lengthInBytes,
        bytes = new Bytes.typedDataView(td, endian);

*/

}
