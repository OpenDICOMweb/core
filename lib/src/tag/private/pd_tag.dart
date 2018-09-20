//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/tag/code.dart';
import 'package:core/src/tag/private/pc_tag.dart';
import 'package:core/src/tag/private/pd_tag_definitions.dart';
import 'package:core/src/tag/private/private_tag.dart';
import 'package:core/src/tag/vm.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

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
  int get sgNumber => elt >> 8;
  int get sgOffset => elt & 0x00FF;
  String get sgOffsetHex => hex8(sgOffset);

  @override
  bool get isValid => isPDCode(code, creator.code);

  static const String phantomName = '--<PhantomCreator>--';

  static PDTag make(int code, int vrIndex, Object creator) {
    //if (creator == null && creator == '') {
    if (creator is PCTag) {
      final definition = creator.lookupPDCode(code);
      return (definition != null)
          ? PDTagKnown(code, vrIndex, creator, definition)
          : PDTagUnknown(code, vrIndex, creator);
    }
    final pcTag = PCTagUnknown(code, kLOIndex, phantomName);
    return PDTagUnknown(code, vrIndex, pcTag);
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

  @override
  String get keyword => 'UnknownPrivateDataTag';
  @override
  String get name => 'Unknown Private Data Tag';

  static PDTagUnknown make(int code, int vrIndex, [PCTag creator]) =>
      PDTagUnknown(code, vrIndex, creator);
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
  String get keyword => (definition == null) ? 'Unknown' : definition.keyword;
  @override
  String get name => (definition == null) ? 'Unknown' : definition.name;

//  int get offset => code & 0xFF;

//  String get offsetHex => hex8(offset);

  int get expectedVR => definition.vrIndex;

  int get expectedGroup => definition.group;

  int get expectedOffset => definition.offset;

  String get token => definition.token;

  @override
  int get index => definition.index;

  @override
  bool get isValid => isPDCode(code, creator.code);

  @override
  String get info =>
      '$runtimeType$dcm $groupHex, "$token", sgNumber($sgNumberHex), '
      'offset($sgOffsetHex), ${vrIdByIndex[vrIndex]}, $vm, "$name"';

  @override
  String toString() => '$runtimeType$dcm $name $sgNumber($sgNumberHex), creator'
      '(${creator.name})';

  static PDTagKnown make(
          int code, int vrIndex, PCTag creator, PDTagDefinition definition) =>
      PDTagKnown(code, vrIndex, creator, definition);
}
