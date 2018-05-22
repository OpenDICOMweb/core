//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/dataset/base/dataset.dart';

/// A Element Type predicate. Returns _true_ if the Element
/// corresponding to [key] in the [Dataset] satisfies the
/// requirements for the SopClass of the [Dataset].
typedef bool ETypePredicate<K>(Dataset ds, K key) ;

/// [ElementBase] defines the interface to DICOM Tags, where
/// a Tag is a semantic identifier for an element.
///
/// Any non abstract subclasses of Element, must implement _this_.
abstract class ElementBase {


  // **** Tag Identifier related getters
  /// Returns the identifier ([index]), used to locate
  /// the Attributes associated with this Element.
  int get index;

  /// Returns the DICOM Tag Code ([code]) associated with this Element
  int get code;

  String get keyword;

  String get name;

  // **** VR related Getters ****

  /// The index ([vrIndex]) of the Value Representation for this Element.
  int get vrIndex;

	/// The _minimum_ length of a non-empty Value Field for this Element.
  int get vmMin;

  /// The _maximum_ length of a non-empty Value Field for this Element.
  int get vmMax;

  /// The _rank_ or _width_, i.e. the number of columns in the
  /// Value Field for this Element. _Note_: The Element values
  /// length must be a multiple of this number.
  int get vmColumns;

  // **** Value Field related Getters ****

  /// The value of the Value Field Lengt field in binary Elements.
  int get vfLengthField;

  /// The actual length in bytes of the Value Field.
  int get vfLength;

  // **** Element Type (1, 1c, 2, ...) related Getters ****

  /// The Element Type index of this Element.
  int get eTypeIndex;

  // **** Information Entity Level related Getters ****


  /// The Information Entity index of this Element.
  int get ieIndex;

  /// The Information Entity level of this Element.
  String get ieLevel;

  // **** DeIdentification Method related Getters ****

  /// The DeIdentification Method index for this Element.
  int get deIdIndex;

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