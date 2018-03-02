// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/base.dart';
import 'package:core/src/element.dart';
import 'package:core/src/utils/logger.dart';
import 'package:core/src/tag.dart';

//TODO: needed??
const List<LO> emptyPrivateCreator = const <LO>[];

class PrivateGroup {
  /// The Group number for this group
  final int group;

  /// The Group Length Element for this [PrivateGroup].  This
  /// [Element] is retired and normally is not present.
  Element gLength;

  /// Illegal elements between gggg,0001 - gggg,000F
  List<Element> illegal = [];

  /// A [Map] from sgNumber to [PrivateSubgroup].
  Map<int, PrivateSubgroup> subgroups = <int, PrivateSubgroup>{};

  PrivateGroup(this.group);

  /// Returns the [PrivateSubgroup] that corresponds with.
  PrivateSubgroup operator [](int pdCode) => subgroups[pdCode & 0xFFFF];

  String get info => '$this\n${subgroups.values.join("  \n")}';

  /// Returns _true_ if [code] has a Group number equal to [group].
  bool inGroup(int code) => code >> 16 == group;

  /// Adds a new [PrivateSubgroup] to _this_ [PrivateGroup].
  void _add(PrivateSubgroup sg) {
    final PCTag tag = sg.creator.tag;
    final sgNumber = tag.sgNumber;
    final sg0 = subgroups[sgNumber];
    if (sg0 != null)
      throw new SubgroupAlreadyExistsError(
          'Subgroup $sg0 already exists: new $sg');
    subgroups[sgNumber] = sg;
  }

  String format(Formatter z) =>
      '${z(this)}\n${z.fmt('Subgroups(${subgroups.values.length})',
                               subgroups)}';

  @override
  String toString([String prefix = '']) => '$runtimeType(${hex8(group)}): '
      '${subgroups.length} creators';
}

/// A [PrivateSubgroup] contains a Private [creator] and
/// a [Map<int, Element] of corresponding Private Data Elements.
///
/// _Note_: The [Element] read from an encoded Dataset might
/// have a VR of UN, but will typically be converted to LO
/// Element when created.
class PrivateSubgroup {
  /// The Private Creator for this [PrivateSubgroup].
  ///
  /// _Note_: If no [creator] corresponding to a Private Data Element
  /// is present in the Dataset, the [creator] will be a Missing Private
  /// Creator Element.
  final Element creator;

  /// The subgroup key is the Elt number of the Private Data
  Map<int, Element> pData = {};

  factory PrivateSubgroup(PrivateGroup group, Element creator) {
    final sg = new PrivateSubgroup._(creator);
    group._add(sg);
    return sg;
  }

  factory PrivateSubgroup.noCreator(PrivateGroup group, Element creator) {
    final sg = new PrivateSubgroup._(creator);
    group._add(sg);
    return sg;
  }

  PrivateSubgroup._(this.creator);

  int get group => creator.tag.group;

  /// A integer between 0x10 and 0xFF inclusive. It corresponds to
  /// a Private Creator's Element field, i.e. eeee in (gggg,eeee).
  int get sgNumber {
    final PCTag tag = creator.tag;
    return tag.sgNumber;
  }

  String get info => '$runtimeType(${hex16(sgNumber)}) $creator\n '
      '(${pData.length})$creator.pData';

  void add(Element e) {
    if (Tag.isValidPDCode(e.code, creator.code)) pData[Tag.toElt];
  }

  bool inSubgroup(int pdCode) => Tag.isValidPDCode(pdCode, creator.code);

  /// Returns a Private Data [Element].
  Element lookupData(int pdCode) =>
      (inSubgroup(pdCode)) ? pData[Tag.toElt(pdCode)] : null;

  String format(Formatter z) {
    final sb = new StringBuffer('${z(this)}\n');
    z.down;
    sb.write(z.fmt(creator, pData));
    z.up;
    return sb.toString();
  }

  @override
  String toString() => '$runtimeType($sgNumber): $creator';
}

class SubgroupAlreadyExistsError extends Error {
  String msg;

  SubgroupAlreadyExistsError(this.msg);

  @override
  String toString() => 'SubgroupAlreadyExistsError: $msg';
}
