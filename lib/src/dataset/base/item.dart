// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element/base/sequence.dart';

/// Sequence Items -
abstract class Item extends Dataset {
	/// The Sequence that contains this Item.
	/// [sequence] has one-time setter that is initialized lazily.
  // ignore: unnecessary_getters_setters
	SQ get sequence;
  // ignore: unnecessary_getters_setters
	set sequence(SQ sq);

	@override
	Dataset get parent;

	/// _Deprecated_: Use [sequence] = [sq] instead.
  @deprecated
  void addSQ(SQ sq) {
    assert(sq is SQ && sq != null);
    sequence = sq;
  }
}
