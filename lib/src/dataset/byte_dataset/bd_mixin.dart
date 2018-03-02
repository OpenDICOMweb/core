// Copyright (c) 2016, 2017 Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base.dart';
import 'package:core/src/tag.dart';

/// A [BDMixin] is a DICOM [Dataset].
abstract class BDMixin {

	bool get isImmutable => true;

  /// Returns _true_ if the [Dataset] can have an undefined length.
  bool get undefinedLengthAllowed => true;

  int keyToIndex(int key)  => key;

	Tag getTag(int key) => Tag.lookupByCode(key);
}