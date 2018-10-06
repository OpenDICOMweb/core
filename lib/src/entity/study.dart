//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:collection';

import 'package:core/src/utils/primitives.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/entity/entity.dart';
import 'package:core/src/entity/ie_level.dart';
import 'package:core/src/entity/instance.dart';
import 'package:core/src/entity/patient/patient.dart';
import 'package:core/src/entity/series.dart';
import 'package:core/src/values/uid.dart';

/// A DICOM [Study] in SOP Instance format.
class Study extends Entity with MapMixin<Uid, Series> {
  /// An constant empty [seriesMap].
  static const Map kEmptySeriesMap = <Uid, Series>{};

  /// A Map from [Uid] to [Series].
  final HashMap<Uid, Series> seriesMap;

  /// Creates a  Study.
  Study(Patient subject, Uid uid, RootDataset dataset,
      [Map<Uid, Series> seriesMap])
      : seriesMap = seriesMap ?? HashMap(),
        super(subject, uid, dataset, seriesMap);

  /// Returns a copy of _this_ [Series], but with a  [Uid]. If [parent]
  /// is _null_ the  [Instance] is in the same [Series] as _this_.
  Study.from(Study study, RootDataset rds, [Patient parent])
      : seriesMap = HashMap(),
        super((parent == null) ? study.parent : parent, Uid(), rds,
            HashMap.from(study.seriesMap));

  /// Returns a  [Study] created from the [RootDataset].
  factory Study.fromRootDataset(RootDataset rds, [Patient patient]) {
    final e = rds.lookup(kStudyInstanceUID, required: true);
    final uid = Uid(e.value);
    patient ??= Patient.fromRDS(rds);
    final study = Study(patient, uid, rds);
    patient.putIfAbsent(uid, () => study);
    return study;
  }

  // **** Map Implementation

  @override
  Series operator [](Object o) => (o is Uid) ? seriesMap[o] : null;
  @override
  void operator []=(Uid uid, Series series) => seriesMap[uid] = series;
  @override
  Iterable<Uid> get keys => seriesMap.keys;
  @override
  void clear() => seriesMap.clear();
  @override
  Series remove(Object key) => (key is Uid) ? seriesMap.remove(key) : null;

  // **** End Map Implementation

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
  Iterable<Series> get series => seriesMap.values;

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
}
