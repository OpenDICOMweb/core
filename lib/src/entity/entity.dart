//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:collection';

import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/entity/ie_level.dart';
import 'package:core/src/entity/instance.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/logger.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

/// DICOM Information Entities
///
/// 1. Every [Entity] is unique and is identified by its [Uid].
/// 2. When an [Entity] is copied its [Uid] is modified

// Issue:
//   1. Should we have separate classes for Patient, Patient, and Animal?

/// The Base [class] that is used to implement DICOM Information Entities
/// (see  PS3.1 and PS3.6).
abstract class Entity with MapMixin<Uid, Entity> {
  /// This [parent] of _this_.
  final Entity parent;

  /// A Map from [Uid] to [Entity].
  final Map<Uid, Entity> childMap;

  /// The SOP Instance UID of _this_.
  final Uid key;

  /// The [RootDataset] associated with this [Entity].
  /// Note: For standard DICOM this is the [RootDataset],
  /// for Mint it is the Entity RootDataset.
  final RootDataset rds;

  /// A DICOM Information Entity
  Entity(this.parent, this.key, this.rds, this.childMap);

  /// Returns a copy of [Entity], but with a  [Uid]. If [parent] is _null_
  /// the  [Entity] has the same parent as _this_.
  Entity.from(Entity entity, this.rds, Entity parent, this.childMap, this.key)
      : parent = (parent == null) ? entity.parent : parent;

  // **** Map Implementation

  @override
  bool operator ==(Object other)  => other is Entity && key == other.key;
  @override
  Entity operator [](Object key) => (key is Uid) ? childMap[key] : null;
  @override
  void operator []=(Uid key, Entity value) => childMap[key] = value;
  @override
  Iterable<Uid> get keys => childMap.keys;
  @override
  void clear() => childMap.clear();
  @override
  Entity remove(Object key) => (key is Uid) ? childMap.remove(key) : null;
  @override
  int get hashCode => key.hashCode;

  // **** End Map Implementation

  Uid get uid => key;

  /// The [Type] of _this_.
  Type get type => runtimeType;

  /// The Information Entity Level of _this_.
  IELevel get level;

  /// The [Type] of the children of _this_.
  Type get childType;

  String get info => '''$this
  parent: $parent
    $childType: ${childMap.length}
  ''';

  /// Returns a [String] containing information about _this_.
  String get summary {
    final sb = StringBuffer('$runtimeType: $key\n  '
        '${parent.runtimeType}: $parent $length $childType\n');
    if (this is! Instance) {
      for (var s in values) {
        sb.write('  $childType: ${s.key}\n    ${s.length} values\n');
      }
    }
    return '$sb';
  }

  //TODO: this should handle sequence tags
  /// Returns the [Element] with [Tag] equal to [tag] in _this_.
  Element lookup(Tag tag) => rds[tag.code];

  /// Adds an  [Entity] to _this_.  Throws a [DuplicateEntityError]
  /// if _this_ has an existing [Entity] with the same [Uid].
  Entity addIfAbsent(Entity entity) =>
    putIfAbsent(entity.key, () => entity);


  /// Returns a [String] containing formatted output.
  String format(Formatter z) => z.fmt(this, values);

  @override
  String toString() => '$runtimeType($uid): (children: $length) ';
}
