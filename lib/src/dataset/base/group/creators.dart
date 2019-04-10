// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/primitives.dart';

/// A class containing a [Map] from Tag code to Private Creator Tags ([PCTag]).
class PrivateCreatorTags {
  /// A [Map] from Tag code to Private Creator Tags ([PCTag]).
  Map<int, PCTag> tags;

  /// Constructor
  PrivateCreatorTags() : tags = <int, PCTag>{};

  /// Returns the [PCTag] with [code] if present; otherwise, _null_.
  PCTag operator [](Object code) {
    if (code is int) {
      _checkPCTagCode(code);
      return tags[code];
    }
    return null;
  }

  /// Returns the [PCTag] with [code] if present; otherwise, _null_.
  void operator []=(int code, PCTag tag) => tryAdd(tag);

  /// Adds a new[PCTag] to _this_.
  void add(PCTag tag) => tryAdd(tag);

  /// If [tag] is not present, it is added to _this_ and _true_ is returned;
  /// otherwise, _false_ is returned.
  bool tryAdd(PCTag tag) {
    _checkPCTagCode(tag.code);
    final result = tags.putIfAbsent(tag.code, () => tag);
    return result != tag && Tag.isValidTag(tag, null, kLOIndex, PCTag);
  }

  //TODO(Jim): move to base.dart
  bool _checkPCTagCode(int code) {
    final v = code & 0x100FF;
    if (v >= 0x10010 && v <= 0x100FF) return true;
    final msg = 'Invalid PCTag Code ${dcm(code)}';
    log.error(msg);
    return invalidTagCode(code, msg);
  }

  @override
  String toString() {
    final sb = StringBuffer('$runtimeType: ${tags.length} creators');
    for (final v in tags.values) sb.writeln('  $v');
    return '$sb';
  }
}
