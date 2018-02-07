// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

/// The following data are generate with tools/generate_data.dart.import '

import 'package:core/server.dart';
// 0: data

List<int> data0 = <int>[
  143, 83, 77, 87, 1, 149, 74, 60, // No reformat
  135, 150, 139, 227, 179, 68, 64, 188
];


/*List<int> data0 = <int>[
  207, 206, 228, 240, 248, 183, 65, 3, // No reformat
  152, 144, 119, 219, 68, 6, 252, 107
];*/

String s0 = '8f534d57-0195-4a3c-8796-8be3b34440bc';
//String s0 = 'cfcee4f0-f8b7-4103-9890-77db4406fc6b';
Uuid uuidD0 = new Uuid.fromList(data0);
Uuid uuidS0 = Uuid.parse(s0);

// 1: data
List<int> data1 = <int>[
  126, 234, 178, 173, 199, 78, 67, 254, // No reformat
  151, 32, 219, 14, 9, 121, 117, 24
];
String s1 = '7eeab2ad-c74e-43fe-9720-db0e09797518';
Uuid uuidD1 = new Uuid.fromList(data1);
Uuid uuidS1 = Uuid.parse(s1);

// 2: data
List<int> data2 = <int>[
  153, 164, 102, 227, 105, 29, 78, 5, // No reformat
  189, 17, 31, 59, 34, 65, 6, 208
];
String s2 = '99a466e3-691d-4e05-bd11-1f3b224106d0';
Uuid uuidD2 = new Uuid.fromList(data2);
Uuid uuidS2 = Uuid.parse(s2);

// 3: data
List<int> data3 = <int>[
  40, 171, 210, 31, 184, 12, 71, 153, // No reformat
  140, 40, 197, 123, 126, 159, 45, 59
];
String s3 = '28abd21f-b80c-4799-8c28-c57b7e9f2d3b';
Uuid uuidD3 = new Uuid.fromList(data3);
Uuid uuidS3 = Uuid.parse(s3);

// 4: data
List<int> data4 = <int>[
  193, 208, 97, 34, 237, 9, 68, 189, // No reformat
  160, 96, 141, 48, 157, 126, 127, 38
];
String s4 = 'c1d06122-ed09-44bd-a060-8d309d7e7f26';
Uuid uuidD4 = new Uuid.fromList(data4);
Uuid uuidS4 = Uuid.parse(s4);

// 5: data
List<int> data5 = <int>[
  219, 4, 17, 218, 239, 205, 67, 64, // No reformat
  151, 114, 102, 155, 29, 38, 17, 237
];
String s5 = 'db0411da-efcd-4340-9772-669b1d2611ed';
Uuid uuidD5 = new Uuid.fromList(data5);
Uuid uuidS5 = Uuid.parse(s5);

// 6: data
List<int> data6 = <int>[
  132, 126, 61, 227, 74, 91, 73, 230, // No reformat
  138, 248, 168, 240, 240, 42, 198, 1
];
String s6 = '847e3de3-4a5b-49e6-8af8-a8f0f02ac601';
Uuid uuidD6 = new Uuid.fromList(data6);
Uuid uuidS6 = Uuid.parse(s6);

// 7: data
List<int> data7 = <int>[
  188, 121, 95, 50, 234, 98, 78, 235, // No reformat
  191, 48, 23, 30, 126, 28, 101, 225
];
String s7 = 'bc795f32-ea62-4eeb-bf30-171e7e1c65e1';
Uuid uuidD7 = new Uuid.fromList(data7);
Uuid uuidS7 = Uuid.parse(s7);

// 8: data
List<int> data8 = <int>[
  80, 68, 44, 131, 174, 253, 64, 3, // No reformat
  190, 123, 42, 159, 52, 38, 185, 3
];
String s8 = '50442c83-aefd-4003-be7b-2a9f3426b903';
Uuid uuidD8 = new Uuid.fromList(data8);
Uuid uuidS8 = Uuid.parse(s8);

// 9: data
List<int> data9 = <int>[
  72, 38, 166, 140, 240, 246, 79, 164, // No reformat
  163, 2, 154, 56, 189, 13, 249, 58
];
String s9 = '4826a68c-f0f6-4fa4-a302-9a38bd0df93a';
Uuid uuidD9 = new Uuid.fromList(data9);
Uuid uuidS9 = Uuid.parse(s9);

List<String> sList = <String>[
  '8f534d57-0195-4a3c-8796-8be3b34440bc.asString',
  '7eeab2ad-c74e-43fe-9720-db0e09797518.asString',
  '99a466e3-691d-4e05-bd11-1f3b224106d0.asString',
  '28abd21f-b80c-4799-8c28-c57b7e9f2d3b.asString',
  'c1d06122-ed09-44bd-a060-8d309d7e7f26.asString',
  'db0411da-efcd-4340-9772-669b1d2611ed.asString',
  '847e3de3-4a5b-49e6-8af8-a8f0f02ac601.asString',
  'bc795f32-ea62-4eeb-bf30-171e7e1c65e1.asString',
  '50442c83-aefd-4003-be7b-2a9f3426b903.asString',
  '4826a68c-f0f6-4fa4-a302-9a38bd0df93a.asString'
];

List<List<int>>  dList = <List<int>>[
  data0, data1, data2, data3, data4, data5, data6, data7, data8, data9
];

List<Uuid> dUuids = <Uuid>[
  uuidD0, uuidD1, uuidD2, uuidD3, uuidD4, uuidD5, uuidD6, uuidD7,
  uuidD8, uuidD9 // No reformat
];

List<Uuid>  sUuids = <Uuid>[
  uuidS0, uuidS1, uuidS2, uuidS3, uuidS4, uuidS5, uuidS6, uuidS7,
  uuidS8, uuidS9 // No reformat
];




