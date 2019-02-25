//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/element.dart';
import 'package:core/src/error/dataset_errors.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

mixin NoValuesMixin {
  /// An [Iterable<Element>] of the [Element]s contained in _this_.
  ///
  // Design Note: It is expected that [ElementList] will have
  // it's own specialized implementation for correctness and efficiency.
  List<Element> get elements;

  bool get allowInvalidValues => true;

  /// Store [Element] [e] at [index] in _this_.
  void store(int index, Element e);

  /// Returns the Element with [index], if present; otherwise, returns _null_.
  ///
  /// _Note_: All lookups should be done using this method.
  ///
  Element lookup(int index, {bool required = false});

// **** End Interface

  // **** Getters for [values]s.

  /// Returns the values for the [Element] with [index]. If the [Element]
  /// is not present or if the [Element] has more than one values,
  /// either throws or returns _null_;
  V getValue<V>(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    return _checkOneValue(index, e.values);
  }

  V _checkOneValue<V>(int index, List<V> values) =>
      (values == null || values.length != 1)
          ? badValuesLength(values, 0, 1, null, Tag.lookupByCode(index), )
          : values.first;

  /// Returns the [int] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<V> getValues<V>(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null) return required ? elementNotPresentError(index) : null;
    final List<V> values = e.values;
    assert(values != null);
    return allowInvalidValues ? e.values : e.isValid;
  }

  // **** Integers

  // Image Pixel Macro values

  int get frameCount => getInt(kNumberOfFrames);

  int get samplesPerPixel => getInt(kSamplesPerPixel);

  String get photometricInterpretation => getString(kPhotometricInterpretation);

  int get rows => getInt(kRows);

  int get columns => getInt(kColumns);

  int get bitsAllocated => getInt(kBitsAllocated);

  int get bitsStored => getInt(kBitsStored);

  int get highBit => getInt(kHighBit);

  int get pixelRepresentation => getInt(kPixelRepresentation);

  int get smallestImagePixelValue => getInt(kSmallestImagePixelValue);

  int get largestImagePixelValue => getInt(kLargestImagePixelValue);

  //TODO definedTerms [colorByPixel = 0, colorByPlane = 1]
  int get planarConfiguration => getInt(kPlanarConfiguration);

  double get pixelAspectRatio {
    final list = getStringList(kPixelAspectRatio);
    if (list == null || list.isEmpty) return 1;
    if (list.length != 2) {
      badValues(list, null, PTag.kPixelAspectRatio);
      //Issue: is this reasonable?
      return 1;
    }
    final numerator = int.parse(list[0]);
    final denominator = int.parse(list[1]);
    return numerator / denominator;
  }

  /// Returns the [int] values for the [Integer] Element with [index].
  /// If the [Element] is not present or if the [Element] has more
  /// than one values, either throws or returns _null_.
  int getInt(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! Integer) return nonIntegerTag(index);
    return _checkOneValue<int>(index, e.values);
  }

  /// Returns the [List<int>] values for the [Integer] Element with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<int> getIntList(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! Integer) return nonIntegerTag(index);
    if (!allowInvalidValues && !e.hasValidValues)
      return badElement('Invalid Element: $e', e);
    final vList = e.values;
    //if (vList == null) return nullValueError('getIntList');
    assert(vList != null);
    return vList;
  }

  // **** Floating Point

  /// Returns a [double] values for the [Float] Element with
  /// [index]. If the [Element] is not present or if the [Element] has more
  /// than one values, either throws or returns _null_.
  double getFloat(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! Float) return nonFloatTag(index);
    return _checkOneValue<double>(index, e.values);
  }

  /// Returns the [List<double>] values for the [Float] Element
  /// with [index]. If [Element] is not present, either throws or returns
  /// _null_;
  List<double> getFloatList(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! Float) return badFloatElement(e);
    final vList = e.values;
    //if (vList == null) return nullValueError('getFloatList');
    assert(vList != null);
    return vList;
  }

  // **** String

  /// Returns a [double] values for the [StringBase] Element with [index].
  /// If the [Element] is not present or if the [Element] has more
  /// than one values, either throws or returns _null_.
  String getString(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! StringBase) return nonStringTag(index);
    return (e.isEmpty) ? '' : _checkOneValue<String>(index, e.values);
  }

  /// Returns the [List<double>] values for the [StringBase] Element
  /// with [index]. If [Element] is not present, either throws or returns
  /// _null_;
  List<String> getStringList(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null || e is! StringBase) return nonStringTag(index);
    if (!allowInvalidValues && !e.hasValidValues)
      return badElement('Invalid Element: $e', e);
    final vList = e.values;
    //if (vList == null) return nullValueError('getStringList');
    assert(vList != null);
    return vList;
  }

  // **** Item

  /// Returns an [Item] values for the [SQ] [Element] with [index].
  /// If the [Element] is not present or if the [Element] has more
  /// than one values, either throws or returns _null_.
  Item getItem(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null)
      return (required == false) ? null : elementNotPresentError(index);
    if (e is SQ) return _checkOneValue<Item>(index, e.values);
    return nonSequenceTag(index);
  }

  /// Returns the [List<Item>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<Item> getItemList(int index, {bool required = false}) {
    final e = lookup(index, required: required);
    if (e == null)
      return (required == false) ? null : elementNotPresentError(index);
    if (e is SQ) {
      final vList = e.values;
      if (vList == null) return nullValueError('getItemList');
      return vList;
    }
    return nonSequenceTag(index);
  }

  // **** Uid

  /// Returns a [Uid] values for the [UI] [Element] with [index].
  /// If the [Element] is not present or if the [Element] has more
  /// than one values, either throws or returns _null_.
  Uid getUid(int index, {bool required = false}) {
    final UI e = lookup(index, required: required);
    return (e == null) ? null : _checkOneValue<Uid>(index, e.uids);
  }

  /// Returns the [List<double>] values for the [Element] with [index].
  /// If [Element] is not present, either throws or returns _null_;
  List<Uid> getUidList(int index, {bool required = false}) {
    final UI e = lookup(index, required: required);
    if (e == null || e is! UI) return nonUidTag(index);
    final vList = e.uids;
    if (vList == null) return nullValueError('getUidList');
    return vList;
  }

  // **************** Element values accessors
  //TODO: when fast_tag is working replace code with index.
  // Note: currently the variable 'index' in this file means code.

  /// Returns a Uint8List or Uint16List of pixels from the [kPixelData]
  /// [Element];
  List<int> getPixelData() {
    final bitsAllocated = getInt(kBitsAllocated);
    return _getPixelData(bitsAllocated);
  }

  List<int> _getPixelData(int bitsAllocated) {
    final e = lookup(kPixelData);
    if (e == null || bitsAllocated == null) return pixelDataNotPresent();
    if (e.code == kPixelData) {
      if (e is OWPixelData) {
        assert(bitsAllocated == 16);
        return e.values;
      } else if (e is OBPixelData) {
        assert(bitsAllocated == 8 || bitsAllocated == 1);
        return e.values;
      } else if (e is UNPixelData) {
        // TODO: use transfer syntax to convert UN into OW or OB
        assert(bitsAllocated == 8 || bitsAllocated == 1);
        return e.values;
      } else {
        return badElement('$e is bad Pixel Data', e);
      }
    }
    if (throwOnError) return null;
    return null;
  }
}
