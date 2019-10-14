//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:constants/constants.dart';
import 'package:core/src/tag.dart';

/// Returns a [String] containing the Type of [key].
String keyTypeString<K>(K key) {
  if (key is int) {
    return 'Code ${dcm(key)}';
  } else if (key is String) {
    return 'Keyword "$key"';
  } else if (key is Tag) {
    return '$key';
  }
  return 'Error: bad Tag($key) in _toMsgString($key)';
}

