// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';

typedef Element DeIdAdd<V>(Dataset ds, int index, Element<V> e);
typedef List<Element> DeIdAddAll<V>(Dataset ds, int index, List<Element<V>> e);

typedef Element<V> DeIdUpdate<V>(Dataset ds, int index, List<V> vList);
typedef Element<V> DeIdUpdateF<V>(Dataset ds, int index, List<V> f(List<V> vList));
typedef List<Element> DeIdUpdateAll<V>(Dataset ds, int index, List<Element<V>> e);
typedef List<Element> DeIdUpdateAllF<V>(Dataset ds, int index, List<V> f(List<V> vList));

typedef List<V> DeIdReplace<V>(Dataset ds, int index, List<V> vList);
typedef List<V> DeIdReplaceF<V>(Dataset ds, int index, List<V> f(List<V> vList));
typedef List<Element> DeIdReplaceAll<V>(Dataset ds, int index, List<V> vList);
typedef List<Element> DeIdReplaceAllF<V>(Dataset ds, int index, List<V> f(List<V> vList));

typedef Element DeIdDelete(Dataset ds, int index);
typedef List<Element> DeIdDeleteAll(Dataset ds, int index);

//TODO: document
/// A DICOM Data Element Type.  See PS3.5, Section 7.4.
abstract class DeIdOption {
  int get index;
  String get keyword;
  Function get method;

  List<Element> call(Dataset ds, int index, [Function f]) => method(ds, index, f);

  static const List<DeIdOption> kByIndex = const <DeIdOption>[];

  static DeIdOption lookupByIndex(int index) => kByIndex[index];

  static  const Map<String, DeIdOption>  kByKeyword = const <String, DeIdOption>{};

  static DeIdOption lookupByKeyword(String keyword) => kByKeyword[keyword];

  @override
  String toString() => '$runtimeType($keyword)';
}

Element delete(Dataset ds, int index) => ds.delete(index);

class DeIdBasic {
	final int  index;
	final String  keyword;
	final Function  method;

	const DeIdBasic(this.index, this.keyword, this.method);

	List<Element> call(Dataset ds, int index, [Function f]) => method(ds, index, f);

	static const Function kNoOp = const DeIdBasic(1, 'true', delete);

	static const List<DeIdBasic> kByIndex = const <DeIdBasic>[];

	static  DeIdBasic lookupByIndex(int index) => kByIndex[index];

	static  const Map<String, DeIdBasic>  kByKeyword = const <String, DeIdBasic>{};

	static  DeIdBasic lookupByKeyword(String keyword) => kByKeyword[keyword];

	@override
	String toString() => '$runtimeType($keyword)';
}
