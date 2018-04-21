//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/base.dart';
import 'package:core/src/dataset/base/group/private_group.dart';
import 'package:core/src/element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/indenter.dart';
import 'package:core/src/utils/logger.dart';

/// A [PrivateSubgroup] contains a Private [creator] and a set of Private
/// Data Elements contained in the [PrivateSubgroup].
///
/// The first [Element] encountered will be used to create the
/// [PrivateSubgroup]. In the typical case that will be a Private Creator
/// [Element]; however, in some (illegal) cases it will be a Private Data
/// [Element], in which case the [PrivateSubgroup] will have a
/// _Phantom Creator_ with ['.
///
/// _Note_: A Private Creator [Element] read from an encoded Dataset might
/// have a VR of UN, but will typically be converted to an [LO] Element
/// when created. In all cases the Private Creator element will be
/// converted to a [PC] Element.
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

  /// The Private Data [Element]s in this Subgroup.
  final Map<int, Object> members;

  PrivateSubgroup(this.group, this.sgNumber) : members = <int, Element>{};

  int get gNumber => group.gNumber;

  PC get creator => _creator ??= PCtag.makePhantom(gNumber, sgNumber);
  PC _creator;

  /// Returns a Private Data [Element].
  Element lookup(int code) => members[code];

  bool inSubgroup(int pdCode) => Tag.isValidPDCode(pdCode, creator.code);

  PC addCreator(Element pc) {
    var pcNew = pc;
    final pcCode = pc.code;
    assert(Tag.isPCCode(pcCode));
    final sg = Tag.pcSubgroup(pcCode);
    if (sg != sgNumber) print('** Invalid Subgroup: $pc');
    var tag = pc.tag;
    if (pc is! LO) print('Bad VR for Private Creator: $pc');
    if (pcNew is! PC) {
      if (tag is! PCTagUnknown) {
        final String token = pc.value;
        final tagNew = PCTag.lookupByToken(pcCode, pc.vrIndex, token);
        if (tagNew != null) tag = tagNew;
      }
      pcNew = new PCtag(tag, pc.values);
    }
    return _creator = pcNew;
  }

  /// Add a Private Data [Element] to _this_;
  Element addData(Element pd) {
    var pdNew = pd;
    final pdCode = pd.code;
    assert(Tag.isPDCode(pdCode));
    if (!Tag.isValidPDCode(pdCode, creator.code))
      return invalidElementError(
          pd, 'pdCode ${dcm(pdCode)} not valid for Subgroup: $sgNumber');
    final sg = Tag.pdSubgroup(pdCode);
    if (sg != sgNumber) print('** Invalid Subgroup: $pd');
    final tag = pd.tag;
    if (tag is PDTagUnknown) {
      final cTag = creator.tag;
      if (cTag is PCTagKnown) {
        final pdDef = cTag.lookupPDCode(pd.code);
        if (pdDef != null) {
          final pdTag = new PDTagKnown(pdCode, pd.vrIndex, cTag, pdDef);
          pdNew = TagElement.makeFromTag(pdTag, pd.values, pd.vrIndex);
        }
      }
    }

    return members[pdCode] = pdNew;
  }

  String get info {
    final sb = new Indenter('$runtimeType(${hex16(sgNumber)}): '
        '${members.values.length}')
      ..down;
    members.values.forEach(sb.writeln);
    sb.up;
    return '$sb';
  }

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
