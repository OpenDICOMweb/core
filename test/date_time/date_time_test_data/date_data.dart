//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

//Good dates
const List<String> goodDcmDateList = [
  '19500718', '19000101', '19700101',
  '19931010', '20171231', '20171130',
  '20501231'
];

//Bad dates
const List<String> badDcmDateList = [
  '19501318', // bad month
  '20041313', // bad month
  '19804312', //bad month
  '00000032', // bad month and day
  '00000000', // bad month and day
  '19800541', //bad day
  '19501032', // bad day
  '-9700101', // bad character in year
  '1b700101', // bad character in year
  '19c00101', // bad character in year
  '197d0101', // bad character in year
  '1970a101', // bad character in month
  '19700b01', // bad character in month
  '197001a1', // bad character in day
  '1970011a', // bad character in day
];

//Bad dates
const List<String> badInetDateList = [
  '1950-13-18', // bad month
  '2004-13-13', // bad month
  '1980-43-12', //bad month
  '0000-00-32', // bad month and day
  '0000-00-00', // bad month and day
  '1980-05-41', //bad day
  '1950-10-32', // bad day
  '-970-01-01', // bad character in year
  '1b70-01-01', // bad character in year
  '19c0-01-01', // bad character in year
  '197d-01-01', // bad character in year
  '1970-a1-01', // bad character in month
  '1970-0b-01', // bad character in month
  '1970-01-a1', // bad character in day
  '1970-01-1a', // bad character in day
];




