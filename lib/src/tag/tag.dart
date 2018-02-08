// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/string/ascii.dart';
import 'package:core/src/string/hexadecimal.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/e_type.dart';
import 'package:core/src/tag/elt.dart';
import 'package:core/src/tag/errors.dart';
import 'package:core/src/tag/group.dart';
import 'package:core/src/tag/ie_type.dart';
import 'package:core/src/tag/p_tag.dart';
import 'package:core/src/tag/p_tag_keywords.dart';
import 'package:core/src/tag/private/pc_tag.dart';
import 'package:core/src/tag/private/pd_tag.dart';
import 'package:core/src/tag/private/private_tag.dart';
import 'package:core/src/tag/vm.dart';
import 'package:core/src/vr/vr.dart';

const int kGroupMask = 0xFFFF0000;
const int kElementMask = 0x0000FFFF;

/// A Element Type predicate. Returns _true_  if the Element
/// corresponding to [key] in the [Dataset] satisfies the
/// requirements for the SopClass of the [Dataset].
typedef bool _ETypePredicate<K>(Dataset ds, K key);

/// //Fix:
/// A [Tag] defines the [Type] of a DICOM Attribute.  There are different
/// types of Tags in the following class hierarchy:
///   Tag <abstract>
///     PTag
///     PTagGroupLength
///     PTagUnknown
///     PrivateTag<abstract>
///       PrivateTagGroupLength
///       PrivateTagIllegal
///       PCTag
///       PCTagUnknown
///       PDTag
///       PDTagUnknown
//TODO: is hashCode needed?
abstract class Tag {
  ///TODO: Tag and Tag.public are inconsistent when new Tag, PrivateTag... files
  ///      are generated make them consistent.
  const Tag();

  //TODO: When regenerating Tag rework constructors as follows:
  // Tag(int code, [vr = VR.kUN, vm = VM.k1_n);
  // Tag._(this.code, this.vr, this.vm, this.keyword, this.name,
  //     [this.isRetired = false, this.type = EType.kUnknown]
  // Tag.const(this.code, this.vr, this.vm, this.keyword, this.name,
  //     [this.isRetired = false, this.type = EType.kUnknown]
  // Tag.private(this.code, this.vr, this.vm, this.keyword, this.name,
  //     [this.isRetired = false, this.type = EType.kUnknown]);
  int get index => code;
  int get code;
  int get vrIndex;

  String get keyword => 'UnknownTag';
  String get name => 'Unknown Tag';
  VM get vm => VM.k1_n;
  int get vmMin => vm.min;
  int get vmMax => vm.max;
  int get vmColumns => vm.columns;

/*
  /// The maximum number of values allowed for _this_ .
  int get maxValues {
    if (vmMax != -1) return vmMax;
    final n = vr.maxLength - (vr.maxLength % vmColumns);
    assert(n % vmColumns == 0);
    return n;
  }
*/
  bool get isRetired => true;
  EType get type => EType.k3;

  /// Returns _true_  if _this_  is a [Tag] defined by the DICOM Standard
  /// or one of the known private [Tag]s ([PCTag] or [PDTag]) defined
  /// in the ODW SDK.
  bool get isKnown => keyword != 'UnknownTag';

  bool get isUnKnown => !isKnown;

  // **** Code Getters

  /// Returns a [String] for the [code] in DICOM format, i.e. (gggg,eeee).
  String get dcm => '${Tag.toDcm(code)}';

  /// Returns the [group] number for _this_  [Tag].
  int get group => code >> 16;

  /// Returns the [group] number for _this_  in hexadecimal format.
  String get groupHex => hex16(group);

  /// Returns the DICOM element [Elt] number for _this_  [Tag].
  int get elt => code & kElementMask;

  /// Returns the DICOM element [Elt] number for _this_  in hexadecimal format.
  String get eltHex => hex16(elt);

  // **** VR Getters

