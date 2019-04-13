//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/group/private_group.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/error/general_errors.dart';

// ignore_for_file: public_member_api_docs

/// A history of all changes to a [Dataset].
class History {
  /// A list of elements that were _added_ to the dataset.
  List<Element> added;

  /// A list of elements that were _updated_ in the dataset.
  List<Element> updated;

  /// A list of elements that were _removed_ from the dataset.
  List<Element> removed;

  /// A list of duplicate elements that were either _found_ or
  /// attempted to be stored in the dataset.
  List<Element> duplicates;

  //TODO: when we have IODs
  /// A [List<int>] of Element indices that were required
  /// by the IOD, but not found.
  List<int> requiredNotPresent;

  /// A [List<int>] of elements that were looked up, but not found.
  List<int> notPresent;

  /// A list of [PrivateGroup]s contained in this dataset.
  List<PrivateGroup> privateGroups;

  History()
      : added = <Element>[],
        updated = <Element>[],
        removed = <Element>[],
        duplicates = <Element>[],
        requiredNotPresent = <int>[],
        notPresent = <int>[],
        privateGroups = <PrivateGroup>[];

  History.from(History h)
      : added = List.from(h.added),
        updated = List.from(h.updated),
        removed = List.from(h.removed),
        duplicates = List.from(h.duplicates),
        requiredNotPresent = List.from(h.requiredNotPresent),
        notPresent = List.from(h.notPresent),
        privateGroups = List.from(h.privateGroups);

  //TODO:
  SQ get modifiedElementsSequence => unimplementedError();

  @override
  String toString() => '''
	History:
	               Added: ${added.length}
               Updated: ${updated.length}
               Removed: ${removed.length}
            Duplicates: ${duplicates.length}
    RequiredNotPresent: ${requiredNotPresent.length}
            NotPresent: ${notPresent.length}
         PrivateGroups: ${privateGroups.length}
''';
}
