// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/string/hexadecimal.dart';
import 'package:core/src/tag/private/pc_tag.dart';
import 'package:core/src/tag/private/pd_tag_definitions.dart';
import 'package:core/src/tag/private/private_tag.dart';
import 'package:core/src/tag/vm.dart';
import 'package:core/src/vr/vr.dart';

abstract class PDTag extends PrivateTag {
  const PDTag._();

  /// The Private Creator Tag ([PCTag]) associated with this
  /// Private Data Tag ([PDTag]).
  PCTag get creator;

  @override
  bool get isPrivateData => true;

  @override
  VM get vm => VM.k1_n;

  @override
  int get subGroup => elt >> 8;
  int get subGroupOffset => elt & 0x00FF;

  static PDTag make(int code, int vrIndex, PCTag creator) {
    if (creator != null) {
      final definition = creator.lookupData(code);
      return (definition != null)
          ? new PDTagKnown(code, vrIndex, creator, definition)
          : new PDTagUnknown(code, vrIndex, creator);
    }
    return new PDTagUnknown(code, vrIndex, PCTagUnknown.kUnknownCreator);
  }
}

class PDTagUnknown extends PDTag {
  @override
  final int code;
  @override
  final int vrIndex;
  @override
  final PCTag creator;
  PDTagUnknown(this.code, this.vrIndex, this.creator) : super._();

  @override
  bool get isKnown => false;

  static PDTagUnknown make(int code, int vrIndex, [PCTag creator]) =>
      new PDTagUnknown(code, vrIndex, creator);
}

class PDTagKnown extends PDTag {
  @override
  final int code;
  @override
  final int vrIndex;
  @override
  final PCTag creator;
  final PDTagDefinition definition;

  const PDTagKnown(this.code, this.vrIndex, this.creator, this.definition)
      : super._();

  @override
  bool get isKnown => true;

  @override
  VM get vm => definition.vm;

  @override
  String get name => (definition == null) ? 'Unknown' : definition.name;

  int get offset => code & 0xFF;

  String get offsetHex => hex8(offset);

  int get expectedVR => definition.vrIndex;

  int get expectedGroup => definition.group;

  int get expectedOffset => definition.offset;

  String get token => definition.token;

  @override
  int get index => definition.index;

  @override
  bool get isValid => creator.isValidDataCode(code);

  @override
  String get info =>
      '$runtimeType$dcm $groupHex, "$token", subgroup($subgroupHex), '
      'offset($offsetHex), ${vrIdByIndex[vrIndex]}, $vm, "$name"';

  @override
  String toString() => '$runtimeType$dcm $name $subGroup($subgroupHex), creator'
      '(${creator.name})';

  static PDTagKnown make(
          int code, int vrIndex, PCTag creator, PDTagDefinition definition) =>
      new PDTagKnown(code, vrIndex, creator, definition);
}