  VR get vr => vrByIndex[vrIndex];

//  int get vrIndex => vr.index;
  int get vrCode => vrCodeByIndex[vrIndex];

  @deprecated
  int get sizeInBytes => elementSize;

  int get elementSize => vrElementSizeByIndex[vrIndex];

  @deprecated
  bool get isShort => hasShortVF;

  bool get hasShortVF => isEvrShortVRIndex(vrIndex);

  bool get hasLongVF => isEvrLongVRIndex(vrIndex);

  /// Returns the length of a DICOM Element header field.
  /// Used for encoding DICOM media types
  int get dcmHeaderLength => (hasShortVF) ? 8 : 12;

  bool get hasNormalVR => isNormalVRIndex(vrIndex);
  bool get hasSpecialVR => isSpecialVRIndex(vrIndex);

  bool isValidVRIndex(int index) => vr.isValidIndex(index);
  
  // **** VM Getters

  /// The minimum number that MUST be present, if any values are present.
  int get minValues => vm.min;

//  int get _vfLimit => (vr.hasShortVF) ? kMaxShortVF : kMaxLongVF;

  /// The minimum length of the Value Field.
//  int get minVFLength => vm.min * vr.minValueLength;

/*
  /// The maximum length of the Value Field for this [Tag].
  int get maxVFLength {
    // Optimization - for most Tags vm.max == 1
    if (vmMax != 1) return vmMax * vr.elementSize;
    final excess = maxLength % vmColumns;
    final actual = maxLength - excess;
    assert(actual % columns == 0);
    return actual;
  }
*/

  //TODO: Validate that the number of values is legal
  //TODO write unit tests to ensure this is correct
  //TODO: make this work for PrivateTags

  /// Returns the maximum number of values allowed for this [Tag].
  int get maxValues {
    if (vm.max == -1) {
      final max = (hasShortVF) ? kMaxShortVF : kMaxLongVF;
      return max ~/ elementSize;
    }
    return vm.max;
  }

  int get columns => vm.columns;

  // **** Element Type (1, 1c, 2, ...)
  //TODO: add EType to tag
  EType get eType => EType.k3;
  int get eTypeIndex => eType.index;
  _ETypePredicate get eTypePredicate => throw new UnimplementedError();

  // Information Entity Level
  IEType get ieType => IEType.kInstance;
  int get ieIndex => ieType.index;
  String get ieLevel => ieType.level;

  // DeIdentification Method
  int get deIdIndex => throw new UnimplementedError();
  String get deIdName => throw new UnimplementedError();
  // DeIdMethod get deIdMethod => throw new UnimplementedError();

  int get hashcode => code;

  /// Returns true if the Tag is defined by DICOM, false otherwise.
  /// All DICOM Public tags have group numbers that are even integers.
  /// Note: This only checks that the group number is an even.
  bool get isPublic => code.isEven;

  bool get isPrivate => false;

  bool get isCreator => false;

  //bool get isPrivateCreator => false;
  bool get isPrivateData => false;

  int get fmiMin => kMinFmiTag;

  int get fmiMax => kMaxFmiTag;

  /// Returns _true_  if the [group] is in the File Meta Information group.
  bool get isFmiGroup => group == 0x0002;

  /// Returns _true_  if [code] is in the range of File Meta Information
  /// [Tag] [code]s.
  ///
  /// Note: Does not test tag validity.
  bool get inFmiRange => kMinFmiTag <= code && code <= kMaxFmiTag;

  int get dcmDirMin => kMinDcmDirTag;

  int get dcmDirMax => kMaxDcmDirTag;

  /// Returns _true_  if [code] is in the range of DICOM Directory [Tag] [code]s.
  ///
  /// Note: Does not test tag validity.
  bool get isDcmDir => kMinDcmDirTag <= code && code <= kMaxDcmDirTag;

  /// Returns _true_  if [code] is in the range of DICOM Directory
  /// [Tag] [code]s.
  ///
  /// Note: Does not test tag validity.
  bool get inDcmDirRange => kMinDcmDirTag <= code && code <= kMaxDcmDirTag;

