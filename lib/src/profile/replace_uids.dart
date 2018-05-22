//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/profile/de_id/deid_uids.dart';
import 'package:core/src/value/uid.dart';

final Map<Uid, Uid> idedToDeIded = <Uid, Uid>{};

List<Element> replaceUids(TagRootDataset rds) {
  final old = <Element>[];

  for (var code in deIdUidCodes) {
    final UI e = rds.lookup(code);
    if (e != null) {
      final eNew = replaceUIFast(e);
      rds.replace(e.index, eNew);
      old.add(e);
    }
  }
  return old;
}

UI replaceUIFast(UI e) {
  final oldUids = e.uids;
  final length = oldUids.length;
  final newUids = new List<String>(length);
  for (var i = 0; i < length; i++) {
    final uid = oldUids.elementAt(i);
    var newUid = idedToDeIded[uid];
    if (newUid != null) {
      newUids[i] = newUid.asString;
    } else {
      newUid = new Uid();
      idedToDeIded[uid] = newUid;
      newUids[i] = newUid.asString;
    }
  }
  printUidValues(e, newUids);
  return e.update(newUids);
}

UI replaceUIGeneral(UI e) {
  final oldUids = e.uids;
  final length = oldUids.length;
  final newUids = new List<String>(length);
  for (var i = 0; i < length; i++) {
    final uid = oldUids.elementAt(i);
    var newUid = idedToDeIded[uid];
    if (newUid != null) {
      newUids[i] = newUid.asString;
    } else if (uid.isWellKnown) {
      newUids[i] = uid.asString;
    } else if (Uid.isDicom(uid)) {
      newUids[i] = uid.asString;
    } else {
      newUid = new Uid();
      idedToDeIded[uid] = newUid;
      newUids[i] = newUid.asString;
    }
  }
  printUidValues(e, newUids);
  return e.update(newUids);
}

void printUidValues(UI e, List<String> nList) => print('''   
        e: $e
  oldUids: ${e.values}
  newUids: $nList
''');
