// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
//
import 'package:base/base.dart';
import 'package:core/src/tag.dart';


// ignore_for_file: public_member_api_docs

void main(){
  final out = tokensToLookupMap(pcTagNames);
  print(out);
}

String creatorTokenToId(String s) {
  final sb = StringBuffer();

  if (isDigitChar(s.codeUnitAt(0))) sb.write('Uid_');
  for(var i = 0; i < s.length; i++) {
    final c = s.codeUnitAt(i);

    if (isAlphanumericChar(c)) {
      sb.writeCharCode(c);
    } else {
      sb.writeCharCode(k_);
    }
  }
  return '$sb';
}

String tokenToMapEntry(String token) {
  final id = creatorTokenToId(token);
  return "'$token': $id";
}

String tokensToLookupMap(List<String> tokens) {
  final entries = tokens.map(tokenToMapEntry);
  return '''
//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/tag.dart';
import 'package:core/src/tag/private/new_pc_tag_definitions.dart';
  
const Map<String, Map<int, PDTagDefinition>> creatorIdMap =
      const <String, Map<int, PDTagDefinition>>{
    ${entries.join(',\n  ')}  
      };
''';
}