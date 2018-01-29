// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/dataset/element_list/element_list.dart';
import 'package:core/src/tag/constants.dart';
import 'package:core/src/element/base/sequence.dart';

/// Sequence Items -
abstract class Item extends Dataset {

  @override
  IDSBytes get dsBytes;
  set dsBytes(IDSBytes bd);

	/// The Sequence that contains this Item.
	/// [sequence] has one-time setter that is initialized lazily.
  // ignore: unnecessary_getters_setters
	SQ get sequence => _sq;
	SQ _sq;
  // ignore: unnecessary_getters_setters
	set sequence(SQ sq) => _sq ??= sq;

	@override
	Dataset get parent;
	@override
	ElementList get elements;

	/// The length of the Value Field of the encoded object (e.g. ByteData,
	/// JSON [String]...) that _this_was created from, or
	/// _null_ if _this_was not created by parsing an encoded object.
	@override
	int get vfLengthField => dsBytes.vfLengthField;

	/// The actual length of the Value Field for _this_
	@override
	int get vfLength => (dsBytes != null) ? dsBytes.eLength - 8 : null;

	/// _true_if _this_was created from an encoded object (e.g. [ByteData],
	/// JSON [String]...) and the Value Field length was [kUndefinedLength].
	// Design Note:
	//   Only Item and its subclasses can have undefined length.
	//   RootDatasets cannot.
	@override
  bool get hasULength => vfLengthField == kUndefinedLength;

	@override
	List<int> get keys => elements.keys;

	/// _Deprecated_: Use [sequence] = [sq] instead.
  @deprecated
  void addSQ(SQ sq) {
    assert(sq is SQ && sq != null && _sq == null);
    sequence = _sq ??= sq;
  }

  Item copy([Dataset parent]);
}
