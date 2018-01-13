// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:system/server.dart';

void main() {
	Server.initialize();

	var tableOut = 'const List kKnownTimeZones = const [\n  $unknown\n  ';
	var usOut = 'const List kTimeZonesInMicroseconds = const [\n  -1, ';
	var tzDicomStringListOut = 'const List kDicomStringList = const [\n  '',\n  ';
	var tzInetStringListOut = 'const List kInetStringList = const [\n  '',\n  ';
	var tzDicomStringMapOut = 'const List kDicomStrings = const {\n  '',\n  ';
	var tzInetStringMapOut = 'const List kInetStrings = const {\n  '',\n  ';

	final definitions = <String>[];
	final members = <String>[];
	final tzs =  <String>[];
	final usList = <String>[];
	final dicomList = <String>[];
	final inetList = <String>[];
	final dicomStringToUSMap = <String>[];
	final inetStringToUSMap = <String>[];
	final dicomStringToTZMap = <String>[];
	final inetStringToTZMap = <String>[];

	for (var v in baseZimeZones) {
		final int index = v[0] - 1;
		int hour = v[1];
		final int minute = v[2];
		final int token = v[3];
		final sign = (hour.isNegative) ? -1 : 1;
		final signChar = (hour.isNegative) ? '-' : '+';
		hour = hour.abs();
		final us = timeZoneToMicroseconds(sign, hour, minute);
		final dicom = '"$signChar${digits2(hour)}${digits2(minute)}"';
		final inet = '"$signChar${digits2(hour)}${digits2(minute)}"';
		tzs.add('const [$index, $hour, $minute, $us, "$token", "$dicom", "$inet"]');
		usList.add('$us');

		definitions.add('static const TimeZone kTZ$index = const TimeZone._($index, $hour, '
				                '$minute, '
				                '$us, "$token", $dicom);');
		members.add('kTZ$index');
		dicomList.add(dicom);
		inetList.add(inet);
		dicomStringToUSMap.add('"$dicom": $us');
		inetStringToUSMap.add('"$inet": $us');
		dicomStringToTZMap.add('"$dicom": TimeZone.k$index');
		inetStringToTZMap.add('"$inet": TimeZone.k$index');
	}
	tableOut += tzs.join(',\n  ') + '\n];\n';
	usOut += usList.join(', ');
	tzDicomStringListOut += dicomList.join(', ') + '\n];\n';
	tzInetStringListOut += inetList.join(', ') + '\n];\n';
	tzDicomStringMapOut += dicomStringToUSMap.join(',\n  ') + '\n};\n';
	tzInetStringMapOut += inetStringToUSMap.join(',\n  ') + '\n};\n';
	tzDicomStringMapOut += dicomStringToTZMap.join(',\n  ') + '\n};\n';
	tzInetStringMapOut += inetStringToTZMap.join(',\n  ') + '\n};\n';

	print(definitions.join('\n'));
	print(members.join(', '));

/*	print(tableOut);
	print(usOut);
	print(tzDicomStringListOut);
	print(tzInetStringListOut);
	print(tzDicomStringMapOut);
	print(tzInetStringMapOut);
	*/

}

String genTimeZone() {
  final out = '''

import 'package:string/string.dart';
import 'package:system/core.dart';

//Enhancement: should implement Comparable, add, subtract

typedef TimeZone OnTimeZoneError(int sign, int h);
typedef TimeZone OnTimeZoneParseError(String s);
typedef String OnTimeZoneHashStringError(String s);

/// A Time Zone object. See ISO 8601.
class TimeZone implements Comparable<TimeZone> {
  // TODO: before V0.9.0 convert to 'k' format.
  static const int minHour = kMinTimeZoneHours;
  static const int maxHour = kMaxTimeZoneHours;
  static const int minMinutes = kMinTimeZoneMinutes;
  static const int maxMinutes = kMaxTimeZoneMinutes;
  static const TimeZone utc = const TimeZone._(0);
  static const TimeZone usEast = const TimeZone._(kUSEastTimeZone);
  static const TimeZone usCentral = const TimeZone._(kUSCentralTimeZone);
  static const TimeZone usMountain = const TimeZone._(kUSMountainTimeZone);
  static const TimeZone usPacific = const TimeZone._(kUSPacificTimeZone);

  final int index;
  final int hour;
  final int minute;
  /// The minutes from UTC, where negative numbers indicate before UTC and
  /// positive numbers indicate after UTC>
  final int microseconds;
  /// A single uppercase character that is an abbreviation ([token]) for the time zone.
  final String token;
  
  const TimeZone(this.index, this.

  
  ''';
}
class TimeZone {
	final int index;
	final int hour;
	final int minute;
	final int microseconds;
	final String token;

	const TimeZone(this.index, this.hour, this.minute, this.microseconds, this.token);

	static const TimeZone kTZ0 = const TimeZone(0, -999, 999, 0, 'Unknown');

}

