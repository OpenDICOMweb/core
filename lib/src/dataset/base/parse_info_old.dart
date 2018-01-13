// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See /[package]/AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/tag/tag_lib.dart';

class ParseInfo {
  // Reader Info
  final bool isEVR;
  final int nElementsRead;
  final int nSequences;
  final int nPrivateElements;
  final int nPrivateSequences;

  // Root Dataset info
  final int nDSElements;
  final int nDSTopLevelElements;
  final int nDSDuplicates;
  final int nDSSequences;
  final int nDSPrivateElements;
  final int nDSPrivateSequences;

  /// The path of the Object that was parsed, if any.
  final String path;

  final bool hadFmi;

  final Uint8List preamble;

  /// if _null_ the preamble was not tested for all zeros. if _true_all
  /// bytes in the preamble were zeros.
  final bool preambleWasZeros;

  /// _true_if the Object has a 128 byte preamble and a 'DICM' prefix.
  final bool hadPrefix;

  final bool hadGroupLengths;

  /// There where errors that occured while parsing the file.
  final bool hadParsingErrors;

  /// The Object had Sequence or Item delimiters that had length fields that were not zero.
  final int nonZeroDelimiterLengths;

  /// The number of Value Fields that had an odd length value.
  final int oddLengthValueFields;
  final TransferSyntax ts;

  final int pixelDataVRIndex;

  final int pixelDataStart;

  final int pixelDataEnd;

  final Element lastElementRead;

  final int lastElementCode;

  final int endOfLastValueRead;

  /// The length of the encoded Dataset in bytes.
  final int dsLengthInBytes;

  /// The length of the file in bytes.
  final int fileLengthInBytes;

  /// The number of bytes below which the Object is considered to be short.
  final int shortFileThreshold;

  /// The file had fewer than [shortFileThreshold] bytes.
  final bool wasShortFile;

  /// There were bytes after the last valid element.
  final bool hadTrailingBytes;

  /// There were zero at the end of the Object that was parsed.
  final bool hadTrailingZeros;

  final List<String> exceptions;

  ParseInfo(
      // Reader info
      this.nElementsRead,
      this.nSequences,
      this.nPrivateElements,
      this.nPrivateSequences,

      // Root Dataset info
      this.nDSElements,
      this.nDSTopLevelElements,
      this.nDSDuplicates,
      this.nDSSequences,
      this.nDSPrivateElements,
      this.nDSPrivateSequences,

      // Other Reader info
      this.path,
      this.preamble,
      this.nonZeroDelimiterLengths,
      this.oddLengthValueFields,
      this.ts,
      this.pixelDataVRIndex,
      this.pixelDataStart,
      this.pixelDataEnd,
      this.lastElementRead,
      this.lastElementCode,
      this.endOfLastValueRead,
      this.dsLengthInBytes,
      this.fileLengthInBytes,
      this.shortFileThreshold,
      this.exceptions,
      {this.isEVR,
	      this.wasShortFile,
      this.hadFmi,
	      this.hadPrefix,
      this.preambleWasZeros,
	      this.hadParsingErrors,
	      this.hadGroupLengths,
	      this.hadTrailingBytes,
	      this.hadTrailingZeros});

  ParseInfo.options(
      // Reader info
      this.nElementsRead,
      this.nSequences,
      this.nPrivateElements,
      this.nPrivateSequences,

      // Root Dataset info
      this.nDSElements,
      this.nDSTopLevelElements,
      this.nDSDuplicates,
      this.nDSSequences,
      this.nDSPrivateElements,
      this.nDSPrivateSequences,
      {this.isEVR,
      this.path = '',
      this.hadFmi = false,
      this.preamble,
      this.preambleWasZeros,
      this.hadPrefix = false,
      this.hadGroupLengths = false,
      this.hadParsingErrors = false,
      this.nonZeroDelimiterLengths = 0,
      this.oddLengthValueFields = 0,
      this.ts,
      this.pixelDataVRIndex,
      this.pixelDataStart,
      this.pixelDataEnd,
      this.lastElementRead,
      this.lastElementCode,
      this.endOfLastValueRead,
      this.dsLengthInBytes,
      this.fileLengthInBytes,
      this.shortFileThreshold,
      this.wasShortFile = false,
      this.hadTrailingBytes = false,
      this.hadTrailingZeros = false,
      this.exceptions});

