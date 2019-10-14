//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:base/base.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/profile/de_id/cid_7050.dart';
import 'package:core/src/tag.dart';

// ignore_for_file: type_annotate_public_apis
// ignore_for_file: public_member_api_docs

// TODO: Determine the correct codeValue and URL.
const acrDeIdCodeValue = 'ACR OpenDICOMWeb SDK De-Identifier';
const acrDeIdUrn = 'http://dicom.acr.org/odw/deidentifier.html';

void addDeIdMethodCodeSequence(RootDataset rds, DeIdMethod deIdMethod) {
  rds
    ..replace<String>(kPatientIdentityRemoved, const <String>['Yes'])
    ..replace<String>(kDeidentificationMethod, const <String>['Yes']);
  final map = <int, Element>{
    // TODO: create the ability to have const Element
    kCodeValue: SHtag(PTag.kCodeValue, [acrDeIdCodeValue]),
    kCodingSchemeDesignator:
        SHtag(PTag.kCodingSchemeDesignator, [deIdMethod.code]),
    kCodeMeaning: LOtag(PTag.kCodeMeaning, [deIdMethod.meaning]),
    kURNCodeValue: URtag(PTag.kURNCodeValue, [acrDeIdUrn])
  };

  final sq = SQtag(rds, PTag.kDeidentificationMethodCodeSequence, <Item>[]);
  final item = TagItem(rds, sq, map);
  rds.replace(kDeidentificationMethodCodeSequence, [item]);
}

//  final codingVersion =  LOtag(PTag.kCodingSchemeVersion, [ DeIdMethod
//      .kBasicApplicationConfidentialityProfile.meaning]);
