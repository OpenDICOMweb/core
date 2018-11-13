//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/tag.dart';
import 'package:core/src/element/tag.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/dicom.dart';

// ignore_for_file: type_annotate_public_apis
// ignore_for_file: public_member_api_docs

// TODO: add kEncryptedAttributeDataset
class DeIdentify {
  final TagRootDataset rds;

  DeIdentify(this.rds);

  // Urgent Sharath: Unit test
  void addPatientIdentityRemoved(TagRootDataset rds) {
    const values = ['YES'];
    final e = rds.lookup(kPatientIdentityRemoved);
    (e == null)
        ? rds.add(CStag(PTag.kPatientIdentityRemoved, values))
        : rds.replace(kPatientIdentityRemoved, values);
  }
}
