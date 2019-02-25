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
/// A Information Entity Type.  See PS3.x....
class IEType {
  final int index;
  final String level;

  const IEType(this.index, this.level);

  String get name => level;

  static const IEType kPatient = IEType(0, 'Patient');
  static const IEType kStudy = IEType(1, 'Study');
  static const IEType kSeries = IEType(2, 'Series');
  static const IEType kInstance = IEType(3, 'Instance');

  static const List<IEType> list = [kPatient, kStudy, kSeries, kInstance];

  static const List<IEType> kByIndex = [
    kPatient, kStudy, kSeries, kInstance // No Reformat
  ];

  IEType lookupByIndex(int index) {
    RangeError.checkValueInInterval(index, kPatient.index, kInstance.index);
    return kByIndex[index];
  }

  static const Map<String, IEType> kNameToIEType = {
    'Patient': IEType.kPatient,
    'Study': IEType.kStudy,
    'Series': IEType.kSeries,
    'Instance': IEType.kInstance,
  };

  IEType lookupByName(String s) {
    for (final ie in kByIndex) if (ie.level == s) return ie;
    return null;
  }

  @override
  String toString() => '$runtimeType($level)';
}
