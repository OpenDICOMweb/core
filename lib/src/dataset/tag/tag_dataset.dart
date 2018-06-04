//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/dataset/base.dart';
import 'package:core/src/dataset/tag.dart';
import 'package:core/src/element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';

/// An [TagDataset] is a Dataset containing TagElements.
abstract class TagDataset {
  PrivateGroups get pGroups;

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

  bool isImmutable = false;

  int keyToIndex(int code) => code;

  Tag getTag(int key) => Tag.lookupByCode(key);

  static const _makeSQ = TagElement.makeSequenceFromCode;

  static const _makeElement = TagElement.makeFromValues;

  static Dataset convert(Dataset dsOld, Dataset dsNew,
      [Bytes bytes]) {
    final badElements = <Element>[];
    for (var old in dsOld.elements) {
      final e = (old is SQ)
          ? _makeSQ(dsNew, old.code, <TagItem>[], bytes)
          : _makeElement(old.code, old.vrIndex, old.values, dsNew);
      if (e == null) {
        badElements.add(e);
      } else {
        dsNew.add(e);
      }
    }
    print('Bad Elements: $badElements');
    return dsNew;
  }
}
