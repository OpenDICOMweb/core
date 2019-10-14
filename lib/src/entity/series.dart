//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:constants/constants.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/entity/entity.dart';
import 'package:core/src/entity/ie_level.dart';
import 'package:core/src/entity/instance.dart';
import 'package:core/src/entity/patient/patient.dart';
import 'package:core/src/entity/study.dart';
import 'package:core/src/error.dart';
import 'package:core/src/values/uid.dart';

/// A DICOM [Series] Instance in SOP Instance format.
class Series extends Entity {
  /// Creates a  [Series].
  Series(Study study, Uid uid, RootDataset rds, [Map<Uid, Instance> instances])
      : super(study, uid, rds, instances ?? <Uid, Instance>{});

  /// Returns a copy of _this_ [Series], but with a  [Uid]. If [parent]
  /// is _null_ the  [Instance] is in the same [Series] as _this_.
  Series.from(Series series, RootDataset rds, [Study parent])
      : super((parent == null) ? series.parent : parent, Uid(), rds,
            <Uid, Instance>{});

  /// Returns a  [Series] created from the [RootDataset].
  factory Series.fromRootDataset(RootDataset rds, Study study) {
    assert(study != null);
    final e = rds.lookup(kSeriesInstanceUID, required: true);
    if (e == null) return elementNotPresentError(e);
    final uid = Uid(e.value);
    final series = Series(study, uid, rds);
    return study.addIfAbsent(series);
  }

  @override
  IELevel get level => IELevel.series;
  @override
  Type get childType => Instance;

  /// Returns the [Study] that is the [parent] of _this_ Series.
  Patient get patient => study.patient;

  /// Returns the [Study] that is the [parent] of _this_ Series.
  Patient get subject => study.patient;

  /// Returns the [Study] that is the [parent] of _this_ Series.
  Study get study => parent;

  /// Returns the [Instance]s contained in _this_.
  Iterable<Instance> get instances => childMap.values;

  /// Returns a  [Instance] created from [rds].
  Instance createInstanceFromRootDataset(RootDataset rds) =>
      Instance.fromRootDataset(rds, this);

  @override
  String toPath() => '/${parent.uid}/$uid';
}
