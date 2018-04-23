//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/base.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/profile/de_id/cid_7050.dart';
import 'package:core/src/tag.dart';

// ignore_for_file: type_annotate_public_apis

// TODO: add kEncryptedAttributeDataset
class DeIdentify {
  final TagRootDataset rds;

  DeIdentify(this.rds);

  void addPatientIdentityRemoved(TagRootDataset rds) {}
}

// TODO: Determine the correct codeValue and URL.
const acrDeIdCodeValue = 'ACR OpenDICOMWeb SDK De-Identifier';
const acrDeIdUrn = 'http://dicom.acr.org/odw/deidentifier.html';

void addDeIdMethodCodeSequence(RootDataset rds, DeIdMethod deIdMethod) {
  rds
    ..replace<String>(kPatientIdentityRemoved, const <String>['Yes'])
    ..replace<String>(kDeidentificationMethod, const <String>['Yes']);
  final map = <int, Element>{
    // TODO: create the ability to have const Element
    kCodeValue: new SHtag(PTag.kCodeValue, [acrDeIdCodeValue]),
    kCodingSchemeDesignator:
        new SHtag(PTag.kCodingSchemeDesignator, [deIdMethod.code]),
    kCodeMeaning: new LOtag(PTag.kCodeMeaning, [deIdMethod.meaning]),
    kURNCodeValue: new URtag(PTag.kURNCodeValue, [acrDeIdUrn])
  };

  final sq = new SQtag(rds, PTag.kDeidentificationMethodCodeSequence, <Item>[]);
  final item = new TagItem(rds, sq, map);
  rds.replace(kDeidentificationMethodCodeSequence, [item]);
}

//  final codingVersion = new LOtag(PTag.kCodingSchemeVersion, [ DeIdMethod
//      .kBasicApplicationConfidentialityProfile.meaning]);
