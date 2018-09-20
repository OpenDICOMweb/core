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
import 'package:core/src/dataset/tag/tag_item.dart';
import 'package:core/src/element.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs


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

  int get length => members.length;

  PCtag get creator => _creator ??= PCtag.makePhantom(gNumber, sgNumber);
  PCtag _creator;

  PCTag get pcTag => _pcTag ??=
      PCTag.lookupByToken(creator.code, creator.vrIndex, creator.value);

  PCTag _pcTag;

  /// Returns a Private Data [Element].
  Element lookup(int code) => members[code];

  bool inSubgroup(int pdCode) => isPDCode(pdCode, creator.code);

  PC addCreator(Element pc) {
    var pcNew = pc;
    final pcCode = pc.code;
    final sg = pcCode & 0xFFFF;
    assert((pcCode >> 16).isOdd);
    assert((sg >= 0x10 && sg <= 0xFF) && sg == sgNumber,
        '** Invalid Subgroup ($sg) Creator: $pc');
    final vrIndex = pc.vrIndex;
    if (vrIndex != kLOIndex) log.debug('Bad VR for Private Creator: $pc');


    if (pc is! PC) {
      var tag = pc.tag;
      if (tag is! PCTagKnown) {
        final String token =
            (pc is ByteElement) ? pc.vfBytes.getUtf8() : pc.value;
        final tagNew = PCTag.lookupByToken(pcCode, vrIndex, token);
        if (tagNew is PCTagKnown) tag = tagNew;
      }
      pcNew = PCtag(tag, pc.values);
    }
    return _creator = pcNew;
  }

  /// Add a Private Data [Element] to _this_;
  Element addData(Element pd, Dataset sqParent) {
    var pdNew = pd;
    final pdCode = pd.code;
    assert(isPDCode(pdCode));
    _isNotValidPDCode(pdCode, pd);

    final tag = pd.tag;
    if (tag is PDTagUnknown) {
      final cTag = creator.tag;
      if (cTag is PCTagKnown) {
        final pdDef = cTag.lookupPDCode(pd.code);
        if (pdDef != null) {
          final pdTag = PDTagKnown(pdCode, pd.vrIndex, cTag, pdDef);
          pdNew = (pd.vrIndex == kSQIndex)
          ? TagElement.makeSequenceFromTag(sqParent, tag, <TagItem>[])
          : TagElement.makeFromTag(pdTag, pd.values, pd.vrIndex);
        }
      }
    }
    return members[pdCode] = pdNew;
  }

  bool _isNotValidPDCode(int pdCode, Element pd) {
    final pdSG = (pdCode & 0xFFFF) >> 8;
    if (pdSG != sgNumber) {
      invalidElement(
          'pdCode ${dcm(pdCode)} invalid Subgroup($pdSG != $sgNumber)', pd);
      return false;
    }
    return true;
  }

  String get info {
    final sb = Indenter('$runtimeType(${hex16(sgNumber)}): '
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
    final sb = StringBuffer('${z(subgroup)}\n');
    z.down;
    sb.write(z.fmt(subgroup.creator, subgroup.members));
    z.up;
    return sb.toString();
  }
}

class SubgroupAlreadyExistsError extends Error {
  String msg;

  SubgroupAlreadyExistsError(this.msg);

  @override
  String toString() => 'SubgroupAlreadyExistsError: $msg';
}
