//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/profile/profile.dart';

// ignore_for_file: public_member_api_docs

class TagGroup {
  final String name;
  final int group;

  const TagGroup(this.name, this.group);

  int get min => group << 16;
  int get max => (group << 16) + 0xFFFF;

  void keep(Profile profile) => profile.groupsToRetain.add(group);

  void remove(Dataset ds) => ds.deletePrivateGroup(group);

  static const TagGroup kGroup18 = TagGroup('Group 18', 0x0018);
  static const TagGroup kGroup20 = TagGroup('Group 20', 0x0020);
  static const TagGroup kGroup28 = TagGroup('Group 28', 0x0028);
  static const TagGroup kGroup50 = TagGroup('Group 50', 0x0050);
  static const TagGroup kGroup60 = TagGroup('Group 60', 0x0060);
  static const TagGroup kCurves = kGroup50;
  static const TagGroup kOverLays = kGroup60;

  static const List<TagGroup> validGroups =
      [kGroup18, kGroup20, kGroup28, kGroup50, kGroup60]; // No reformat

  static const List<TagGroup> defaultKeepGroups =
      [kGroup18, kGroup20, kGroup28];  // No reformat

  static const List<TagGroup> defaultRemoveGroups =
      [kGroup50, kGroup60];  // No reformat
}

class GlobalRule {
  static const List<int> allowedGroupNumbers = <int>[
    0x0018,
    0x0020,
    0x0028,
    0x0050,
    0x0060
  ];
  bool deIdentify = true;
  bool keepSafePrivate = false;
  bool removePrivate = true;
  List<int> options = [];

  List<TagGroup> keepGroups = [];
  List<TagGroup> removeGroups = [];

  GlobalRule();

  bool keep(TagGroup group) {
    if (allowedGroupNumbers.contains(group)) {
      keepGroups.add(group);
      return true;
    } else {
      return false;
    }
  }

  bool remove(TagGroup group) {
    if (allowedGroupNumbers.contains(group)) {
      removeGroups.add(group);
      return true;
    } else {
      return false;
    }
  }
}

const List<String> dataTypes = <String>[
  'char', 'condition', 'date', 'default', 'int', 'param', 'regexp', 'siteId',
  'tag', 'uidroot', 'uint', 'year', 'month', 'day' //no reformat
];
const List<String> vrTypes = [
  'string', 'AS', 'DA', 'LO', 'private', 'SQ', 'TM', 'UI', '??' //no reformat
];

class GlobalRuleType {
  final String name;
  final String vrType;
  final int min;
  final int max;
  final int nScripts;
  final List<String> argTypes;
  final Function argPredicate;

  const GlobalRuleType(
      this.name, this.vrType, this.min, this.max, this.nScripts,
      [this.argTypes, this.argPredicate]);

  bool get hasArgs => min > 0;

  bool get hasScripts => nScripts > 0;

  bool validArgs(List args) => argPredicate(args);

  // Whitespace is allowed but ignored.  'RESET' might be present
  static const GlobalRuleType deIdentificationMethodCodeSeq = GlobalRuleType(
      '@DeIdentificationMethodCodeSeq', 'SQ', 1, 1, 0, ['string']);

  static const GlobalRuleType keepGroup =
      GlobalRuleType('@keepGroup', 'uint', 1, 1, 1);
  static const GlobalRuleType keepGroup18 =
      GlobalRuleType('@keepGroup18', '*', 0, 0, 0);
  static const GlobalRuleType keepGroup20 =
      GlobalRuleType('@keepGroup20', '*', 0, 0, 0);
  static const GlobalRuleType keepGroup28 =
      GlobalRuleType('@keepGroup28', '*', 0, 0, 0);
  static const GlobalRuleType keepGroup50 =
      GlobalRuleType('@keepGroup50', '*', 0, 0, 0);
  static const GlobalRuleType keepGroup60 =
      GlobalRuleType('@keepGroup60', '*', 0, 0, 0);
  static const GlobalRuleType keepCurves = keepGroup50;
  static const GlobalRuleType keepOverLays = keepGroup60;
  static const GlobalRuleType keepSafePrivate = null;

  static const GlobalRuleType keepPrivateGroup =
      GlobalRuleType('@pkeepPrivateGroup', 'private', 1, 1, 0);

  static const GlobalRuleType removeUncheckedElements =
      GlobalRuleType('@removeUncheckedElements', '*', 0, 0, 0);

