//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element.dart';


class Compare {
  final List same = <List>[];
  final List diff = <List>[];

  Compare(Dataset ds0, Dataset ds1) {
    final elements0 = ds0.elements.toList(growable: false);
    final elements1 = ds1.elements.toList(growable: false);
    final length0 = elements0.length;
    final length1 = elements1.length;
    var index0 = 0;
    var index1 = 1;
    while ((index0 < length0) && (index1 < length1)) {
      final e0 = elements0[index0];
      final e1 = elements0[index1];
      final tag0 = e0.tag;
      final tag1 = e1.tag;
      if (tag0 == tag1) {
        compareElements(e0, e1);
        index0++;
        index1++;
        continue;
      } else if (tag0.code < tag1.code) {
        diff.add(<dynamic>[-1, e0, null]);
        index0++;
        continue;
      } else {
        diff.add(<dynamic>[1, null, e0]);
        index1++;
        continue;
      }
    }
  }

  void compareDatasets(Dataset ds0, Dataset ds1) {
    final elements0 = ds0.elements.toList(growable: false);
    final length0 = elements0.length;
    final elements1 = ds1.elements.toList(growable: false);
    final length1 = elements1.length;
    var index0 = 0;
    var index1 = 1;
    while ((index0 < length0) && (index1 < length1)) {
      final e0 = elements0[index0];
      final e1 = elements0[index1];
      final tag0 = e0.tag;
      final tag1 = e1.tag;
      if (tag0 == tag1) {
        compareElements(e0, e1);
        index0++;
        index1++;
        continue;
      } else if (tag0.code < tag1.code) {
        diff.add(<dynamic>[-1, e0, null]);
        index0++;
        continue;
      } else {
        diff.add(<dynamic>[1, null, e0]);
        index1++;
        continue;
      }
    }
  }

  void compareElements(Element eo, Element e1) {
    // log.debug('Elements:\n\te0: $eo\n\te1: $e1');
    if (eo.tag != e1.tag)
      throw new ArgumentError('Incomparable Tags: $eo, $e1');
    if (eo.vrIndex != e1.vrIndex)
      throw new ArgumentError('VRs are not equivalent: $eo, $e1');
    return (eo is SQ) ? compareSequences(eo, e1) : compareValues(eo, e1);
  }

  void compareSequences(SQ sq0, SQ sq1) {
    // log.debug('sq0: $sq0\nsq1: $sq1');

    if (sq0.items.length == sq1.items.length) {
      if (sq0.items.isEmpty) return;
      for (var i = 0; i < sq0.items.length; i++) {
        compareItems(sq0.items.elementAt(i), sq1.items.elementAt(i));
      }
    } else if (sq0.items.length < sq1.items.length) {}
  }

  void compareItems(Dataset item0, Dataset item1) {
    // log.debug('item0: $item0\nitem1: $item1');
    final elements0 = item0.elements.toList(growable: false);
    final elements1 = item1.elements.toList(growable: false);
    // log.debug('elements0: $elements0\nelements0: $elements0');

    if (elements0.length == elements1.length) {
      // log.debug('map.length:\n\t${elements0.length}\n\t${elements1.length}');
      if (elements0.isEmpty) {
        // log.debug('zero length items: $item0, $item1');
      }
      for (var i = 0; i < elements0.length; i++) {
        compareElements(elements0[i], elements1[i]);
      }
    } else {
      // TODO: fix or remove brance
    }
  }

  void compareValues(Element e0, Element e1) {
    // log.debug('e0: $e0\ne1: $e1');
    final v0 = e0.values.toList(growable: false);
    final v1 = e1.values.toList(growable: false);
    if (v0.length == v1.length) {
      for (var i = 0; i < v0.length; i++) {
        if (v0[i] != v1[i]) {
          diff.add([0, e0, e1]);
          return;
        }
      }
      same.add(e0);
    } else if (v0.length < v1.length) {
      // log.debug('v0: $v0\nv1: $v1');
      diff.add([-1, e0, e1]);
    } else {
      diff.add([1, e0, e1]);
      // log.debug('v0: $v0\nv1: $v1');
    }
  }
}
