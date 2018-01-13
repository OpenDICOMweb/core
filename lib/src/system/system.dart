// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

// **** Note: this file cannot have any dependencies on dart:io or dart:html.

//TODO: add a createFMI method to convert writer that uses the system object
//      to generate the new FMI.

// System imports
//  1. uses uid for transfer syntax TODO: anything else?
//  2. uses uuid for random uid generation TODO: finish organization
//  3. Uses version for system version info
//  4. Uses logging to be the root of Logger

import 'dart:math';

import 'package:core/src/date_time/primitives/constants.dart';
import 'package:core/src/date_time/primitives/time_zone.dart';
import 'package:core/src/dicom.dart' as dicom;
import 'package:core/src/errors.dart';
import 'package:core/src/hash/hash.dart';
import 'package:core/src/hash/hash64.dart';
import 'package:core/src/logger/log_level.dart';
import 'package:core/src/logger/logger.dart';
import 'package:core/src/sdk.dart';
import 'package:core/src/string/hexadecimal.dart' as hexadecimal;
import 'package:core/src/system/sys_info.dart';
import 'package:core/src/uid/supported_transfer_syntax.dart';
import 'package:core/src/uid/uid.dart';
import 'package:core/src/uid/well_known/transfer_syntax.dart';
import 'package:version/version.dart';




//TODO: add a createFMI method to convert writer that uses the system object
//      to generate the new FMI.

//TODO: add a way to log to a file called <project>/output/<script>.out

const String kSystemBuildNumber = '00000';

/// The minimum Epoch Year using a 63-bit integer as microseconds.
const int kMinYearLimit = -144169;

/// The maximum Epoch Year using a 63-bit integer as microseconds.
const int kMaxYearLimit = 148108;

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

  System(
      {this.name = 'Unknown',
      Version version,
      this.buildNumber = -1,
      this.mediaStorageSopClassUid,
      this.mediaStorageSopInstanceUid,
      this.implementationClassUid,
      this.implementationVersionName,
      this.privateInformationCreatorUid,
      this.minYear = kDefaultMinYear,
      this.maxYear = kDefaultMaxYear,
      this.hasher,
      Level level = Level.config,
      this.throwOnError = false,
      this.isUuidUppercase = false,
      this.isHexUppercase = false,
      this.showBanner = true,
      this.showSdkBanner = false})
      : version = (version == null) ? new Version(0, 0, 1) : version,
        log = new Logger(name, level) {
    if (minYear < kMinYearLimit) throw new InvalidYearError(minYear);
    log.config('minYear: $minYear, minYearLimit: $kMinYearLimit');
    if (maxYear > kMaxYearLimit) throw new InvalidYearError(maxYear);
    log.config('maxYear:  $maxYear, maxYearLimit:  $kMaxYearLimit');
    hasher ??= const Hash64();
  }

  // **** Interface

  /// The script or program being run.
  String get script;

  // Exit must be handled differently on Client and Server.
  void exit(int code, [String msg]);

  // **** End Interface

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

  //Urgent: finish
  String get info => '''
  Urgent: finish
  ''';

  // **** File Meta Information - each client or server should implement.

  //TODO: before V0.9.0 document these following
  Map<String, SupportedTransferSyntax> get supportedTS => SupportedTransferSyntax.map;

  bool isSupportedTransferSyntax(String ts) => SupportedTransferSyntax.isSupported(ts);

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
  static final int timeZoneOffsetInMicroseconds = startTime.timeZoneOffset.inMicroseconds;
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

  static String dcm(int code) => dicom.dcm(code);
  static String hex8(int v) => hexadecimal.hex8(v);
  static String hex16(int v) => hexadecimal.hex16(v);
  static String hex32(int v) => hexadecimal.hex32(v);
}

/// The system singleton;
final System system = System.system;

//Urgent Jim: out how to handle Hash64
/// The system hash function
int hash(Object o) => system.hash(o);

/// The top-level [Logger] for the src.
Logger get log => system.log;

/// Should functions throw or return null.
bool get throwOnError => system.throwOnError;

/// Should [Uuid] [String]s use upper or lowercase hexadecimal.
bool get uuidsUseUppercase => system.isUuidUppercase;

bool get hexUseUppercase => system.isHexUppercase;
