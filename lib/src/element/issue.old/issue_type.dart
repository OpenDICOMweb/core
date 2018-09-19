// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'issue_action.dart';

// ignore_for_file: public_member_api_docs

//TODO: verify that all the actions taken in this file are correct.
class IssueType {
  /// A [keyword] that identifies the [IssueType].
  final String keyword;

  /// The [Type] of [IssueType].
  final IssueAction action;

  /// A description of the [IssueType].
  final String description;

  // Creates an new, not yet defined, IssueType.
  IssueType(this.keyword, this.action, [this.description = '']);

  const IssueType._(this.keyword, this.action, [this.description = 'TODO']);

  @override
  String toString() => '$runtimeType($action): $description';

  // **** Public Elements

  // **** Tag Issues

  static const IssueType kUnknownPublicTag = const IssueType._(
      'UnknownPublicTag',
      IssueAction.kAbort,
      'An Unknown DICOM Tag has been encountered (see PS3.6). '
      'This is typically caused '
      'by a programming error, or an out of date DICOM Dictionary');

  static const IssueType kPublicGroupLengthPresent = const IssueType._(
      'PublicGroupLengthPresent',
      IssueAction.kRemoveElement,
      'Group Lenth Elements should no longer be included in DICOM Datasets.');

  // **** Private Elements

  // **** Tag Issues

  static const IssueType kPrivateGroupLengthPresent = const IssueType._(
      'PrivateGroupLengthPresent',
      IssueAction.kRemoveElement,
      'Private Group Lenth Elements should no longer be included '
      'in DICOM Datasets.');

  static const IssueType kIllegalPrivateTagCode = const IssueType._(
      'IllegalPrivateTagCode',
      IssueAction.kAbort,
      'The element has an illegal private tag code in the range '
      '(gggg,0001) - (gggg,000F)');

  static const IssueType kPrivateCreatorWithNoValue = const IssueType._(
      'PrivateCreatorWithNoValue',
      IssueAction.kQuarantine,
      'Private Creator Element without a values');


  static const IssueType kPrivateCreatorWithMoreThanOneValue = const
  IssueType._(
      'PrivateCreatorWithMoreThanOneValue',
      //TODO: could truncate to one value
      IssueAction.kFix,
      'Private Creator Element without a values');

  static const IssueType kUnknownPrivateCreatorTag = const IssueType._(
      'UnknownPublicTag',
      IssueAction.kInfo,
      'An Unknown Tag has been encountered. This is typically caused '
      'by a programming error, or an out of date DICOM Dictionary');

  static const IssueType kPrivateCreatorTagNotKeyword = const IssueType._(
      'PrivateCreatorTagNotKeyword',
      IssueAction.kInfo,
      'Private Creator Tag with Token that is not a keyword. This is NOT an'
      'error, but it is a best practice to have creator tokens be keywords.');

  static const IssueType kPrivateDataWithNoCreator = const IssueType._(
      'PrivateDataWithNoCreator',
      IssueAction.kQuarantine,
      'Private Data Element without a corresponding Private Creator.  '
      'All Private Data Elements MUST have corresponding Private '
      'Creators (see PS3.5).');

  static const IssueType kUnknownPrivateDataTag = const IssueType._(
      'UnknownPrivateDataTag',
      IssueAction.kInfo,
      'An Unknown Tag has been encountered. This is typically caused '
      'by a programming error, or an out of date DICOM Dictionary');



  // ***** Value Representation

  // Value Representation Code
  static const IssueType kInvalidVR = const IssueType._(
      'InvalidVR', IssueAction.kFix, 'Invalid Value Representation (VR)');

  static const IssueType kValueRepresentationIsKnown = const IssueType._(
      'kValueRepresentationIsKnown',
      IssueAction.kAutoFix,
      'Element has VR of UN, when VR is known');

  // ***** Value Multiplicity

  // **** Value Issues

  static const IssueType kInvalidValueFieldLength = const IssueType._(
      'kInvalidValueFieldLength',
      IssueAction.kAbort,
      'Element\'s Value Field Length is not an even number');

  // **** Value Multiplicity

  //TODO: do we need to distinguish between too few and too many values?
  static const IssueType kInvalidNumberOfValues = const IssueType._(
      'InvalidNumberOfValues',
      IssueAction.kFix,
      'The number of values does not correspond to the Value Multiplicity');

  static const IssueType kInvalidNoValues = const IssueType._(
      'InvalidNoValues',
      IssueAction.kQuarantine,
      'Element with no values, when the EType required values to be present');

  // **** Integer Values

  static const IssueType kIntegerNotInRange = const IssueType._(
      'IntegerNotInRange',
      IssueAction.kQuarantine,
      'Integer values out of range');

  // **** String Values

  static const IssueType kInvalidValueLength = const IssueType._(
      'StringInvalidValueLength',
      IssueAction.kQuarantine,
      'Invalid values length');

  static const IssueType kStringInvalidCharacter = const IssueType._(
      'StringInvalidCharacter',
      IssueAction.kQuarantine,
      'Invalid Character in Value');

  static const IssueType kStringInvalidPadChar = const IssueType._(
      'StringInvalidPadChar',
      IssueAction.kAutoFix,
      'Element\'s Value Field ended with an invalid padding byte that should '
      'have been the ASCII space character(0x20)');

  // VR.kCS
  static const IssueType kCodeStringInvalidLowerCase = const IssueType._(
      'CodeStringInvalidLowerCase',
      IssueAction.kAutoFix,
      'Code String (CS) contains illegal lowercase letters');

  // VR.kUI errors

  static const IssueType kUidInvalidRoot = const IssueType._(
      'kInvalidUidRoot',
      IssueAction.kAutoFix,
      'Element\'s Value Field ended with an invalid padding byte of space(0x20)'
      'that should have been the ASCII null character(0x00)');

  static const IssueType kUidInvalidZeroComponent = const IssueType._(
      'kInvalidUidZeroComponent',
      IssueAction.kQuarantine,
      'A Uid component that begins with zero has a length greater than one.');

  static const IssueType kInvalidUidNonZeroComponent = const IssueType._(
      'kUidInvalidNonZeroComponent',
      IssueAction.kQuarantine,
      'A Uid component that begins with a non-zero digit, but has a length '
      'of one.');

  static const IssueType kInvalidUidPadChar = const IssueType._(
      'invalidPaddingChar',
      IssueAction.kAutoFix,
      'Element\'s Value Field ended with an invalid padding byte of space(0x20)'
      'that should have been the ASCII null character(0x00)');

  static const IssueType kUidUnknown =
      const IssueType._('kUidUnknown', IssueAction.kInfo, 'Unknown UID');
}
