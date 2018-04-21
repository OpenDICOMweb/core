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
import 'package:core/src/tag.dart';

// ignore_for_file: only_throw_errors

abstract class GroupBase {
  int get gNumber;
  Map<int, dynamic> get members;
  String get info;

  int get length;

  void add(Element e);
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
  void add(Element e) {
    final gNumber = e.group;
    if (gNumber < currentGNumber) {
      invalidElementError(e, '$gNumber > $currentGNumber');
    } else if (gNumber == currentGNumber) {
      currentGroup.add(e);
    } else {
      // new group
      currentGNumber = gNumber;
      GroupBase gp;
      if (gNumber.isEven) {
        currentGroup = new PublicGroup(e);
        gp = publicGroups.putIfAbsent(gNumber, () => currentGroup);
        } else {
        currentGroup = new PrivateGroup(e);
        gp = privateGroups.putIfAbsent(gNumber, () => currentGroup);
      }
      if (gp != currentGroup) invalidGroupError(currentGNumber);
      currentGroup.add(e);
    }
  }

  @override
  String toString() {
    final sb = new StringBuffer();
    publicGroups.forEach((gNum, pGroup) => sb.writeln('$gNum: $pGroup'));
    privateGroups.forEach((gNum, pGroup) => sb.writeln('$gNum: $pGroup'));
    return '$sb';
  }
}
