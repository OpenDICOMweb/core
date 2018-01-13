// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

//TODO: document
/// A Information Entity Type.  See PS3.x....
class IEType {
  final int index;
  final String level;

  const IEType(this.index, this.level);

  String get name => level;
  
  static const IEType kPatient = const IEType(0, 'Patient');
  static const IEType kStudy = const IEType(1, 'Study');
  static const IEType kSeries = const IEType(2, 'Series');
  static const IEType kInstance = const IEType(3, 'Instance');

  static const List<IEType> list = const [kPatient, kStudy, kSeries, kInstance];

  static const List<IEType> kByIndex = const [
   kPatient, kStudy, kSeries, kInstance // No Reformat
  ];

  IEType lookupByIndex(int index) {
  	RangeError.checkValueInInterval(index, kPatient.index, kInstance.index);
  	return kByIndex[index];
  }

  static const Map<String, IEType> kNameToIEType = const {
	  'Patient': IEType.kPatient,
	  'Study': IEType.kStudy,
	  'Series': IEType.kSeries,
	  'Instance': IEType.kInstance,
  };

  IEType lookupByName(String s) {
	  for (var ie in kByIndex)
	  	if (ie.level == s) return ie;
	  return null;
  }

  @override
  String toString() => '$runtimeType($level)';
}
