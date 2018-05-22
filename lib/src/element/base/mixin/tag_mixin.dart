//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/tag/tag.dart';

abstract class TagMixin {
	Tag get tag;

  /// Returns the identifier ([index]), used to locate
  /// the Attributes associated with this Element.
  int get index => tag.index;

  /// Returns the Tag Code ([code]) associated with this Element
  int get code => tag.code;

  /// Returns the _keyword_ associated with this Element.
  String get keyword => tag.keyword;

  /// Returns the _name_ associated with this Element.
  String get name => tag.name;

  // **** VR related Getters ****

  /// The index ([vrIndex]) of the Value Representation for this Element.
  int get vrIndex=> tag.vrIndex;

  /// Returns the Value Representation (VR) integer code [vrCode] for _this_.
  int get vrCode => tag.vrCode;
  /// The _minimum_ length of a non-empty Value Field for this Element.
  int get vmMin => tag.vmMin;

  /// The _maximum_ length of a non-empty Value Field for this Element.
  int get vmMax => tag.vmMax;

  /// The _rank_ or _width_, i.e. the number of columns in the
  /// Value Field for this Element. _Note_: The Element values
  /// length must be a multiple of this number.
  int get vmColumns=> tag.vmColumns;

  /// Returns true if _this_ is a Data Element defined by the DICOM Standard.
  bool get isPublic => tag.isPublic;

  /// _true_ if this Element has been retired, i.e. is no longer
  /// defined by the current DICOM Standard.
  bool get isRetired => tag.isRetired;

}