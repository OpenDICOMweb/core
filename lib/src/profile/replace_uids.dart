// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/profile/de_id/deid_uids.dart';
import 'package:core/src/value/uid.dart';

final Map<Uid, Uid> idedToDeIded = <Uid, Uid>{};

List<Element> replaceUids(TagRootDataset rds) {
  final old = <Element>[];

//  print('**** Normalizing FMI UIDs');

/*
  // Issue: Does this ever get replaced
  final UI e = rds.fmi[kMediaStorageSOPInstanceUID];
  final eNew = replaceUIFast(e);
  rds.fmi.store(e.code, eNew);
  old.add(e);
*/

//  print('**** Normalizing Dataset UIDs');

  for (var code in deIdUidCodes) {
    final UI e = rds.lookup(code);
    if (e != null) {
      final eNew = replaceUIFast(e);
      rds.replace(e.index, eNew);
      old.add(e);
    }
  }
//  final z = new Formatter();
//  print(z.fmt('old: ${old.length}', old));
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
//      print('Dicom UID: $uid');
      newUids[i] = newUid.asString;
    } else if (uid.isWellKnown) {
//      print('Well Known UID: $uid');
      newUids[i] = uid.asString;
    } else if (Uid.isDicom(uid)) {
//      print('Dicom UID: $uid');
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
