// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

const List<String> goodDcmTimes = const <String>[
  '000000',
  '190101',
  '235959',
  '010101.1',
  '010101.11',
  '010101.111',
  '010101.1111',
  '010101.11111',
  '010101.111111',
  '000000.0',
  '000000.00',
  '000000.000',
  '000000.0000',
  '000000.00000',
  '000000.000000',
  '00',
  '0000',
  '000000',
  '000000.1',
  '000000.111111',
  '01',
  '0101',
  '010101',
  '010101.1',
  '010101.111111',
  '10',
  '1010',
  '101010',
  '101010.1',
  '101010.111111',
  '22',
  '2222',
  '222222',
  '222222.1',
  '222222.111111',
  '23',
  '2323',
  '232323',
  '232323.1',
  '232323.111111',
  '23',
  '2359',
  '235959',
  '235959.1',
  '235959.111111',
];

const List<String> badDcmTimes = const <String>[
  '241318', // bad hour
  '006132', // bad minute
  '006060', // bad minute and second
  '000060', // bad month and day
  '-00101', // bad character in hour
  'a00101', // bad character in hour
  '0a0101', // bad character in hour
  'ad0101', // bad characters in hour
  '19a101', // bad character in minute
  '190b01', // bad character in minute
  '1901a1', // bad character in second
  '19011a', // bad character in second
  '999999.9', '999999.99', '999999.999',
  '999999.9999', '999999.99999', '999999.999999', //don't format
  //Urgent: test fractions
];

const List<int> goodTimeFractionValues = const <int>[
  100000, 110000, 111000, 111100, 111110, 111111,
  000000, 000000, 000000, 000000, 000000, 000000,
  900000, 990000, 999000, 999900, 999990, 999999 //no reformat
];

const List<int> goodFractionValues = const <int>[
  1, 11, 111, 1111, 11111, 111111,
  0, 00, 000, 0000, 00000, 000000,
  9, 99, 999, 9999, 99999, 999999 //no reformat
];

const List<String> goodFractionStrings = const <String>[
  '.1',
  '.11',
  '.111',
  '.1111',
  '.11111',
  '.111111',
  '.0',
  '.00',
  '.000',
  '.0000',
  '.00000',
  '.000000',
  '.9',
  '.99',
  '.999',
  '.9999',
  '.99999',
  '.999999',
];

const List<String> badFractionStrings = const <String>[
  'a',
  'aa',
  '.',
  '.a',
  '.1a',
  '.11x',
  '.111*',
  '.1111.',
  '.11111,',
  '0',
  '00',
  '.,00',
  '.*000',
  '.00-000',
  '.00000+00',
  '.00000000zx',
];

const List<String> badTimeFractionStrings = const <String>[
  'a',
  'aa',
  '.',
  '.a',
  '.1a',
  '.11x',
  '.111*',
  '.1111.',
  '.11111,',
  '0',
  '00',
  '.,00',
  '.*000',
  '.00-000',
  '.00000+00',
  '.00000000', //Too Long
];
