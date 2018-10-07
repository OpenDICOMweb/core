//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/global.dart';

// ignore_for_file: only_throw_errors
// ignore_for_file: public_member_api_docs

/// The [Sex}, one of [male], [female], or [other].
class Sex {
  /// A unique identifier for this member.
  final int type;

  /// The [name] for this [type].
  final String name;

  /// A Constant constructor.
  const Sex._(this.type, this.name);

  /// Returns _true_ is _this_ is a male, false otherwise..
  bool get isMale => type == maleType;

  /// Returns _true_ is _this_ is a female, false otherwise.
  bool get isFemale => !isMale;

  /// Returns an [abbreviation] for the [Sex].
  String get abbreviation {
    switch (type) {
      case maleType:
        return 'M';
      case femaleType:
        return 'F';
      case otherType:
        return 'O';
    }
    return throw 'Invalid id = $type';
  }

  /// A [String] corresponding to the [Sex].
  @override
  String toString() => '$name';

  static const int femaleType = 0;
  static const int maleType = 1;
  static const int otherType = 2;

  /// A female
  static const Sex female = Sex._(femaleType, 'Female');

  /// A male
  static const Sex male = Sex._(maleType, 'Male');

  /// Other than male or female
  static const Sex other = Sex._(otherType, 'Other');

  static Sex parse(String s) {
    if (s == null || s.isEmpty) return null;
    switch (s) {
      case 'M':
        return Sex.male;
      case 'F':
        return Sex.female;
      case 'O':
        return Sex.other;
      default:
        log.warn('Invalid Sex: "$s"');
        if (throwOnError) throw 'Invalid Sex($s)';
        return null;
    }
  }
}
