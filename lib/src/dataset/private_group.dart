// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/private.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/logger/formatter.dart';
import 'package:core/src/string/hexadecimal.dart';
import 'package:core/src/tag/tag_lib.dart';


//TODO: needed??
const List<LO> emptyPrivateCreator = const <LO>[];

//TODO: each private creator in the same Private Group MUST have a distinct identifier;
class PrivateGroup {
  /// The Group number for this group
  final int group;

  /// The Group Length Element for this [PrivateGroup].  This
  /// [PrivateElement] is retired and normally is not present.
  Element gLength;

  /// Illegal elements between gggg,0001 - gggg,000F
  List<Element> illegal = [];

  /// A [Map] from [Elt] to [PrivateSubGroup].
  Map<int, PrivateSubGroup> subgroups = <int, PrivateSubGroup>{};

  PrivateGroup(this.group);

  /// Returns the [PrivateSubGroup] that corresponds with.
  PrivateSubGroup operator [](int pdCode) => subgroups[Elt.fromTag(pdCode)];

  // Flush void operator []=(int pcCode, PrivateSubGroup sg) => _add(pcCode,
  // sg);

  String get info =>
    '$this\n${subgroups.values.join("  \n")}';

  /// Returns _true_ if [code] has a Group number equal to [group].
  bool inGroup(int code) => Group.fromTag(code) == group;

  /// Adds a new [PrivateSubGroup] to _this_ [PrivateGroup].
  void _add(PrivateSubGroup sg) {
    final sg0 = subgroups[sg.creator.sgIndex];
    if (sg0 != null)
    	throw new SubgroupAlreadyExistsError('Subgroup $sg0 already exists: new $sg');
    subgroups[sg.creator.sgIndex] = sg;
  }

  String format(Formatter z) =>
     '${z(this)}\n${z.fmt('Subgroups(${subgroups.values.length})', subgroups)}';

  @override
  String toString([String prefix = '']) => '$runtimeType(${hex8(group)}): '
      '${subgroups.length} creators';
}

//TODO: each private creator in the same Private Group MUST
//      have a distinct identifier;
/// Private Creator Element (see PS3.5)
///
/// Unlike other Private Tags, which are MetaElements, [PrivateCreator]
/// extends the LO {Element].  All [PrivateCreator]s must have only
/// 1 value, which is a [PrivateCreator] token [String].
///
//TODO: is this the right thing to do?
/// Note: The [PrivateCreator] read from an encoded Dataset might
/// have a VR of UN, but it will be converted to LO Element when created.
class PrivateSubGroup {
  // PrivateSubGroupTag pcTag;
  final PrivateCreator creator;

  //Flush if not needed.
  /// The subgroup key is the Elt number of the Private Data
  //Map<int, Element> data = {};

  factory PrivateSubGroup(PrivateGroup group, PrivateCreator creator) {
    final sg = new PrivateSubGroup._(creator);
    group._add(sg);
    return sg;
  }

  factory PrivateSubGroup.noCreator(
      PrivateGroup group, PrivateCreator creator) {
    final sg = new PrivateSubGroup._(creator);
    group._add(sg);
    return sg;
  }

  PrivateSubGroup._(this.creator);

  int get group => creator.group;

  /// A integer between 0x10 and 0xFF inclusive. It corresponds to the
  /// [PrivateCreator]s [Elt].
  int get index => creator.sgIndex;

  String get info => '$runtimeType(${hex16(index)}) $creator\n '
      '(${creator.pData.length})$creator.pData';

  //Element lookup(int index) => data[index];

  // void add(Element pd) {
  //   data[pd.code] = pd;
  // }

  bool inSubgroup(int pdCode) =>
      Group.fromTag(pdCode) == group && creator.inSubgroup(Elt.fromTag(pdCode));

  /// Returns a Private Data [Element].
  Element lookupData(int code) => creator.lookupData(code);

  String format(Formatter z) {
    final sb = new StringBuffer('${z(this)}\n');
    z.down;
    sb.write(z.fmt(creator, creator.pData));
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