//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.base.string;

class StringBulkdata extends DelegatingList<String> with BulkdataRef<String> {
  @override
  final int code;
  @override
  final Uri uri;
  List<String> _values;

  StringBulkdata(this.code, this.uri, [this._values]) : super(_values);

  StringBulkdata.fromString(this.code, String s, [this._values])
      : uri = Uri.parse(s),
        super(_values);

  List<String> get delegate => _values;

  @override
  List<String> get values => _values ??= getBulkdata(code, uri);
}
