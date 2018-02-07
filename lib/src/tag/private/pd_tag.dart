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

class PDTag extends PrivateTag {
  /// The [PCTag.name]
  final PCTag creator;

  factory PDTag(int code, int vrIndex, [PCTag creator]) {
    if (creator != null) {
      final definition = creator.lookupData(code);
      if (definition != null)
        return new PDTagKnown(code, vrIndex, creator, definition);
      return new PDTagUnknown(code, vrIndex, creator);
    }
    return new PDTagUnknown(code, vrIndex, PCTagUnknown.kUnknownCreator);
  }

  const PDTag._(int code, int vrIndex, this.creator) : super(code, vrIndex);

  @override
  bool get isPrivateData => true;

  @override
  VM get vm => VM.k1_n;

  static PDTag make(int code, int vrIndex, [PCTag creator]) =>
      new PDTag(code, vrIndex, creator);
}

class PDTagUnknown extends PDTag {
  PDTagUnknown(int code, int vrIndex, PCTag creator)
   // Flush   [PCTag creator = PCTagUnknown.kUnknownCreator])
      : super._(code, vrIndex, creator);

  @override
  bool get isKnown => false;

  // TODO: flush if not used
  static PDTagUnknown maker(int code, int vrIndex, [PCTag creator]) =>
      new PDTagUnknown(code, vrIndex, creator);
}

class PDTagKnown extends PDTag {
  final PDTagDefinition definition;

  const PDTagKnown(int code, int vrIndex, PCTag creator, this.definition)
      : super._(code, vrIndex, creator);

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
  String toString() => '$runtimeType$dcm $name $subgroup($subgroupHex), creator'
      '(${creator.name})';

  // TODO: Flush if not used
  static PDTagKnown make(
          int code, int vrIndex, PCTag creator, PDTagDefinition definition) =>
      new PDTagKnown(code, vrIndex, creator, definition);
}
