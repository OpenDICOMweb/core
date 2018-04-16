//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/utils/logger/log_record.dart';
import 'package:core/src/utils/logger/server/handler_base.dart';
import 'package:core/src/utils/logger/transformer/transformer.dart';

//TODO: move these comments elsewhere.
/// Creates a default handler that outputs using the build-in [print] function.
///
/// Example usage, with custom message formatting to make it look like the
/// standard print() output:
///
///     import 'package:logging_handlers/logging_handlers_shared.dart';
///     import 'package:logging/logger.dart';
///
///     main() {
///       var logger = new Logger("mylogger");
///       logger.onRecord.listen(new PrintHandler(messageFormat:"%m"));
///     }
///

//typedef String LogFormatter(LogRecord record);
//typedef void LogWriter(String s);

/// A Handler that transforms the [LogRecord] before  passing it to
/// the [logger.onRecord.listen] Handler.
class TransformHandler extends HandlerBase {
  final Transformer transform;

  TransformHandler({this.transform, bool doPrint: false}) : super(doPrint: doPrint);

  /// This Base implementation simply prints the log record.
  @override
  Object call(LogRecord record, {bool flush}) =>
      (transform == null) ? record : transform(record);
}
