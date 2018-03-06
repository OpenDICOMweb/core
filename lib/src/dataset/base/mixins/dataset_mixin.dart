// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/base.dart';
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/base/history.dart';
import 'package:core/src/dataset/base/private_group.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/base/errors.dart';
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
abstract class DatasetMixin {
  // **** Start of Interface ****

  /// Returns the Element with [index], if present; otherwise, returns _null_.
  ///
  /// _Note_: All lookups should be done using this method.
  ///
  // Design Note: This method should record the index of any Elements
  // not found if [recordNotFound] is _true_.
  // TODO: turn required into an EType test
  Element lookup(int index, {bool required = false});

  Element internalLookup(int index);

  Element deleteCode(int index);

  /// Store [Element] [e] at [index] in _this_.
  void store(int index, Element e);

  bool remove(Object e);

  int get length;

  /// The parent of _this_. If [parent] == _null_, then this is a Root Dataset
  /// (see RootDatasetMixin); otherwise, it is an [Item].
  DatasetMixin get parent;

  /// An [Iterable<int>] of the [Element] [keys] in _this_.
  Iterable<int> get keys;

  /// An [Iterable<Element>] of the [Element]s contained in _this_.
  ///
  // Design Note: It is expected that [ElementList] will have
  // it's own specialized implementation for correctness and efficiency.
  List<Element> get elements;

  DSBytes get dsBytes;

  History get history;

  /// If _true_ [Element]s with invalid values are stored in the
  /// [Dataset]; otherwise, an [InvalidValuesError] is thrown.
  bool get allowInvalidValues => true;

  /// If _true_ duplicate [Element]s are stored in the duplicate Map
  /// of the [Dataset]; otherwise, a [DuplicateElementError] is thrown.
  bool get allowDuplicates => true;

  /// A field that control whether new [Element]s are checked for
  /// [Issues] when they are [add]ed to the [Dataset].
  bool get checkIssuesOnAdd => false;

  /// A field that control whether new [Element]s are checked for
  /// [Issues] when they are accessed from the [Dataset].
  bool get checkIssuesOnAccess => false;

  /// Returns a Sequence([SQ]) containing any [Element]s that were
  /// modified or removed.
  // TODO: complete and test
  //SQ get originalAttributesSequence;

  // **** End of Interface ****

  /// Returns the [Tag.index] for the corresponding [key].
  // Note: this should be overridden as necessary
  int keyToIndex(int key) => key;

  Tag getTag(int index, [int vrIndex, Object creator]) =>
      Tag.lookupByCode(index, vrIndex, creator);

  /// _true_ if _this_ is immutable.
  bool get isImmutable => false;

  int get total => counter((e) => true);

  int doCount(int sum, Element e) => (e is SQ) ? e.total : sum + 1;

  int get dupTotal => unsupportedError();

  // TODO Enhancement? make private for performance
  // TODO: make conform to Fold interface
  /// Walk the [Dataset] recursively and return the count of [Element]s
  /// for which [test] is true.
  /// Note: It ignores duplicates.
  int counter(ElementTest test) {
    var count = 0;
    for (var e in elements)
      if (e is SQ) {
        count += e.counter(test);
      } else {
        if (test(e)) count++;
      }
    return count;
  }

  List map<T>(dynamic f(Element e)) => _map(f, <dynamic>[]);

  List _map(dynamic f(Element e), List list) {
    for (var e in elements) {
      if (e is SQ) {
        list.add(e.sqMap(f));
      } else {
        list.add(f(e));
      }
    }
    return list;
  }

  // **** Section Start: Default Operator and Getters
  // **** These may be overridden in subclasses.

  bool get hasDuplicates => history.duplicates.isNotEmpty;

  List<SQ> get sequences {
    final results = <SQ>[];
    for (var e in elements)
      if (e is SQ) add(e);
    return results;
  }

  // **** Section Start: Element related Getters and Methods

  // Dataset<K> copy([Dataset<K> parent]);

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

  bool hasElementsInRange(int min, int max) {
    for (var e in elements)
      if (e.code >= min && e.code <= max) return true;
    return false;
  }

  /// Returns a [List] of the Elements that satisfy [min] <= e.code <= [max].
  List<Element> getElementsInRange(int min, int max) {
    final elements = <Element>[];
    for (var e in elements)
      if (e.code >= min && e.code < max) elements.add(e);
    return elements;
  }

  void add(Element e, [Issues issues]) => tryAdd(e);

