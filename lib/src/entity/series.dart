//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:collection';

import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/entity/entity.dart';
import 'package:core/src/entity/ie_level.dart';
import 'package:core/src/entity/instance.dart';
import 'package:core/src/entity/patient/patient.dart';
import 'package:core/src/entity/study.dart';
import 'package:core/src/error.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values/uid.dart';

/// A DICOM [Series] Instance in SOP Instance format.
class Series extends Entity with MapMixin<Uid, Instance> {
  /// An constant empty [instanceMap].
  static const Map kEmptyInstanceMap = <Uid, Series>{};

  /// A Map from [Uid] to [Instance].
  final HashMap<Uid, Instance> instanceMap;
  
  /// Creates a  [Series].
  Series(Study study, Uid uid, RootDataset rds, [Map<Uid, Instance> instances])
      : instanceMap = instances ?? HashMap(),
        super(study, uid, rds, instances);

  /// Returns a copy of _this_ [Series], but with a  [Uid]. If [parent]
  /// is _null_ the  [Instance] is in the same [Series] as _this_.
  Series.from(Series series, RootDataset rds, [Study parent])
      : instanceMap = HashMap(),
        super((parent == null) ? series.parent : parent, Uid(), rds,
          HashMap.from(series.instanceMap));

  /// Returns a  [Series] created from the [RootDataset].
  factory Series.fromRootDataset(RootDataset rds, [Study study]) {
    final e = rds.lookup(kSeriesInstanceUID, required: true);
    final uid = Uid(e.value);
    study ??= Study.fromRootDataset(rds);
    final series = Series(study, uid, rds);
    study.putIfAbsent(uid, () => series);
    return series;
  }

  // **** Map Implementation

  @override
  Instance operator [](Object o) => (o is Uid) ? instanceMap[o] : null;
  @override
  void operator []=(Uid uid, Instance instance) => instanceMap[uid] = instance;
  @override
  Iterable<Uid> get keys => instanceMap.keys;
  @override
  void clear() => instanceMap.clear();
  @override
  Instance remove(Object key) => (key is Uid) ? instanceMap.remove(key) : null;

  // **** End Map Implementation
  
  @override
  IELevel get level => IELevel.series;
  @override
  Type get parentType => Study;
  @override
  Type get childType => Instance;
  @override
  String get path => '/${study.path}/$uid';
  @override
  String get fullPath => '/${study.fullPath}/$uid';
  @override
  String get info => '''$this
  $study
    $subject
  ''';

  /// Returns the [Study] that is the [parent] of _this_ Series.
  Study get study => parent;

  /// Returns the [Study] that is the [parent] of _this_ Series.
  Patient get subject => study.subject;

  /// Returns the [Instance]s contained in _this_.
  Iterable<Instance> get instances => instanceMap.values;

  /// Returns a  [Instance] created from [rds].
  Instance createInstanceFromRootDataset(RootDataset rds) =>
      Instance.fromRootDataset(rds, this);
}
