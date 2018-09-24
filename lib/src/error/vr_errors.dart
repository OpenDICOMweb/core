//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error/issues/issues.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: public_member_api_docs
// ignore_for_file: prefer_void_to_null

class InvalidVRError extends Error {
  String message;
  int vrIndex;
  int correctVR;
  Tag tag;

  InvalidVRError(this.message, this.vrIndex, this.correctVR, [this.tag]);

  @override
  String toString() => _msg(tag, vrIndex);

  static String _msg(Tag tag, int vrIndex) {
    final vr = vrIdFromIndex(vrIndex);
    return 'Error: Invalid VR (Value Representation) "$vr" for $tag';
  }
}

String _vrIndexErrorMsg(String type, int bad, int good, [Tag tag]) {
  final sBad = '${vrIdFromIndex(good)}($bad)';
  final sGood = '${vrIdFromIndex(bad)}($good)';
  return _vrErrorMsg(type, sBad, sGood, tag);
}

String _vrCodeErrorMsg(String type, int bad, int good, [Tag tag]) {
  final sBad = '${vrIdFromCode(bad)}(${hex16(bad)})';
  final sGood = '${vrIdFromCode(good)}(${hex16(bad)})';
  return _vrErrorMsg(type, sBad, sGood, tag);
}

String _vrErrorMsg(String type, String bad, String good, [Tag tag]) {
  final t = (tag == null) ? '' : '$tag';
  return 'Error: Invalid $type $bad correct $good $t';
}

Null _doError(int bad, Issues issues, int good, Tag tag, String msg) {
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw InvalidVRError(msg, bad, good, tag);
  return null;
}

Null badVRIndex(int badIndex, Issues issues, int goodIndex, [Tag tag]) {
  final msg = _vrIndexErrorMsg('Index', badIndex, goodIndex, tag);
  return _doError(badIndex, issues, goodIndex, tag, msg);
}

bool invalidVRIndex(int badIndex, Issues issues, int goodIndex, [Tag tag]) {
  badVRIndex(badIndex, issues, goodIndex, tag);
  return false;
}

Null badVRCode(int badCode, Issues issues, int goodCode, [Tag tag]) {
  final msg = _vrCodeErrorMsg('Code', badCode, goodCode, tag);
  return _doError(badCode, issues, goodCode, tag, msg);
}

bool invalidVRCode(int badCode, Issues issues, int goodCode, [Tag tag]) {
  badVRCode(badCode, issues, goodCode, tag);
  return false;
}

