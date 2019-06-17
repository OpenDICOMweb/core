//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:bytes/bytes.dart';
import 'package:core/src/dataset/base.dart';
import 'package:core/src/element.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';

// ignore_for_file: public_member_api_docs

/// An [TagDataset] is a Dataset containing TagElements.
mixin TagDataset {
  Map<int, Element> get eMap;

  List<Element> get elements => eMap.values.toList(growable: false);

  PrivateGroups get pGroups;

  /// Returns _false_ because [TagDataset]s are mutable.
  bool isImmutable = false;

  int keyToIndex(int code) => code;

  Tag getTag(int key, [int vrIndex, Object creator]) => Tag.lookupByCode(key);

  /// If _true_ Elements with invalid values are stored in the
  /// [Dataset]; otherwise, an InvalidValuesError is thrown.
  bool allowInvalidValues = true;

  /// If _true_ duplicate Elements are stored in the duplicate Map
  /// of the [Dataset]; otherwise, a [DuplicateElementError] is thrown.
  bool allowDuplicates = true;

  /// A field that control whether new Elements are checked for
  /// Issues when they are added to the [Dataset].
  bool checkIssuesOnAdd = false;

  /// A field that control whether new Elements are checked for
  /// Issues when they are accessed from the Dataset.
  bool checkIssuesOnAccess = false;

  static Dataset convert(Dataset dsOld, Dataset dsNew, [Bytes bytes]) {
    final badElements = <Element>[];
    for (final old in dsOld.elements) _convertElement(dsNew, old, badElements);
    log.debug('Bad Elements: $badElements');
    return dsNew;
  }

  // TODO: remove when tear offs work
  static const _makeElement = TagElement.fromValues;

  static void _convertElement(
      Dataset dsNew, Element old, List<Element> badElements) {
    final e = (old is SQ)
        ? _convertSQ(dsNew, old)
        : _makeElement(old.code, old.vrIndex, old.values, dsNew);
    if (e == null) {
      badElements.add(old);
    } else {
      dsNew.add(e);
    }
  }

  static SQ _convertSQ(Dataset parent, SQ oldSQ) =>
      SQtag.convert(parent, oldSQ);
}
