//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/values/date_time.dart';
import 'package:core/src/values/person/address.dart';
import 'package:core/src/values/person/person_name.dart';
import 'package:core/src/values/person/sex.dart';

/// A class representing a [Person].
class Person {
  /// The name ([PersonName]) of _this_ [Person].
  final PersonName name;

  /// Their date of birth.
  final Date dateOfBirth;

  /// Their sex.
  final Sex sex;

  /// Their address
  final List<Address> address;

  //TODO need to add validators for the fields,
  // e.g. DOB should not be in future and should not be more than 110 years ago.
  /// Creates a new instance of [Person].
  Person(this.name, this.dateOfBirth, this.sex, this.address);

  /// A [String] identifying the [Person].
  @override
  String toString() => 'Person: $name, DOB: $dateOfBirth';

  /// Throws an argument error.
  Error error(String msg) => throw ArgumentError('Parse Error: $msg');
}
