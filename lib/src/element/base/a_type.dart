//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/tag.dart';

// ignore_for_file: public_member_api_docs

typedef ElementPredicate = bool Function(Dataset ds, Element e,
    [DatasetPredicate dsp]);

typedef DatasetPredicate = bool Function(Dataset ds, Element e);

/// A DICOM Data Element Type.  See PS3.5, Section 7.4.
class AType {
  // The index number of the AType.
  final int index;
  final String name;
  final ElementPredicate predicate;
  final bool isConditional;

  const AType(this.index, this.name, this.predicate, {this.isConditional});

  //TODO: fix a_type
  bool call(Dataset ds, Tag tag, Element e) => throw UnimplementedError();

  /// Use this when the EType is not known.
  static const AType kUnknown = AType(0, '0', null, isConditional: false);

  static const AType k1 = AType(1, '1', _type1, isConditional: false);
  static const AType k1c = AType(2, '1C', _type1c, isConditional: true);
  static const AType k2 = AType(3, '2', _type2, isConditional: false);
  static const AType k2c = AType(4, '2C', _type2c, isConditional: true);
  static const AType k3 = AType(5, '3', _type3, isConditional: false);

  static const List<AType> list = [kUnknown, k1, k1c, k2, k2c, k3];

  static const Map<String, AType> map = {
    '0': AType.k1,
    '1': AType.k1,
    '1c': AType.k1,
    '2': AType.k1,
    '2c': AType.k1,
    '3': AType.k1,
  };

  AType lookup(int index) {
    if (index < 0 || 5 < index) return null;
    return list[index];
  }

  @override
  String toString() => 'ElementType($name)';

  static bool _type3(Dataset ds, Element e, [DatasetPredicate dsp]) => true;

  static bool _type2(Dataset ds, Element e, [DatasetPredicate dsp]) =>
      e != null;

  static bool _type2c(Dataset ds, Element e, [DatasetPredicate dsp]) =>
      e != null && dsp(ds, e);

  static bool _type1(Dataset ds, Element e, [DatasetPredicate dsp]) =>
      e != null && e.values.isNotEmpty;

  static bool _type1c(Dataset ds, Element e, [DatasetPredicate dsp]) =>
      (e != null && e.values.isNotEmpty) && (dsp != null && dsp(ds, e));
}
