// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.


/// Returns the date in Internet format.
String date(DateTime dt) => '${dt.year}-${dt.month}-${dt.day}';

/// Returns the time in Internet format.
String time(DateTime dt) => '${dt.hour}:${dt.minute}:${dt.second}';

/// Returns the date/time in Internet format.
String dateTime(DateTime dt) => '${date(dt)} ${time(dt)}';
