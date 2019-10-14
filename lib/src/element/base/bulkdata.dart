//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error/general_errors.dart';
import 'package:core/src/global.dart';

/// The base class for Bulkdata.
mixin BulkdataRef<V> {
  /// The Tag code of the Element containing _this_.
  int get code;

  /// The URI reference for _this_.
  Uri get uri;

  /// The values in the Value Field of _this_.
  Iterable<V> get values {
    _values ?? unimplementedError();
    return _values;
  }

  Iterable<V> _values;
  set values(Iterable<V> vList) => _values = vList;

  @override
  bool operator ==(Object other) =>
      (other is BulkdataRef) && code == other.code && uri == other.uri;

  @override
  int get hashCode => global.hasher.n2(code, uri);

  /// An [Iterator] for _This_.
  Iterator<V> get iterator => values.iterator;

  /// Returns a List of Bulkdata Values associated with this.
  List<V> getBulkdata(int code, Uri uri) {
    unimplementedError();
    return null;
  }
}


