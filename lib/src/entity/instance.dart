//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/dataset.dart';
import 'package:core/src/entity/entity.dart';
import 'package:core/src/entity/ie_level.dart';
import 'package:core/src/entity/patient/patient.dart';
import 'package:core/src/entity/series.dart';
import 'package:core/src/entity/study.dart';
import 'package:core/src/error.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

// ignore: prefer_void_to_null
class Instance extends Entity {
  /// Pixel Data
  Uint8List _pixelData;

  /// Creates a  [Instance].
  Instance(Series series, Uid uid, RootDataset dataset)
      : super(series, uid, dataset, null);

  /// Returns a copy of _this_ [Series], but with a  [Uid]. If [parent]
  /// is _null_ the  [Instance] is in the same [Series] as _this_.
  Instance.from(Instance instance, RootDataset rds, [Series parent])
      : super((parent == null) ? instance.parent : parent, Uid(), rds,
            <Uid, Instance>{});

  /// Returns a  [Instance] created from the [RootDataset].
  factory Instance.fromRootDataset(RootDataset rds, Series series) {
    assert(series != null);
    final e = rds.lookup(kSOPInstanceUID, required: true);
    if (e == null) return elementNotPresentError(e);
    final uid = Uid(e.value);
    final instance = Instance(series, uid, rds);
    return series.addIfAbsent(instance);
  }

  @override
  IELevel get level => IELevel.instance;
  @override
  Type get childType => null;

  /// The [Series] that is the [parent] of this [Instance].
  Entity get series => parent;

  /// The [study] that contains this [Instance].
  Study get study => series.parent;

  /// The [subject] of this [Instance].
  Patient get subject => study.patient;

  @override
  int get length => rds.length;

  /// The DICOM Transfer Syntax for _this_ [Instance], if any.
  ///
  /// If the [Instance] does not contain an image(s) or video,
  /// the TransferSyntax will be null.
  TransferSyntax get transferSyntax => rds.transferSyntax;

  Uint8List get pixelData => _pixelData ??= rds[kPixelData].value;

  @override
  String get info {
    final s = (uid == null) ? 'null' : '$uid';
    return '''$runtimeType(${key.asString}), SOPClass: $s, $length elements
    $series
      $study
        $subject
    ''';
  }

  @override
  String toString() => '$runtimeType(${key.asString}), $length elements';
}
