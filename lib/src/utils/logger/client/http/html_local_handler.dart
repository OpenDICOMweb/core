//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:html';

import 'package:core/src/utils/logger/log_record.dart';
import 'package:core/src/utils/logger/server/file/log_file.dart';
import 'package:core/src/utils/logger/transformer/transformer.dart';

// ignore_for_file: public_member_api_docs

//TODO: make this work.  Need to talk to logging server.

class HtmlFileHandler {
  static const _storeName = 'logger.store';
  final String name;
  final LogMode mode;
  bool _doPrint;
  Storage _store;
  Transformer _transform;

  HtmlFileHandler(this.name, this.mode, {bool doPrint, Transformer transform})
      : _doPrint = doPrint,
        _store = window.localStorage,
        _transform = transform;

  String call(LogRecord record) {
    final Object entry =
        (_transform != null) ? _transform(record) : '${record.info}\n';
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
  Transformer _transform;

  HtmlRemoteFileHandler(this.name, this.mode,
      {bool doPrint, Transformer transform})
      : _doPrint = doPrint,
        _store = window.localStorage,
        _transform = transform;

  String call(LogRecord record) {
    final Object entry =
        (_transform != null) ? _transform(record) : '${record.info}\n';
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