  static const GlobalRuleType removeGroup =
      GlobalRuleType('@removeGroup', 'uint', 1, 1, 1);
  static const GlobalRuleType removeGroup18 =
      GlobalRuleType('@removeGroup18', '*', 0, 0, 0);
  static const GlobalRuleType removeGroup20 =
      GlobalRuleType('@removeGroup20', '*', 0, 0, 0);
  static const GlobalRuleType removeGroup28 =
      GlobalRuleType('@removeGroup28', '*', 0, 0, 0);
  static const GlobalRuleType removeGroup50 =
      GlobalRuleType('@removeGroup50', '*', 0, 0, 0);
  static const GlobalRuleType removeGroup60 =
      GlobalRuleType('@removeGroup60', '*', 0, 0, 0);
  static const GlobalRuleType removeCurves = removeGroup50;
  static const GlobalRuleType removeOverlays = removeGroup60;

  static const GlobalRuleType removeAllPrivateGroups =
      GlobalRuleType('@removePrivateGroups', '', 0, 0, 0);
  static const GlobalRuleType removePrivateGroup =
      GlobalRuleType('@removePrivateGroup', 'string', 1, 1, 0);

  //TODO: these might work with whole groups
  static const GlobalRuleType ifExists =
      GlobalRuleType('@ifExists', '*', 1, 1, 2, ['tag']);
  static const GlobalRuleType ifBlank =
      GlobalRuleType('@ifBlank', 'string', 1, 1, 2, ['tag']);
  static const GlobalRuleType ifEquals =
      GlobalRuleType('@ifEquals', '*', 2, 2, 2, ['tag', 'string']);
  static const GlobalRuleType ifContains =
      GlobalRuleType('@ifContains', 'string', 2, 2, 2, ['tag', 'string']);
  static const GlobalRuleType ifMatches =
      GlobalRuleType('@ifMatches', '*', 2, 2, 2, ['tag', 'string']);

  bool blankArgPredicate(List args) {
    if (args.isEmpty) return true;
    if (args.length == 1) {
      final val = int.tryParse(args[0]);
      if (val != null) return true;
    }
    return false;
  }

  static const Map<String, GlobalRuleType> globalRuleTypeMap =
      <String, GlobalRuleType>{
    '@deIdentificationMethodCodeSeq': deIdentificationMethodCodeSeq,
    //TODO: Should be keep or remove other groupNumbers
    '@keepGroup': keepGroup,
    '@keepGroup18': keepGroup18,
    '@keepGroup20': keepGroup20,
    '@keepGroup28': keepGroup28,
    '@keepGroup50': keepGroup50,
    '@keepGroup60': keepGroup60,
    '@keepCurves': keepCurves,
    '@keepOverlays': keepOverLays,
    '@keepSafePrivate': keepSafePrivate,

    '@keepPrivateGroup': keepPrivateGroup,

    '@removeGroup': removeGroup,
    '@removeGroup18': removeGroup18,
    '@removeGroup20': removeGroup20,
    '@removeGroup28': removeGroup28,
    '@removeGroup50': removeGroup50,
    '@removeGroup60': removeGroup60,
    '@removeCurves': removeCurves,
    '@removeOverlays': removeOverlays,

    '@removeAllPrivateGroups': removeAllPrivateGroups,
    '@removePrivateGroup': removePrivateGroup,

    //TODO: are this useful globally
    '@ifExists': ifExists,
    '@ifBlank': ifBlank,
    '@ifEquals': ifEquals,
    '@ifContaints': ifContains,
    '@ifMatches': ifMatches,
  };

  static final List<String> names = globalRuleTypeMap.keys;

  static final List<GlobalRuleType> rules = globalRuleTypeMap.values;

  /* TODO: delete after verifying that [names] and [values] work
  static const List<String> ruleNames = const [
    '@deIdentificationMethodCodeSeq',
    '@empty',
    '@encrypt',
    '@hash',
    '@hashuid',
    '@hashname',
    '@hashptid',
    '@hashPtId',
    '@if',
    '@incrementDate',
    '@initials',
    '@integer',
    '@keep',
    '@keepGroup18',
    '@keepGroup20',
    '@keepGroup28',
    '@keepGroup50',
    '@keepGroup60',
    '@keepCurves',
    '@keepOverlays',
    '@keepSafePrivate',
    '@lookup',
    '@modifiyDate',
    '@param',
    '@privateattribute',
    '@privateElement',
    '@process',
    '@ptidlookup',
    '@remove',
    '@removePrivateGroup',
    '@removeGroup18',
    '@removeGroup20',
    '@removeGroup28',
    '@removeGroup50',
    '@removeGroup60',
    '@removeCurves',
    '@removeOverlays',
    '@require',
    '@round',
    '@select',
    '@skip',
    '@time',
    '@truncate'
        '@ifExists',
    '@ifBlank',
    '@ifEquals',
    '@ifContaints',
    '@ifMatches'
  ];
*/
}
