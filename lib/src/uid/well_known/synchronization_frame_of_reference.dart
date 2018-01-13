// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/uid/uid_type.dart';
import 'package:core/src/uid/well_known/wk_uid.dart';

class SynchronizationFrameOfReference extends WKUid {
  const SynchronizationFrameOfReference(
      String uid, String keyword, UidType type, String name,
      {bool isRetired = false})
      : super(uid, keyword, type, name, isRetired: isRetired);

  @override
  String get info => '$runtimeType($asString)';

  @override
  String toString() => asString;

  static const String kName = 'Synchronization Frame of Reference';

  static SynchronizationFrameOfReference lookup(String s) => map[s];

  static const SynchronizationFrameOfReference kUniversalCoordinatedTime =
      const SynchronizationFrameOfReference(
          '1.2.840.10008.15.1.1',
          'UniversalCoordinatedTime',
          UidType.kSynchronizationFrameOfReference,
          'Universal Coordinated Time');

  static const List<SynchronizationFrameOfReference> members =
      const <SynchronizationFrameOfReference>[kUniversalCoordinatedTime];

  static const Map<String, SynchronizationFrameOfReference> map =
      const <String, SynchronizationFrameOfReference>{
    '1.2.840.10008.15.1.1': kUniversalCoordinatedTime
  };
}
