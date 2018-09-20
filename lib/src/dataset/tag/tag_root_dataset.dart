//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/base/group/private_group.dart';
import 'package:core/src/dataset/map_dataset/map_root_dataset.dart';
import 'package:core/src/dataset/tag/tag_dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/utils.dart';

// ignore_for_file: public_member_api_docs

/// A [TagRootDataset].
class TagRootDataset extends MapRootDataset with TagDataset {
  @override
  final PrivateGroups pGroups;

  /// Creates an empty, i.e. without TagElements, [TagRootDataset].
  TagRootDataset(Fmi fmi, Map<int, Element> eMap,
      [String path = '', Bytes bd, int fmiEnd])
      : pGroups = PrivateGroups(),
        super(fmi, eMap, path, bd, fmiEnd) {
    pGroups.ds = this;
  }

  /// Creates an empty [TagRootDataset], i.e. without [Element]s.
  TagRootDataset.empty([String path = '', Bytes bd, int fmiEnd = 0])
      : pGroups = PrivateGroups(),
        super.empty(path, bd ?? Bytes.kEmptyBytes, fmiEnd) {
    pGroups.ds = this;
  }

  // TODO: make this work recursively
  /// Creates a [TagRootDataset] from another [TagRootDataset].
  factory TagRootDataset.from(RootDataset rds) => convert(rds);

  @override
  bool tryAdd(Element e, [Issues issues]) {
    var eNew = e;
    final old = lookup(e.code);
    if (e.group.isOdd && old == null) eNew = pGroups.add(e, this);
    return super.tryAdd(eNew, issues);
  }

  @override
  RootDataset copy([RootDataset rds]) => TagRootDataset.from(rds ?? this);

  static const _makeElement = TagElement.makeFromValues;

  static TagRootDataset convert(RootDataset rds) {
    final tagRds = TagRootDataset.empty();
    for (var e in rds.fmi.elements) {
      final te = _makeElement(e.code, e.vrIndex, e.values, rds);
//      print('Convert FMI: $te');
      tagRds.fmi.add(te);
    }
    return TagDataset.convert(rds, tagRds);
  }
}
