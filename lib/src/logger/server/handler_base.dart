// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:core/src/logger/log_record.dart';


//TODO: move these comments elsewhere.
/// Creates a default handler that outputs using the build-in [print] function.
///
/// Example usage, with custom message formatting to make it look like the
/// standard print() output:
///
///
///     main() {
///       var logger = new Logger("mylogger");
///       logger.onRecord.listen(new PrintHandler(messageFormat:"%m"));
///
///     }


/// Base Handler that can be passed to the [logger.onRecord.listen] handler.
/// This Handler simply prints the log record before passing it up the chain.
abstract class HandlerBase {
	bool doPrint;

	HandlerBase({this.doPrint = true});

	/// This Base implementation simply prints the log record.
	Object call(LogRecord r, {bool flush: false}) {
		final s = '$r';
		if (doPrint) stdout.writeln(s);
		return s;
	}



	@override
	String toString() => '$runtimeType';
}