  @override
  bool operator ==(Object other) => (other is ParseInfo &&
          isEVR == other.isEVR &&
          nElementsRead == other.nElementsRead &&
          nSequences == other.nSequences &&
          nPrivateElements == other.nPrivateElements &&
          nPrivateSequences == other.nPrivateSequences &&
          nDSElements == other.nDSElements &&
          nDSTopLevelElements == other.nDSTopLevelElements &&
          nDSDuplicates == other.nDSDuplicates &&
          nDSPrivateElements == other.nDSPrivateElements &&
          nDSPrivateSequences == other.nDSPrivateSequences &&
          // Path is not included so we can compare results from different files
          //  path == other.path &&
          hadFmi == other.hadFmi &&
          //TODO: preamble must be compared byte for byte
          //     preamble == other.preamble &&
          preambleWasZeros == other.preambleWasZeros &&
          hadPrefix == other.hadPrefix &&
          hadGroupLengths == other.hadGroupLengths &&
          hadParsingErrors == other.hadParsingErrors &&
          nonZeroDelimiterLengths == other.nonZeroDelimiterLengths &&
          oddLengthValueFields == other.oddLengthValueFields &&
          ts == other.ts &&
          pixelDataVRIndex == other.pixelDataVRIndex &&
          pixelDataStart == other.pixelDataStart &&
          pixelDataEnd == other.pixelDataEnd &&
          lastElementRead == other.lastElementRead &&
          lastElementCode == other.lastElementCode &&
          endOfLastValueRead == other.endOfLastValueRead &&
          dsLengthInBytes == other.dsLengthInBytes &&
          fileLengthInBytes == other.fileLengthInBytes &&
          // TODO: decide if these should be included or not
          // shortFileThreshold == other.shortFileThreshold &&
          // hadTrailingBytes == other.hadTrailingBytes &&
          // hadTrailingZeros == other.hadTrailingZeros) &&
          // exceptions == other.exceptions
          wasShortFile == other.wasShortFile)
      ? true
      : false;

  //TODO: implement hashCode if we keep equals
  @override
  int get hashCode => system.hasher(this);

  bool get hadErrors => hadParsingErrors;

  //TODO: this could be (exceptions.length != 0)
  bool get hadWarnings =>
      wasShortFile ||
      !hadFmi ||
      hadParsingErrors ||
      hadTrailingBytes ||
      nonZeroDelimiterLengths != 0;

  //Urgent: add new elements below at **
  /// Returns a [String] containing all values,
  /// except preamble if it was all zeros.
  String get info {
    final preambleMsg = (preambleWasZeros)
        ? ''
        : '\n                  Preamble: '
        '$preamble';
    final tsMsg = (ts == null) ? 'Not present' : '$ts';
    return '''$runtimeType: '$path'
  Reader:
             Elements Read: $nElementsRead
                 Sequences: $nSequences
          Private Elements: $nPrivateElements
         Private Sequences: $nPrivateSequences
  Root Dataset:
               DS Elements: $nDSElements
     DS Top-Level Elements: $nDSTopLevelElements
     DS Duplicate Elements: $nDSDuplicates
              DS Sequences: ** nDSSequences
       DS Private Elements: ** nDSPrivateElements
      DS Private Sequences: ** nDSPrivateSequences
                   Had Fmi: $hadFmi
                Had Prefix: $hadPrefix
        Preamble Was Zeros: $preambleWasZeros$preambleMsg
         Had Group Lengths: $hadGroupLengths
        Had Parsing Errors: $hadParsingErrors
Non-Zero Delimiter Lengths: $nonZeroDelimiterLengths
   Odd Length Value Fields: $oddLengthValueFields
              IsExplicitVR: $isEVR
           Transfer Syntax: $tsMsg
             Pixel Data VR: $pixelDataVRIndex
          Pixel Data Start: $pixelDataStart
            Pixel Data End: $pixelDataEnd
         Last Element Read: $lastElementRead
         Last Element Code: ${Tag.toDcm(lastElementCode)}
       End Of Last Element: $endOfLastValueRead
        DS Length In Bytes: $dsLengthInBytes
      File Length In Bytes: $fileLengthInBytes
      Short File Threshold: $shortFileThreshold
            Was Short File: $wasShortFile
        Had Trailing Bytes: $hadTrailingBytes
        Had Trailing Zeros: $hadTrailingZeros
                Exceptions: ${exceptions.join('\n')}''';
  }

