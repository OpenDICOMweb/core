//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';

import 'package:core/src/utils/logger/log_record.dart';

/// A [File] handler for the Loggers.
class HttpHandler {
  final int defaultPort = 8080;
  final Uri url;
  final bool isAsync;
  final bool doFlush;
  HttpClientRequest _request;
  SecurityContext context;

  bool _doPrint;

  /// Returns a new [HttpHandler].
  HttpHandler(String url,
      {this.isAsync = true, bool doPrint = false, this.doFlush = false})
      : url = Uri.parse(url),
        _doPrint = doPrint,
        context = SecurityContext.defaultContext;

  bool get printOn => _doPrint = true;
  bool get printOff => _doPrint = false;

  /// Write the [LogRecord] to the File.
  Future<String> call(LogRecord record, {bool flush: false}) async {
    _request ??= await _open(url, context);
    final entry = '${record.info}\n';
    _request.write(entry);
    await _request.done;
    if (_doPrint) stdout.writeln(entry);
    return entry;
  }

  static Future _write(String s, HttpClientRequest request) async {
    request.write(s);
    await request.done;
  }

  static Future _open(Uri url, SecurityContext context) async {
    if (url.scheme != 'https') stderr.writeln('This not a secure connection');
    final _client = new HttpClient(context: context);
    final request = await _client.open('POST', url.host, url.port, url.path);

    final dt = new DateTime.now();
    // Written with double quotes in case it's a json file;
    final msg = '"Open DICOMweb log file (opened at $dt)"\n';
    await _write(msg, request);
    await request.done;
    return request;
  }
}
