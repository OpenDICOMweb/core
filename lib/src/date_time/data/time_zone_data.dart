// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.


const List<String> goodTimeZoneList = const [
  '+0000',
  '+0100',
  '+0200',
  '+1300',
  '+1400',
  '-0000',
  '-0100',
  '-0200',
  '-1100',
  '-1200',

  '+0030',
  '+0145',
  '+0230',
  '+1345',
  '+1400',
  '-0030',
  '-0145',
  '-0230',
  '-1145',
  '-1200',
];

const List<String> badTimeZoneList = const [
  // bad lengths
  '+',
  '+0',
  '+02',
  '+130',
  '+13000',
  '+130000',

  // bad chars
  'x1400',
  '+x000',
  '+0x00',
  '+02x0',
  '+130x',
  '-x000',
  '-0x00',
  '-02x0',
  '-130x',

  // too large
  '+1415',
  '+1430',
  '+1445',
  '+1500',

  // too small
  '-1215',
  '-1230',
  '-1245',
  '-1300',

  // bad minute
  '+0001',
  '+0122',
  '+0299',
  '+1346',
  '+1450',

  // bad hour
  '-1300',
  '-1400',
  '-2000',
  '-5000',
  '-3200',
];
