//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/entity/entity.dart';
import 'package:core/src/entity/ie_level.dart';
import 'package:core/src/entity/patient/patient.dart';
import 'package:core/src/entity/series.dart';
import 'package:core/src/entity/study.dart';
import 'package:core/src/error.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

class Instance extends Entity {
  /// Pixel Data
  Uint8List _pixelData;

  /// Creates a new [Instance].
  Instance(Series series, Uid uid,RootDataset dataset)
      : super(series, uid, dataset, Entity.empty);

  /// Returns a new [Instance] created from the [RootDataset].
  factory Instance.fromRDS(RootDataset rds, Series series) {
    assert(series != null);
    final e = rds[kSOPInstanceUID];
    if (e == null) return elementNotPresentError(e);
    final instanceUid = new Uid(e.value);
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
