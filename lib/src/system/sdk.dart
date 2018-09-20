//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:version/version.dart';

// ignore_for_file: public_member_api_docs

const int kSdkBuildNumber = 0;

//TODO: have this class be build automatically by the Grinder.
class _SDK {
  //TODO: read from file
  final Version version;
  //TODO: read from file
  final String news;

  const _SDK._(this.version, this.news);

  String get title => 'Open DICOMweb SDK';
  String get id => 'OdwSdk';

  /// The build number of this instance.
  int get buildNumber => kSdkBuildNumber;

  /// Information about _this_.
  String get info => '$asString\n$news';

  String get asString => toString();

  @override
  String toString() => '$title($version)';
}

/// The singleton SDK object.  It contains information about the
/// ODW SDK with which this System is built.
final _SDK sdk = _SDK._(
    Version(0, 6, 1, preRelease: ['alpha', '1'], build: buildNumber),
    _news);

//TODO: increment this number as part of the build cycle.
/// The build number of _this_.
const String buildNumber = '00000';

/// A [String] containing news about the this release of the ODW SDK.
String get _news => '''
  This is an pre-beta version of the system.
    New features:
      - ...
    Recent changes:
      - ...
    Recent fixes:
      - ...
    ''';
