//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/tag/vm.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

//TODO: add these to DED and then create a Map from this file.
class DcmDir {
  final String keyword;
  final int code;
  final String name;
  final int vrIndex;
  final VM vm;
  final bool isRetired;

  const DcmDir(this.keyword, this.code, this.name, this.vrIndex, this.vm,
      {this.isRetired});

  static const DcmDir kFileSetID = DcmDir(
      'FileSetID', 0x00041130, 'File-set ID', kCSIndex, VM.k1,
      isRetired: false);

  static const DcmDir kFileSetDescriptorFileID = DcmDir(
      'FileSetDescriptorFileID',
      0x00041130,
      'File-set Descriptor File ID',
      kCSIndex,
      VM.k1_8,
      isRetired: false);

  static const DcmDir kSpecificCharacterSetOfFileSetDescriptorFile = DcmDir(
      'SpecificCharacterSetOfFileSetDescriptorFile',
      0x00041142,
      'Specific Character Set of File Set Descriptor File',
      kCSIndex,
      VM.k1,
      isRetired: false);

  static const DcmDir kOffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity =
      DcmDir(
          'OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity',
          0x00041200,
          'SOffset of the First Directory Record of the Root Directory Entity',
          kULIndex,
          VM.k1,
          isRetired: false);

  static const DcmDir kOffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity =
      DcmDir(
          'OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity',
          0x00041202,
          'Offset of the Last Directory Record of the Root Directory Entity',
          kULIndex,
          VM.k1,
          isRetired: false);

  static const DcmDir kFileSetConsistencyFlag = DcmDir('FileSetConsistencyFlag',
      0x00041212, 'File-set Consistency Flag', kUSIndex, VM.k1,
      isRetired: false);

  static const DcmDir kDirectoryRecordSequence = DcmDir(
      'DirectoryRecordSequence',
      0x00041220,
      'Directory Record Sequence',
      kSQIndex,
      VM.k1,
      isRetired: false);

  static const DcmDir kOffsetOfTheNextDirectoryRecord = DcmDir(
      'OffsetOfTheNextDirectoryRecord',
      0x00041400,
      'Offset of the Next Directory Record',
      kULIndex,
      VM.k1,
      isRetired: false);

  static const DcmDir kRecordInUseFlag = DcmDir(
      'RecordInUseFlag', 0x00041410, 'Record In-use Flag', kUSIndex, VM.k1,
      isRetired: false);

  static const DcmDir kOffsetOfReferencedLowerLevelDirectoryEntity = DcmDir(
      'OffsetOfReferencedLowerLevelDirectoryEntity',
      0x00041420,
      'Offset of Referenced Lower-Level Directory Entity',
      kULIndex,
      VM.k1,
      isRetired: false);

  static const DcmDir kDirectoryRecordType = DcmDir('DirectoryRecordType',
      0x00041430, 'Directory​Record​Type', kCSIndex, VM.k1,
      isRetired: false);

  static const DcmDir kPrivateRecordUID = DcmDir(
      'PrivateRecordUID', 0x0004, 'Private Record UID', kUIIndex, VM.k1,
      isRetired: false);

  static const DcmDir kReferencedFileID = DcmDir(
      'ReferencedFileID', 0x00041500, 'Referenced File ID', kCSIndex, VM.k1_8,
      isRetired: false);

  static const DcmDir kMRDRDirectoryRecordOffset = DcmDir(
      'MRDRDirectoryRecordOffset',
      0x0004,
      'MRDR Directory Record Offset',
      kULIndex,
      VM.k1,
      isRetired: true);

  static const DcmDir kReferencedSOPClassUIDInFile = DcmDir(
      'ReferencedSOPClassUIDInFile',
      0x00041510,
      'Referenced SOP Class UID in File',
      kUIIndex,
      VM.k1,
      isRetired: false);

  static const DcmDir kReferencedSOPInstanceUIDInFile = DcmDir(
      'ReferencedSOPInstanceUIDInFile',
      0x00041511,
      'Referenced SOP Instance UID in File',
      kUIIndex,
      VM.k1,
      isRetired: false);

  static const DcmDir kReferencedTransferSyntaxUIDInFile = DcmDir(
      'ReferencedTransferSyntaxUIDInFile',
      0x00041512,
      'Referenced Transfer Syntax UID in File',
      kUIIndex,
      VM.k1,
      isRetired: false);

  static const DcmDir kReferencedRelatedGeneralSOPClassUIDInFile = DcmDir(
      'ReferencedRelatedGeneralSOPClassUIDInFile',
      0x0004151a,
      'Referenced Related General SOP Class UID in File',
      kUIIndex,
      VM.k1_n,
      isRetired: false);

  static const DcmDir kNumberOfReferences = DcmDir(
      'NumberOfReferences', 0x00041600, 'Number of References', kULIndex, VM.k1,
      isRetired: true);

  static const List<DcmDir> dcmDirTags = <DcmDir>[
    kFileSetID, // (0004,1130)
    kFileSetDescriptorFileID, // (0004,1141)
    kSpecificCharacterSetOfFileSetDescriptorFile, // (0004,1142)
    kOffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity, // (0004,1200)
    kOffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity, // (0004,1202)
    kFileSetConsistencyFlag, // (0004,1212)
    kDirectoryRecordSequence, // (0004,1220)
    kOffsetOfTheNextDirectoryRecord, // (0004,1400)
    kRecordInUseFlag, // (0004,1410)
    kOffsetOfReferencedLowerLevelDirectoryEntity, // (0004,1420)
    kDirectoryRecordType, // (0004,1430)
    kPrivateRecordUID, // (0004,1432)
    kReferencedFileID, // (0004,1500)
    kMRDRDirectoryRecordOffset, // (0004,1504)
    kReferencedSOPClassUIDInFile, // (0004,1510)
    kReferencedSOPInstanceUIDInFile, // (0004,1511)
    kReferencedTransferSyntaxUIDInFile, // (0004,1512)
    kReferencedRelatedGeneralSOPClassUIDInFile, // (0004,151A)
    kNumberOfReferences, // (0004,1600)
  ];
}