  String get info {
    final retired = (isRetired) ? '- Retired' : '';
    return '$runtimeType$dcm ${vrIdByIndex[vrIndex]} $vm $keyword $retired';
  }

  /// Returns _true_  is _this_  is a valid [Tag].
  /// Valid [Tag]s are those defined in PS3.6 and Private [Tag]s that
  /// conform to the DICOM Standard.
  bool get isValid => false;

  /// Returns True if [vList].length, i.e. is valid for this [Tag].
  ///
  /// _Note_: A length of zero is always valid.
  ///
  /// [min]: The minimum number of values.
  /// [max]: The maximum number of values. If -1 then max length of
  ///     Value Field; otherwise, must be greater than or equal to [min].
  /// [width]: The [columns] of the matrix of values. If [columns == 0,
  /// then singleton; otherwise must be greater than 0;
  //TODO: should be modified when EType info is available.
  bool isValidValues<V>(Iterable<V> vList, [Issues issues]) {
    if (vList == null) {
      nullValueError();
      return false;
    }
    if (vrIndex == kUNIndex || vList.isEmpty) return true;

    if (isNotValidValuesLength(vList, issues)) {
      invalidValuesLengthError(this, vList);
      return false;
    }
    for (var v in vList)
      if (vr.isNotValidValue(v, issues)) {
        invalidTagValuesError<V>(this, vList);
        return false;
      }
    return true;
  }

  bool get isLengthAlwaysValid =>
      vrIndex == kOBIndex ||
      vrIndex == kODIndex ||
      vrIndex == kOFIndex ||
      vrIndex == kOLIndex ||
      vrIndex == kOWIndex ||
      vrIndex == kOBOWIndex;

  /// Returns _true_  if [vList].length is a valid number of values for _this_.
  ///
  /// _Note_: If a VR has a long (32-bit) Value Field, then by definition its
  /// Value Multiplicity is [VM.k1], and its length is always valid.
  bool isValidValuesLength<V>(Iterable<V> vList, [Issues issues]) {
    assert(vList != null);
    if (isValidLength(vList.length)) return true;
    invalidValuesLengthError(this, vList, issues);
    return false;
  }

  bool isNotValidValuesLength<V>(Iterable<V> vList, [Issues issues]) =>
      !isValidValuesLength(vList, issues);

  bool isValidLength(int length) {
    assert(length != null);
    if (isLengthAlwaysValid == true || length == 0) return true;
    return (length >= minValues &&
            length <= maxValues &&
            (length % columns) == 0) &&
        length <= vr.maxVFLength;
  }

  bool isNotValidLength(int length) => !isValidLength(length);

  //TODO: unit test
  /// Returns _true_  if [vfLength] is a valid Value Field length for _this_ [Tag].
  bool isValidVFLength(int vfLength, [Issues issues]) {
    assert(vfLength >= 0 && vfLength <= vr.maxVFLength);
    if (isVFLengthAlwaysValid(vrIndex)) return true;
    if (vr.isValidVFLength(vfLength, minValues, maxValues) &&
        (vfLength % columns) == 0) return true;

    final msg = 'Invalid Value Field length: '
        'min($minValues) <= $vfLength <= max($maxValues)';
    if (issues != null) issues.add(msg);
    if (throwOnError) return invalidVFLength(vfLength, vr.maxVFLength);
    return false;
  }

  bool isNotValidVFLength(int vfLength, [Issues issues]) =>
      !isValidVFLength(vfLength, issues);

  /* Flush when working
  bool get isVFLengthAlwaysValid => isVFLengthValid();
      vrIndex == kSQIndex ||
      vrIndex == kUNIndex ||
      vrIndex == kOBIndex ||
      vrIndex == kOWIndex ||
      vrIndex == kOLIndex ||
      vrIndex == kODIndex ||
      vrIndex == kOFIndex ||
      vrIndex == kUCIndex ||
      vrIndex == kURIndex ||
      vrIndex == kUTIndex;
*/

