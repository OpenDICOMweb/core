// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:collection';

import 'package:core/src/errors.dart';

/*
class BulkdataIterator<E> {
  int index = -1;
  final List<E> values;

  BulkdataIterator(this.values);

  E get current => values[index];

  bool moveNext() {
    if (index < -1 || index >= values.length) return false;
    index++;
    return true;
  }
}
*/

// Must implement Values and Value with reified.
abstract class BulkdataRef<E> extends IterableBase<E> {
  int get code;
  String get uri;

  List<E> _values;
  List<E> get values => _values ??= getBulkdata(code, uri);

  @override
  Iterator<E> get iterator => values.iterator;

  List<E> getBulkdata(int code, String uri) => unimplementedError();
}
