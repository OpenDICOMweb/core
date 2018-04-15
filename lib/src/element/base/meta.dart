//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/element/base/element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/errors.dart';
import 'package:core/src/utils/issues.dart';

abstract class MetaElementMixin<V>  {
  Element get e;

  List<V> get emptyList => e.emptyList;

  Tag get tag => e.tag;

  //Why are these 3 necessary
  int get code => e.code;

  String get keyword => e.keyword;

  int get vrIndex => e.vrIndex;

  VM get vm => e.vm;

  int get maxLength => e.maxLength;
  int get maxVFLength => e.maxVFLength;
  int get vfLengthField => e.vfLengthField;

  int get padChar => e.padChar;

  Iterable<V> get values => e.values;

  V get value => e.value;

  TypedData get typedData => e.typedData;

  bool checkValues(Iterable<V> vList, [Issues issues]) =>
      e.checkValues(vList, issues);

  bool checkValue(V v, {Issues issues, bool allowInvalid = false}) =>
      e.checkValue(v, issues: issues, allowInvalid: allowInvalid);

  Element<V> update([Iterable<V> vList]) => e.update(vList);
}

// Must implement Values and Value with reified.
class BulkdataRef<V> extends Element<V> with MetaElementMixin<V> {
  @override
  Element e;
  String uri;

  BulkdataRef(this.e, this.uri);

  @override
  Iterable<V> get values => _values ??= unimplementedError();
  Iterable<V> _values;
  @override
 set values(Iterable<V> vList) => _values ??= vList;

}