  String get shortFileInfo => (!wasShortFile)
      ? ''
      : '\n'
      '''      Short File Threshold: $shortFileThreshold
            Was Short File: $wasShortFile      
''';

  String get trailingBytes => (!wasShortFile)
      ? ''
      : '\n'
      '''        Had Trailing Bytes: $hadTrailingBytes
        Had Trailing Zeros: $hadTrailingZeros     
  ''';

  // Should only print out values that are important or not normal.
  @override
  String toString() {
    var wasShort = '';
    if (wasShortFile)
      wasShort = 'wasShortFile: $wasShortFile ($fileLengthInBytes) threshold: '
          '$shortFileThreshold\n';
    var preambleMsg = '';
    if (hadPrefix && !preambleWasZeros)
      preambleMsg = '\n'
          '                preambleWasZeros: $preambleWasZeros\n'
          '                        preamble: $preamble';
    final tsMsg = (ts == null) ? 'Not present' : '$ts';
    var parsingErrors = '';
    if (hadParsingErrors)
      parsingErrors = '              Had Parsing Errors: $hadParsingErrors\n';
    var trailingBytes = '';
    if (hadTrailingBytes)
      trailingBytes = '              Had Trailing Bytes: $hadTrailingBytes\n';
    var trailingZeros = '';
    if (hadTrailingZeros)
      trailingZeros = '              Had Trailing Zeros: $hadTrailingZeros\n';
    var nonZeroDelimiters = '';
    if (nonZeroDelimiterLengths > 0)
      nonZeroDelimiters = '  Had Non-Zero Delimiter Lengths: $nonZeroDelimiterLengths\n';
    return '''$runtimeType: '$path'
                    IsExplicitVR: $isEVR
                   Elements read: $nElementsRead
                     DS Elements: $nDSElements
              Top Level Elements: $nDSTopLevelElements
                       Sequences: $nSequences
              Duplicate Elements: $nDSDuplicates       
                Private Elements: $nPrivateElements
               Private Sequences: $nPrivateSequences
                      Had Prefix: $hadPrefix$preambleMsg
                         Had Fmi: $hadFmi
               Had Group Lengths: $hadGroupLengths$parsingErrors$nonZeroDelimiters
         Odd Length Value Fields: $oddLengthValueFields 
                 Transfer Syntax: $tsMsg
                   Pixel Data VR: $pixelDataVRIndex
                Pixel Data Start: $pixelDataStart
                  Pixel Data End: $pixelDataEnd
               Last Element Read: $lastElementRead
               Last Element Code: ${Tag.toDcm(lastElementCode)}
             End of Last Element: $endOfLastValueRead
              DS Length In Bytes: $dsLengthInBytes
            File Length In Bytes: $fileLengthInBytes$wasShort$trailingBytes$trailingZeros
                      Exceptions: ${exceptions.join('\n')}
  ''';
  }

  String get json => '''{
  '@type': '$runtimeType',
  'path': '$path',
  'isEVR': '$isEVR',
    'nElementsRead': $nDSElements,
  'nDSlements': $nDSElements,
    'nDSTopLevelElementCount': $nDSTopLevelElements,
  'nDSDuplicate: $nDSDuplicates,

  'sequenceCount': $nSequences,
  'privateElementCount': $nPrivateElements,
  'privateSequenceCount': $nPrivateSequences,
  'hadFmi': $hadFmi,
  'preamble': $preamble,
  'preambleWasZeros': $preambleWasZeros,
  'hadPrefix': $hadPrefix,
  'hadGroupLengths': $hadGroupLengths,
  'hadParsingErrors': $hadParsingErrors,
  'nonZeroDelimiterLengths': $nonZeroDelimiterLengths,
  'oddLengthValueFields': $oddLengthValueFields,
  'transferSyntax': '${ts.asString}',
  'pixelDataVR': $pixelDataVRIndex,
  'pixelDataStart': $pixelDataStart,
  'pixelDataEnd': $pixelDataEnd,
  'lastElementCode': $lastElementCode,
  'endOfLastElement': $endOfLastValueRead,
  'dsLengthInBytes': $dsLengthInBytes,
  'fileLengthInBytes': $fileLengthInBytes,
  'shortFileThreshold': $shortFileThreshold,
  'wasShortFile': $wasShortFile,
  'HadTrailingBytes': $hadTrailingBytes,
  'HadTrailingZeros': $hadTrailingZeros,
  'Exceptions': $exceptions
  }
  ''';
}
