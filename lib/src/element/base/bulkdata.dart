//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/system.dart';
import 'package:core/src/utils/errors.dart';
//import 'package:core/src/values/errors.dart';

// Must implement Values and Value with reified.
abstract class BulkdataRef<E> {
  int get code;
  Uri get uri;

  List<E> get values;

  @override
  bool operator ==(Object other) =>
      (other is BulkdataRef) && code == other.code && uri == other.uri;

  @override
  int get hashCode => system.hasher.n2(code, uri);

  Iterator<E> get iterator => values.iterator;

  List<E> getBulkdata(int code, Uri uri) => unimplementedError();
}
