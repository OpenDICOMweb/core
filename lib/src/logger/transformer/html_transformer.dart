// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/logger/log_record.dart';
import 'package:core/src/logger/transformer/transformer.dart';

class Html extends Transformer {
  Html() : super();

  /// Convert the [LogRecord] into a Html [String}.
  @override
  String call(LogRecord r) => '''
  <div>
    <ul>
      <li>number: ${r.index}</li>
      <li>message: ${r.message}</li>
      <li>level: ${r.level}</li>
      <li>LoggerName: ${r.name}</li>
      <li>time: ${r.dt}</li>
    </ul>
    <div>exception: ${r.error}</div>
  </div>
''';
}
