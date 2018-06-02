//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/dataset/base.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: only_throw_errors
// Urgent: verify that tag.vr is newVRIndex when appropriate

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
    return _lookupPrivateDataTag(code, vrIndex, ds, group);
  } else if (_isPrivateGroup(group)) {
    return Tag.lookupPrivateByCode(code);
  } else {
    return badTagCode(code);
  }
}

Tag _lookupPrivateDataTag(int code, int vrIndex, Dataset ds, int group) {
  // Return the appropriate Private Data Tag, based on the corresponding
  // Private Creator Tag in [ds].
  final elt = code & 0xFFFF;
  final pcCode = (group << 16) + (elt >> 8);
  final creator = ds.pcTags[pcCode];
  return PDTag.make(code, vrIndex, creator);
}

/*
int __getCorrectVR(int vrIndex, Tag tag) {
  var vrIndexNew = vrIndex;
  final tagVRIndex = tag.vrIndex;
  if (tagVRIndex > kVRNormalIndexMax) {
    //TODO: This should be returning something better than UN!
    log.info1('Tag has VR ${vrIdFromIndex(tagVRIndex)} using '
        '${vrIdFromIndex(vrIndex)}');
  } else if (vrIndex == kUNIndex && tagVRIndex != kUNIndex) {
    log.info1('Converting VR from UN to ${vrIdFromIndex(tagVRIndex)}');
    vrIndexNew = tagVRIndex;
  } else if (vrIndex == kUNIndex && tagVRIndex != vrIndex) {
    log.info1('Converting from UN to ${vrIdFromIndex(tagVRIndex)}');
    vrIndexNew = tagVRIndex;
  }
  return vrIndexNew;
}
*/

int _getCorrectVR(int vrIndex, int tagVRIndex) =>
    (tagVRIndex > kVRNormalIndexMax) ? vrIndex : tagVRIndex;

/*
Tag _getCorrectTag(int code, int vrIndex) {
  var tag = Tag.lookupPublicByCode(code, vrIndex);
  if (!_isDefinedVRIndex(tag.vrIndex)) {
    final newVRIndex = _getCorrectVR(vrIndex, tag.vrIndex);
    return PTag.lookupByCode(code, newVRIndex);
  }
  return tag;
}
*/

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
  return (bits >= 0x10010 && bits <= 0x100FF);
}

bool _isNotPCTagCode(int code) => !_isPCCode(code);

// Trick to check that it is both Private and Data.
bool _isPDCode(int code) {
  final bits = code & 0x1FFFF;
  return (bits >= 0x11000 && bits <= 0x1FF00);
}

/*
Tag _getPCtagFromCode(int code, Iterable values, int vrIndex) {
  final String token = values.elementAt(0);
  return PCTag.lookupByToken(code, kLOIndex, token);
}
*/
