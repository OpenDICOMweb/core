// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/issues.dart';
import 'package:core/src/tag/export.dart';

/// Tag Mixin Class
///
/// This mixin defines the interface to DICOM Tags, where a Tag is
/// a semantic identifier for an element.
abstract class TagMixinBase<K, V> {
  int get field;
  Tag get tag;

  // **** Tag Identifiers
	/// Returns the DICOM integer tag code.
  int get index;
	int get code;
  String get keyword;
  String get name;
  /// Returns the identifier ([key]), used as key to locate the Element in a Dataset<K,V>.
  K get key;

  // **** VR related Getters
//  VR get vr;
  int get vrIndex;
	int get vrCode;
	bool isNotValidValue(V value);

  /// The number of bytes in one value.
  int get unitSize;
  int get maxVFLength;
  TypedData valuesToBytes;

  List<V> values;

//  bool isValidVR(VR x, [Issues issues]) => x == vr;
  bool isValidVRIndex(int index, [Issues issues]) => index == vrIndex;
  bool isValidVRCode(int code, [Issues issues]) => code == vrCode;

  bool isValidValuesType(List<V> vList, [Issues issues]) => vList is List<V>;

  bool isValidVListLength(Tag tag, List<V> vList, [Issues issues]) {
  	final length = vList.length;
  	return length >= minLength && length <= maxLength && (length % rank) == 0;
  }
  bool isValidValues(Tag tag, List<V> vList, [Issues issues]) =>
    vList is List<V> && isValidVListLength(tag, vList) && _isValidValues(vList);

  bool _isValidValues(List<V> vList) {
	  for (var v in vList)
		  if (isNotValidValue(v)) return false;
	  return true;
  }

  // **** VM Related Getters
	VM get vm;
  int get minLength;
  int get maxLength;
  int get rank;


  // **** Element Type (1, 1c, 2, ...)
  EType get eType;
  int get eTypeIndex;
  int get predicate;

  // Information Entity Level
  int get ieLevel;

  // DeIdentification Method
  int get deIdIndex;
  int get deIdMethod;

  /// Returns true if _this_ is a Data Element defined by the DICOM Standard.
  bool get isPublic;
  bool get isPrivate;

  bool get isRetired;

  bool get hasValidType;

  /// Returns _true_ if [values].length is valid for _this_.
  bool get hasValidLength => (values.length >= minLength && values.length <= maxLength);

  /// Returns _true_ if all [values] are valid for _this_.
  bool get hasValidValues => isValidValues(tag, values);

  TypedData toTypedData(List<V> values);

  Issues get issues;
}