// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:html';

import 'package:core/src/logger/log_record.dart';
import 'package:core/src/logger/server/file/log_file.dart';
import 'package:core/src/logger/transformer/transformer.dart';

//TODO: make this work.  Need to talk to logging server.

class HtmlFileHandler {
  static const _storeName = 'logger.store';
  final String name;
  final LogMode mode;
  bool _doPrint;
  Storage _store;

  HtmlFileHandler(this.name, this.mode, {bool doPrint, Transformer transform})
      : _doPrint = doPrint {
    _store = window.localStorage;
  }

  String call(LogRecord record) {
    final entry = '${record.info}\n';
    final _entries = _store[_storeName];
    _store[_storeName] = '$_entries$entry';
    if (_doPrint) print(entry);
    return entry;
  }

  bool get printOn => _doPrint = true;
  bool get printOff => _doPrint = false;

  @override
  String toString() => 'HtmlHandler: $name. Type: $runtimeType, Mode: $mode';
}

class HtmlRemoteFileHandler {
	static const _storeName = 'logger.store';
	final String name;
	final LogMode mode;
	bool _doPrint;
	Storage _store;

	HtmlRemoteFileHandler(this.name, this.mode, {bool doPrint, Transformer transform})
			: _doPrint = doPrint {
		_store = window.localStorage;
	}

	String call(LogRecord record) {
		final entry = '${record.info}\n';
		final _entries = _store[_storeName];
		_store[_storeName] = '$_entries$entry';
		if (_doPrint) print(entry);
		return entry;
	}

	bool get printOn => _doPrint = true;
	bool get printOff => _doPrint = false;

	@override
	String toString() => 'HtmlHandler: $name. Type: $runtimeType, Mode: $mode';
}