  bool isValidColumns<V>(List<V> vList, [Issues issues]) =>
      columns == 0 || (vList.length % columns) == 0;

/*
 //Flush when sure this is less accurate then above.
  bool isValidVFLength(int lengthInBytes) =>
      (lengthInBytes >= minVFLength && lengthInBytes <= vr.maxVFLength);
*/

/*
  int getMax() {
    if (vmMax != -1) return vmMax;
    final excess = vr.maxLength % vmColumns;
    final actual = maxLength - excess;
    assert(actual % vmColumns == 0);
    return actual;
  }


  bool isNotValidLength<V>(Iterable<V> vList, [Issues issues]) =>
      !isValidLength(vList, issues);

//  List<V> checkLength<V>(Iterable<V> vList) => (isValidLength<V>(vList)) ? vList : null;

  //Flush?
  String widthError(int length) => 'Invalid Width for Tag$dcm}: '
      'values length($length) is not a multiple of vmWidth($width)';

  //Flush?
  String lengthError(int length) =>
      'Invalid Length: min($minValues) <= length($length) <= max($maxValues)';


  Uint8List checkVFLength(Uint8List bytes, int maxVFLength, int sizeInBytes) =>
      (isValidVFLength(bytes.length, maxVFLength, sizeInBytes)) ? bytes : null;

  //Fix or Flush
  //Uint8List checkBytes(Uint8List bytes) => vr.checkBytes(bytes);

  V parse<V>(String s) => vr.parse(s);
*/
  /// Converts a DICOM [keyword] to the equivalent DICOM name.
  ///
  /// Given a keyword in camelCase, returns a [String] with a
  /// space (' ') inserted before each uppercase letter.
  ///
  /// Note: This algorithm does not return the exact DICOM name string,
  /// for example some names have apostrophes ("'") in them,
  /// but they are not in the [keyword]. Also, all dashes ('-') in
  /// keywords have been converted to underscores ('_'), because
  /// dashes are illegal in Dart identifiers.
  String keywordToName(String keyword) {
    final kw = keyword.codeUnits;
    final name = <int>[];
    name[0] = kw[0];
    for (var i = 0; i < kw.length; i++) {
      final char = kw[i];
      if (isUppercaseChar(char)) name.add(kSpace);
      name.add(char);
    }
    return UTF8.decode(name);
  }

  String stringToKeyword(String s) {
    var v = s;
    v = v.replaceAll(' ', '_');
    v = v.replaceAll('-', '_');
    v = v.replaceAll('.', '_');
    return v;
  }

  @override
  String toString() {
    final retired = (isRetired == false) ? '' : ', (Retired)';
    return '$runtimeType: $dcm $keyword, ${vrIdByIndex[vrIndex]}, $vm$retired';
  }

  //Fix: make this a real index
  static int codeToIndex(int x) => x;
  static int keywordToIndex(String kw) => pTagKeywords[kw].code;

  static Tag lookup<K>(K key, [int vrIndex = kUNIndex, String creator]) {
    if (key is int) return lookupByCode(key, vrIndex, creator);
    if (key is String) return lookupByKeyword(key, vrIndex, creator);
    return invalidTagKey<K>(key, vrIndex, creator);
  }

  /// Returns an appropriate [Tag] based on the arguments.
  static Tag fromCode<T>(int code, int vrIndex, [T creator]) {
    if (Tag.isPublicCode(code)) return Tag.lookupPublicCode(code, vrIndex);
    if (Tag.isPrivateCreatorCode(code) && creator is String)
      return new PCTag(code, vrIndex, creator);
    if (Tag.isPrivateDataCode(code) && creator is PCTag)
      return new PDTag(code, vrIndex, creator);
    // This should never happen
    return invalidTagCode(code);
  }

