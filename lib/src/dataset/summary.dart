// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/timer/timestamp.dart';


//TODO: test
class Summary {
  Timestamp timestamp;
  Dataset _ds;
  int nElements = 0;
  int nSequences = 0;
  int nItems = 0;

  Summary(this._ds) : timestamp = Timestamp.now {
    _summarizeDataset(_ds);
    _ds = null;
  }

  Summary.withDataset(this._ds) : timestamp = Timestamp.now {
    _summarizeDataset(_ds);
  }

  void _summarizeDataset(Dataset ds) {
    for (var e in ds.elements) {
      if (e is SQ) _summarizeSequence(e);
      nElements++;
    }
  }

  void _summarizeSequence(Element sq) {
    for (Dataset item in sq.values) {
      _summarizeDataset(item);
      nItems++;
    }
    nSequences++;
  }

  @override
  String toString() => 'DS(${_ds.hashCode}): Elements($nElements), '
      'Sequences($nSequences), Items($nItems)';
}
