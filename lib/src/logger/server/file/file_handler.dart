// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';

/// A [File] handler for the Loggers.
class FileHandler {
  final LogFile logFile;
  final bool isAsync;
  final bool doFlush;
  final RandomAccessFile _log;
  bool _doPrint;

  /// Returns a new [FileHandler].
  FileHandler(this.logFile,
      {this.isAsync = false, bool doPrint = false, this.doFlush = false})
      : _log = _openLogFile(logFile),
        _doPrint = doPrint;

  /// Write the [LogRecord] to the File.
  String call(LogRecord record, {bool flush: false})  {
    final entry = '$record\n';
    final shouldFlush = doFlush || flush;
    if (isAsync) {
      _writeAsync(entry, shouldFlush);
    } else {
      _writeSync(entry, shouldFlush);
    }
    if (_doPrint) print(entry);
    return entry;
  }

  bool get printOn => _doPrint = true;
  bool get printOff => _doPrint = false;

  Future _writeAsync(String s, bool shouldFlush) async {
    await _log.writeString(s);
    if (shouldFlush) await _log.flush();
  }

  void _writeSync(String s, bool shouldFlush) {
    _log.writeStringSync(s);
    if (shouldFlush) _log.flushSync();
  }

  static RandomAccessFile _openLogFile(LogFile name) {
    final dt = new DateTime.now();
    stdout.writeln('Logging to file: ${name.path}');
    final file = new File(name.path);
    if ((name.mode == LogMode.delete) && (file.existsSync())) file.deleteSync();
    // Written with double quotes in case it's a json file;
    final msg = '"Open DICOMweb log file (opened at $dt)"\n';
    return file.openSync(mode: FileMode.APPEND)..writeStringSync(msg);
  }
}
