//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//


const List<String> goodDcmDateTimeList = const [
  '19500718105630',
  '00000101010101',
  '19700101000000',
  '20161229000000',
  '19991025235959',
  '20170223122334.111111',
  '20120228105630', // leap year
  '20080229105630', // leap year
  '20160229105630', // leap year
  '20200125105630', // leap year
  '20240229105630', // leap year
];

const List<String> badDcmDateTimeList = const [
  '19501318105630', //bad months
  '19501032105630', // bad day
  '00000000000000', // bad month and day
  '19501032105660', // bad day and second
  '00000032240212', // bad month and day and hour
  '20161229006100', // bad minute
  '-9700101226a22', // bad character in year minute
  '1b7001012a1045', // bad character in year and hour
  '19c001012210a2', // bad character in year and sec
  '197d0101105630', // bad character in year
  '1970a101105630', // bad character in month
  '19700b01105630', // bad character in month
  '197001a1105630', // bad character in day
  '1970011a105630', // bad character in day
  '20120230105630', // bad day in leap year
  '20160231105630', // bad day in leap year
  '20130229105630', // bad day in year
  '20230229105630', // bad day in year
  '20210229105630', // bad day in year
];
