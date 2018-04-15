//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/base.dart';
import 'package:core/src/dataset/base/errors.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/entity/entity.dart';
import 'package:core/src/entity/ie_level.dart';
import 'package:core/src/entity/instance.dart';
import 'package:core/src/entity/patient/patient.dart';
import 'package:core/src/entity/study.dart';
import 'package:core/src/value/uid.dart';

/// A DICOM [Series] Instance in SOP Instance format.
class Series extends Entity {

  /// Creates a new [Series].
  Series(Study study, Uid uid, RootDataset rds,
      [Map<Uid, Instance> instances])
      : super(study, uid, rds,
            (instances == null) ? <Uid, Instance>{} : instances);

  /// Returns a copy of _this_ [Series], but with a new [Uid]. If [parent]
  /// is _null_ the new [Instance] is in the same [Series] as _this_.
  Series.from(Series series, RootDataset rds, [Study parent])
      : super((parent == null) ? series.parent : parent, new Uid(), rds,
            new Map.from(series.children));

  /// Returns a new [Series] created from the [RootDataset].
  factory Series.fromRootDataset(RootDataset rds, Study study) {
    assert(study != null);
    final e = rds[kSeriesInstanceUID];
    if (e == null) return elementNotPresentError(e);
    final seriesUid = new Uid(e.value);
    // log.debug('seriesUid: $seriesUid');
    final series = new Series(study, seriesUid, rds);
    study.putIfAbsent(series);
    return series;
  }

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

  Iterable<Instance> get instances => children.values;

  Instance createInstanceFromRootDataset(RootDataset rds) =>
      new Instance.fromRDS(rds, this);
}
