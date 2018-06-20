//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/element/base/element.dart';

abstract class DatasetPrimitives<V> {

  List<V> empty(int tag);

  List<V> value(int tag);

  bool require(int tag);

  List<V> replace(int tag, List<V> vList);

  List<V> encrypt(int tag, V key);

  V lookup(Object resource, String columnKey, String rowKey);

  bool updateResource(
      Object resource, String columnKey, String rowKey, V value);

  // **** Global Methods ****

  /// Removes all private [Element]s from _this_.
  void removePrivate();

  /// Removes all [Element]s int [group] from _this_.
  void removeGroup(int group);

}

abstract class ElementPrimitives<V> {
  List<V> noValue(int tag);

  List<V> value(int tag);

  bool require(int tag);

  List<V> replace(int tag, List<V> vList);

  List<V> encrypt(int tag, V key);

  V lookup(Object resource, String columnKey, String rowKey);

  bool updateResource(
      Object resource, String columnKey, String rowKey, V value);
}

abstract class StringElementPrimitives<V> {
  List<String> prepend(int tag, String s);

  List<String> append(int tag, String s);

  // Note: does not include [position] (start or end) parameter.
  List<String> truncate(int tag, int maxLength);

  bool equal(int tag, String match);
}
