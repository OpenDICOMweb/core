//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:collection';
import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset_mixin.dart';
import 'package:core/src/dataset/base/errors.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/system.dart';

// ignore_for_file: unnecessary_getters_setters

// Meaning of method names:
//    lookup:
//    add:
//    update
//    replace(int index, Iterable<V>: Replaces
//    noValue: Replaces an Element in the Dataset with one with an empty value.
//    delete: Removes an Element from the Dataset

// Design Note:
//   Only [keyToTag] and [keys] use the Type variable <K>. All other
//   Getters and Methods are defined in terms of [Element] [index].
//   [Element.index] is currently [Element.code], but that is likely
//   to change in the future.

/// A DICOM Dataset. The [Type] [<K>] is the Type of 'key'
/// used to lookup [Element]s in the [Dataset]].
abstract class Dataset extends Object with ListMixin<Element>, DatasetMixin {
  @override
  Element operator [](int i) => lookup(i);
  @override
  void operator []=(int i, Element e) => tryAdd(e);

  // TODO: when are 2 Datasets equal?
  // TODO: should this be checking that parents are equal? It doesn't
  @override
  bool operator ==(Object other) {
    if (other is Dataset && length == other.length) {
      for (var e in elements) if (e != other[e.index]) return false;
      return true;
    }
    return false;
  }

  // Implement Equality
  @override
  int get hashCode => system.hasher.nList(elements);

  @override
  bool remove(Object e) =>
     (e is Element) ? elements.remove(e) : false;

  // **** Section Start: Element related Getters and Methods

  /// Returns the Element with [index], if present; otherwise, returns _null_.
  ///
  /// _Note_: All lookups should be done using this method.
  ///
  // Design Note: This method should record the index of any Elements
  // not found if [recordNotFound] is _true_.
  @override
  Element lookup(int index, {bool required = false}) {
    final e = this[index];
    if (e == null && required == true) return elementNotPresentError(index);
    return e;
  }

  @override
  Element internalLookup(int index) => this[index];

/*
  @override
  Element deleteCode(int code) {
    print('index: $code');
    final e = this[code];
    if (e != null) rCode(code);
    return e;
  }
*/

  static const List<Dataset> empty = const <Dataset>[];

  static final ByteData emptyByteData = new ByteData(0);
}
