//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:base/base.dart';
import 'package:core/src/dataset/base.dart';
import 'package:core/src/error.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: only_throw_errors

/// Return the appropriate [Tag] for [ds] and [code].
///
/// If [code] is Public (i.e. even), returns the Public Tag
/// corresponding to [code]. If [code] is a Private Data Code,
/// return the appropriate Private Data Tag, based on the corresponding
//  Private Creator Tag in [ds].
///
/// If [code] is Private Creator code, an Error is thrown.
Tag lookupTagByCode(int code, int vrIndex, Dataset ds) {
  assert(_isNotPCTagCode(code));
  final group = code >> 16;

  if (_isPublicGroup(group)) {
    // Returns the Public Tag corresponding to [code].
    final tag = Tag.lookupPublicByCode(code);
    if (isNormalVRIndex(vrIndex) && vrIndex != kUNIndex) return tag;

    final newVRIndex = _getCorrectVR(vrIndex, tag.vrIndex);
    return PTag.lookupByCode(code, newVRIndex);
  } else if (_isPDCode(code)) {
    return (ds == null)
        ? Tag.lookupByCode(code, vrIndex)
        : _lookupPrivateDataTag(code, vrIndex, ds, group);
  } else if (_isPrivateGroup(group)) {
    return Tag.lookupPrivateByCode(code);
  } else {
    return badTagCode(code);
  }
}

/// Returns a valid Pixel Data [vrIndex].
int getPixelDataVR(int code, int vrIndex, Dataset ds, TransferSyntax ts) {
  if (code != kPixelData) return badTagCode(code, 'Not Pixel Data Tag Code');
  if (vrIndex == kOBIndex || vrIndex == kOWIndex) return vrIndex;
  if (vrIndex != kUNIndex) return badVRIndex(vrIndex, null, -1);

  if (ds != null && (vrIndex == kUNIndex || vrIndex == kOBOWIndex)) {
    final int pixelSize = ds[kBitsAllocated].value;
    return (pixelSize == 16) ? kOWIndex : kOBIndex;
  }
  if (ts != null && ts.isEncapsulated) return kOBIndex;
  return kUNIndex;
}

/// Returns a valid [vrIndex] given the current [vrIndex] and
/// the _tag_.[vrIndex]. If [vrIndex] is not a _normal_ index,
/// returns [kUNIndex]; otherwise, returns the _tag_.[vrIndex].
int getValidVR(int vrIndex, int tagVRIndex) {
  if (vrIndex < 0 || vrIndex > kMaxNormalVRIndex) return kUNIndex;
  return (tagVRIndex > kMaxNormalVRIndex) ? vrIndex : tagVRIndex;
}

Tag _lookupPrivateDataTag(int code, int vrIndex, Dataset ds, int group) {
  // Return the appropriate Private Data Tag, based on the corresponding
  // Private Creator Tag in [ds].
  final elt = code & 0xFFFF;
  final pcCode = (group << 16) + (elt >> 8);
  final creator = ds.pcTags[pcCode];
  return PDTag.make(code, vrIndex, creator);
}

int _getCorrectVR(int vrIndex, int tagVRIndex) =>
    (tagVRIndex > kMaxNormalVRIndex) ? vrIndex : tagVRIndex;

/// Returns a [PCTag] corresponding to [code].
Tag lookupPCTagByCode(Dataset ds, int code, String token, int vrIndex) {
  // Private Creator Element
  var tag = ds.pcTags[code];
  return tag ??= (token.isEmpty)
      ? PCTag.make(code, vrIndex)
      : PCTag.lookupByToken(code, vrIndex, token);
}

bool _isPublicGroup(int group) => group.isEven && group <= 0xFFFE;

bool _isPrivateGroup(int group) =>
    group.isOdd && group >= 0x0009 && group <= 0xFFFF;

// Trick to check that it is both Private and Creator.
bool _isPCCode(int code) {
  final bits = code & 0x1FFFF;
  return bits >= 0x10010 && bits <= 0x100FF;
}

bool _isNotPCTagCode(int code) => !_isPCCode(code);

// Trick to check that it is both Private and Data.
bool _isPDCode(int code) {
  final bits = code & 0x1FFFF;
  return bits >= 0x11000 && bits <= 0x1FF00;
}
