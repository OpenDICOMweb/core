// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

// TODO: replace all cvt.base64.encode/decode with base64Encode/base64Decode
// TODO: same for JSON, ascii, utf8,...

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/utils/bytes.dart';

abstract class JsonMixin<V> {
	Tag get tag;
	List<V> get values;
	Bytes get bytes;
	int get vrIndex;
	String get vrId;
//	VR get vr;

	/// Returns a comma-separated [String] of [List][values].
	String get valuesAsString => values.join(', ');

	String get base64 => base64Encode(bytes);

	/// Returns a [String] containing an array of JSON [num].
	//TODO: decide if this is needed
	String get toJsonVF => '[${values.join(",")}]';

	/// Returns an Element as a JSON [Dataset] member
	String get toJson => '"${tag.code}": {vr: $vrId, values: $toJsonVF';

	/// Returns the [values] encoded as a [Base64] [String].
	String get vfBase64 => base64Encode(bytes);

	Bytes bytesFromB64(String s) => base64Decode(s);

	/// Returns a [base64] [String] containing [bytes].
	String base64FromVFBytes(Bytes bytes) => base64Encode(bytes);

	/// Returns a [Uint8List] containing [bytes].
	Bytes bytesFromBase64(String s) => base64Decode(s);

}