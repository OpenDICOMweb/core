//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:math';

import 'package:core/src/element/primitives/code.dart' as primitive;
import 'package:core/src/system/sdk.dart';
import 'package:core/src/system/sys_info.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/value/date_time.dart';
import 'package:core/src/value/uid.dart';
import 'package:version/version.dart';

// **** Note: this file cannot have any dependencies on dart:io or dart:html.

//TODO: add a createFMI method to convert writer that uses the system object
//      to generate the new FMI.

// System imports
//  1. uses uid for transfer syntax TODO: anything else?
//  2. uses uuid for random uid generation TODO: finish organization
//  3. Uses version for system version info
//  4. Uses logging to be the root of Logger

//TODO: add a createFMI method to convert writer that uses the system object
//      to generate the new FMI.

//TODO: add a way to log to a file called <project>/output/<script>.out

const String kSystemBuildNumber = '00000';

/// The minimum Epoch Year using a 63-bit integer as microseconds.
const int kMinYearLimit = -144169;

/// The maximum Epoch Year using a 63-bit integer as microseconds.
const int kMaxYearLimit = 148108;

const String kDefaultTimeSeparator = ' ';

/// An abstract class that is the foundation of both Servers and Clients.
abstract class System {
  /// The name of this [System].
  final String name;
  final Version version;
  final int buildNumber;

  /// FMI Values
  final String mediaStorageSopClassUid;
  final String mediaStorageSopInstanceUid;
  final String implementationClassUid;
  final String implementationVersionName;
  final String privateInformationCreatorUid;
  final String sdkSourceAETitle;
  final String sdkDestinationAETitle;

  final int minYear;
  final int maxYear;

  /// The Root [Logger] for the [System].
  final Logger log;

  /// The default hasher is for this [System];
  /// _Note_: This field is mutable.
  Hash hasher;

  /// This setting determines whether [Error]s are thrown or just return _null_.
  /// _Note_: This field is mutable.
  bool throwOnError;

  /// If _true_ the [banner] is displayed.
  /// _Note_: This field is mutable.
  bool showBanner;

  /// If _true_ the [banner] is displayed.
  /// _Note_: This field is mutable.
  bool showSdkBanner;

  /// This setting determines whether UUIDs print in upper or lowercase.
  /// _Note_: This field is mutable.
  //TODO: how to make this work with Uuid package?
  bool isUuidUppercase;

  bool isHexUppercase;

  bool allowInvalidCharacterEncodings = true;
  bool allowInvalidAscii = true;
  bool allowMalformedUtf8 = true;

  bool useAscii = false;

  String dateTimeSeparator = kDefaultTimeSeparator;

  System(
      {this.name = 'Unknown',
      this.minYear = kDefaultMinYear,
      this.maxYear = kDefaultMaxYear,
      this.hasher,
      Version version,
      this.buildNumber = -1,
      this.mediaStorageSopClassUid,
      this.mediaStorageSopInstanceUid,
      this.implementationClassUid,
      this.implementationVersionName,
      this.privateInformationCreatorUid,
      this.sdkSourceAETitle,
      this.sdkDestinationAETitle,
      Level level = Level.config,
      this.throwOnError = false,
      this.isUuidUppercase = false,
      this.isHexUppercase = false,
      this.showBanner = true,
      this.showSdkBanner = true})
      : version = (version == null) ? new Version(0, 0, 1) : version,
        log = new Logger(name, level) {
    if (minYear < kMinYearLimit) throw new InvalidYearError(minYear);
    if (maxYear > kMaxYearLimit) throw new InvalidYearError(maxYear);
    log
      ..config('minYear: $minYear, minYearLimit: $kMinYearLimit')
      ..config('maxYear:  $maxYear, maxYearLimit:  $kMaxYearLimit')
      ..config('log level:  ${log.level}');
    hasher ??= const Hash64();
  }

  // **** Interface

  /// The script or program being run.
  String get script;

  // Exit must be handled differently on Client and Server.
  void exit(int code, [String msg]);

  // **** End Interface

  int get minYearInMicroseconds => minYear * kMicrosecondsPerYear;
  int get maxYearInMicroseconds => maxYear * kMicrosecondsPerYear;

  bool showWarnings = false;

  void warn(String msg) {
    if (showWarnings) log.warn(msg);
  }

  /// The initial [Logger] [Level].
  Level get level => log.level;
  set level(Level l) => log.level = l;

  /// The default [hash] function for the system.
  int hash(Object o) => hasher(o);

  /// The default Transfer Syntax for all ODW/SDK based systems.
  ///
  /// _Note_: This Getter can be overridden in Server, Client, or Browser.
  Uid get defaultTransferSyntax => TransferSyntax.kExplicitVRLittleEndian;

  String get banner => (showSdkBanner)
      ? '$name($runtimeType V$version): $script\n  Running on ${sdk.info}'
      : '$name($runtimeType V$version): $script';

  /// Returns a [String] containing information about this [System].
  SysInfo get sysInfo => new SysInfo();

  String get versionName => '$name\_$version';

  int truncatedListLength = 5;
  String truncate(List v) {
    if (v.length > truncatedListLength) {
      final x = v.sublist(0, truncatedListLength).join(', ');
      return '[$x, ...]';
    }
    return v.toString();
  }

  //TODO: finish
  String get info => '''
  TODO: finish
  ''';

  // **** File Meta Information - each client or server should implement.

  //TODO: before V0.9.0 document these following
  Map<String, SupportedTransferSyntax> get supportedTS =>
      SupportedTransferSyntax.map;

  bool isSupportedTransferSyntax(String ts) =>
      SupportedTransferSyntax.isSupported(ts);

  bool isStorableTransferSyntax(TransferSyntax ts) =>
      SupportedTransferSyntax.map[ts]?.isStorable;

  bool isDecodableTransferSyntax(TransferSyntax ts) =>
      SupportedTransferSyntax.map[ts]?.isDecodable;

  bool isEncodableTransferSyntax(TransferSyntax ts) =>
      SupportedTransferSyntax.map[ts]?.isEncodable;

  bool isDisplayableTransferSyntax(TransferSyntax ts) =>
      SupportedTransferSyntax.map[ts]?.isDecodable;

  @override
  String toString() => '$banner';

  // Date/Time stuff
  static final DateTime startTime = new DateTime.now();
  static final Duration timeZoneOffset = startTime.timeZoneOffset;
  static final int timeZoneOffsetInMicroseconds =
      startTime.timeZoneOffset.inMicroseconds;
  static final int timeZoneIndex =
      kValidTZMicroseconds.indexOf(timeZoneOffsetInMicroseconds);
  static final String timeZoneName = startTime.timeZoneName;

  /// The random number generator for the system.
  static final Random rng = new Random.secure();

  /// Returns the [System] singleton, which is and instance
  /// of Browser, Client, or Server. It has a lazy one-time
  /// Setter.
  // ignore: unnecessary_getters_setters
  static System get system => _system;
  static System _system;
  // ignore: unnecessary_getters_setters
  static set system(System system) => _system ??= system;

  static String dcm(int code) => primitive.dcm(code);
  static String hex8(int v) => hex8(v);
  static String hex16(int v) => hex16(v);
  static String hex32(int v) => hex32(v);
}

/// The system singleton;
final System system = System.system;

/// The top-level [Logger] for the src.
Logger get log => system.log;

/// Should functions throw or return null.
bool get throwOnError => system.throwOnError;

/// Should [Uuid] [String]s use upper or lowercase hexadecimal.
bool get uuidsUseUppercase => system.isUuidUppercase;

bool get hexUseUppercase => system.isHexUppercase;
