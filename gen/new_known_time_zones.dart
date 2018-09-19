//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart';

// ignore_for_file: type_annotate_public_apis

// TODO: Move to generator package
void main() {
	Server.initialize();

	var tableOut = 'const List kKnownTimeZones = const [\n  ${TimeZone.unknown}\n';
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

	for (TimeZone tz in baseTimeZones) {
				final int index = tz[0] - 1;
		int hour = tz[1];
		final int minute = tz[2];
		final int token = tz[3];
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
	tableOut += '${tzs.join(',\n  ')}\n];\n';
	usOut += usList.join(', ');
	tzDicomStringListOut += '${dicomList.join(', ')}\n];\n';
	tzInetStringListOut += '${inetList.join(', ')}\n];\n';
	tzDicomStringMapOut += '${dicomStringToUSMap.join(',\n  ')}\n};\n';
	tzInetStringMapOut += '${inetStringToUSMap.join(',\n  ')}\n};\n';
	tzDicomStringMapOut += '${dicomStringToTZMap.join(',\n  ')}\n};\n';
	tzInetStringMapOut += '${inetStringToTZMap.join(',\n  ')}\n};\n';

	print(definitions.join('\n'));
	print(members.join(', '));

	print(tableOut);
	print(usOut);
	print(tzDicomStringListOut);
	print(tzInetStringListOut);
	print(tzDicomStringMapOut);
	print(tzInetStringMapOut);

}

String genTimeZone() => '''

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

class TimeZone {
  final int index;
  final int hour;
  final int minute;

//	final int microseconds;
  final String token;

  const TimeZone(this.index, this.hour, this.minute, this.token);

  int get microseconds =>
      (hour * kMicrosecondsPerHour) +
          (minute * kMicrosecondsPerHour);

  static const Y = TimeZone(1, -12, 00, 'Y');



  static const unknown = TimeZone(0, -999, 999, 'Invalid');
  static const Y = TimeZone(1, -12, 00, 'Y');
  static const A = TimeZone(2, -11, 00, 'X');
  static const A = TimeZone(3, -10, 00, 'W');
  static const A = TimeZone(4, -09, 30, 'V');
  static const A = TimeZone(5, -09, 00, 'V');
  static const A = TimeZone(6, -08, 00, 'U');
  static const A = TimeZone(7, -07, 00, 'T');
  static const A = TimeZone(8, -06, 00, 'S');
  static const A = TimeZone(9, -05, 00, 'R');
  static const A = TimeZone(10, -04, 00, 'Q');
  static const A = TimeZone(11, -03, 30, 'P');
  static const A = TimeZone(12, -03, 00, 'P');
  static const P = TimeZone(13, -02, 00, 'O');
  static const N = TimeZone(14, -01, 00, 'N');
  static const Z = TimeZone(15, 00, 00, 'Z');
  static const A = TimeZone(16, 01, 00, 'A');
  static const A = TimeZone(17, 02, 00, 'B');
  static const A = TimeZone(18, 03, 00, 'C');
  static const A = TimeZone(19, 03, 30, 'C');
  static const A = TimeZone(20, 04, 00, 'D');
  static const A = TimeZone(21, 04, 30, 'D');
  static const A = TimeZone(22, 05, 00, 'E');
  static const A = TimeZone(23, 05, 30, 'E');
  static const A = TimeZone(24, 05, 45, 'E');
  static const A = TimeZone(25, 06, 00, 'F');
  static const A = TimeZone(26, 06, 30, 'F');
  static const A = TimeZone(27, 07, 00, 'G');
  static const A = TimeZone(28, 08, 00, 'H');
  static const A = TimeZone(29, 08, 30, 'H');
  static const A = TimeZone(30, 08, 45, 'H');
  static const A = TimeZone(31, 09, 00, 'I');
  static const A = TimeZone(32, 09, 30, 'I');
  static const A = TimeZone(33, 10, 00, 'K');
  static const A = TimeZone(34, 10, 30, 'K');
  static const A = TimeZone(35, 11, 00, 'L');
  static const M = TimeZone(36, 12, 00, 'M');
  static const A = TimeZone(37, 12, 45, 'M');
  static const A = TimeZone(38, 13, 00, 'M');
  static const A = TimeZone(39, 14, 00, 'M');

  static const TimeZone kTZ0 = const TimeZone(0, -999, 999, 'Unknown');
}

/*
const List kKnownTimeZones = const <List<Object>>[
	// [ index, hour, minute, microsecond, token ]
	static const [0, -999, 999, 'Invalid'],
	static const [1, -12, 0, -43200000000, 'Y'],
	static const [2, -11, 0, -39600000000, 'X'],
	static const [3, -10, 0, -36000000000, 'W'],
	static const [4, -9, 30, -34200000000, 'V'],
	static const [5, -9, 0, -32400000000, 'V'],
	static const [6, -8, 0, -28800000000, 'U'],
	static const [7, -7, 0, -25200000000, 'T'],
	static const [8, -6, 0, -21600000000, 'S'],
	static const [9, -5, 0, -18000000000, 'R'],
	static const [10, -4, 0, -14400000000, 'Q'],
	static const [11, -3, 30, -12600000000, 'P'],
	static const [12, -3, 0, -10800000000, 'P'],
	static const [13, -2, 0, -7200000000, 'O'],
	static const [14, -1, 0, -3600000000, 'N'],
	static const [15, 0, 0, 0, 'Z'],
	static const [16, 1, 0, 3600000000, 'A'],
	static const [17, 2, 0, 7200000000, 'B'],
	static const [18, 3, 0, 10800000000, 'C'],
	static const [19, 3, 30, 12600000000, 'C'],
	static const [20, 4, 0, 14400000000, 'D'],
	static const [21, 4, 30, 16200000000, 'D'],
	static const [22, 5, 0, 18000000000, 'E'],
	static const [23, 5, 30, 19800000000, 'E'],
	static const [24, 5, 45, 20700000000, 'E'],
	static const [25, 6, 0, 21600000000, 'F'],
	static const [26, 6, 30, 23400000000, 'F'],
	static const [27, 7, 0, 25200000000, 'G'],
	static const [28, 8, 0, 28800000000, 'H'],
	static const [29, 8, 30, 30600000000, 'H'],
	static const [30, 8, 45, 31500000000, 'H'],
	static const [31, 9, 0, 32400000000, 'I'],
	static const [32, 9, 30, 34200000000, 'I'],
	static const [33, 10, 0, 36000000000, 'K'],
	static const [34, 10, 30, 37800000000, 'K'],
	static const [35, 11, 0, 39600000000, 'L'],
	static const [36, 12, 0, 43200000000, 'M'],
	static const [37, 12, 45, 45900000000, 'M'],
	static const [38, 13, 0, 46800000000, 'M'],
	static const [39, 14, 0, 50400000000, 'M']
];
*/

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



