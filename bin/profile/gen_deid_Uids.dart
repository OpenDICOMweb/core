// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';


void main() {
  makeDeIdUidList();
}

String makeDeIdList() {
  final sb = new StringBuffer();
  sb.writeln('static const List<DeIdProfile> deIdTags = const <DeIdProfile>[');
  for(var v in DeIdProfile.map.values)
    sb.writeln('  k${v.tag.keyword},');
  sb.writeln('];\n');
  print('$sb');
}

String makeDeIdUidList() {
  final sb = new StringBuffer();
  sb.writeln('static const List<DeIdProfile> deIdUidTags = const '
                 '<DeIdProfile>[');
  for(var v in DeIdProfile.map.values) {
    if (v.name.('UID'))
      sb.writeln('  k${v.tag.keyword},');
  }
  sb.writeln('];\n');
  print('$sb');
}