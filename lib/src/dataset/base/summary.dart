//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/utils/timer.dart';

// ignore_for_file: public_member_api_docs

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
    for (final e in ds.elements) {
      if (e is SQ) _summarizeSequence(e);
      nElements++;
    }
  }

  void _summarizeSequence(Element sq) {
    for (final item in sq.values) {
      _summarizeDataset(item);
      nItems++;
    }
    nSequences++;
  }

  @override
  String toString() => 'DS(${_ds.hashCode}): Elements($nElements), '
      'Sequences($nSequences), Items($nItems)';
}
