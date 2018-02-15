// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/string/hexadecimal.dart';
import 'package:core/src/tag/e_type.dart';
import 'package:core/src/tag/private/pc_tag.dart';
import 'package:core/src/tag/private/pd_tag.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/tag/vm.dart';
import 'package:core/src/vr/vr.dart';

typedef Tag TagMaker(int code, int vrIndex);

abstract class PrivateTag extends Tag {
  const PrivateTag() : super();

  @override
   int get code;
  @override
  int get vrIndex;

  @override
  VM get vm => VM.k1_n;

/*
  PrivateTag._(this.code, [this.vrIndex = kUNIndex, this.vm = VM.k1_n]);
*/

  @override
  bool get isPrivate => true;

  @override
  String get name;

  @override
  int get index;

  // In Private Data Tag (gggg,ssoo) gggg is group, ss is subGroup,
  // and oo is subGroupOffset.

  /// The Private Subgroup for this Tag.
  int get subGroup;
//  int get subGroup => (isCreator) ? code & 0xFF : (code & 0xFF00) >> 8;


  @override
  EType get type => EType.k3;

  String get subgroupHex => hex8(subGroup);

  String get asString => toString();

  @override
  String get info => '$runtimeType$dcm "$name", $eltHex '
      '${vrIdByIndex[vrIndex]}, $vm';

  @override
  String toString() => '$runtimeType$dcm subgroup($subGroup)';

  /// Returns a new [PrivateTag] based on [code] and [vrIndex].
  /// [obj] can be either a [String] or [PCTag].
 static PrivateTag make(int code, int vrIndex, [Object obj]) {
   if (Tag.isPrivateDataCode(code)) {
     final PCTag creator = obj;
     return PDTag.make(code, vrIndex, creator);
   } else if (Tag.isPrivateCreatorCode(code)) {
     final String creator = obj;
     return PCTag.make(code, vrIndex, creator);
   } else if (Tag.isGroupLengthCode(code)) {
     return new PrivateTagGroupLength(code, vrIndex);
   } else {
     return new PrivateTagIllegal(code, vrIndex);
   }
 }
}

/// Private Group Length Tags have codes that are (gggg,eeee),
/// where gggg is odd, and eeee is zero.  For example (0009,0000).
class PrivateTagGroupLength extends PrivateTag {
  static const int kUnknownIndex = -1;
  @override
  final int code;
  @override
  final int vrIndex;
  @override

  PrivateTagGroupLength(this.code, this.vrIndex) {
    if (vrIndex != kULIndex) invalidVRIndex(vrIndex, null, correctVRIndex);
  }

  int get correctVRIndex => kULIndex;

  @override
  VM get vm => VM.k1;
  @override
  int get subGroup => 0;
  @override
  String get name => 'Private Group Length Tag';
}

/// Private Illegal Tags have have codes that are (gggg,eeee),
/// where gggg is odd, and eeee is between 01 and 09 hexadecimal.
/// For example (0009,0005).
// TODO: Flush at v0.9.0 if not used by then
class PrivateTagIllegal extends PrivateTag {
  static const int kUnknownIndex = -1;
  @override
  final int code;
  @override
  final int vrIndex;

  PrivateTagIllegal(this.code, this.vrIndex);

  @override
  int get subGroup => 1;
  @override
  String get name => 'Illegal Private Tag';
}
