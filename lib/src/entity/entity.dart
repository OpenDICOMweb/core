//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/entity/ie_level.dart';
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
abstract class Entity {
  static const Map<Uid, Entity> empty = <Uid, Entity>{};

  /// This [parent] of _this_.
  final Entity parent;

  /// The SOP Instance UID of _this_.
  final Uid uid;

  /// The [Entity]s contained in _this_.
  final Map<Uid, Entity> children;

  //TODO: explain
  /// The [RootDataset] associated with this [Entity].
  /// Note: For standard DICOM this is the [RootDataset],
  /// for Mint it is the Entity RootDataset.
  final RootDataset rds;

  //TODO: explain the difference between Mint encoding and standard DICOM.
  /// A DICOM Information Entity
  Entity(this.parent, this.uid, this.rds, Map<Uid, Entity> children)
      : children = (children == null) ? <Uid, Entity>{} : children;

  /// Returns a copy of [Entity], but with a  [Uid]. If [parent] is _null_
  /// the  [Entity] has the same parent as _this_.
  //TODO: how to create an interface without changing finals
  Entity.from(Entity entity, this.rds, Entity parent)
      : parent = (parent == null) ? entity.parent : parent,
        uid = Uid(),
        children = Map.from(entity.children);

  /// Returns the child that has [uid].
  Entity operator [](Uid uid) => children[uid];

  // **** Minimal Interface ****

  // The [name] of _this_.
  Type get type => runtimeType;

  /// The Information Entity Level of _this_.
  IELevel get level;

  /// The [Type] of the [parent].
  Type get parentType;

  /// The [Type] of the [children].
  Type get childType;

  // Issue: this could be '/$id' for all classes where id == uid for non-patient
  /// Returns a [String] containing the canonical pathname for _this_.
  String get path;

  /// Returns a [String] containing the full canonical pathname
  /// (i.e. including the [Patient] [Uid]) for _this_.
  String get fullPath;

  // **** End of Minimal Interface ****

  /// Returns a [String] containing information about _this_.
  String get info => toString();

  //TODO: this should handle sequence tags
  /// Returns the [Element] with [Tag] equal to [tag] in _this_.
  Element lookup(Tag tag) => rds[tag.code];

  /// Returns a [String] containing formatted output.
  String format(Formatter z) => z.fmt(this, children.values);

  @override
  String toString() => '$runtimeType($uid): (${children.length}) ';

  static Entity putWhenAbsent(
      Entity entity, Uid uid, Map<Uid, Entity> children) {
    final v = children.putIfAbsent(uid, () => entity);
    if (v != entity) return duplicateEntityError(v, entity);
    return entity;
  }
}
