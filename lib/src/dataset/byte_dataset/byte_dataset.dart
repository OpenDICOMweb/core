//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/tag.dart';

// ignore_for_file: public_member_api_docs

/// A [ByteDataset] is a DICOM [Dataset].
mixin ByteDataset {
  Map<int, Element> get eMap;

  List<Element> get elements => eMap.values.toList(growable: false);

	bool get isImmutable => true;

  /// Returns _true_ if the [Dataset] can have an undefined length.
  bool get undefinedLengthAllowed => true;

  int keyToIndex(int code)  => code;

	Tag getTag(int key, [int vrIndex, Object creator]) =>
  Tag.lookupByCode(key);
}
