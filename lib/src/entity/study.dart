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
      [Map<Uid, Series> series])
      : super(
            subject, uid, dataset, (series == null) ? <Uid, Series>{} : series);

  /// Returns a copy of _this_ [Series], but with a  [Uid]. If [parent]
  /// is _null_ the  [Instance] is in the same [Series] as _this_.
  Study.from(Study study, RootDataset rds, [Patient parent])
      : super((parent == null) ? study.parent : parent, Uid(), rds,
            Map.from(study.children));

  /// Returns a  [Study] created from the [RootDataset].
  factory Study.fromRootDataset(RootDataset rds, [Patient parent]) {
    final e = rds.lookup(kStudyInstanceUID, required: true);
    final studyUid = Uid(e.value);
    parent ??= Patient.fromRDS(rds);
    final study = Study(parent, studyUid, rds);
    parent.putIfAbsent(study);
    return study;
  }

  @override
  IELevel get level => IELevel.study;
  @override
  Type get parentType => Patient;
  @override
  Type get childType => Series;
  @override
  String get path => '/$uid';
  @override
  String get fullPath => '/${subject.uid}/$uid';
  @override
  String get info => '$this\n  $subject';

  /// Returns the [Patient] of _this_ Study.
  Patient get subject => parent;

  /// Returns the [Series] of this [Study].
  Iterable<Series> get series => children.values;

  /// Returns a [List] of all the [Instance]s that belong to _this_.
  List<Instance> get instances {
    final list = <Instance>[];
    for (var s in series) list.addAll(s.instances);
    return list;
  }

  /// Returns a  [Series] created from _rds_.
  Series createSeriesFromRootDataset(RootDataset rds) =>
      Series.fromRootDataset(rds, this);

  /// Returns a [String] containing summary information about _this_.
  String get summary {
    final sb = StringBuffer('Study Summary: $uid\n  Patient: $subject '
        '${series.length} Series\n');
    for (var s in series) {
      sb.write('  Series: ${s.uid}\n    ${s.instances.length} Instances\n');
      for (var i in s.instances) {
        sb.write('      $Instance: ${i.uid}\n'
            '        ${i.rds.length} Attributes\n');
      }
    }
    return sb.toString();
  }

  /// Adds a  [Series] to the [Study].  Throws a [DuplicateEntityError]
  /// if _this_ has an existing [Series] with the same [Uid].
  Series putIfAbsent(Series series) {
    final v = children.putIfAbsent(series.uid, () => series);
    if (v != series) return duplicateEntityError(v, series);
    return series;
  }
}
