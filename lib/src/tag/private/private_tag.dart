// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/string/hexadecimal.dart';
import 'package:core/src/tag/e_type.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/tag/vm.dart';
import 'package:core/src/vr/vr.dart';

typedef Tag TagMaker(int code, int vrIndex);

abstract class PrivateTag extends Tag {
  @override
  final int code;
  @override
  final int vrIndex;
  @override
  final VM vm;

  const PrivateTag(this.code, [this.vrIndex = kUNIndex, this.vm = VM.k1_n])
      : super();

  PrivateTag._(this.code, [this.vrIndex = kUNIndex, this.vm = VM.k1_n]);

  @override
  bool get isPrivate => true;

  @override
  String get name => 'Illegal Private Tag';

  @override
  int get index => -1;

  /// The Private Subgroup for this Tag.
  // Note: MUST be overridden in all subclasses.
  int get subgroup => (isCreator) ? code & 0xFF : (code & 0xFF00) >> 8;

  @override
  EType get type => EType.k3;

  String get subgroupHex => hex8(subgroup);

  String get asString => toString();

  @override
  String get info => '$runtimeType$dcm $groupHex, "$name", $eltHex '
      '${vrIdByIndex[vrIndex]}, $vm';

  @override
  String toString() => '$runtimeType$dcm subgroup($subgroup)';

/*  static PrivateTag maker(int code, int vrIndex, String name) =>
      new PrivateTag._(code, vr);*/
}

/// Private Group Length Tags have codes that are (gggg,eeee),
/// where gggg is odd, and eeee is zero.  For example (0009,0000).
class PrivateTagGroupLength extends PrivateTag {
  static const int kUnknownIndex = -1;

  PrivateTagGroupLength(int code, int vrIndex) : super(code, vrIndex);

  @override
  int get vrIndex => kULIndex;

  @override
  VM get vm => VM.k1;

  @override
  String get name => 'Private Group Length Tag';
}

/// Private Illegal Tags have have codes that are (gggg,eeee),
/// where gggg is odd, and eeee is between 01 and 09 hexadecimal.
/// For example (0009,0005).
// TODO: Flush at v0.9.0 if not used by then
class PrivateTagIllegal extends PrivateTag {
  static const int kUnknownIndex = -1;

  PrivateTagIllegal(int code, int vrIndex) : super(code, vrIndex);

  @override
  String get name => 'Private Illegal Tag';
}
