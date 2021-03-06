// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/errors.dart';
import 'package:core/src/entity/entity.dart';
import 'package:core/src/entity/ie_level.dart';
import 'package:core/src/entity/patient/patient.dart';
import 'package:core/src/entity/series.dart';
import 'package:core/src/entity/study.dart';

class Instance extends Entity {
  /// Pixel Data
  Uint8List _pixelData;

  /// Creates a new [Instance].
  Instance(Series series, Uid uid,RootDataset dataset)
      : super(series, uid, dataset, Entity.empty);

/* Flush if not needed
  /// Returns a copy of [this] [Instance], but with a new [Uid]. If [series]
  /// is [null] the new [Instance] is in the same [Series] as [this].
  Instance.from(Instance instance, Series parent)
      : _pixelData = instance.pixelData,
        super((parent == null) ? instance.parent : parent, new Uid(),
            new RootDataset.from(instance.dataset));
*/

  /// Returns a new [Instance] created from the [RootDataset].
  factory Instance.fromRDS(RootDataset rds, Series series) {
    assert(series != null);
    final e = rds[kSOPInstanceUID];
    if (e == null) return elementNotPresentError(e);
    final instanceUid = new Uid(e.value);
//    if (series == null) series = new Series.fromRootDataset(rds, study, subject);
    final instance = new Instance(series, instanceUid, rds);
    series.putIfAbsent(instance);
    return instance;
  }

  @override
  IELevel get level => IELevel.instance;
  @override
  Type get parentType => Series;
  @override
  Type get childType => null;

  @override
  String get path => '/${series.path}/$uid';

  @override
  String get fullPath => '/${series.fullPath}/$uid';

  /// The [Series] that is the [parent] of this [Instance].
  Entity get series => parent;

  /// The [study] that contains this [Instance].
  Study get study => series.parent;

  /// The [subject] of this [Instance].
  Patient get subject => study.subject;

  int get length => rds.length;

  Uid get sopClassUid => rds.sopClassUid;

  /// The DICOM Transfer Syntax for _this_ [Instance], if any.
  ///
  /// If the [Instance] does not contain an image(s) or video,
  /// the TransferSyntax will be null.
  TransferSyntax get transferSyntax => rds.transferSyntax;

  Uint8List get pixelData => _pixelData ??= rds[kPixelData].value;

  @override
  String get info {
    final s = (sopClassUid == null) ? 'null' : '$sopClassUid';
    return '''$runtimeType(${uid.asString}), SOPClass: $s, $length elements
    $series
      $study
        $subject
    ''';
  }

  @override
  String toString() => '$runtimeType(${uid.asString}), $length elements';

}
