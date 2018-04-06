// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/utils/issues.dart';

List<Issues> validateRootDataset(RootDataset ds) =>
    _validateDataset(ds, <Issues>[]);

List<Issues> _validateDataset(Dataset ds, List<Issues> iList) {
  for (var e in ds) {
    final v = e.issues;
    if (v != null && v.isNotEmpty) {
      iList.add(v);
      print('$e\n  Issues: $v');
    }
    if (e is SQ) _validateSequence(e, iList);
  }
  return iList;
}

List<Issues> _validateSequence(SQ sq, List<Issues> iList) {
  for (var item in sq.items) _validateDataset(item, iList);
  return iList;
}
