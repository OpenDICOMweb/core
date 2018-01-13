// Copyright (c) 2016, 2017 Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/element_list/element_list.dart';
import 'package:core/src/tag/tag_lib.dart';

/// A [DatasetBD] is a DICOM [Dataset].
abstract class DatasetBD {

	ElementList<int> get elements;

	bool get isImmutable => true;

  /// Returns _true_ if the [Dataset] can have an undefined length.
  bool get undefinedLengthAllowed => true;

  int keyToIndex(int key)  => key;

	Tag getTag(int key) => Tag.lookupByCode(key);
}
