//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/error/general_errors.dart';
import 'package:core/src/system.dart';

// Must implement Values and Value with reified.
abstract class BulkdataRef<V> {
  int get code;
  //TODO: add Element?
  //  Element get e;
  Uri get uri;

  Iterable<V> get values => _values ??= unimplementedError();
  Iterable<V> _values;
  set values(Iterable<V> vList) => _values ??= vList;

  @override
  bool operator ==(Object other) =>
      (other is BulkdataRef) && code == other.code && uri == other.uri;

  @override
  int get hashCode => global.hasher.n2(code, uri);

  Iterator<V> get iterator => values.iterator;

  List<V> getBulkdata(int code, Uri uri) => unimplementedError();
}


