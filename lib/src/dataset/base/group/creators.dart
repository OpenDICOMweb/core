// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/primitives.dart';

class PrivateCreatorTags {
  Map<int, PCTag> tags;

  PrivateCreatorTags() : tags = <int, PCTag>{};

  PCTag operator [](int code) {
    _checkPCTagCode(code);
    return tags[code];
  }

  void operator []=(int code, PCTag tag) => tryAdd(tag);

  void add(PCTag tag) => tryAdd(tag);

  bool tryAdd(PCTag tag) {
    _checkPCTagCode(tag.code);
    final result = tags.putIfAbsent(tag.code, () => tag);
    return (result != tag) ? Tag.isValidTag(tag, null, kLOIndex, PCTag) : true;
  }

  //TODO: move to base.dart
  bool _checkPCTagCode(int code) {
    final v = code & 0x100FF;
    if (v >= 0x10010 && v <= 0x100FF) return true;
    final msg = 'Invalid PCTag Code ${dcm(code)}';
    log.error(msg);
    return invalidCode(code, msg);
  }

  @override
  String toString() {
    final sb = new StringBuffer('$runtimeType: ${tags.length} creators');
    for (var v in tags.values) sb.writeln('  $v');
    return '$sb';
  }
}
