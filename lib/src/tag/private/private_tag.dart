//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/error/tag_errors.dart';
import 'package:core/src/tag/e_type.dart';
import 'package:core/src/tag/private/pc_tag.dart';
import 'package:core/src/tag/private/pd_tag.dart';
import 'package:core/src/tag/code.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/tag/vm.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/vr.dart';

typedef Tag TagMaker(int code, int vrIndex);

abstract class PrivateTag extends Tag {
  const PrivateTag() : super();

  @override
  bool get isPrivate => true;
  @override
  bool get isPublic => false;

  // Only Private Tags have Subgroup Numbers.
  int get sgNumber;

  String get sgNumberHex => hex8(sgNumber);

  // The default VM if n=unknown
  @override
  VM get vm => VM.k1_n;

  @override
  String get name;

  @override
  int get index;

  @override
  EType get type => EType.k3;

  String get asString => toString();

  @override
  String get info => '$runtimeType$dcm "$name", $eltHex '
      '${vrIdByIndex[vrIndex]}, $vm';

  @override
  String toString() => '$runtimeType$dcm subgroup($sgNumber)';

  // TODO: compare to tag_utils/lookupTagByCode
  /// Returns a new [PrivateTag] based on [code] and [vrIndex].
  /// [obj] can be either a [String] or [PCTag].
  static PrivateTag make(int code, int vrIndex, [Object obj]) {
    if (isPublicCode(code)) return null;
    if (isPDCode(code)) {
      final PCTag creator = obj;
      return PDTag.make(code, vrIndex, creator);
    } else
    if (isPCCode(code)) {
      final String creator = obj;
      return PCTag.make(code, vrIndex, creator);
    } else
    if (isPrivateGroupLengthCode(code)) {
      return new PrivateGroupLengthTag(code, vrIndex);
    } else {
      return new IllegalPrivateTag(code, vrIndex);
    }
  }
}

/// Private Group Length Tags have codes that are (gggg,eeee),
/// where gggg is odd, and eeee is zero.  For example (0009,0000).
class PrivateGroupLengthTag extends PrivateTag {
  static const int kUnknownIndex = -1;
  @override
  final int code;
  final int actualVRIndex;

  @override
  PrivateGroupLengthTag(this.code, this.actualVRIndex) {
    if (!isPrivateGroupLengthCode(code)) badTagCode(code);
    if (vrIndex != kULIndex && vrIndex != kUNIndex) VR.badIndex(
        vrIndex, null, correctVRIndex);
  }

  @override
  int get vrIndex => kULIndex;

  @override
  String get keyword => 'PrivateGroupLengthTag';

  @override
  String get name => 'Private Group Length Tag';

  int get correctVRIndex => kULIndex;

  @override
  VM get vm => VM.k1;
  @override
  int get sgNumber => 0;
}

/// Private Illegal Tags have have codes that are (gggg,eeee),
/// where gggg is odd, and eeee is between 01 and 09 hexadecimal.
/// For example (0009,0005).
// TODO: Flush at v0.9.0 if not used by then
class IllegalPrivateTag extends PrivateTag {
  static const int kUnknownIndex = -1;
  @override
  final int code;
  @override
  final int vrIndex;

  IllegalPrivateTag(this.code, this.vrIndex);

  @override
  String get keyword => 'IllegalPrivateTag';
  @override
  String get name => 'Illegal Private Tag';

  @override
  int get sgNumber => code & 0xFF;
}
