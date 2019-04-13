//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert' as cvt;

import 'package:core/src/tag/public/p_tag.dart';
import 'package:core/src/tag/tag.dart';

// ignore_for_file: public_member_api_docs

const List<String> ruleNames = [
  '@add',
  '@always',
  '@append',
  '@blank',
  '@contents',
  '@date',
  '@empty',
  '@encrypt',
  '@hash',
  '@hashuid',
  '@hashname',
  '@hashptid',
  '@incrementDate',
  '@initials',
  '@integer',
  '@keep',
  '@lookup',
  '@modifiyDate',
  '@param',
  '@privateattribute',
  '@process',
  '@remove',
  '@require',
  '@round',
  '@time',
  '@truncate'
];

String action = r'remove|keep|empty|skip|default|ignore';
final RegExp actionRE = RegExp(action);

const String condition = r'exists|isblank|equals|contains|matches';
final RegExp conditionRE = RegExp(condition);

const Map<String, int> conditionMap = {
  'exists': 2,
  'isBlank': 2,
  'equals': 3,
  'contains': 3,
  'matches': 3
};

class Rule {
  int index;
  Tag targetTag;
  String keyword;
  String function;
  List<String> args;
  List<String> scripts;
  List suffix;
  bool isParsed;

  Rule(this.index, int code, this.keyword)
      : targetTag = PTag.lookupByCode(code) {
    if ((targetTag == null) ||
        ((keyword != null) && (keyword != targetTag.keyword)))
      throw ArgumentError('Invalid targetTag($code) or keyword($keyword)');
  }

  int get argLength => args.length;

  Tag get sourceTag {
    final val = int.tryParse(args[0]);
    return (val != null) ? PTag.lookupByCode(val) : null;
  }

  bool get isValidArgs {
    final condition = args[1];
    final nArgsRequired = conditionMap[condition];
    if ((nArgsRequired == null) || (nArgsRequired != argLength)) return false;
    return true;
  }

  Map<String, Object> get map => <String, Object>{
        'index': index,
        'target': targetTag,
        'keyword': keyword,
        'function': function,
        'args': args,
        'scripts': scripts,
      };

  String get json => cvt.json.encode(map);

  @override
  String toString() => 'Rule: $function($args) $scripts';
}
