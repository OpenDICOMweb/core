//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/logger/log_record.dart';
import 'package:core/src/utils/logger/transformer/transformer.dart';

// ignore_for_file: public_member_api_docs

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
