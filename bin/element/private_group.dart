//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';

//FIX or Flush
void main() {
  const creatorCode = 0x00290010;
  final pcTag = PCTag.make(creatorCode, kLOIndex, 'CAMTRONICS IP');
  print('Creator Tag: ${pcTag.info}');
  final lo = new LOtag(pcTag, ['CAMTRONICS IP']);
  print('LO: ${lo.info}');
//  print('Creator: ${creator.info}');
 // print('cElement: ${dcm(creator.code)}, '
//      'pcTag: ${dcm(creator.tag.code)}');
  const pDataCode = 0x00291010;
  final pdTag = PDTag.make(pDataCode, kUNIndex, pcTag);
  print('PDTag: ${pdTag.info}');
  // PrivateData data = new PrivateData(pdTag, lo);
  // print('PData: ${data.info}');
}

/*
bool _inSubGroup(PrivateCreator creator, int pDataCode) {
  //if (creator..containsKey(pDataCode)) return true;

  PCTag tag = creator.tag;
  //print('isPrivateData: ${isPDTag(data)}');
  print('Creator group:  ${creator.tag.group}');
 // print('Data group:  ${creator.data}');
  int base = tag.base;
  //int base0 = creator.base;
  int elt = tag.elt;
  print('base:  $base');
  print('elt: $elt');
  print('base + 0x00: ${base + 0x00}');
  print('base + 0xFF: ${base + 0xFF}');
  bool z = (tag.isValidDataCode(pDataCode) &&
      (tag.dataTags.keys.contains(pDataCode)));
  print('z: $z');
  //TODO: fix
  if (tag.group == creator.tag.group) {
    elt = tag.elt;
    print('base:  ${tag.base}');
    print('elt: $elt');
    print('limit: ${tag.limit}');
    var x = ((elt >= (base + 0x00)) && (elt <= (base + 0xFF)));
    print('x: $x');
    if ((elt >= (base + 0x00)) && (elt <= (base + 0xFF))) return true;
  }
  return false;
}
*/
