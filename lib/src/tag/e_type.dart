//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

//TODO: document
/// A DICOM Data Element Type.  See PS3.5, Section 7.4.
class EType {
  final int index;
  final String name;
  final bool isConditional;

  const EType(this.index, this.name, {this.isConditional});

  /// Use this when the EType is not known.
  static const EType kUnknown = const EType(0, '0', isConditional: false);

  static const EType k1 = const EType(1, '1', isConditional: false);
  static const EType k1c = const EType(2, '1C', isConditional: true);
  static const EType k2 = const EType(3, '2', isConditional: false);
  static const EType k2c = const EType(4, '2C', isConditional: true);
  static const EType k3 = const EType(5, '3', isConditional: false);

  static const List<EType> list = const [kUnknown, k1, k1c, k2, k2c, k3];

  static const Map<String, EType> map = const {
    '0': EType.k1,
    '1': EType.k1,
    '1c': EType.k1,
    '2': EType.k1,
    '2c': EType.k1,
    '3': EType.k1,
  };

  EType lookup(int index) {
    if (index < 0 || 5 < index) return null;
    return list[index];
  }

  @override
  String toString() => 'ElementType($name)';
}
