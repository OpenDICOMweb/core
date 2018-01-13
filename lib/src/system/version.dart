// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.



class Version {
  String name;
  List<String> number;

    Version(this.name, String number)
      : number = number.split('.');

  String get major => number[0];
  String get minor => number[1];
  String get edit => number[2];
}