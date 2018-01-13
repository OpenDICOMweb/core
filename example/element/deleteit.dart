// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';

void main() {
  final ds = new TagRootDataset();
  //Map<int, Element> mappedElem = {};
  Tag tag = PTag.lookupByCode(kStudyDate); // Study Date
  final date = new DAtag(tag, ['19990505']);
  ds[tag.code] = date;
  date..checkValues(['3758'])..checkValues(['25240528']);
  //Urgent Fix: there needs to be a comparison
//  final cpy = date.copy..values;
  print('copied value equals original value:');
  print(date.values.first);
  tag = PTag.lookupByCode(kSeriesDate); // Series Date
  ds[tag.code] = new DAtag(tag, ['19990505']);
  tag = PTag.lookupByCode(kAcquisitionDate); // Acquisition Date
  ds[tag.code] = new DAtag(tag, ['19990505']);
  tag = PTag.lookupByCode(kContentDate); // Image Date
  ds[tag.code] = new DAtag(tag, ['19990505']);

  tag = PTag.lookupByCode(kStudyTime); // Study Time
  final time = new TMtag(tag, ['105234.530000']);
  ds[tag.code] = time;

  tag = PTag.lookupByCode(kSeriesTime); // Series Time
  ds[tag.code] = new TMtag(tag, ['105234.530000']);
  tag = PTag.lookupByCode(kAcquisitionTime); //   Acquisition Time
  ds[tag.code] = new TMtag(tag, ['105234.530000']);
  tag = PTag.lookupByCode(kContentTime); // Image Time
  ds[tag.code] = new TMtag(tag, ['105234.530000']);
  tag = PTag.lookupByCode(kMediaStorageSOPClassUID); // Media Storage SOP Class UID
  ds[tag.code] = new UItag(tag, [kCTImageStorage]);
  tag = PTag.lookupByCode(kMediaStorageSOPInstanceUID); // Media Storage SOP Instance UID
  ds[tag.code] =
      new UItag(tag, ['2.16.840.1.113662.2.1.4519.41582.4105152.419990505.410523251']);
  tag = PTag.lookupByCode(kTransferSyntaxUID); // Transfer Syntax UID
  ds[tag.code] = new UItag(tag, [kExplicitVRLittleEndian]);
  tag = PTag.lookupByCode(kStudyInstanceUID); // Study Instance UID
  ds[tag.code] = new UItag(tag, ['2.16.840.1.113662.2.1.1519.11582.1990505.1105152']);
  print(ds.studyUid);
  print(ds.transferSyntax);
}
