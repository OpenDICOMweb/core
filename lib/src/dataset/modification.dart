// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag/export.dart';

enum ChangeType { created, replaced, modified, deleted }

class OriginalAttributesSequence {
  final Tag tag = PTag.kOriginalAttributesSequence;
  // Source of Previous Values
  final String source;
  final String system;
  final String reason;
  final DateTime dt;
  final Modification modified;

  OriginalAttributesSequence(
      this.source, this.system, this.reason, this.modified)
      : dt = new DateTime.now();
}

//TODO: should we add timestamp
class Modification {
  final List<Modification> changes = [];
  ChangeType type;
  TagElement original;
  TagElement updated;
  List newValues;

  Modification();

  Modification._(this.type, this.original, this.updated, this.newValues);

  void create(TagElement e) {
    changes.add(new Modification._(ChangeType.created, e, null, null));
  }

  void replace(TagElement start, TagElement end) {
    changes.add(new Modification._(ChangeType.replaced, start, end, newValues));
  }

  void modify(TagElement initial, List newValues) {
    changes
        .add(new Modification._(ChangeType.modified, initial, null, newValues));
  }

  void remove(TagElement e) {
    changes.add(new Modification._(ChangeType.deleted, e, null, null));
  }

  @override
  String toString() => 'Modified Attributes(${changes.length}): $changes';
}
