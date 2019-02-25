//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/dataset/base/group/private_group.dart';
import 'package:core/src/dataset/base/item.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: unnecessary_getters_setters, public_member_api_docs

// Meaning of method names:
//    lookup:
//    add:
//    update
//    replace(int index, Iterable<V>: Replaces
//    noValue: Replaces an Element in the Dataset with one with an empty values.
//    delete: Removes an Element from the Dataset

// Design Note:
//   Only [keyToTag] and [keys] use the Type variable <K>. All other
//   Getters and Methods are defined in terms of [Element] [index].
//   [Element.index] is currently [Element.code], but that is likely
//   to change in the future.

/// A DICOM Dataset. The [Type] [<K>] is the Type of 'key'
/// used to lookup [Element]s in the [Dataset]].
mixin DatasetMixin {
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
    for (final e in elements)
      if (e is SQ) {
        count += e.counter(test);
      } else {
        if (test(e)) count++;
      }
    return count;
  }

  List map<T>(Object f(Element e)) => _map(f, <Object>[]);

  List _map(Object f(Element e), List list) {
    for (final e in elements) {
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

  // **** Section Start: Element related Getters and Methods

  // Dataset<K> copy([Dataset<K> parent]);


  bool hasElementsInRange(int min, int max) {
    for (final e in elements)
      if (e.code >= min && e.code <= max) return true;
    return false;
  }

  /// Returns a [List] of the Elements that satisfy [min] <= e.code <= [max].
  List<Element> getElementsInRange(int min, int max) {
    final elements = <Element>[];
    for (final e in elements)
      if (e.code >= min && e.code < max) elements.add(e);
    return elements;
  }

  Iterable<Element> copyWhere(bool test(Element e)) {
    final result = <Element>[];
    for (final e in elements) {
      if (test(e)) result.add(e);
    }
    return result;
  }

  Iterable<Element> findWhere(bool test(Element e)) {
    final result = <Element>[];
    for (final e in elements) {
      if (test(e)) result.add(e);
    }
    return result;
  }

  Iterable<Object> findAllWhere(bool test(Element e)) {
    final result = <Object>[];
    for (final e in elements)
      if (test(e)) result.add(e);
    return result;
  }

  Map<SQ, Element> findSQWhere(bool test(Element e)) {
    final map = <SQ, Element>{};
    for (final e in elements) {
      if (e is SQ) {
        for (final item in e.items) {
          final eList = item.findAllWhere(test);
          if (eList.isNotEmpty) {
            map[e] = eList;
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

  List<int> findAllPrivateCodes({bool recursive = false}) {
    final privates = <int>[];
    for (final e in elements)
      if (e.isPrivate) privates.add(e.code);
    return privates;
  }

  Iterable<Element> retainSafePrivate() {
    final dList = <Element>[];
    //TODO: finish
    return dList;
  }

  /// Returns a formatted [String]. See [Formatter].
  String format(Formatter z) => z.fmt('$runtimeType: $length Elements', this);

  @override
  String toString() => '$runtimeType: $length Elements';

  // **************** RootDataset related Getters and Methods

  /// Returns _true_ if _this_ is a [RootDataset].
  bool get isRoot => parent == null;

  /// The [RootDataset] of _this_.
  /// _Note_: A [RootDataset] is its own [root].
  DatasetMixin get root => isRoot ? this : parent.root;


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

  static const List<Dataset> empty = <Dataset>[];

  static final ByteData emptyByteData = ByteData(0);
}
