// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/private_group.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/errors.dart';

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
      : added = new List.from(h.added),
        updated = new List.from(h.updated),
        removed = new List.from(h.removed),
        duplicates = new List.from(h.duplicates),
        requiredNotPresent = new List.from(h.requiredNotPresent),
        notPresent = new List.from(h.notPresent),
        privateGroups = new List.from(h.privateGroups);

  //TODO:
  SQ get modifiedElementsSequence => unimplementedError();

  String get info => '''
	not
	''';
}
