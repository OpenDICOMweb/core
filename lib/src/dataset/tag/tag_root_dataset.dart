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

/// A [TagRootDataset].
class TagRootDataset extends MapRootDataset with TagDataset {
  @override
  final PrivateGroups pGroups;

  /// Creates an empty, i.e. without TagElements, [TagRootDataset].
  TagRootDataset(Fmi fmi, Map<int, Element> eMap,
      [String path = '', Bytes bd, int fmiEnd])
      : pGroups = new PrivateGroups(),
        super(fmi, eMap, path, bd, fmiEnd) {
    pGroups.ds = this;
  }

  /// Creates an empty [TagRootDataset], i.e. without [Element]s.
  TagRootDataset.empty([String path = '', Bytes bd, int fmiEnd = 0])
      : pGroups = new PrivateGroups(),
        super.empty(path, bd ?? Bytes.kEmptyBytes, fmiEnd) {
    pGroups.ds = this;
  }

  // TODO: make this work recursively
  /// Creates a [TagRootDataset] from another [TagRootDataset].
  factory TagRootDataset.from(RootDataset rds) => convert(rds);

  @override
  bool tryAdd(Element e, [Issues issues]) {
    var eNew = e;
    return (e.group.isOdd)
        ? eNew = pGroups.add(e, this)
        : super.tryAdd(eNew, issues);
  }

  @override
  RootDataset copy([RootDataset rds]) => new TagRootDataset.from(rds ?? this);

  static const _makeElement = TagElement.makeFromValues;

  static TagRootDataset convert(RootDataset rds) {
    final tagRds = new TagRootDataset.empty();
    for (var e in rds.fmi.elements)
      tagRds.fmi.add(_makeElement(e.code, e.vrIndex, e.values, rds));
    return TagDataset.convert(null, rds, tagRds);
  }
}
