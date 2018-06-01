//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart';

void main() {
  Server.initialize(name: 'bin/element', level: Level.debug3);
  Iterable<String> dQuoteList(List<String> vList) => vList.map((s) => '$s');

  const titles = const <String>['foo', 'bar', 'a', 'b', 'c', 'd'];
  const badTitles = const <String>[
    'foo',
    'bar',
    '012345678901234567',
    'b\n',
    'c\x00',
    'd'
  ];

  final ds = new TagRootDataset.empty();

  final ae0 = new AEtag(PTag.kSpecificCharacterSet, titles);
  ds[ae0.code] = ae0;
  log.debug('ae0 info: ${ae0.info}');
  final bytes = ae0.vfBytes;

  final ae1 = AEtag.fromBytes(PTag.kSpecificCharacterSet, bytes);
  ds.add(ae1);
  log.debug('ae1 info: ${ae1.info}');
  final v = ae1.values;
  log.debug('ae1 values: ${dQuoteList(v)}');

  final Element ae2 = new AEtag(PTag.kSpecificCharacterSet, badTitles);
  ds.add(ae2);
  log..debug('ae2 info: ${ae2.info}')..debug('${ds.info}');

  final Element sh0 = new SHtag(PTag.kSpecificCharacterSet, titles);
  ds[sh0.code] = sh0;
  log.debug('sh0 info: ${sh0.info}');
  final b0 = sh0.vfBytes;
  log.debug('vfBytes: (${b0.length})$b0');
  final s0 = new String.fromCharCodes(sh0.vfBytes);
  log.debug('S from vfBytes: (${s0.length})"$s0"');

  final sh1 = SHtag.fromBytes(b0, PTag.kSpecificCharacterSet);
  ds.add(sh1);
  log.debug('sh1 info: ${sh1.info}');
  final v1 = sh1.values;
  log.debug('sh1 values: ${dQuoteList(v1)}');

  final sh2 = new SHtag(PTag.kSpecificCharacterSet, badTitles);
  ds.add(sh2);

  log..debug('sh2 info: ${sh2.info}')..debug('${ds.info}')..debug('done');
}
