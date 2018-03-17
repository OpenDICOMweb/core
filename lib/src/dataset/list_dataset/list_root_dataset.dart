// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/list_dataset/list_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/utils/bytes.dart';

/// A [ListRootDataset].
class ListRootDataset extends RootDataset with ListDataset {
  @override
  final FmiList fmi;

  /// A sorted [List] of Tag Codes increasing order.
  @override
  List<int> codes;

  /// A sorted [List] of [Element]s in Tag Code order.
  @override
  List<Element> elements;

  /// Creates an [ListRootDataset].
  ListRootDataset(this.fmi, this.codes, this.elements, String path,
      Bytes bd, int fmiEnd)
      : super(path, bd, fmiEnd);

  /// Creates an empty, i.e. without [Element]s, [ListRootDataset].
  ListRootDataset.empty(String path, Bytes bd, int fmiEnd)
      : fmi = new FmiList.empty(),
        codes = <int>[],
        elements = <Element>[],
        super(path, bd, fmiEnd);

  /// Creates a [ListRootDataset] from another [ListRootDataset].
  ListRootDataset.from(ListRootDataset rds)
      : fmi = new FmiList.from(rds.fmi),
        codes = new List<int>.from(rds.codes),
        elements = new List<Element>.from(rds.elements),
        super(rds.path, rds.dsBytes.bytes, rds.dsBytes.fmiEnd);

  RootDataset copy([RootDataset rds]) => new ListRootDataset.from(rds ?? this);
}

class FmiList extends Fmi with ListDataset {
  /// A sorted [List] of Tag Codes increasing order.
  @override
  List<int> codes;

  /// A sorted [List] of [Element]s in Tag Code order.
  @override
  List<Element> elements;

  FmiList(this.codes, this.elements);

  FmiList.empty()
      : codes = <int>[],
        elements = <Element>[];

  FmiList.from(FmiList fmi)
      : codes = new List<int>.from(fmi.codes),
        elements = new List<Element>.from(fmi.elements);

  @override
  String toString() => '$runtimeType: $length elements';
}
