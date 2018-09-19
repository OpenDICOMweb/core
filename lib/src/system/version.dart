//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

class Version {
  String name;
  List<String> number;

    Version(this.name, String number)
      : number = number.split('.');

  String get major => number[0];
  String get minor => number[1];
  String get edit => number[2];
}