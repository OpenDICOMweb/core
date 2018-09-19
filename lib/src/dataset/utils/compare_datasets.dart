//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/element.dart';
import 'package:core/src/system.dart';
import 'package:core/src/utils/logger.dart';

// ignore_for_file: public_member_api_docs

class ElementDiff {
  Element e0;
  Element e1;
  String msg;

  ElementDiff(this.e0, this.e1, this.msg);

  String get compare {
    final sb = new StringBuffer();
    if (e0.tag == e1.tag) {
      sb.write('tags ${e0.tag.dcm} Equal\n');
    } else {
      sb.write('** e0.tag${e0.tag.dcm}, e1.tag${e1.tag.dcm}\n');
    }
    if (e0.vrIndex == e1.vrIndex) {
      sb.write('vrs ${e0.vrId} Equal\n');
    } else {
      sb.write('** e0.vr(${e0.vrId}), e1.vr(${e1.vrId})\n');
    }
    if (e0.values == e1.values) {
      sb.write('values ${e0.values} Equal\n');
    } else {
      sb
        ..write('** e0.values(${e0.vrId})\n')
        ..write('** e1.values(${e1.vrId})\n');
    }
    return sb.toString();
  }
}

class DatasetComparitor<K> {
  final Dataset dataset0;
  final Dataset dataset1;
  //TODO: create a better reporting mechanism
  final List<List> bad = <List>[];
  bool hasDifference = false;
  int level = 0;

  DatasetComparitor(this.dataset0, this.dataset1,
      [Level logLevel = Level.config]) {
    log.level = logLevel;
  }

  bool get run {
    log
      ..info0('Comparing Datasets:')
      ..down
      ..info0('0=$dataset0')
      ..info0('1=$dataset1');
    final v = compare(dataset0, dataset1);
    log.up;
    return v;
  }

  String get info {
    final sb = new StringBuffer('Dataset inequalities: \n');
    for (var i = 0; i < bad.length; i++) {
      final list = bad[i];
      final Element a = list[0];
      final Element b = list[1];
      sb.write('  $i A: ${a.info}\n$i B: ${b.info}\n');
    }
    return sb.toString();
  }

  //TODO: fix results
  bool compare(Dataset ds0, Dataset ds1) {
    int length;
    if (ds0.isEmpty && ds1.isEmpty) return false;
    log
      ..debug('ds0 length(${ds0.length}', 1)
      ..debug('ds1 length(${ds1.length}');
    length = ds0.length;
    if (ds0.length != ds1.length) {
      length = ds0.length;
      // log.debug('*** Uneven DS length: ds0($ds0), ds1($ds1)');
      if (ds0.length > ds1.length) length = ds1.length;
      hasDifference = true;
    }

    // log.debug('length($length)');
    final ds0List = ds0.elements.toList(growable: false);
    final ds1List = ds1.elements.toList(growable: false);
    for (var i = 0; i < length; i++) {
      final e0 = ds0List[i];
      final e1 = ds1List[i];
      log
        ..down
        ..debug('e0: ${e0.info}')
        ..debug('e1: ${e1.info}');
      if (e0.runtimeType != e1.runtimeType) {
        // log.debug('Uneven Type: e0($e0), e0($e0)');
        //throw 'Non matching elements';
      }
      if (e0 is SQ && e1 is SQ) {
        compareSequences(e0, e1);
/*      } else if (e0 is BulkdataRef && e1 is BulkdataRef) {
        final m0 = e0.;
        final m1 = e1.e;
        if (m0 is SQ && m1 is SQ) {
          compareSequences(m0, m1);
        } else {
          compareElements(i, e0.e, e1.e);
        }*/
      } else {
        compareElements(i, e0, e1);
      }
      log.up;
    }
    log.up;
    return hasDifference;
  }

  void compareElements(int i, Element e0, Element e1) {
    assert(e0 != null && e1 != null);
    log.down;
    if (e0 == null || e1 == null) {
      log.warn('$i ($level) Null Element: e0($e0), e1($e1)');
      return;
    } else if (e0.tag != e1.tag) {
      // log.debug('!= Tag E0: ${e0.tag.dcm}, E1: ${e1.tag.dcm}');
      hasDifference = true;
    } else if (e0.vrIndex != e1.vrIndex) {
      // log.debug('!= VR E0: ${e0.vrId}, E1: ${e1.vrId}');
      hasDifference = true;
    } else if (e0.length != e1.length) {
      // log.debug('!= Length E0: ${e0.length}, E1: ${e1.length}');
      hasDifference = true;
    }
    final len = (e0.length < e1.length) ? e0.length : e1.length;
    final v0 = e0.values.toList(growable: false);
    final v1 = e1.values.toList(growable: false);
    for (var i = 0; i < len; i++) {
      final Object a = v0[i];
      final Object b = v1[i];
      if (a != b) {
        log.debug('!= values[$i] E0: $a, E1: $b');
        hasDifference = true;
      }
    }
    if (hasDifference) addNonMatchingElements(e0, e1);
    log.up;
  }

  void compareSequences(SQ sq0, SQ sq1) {
    level++;
    log.down;
    var hasDifferenceSQ = false;
    if (sq0.tag != sq1.tag) {
      // log.debug('!= Sequence Tag E0: ${sq0.tag.dcm}, E1: ${sq1.tag.dcm}');
      hasDifference = true;
    }
    if (sq0.vrIndex != sq1.vrIndex) {
      // log.debug('!= Sequence VR E0: ${sq0.vrId}, E1: ${sq1.vrId}');
      hasDifference = true;
    }
    if (sq0.isEmpty && sq1.isEmpty) return;
    if (sq0.length != sq1.length) {
      // log.debug('!= Sequence Items E0: ${sq0.length}, E1: ${sq1.length}');
      hasDifference = true;
    }

    final len =
        (sq0.values.length < sq1.length) ? sq0.values.length : sq1.length;
    final v0 = sq0.values;
    final v1 = sq1.values;
    if (v0.isEmpty && v1.isEmpty) return;
//    log.info0('sq0.values($v0), sq1.values($v1');
    for (var i = 0; i < len; i++)
      hasDifferenceSQ = compareItems(v0.elementAt(i), v1.elementAt(i));
    if (hasDifferenceSQ) addNonMatchingElements(sq0, sq1);
    log.up;
    level--;
  }

  bool compareItems(Item item0, Item item1) {
    log..info0('${item0.info}')..info0('${item0.info}');
    if (item0.elements.isEmpty && item1.elements.isEmpty) return false;
    level++;
    log.down;
    final hasDifference = compare(item0, item1);
    if (hasDifference == true) bad.add(<Dataset>[item0, item1]);
    log.up;
    level--;
    return hasDifference;
  }

  void addNonMatchingElements(Element e0, Element e1) =>
      bad.add(<Element>[e0, e1]);

  @override
  String toString() => '$runtimeType: $dataset0, $dataset1';
}
