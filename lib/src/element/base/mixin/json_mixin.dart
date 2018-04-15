//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/tag/tag.dart';

abstract class JsonMixin<V> {
	Tag get tag;
	List<V> get values;
	Uint8List get bytes;
	int get vrIndex;
	String get vrId;
//	VR get vr;

	/// Returns a comma-separated [String] of [List][values].
	String get valuesAsString => values.join(', ');

	String get base64 => cvt.base64.encode(bytes);

	/// Returns a [String] containing an array of JSON [num].
	//TODO: decide if this is needed
	String get toJsonVF => '[${values.join(",")}]';

	/// Returns an Element as a JSON [Dataset] member
	String get toJson => '"${tag.code}": {vr: $vrId, values: $toJsonVF';

	/// Returns the [values] encoded as a [Base64] [String].
	String get vfBase64 => cvt.base64.encode(bytes);

	Uint8List bytesFromB64(String s) => cvt.base64.decode(s);

	/// Returns a [base64] [String] containing [bytes].
	String base64FromVFBytes(Uint8List bytes) => cvt.base64.encode(bytes);

	/// Returns a [Uint8List] containing [bytes].
	Uint8List bytesFromBase64(String s) => cvt.base64.decode(s);

}