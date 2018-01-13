// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.


import 'package:core/core.dart';

/// Read Error
class ReadError extends Error {
	/// The error message
	final String msg;

	ReadError(this.msg);

	@override
	String toString() => message(msg);

	static String message(String msg) => 'ReadError: $msg';
}

void readError(String msg) {
	log.error(ReadError.message(msg));
	if (throwOnError)
		throw new ReadError(msg);
	return null;
}