  //TODO: redoc
  /// Returns an appropriate [Tag] based on the arguments.
  static Tag lookupByCode(int code, [int vrIndex = kUNIndex, Object creator]) {
    String msg;
    if (Tag.isPublicCode(code)) {
      var tag = Tag.lookupPublicCode(code, vrIndex);
      return tag ??= new PTag.unknown(code, vrIndex);
    } else {
      if (Tag.isPrivateGroupLengthCode(code))
        return new PrivateTagGroupLength(code, vrIndex);
      if (Tag.isPrivateCreatorCode(code))
        return new PCTag(code, vrIndex, creator);
      if (Tag.isPrivateDataCode(code)) return new PDTag(code, vrIndex, creator);
    }
//    log.debug('lookupTag: ${Tag.toDcm(code)} $vrIndex, $creator');
    msg = 'Unknown Private Tag Code: creator: $creator';
    return invalidTagCode(code, msg);
  }

  static Tag lookupByKeyword(String keyword,
      [int vrIndex = kUNIndex, Object creator]) {
/*    Tag tag = Tag.lookupKeyword(keyword, vr);
    if (tag != null) return tag;
    tag = Tag.lookupPrivateCreatorKeyword(keyword, vr) {
      if (Tag.isPrivateGroupLengthKeyword(keyword))
        return new PrivateGroupLengthTagFromKeyword(keyword, vr);
      if (Tag.isPrivateCreatorKeyword(keyword))
        return new PCTag.keyword(keyword, vr, creator);
      if (Tag.isPrivateDataKeyword(keyword))
        return new PDTag.keyword(keyword, vr, creator);
      throw 'Error: Unknown Private Tag Code$keyword';
    } else {
      // This should never happen
      //throw 'Error: Unknown Tag Code${Tag.toDcm(code)}';
      return null;
    }*/
    throw new UnimplementedError();
  }

  static bool allowInvalidVR = false;

  // Returns _true_ if [vrIndex] is valid for [tag].
  static bool isValidVR(Tag tag, int vrIndex) {
    if (tag.vr.isValidIndex(vrIndex)) return true;
    log.warn('Invalid VR ${vrIdFromIndex(vrIndex)} for $tag');
    if (allowInvalidVR) return true;
    if (throwOnError) invalidVRForTag(tag, vrIndex);
    return false;
  }

  //TODO: move these to Fast Tag
  // static bool isValidTagCode(int index) => _isValidTagIndex(index, kVR);
  // static bool isValidTagCode(int code) => _isValidTagCode(code, kVR);
  // static bool isValidTagKeyword(String keyword) =>
  //     _isValidTagKeyword(keyword, kVR);

  //TODO: Use the 'package:collection/collection.dart' ListEquality
  //TODO:  decide if this ahould be here
  /// Compares the elements of two [List]s and returns _true_  if all
  /// elements are equal; otherwise, returns _false_.
  /// Note: this is not recursive!
  static bool listEquals<E>(List<E> e1, List<E> e2) {
    if (identical(e1, e2)) return true;
    if (e1 == null || e2 == null) return false;
    if (e1.length != e2.length) return false;
    for (var i = 0; i < e1.length; i++) if (e1[i] != e2[i]) return false;
    return true;
  }

  //TODO: needed or used?
  static Tag lookupPublicCode(int code, int vrIndex) {
    final tag = PTag.lookupByCode(code, vrIndex);
    if (tag != null) return tag;
    if (Tag.isPublicGroupLengthCode(code)) return new PTagGroupLength(code);
    return new PTagUnknown(code, vrIndex);
  }

  static Tag lookupPublicKeyword(String keyword, int vrIndex) {
    final tag = PTag.lookupByKeyword(keyword, vrIndex);
    if (tag != null) return tag;
    if (Tag.isPublicGroupLengthKeyword(keyword))
      return new PTagGroupLength.keyword(keyword);
    return new PTagUnknown.keyword(keyword, vrIndex);
  }

