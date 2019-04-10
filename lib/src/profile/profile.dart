//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert' as cvt;

import 'package:core/src/element/base/element.dart';
import 'package:core/src/profile/global_rule.dart';
import 'package:core/src/profile/rule.dart';
import 'package:core/src/profile/trial.dart';

// ignore_for_file: public_member_api_docs

typedef Updater = Element Function(Element element);

enum ProfileFormat { text, json, xml }

class Profile {
  /// The name of this profile.
  final String name;

  /// A [String] containing the URL where the Profile is stored.
  final Uri url;

  /// A [String] containing the URL of the Trial Server.
  final String trialServer;

  /// A [String] containing the URL of the Quarantine Server.
  final String quarantineUrl;
//  final List<String> lines;
  final GlobalRule globals;
  final Map<String, Object> trialMap;
  final Map<String, String> parameters;
  final List<int> groupsToRetain;
  final List<int> groupsToRemove;
  final List<int> keysToRetain;
  final List<int> keysToRemove;
  final Map<int, Updater> updateMap;
  final Map<String, String> comments;
  final List<Rule> rules;
  final Map<String, String> errors;

  Profile(
      this.name, this.url, this.trialServer, this.quarantineUrl, this.trialMap)
      : globals = GlobalRule(),
        parameters = {},
        groupsToRetain = [],
        groupsToRemove = [],
        keysToRetain = [],
        keysToRemove = [],
        updateMap = {},
        comments = {},
        rules = [],
        errors = {} {
    for (final code in keysToRemove)
      if (keysToRetain.contains(code))
        throw ArgumentError('removeTags cannot contain and tags in'
            ' the keepTags list.');
  }

  //TODO: finish if needed for creating constant profile such as anonymization.
  Profile._(
      this.name,
      this.url,
      this.trialServer,
      this.quarantineUrl,
      this.globals,
      this.trialMap,
      this.parameters,
      this.groupsToRetain,
      this.groupsToRemove,
      this.keysToRetain,
      this.keysToRemove,
      this.updateMap,
      this.comments,
      this.errors,
      this.rules);

  //String get extension => '.dvp';

  Map<String, Object> get map => <String, Object>{
        'name': name,
        'path': url,
        'parameters': parameters,
        //  'global': globalMap,
        'rules': rules,
        'comments': comments,
        'errors': errors
      };

  void addRule(Rule rule) {
    rules.add(rule);
  }

  bool keep(int tag) => keysToRetain.contains(tag);

  String lookup(String key) => parameters[key];

  bool isVariable(String v) => v[0] == '@';

  bool isNotVariable(String v) => !isVariable(v);

  String getVariable(String v) => (isVariable(v)) ? parameters[v] : null;

  void addVariable(String v, String value) {
    //TODO: can a var have a var in its values??
    if (isVariable(v) && (value is String)) parameters[v] = value;
  }

  bool comment(int lineNo, String line) {
    comments['$lineNo'] = '$line';
    return true;
  }

  bool error(int lineNo, String msg) {
    errors['$lineNo'] = '$msg';
    return false;
  }

  String get rulesToJson {
    final rList = <String>[];
    for (final rule in rules) rList.add(rule.json);
    return '[\n${rList.join(',\n')}\n]';
  }

  String get json => '''{
    "@type": "Clinical Study Profile",
    "name": "$name",
    "path": "$url",
    "parameters": ${cvt.json.encode(parameters)},
    "rules": $rulesToJson,
    "comments": ${cvt.json.encode(comments)},
    "errors": ${cvt.json.encode(errors)}
}''';

  String format([ProfileFormat format]) {
    switch (format) {
      case ProfileFormat.json:
        return json;
      case ProfileFormat.text:
        //TODO:
        return 'Text is not yet supported.';
      case ProfileFormat.xml:
        return 'XML is not yet supported.';
      default:
        return json;
    }
  }

  Profile evaluateTrial(Trial trial) =>
      //TODO:
      null;

  @override
  String toString() => 'Profile: $name';

  // ignore: prefer_constructors_over_static_methods
  static Profile parse(String s) {
    final Map map = cvt.json.decode(s);
    return Profile._(
        map['name'],
        map['url'],
        map['trialServer'],
        map['quarantineUrl'],
        map['globals'],
        map['trialMap'],
        map['parameters'],
        map['retainGroups'],
        map['removeGroups'],
        map['retainTags'],
        map['removeTags'],
        map['updateMap'],
        map['comments'],
        map['rules'],
        map['errors']);
  }
}
