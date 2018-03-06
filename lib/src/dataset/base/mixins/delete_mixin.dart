// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/errors.dart';
import 'package:core/src/dataset/base/history.dart';
import 'package:core/src/element.dart';

abstract class DeleteMixin {
  /// An [Iterable<Element>] of the [Element]s contained in _this_.
  ///
  // Design Note: It is expected that [ElementList] will have
  // it's own specialized implementation for correctness and efficiency.
  List<Element> get elements;
  List<SQ> get sequences;
  History get history;

  /// Store [Element] [e] at [index] in _this_.
  void store(int index, Element e);

  bool remove(Object e);

  /// Returns the Element with [index], if present; otherwise, returns _null_.
  ///
  /// _Note_: All lookups should be done using this method.
  ///
  Element lookup(int index, {bool required = false});

  Element deleteCode(int index);


  List<int> findAllPrivateCodes({bool recursive: false});

// **** End Interface



  /// Removes the [Element] with [code] from _this_. If no [Element]
  /// with [code] is contained in _this_ returns _null_.
  Element delete(int code, {bool required = false}) {
    assert(code != null && !code.isNegative, 'Invalid index: $code');
    final e = lookup(code, required: required);
    if (e == null) return (required) ? elementNotPresentError<int>(code) : null;
    return (remove(e)) ? e : null;
  }

  /// Deletes all [Element]s in _this_ that have a Tag Code in [codes].
  /// If there is no [Element] with one of the codes _this_ does nothing.
  List<Element> deleteCodes(List<int> codes) {
    //  print('codes: $codes');
    assert(codes != null && codes.isNotEmpty);
    final deleted = <Element>[];
    for (var code in codes) {
      final e = deleteCode(code);
      if (e != null) deleted.add(e);
    }
    return deleted;
  }

  /// Remove all duplicates from _this_.
  List<Element> deleteDuplicates() {
    final dups = history.duplicates;
    history.duplicates.clear();
    return dups;
  }

/*
  Iterable<Element> deleteAll(int index, {bool recursive = false}) =>
      elements.deleteAll(index, recursive: recursive);
*/

  List<Element> deleteAll(int index, {bool recursive = false}) {
    assert(index != null, 'Invalid index: $index');
    final results = <Element>[];
    final e = delete(index);
    if (e != null) results.add(e);
    assert(lookup(index) == null);
    if (recursive) for (var e in elements) {
      if (e is SQ) {
        for (var item in e.items) {
          final deleted = item.delete(index);
//            if (deleted != null) print('item $item deleted: $deleted');
          if (deleted != null) results.add(deleted);
        }
      }
    }
    return results;
  }

  // Urgent Jim: Fix - maybe remove recursive call
  List<Element> deleteIfTrue(bool test(Element e), {bool recursive = false}) {
    final deleted = <Element>[];
    for (var e in elements) {
      if (test(e)) {
        delete(e.index);
        deleted.add(e);
      } else
      if (e is SQ) {
        for (var item in e.items) {
          final dList = item.deleteIfTrue(test, recursive: recursive);
          deleted.addAll(dList);
        }
      }
    }
    return deleted;
  }

  List<Element> deleteAllPrivate({bool recursive = false}) {
    final privates = findAllPrivateCodes(recursive: recursive);
    final deleted = deleteCodes(privates);
    if (recursive) {
      // Fix: you cant tell what sequence the element was in.
      for (var sq in sequences) {
        for (var i = 0; i < sq.items.length; i++) {
          final Iterable<int> codes = sq.items.elementAt(i)
              .findAllPrivateCodes();
          final elements = deleteCodes(codes);
          deleted.addAll(elements);
        }
      }
    }
    return deleted;
  }

  /// Deletes all Private Elements in Public Sequences.
  // Urgent: doesn't implement recursion
  List<Element> deleteAllPrivateInPublicSQs({bool recursive = false}) {
    final deleted = <Element>[];
    for (var sq in sequences) {
      for (var item in sq.items) {
        final privates = item.deleteAllPrivate();
        if (privates.isNotEmpty) deleted.addAll(privates);
      }
    }
    return deleted;
  }

  Iterable<Element> deletePrivateGroup(int group, {bool recursive = false}) =>
      deleteIfTrue((e) => e.isPrivate && e.group.isOdd, recursive: recursive);


}
