// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.



abstract class ElementInterface {

  int get index;
  int get code;
  String get keyword;
  String get name;
  String get vrIndex;
  int get minValues;
  int get maxValues;
  int get width;
  int get ieIndex;
  int get eTypeIndex;
}