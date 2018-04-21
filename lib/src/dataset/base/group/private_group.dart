//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/base.dart';
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/group/group_base.dart';
import 'package:core/src/dataset/base/group/private_subgroup.dart';
import 'package:core/src/element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/logger.dart';

// ignore_for_file: only_throw_errors

class PrivateGroups {
  Dataset ds;
  final _groups = <int, PrivateGroup>{};

  PrivateGroups();

  PrivateGroup operator [](int gNumber) => _groups[gNumber];

  var _currentGNumber = 0;
  PrivateGroup _currentGroup;

  /// Add an [Element] to the [PrivateGroups] for the containing [Dataset].
  Element add(Element e) {
    assert(e.isPrivate);
    final gNumber = e.group;
    assert(gNumber.isOdd);
    if (gNumber == _currentGNumber) {
      return _currentGroup.add(e);
    } else if (gNumber < _currentGNumber) {
      return invalidElementError(e, '$gNumber > $_currentGNumber');
    } else {
      _currentGNumber = gNumber;
      _currentGroup = new PrivateGroup(e);
      final gp = _groups.putIfAbsent(gNumber, () => _currentGroup);
      if (gp != _currentGroup) invalidGroupError(gNumber);
      return _currentGroup.add(e);
    }
  }

  @override
  String toString() {
    final sb = new StringBuffer();
    _groups.forEach((gNum, pGroup) => sb.writeln('$gNum: $pGroup'));
    return '$sb';
  }
}

/// A container for all private [Element]s in a
/// [Dataset] with the same Group number.
///
/// All [Element]s in a [PrivateGroup] have the same Group Number.
/// A [PrivateGroup] is created with the first [Element] encountered with
/// its Group Number in the [Dataset].  There are four possibilities for the
/// _first_ element encountered in a Group:
///     - A Group Length ([GL]) [Element] with a [code] ending in 0x10000
///     - An _illegal_ Private [Element] with the low order 8-bits having
///       a value between 0x01 and 0x0F inclusive.
///     - A Private Creator [Element] with the low order 16-bits having a
///       value between 0x0010 and 0x00FF inclusive.
///     - A Private Data [Element] _without_ a corresponding Private Creator
///       [Element].
class PrivateGroup implements GroupBase {
  /// The Group number of this group. The value must be an odd integer
  /// between 0x0009 and 0xFFFD inclusive.
  // TODO: is 0xFFFD correct
  @override
  final int gNumber;

  /// The Group Length Element for this [PrivateGroup].  This
  /// [Element] is retired and is normally not present.
  final Element gLength;

  /// Illegal elements between gggg,0001 - gggg,000F
  List<Element> illegal = [];

  /// A [Map] from sgNumber to [PrivateSubgroup].
  Map<int, PrivateSubgroup> subgroups = <int, PrivateSubgroup>{};

  PrivateGroup(Element e)
      : gNumber = e.group,
        assert(e.group.isOdd),
        gLength = (e.elt == 0) ? e : null {
    final elt = e.elt;
    (elt > 0 || elt < 0x10) ? illegal.add(e) : add(e);
  }

  /// Returns the [PrivateSubgroup] that corresponds with.
  PrivateSubgroup operator [](int sgNumber) => subgroups[sgNumber];

  @override
  Map<int, PrivateSubgroup> get members => subgroups;

  @override
  int get length => members.length;

  @override
  String get info => '$this\n${subgroups.values.join("  \n")}';

  /// Returns _true_ if [code] has a Group number equal to [gNumber].
  bool inGroup(int code) => (code >> 16) == gNumber;

  var _currentSGNumber = 0;
  PrivateSubgroup _currentSubgroup;

  /// Add a Private Creator or Private Data [Element] to the group.
  ///
  /// If [e] does not have a PCTag or PDTag a new [Element] with a
  /// Private Tag is created, stored in the [PrivateGroup] (Group Length
  /// or Illegal Private Element) or in the [PrivateSubgroup] (Private
  /// Creator or Private Data).
  @override
  Element add(Element e) {
    assert(e.isPrivate);
    final code = e.code;
    final group = code >> 16;
    if (group.isEven) return invalidElementError(e, 'Non Private Element');
    if (group != gNumber)
      return invalidElementError(e, '${hex16(group)} != ${hex16(gNumber)}');

    assert(!Tag.isPrivateGroupLengthCode(code));

    var eNew = e;
    if (Tag.isPDCode(code)) {
      final sgNumber = Tag.pdSubgroup(code);
      _checkSubgroup(sgNumber);
      eNew = _currentSubgroup.addData(e);
    } else if (Tag.isPCCode(code)) {
      final sgNumber = Tag.pcSubgroup(code);
      _checkSubgroup(sgNumber);
      eNew = _currentSubgroup.addCreator(e);
    } else if (Tag.isPrivateIllegalCode(code)) {
      illegal.add(e);
    } else {
      throw '**** Internal Error: $e';
    }
    return eNew;
  }

  void _checkSubgroup(int sgNumber) {
    print('currentSGIndex $_currentSGNumber sgNumber $sgNumber');
    if (sgNumber < _currentSGNumber) {
      invalidSubgroupNumber(_currentSGNumber, sgNumber);
    } else if (sgNumber > _currentSGNumber) {
      _currentSGNumber = sgNumber;
      _currentSubgroup = new PrivateSubgroup(this, sgNumber);
      subgroups[sgNumber] = _currentSubgroup;
    }
  }

/*  String format(Formatter z) =>
      '${z(this)}\n${z.fmt('Subgroups(${subgroups.values.length})',
                               subgroups)}';
 */
  String format(Formatter z) => z.fmt(
      '$runtimeType(${hex16(gNumber)}): ${subgroups.length} Subroups',
      subgroups);

  @override
  String toString([String prefix = '']) =>
      '$runtimeType(${hex16(gNumber)}): ${subgroups.values.length} creators';
}

Null invalidSubgroupNumber(int currentSGNumber, int sgNumber) {
  throw 'Private Subgroup out of order: current($currentSGNumber): $sgNumber';
}
