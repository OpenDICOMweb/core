// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/dataset/tag/tag_item.dart';
import 'package:core/src/profile/de_id/cid_7050.dart';
import 'package:core/src/dataset/tag/tag_root_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/tag/sequence.dart';
import 'package:core/src/element/tag/string.dart';
import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/p_tag.dart';

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
    ..replace<String>(kPatientIdentityRemoved, const<String>['Yes'])
    ..replace<String>(kDeidentificationMethod, const<String>['Yes']);
  final map = <int, Element>{
    // TODO: create the ability to have const Element
    kCodeValue: new SHtag(PTag.kCodeValue, [acrDeIdCodeValue]),
    kCodingSchemeDesignator:
        new SHtag(PTag.kCodingSchemeDesignator, [deIdMethod.code]),
    kCodeMeaning: new LOtag(PTag.kCodeMeaning, [deIdMethod.meaning]),
    kURNCodeValue: new URtag(PTag.kURNCodeValue, [acrDeIdUrn])
  };

  final item = new TagItem(rds, map);
  final sq = new SQtag(PTag.kDeidentificationMethodCodeSequence, rds, [item]);
  item.sequence = sq;
  rds.replace(kDeidentificationMethodCodeSequence, [item]);
}

//  final codingVersion = new LOtag(PTag.kCodingSchemeVersion, [ DeIdMethod
//      .kBasicApplicationConfidentialityProfile.meaning]);
