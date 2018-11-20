//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

const List<String> goodTimeZoneList = [
  '+0000',
  '+0100',
  '+0200',
  '+1300',
  '+1400',
  '-0100',
  '-0200',
  '-1100',
  '-1200',
  '+1400',
  '-1200',
];

const List<String> badTimeZoneList = [
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
