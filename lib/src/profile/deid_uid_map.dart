//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/values/uid.dart';

/// A [Map] from Identified [Uid]s to De-Identified [Uid]s.
/// The [parentUid] if present is the [Uid] of the containing
/// Information Entity.
class UidMap {
  /// The Information Entity containing these [Uid]s.
  final Uid parentUid;

  /// The
  final Uid parentDeIdUid;
  final _uidMap = <Uid, Uid>{};

  /// Constructor. If [parentDeIdUid] is not provided a new [Uid] is created.
  UidMap(this.parentUid, [Uid parentDeIdUid])
      : parentDeIdUid = parentDeIdUid ?? Uid();

  /// Returns the De-Identified [Uid] associated with [idUid],
  /// an Identified [Uid].
  Uid operator [](Uid idUid) => lookup(idUid);

  /// Returns the De-Identified [Uid] associated with [idUid],
  /// an Identified [Uid]. if [parent] is present it must be
  /// equal to [parentUid] or _null_ is returned.
  Uid lookup(Uid idUid, [Uid parent]) {
    if (parentUid == null || parent == parentUid) {
      final deIdUid = _uidMap[idUid];
      if (deIdUid != null) return deIdUid;
      final newDeIdUid = Uid();
      final result = _uidMap.putIfAbsent(idUid, () => newDeIdUid);
      assert(newDeIdUid == result);
      return newDeIdUid;
    }
    return null;
  }
}
