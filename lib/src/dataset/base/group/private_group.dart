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
  void add(Element e) {
    assert(e.isPrivate);
    final gNumber = e.group;
    assert(gNumber.isOdd);
    if (gNumber == _currentGNumber) {
      _currentGroup.add(e);
    } else if (gNumber < _currentGNumber) {
      invalidElementError(e, '$gNumber > $_currentGNumber');
    } else {
      _currentGNumber = gNumber;
      _currentGroup = new PrivateGroup(e);
      final gp = _groups.putIfAbsent(gNumber, () => _currentGroup);
      if (gp != _currentGroup) invalidGroupError(gNumber);
      _currentGroup.add(e);
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
class PrivateGroup implements GroupBase {
  /// The Group number of this group
  @override
  final int gNumber;

  /// The Group Length Element for this [PrivateGroup].  This
  /// [Element] is retired and normally is not present.
  final Element gLength;

  /// Illegal elements between gggg,0001 - gggg,000F
  List<Element> illegal = [];

  /// A [Map] from sgNumber to [PrivateSubgroup].
  Map<int, PrivateSubgroup> subgroups = <int, PrivateSubgroup>{};

  PrivateGroup(Element e)
      : gNumber = e.group,
        assert(gNumber.isOdd),
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
  void add(Element e) {
    assert(e.isPrivate);
    final tag = e.tag;
    if (tag is PrivateTag) {
      final sgNumber = tag.sgNumber;
      print('currentSGIndex $_currentSGNumber sgNumber $sgNumber');
      if (sgNumber < _currentSGNumber) {
        // privateSubgroupOutOfOrder(_currentSubgroupNumber, sgNumber, e);
        throw 'Private Subgroup out of order: '
            'current($_currentSGNumber) e($sgNumber): $e';
      } else if (sgNumber > _currentSGNumber) {
        _getNewSubgroup(sgNumber, e);
      }
      if (tag is PCTag) {
        if (_currentSubgroup.creator != e) throw 'Invalid subgroup creator: $e';
      } else if (tag is PDTag) {
        _currentSubgroup.addPD(e);
      } else if (tag is GroupLengthPrivateTag) {
        if (gLength != null)
          throw 'Duplicate Group Length Element: 1st: $gLength 2nd: e';
        gLength ?? e;
      } else if (tag is IllegalPrivateTag) {
        illegal.add(e);
      } else {
        throw '**** Internal Error: $e';
      }
    }
//    log.debug('Non-Private Element: $e');
  }

  void _getNewSubgroup(int sgNumber, [Element creator]) {
    assert(creator == null || creator.tag is PCTag);
    _currentSGNumber = sgNumber;
    _currentSubgroup = new PrivateSubgroup(this, sgNumber, creator);
    subgroups[sgNumber] = _currentSubgroup;
    // _currentSubgroup.creator = creator;
  }

  bool addCreator(Element pc) {
    if (pc.tag is PCTag) {
      final PCTag tag = pc.tag;
      final sg = new PrivateSubgroup(this, tag.sgNumber, pc);
      subgroups[tag.sgNumber] = sg;
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

  final Map<int, Object> pData;

  /// The Private Creator for this [PrivateSubgroup].
  ///
  /// _Note_: If no [creator] corresponding to a Private Data Element
  /// is present in the Dataset, the [creator] will be a Missing Private
  /// Creator Element.
//  final Element creator;

  /// The subgroup key is the Elt number of the Private Data
//  Map<int, Element> pData = {};

  factory PrivateSubgroup(PrivateGroup group, int sgNumber, Element _creator) {
    if (_creator.group == group.gNumber &&
        Tag.pcSubgroup(_creator.code) == sgNumber)
      return new PrivateSubgroup._(group, sgNumber, _creator);
    final tag = (_creator == null)
        ? new PCTagUnknown(group.gNumber, kLOIndex, '--Phantom--')
        : _creator.tag;
    return invalidTagError(tag, LO);
  }
/*
  factory PrivateSubgroup(PrivateGroup group, Element creator) {
    final sg = new PrivateSubgroup._(creator);
    group._add(sg);
    return sg;
  }
*/
/*

  factory PrivateSubgroup.noCreator(PrivateGroup group) {
    final sg = new PrivateSubgroup._(creator);
    group._add(sg);
    return sg;
  }
*/

  //PrivateSubgroup._(this.creator);

  PrivateSubgroup._(this.group, this.sgNumber, [this._creator])
      : pData = <int, Element>{};

  Map<int, Object> get members => pData;

  /// The Private Creator for this [PrivateSubgroup].
  ///
  /// _Note_: If no [creator] corresponding to a Private Data Element
  /// is present in the Dataset, the [creator] will be a Missing Private
  /// Creator Element.
  Element get creator => _creator;
  Element _creator;
  set creator(Element e) {
    assert(e.tag is PCTag);
    if (creator != null)
      throw 'Duplicate Subgroup Creator($sgNumber) 1st: $creator 2nd: $e';
    _creator ??= e;
  }

  PCTag get tag => _creator.tag;

  int get groupNumber => group.gNumber;

  // int get group => creator.tag.group;

  /// A integer between 0x10 and 0xFF inclusive. It corresponds to
  /// a Private Creator's Element field, i.e. eeee in (gggg,eeee).
/*
  int get sgNumber {
    final PCTag tag = creator.tag;
    return tag.sgNumber;
  }
*/

  String get info {
    final sb = new Indenter('$runtimeType(${hex16(sgNumber)}): '
        '${pData.values.length}')
      ..down;
    pData.values.forEach(sb.writeln);
    sb.up;
    return '$sb';
  }

/*
  String get info => '$runtimeType(${hex16(sgNumber)}) $creator\n '
      '(${pData.length})$creator.pData';
*/

/*
  void add(Element e) {
    if (Tag.isValidPDCode(e.code, creator.code)) pData[Tag.toElt];
  }
*/

  void addPD(Element pd) {
    final code = pd.code;
    if (Tag.isValidPDCode(code, _creator.code)) {
      pData[code] = pd;
    } else {
      throw 'Invalid PD Element: $pd';
    }
  }

  /// Returns a Private Data [Element].
  Element lookupData(int code) => pData[code];

  bool inSubgroup(int pdCode) => Tag.isValidPDCode(pdCode, creator.code);

/*
  /// Returns a Private Data [Element].
  Element lookupData(int pdCode) =>
      (inSubgroup(pdCode)) ? pData[Tag.toElt(pdCode)] : null;
*/

  String format(Formatter z) {
    final sb = new StringBuffer('${z(this)}\n');
    z.down;
    sb.write(z.fmt(creator, pData));
    z.up;
    return sb.toString();
  }

/*
  String format(Formatter z) => z.fmt(
      '$runtimeType(${hex16(sgNumber)}): ${members.length} Subroups $_creator',
      members);
*/

  @override
  String toString() => '${hex8(sgNumber)} $runtimeType: '
      '$creator Members: ${members.length}';
}

class SubgroupAlreadyExistsError extends Error {
  String msg;

  SubgroupAlreadyExistsError(this.msg);

  @override
  String toString() => 'SubgroupAlreadyExistsError: $msg';
}
