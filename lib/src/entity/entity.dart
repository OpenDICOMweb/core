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

/// DICOM Information Entities
///
/// 1. Every [Entity] is unique and is identified by its [Uid].
/// 2. When an [Entity] is copied its [Uid] is modified

// Issue:
//   1. Should we have separate classes for Patient, Patient, and Animal?

/// The Base [class] that is used to implement DICOM Information Entities
/// (see  PS3.1 and PS3.6).
abstract class Entity {
  static const Map<Uid, Entity> empty = const <Uid, Entity>{};

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
      : children = (children == null) ? <Uid, Entity>{} : children {
    //system.checkUidNotPresent(uid);
  }

  /// Returns a copy of [Entity], but with a new [Uid]. If [parent] is _null_
  /// the new [Entity] has the same parent as _this_.
  //TODO: how to create an interface without changing finals
  Entity.from(Entity entity, this.rds, Entity parent)
      : parent = (parent == null) ? entity.parent : parent,
        uid = new Uid(),
        children = new Map.from(entity.children);

  // TODO: how to prototype a factory constructor?
  // Entity.fromRootDataset(RootDataset rds);

  /// Returns the child that has [uid].
  Entity operator [](Uid uid) => children[uid];

  /// [putIfAbsent]s a child [Entity] with [uid].
  void operator []=(Uid uid, Entity e) {
    putIfAbsent(e);
  }

  /*@override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Entity) {
      if (uid != other.uid && parent != other.parent) return false;
      return true;
    }
    return false;
  }*/

  // **** Minimal Interface ****

  // The [name] of _this_.
  Type get type => runtimeType;
  /// The Information Entity Level of _this_.
  IELevel get level;

  /// The [Type] of the [parent].
  Type get parentType;

  /// The [Type] of the [children].
  Type get childType;

  /// Returns a [String] containing the canonical pathname for _this_.
  String get path;

  /// Returns a [String] containing the full canonical pathname
  /// (i.e. including the [Patient] [Uid]) for _this_.
  String get fullPath;

  // **** End of Minimal Interface ****

  /// Returns a [hashCode] for _this_.
  /*@override
  int get hashCode => Hash.k2(parent, uid);*/

  /// Returns a [String] containing information about _this_.
  String get info => toString();

  //TODO: this should handle sequence tags
  /// Returns the [Element] with [Tag] equal to [tag] in _this_.
  Element lookup(Tag tag) => rds[tag.code];

  /// Adds a new child to the Entity.  Throws a [DuplicateEntityError] if
  /// a an existing child has the same [Uid].
  Entity putIfAbsent(Entity entity) {
    final v = children.putIfAbsent(entity.uid, () => entity);
    if (v != entity) return duplicateEntityError(v, entity);
    return entity;
  }

  /// Returns a [String] containing formatted output.
  String format(Formatter z) => z.fmt(this, children.values);

  @override
  String toString() => '$runtimeType($uid): (${children.length}) ';

/*  static Entity fromRootDataset(RootDataset ds) {
    Uid study = ds.getUid(kStudyInstanceUID);
    if (study == null) missingUid(kStudyInstanceUID);
    Uid series = ds.getUid(kSeriesInstanceUID);
    if (study == null) missingUid(kSeriesInstanceUID);
    Uid instance = ds.getUid(kSOPInstanceUID);
    if (study == null) missingUid(kSOPInstanceUID);
    activeStudies.ad
  }*/
}


