//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

/// The type of an [Address]
enum AddressType {
  /// Home address
  home,

  /// Office address
  office,

  /// Some other address
  other
}

/// An address
class Address {
  AddressType type;
  String street1;
  String street2;
  String country;
  String city;
  String state;
  String postalCode;

  //TODO add address parser and address type
  /// Creates an instance of _this_.
  Address(this.type, this.street1, this.city, this.state, this.postalCode,
          [this.street2 = '', this.country = 'USA']);
}
