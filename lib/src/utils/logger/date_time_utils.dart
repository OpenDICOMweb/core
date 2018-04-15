//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//


/// Returns the date in Internet format.
String date(DateTime dt) => '${dt.year}-${dt.month}-${dt.day}';

/// Returns the time in Internet format.
String time(DateTime dt) => '${dt.hour}:${dt.minute}:${dt.second}';

/// Returns the date/time in Internet format.
String dateTime(DateTime dt) => '${date(dt)} ${time(dt)}';
