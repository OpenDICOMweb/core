// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/list_dataset/list_dataset.dart';
import 'package:core/src/element/base/element.dart';

/// A [ListRootDataset].
class ListRootDataset extends RootDataset with ListDataset {
  @override
  final FmiList fmi;

  /// A sorted [List] of Tag Codes increasing order.
  @override
  List<int> codeList;

  /// A sorted [List] of [Element]s in Tag Code order.
  @override
  List<Element> elementList;

  /// Creates an [ListRootDataset].
  ListRootDataset(this.fmi, this.codeList, this.elementList, String path,
      ByteData bd, int fmiEnd)
      : super(path, bd, fmiEnd);

  /// Creates an empty, i.e. without [Element]s, [ListRootDataset].
  ListRootDataset.empty(String path, ByteData bd, int fmiEnd)
      : fmi = new FmiList.empty(),
        codeList = <int>[],
        elementList = <Element>[],
        super(path, bd, fmiEnd);

  /// Creates a [ListRootDataset] from another [ListRootDataset].
  ListRootDataset.from(ListRootDataset rds)
      : fmi = new FmiList.from(rds.fmi),
        codeList = new List<int>.from(rds.codeList),
        elementList = new List<Element>.from(rds.elementList),
        super(rds.path, rds.dsBytes.bd, rds.dsBytes.fmiEnd);

  RootDataset copy([RootDataset rds]) => new ListRootDataset.from(rds ?? this);
}

class FmiList extends Fmi with ListDataset {
  /// A sorted [List] of Tag Codes increasing order.
  @override
  List<int> codeList;

  /// A sorted [List] of [Element]s in Tag Code order.
  @override
  List<Element> elementList;

  FmiList(this.codeList, this.elementList);

  FmiList.empty()
      : codeList = <int>[],
        elementList = <Element>[];

  FmiList.from(FmiList fmi)
      : codeList = new List<int>.from(fmi.codeList),
        elementList = new List<Element>.from(fmi.elementList);

  @override
  String toString() => '$runtimeType: $length elements';
}
