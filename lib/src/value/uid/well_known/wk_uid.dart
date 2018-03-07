// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//part of odw.sdk.dictionary.uid;

import 'package:core/src/value/uid/uid.dart';
import 'package:core/src/value/uid/uid_errors.dart';
import 'package:core/src/value/uid/well_known/uid_type.dart';
import 'package:core/src/value/uid/well_known/wk_uids_map.dart';

/// Compile time constant definitions for the 'Well Known' UIDs from PS 3.6
class WKUid extends Uid {
  final String keyword;
  final UidType _type;
  final String name;
  final bool isRetired;

  const WKUid(String value, this.keyword, this._type, this.name,
      {this.isRetired = false})
      : super.wellKnown(value);

  UidType get type => _type;

  bool get isNotRetired => !isRetired;

  @override
  String get info => '$runtimeType($asString) $name';

  static const String kName = 'Coding Scheme';

  static WKUid lookup(Object o) {
    Uid uid;
    if (o is WKUid) {
      uid = o;
    } else if (o is Uid) {
      uid = wellKnownUids[o.asString];
    } else if (o is String) {
      final s = o.trim();
      uid = wellKnownUids[s];
    } else {
      return invalidUid(o);
    }
    return uid;
  }

  static List<WKUid> get uids => wellKnownUids.values;

  static List<String> get strings => wellKnownUids.keys;

  //*****   Constant Values   *****

  static const WKUid kDicomApplicationContextName = const WKUid(
    '1.2.840.10008.3.1.1.1',
    'DICOMApplicationContextName',
    UidType.kApplicationContextName,
    'DICOM Application Context Name',
  );

  static const WKUid kUniversalCoordinatedTime = const WKUid(
      '1.2.840.10008.15.1.1',
      'UniversalCoordinatedTime',
      UidType.kSynchronizationFrameOfReference,
      'Universal Coordinated Time');
}
