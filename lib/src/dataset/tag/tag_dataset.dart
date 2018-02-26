// Copyright (c) 2016, 2017, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';

/// An [TagDataset] is a Dataset containing TagElements.
abstract class TagDataset {
  History get history;
  /// If _true_ [Element]s with invalid values are stored in the
  /// [Dataset]; otherwise, an [InvalidValuesError] is thrown.
  bool allowInvalidValues = true;

  /// If _true_ duplicate [Element]s are stored in the duplicate Map
  /// of the [Dataset]; otherwise, a [DuplicateElementError] is thrown.
  bool allowDuplicates = true;

  /// A field that control whether new [Element]s are checked for
  /// [Issues] when they are added to the [Dataset].
  bool checkIssuesOnAdd = false;

  /// A field that control whether new [Element]s are checked for
  /// [Issues] when they are accessed from the [Dataset].
  bool checkIssuesOnAccess = false;


  bool isImmutable = false;

	int keyToIndex(int code) => code;

	Tag getTag(int key) => Tag.lookupByCode(key);
}
