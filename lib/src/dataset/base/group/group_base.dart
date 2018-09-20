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
import 'package:core/src/dataset/base/group/public_group.dart';
import 'package:core/src/element.dart';
import 'package:core/src/utils.dart';

// ignore_for_file: only_throw_errors, public_member_api_docs

abstract class GroupBase {
  int get gNumber;
  Map<int, Object> get members;
  String get info;

  int get length;

  void add(Element e, Dataset sqParent);
}

class DatasetGroups {
  Dataset ds;
  final Map<int, PrivateGroup> privateGroups = <int, PrivateGroup>{};
  final Map<int, PrivateGroup> publicGroups = <int, PrivateGroup>{};

  DatasetGroups();

  PrivateGroup operator [](int gNumber) => privateGroups[gNumber];

  int currentGNumber = 0;
  GroupBase currentGroup;

  /// Add an [Element] to the [PrivateGroups] for the containing [Dataset].
  void add(Element e, Dataset sqParent) {
    final gNumber = e.group;
    if (gNumber < currentGNumber) {
      badElement('$gNumber > $currentGNumber', e);
    } else if (gNumber == currentGNumber) {
      currentGroup.add(e, sqParent);
    } else {
      // new group
      currentGNumber = gNumber;
      GroupBase gp;
      if (gNumber.isEven) {
        currentGroup = PublicGroup(e, sqParent);
        gp = publicGroups.putIfAbsent(gNumber, () => currentGroup);
      } else {
        currentGroup = PrivateGroup(e);
        gp = privateGroups.putIfAbsent(gNumber, () => currentGroup);
      }
      if (gp != currentGroup) badGroupError(currentGNumber);
      currentGroup.add(e, sqParent);
    }
  }

  @override
  String toString() {
    final sb = StringBuffer();
    publicGroups
        .forEach((gNum, pGroup) => sb.writeln('${hex16(gNum)}: $pGroup'));
    privateGroups
        .forEach((gNum, pGroup) => sb.writeln('${hex16(gNum)}: $pGroup'));
    return '$sb';
  }
}
