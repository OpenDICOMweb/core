// Copyright (c) 2016, 2017, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';

/// An [TagDataset] is a Dataset containing TagElements.
abstract class TagDataset {

	bool get isImmutable => false;

	int keyToIndex(int code) => code;

	Tag getTag(int key) => Tag.lookupByCode(key);
}