  static Tag lookupPrivateCreatorCode(int code, int vrIndex, String token) {
    if (Tag.isPrivateGroupLengthCode(code))
      return new PrivateTagGroupLength(code, vrIndex);
    if (isPrivateCreatorCode(code)) return new PCTag(code, vrIndex, token);
    throw new InvalidTagCodeError(code);
  }

/*  static PDTagKnown lookupPrivateDataCode(
      int code, int vrIndex, PCTag creator) =>
      (creator is PCTagKnown) ? creator.lookupData(code)
          : new PDTagUnknown(code, vr, creator);
  */

  /// Returns a [String] corresponding to [tag], which might be an
  /// [int], [String], or [Tag].
  static String toMsg<T>(T tag) {
    String msg;
    if (tag is int) {
      msg = 'Code ${Tag.toDcm(tag)}';
    } else if (tag is String) {
      msg = 'Keyword "$tag"';
    } else {
      msg = '${tag.runtimeType}: $tag';
    }
    return '$msg';
  }

  static List<String> lengthChecker(
      List values, int minLength, int maxLength, int width) {
    final length = values.length;
    // These are the most common cases.
    if (length == 0 || (length == 1 && width == 0)) return null;
    List<String> msgs;
    if (length % width != 0)
      msgs = ['Invalid Length($length) not a multiple of vmWidth($width)'];
    if (length < minLength) {
      final msg = 'Invalid Length($length) less than minLength($minLength)';
      msgs = msgs ??= []..add(msg);
    }
    if (length > maxLength) {
      final msg = 'Invalid Length($length) greater than maxLength($maxLength)';
      msgs = msgs ??= []..add(msg); //TODO: test Not sure this is working
    }
    return (msgs == null) ? null : msgs;
  }

  // *** Private Tag Code methods
  static bool isPrivateCode(int code) => Group.isPrivate(Group.fromTag(code));

  static bool isPublicCode(int code) => Group.isPublic(Group.fromTag(code));

  static bool isGroupLengthCode(int code) => Elt.fromTag(code) == 0;

  static bool isPublicGroupLengthCode(int code) =>
      Group.isPublic(Group.fromTag(code)) && Elt.fromTag(code) == 0;

  static bool isPublicGroupLengthKeyword(String keyword) =>
      keyword == 'PublicGroupLengthKeyword' ||
      isPublicGroupLengthKeywordCode(keyword);

  //TODO: test - needs to handle 'oxGGGGEEEE' and 'GGGGEEEE'
  static bool isPublicGroupLengthKeywordCode(String keywordCode) {
    final code = int.parse(keywordCode, radix: 16, onError: (s) => -1);
    return (code == -1) ? (Elt.fromTag(code) == 0) ? true : false : false;
  }

  /// Returns true if [code] is a valid Private Creator Code.
  static bool isPrivateCreatorCode(int code) =>
      isPrivateCode(code) && Elt.isPrivateCreator(Elt.fromTag(code));

  static bool isCreatorCodeInGroup(int code, int group) {
    final g = group << 16;
    return (code >= (g + 0x10)) && (code <= (g + 0xFF));
  }

  static bool isPDataCodeInSubgroup(int code, int group, int subgroup) {
    final sg = (group << 16) + (subgroup << 8);
    return (code >= sg && (code <= (sg + 0xFF)));
  }

  static bool isPrivateDataCode(int code) =>
      Group.isPrivate(Group.fromTag(code)) &&
      Elt.isPrivateData(Elt.fromTag(code));

  static int privateCreatorBase(int code) => Elt.pcBase(Elt.fromTag(code));

  static int privateCreatorLimit(int code) => Elt.pcLimit(Elt.fromTag(code));

  static bool isPrivateGroupLengthCode(int code) =>
      Group.isPrivate(Group.fromTag(code)) && Elt.fromTag(code) == 0;