String unknown = 'const [0, -999, 999, "Invalid"],';
const List<dynamic> baseZimeZones = const <List<Object>> [
	const [1, -12, 00, 'Y'],
	const [2, -11, 00, 'X'],
	const [3, -10, 00, 'W'],
	const [4, -09, 30, 'V'],
	const [5, -09, 00, 'V'],
	const [6, -08, 00, 'U'],
	const [7, -07, 00, 'T'],
	const [8, -06, 00, 'S'],
	const [9, -05, 00, 'R'],
	const [10, -04, 00, 'Q'],
	const [11, -03, 30, 'P'],
	const [12, -03, 00, 'P'],
	const [13, -02, 00, 'O'],
	const [14, -01, 00, 'N'],
	const [15, 00, 00, 'Z'],
	const [16, 01, 00, 'A'],
	const [17, 02, 00, 'B'],
	const [18, 03, 00, 'C'],
	const [19, 03, 30, 'C'],
	const [20, 04, 00, 'D'],
	const [21, 04, 30, 'D'],
	const [22, 05, 00, 'E'],
	const [23, 05, 30, 'E'],
	const [24, 05, 45, 'E'],
	const [25, 06, 00, 'F'],
	const [26, 06, 30, 'F'],
	const [27, 07, 00, 'G'],
	const [28, 08, 00, 'H'],
	const [29, 08, 30, 'H'],
	const [30, 08, 45, 'H'],
	const [31, 09, 00, 'I'],
	const [32, 09, 30, 'I'],
	const [33, 10, 00, 'K'],
	const [34, 10, 30, 'K'],
	const [35, 11, 00, 'L'],
	const [36, 12, 00, 'M'],
	const [37, 12, 45, 'M'],
	const [38, 13, 00, 'M'],
	const [39, 14, 00, 'M']
];

const List kKnownTimeZones = const <List<Object>>[
	// [ index, hour, minute, microsecond, token ]
	const [0, -999, 999, 'Invalid'],
	const [1, -12, 0, -43200000000, 'Y'],
	const [2, -11, 0, -39600000000, 'X'],
	const [3, -10, 0, -36000000000, 'W'],
	const [4, -9, 30, -34200000000, 'V'],
	const [5, -9, 0, -32400000000, 'V'],
	const [6, -8, 0, -28800000000, 'U'],
	const [7, -7, 0, -25200000000, 'T'],
	const [8, -6, 0, -21600000000, 'S'],
	const [9, -5, 0, -18000000000, 'R'],
	const [10, -4, 0, -14400000000, 'Q'],
	const [11, -3, 30, -12600000000, 'P'],
	const [12, -3, 0, -10800000000, 'P'],
	const [13, -2, 0, -7200000000, 'O'],
	const [14, -1, 0, -3600000000, 'N'],
	const [15, 0, 0, 0, 'Z'],
	const [16, 1, 0, 3600000000, 'A'],
	const [17, 2, 0, 7200000000, 'B'],
	const [18, 3, 0, 10800000000, 'C'],
	const [19, 3, 30, 12600000000, 'C'],
	const [20, 4, 0, 14400000000, 'D'],
	const [21, 4, 30, 16200000000, 'D'],
	const [22, 5, 0, 18000000000, 'E'],
	const [23, 5, 30, 19800000000, 'E'],
	const [24, 5, 45, 20700000000, 'E'],
	const [25, 6, 0, 21600000000, 'F'],
	const [26, 6, 30, 23400000000, 'F'],
	const [27, 7, 0, 25200000000, 'G'],
	const [28, 8, 0, 28800000000, 'H'],
	const [29, 8, 30, 30600000000, 'H'],
	const [30, 8, 45, 31500000000, 'H'],
	const [31, 9, 0, 32400000000, 'I'],
	const [32, 9, 30, 34200000000, 'I'],
	const [33, 10, 0, 36000000000, 'K'],
	const [34, 10, 30, 37800000000, 'K'],
	const [35, 11, 0, 39600000000, 'L'],
	const [36, 12, 0, 43200000000, 'M'],
	const [37, 12, 45, 45900000000, 'M'],
	const [38, 13, 0, 46800000000, 'M'],
	const [39, 14, 0, 50400000000, 'M']
];

const List kTimeZonesInMicroseconds = const <int>[
  -1,  //No reformat
  -43200000000, -39600000000, -36000000000, -34200000000, -32400000000,
  -28800000000, -25200000000, -21600000000, -18000000000, -14400000000,
  -12600000000, -10800000000, -7200000000, -3600000000, 0, 3600000000,
  7200000000, 10800000000, 12600000000, 14400000000, 16200000000,
  18000000000, 19800000000, 20700000000, 21600000000, 23400000000,
  25200000000, 28800000000, 30600000000, 31500000000, 32400000000,
  34200000000, 36000000000, 37800000000, 39600000000, 43200000000,
  45900000000, 46800000000, 50400000000
];



