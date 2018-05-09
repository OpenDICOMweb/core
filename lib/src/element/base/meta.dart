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
import 'package:core/src/utils/issues.dart';

abstract class MetaElementMixin  {
  Element get e;

  List get emptyList => e.emptyList;

  int get index => e.index;
  int get code => e.code;
  String get keyword => e.keyword;
  String get name => e.name;
  int get vrIndex => e.vrIndex;

  int get vmMin => e.vmMin;
  int get vmMax => e.vmMax;
  int get vmColumns => e.vmColumns;
  VM get vm => e.vm;

  bool get isPublic => e.isPublic;

  bool get isRetired => e.isRetired;

  Tag get tag => e.tag;

  int get maxLength => e.maxLength;
  int get maxVFLength => e.maxVFLength;
  int get vfLengthField => e.vfLengthField;

  Iterable get values => e.values;
  set values(Iterable<Object> vList) => e.values = vList;

  Object get value => e.value;

  TypedData get typedData => e.typedData;

  bool checkValues(Iterable vList, [Issues issues]) =>
      e.checkValues(vList, issues);

  bool checkValue(Object v, {Issues issues, bool allowInvalid = false}) =>
      e.checkValue(v, issues: issues, allowInvalid: allowInvalid);

  Element update([Iterable vList]) => e.update(vList);
}

