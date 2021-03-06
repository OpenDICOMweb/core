// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/src/date_time/date.dart';
import 'package:core/src/entity/patient/address.dart';
import 'package:core/src/entity/patient/person_name.dart';
import 'package:core/src/entity/patient/sex.dart';

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

  Error error(String msg) => throw new ArgumentError('Parse Error: $msg');
}
