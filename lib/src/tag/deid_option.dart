//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';

// ignore_for_file: public_member_api_docs

typedef DeIdAdd = Element Function<V>(Dataset ds, int index, Element<V> e);
typedef DeIdAddAll = List<Element> Function<V>(
    Dataset ds, int index, List<Element<V>> e);

typedef DeIdUpdate<V> = Element<V> Function<V>(
    Dataset ds, int index, List<V> vList);

typedef Element<V> DeIdUpdateF<V>(
    Dataset ds, int index, List<V> f(List<V> vList));

typedef DeIdUpdateAll = List<Element> Function<V>(
    Dataset ds, int index, List<Element<V>> e);

typedef List<Element> DeIdUpdateAllF<V>(
    Dataset ds, int index, List<V> f(List<V> vList));

typedef DeIdReplace = List<V> Function<V>(Dataset ds, int index, List<V> vList);

typedef List<V> DeIdReplaceF<V>(
    Dataset ds, int index, List<V> f(List<V> vList));

typedef DeIdReplaceAll = List<Element> Function<V>(
    Dataset ds, int index, List<V> vList);

typedef List<Element> DeIdReplaceAllF<V>(
    Dataset ds, int index, List<V> f(List<V> vList));

typedef DeIdDelete = Element Function(Dataset ds, int index);
typedef DeIdDeleteAll = List<Element> Function(Dataset ds, int index);

//TODO: document
/// A DICOM Data Element Type.  See PS3.5, Section 7.4.
abstract class DeIdOption {
  int get index;
  String get keyword;
  Function get method;

  List<Element> call(Dataset ds, int index, [Function f]) =>
      method(ds, index, f);

  static const List<DeIdOption> kByIndex = <DeIdOption>[];

  static DeIdOption lookupByIndex(int index) => kByIndex[index];

  static const Map<String, DeIdOption> kByKeyword = <String, DeIdOption>{};

  static DeIdOption lookupByKeyword(String keyword) => kByKeyword[keyword];

  @override
  String toString() => '$runtimeType($keyword)';
}

Element delete(Dataset ds, int index) => ds.delete(index);

class DeIdBasic {
  final int index;
  final String keyword;
  final Function method;

  const DeIdBasic(this.index, this.keyword, this.method);

  List<Element> call(Dataset ds, int index, [Function f]) =>
      method(ds, index, f);

  static const Function kNoOp = DeIdBasic(1, 'true', delete);

  static const List<DeIdBasic> kByIndex = <DeIdBasic>[];

  static DeIdBasic lookupByIndex(int index) => kByIndex[index];

  static const Map<String, DeIdBasic> kByKeyword = <String, DeIdBasic>{};

  static DeIdBasic lookupByKeyword(String keyword) => kByKeyword[keyword];

  @override
  String toString() => '$runtimeType($keyword)';
}
