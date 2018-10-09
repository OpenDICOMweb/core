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
import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

final Map<Uid, Uid> idedToDeIded = <Uid, Uid>{};

List<Element> replaceUids(TagRootDataset rds) {
  final old = <Element>[];

  for (var code in deIdUidCodes) {
    final UI e0 = rds.lookup(code);
    if (e0 != null) {
      final e1 = replaceUIFast(e0);
      rds.replace(e0.index, e1);
      old.add(e0);
    }
  }
  return old;
}

UI replaceUIFast(UI e) {
  final oldUids = e.uids;
  final length = oldUids.length;
  final uids =  List<String>(length);
  for (var i = 0; i < length; i++) {
    final oldUid = oldUids.elementAt(i);
    var newUid = idedToDeIded[oldUid];
    if (newUid != null) {
      uids[i] = newUid.asString;
    } else {
      newUid =  Uid();
      idedToDeIded[oldUid] = newUid;
      uids[i] = newUid.asString;
    }
  }
  return e.update(uids);
}

UI replaceUIGeneral(UI e) {
  final oldUids = e.uids;
  final length = oldUids.length;
  final uids =  List<String>(length);
  for (var i = 0; i < length; i++) {
    final old = oldUids.elementAt(i);
    var newUid = idedToDeIded[old];
    if (newUid != null) {
      uids[i] = newUid.asString;
    } else if (old.isWellKnown) {
      uids[i] = old.asString;
    } else if (Uid.isDicom(old)) {
      uids[i] = old.asString;
    } else {
      newUid =  Uid();
      idedToDeIded[old] = newUid;
      uids[i] = newUid.asString;
    }
  }
//  printUidValues(e, uids);
  return e.update(uids);
}

void printUidValues(UI e, List<String> nList) => print('''   
        e: $e
  oldUids: ${e.values}
  Uids: $nList
''');
