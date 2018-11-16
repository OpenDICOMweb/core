//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/element.dart';
import 'package:core/src/error/dataset_errors.dart';

/// A Mixin that implement an Element with no values.
mixin NoValuesMixin {
  /// An [Iterable<Element>] of the [Element]s contained in _this_.
  ///
  // Design Note: It is expected that [ElementList] will have
  // it's own specialized implementation for correctness and efficiency.
  List<Element> get elements;

  /// Store [Element] [e] at [index] in _this_.
  void store(int index, Element e);

  /// Returns the Element with [index], if present; otherwise, returns _null_.
  ///
  /// _Note_: All lookups should be done using this method.
  ///
  // Design Note: This method should record the index of any Elements
  // not found if [recordNotFound] is _true_.
  // TODO: turn required into an EType test
  Element lookup(int index, {bool required = false});

// **** End Interface

  /// Replaces the element with [index] with a new element that is
  /// the same except it has no values.  Returns the original element.
  Element noValues(int index, {bool required = false}) {
    final oldE = lookup(index, required: required);
    if (oldE == null) return required ? elementNotPresentError(index) : null;
    final newE = oldE.update(oldE.emptyList);
    store(index, newE);
    return oldE;
  }

  /// Updates all [Element.values] with [index] in _this_ or in any
  /// Sequences (SQ) contained in _this_ with an empty list.
  /// Returns a List<Element>] of the original [Element.values] that
  /// were updated.
  List<Element> noValuesAll(int index) {
    assert(index != null);
    final result = <Element>[]..add(noValues(index));
    for (var e in elements) {
      if (e is SQ) {
        result.addAll(e.noValuesAll(index));
      } else if (e.index == index) {
        result.add(e);
        store(index, e.noValues);
      }
    }
    return result;
  }
}
