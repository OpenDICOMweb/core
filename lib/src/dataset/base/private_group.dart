// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/element/base/private.dart.old';
import 'package:core/src/logger/formatter.dart';
import 'package:core/src/string/hexadecimal.dart';
import 'package:core/src/tag/export.dart';

// Each private creator in the same Private Group
// SHOULD/MUST have a distinct  identifier;
class PrivateGroup {
  /// The Group number for this group
  final int group;

  /// The Group Length Element for this [PrivateGroup].  This
  /// Private [Element] is retired and normally is not present.
  GL gLength;

  /// Illegal elements between gggg,0001 - gggg,000F
  List<Element> illegal = [];

  /// A [Map] from [Elt] to [PrivateSubGroup].
  final Map<int, PrivateSubGroup> subgroups = <int, PrivateSubGroup>{};

  PrivateSubGroup _currentSubGroup;

  PrivateGroup(this.group);

  /// Returns the [PrivateSubGroup] that corresponds with.
  PrivateSubGroup operator [](int pdCode) => subgroups[Elt.fromTag(pdCode)];

  String get info => '$this\n${subgroups.values.join("  \n")}';

  /// Returns _true_ if [code] has a Group number equal to [group].
  bool inGroup(int code) => Group.fromTag(code) == group;

  bool add(Element e) {
    final tag = e.tag;
    if (tag is PCTag) {
      addCreator(e);
      return true;
    } else if (tag is PDTag) {
      if (tag.subGroup == _currentSubGroup.sgIndex) {
        _currentSubGroup.add(e);
        return true;
      } else {
        final sg = new PrivateSubGroup(e);
        subgroups[tag.subGroup] = sg;
        return true;
      }
    }
    return false;
  }

  bool addCreator(Element pc) {
    if (pc.tag is PCTag) {
      final PCTag tag = pc.tag;
      final sg = new PrivateSubGroup(pc);
      subgroups[tag.subGroup] = sg;
      return true;
    }
    return false;
  }

  bool addNoCreator(Element pd) {
    if (pd.tag is PCTag) {
      final PDTag tag = pd.tag;
      final sg = new PrivateSubGroup.noCreator(tag.group, tag.subGroup);
      subgroups[tag.subGroup] = sg;
      return true;
    }
    return false;
  }
/*
  /// Adds a new [PrivateSubGroup] to _this_ [PrivateGroup].
  void _add(PrivateSubGroup sg) {
    final sg0 = subgroups[sg.creator.sgIndex];
    if (sg0 != null)
      throw new SubgroupAlreadyExistsError(
          'Subgroup $sg0 already exists: new $sg');
    subgroups[sg.creator.sgIndex] = sg;
  }
*/

  String format(Formatter z) => '${z(this)}\n'
      '${z.fmt('Subgroups(${subgroups.values.length})', subgroups)}';

  @override
  String toString([String prefix = '']) => '$runtimeType(${hex8(group)}): '
      '${subgroups.length} creators';
}

//TODO: each private creator in the same Private Group SHOULD/MUST
//      have a distinct identifier;
/// Private Creator Element (see PS3.5)
///
/// Unlike other Private Tags, which are MetaElements, [PrivateCreator]
/// extends the LO {Element].  All [PrivateCreator]s must have only
/// 1 value, which is a [PrivateCreator] token [String].
///
/// _Note_: The [PrivateCreator] read from an encoded Dataset might
/// have a VR of UN, but it will be converted to LO Element when created.
class PrivateSubGroup {
  // PrivateSubGroupTag pcTag;
  final PrivateCreator creator;

  /// The Tag (gggg,iiii) Group Number (i.e. gggg).
  final int group;

  /// An integer between 0x10 and 0xFF inclusive. If a PCTag Code is denoted
  /// (gggg,00ii), and a PDTag Code is denoted (gggg,iioo) then the Sub-Group
  /// Index corresponds to ii.
  final int sgIndex;

  final Map<int, Element> members;

  PrivateSubGroup(this.creator)
      : assert(creator is PrivateCreator),
        group = creator.group,
        sgIndex = creator.sgIndex,
        members = <int, Element>{};

  PrivateSubGroup.noCreator(this.group, this.sgIndex)
      : creator = null,
        members = <int, Element>{};

  String get info => '$runtimeType(${hex16(group)}) $creator\n '
      '(${members.length})$members';

  Element lookup(int code) =>
      (code == creator.index) ? creator : members[code];

  bool add(Element pd) {
    if (pd.tag is PDTag) {
      members[pd.code] = pd;
      return true;
    }
    return false;
  }

  bool inSubgroup(int pdCode) =>
      Group.fromTag(pdCode) == group && creator.inSubgroup(Elt.fromTag(pdCode));

  /// Returns a Private Data [Element].
  Element lookupData(int code) => members[code];

  String format(Formatter z) {
    final sb = new StringBuffer('${z(this)}\n');
    z.down;
    sb.write(z.fmt(creator, members));
    z.up;
    return sb.toString();
  }

  @override
  String toString() => '$runtimeType(${creator.sgIndex}): $creator';
}

class SubgroupAlreadyExistsError extends Error {
  String msg;

  SubgroupAlreadyExistsError(this.msg);

  @override
  String toString() => 'SubgroupAlreadyExistsError: $msg';
}
