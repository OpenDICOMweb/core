//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:bytes/bytes.dart';
import 'package:core/src/dataset/base.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/list_dataset/list_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/error.dart';

// ignore_for_file: public_member_api_docs

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
      : fmi = FmiList.empty(),
        codes = <int>[],
        elements = <Element>[],
        super(path, bd, fmiEnd);

  /// Creates a [ListRootDataset] from another [ListRootDataset].
  ListRootDataset.from(ListRootDataset rds)
      : fmi = FmiList.from(rds.fmi),
        codes = List<int>.from(rds.codes),
        elements = List<Element>.from(rds.elements),
        super(rds.path, rds.dsBytes.bytes, rds.dsBytes.fmiEnd);


  RootDataset copy([RootDataset rds]) => ListRootDataset.from(rds ?? this);
}

class FmiList extends Fmi {
  /// A sorted [List] of Tag Codes increasing order.
  List<int> codes;

  /// A sorted [List] of [Element]s in Tag Code order.
  @override
  List<Element> elements;

  FmiList(this.codes, this.elements);

  FmiList.empty()
      : codes = <int>[],
        elements = <Element>[];

  FmiList.from(FmiList fmi)
      : codes = List<int>.from(fmi.codes),
        elements = List<Element>.from(fmi.elements);

  @override
  Element operator [](int code) {
    final index = codes.indexOf(code);
    return elements[index];
  }

  @override
  void operator []=(int code, Element e) {
    assert(code == e.code);
    tryAdd(e);
  }

  bool tryAdd(Element e) {
    final code = e.code;
    final index = codes.indexOf(code);
    if (index == -1) {
      codes.add(code);
      elements.add(e);
      return true;
    } else {
      final old = elements[code];
      if (old != null) {
        duplicateElementError(old, e);
        return false;
      }
      return true;
    }
  }

  @override
  int get length => elements.length;

  @override
  set length(int n) => unsupportedSetter();

  @override
  String toString() => '$runtimeType: $length elements';
}
