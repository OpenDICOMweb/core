//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset.dart';
import 'package:core/src/element/primitives/dicom_codes.dart';
import 'package:core/src/utils/ascii.dart';
import 'package:core/src/utils/string/hexadecimal.dart';

typedef bool ATypePredicate(Dataset ds, [Object rest]);

//**** DICOM Constants ****

/// The DICOM Prefix 'DICM' as an integer.
const int kDcmPrefix = 0x4d434944;

// Group Length for group 0x0008
const int kMinPublicCode = 0x00080000;
const int kMaxPublicCode = kDataSetTrailingPadding;

/// Mask for Private Element Codes
const int kEltMask = 0xFFFF;

/// Mask for Private Element Codes
const int kPGMask = 0x1FFFF;

// Special Tag Related constants

/// This corresponds to the first 16-bits of kSequenceDelimitationItem,
/// kItem, and kItemDelimitationItem which are the same value.
const int kDelimiterFirst16Bits = 0xFFFE;

/// This corresponds to the last 16-bits of kSequenceDelimitationItem.
const int kSequenceDelimiterLast16Bits = 0xE0DD;

/// This corresponds to the last 16-bits of kItemDelimitationItem.
const int kItemLast16bits = 0xE000;

/// This corresponds to the last 16-bits of kItemDelimitationItem.
const int kItemDelimiterLast16bits = 0xE00D;

// Next 3 values are 2x16bit little Endian values as one 32bitLE value.
// This allows fast access and comparison

// kItem as 2x16Bit LE == 0xfffee000
const int kItem32BitLE = 0xe000fffe;

// [kItemDelimitationItem] as 2x16-bit LE == 0xfffee00d;
const int kItemDelimitationItem32BitLE = 0xe00dfffe; //feff0de0;

// [kSequenceDelimitationItem] as 2x16bit LE == 0xfffee0dd;
const int kSequenceDelimitationItem32BitLE = 0xe0ddfffe;

/// The value appended to odd length UID Value Fields to make them even length.
const int kUidPaddingChar = kNull; // equal to cvt.ascii.kNull;

/// The value appended to odd length [String] Value Fields to make them
/// even length.
const int kStringPaddingChar = kSpace; // Equal to cvt.ascii.kSpace;

/// The value appended to odd length Uint8 Value Fields (OB, UN) to make
/// them even length.
const int kUint8PaddingValue = 0;

const int kMinTag = kAffectedSOPInstanceUID;
const int kMaxTag = kMaxDatasetTag;

const int kMinFmiTag = kFileMetaInformationGroupLength;
const int kMaxFmiTag = kPrivateInformation;

/// File-set ID
const int kMinDcmDirTag = kFileSetID;

/// Number of References
const int kMaxDcmDirTag = kNumberOfReferences;

/// Group Length
const int kMinDatasetTag = kLengthToEnd;

/// Data Set Trailing Padding
const int kMaxDatasetTag = kDataSetTrailingPadding;

/// The maximum length, in bytes, of a "short" (16-bit) Value Field.
///
/// Notes:
///     1. Short Value Fields may not have an Undefined Length
///     2. All Value Fields must contain an even number of bytes.
const int kMaxShortVF = 0x10000;

const int kMax32BitVF = 0xFFFFFFFE;

/// The maximum length, in bytes, of a "long" (32-bit) Value Field.
///
/// Note: the values is `[kUint32Max] - 1` because the maximum value
/// (0xFFFFFFFF) is used to denote a Value Field with Undefined Length.
const int kMaxLongVF = 0xFFFFFFFE;

/// The maximum length of a long Value Field containing 8-bit values.
const int kMax8BitLongVF = kMaxLongVF;

/// The maximum length of a long Value Field containing 16-bit values.
const int kMax16BitLongVF = kMaxLongVF;

/// The maximum length of a long Value Field containing 32-bit values.
const int kMax32BitLongVF = kMaxLongVF - 2;

/// The maximum length of a long Value Field containing 64-bit values.
const int kMax64BitLongVF = kMaxLongVF - 6;

/// This is the value of a DICOM Undefined Length from a 32-bit
/// Value Field Length.
const int kUndefinedLength = 0xFFFFFFFF;

bool hasUndefinedLength(int i) => i == kUndefinedLength;

/// Returns _true_ if [code] is a valid DICOM Code.
bool isValidCode(int code) => code >= kMinPublicCode && code <= kMaxPublicCode;

/// Returns _true_ if [code] is a Group Length.
bool isGroupLengthCode(int code) => isValidCode(code) && (code & kEltMask) == 0;

const int kMinPrivateCode = 0x00090000;
const int kMaxPrivateCode = 0xfffdffff;

bool isPrivateCode(int code) =>
    code.isOdd && code >= kMinPrivateCode && code <= kMaxPrivateCode;

/// Returns a [String] in DICOM Tag Code format, e.g. (gggg,eeee),
/// corresponding to the Tag [code].
String dcm(int code) {
  assert(code >= 0 && code <= 0xFFFFFFFF, 'code: $code');
  return '(${hex16(code >> 16)},${hex16(code & 0xFFFF)})';
}

@deprecated
String toDcm(int code) => dcm(code);
