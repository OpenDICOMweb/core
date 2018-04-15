//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/value/uid/uid.dart';
import 'package:core/src/value/uid/uid_errors.dart';


/// A singleton class used to ensure that all [Uid]s are unique.
abstract class SupportedUid {
  /// [Uid]s that are known to the src.
  dynamic get knownUids;

  /// Returns _true_ if [uid] is in knownUids.
  bool contains(Uid uid);

  /// Checks that the [uid] is not present in [knownUids].
  /// Thrown a [InvalidUidError] if it is present.
  Uid checkNotPresent(Uid uid) =>
      (contains(uid)) ? uid : invalidDuplicateUid(uid);

  /// Returns a [SupportedUidList] or [SupportedUidMap].
  static SupportedUid initialize([String type, int initialLength]) {
    if (type == 'list')
    	return new SupportedUidList(initialLength);
    if (type == 'map')
    	return new SupportedUidMap();
    return null;
  }
}

/// A singleton class used to ensure that all [Uid]s are unique.
class SupportedUidList extends SupportedUid {
  /// A [List] of known [Uid]s.
  @override
  final List<Uid> knownUids;

  SupportedUidList([int initialLength = 500])
      : knownUids = new List(initialLength);

  @override
  bool contains(Uid uid) => knownUids.contains(uid);

  void add(Uid uid, [Object _]) {
    checkNotPresent(uid);
    knownUids.add(uid);
  }
}

/// A singleton class used to ensure that all [Uid]s are unique.
/// The primary use is by Entities.
class SupportedUidMap extends SupportedUid {
  /// A [Map] of [Uid]s to [Object] of all [Uid]s created.
  /// It can also be used to lookup an [Object] by its [Uid].
  @override
  final Map<Uid, Object> knownUids = <Uid, Object>{};

  SupportedUidMap();

  @override
  bool contains(Uid uid) => knownUids.containsKey(uid);

  void add(Uid uid, Object o) {
    checkNotPresent(uid);
    knownUids.putIfAbsent(uid, o);
  }
}