  /// Returns true if [pd] is a valid Private Data Code for the
  /// [pc] the Private Creator Code.
  ///
  /// If the [PCTag ]is present, verifies that [pd] and [pc]
  /// have the same [group], and that [pd] has a valid [Elt].
  static bool isValidPrivateDataTag(int pd, int pc) {
    final pdg = Group.checkPrivate(Group.fromTag(pd));
    final pcg = Group.checkPrivate(Group.fromTag(pc));
    if (pdg == null || pcg == null || pdg != pcg) return false;
    return Elt.isValidPrivateData(Elt.fromTag(pd), Elt.fromTag(pc));
  }

  //**** Private Tag Code 'Constructors' ****
  static bool isPCIndex(int pcIndex) => 0x0010 <= pcIndex && pcIndex <= 0x00FF;

  /// Returns a valid [PCTag], or -1 .
  static int toPrivateCreator(int group, int pcIndex) {
    if (Group.isPrivate(group) && _isPCIndex(pcIndex))
      return _toPrivateCreator(group, pcIndex);
    return -1;
  }

  /// Returns a valid [PDTagKnown], or -1.
  static int toPrivateData(int group, int pcIndex, int pdIndex) {
    if (Group.isPrivate(group) &&
        _isPCIndex(pcIndex) &&
        _isPDIndex(pcIndex, pdIndex))
      return _toPrivateData(group, pcIndex, pcIndex);
    return -1;
  }

  /// Returns a [PCTag], without checking arguments.
  static int _toPrivateCreator(int group, int pcIndex) =>
      (group << 16) + pcIndex;

  /// Returns a [PDTagKnown], without checking arguments.
  static int _toPrivateData(int group, int pcIndex, int pdIndex) =>
      (group << 16) + (pcIndex << 8) + pdIndex;

  // **** Private Tag Code Internal Utility functions ****

  /// Return _true_  if [pdCode] is a valid Private Creator Index.
  static bool _isPCIndex(int pdCode) => 0x10 <= pdCode && pdCode <= 0xFF;

  // Returns _true_  if [pde] in a valid Private Data Index
  //static bool _isSimplePDIndex(int pde) => 0x1000 >= pde && pde <= 0xFFFF;

  /// Return _true_  if [pdi] is a valid Private Data Index.
  static bool _isPDIndex(int pci, int pdi) =>
      _pdBase(pci) <= pdi && pdi <= _pdLimit(pci);

  /// Returns the offset base for a Private Data Element with the
  /// Private Creator [pcIndex].
  static int _pdBase(int pcIndex) => pcIndex << 8;

  /// Returns the limit for a [PDTagKnown] with a base of [pdBase].
  static int _pdLimit(int pdBase) => pdBase + 0x00FF;

  /// Returns _true_  if [tag] is in the range of DICOM Dataset Tags.
  /// Note: Does not test tag validity.
  static bool inDatasetRange(int tag) =>
      (kMinDatasetTag <= tag) && (tag <= kMaxDatasetTag);

  static void checkDatasetRange(int tag) {
    if (!inDatasetRange(tag)) rangeError(tag, kMinDatasetTag, kMaxDatasetTag);
  }

  /// Returns [code] in DICOM format '(gggg,eeee)'.
  static String toHex(int code) => hex32(code);

  /// Returns [code] in DICOM format '(gggg,eeee)'.
  static String toDcm(int code) {
    if (code == null) return '"null"';
    return '(${hex16(Group.fromTag(code))},'
        '${hex16(Elt.fromTag(code))})';
  }

  /// Returns a [List] of DICOM tag codes in '(gggg,eeee)' format
  static Iterable<String> listToDcm(List<int> tags) => tags.map(toDcm);

  /// Takes a [String] in format '(gggg,eeee)' and returns [int].
  static int toInt(String s) {
    final tmp = '${s.substring(1, 5)}${s.substring(6, 10)}';
    return int.parse(tmp, radix: 16);
  }

  static bool rangeError(int tag, int min, int max) {
    final msg = 'Invalid tag: $tag not in $min <= x <= $max';
    throw new RangeError(msg);
  }
}
