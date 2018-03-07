// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/src/system.dart';

/// General Errors or System related errors.

Null unsupportedError([String msg = '']) => throw new UnsupportedError(msg);

Null unimplementedError([String msg = '']) => throw new UnsupportedError(msg);

//Issue: Shouldn't this always throw?
/// An Internal system error.
class InternalError extends Error {
	final String msg;
	final Object object;
	final int errorCode;

	InternalError(this.msg, [this.object, this.errorCode = -1]);

	@override
	String toString() => message(msg, object, errorCode);

	static String message(String msg, Object object, int code) =>
			'InternalError($code):$msg - $object';
}

// Internal Errors might be handled differently on Client and Server.
void internalError(String msg, [Object o, int errorCode = -1]) {
	log.error(InternalError.message(msg, o, errorCode));
	if (throwOnError)
		throw new InternalError(msg, o, errorCode);
	System.system.exit(errorCode, msg);
	return null;
}

class InvalidYearError extends Error {
	int year;

	InvalidYearError(this.year);

	@override
	String toString() =>
			'Invalid Year: min($kMinYearLimit) <= $year <= max($kMaxYearLimit)';

}

/// A [NullValueError] is thrown when a value should not be _null_.
class NullValueError extends Error {
	String msg;

	NullValueError(this.msg);

	@override
	String toString() => msg;

}

Null nullValueError([String msg = '']) {
	final s = 'NullValueError: $msg';
	log.error(s);
	if (throwOnError) throw new NullValueError(s);
	return null;
}

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




