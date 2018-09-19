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
import 'package:core/src/utils/logger/transformer/transformer.dart';

// ignore_for_file: public_member_api_docs

abstract class HtmlHandler {
  static const _storeName = 'logger.store';
  final String name;
  final bool doPrint;
  Storage _store;
  Transformer _transform;

  HtmlHandler(this.name, {this.doPrint, Transformer transform})
      : _store = window.localStorage,
        _transform = transform;

  Object call(LogRecord record) {
    final _entries = _store[_storeName];
    final entry = (_transform != null) ? _transform(record) : '$record';
    _store[_storeName] = '$_entries$entry';
    if (doPrint) print(entry);
    return entry;
  }

  @override
  String toString() => 'HtmlHandler: $name. Type: $runtimeType';
}
