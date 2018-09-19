// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'package:core/src/element/base/element.dart';

// ignore_for_file: public_member_api_docs

import 'issue_type.dart';

class Issues<E> {
  final IssueType type;

  /// The [Element] with the [IssueType].
  final Element<E> element;
  int invalidLength;

 Issues(this.type, this.element);

  String get asString => '$runtimeType.$type(${type.action}): $element';

  @override
  String toString() => asString;
}

