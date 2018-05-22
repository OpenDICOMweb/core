//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/utils/primitives.dart';

/// A library for handling DICOM File Meta Information Tags.

const List<int> fmiTags = const [
  kFileMetaInformationGroupLength,
  kFileMetaInformationVersion,
  kMediaStorageSOPClassUID,
  kMediaStorageSOPInstanceUID,
  kTransferSyntaxUID,
  kImplementationClassUID,
  kImplementationVersionName,
  kSourceApplicationEntityTitle,
  kSendingApplicationEntityTitle,
  kReceivingApplicationEntityTitle,
  kPrivateInformationCreatorUID,
  kPrivateInformation
];

int fmiTagIndex(int tag) => fmiTags.indexOf(tag);
bool isValidFmiTag(int tag) => fmiTags.contains(tag);

const List<String> fmiKeywords = const [
  'FileMetaInformationGroupLength',
  'FileMetaInformationVersion',
  'MediaStorageSOPClassUID',
  'MediaStorageSOPInstanceUID',
  'TransferSyntaxUID',
  'ImplementationClassUID',
  'ImplementationVersionName',
  'SourceApplicationEntityTitle',
  'SendingApplicationEntityTitle',
  'ReceivingApplicationEntityTitle',
  'PrivateInformationCreatorUID',
  'PrivateInformation'
];

int fmiKeywordIndex(String keyword) => fmiKeywords.indexOf(keyword);
bool isValidFmiKeyword(String keyword) => fmiKeywords.contains(keyword);

const Map<String, int> fmiKeywordToTagMap = const {
  'FileMetaInformationGroupLength': kFileMetaInformationGroupLength,
  'FileMetaInformationVersion': kFileMetaInformationVersion,
  'MediaStorageSOPClassUID': kMediaStorageSOPClassUID,
  'MediaStorageSOPInstanceUID': kMediaStorageSOPInstanceUID,
  'TransferSyntaxUID': kTransferSyntaxUID,
  'ImplementationClassUID': kImplementationClassUID,
  'ImplementationVersionName': kImplementationVersionName,
  'SourceApplicationEntityTitle': kSourceApplicationEntityTitle,
  'SendingApplicationEntityTitle': kSendingApplicationEntityTitle,
  'ReceivingApplicationEntityTitle': kReceivingApplicationEntityTitle,
  'PrivateInformationCreatorUID': kPrivateInformationCreatorUID,
  'PrivateInformation': kPrivateInformation
};

int fmiKeywordToTag(String keyword) => fmiKeywordToTagMap[keyword];

const Map<int, String> fmiTagToKeywordMap = const {
  kFileMetaInformationGroupLength: 'FileMetaInformationGroupLength',
  kFileMetaInformationVersion: 'FileMetaInformationVersion',
  kMediaStorageSOPClassUID: 'MediaStorageSOPClassUID',
  kMediaStorageSOPInstanceUID: 'MediaStorageSOPInstanceUID',
  kTransferSyntaxUID: 'TransferSyntaxUID',
  kImplementationClassUID: 'ImplementationClassUID',
  kImplementationVersionName: 'ImplementationVersionName',
  kSourceApplicationEntityTitle: 'SourceApplicationEntityTitle',
  kSendingApplicationEntityTitle: 'SendingApplicationEntityTitle',
  kReceivingApplicationEntityTitle: 'ReceivingApplicationEntityTitle',
  kPrivateInformationCreatorUID: 'PrivateInformationCreatorUID',
  kPrivateInformation: 'PrivateInformation'
};

String fmiTagToKeyword(int tag) => fmiTagToKeywordMap[tag];
//String fmiTagToName(int tag) => keywordToName(fmiTagToKeywordMap[tag]);
