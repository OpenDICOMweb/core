// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/tag/tag_lib.dart';

/// A Element Type predicate. Returns _true_ if the Element
/// corresponding to [key] in the [Dataset] satisfies the
/// requirements for the SopClass of the [Dataset].
typedef bool ETypePredicate<K>(Dataset ds, K key) ;

/// [TagMixinBase] defines the interface to DICOM Tags, where
/// a Tag is a semantic identifier for an element.
///
/// Any non abstract subclasses of Element, must implement _this_.
abstract class TagMixinBase<K, V> {

	/// The DICOM Element Definition. In the _ODW_ _SDK_ this is called a "_Tag_".
  Tag get tag;

  // **** Tag Identifier related getters
  /// Returns the identifier ([key]), used as key to locate
  /// the Element in a Dataset<K,V>. It will typically
  /// be one of [tag], code, or keyword.
  K get key;


  // **** VR related Getters ****

  /// The Value Representation (VR) for this Element.
//  VR get vr;

  /// The index ([vrIndex]) of the Value Representation for this Element.
  int get vrIndex;

  /// The Value Representation code ([vrCode]) for this Element.
	int get vrCode;

  /// The number of bytes in one value.
  int get sizeInBytes;

  /// The maximum Value Field length in bytes for this Element.
  int get maxVFLength;

  // **** VM related Getters ****

  /// The Value Multiplicity ([vm]) for this Element.
	VM get vm;

	/// The _minimum_ length of a non-empty Value Field for this Element.
  int get vmMin;

  /// The _maximum_ length of a non-empty Value Field for this Element.
  int get vmMax;

  /// The _rank_ or _width_, i.e. the number of columns in the
  /// Value Field for this Element. _Note_: The Element values
  /// length must be a multiple of this number.
  int get vmColumns;

  // **** Value Field related Getters ****

  /// Returns the unsigned integer value contained in the Value Field.
  ///
  /// _Note_: If this is kUndefinedLength (0xFFFFFFFF), then the length
  /// is undefined. Only OB, OW, SQ, and UN can have undefined lengths.
  int get vfLengthField;

  /// The actual length in bytes of the Value Field.
  int get vfLength;

  // **** Element Type (1, 1c, 2, ...) related Getters ****

  /// The Element Type of this Element.
  EType get eType;

  /// The Element Type index of this Element.
  int get eTypeIndex;

  /// The Element Type predicate of this Element.
  ETypePredicate get eTypePredicate;

  // **** Information Entity Level related Getters ****

  /// The Information Entity Type of this Element.
  IEType get ieType;

  /// The Information Entity index of this Element.
  int get ieIndex;

  /// The Information Entity level of this Element.
  String get ieLevel;

  // **** DeIdentification Method related Getters ****

  /// The DeIdentification Method index for this Element.
  int get deIdIndex;

  /// The DeIdentification Method name for this Element.
//  DeIdMethod get deIdMethod;

  // **** Tag status related Getters ****

  /// Returns true if _this_ is a Data Element defined by the DICOM Standard.
  bool get isPublic;

  /// _true_ if _this_ is a Private Data Element, i.e. defined by a
  /// manufacturer or vendor.
  bool get isPrivate;

  /// _true_ if this Element has been retired, i.e. is no longer
  /// defined by the current DICOM Standard.
  bool get isRetired;
}