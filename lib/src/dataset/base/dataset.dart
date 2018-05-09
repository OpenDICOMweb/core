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
import 'package:core/src/dataset/base/group/creators.dart';
import 'package:core/src/dataset/base/history.dart';
import 'package:core/src/element.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/vr.dart';

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
  /// [PCTag]s for [PC] [Element]s in _this_.
  final PrivateCreatorTags pcTags = new PrivateCreatorTags();

  /// A history of changes to _this_.
  final History history = new History();

  // Note: super classes must implement
  @override
  Element operator [](int i);

  // Note: super classes should not override
  @override
  void operator []=(int i, Element e) {
    assert(i == e.index);
    tryAdd(e);
  }

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
  bool remove(Object e) => (e is Element) ? elements.remove(e) : false;

  // **** Section Start: Element related Getters and Methods

  /// A field that control whether new [Element]s are checked for
  /// [Issues] when they are accessed from the [Dataset].
  bool get checkIssuesOnAccess => false;

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

  /// All lookups should be done using this method.
  List<Element> lookupAll(int index) {
    final results = <Element>[];
    final e = lookup(index);
    e ?? results.add(e);
    for (var sq in sequences)
      for (var item in sq.items) {
        final e = item[index];
        e ?? results.add(e);
      }
    return results;
  }

  @override
  Element internalLookup(int index) => this[index];

  /// Adds an [Element] to a [Dataset].
  @override
  void add(Element e, [Issues issues]) => tryAdd(e, issues);

  @override
  void addAll(Iterable<Element> eList) => eList.forEach(add);

  /// If _true_ [Element]s with invalid values are stored in the
  /// [Dataset]; otherwise, an [InvalidValuesError] is thrown.
  @override
  bool get allowInvalidValues => true;

  /// If _true_ duplicate [Element]s are stored in the duplicate Map
  /// of the [Dataset]; otherwise, a [DuplicateElementError] is thrown.
  bool get allowDuplicates => true;

  /// A field that control whether new [Element]s are checked for
  /// [Issues] when they are [add]ed to the [Dataset].
  bool get checkIssuesOnAdd => false;

  /// Tries to add an [Element] to a [Dataset]. Return _true_ if successful.
  ///
  /// If the new [Element] is not valid and [allowInvalidValues] is _false_,
  /// an [invalidElement] is thrown; otherwise, the [Element] is added
  /// to both the [_issues] [Map] and to the [Dataset]. The [_issues] [Map]
  /// can be used later to return an [Issues] for the [Element].
  ///
  /// If an [Element] with the same Tag is already contained in the
  /// [Dataset] and [allowDuplicates] is _false_, a [DuplicateElementError] is
  /// thrown; otherwise, the [Element] is added to both the [duplicates] [Map]
  /// and to the [Dataset].
  @override
  bool tryAdd(Element e, [Issues issues]) {
    final code = e.code;
    final old = lookup(code);
    if (old == null) {
      if (checkIssuesOnAdd && (issues != null)) {
        if (!allowInvalidValues && !e.isValid)
          invalidElement('Invalid Values: $e', e);
      }
      if (Tag.isPCCode(code)) pcTags.tryAdd(e.tag);
      store(e.code, e);
      //     if (e is SQ) sequences.add(e);
      return true;
    } else if (allowDuplicates) {
      system.warn('** Duplicate Element:\n\tnew: $e\n\told: $old');
      if (old.vrIndex != kUNIndex) {
        history.duplicates.add(e);
      } else {
        store(e.index, e);
        history.duplicates.add(old);
      }
      return false;
    } else {
      return duplicateElementError(old, e);
    }
  }

  bool get hasDuplicates => history.duplicates.isNotEmpty;

  /// Remove all duplicates from the [Dataset].
  List<Element> deleteDuplicates() {
    final dups = history.duplicates;
    history.duplicates.clear();
    return dups;
  }

  @override
  List<SQ> get sequences {
    final results = <SQ>[];
    for (var e in elements) if (e is SQ) results.add(e);
    return results;
  }

/*
  @override
  Element deleteCode(int code) {
    print('index: $code');
    final e = this[code];
    if (e != null) rCode(code);
    return e;
  }
*/

  String get info => '''
$runtimeType(#$hashCode):
            Total: $total
        Top Level: $length
       Duplicates: ${history.duplicates.length}
  PrivateElements: $nPrivateElements
    PrivateGroups: $nPrivateGroups
    ''';

  @override
  String toString() => '$runtimeType: $length Elements';

  static const List<Dataset> empty = const <Dataset>[];

  static final ByteData emptyByteData = new ByteData(0);
}
