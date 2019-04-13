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
  Study(Patient patient, Uid uid, RootDataset rds, [Map<Uid, Series> seriesMap])
      : super(patient, uid, rds, seriesMap ?? <Uid, Series>{});

  /// Returns a copy of _this_ [Series], but with a  [Uid]. If [parent]
  /// is _null_ the  [Instance] is in the same [Series] as _this_.
  Study.from(Study study, RootDataset rds, [Patient parent])
      : super((parent == null) ? study.parent : parent, Uid(), rds,
            <Uid, Series>{});

  /// Returns a  [Study] created from the [RootDataset].
  factory Study.fromRootDataset(RootDataset rds, Patient patient) {
    assert(patient != null);
    final e = rds.lookup(kStudyInstanceUID, required: true);
    if (e == null) return elementNotPresentError(e);
    final uid = Uid(e.value);
    final study = Study(patient, uid, rds);
    return patient.addIfAbsent(study);
  }

  @override
  IELevel get level => IELevel.study;
  @override
  Type get childType => Series;

  /// Returns the [parent] of _this_ Study.
  Patient get patient => parent;

  /// Returns the [parent] of _this_ Study.
  Patient get subject => parent;

  /// Returns the [Series] of this [Study].
  Iterable<Series> get series => childMap.values;

  /// Returns a [List] of all the [Instance]s that belong to _this_.
  List<Instance> get instances {
    final list = <Instance>[];
    for (final s in series) list.addAll(s.instances);
    return list;
  }

  // TODO: remove when entity summary works
  @override
  String get summary {
    final sb = StringBuffer('Study Summary: $uid\n  Patient: $subject '
        '${series.length} Series\n');
    for (final s in series) {
      sb.write('  Series: ${s.uid}\n    ${s.instances.length} Instances\n');
      for (final i in s.instances) {
        sb.write('      $Instance: ${i.uid}\n'
            '        ${i.rds.length} Attributes\n');
      }
    }
    return sb.toString();
  }

  /// Returns a  [Series] created from _rds_.
  Series createSeriesFromRootDataset(RootDataset rds) =>
      Series.fromRootDataset(rds, this);

  @override
  String toPath() => '/$uid';
}
