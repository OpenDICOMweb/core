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
import 'package:core/src/element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/indenter.dart';
import 'package:core/src/utils/logger.dart';
import 'package:core/src/vr.dart';

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
      invalidElementError(e, '$gNumber > $_currentGNumber');
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
  PrivateSubgroup operator [](int pdCode) => subgroups[pdCode & 0xFFFF];

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

  ///
  @override
  Element add(Element e) {
    assert(e.isPrivate);
    final tag = e.tag;
    if (tag is PrivateTag) {
      final sgNumber = tag.sgNumber;
      print('currentSGIndex $_currentSGNumber sgNumber $sgNumber');
      if (sgNumber < _currentSGNumber) {
        throw 'Private Subgroup out of order: '
            'current($_currentSGNumber) e($sgNumber): $e';
      } else if (sgNumber > _currentSGNumber) {
        return _getNewSubgroup(sgNumber, e);
      }
      if (tag is PCTag) {
        if (_currentSubgroup.creator != e) throw 'Invalid subgroup creator: $e';
      } else if (tag is PDTag) {
        return _currentSubgroup.add(e);
      } else if (tag is GroupLengthPrivateTag) {
        if (gLength != null)
          throw 'Duplicate Group Length Element: 1st: $gLength 2nd: e';
      } else if (tag is IllegalPrivateTag) {
        illegal.add(e);
      } else {
        throw '**** Internal Error: $e';
      }
    } else {
      print('Non-Private Element: $e');
      return invalidElementError(e);
    }
  }

  Element _getNewSubgroup(int sgNumber, [Element creator]) {
    assert(creator == null || creator.tag is PCTag);
    _currentSGNumber = sgNumber;
    _currentSubgroup = new PrivateSubgroup(this, sgNumber, creator);
    subgroups[sgNumber] = _currentSubgroup;
    // _currentSubgroup.creator = creator;
    return creator;
  }

  bool addCreator(PC pc) {
    final tag = pc.tag;
    var npc = pc;
    if (tag is PCTag) {
      if (tag is PCTagUnknown) {
        final nTag = PCTag.lookupByCode(pc.code, pc.vrIndex, pc.value);
        if (nTag is! PCTagUnknown) npc = new PCtag(nTag, pc.values);
      }
      final sgNumber = tag.sgNumber;
      final sg = new PrivateSubgroup(this, sgNumber, npc);
      subgroups[sgNumber] = sg;
      return true;
    }
    return false;
  }

  bool addNoCreator(Element pd) {
    if (pd.tag is! PDTag) throw 'Invalid Private Data Element: $pd';
    if (pd.tag is PDTag) {
      final PDTag tag = pd.tag;
      final sg = new PrivateSubgroup(this, tag.sgNumber, null);
      subgroups[tag.sgNumber] = sg;
      return true;
    }
    return false;
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

/// A [PrivateSubgroup] contains a Private [creator] and
/// a [Map<int, Element] of corresponding Private Data Elements.
///
/// _Note_: The [Element] read from an encoded Dataset might
/// have a VR of UN, but will typically be converted to LO
/// Element when created.
class PrivateSubgroup {
  final PrivateGroup group;

  /// An integer between 0x10 and 0xFF inclusive. If a PCTag Code is denoted
  /// (gggg,00ii), and a PDTag Code is denoted (gggg,iioo) then the Sub-Group
  /// Index corresponds to ii.
  final int sgNumber;
  /// The Private Creator for this [PrivateSubgroup].
  ///
  /// _Note_: If no [creator] corresponding to a Private Data Element
  /// is present in the Dataset, the [creator] will be a Missing Private
  /// Creator Element.
  final PC creator;

  /// The Private Data [Element]s in this Subgroup.
  final Map<int, Object> members;

  factory PrivateSubgroup(PrivateGroup group, int sgNumber, Element e) {
    final code = e.code;
    assert(Tag.toGroup(code) == group.gNumber);
    if (Tag.isPCCode(code)) {
      assert(Tag.pcSubgroup(code) == sgNumber);
        return new PrivateSubgroup._(group, sgNumber, e);

    } else if (Tag.isPDCode(code)) {
      assert(Tag.pdSubgroup(code) == sgNumber);
      final nTag = new PCTagUnknown(group.gNumber, kLOIndex, '--Phantom--');
      final eNew = TagElement.makeFromTag(nTag, e.values, kLOIndex);
        return new PrivateSubgroup._(group, sgNumber, eNew);

    } else {
      return invalidTagError(e.tag, LO);
    }
  }

  PrivateSubgroup._(this.group, this.sgNumber, this.creator)
      : members = <int, Element>{};

  int get groupNumber => group.gNumber;

  String get info {
    final sb = new Indenter('$runtimeType(${hex16(sgNumber)}): '
        '${members.values.length}')
      ..down;
    members.values.forEach(sb.writeln);
    sb.up;
    return '$sb';
  }

  Element add(Element pd) {
    final tag = pd.tag;
    final cTag = creator.tag;
    if (cTag is PCTagKnown && tag is PDTagUnknown) {
      final pdTag = cTag.definition.dataTags[pd.code];
      if (pdTag != null) {
        final pdNew = TagElement.makeFromTag(pdTag, pd.values, pd.vrIndex);
      }

    }
    final code = pd.code;
    if (Tag.isValidPDCode(code, creator.code)) {

      members[code] = pd;
    } else {
      throw 'Invalid PD Element: $pd';
    }
  }

  /// Returns a Private Data [Element].
  Element lookup(int code) => members[code];

  bool inSubgroup(int pdCode) => Tag.isValidPDCode(pdCode, creator.code);


  @override
  String toString() => '${hex8(sgNumber)} $runtimeType: '
      '$creator Members: ${members.length}';
}

class FormattedPrivateSubgroup {
  final PrivateSubgroup subgroup;

  FormattedPrivateSubgroup.from(this.subgroup);

  String format(Formatter z) {
    final sb = new StringBuffer('${z(subgroup)}\n');
    z.down;
    sb.write(z.fmt(subgroup.creator, subgroup.members));
    z.up;
    return sb.toString();
  }

/*
  String format(Formatter z) => z.fmt(
      '$runtimeType(${hex16(sgNumber)}): ${members.length} Subroups $_creator',
      members);
*/

}

class SubgroupAlreadyExistsError extends Error {
  String msg;

  SubgroupAlreadyExistsError(this.msg);

  @override
  String toString() => 'SubgroupAlreadyExistsError: $msg';
}
