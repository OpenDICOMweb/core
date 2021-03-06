// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/tag/tag_lib.dart';

typedef bool ElementPredicate(Dataset ds, Element e, [DatasetPredicate dsp]);

typedef bool DatasetPredicate<K>(Dataset ds, Element e);

/// A DICOM Data Element Type.  See PS3.5, Section 7.4.
class AType {
  // The index number of the AType.
  final int index;
  final String name;
  final ElementPredicate predicate;
  final bool isConditional;

  const AType(this.index, this.name, this.predicate, {this.isConditional});

  //Urgent Jim: fix a_type
  bool call(Dataset ds, Tag tag, Element e) {
    throw new UnimplementedError();
/*    Element e = ds.lookup(tag.code);
    bool v = tag.predicate(ds, e);
    return (e.is == null) ? v : dsPredicate(ds, e);*/
  }

  /// Use this when the EType is not known.
  static const AType kUnknown = const AType(0, '0', null, isConditional: false);

  static const AType k1 = const AType(1, '1', _type1, isConditional: false);
  static const AType k1c = const AType(2, '1C', _type1c, isConditional: true);
  static const AType k2 = const AType(3, '2', _type2, isConditional: false);
  static const AType k2c = const AType(4, '2C', _type2c, isConditional: true);
  static const AType k3 = const AType(5, '3', _type3, isConditional: false);

  static const List<AType> list = const [kUnknown, k1, k1c, k2, k2c, k3];

  static const Map<String, AType> map = const {
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

  static bool _type2(Dataset ds, Element e, [DatasetPredicate dsp]) => (e != null);

  static bool _type2c(Dataset ds, Element e, [DatasetPredicate dsp]) =>
      (e != null && dsp(ds, e));

  static bool _type1(Dataset ds, Element e, [DatasetPredicate dsp]) =>
      (e != null && e.values.isNotEmpty);

  static bool _type1c(Dataset ds, Element e, [DatasetPredicate dsp]) =>
      ((e != null && e.values.isNotEmpty) && (dsp != null && dsp(ds, e)));
}
/*
class AType {
  final EType eType;
  final ElementPredicate predicate;

  const AType(this.eType, this.predicate);

  bool call(Element e) => predicate(e);

  static type3(Element e)

}

bool type3(Element e) => true;

bool aType2(Element e) {
  if (e == null || e.values == null || !e.hasValidValues) {
    invalidElementError(e);
    return false;
  }
  return true;
}

bool aType1(Element e) {
  if (e == null ||
      e.values == null ||
      e.values.length == 0 ||
      !e.hasValidValues) {
    invalidElementError(e);
    return false;
  }
  return true;
}
*/
