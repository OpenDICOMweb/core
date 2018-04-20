//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/dataset/base.dart';
import 'package:core/src/tag.dart';

/// A [ByteDataset] is a DICOM [Dataset].
abstract class ByteDataset {

	bool get isImmutable => true;

  /// Returns _true_ if the [Dataset] can have an undefined length.
  bool get undefinedLengthAllowed => true;

  int keyToIndex(int key)  => key;

	Tag getTag(int key) => Tag.lookupByCode(key);
}
