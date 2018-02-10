// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/src/element/base/element.dart';
import 'package:core/src/tag/tag_lib.dart';

//TODO: each private creator in the same Private Group MUST have a distinct identifier;
abstract class MetaElement<V> extends Element<V> {
  Element get e;

  @override
  List<V> get emptyList => e.emptyList;

  @override
  Tag get tag => e.tag;
  //Why are these 3 necessary
  @override
  int get code => tag.code;
  @override
  String get keyword => tag.keyword;
  @override
  int get vrIndex => tag.vrIndex;
  @override
  int get vrCode => tag.vrCode;
  @override
  VM get vm => tag.vm;
  @override
  int get sizeInBytes => tag.elementSize;
  @override
  List<V> get values => e.values;
  @override
  V get value => e.value;
}

// Must implement Values and Value with reified.
abstract class BulkdataRef<V> extends Element<V> {
  Element get e;
  String get uri;

  @override
  List<V> get emptyList => e.emptyList;
  @override
  Tag get tag => e.tag;
  //Why are these 3 necessary
  @override
  int get code => tag.code;
  @override
  String get keyword => tag.keyword;
  @override
  int get vrIndex => tag.vrIndex;
  @override
  int get vrCode => tag.vrCode;
  @override
  VM get vm => tag.vm;
  @override
  int get sizeInBytes => tag.elementSize;
}
