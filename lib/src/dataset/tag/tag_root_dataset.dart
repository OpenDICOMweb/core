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
import 'package:core/src/dataset/tag/tag_item.dart';
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
/*
      : pGroups = new PrivateGroups(),
        //TODO: fill private groups
        super.from(rds) {
    pGroups.ds = this;
  }
*/

  @override
  bool tryAdd(Element e, [Issues issues]) {
    final v = super.tryAdd(e, issues);
    if (e.group.isOdd) {
      print('private: $e');
      pGroups.add(e);
    }
    return v;
  }

  @override
  RootDataset copy([RootDataset rds]) => new TagRootDataset.from(rds ?? this);

  static TagRootDataset convert(RootDataset rds) {
    const makeE = TagElement.makeFromElement;

    final tagRDS = new TagRootDataset.empty();
    for (var e in rds.elements) {
      final te = (e is SQ) ? SQtag.convert(e) : makeE(e);
      tagRDS.add(te);
    }
    return tagRDS;
  }
}
