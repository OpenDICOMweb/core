//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag.dart';

// ignore_for_file: public_member_api_docs

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
      : dt = DateTime.now();
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
    changes.add(Modification._(ChangeType.created, e, null, null));
  }

  void replace(TagElement start, TagElement end) {
    changes.add(Modification._(ChangeType.replaced, start, end, newValues));
  }

  void modify(TagElement initial, List newValues) {
    changes.add(Modification._(ChangeType.modified, initial, null, newValues));
  }

  void remove(TagElement e) {
    changes.add(Modification._(ChangeType.deleted, e, null, null));
  }

  @override
  String toString() => 'Modified Attributes(${changes.length}): $changes';
}