  /// Trys to add an [Element] to a [Dataset].
  ///
  /// If the new [Element] is not valid and [allowInvalidValues] is _false_,
  /// an [invalidValuesError] is thrown; otherwise, the [Element] is added
  /// to both the [_issues] [Map] and to the [Dataset]. The [_issues] [Map]
  /// can be used later to return an [Issues] for the [Element].
  ///
  /// If an [Element] with the same [Tag] is already contained in the
  /// [Dataset] and [allowDuplicates] is _false_, a [DuplicateElementError] is
  /// thrown; otherwise, the [Element] is added to both the [duplicates] [Map]
  /// and to the [Dataset].
  bool tryAdd(Element e, [Issues issues]) {
    final old = lookup(e.code);
    if (old == null) {
      if (checkIssuesOnAdd && (issues != null)) {
        if (!allowInvalidValues && !e.isValid) invalidElementError(e);
      }
      store(e.code, e);
      return true;
    } else
    if (allowDuplicates) {
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

  void addAll(Iterable<Element> eList) => eList.forEach(add);

  Iterable<Element> copyWhere(bool test(Element e)) {
    final result = <Element>[];
    for (var e in elements) {
      if (test(e)) result.add(e);
    }
    return result;
  }

  Iterable<Element> findWhere(bool test(Element e)) {
    final result = <Element>[];
    for (var e in elements) {
      if (test(e)) result.add(e);
    }
    return result;
  }

  Iterable<dynamic> findAllWhere(bool test(Element e)) {
    final result = <dynamic>[];
    for (var e in elements)
      if (test(e)) result.add(e);
    return result;
  }

  Map<SQ, Element> findSQWhere(bool test(Element e)) {
    final map = <SQ, Element>{};
    for (var e in elements) {
      if (e is SQ) {
        for (var item in e.items) {
          final eList = item.findAllWhere(test);
          if (eList.isNotEmpty) {
            map[e];
          }
        }
      }
    }
    return map;
  }

  bool _isDA(Element e) => e is DA;
  Iterable<Element> findDates() => findAllWhere(_isDA);

  bool _isUI(Element e) => e is UI;
  Iterable<Element> findUids() => findAllWhere(_isUI);

  bool _isSQ(Element e) => e is SQ;
  Iterable<Element> findSequences() => findWhere(_isSQ);

  bool _isPrivate(Element e) => e.isPrivate;
  Iterable<Element> findAllPrivate0() => findAllWhere(_isPrivate);

  List<int> findAllPrivateCodes({bool recursive: false}) {
    final privates = <int>[];
    for (var e in elements)
      if (e.isPrivate) privates.add(e.code);
    return privates;
  }


  // final sequences = findAllSequences();
  /*
    for (var e in elements) {
      if (e.group.isOdd) print('Odd: $e');
      if (e.isPrivate) {
        final v = delete(e.code);
        if (v != null) deleted.add(e);
        if (v != null) print('DPrivate: $v');
      }
    }
    if (deleted != null) print('DeletedPrivate: (${deleted.length})$deleted');

    for (var e in elements) {
      if (e.isPrivate) {
        deleted.add(delete(e.code));
      }
      print('DeletedPrivate: (${deleted.length})$deleted');
    }
*/
/*

    final deletedInSQ = <Element>[];
    var count = 0;
    print('sequences: $sequences');
    for (var e in sequences) {
      if (e is SQ) {
        count++;
        print('sq: $e');
        for (var item in e.items) {
          print(' item: $item');
          for(var v in item.elements) {
            if (v.isPrivate) {
              print('  Deleted: $v');
              deletedInSQ.add(delete(v.code));
            }
          }
        }
      }
    }
    print('SQ.length: ${sequences.length}');
        print('SQ.count: $count');
        deleted.addAll(deletedInSQ);
    print('DeletedPrivate: (${deleted.length})$deleted');
    return deleted;
  }
*/

  Iterable<Element> retainSafePrivate() {
    final dList = <Element>[];
    //TODO: finish
    return dList;
  }


  String get info => '''
$runtimeType(#$hashCode):
            Total: $total
        Top Level: $length
       Duplicates: ${history.duplicates.length}
  PrivateElements: $nPrivateElements
    PrivateGroups: $nPrivateGroups
    ''';

  /// Returns a formatted [String]. See [Formatter].
  String format(Formatter z) => z.fmt('$runtimeType: $length Elements', this);

  @override
  String toString() => '$runtimeType: $length Elements';

  // **************** RootDataset related Getters and Methods

  /// Returns _true_ if _this_ is a [RootDataset].
  bool get isRoot => parent == null;

  /// The [RootDataset] of _this_.
  /// _Note_: A [RootDataset] is its own [root].
  DatasetMixin get root => (isRoot) ? this : parent.root;


  /// PrivateGroup]s contained in this [Dataset].
  /// [privateGroups] has one-time setter that is initialized lazily.
  /// Note: this may disappear in the future.  Don't rely on it.
  List<PrivateGroup> get privateGroups => _privateGroups;
  List<PrivateGroup> _privateGroups;
  set privateGroups(List<PrivateGroup> vList) => _privateGroups ??= vList;

  int _privateElementCounter(int count, Element e) =>
      e.isPrivate ? count + 1 : count;
  int get nPrivateElements => elements.fold(0, _privateElementCounter);

  int _privateGroupCounter(int count, Element e) =>
      e.isPrivateCreator ? count + 1 : count;
  int get nPrivateGroups => elements.fold(0, _privateGroupCounter);

  // **** Statics

  static const List<Dataset> empty = const <Dataset>[];

  static final ByteData emptyByteData = new ByteData(0);
}
