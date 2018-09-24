//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/tag.dart';

// ignore_for_file: public_member_api_docs
// ignore_for_file: avoid_field_initializers_in_const_classes
class ContextGroup {
  final String dcmType = 'ContextGroup';
  final Map<String, String> designators = const {
    'DCM': 'DICOM',
    'SRT': 'SNOMED-RT'
  };

  const ContextGroup();
}

const Type cid7050 = DeIdMethod;

class DeIdMethod extends ContextGroup {
  // final CodingScheme designator = CodingScheme.DCM;

  final String designator = 'DCM7050';
  final String number = '7050';
  final String name = 'De-Identification Method';
  final String code;
  final String meaning;

  const DeIdMethod(this.code, this.meaning);

  //TODO: change next 2 lines when CodingScheme is available.
  // CodingScheme get codingScheme => CodingScheme.DCM;
  String get codingScheme => designator;

  /// Returns a list of valid [int] codes.
  List<int> get codes => map.keys;

  /// Returns _true_ if [code] is a valid [cid7050] code.
  bool isValid(int code) => map.keys.contains(code);

  bool isValidList(List<int> codes) {
    for (var code in codes) if (!isValid(code)) return false;
    return true;
  }

  TagItem item(Dataset parent, SQ sq) {
    final map = {
      kCodeValue: SHtag(PTag.kCodeValue, [code]),
      kCodingSchemeDesignator:
          SHtag(PTag.kCodingSchemeDesignator, [designator]),
      kCodeMeaning: LOtag(PTag.kCodeMeaning, [meaning])
    };
    return TagItem(parent, sq, map);
  }

  @override
  String toString() => 'CID$number($designator) $name';

  static const DeIdMethod kBasicApplicationConfidentialityProfile =
      DeIdMethod('113100', 'Basic Application Confidentiality Profile');
  static const DeIdMethod kCleanPixelDataOption =
      DeIdMethod('113101', 'Clean Pixel Data Option');
  static const DeIdMethod kCleanRecognizableVisualFeaturesOption =
      DeIdMethod('113102', 'Clean Recognizable Visual Features Option');
  static const DeIdMethod kCleanGraphicsOption =
      DeIdMethod('113103', 'Clean Graphics Option');
  static const DeIdMethod kCleanStructuredContentOption =
      DeIdMethod('113104', 'Clean Structured Content Option');
  static const DeIdMethod kCleanDescriptorsOption =
      DeIdMethod('113105', 'Clean Descriptors Option');
  static const DeIdMethod
      kRetainLongitudinalTemporalInformationFullDatesOption = DeIdMethod(
          '113106',
          'Retain Longitudinal Temporal Information Full Dates Option');
  static const DeIdMethod
      kRetainLongitudinalTemporalInformationModifiedDatesOption = DeIdMethod(
          '113107',
          'Retain Longitudinal Temporal Information Modified Dates Option');
  static const DeIdMethod kRetainPatientCharacteristicsOption =
      DeIdMethod('113108', 'Retain Patient Characteristics Option');
  static const DeIdMethod kRetainDeviceIdentityOption =
      DeIdMethod('113109', 'Retain Device Identity Option');
  static const DeIdMethod kRetainUIDsOption =
      DeIdMethod('113110', 'Retain UIDs Option');
  static const DeIdMethod kRetainSafePrivateOption =
      DeIdMethod('113111', 'Retain Safe Private Option');

  static const Map<int, String> map = {
    113100: 'Basic Application Confidentiality Profile',
    113101: 'Clean Pixel Data Option',
    113102: 'Clean Recognizable Visual Features Option',
    113103: 'Clean Graphics Option',
    113104: 'Clean Structured Content Option',
    113105: 'Clean Descriptors Option',
    113106: 'Retain Longitudinal Temporal Information Full Dates Option',
    113107: 'Retain Longitudinal Temporal Information Modified Dates Option',
    113108: 'Retain Patient Characteristics Option',
    113109: 'Retain Device Identity Option',
    113110: 'Retain UIDs Option',
    113111: 'Retain Safe Private Option'
  };
}
