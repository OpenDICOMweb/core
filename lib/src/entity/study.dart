//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/entity/entity.dart';
import 'package:core/src/entity/ie_level.dart';
import 'package:core/src/entity/instance.dart';
import 'package:core/src/entity/patient/patient.dart';
import 'package:core/src/entity/series.dart';
import 'package:core/src/values/uid.dart';

/// A DICOM [Study] in SOP Instance format.
class Study extends Entity {
  /// Creates a  Study.
  Study(Patient subject, Uid uid, RootDataset dataset,
      [Map<Uid, Series> seriesMap])
      : super(subject, uid, dataset, seriesMap ?? <Uid, Series>{});

  /// Returns a copy of _this_ [Series], but with a  [Uid]. If [parent]
  /// is _null_ the  [Instance] is in the same [Series] as _this_.
  Study.from(Study study, RootDataset rds, [Patient parent])
      : super((parent == null) ? study.parent : parent, Uid(), rds,
            <Uid, Series>{});

  /// Returns a  [Study] created from the [RootDataset].
  factory Study.fromRootDataset(RootDataset rds, [Patient patient]) {
    final e = rds.lookup(kStudyInstanceUID, required: true);
    final uid = Uid(e.value);
    patient ??= Patient.fromRDS(rds);
    final study = Study(patient, uid, rds);
    patient.addIfAbsent(study);
    return study;
  }

  @override
  IELevel get level => IELevel.study;
  @override
  Type get childType => Series;

  /// Returns the [Patient] of _this_ Study.
  Patient get subject => parent;

  /// Returns the [Series] of this [Study].
  Iterable<Series> get series => childMap.values;

  /// Returns a [List] of all the [Instance]s that belong to _this_.
  List<Instance> get instances {
    final list = <Instance>[];
    for (var s in series) list.addAll(s.instances);
    return list;
  }

  /// Returns a  [Series] created from _rds_.
  Series createSeriesFromRootDataset(RootDataset rds) =>
      Series.fromRootDataset(rds, this);
}
