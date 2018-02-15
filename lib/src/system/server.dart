// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

// **** Note: this file cannot have any dependencies on dart:html

import 'dart:io';

import 'package:core/src/date_time/primitives/constants.dart';
import 'package:core/src/hash/hash.dart';
import 'package:core/src/logger/log_level.dart';
import 'package:version/version.dart';

import 'system.dart';

//TODO: add a way to log to a file called <project>/output/<script>.out

/// A singleton class used to handle system-wide values and methods.
///
/// This is an example implementation of [Server].
/// Initialize the [Server] as follows:
///     Server.initialize();
/// Then access it as follows:
///     print(system.info);
class Server extends System {
  Server(
      {String name,
      int minYear = kDefaultMinYear,
      int maxYear = kDefaultMaxYear,
      Hash hasher,
      Version version,
      int buildNumber = -1,
      String mediaStorageSopClassUid = 'TODO',
      String mediaStorageSopInstanceUid = 'TODO',
      String implementationClassUid = '1.2.840.11111111',
      String implementationVersionName = 'Unknown',
      String privateInformationCreatorUid = 'TODO',
      String sdkSourceAETitle = 'Unknown source AETitle',
      String sdkDestinationAETitle = 'Unknown source AETitle',
      Level level = Level.config,
      bool throwOnError = false,
      bool uuidsUseUppercase = false,
      bool showBanner = true,
      bool showSdkBanner = false})
      : super(
            name: name,
      minYear: minYear,
      maxYear: maxYear,
      hasher: hasher,
            version: (version == null) ? new Version(0, 6, 1) : version,
            buildNumber: buildNumber,

            mediaStorageSopClassUid: mediaStorageSopClassUid,
            mediaStorageSopInstanceUid: mediaStorageSopInstanceUid,
            implementationClassUid: implementationClassUid,
            implementationVersionName: implementationVersionName,
            privateInformationCreatorUid: privateInformationCreatorUid,
            sdkSourceAETitle: sdkSourceAETitle,
            sdkDestinationAETitle: sdkDestinationAETitle,
            level: level,
            throwOnError: throwOnError,
            isUuidUppercase: uuidsUseUppercase,
            showBanner: showBanner,
            showSdkBanner: showSdkBanner) {
    System.system = this;
  }

  /// Synonym for name.
  @override
  String get script {
    final script = Platform.script;
    final s =
        (script.scheme == 'data') ? '"Unknown script"\n\n' : script.toString();
    return s;
  }

  /// Exit handler for [Server]s.
  @override
  void exit(int code, [String msg]) {
    stdout.writeln('Exiting ${System.system.name} with status $code');
    exit(code);
  }

  // Create the singleton [Server].
  static bool initialize(
      {String name = 'Unknown',
      Version version,
      int buildNumber = -1,
      String mediaStorageSopClassUid = 'TODO',
      String mediaStorageSopInstanceUid = 'TODO',
      String implementationClassUid = '1.2.840.11111111',
      String implementationVersionName = 'Unknown',
      String privateInformationCreatorUid = 'TODO',
      int minYear = kDefaultMinYear,
      int maxYear = kDefaultMaxYear,
      Hash hasher,
      Level level = Level.config,
      bool throwOnError = false,
      bool uuidsUseUppercase = false,
      bool showBanner = true,
      bool showSdkBanner = false}) {
    System.system = new Server(
        name: name,
        version: (version == null) ? new Version(0, 6, 1) : version,
        buildNumber: buildNumber,
        mediaStorageSopClassUid: mediaStorageSopClassUid,
        mediaStorageSopInstanceUid: mediaStorageSopInstanceUid,
        implementationClassUid: implementationClassUid,
        implementationVersionName: implementationVersionName,
        privateInformationCreatorUid: privateInformationCreatorUid,
        minYear: minYear,
        maxYear: maxYear,
        hasher: hasher,
        level: level,
        throwOnError: throwOnError,
        uuidsUseUppercase: uuidsUseUppercase,
        showBanner: showBanner,
        showSdkBanner: showSdkBanner);
    _initialized = true;
    if (showBanner) stdout.writeln(System.system.banner);
    return true;
  }
}

bool _initialized = _initialized ??= Server.initialize();
