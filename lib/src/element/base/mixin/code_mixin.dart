//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

abstract class CodeMixin {
  /// The DICOM Tag Code, which uniquely identifies and Element.
  int get code;

  // **** Implementation
  int get group;

  int get element;

  int get isPublic;

  int get isPrivate;

  bool get isGroupLength => (isValidCode(code)) && (element & 0xFFFF) == 0;

  bool get isPrivateIllegal;

  bool get isPrivateCreator;

  bool get isPrivateData;

  int get subgroup;

  int get base;

  int get limit;



  bool isValidCode(int code);

  // ...

}