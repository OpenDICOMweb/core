//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;

import 'package:core/src/error.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag/code.dart';
import 'package:core/src/tag/e_type.dart';
import 'package:core/src/tag/ie_type.dart';
import 'package:core/src/tag/public/p_tag.dart';
import 'package:core/src/tag/public/p_tag_keywords.dart';
import 'package:core/src/tag/private/pc_tag.dart';
import 'package:core/src/tag/private/pd_tag.dart';
import 'package:core/src/tag/private/private_tag.dart';
import 'package:core/src/tag/vm.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/vr/vr_base.dart';
import 'package:core/src/vr/vr_external.dart';

const int kGroupMask = 0xFFFF0000;
const int kElementMask = 0x0000FFFF;

/// A Element Type predicate. Returns _true_  if the Element
/// corresponding to [key] in the [Dataset] satisfies the
/// requirements for the SopClass of the [Dataset].
typedef bool _ETypePredicate<K>(Dataset ds, K key);

//TODO: move to system
bool allowInvalidTags = true;

//Fix:
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
abstract class Tag {
  //TODO: Tag and Tag.public are inconsistent when new Tag, PrivateTag... files
  //      are generated make them consistent.
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
  String get vrId => vrIdFromIndex(vrIndex);
  VR get vr => vrByIndex[vrIndex];

  String get keyword; // => 'UnknownTag';
  String get name; // => 'Unknown Tag';
  VM get vm => VM.k1_n;
  int get vmMin => vm.min;
  int get vmMax => vm.max(vr.maxLength);
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
  String get dcm => '${toDcm(code)}';

  /// Returns the [group] number for _this_  [Tag].
  int get group => code >> 16;

  /// Returns the [group] number for _this_  in hexadecimal format.
  String get groupHex => hex16(group);

  /// Returns the DICOM element number for _this_  [Tag].
  int get elt => code & kElementMask;

  /// Returns the DICOM element number for _this_  in hexadecimal format.
  String get eltHex => hex16(elt);

  // **** VR Getters

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

  bool isValidVRIndex(int index) => VR.isValidIndex(index, null, vrIndex);

  // **** VM Getters

  /// The minimum number that MUST be present, if any values are present.
  int get minValues => vm.min;

  /// Returns the maximum number of values allowed for this [Tag].
  int get maxValues => vm.max(vr.maxLength);

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
  bool get isPublic;

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

  /// Returns _true_  if [code] is in the range of
  /// DICOM Directory [Tag] [code]s.
  ///
  /// _Note_: Does not test tag validity.
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

  bool get isLengthAlwaysValid =>
      vrIndex == kUNIndex ||
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
  bool isValidValuesLength(Iterable vList, [Issues issues]) {
    assert(vList != null);
    if (isValidLength(vList)) return true;
    invalidValuesLength(vList, vmMin, vmMax, issues);
    return false;
  }

  bool isNotValidValuesLength(Iterable vList, [Issues issues]) =>
      !isValidValuesLength(vList, issues);

  bool isValidLength(Iterable vList, [Issues issues]) {
    assert(vList != null);
    final length = vList.length;
    if (length == null) return invalidValuesLength(vList, vmMin, vmMax);
    if (isLengthAlwaysValid == true || length == 0) return true;
    return (length >= (minValues * columns)) &&
        ((maxValues == -1 || length <= maxValues) && (length % columns) == 0);
  }

  bool isNotValidLength(Iterable vList, [Issues issues]) =>
      !isValidLength(vList);

  /// Returns _true_  if [vfLength] is a valid
  /// Value Field length for _this_ [Tag].
  bool isValidVFLength(int vfLength, [Issues issues]) =>
      (isVFLengthAlwaysValid(vrIndex))
          ? true
          : vr.isValidVFLength(vfLength, vmMin, vmMax);

  bool isNotValidVFLength(int vfLength, [Issues issues]) =>
      !isValidVFLength(vfLength, issues);

  bool isValidColumns<V>(List<V> vList, [Issues issues]) =>
      columns == 0 || (vList.length % columns) == 0;

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
    return cvt.utf8.decode(name);
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

  //TODO: make this a real index
  static int codeToIndex(int x) => x;
  static int keywordToIndex(String kw) => pTagKeywords[kw].code;

  static Tag lookup<K>(K key, [int vrIndex = kUNIndex, String creator]) {
    if (key is int) return lookupByCode(key, vrIndex, creator);
    if (key is String) return lookupByKeyword(key, vrIndex, creator);
    return badKey<K>(key, vrIndex, creator);
  }

  //TODO: Flush either fromCode of lookupByCode
  /// Returns an appropriate [Tag] based on the arguments.
  static Tag fromCode<T>(int code, int vrIndex, [T creator]) {
    if (isPublicCode(code)) {
      var tag = Tag.lookupPublicCode(code, vrIndex);
      return tag ??= new PTag.unknown(code, vrIndex);
    } else {
      assert(isPrivateCode(code) == true);
      final elt = code & 0xFF;
      if (elt == 0) return new PrivateGroupLengthTag(code, vrIndex);
      if (elt < 0x10) return new IllegalPrivateTag(code, vrIndex);
      if ((elt >= 0x10) && (elt <= 0xFF) && creator is String)
        return PCTag.make(code, vrIndex, creator);
      if ((elt > 0xFF) && (elt <= 0xFFFF) && creator is PCTag)
        return PDTag.make(code, vrIndex, creator);
      // This should never happen
      return badTagCode(code);
    }
  }

  /// Returns _true_ if [code] is valid.  If [code] is public, then it
  /// must be a known [PTag]; otherwise, it must be a valid private [code],
  /// i.e. 0xggggeeee, where gggg is odd and eeee == 0 or eeee >= 00
  static bool isValidCode(int code) {
    if (code.isOdd) {
      return isValidPrivateCode(code);
    } else {
      final tag = PTag.lookupByCode(code);
      return (tag == null) ? false : true;
    }
  }

  static bool isValidPrivateCode(int code) {
    if (!code.isOdd) return false;
    final elt = code & 0xFFFF;
    return ((elt > 0 && elt < 0x10) || (elt > 0xFF && elt < 0x1000))
        ? false
        : true;
  }

  /// Returns an appropriate [Tag] based on the arguments.
  static Tag lookupByCode(int code, [int vrIndex = kUNIndex, Object creator]) {
    if (code > 0xFFFFFFFF ||
        (!allowInvalidTags &&
            (code < kAffectedSOPInstanceUID || code > kDataSetTrailingPadding)))
      return badTagCode(code);

    final group = code >> 16;
    Tag tag;

    if (group.isEven) {
      tag = PTag.lookupByCode(code, vrIndex);
      if (tag == null) {
        if ((code & 0xFFFF) == 0) {
          tag = new PTagGroupLength(code);
        } else {
          tag = new PTag.unknown(code, vrIndex);
        }
      }
    } else if (group.isOdd && group >= 0x0009 && group <= 0xFFFF) {
      final elt = code & 0xFFFF;
      if (elt == 0) {
        tag = new PrivateGroupLengthTag(code, vrIndex);
      } else if (elt < 0x10) {
        tag = new IllegalPrivateTag(code, vrIndex);
      } else if ((elt >= 0x10) && (elt <= 0xFF)) {
        tag = PCTag.make(code, vrIndex, creator);
      } else if ((elt > 0x00FF) && (elt <= 0xFFFF)) {
        tag = PDTag.make(code, vrIndex, creator);
      } else {
        // This should never happen
        final msg = 'Unknown Private Tag Code: creator: $creator';
        return badTagCode(code, msg);
      }
    }
    return tag;
  }

  static Tag lookupPublicByCode(int code, [int vrIndex = kUNIndex]) {
    assert(_isPublicCode(code));
    var tag = PTag.lookupByCode(code, vrIndex);
    if (tag == null) {
      if ((code & 0xFFFF) == 0) {
        tag = new PTagGroupLength(code);
      } else {
        tag = new PTag.unknown(code, vrIndex);
      }
    }
    return tag;
  }

  static bool _isPublicCode(int code) => _isPublicGroup(code >> 16);
  static bool _isPublicGroup(int group) => group.isEven && group <= 0xFFFE;

  static Tag lookupPrivateByCode(int code,
      [int vrIndex = kUNIndex, Object creator]) {
    assert(_isPrivateCode(code));

    final elt = code & 0xFFFF;
    Tag tag;
    if (elt == 0) {
      // Private Group Length
      tag = new PrivateGroupLengthTag(code, vrIndex);
    } else if (elt < 0x10) {
      // Illegal Private Code
      tag = new IllegalPrivateTag(code, vrIndex);
    } else if ((elt >= 0x10) && (elt <= 0xFF)) {
      // Private Creator
      tag = PCTag.make(code, vrIndex, creator);
    } else if ((elt > 0x00FF) && (elt <= 0xFFFF)) {
      // Private Data
      tag = PDTag.make(code, vrIndex, creator);
    } else {
      // This should never happen
      final msg = 'Unknown Private Tag Code: $vrIndex creator: $creator';
      return badTagCode(code, msg);
    }
    return tag;
  }

  static bool _isPrivateCode(int code) => _isPrivateGroup(code >> 16);

  static bool _isPrivateGroup(int group) =>
      group.isOdd && group >= 0x0009 && group <= 0xFFFF;

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
    if (tag.vr.isValid(vrIndex)) return true;
    log.warn('Invalid VR ${vrIdFromIndex(vrIndex)} for $tag');
    if (allowInvalidVR) return true;
    if (throwOnError) invalidVRIndex(vrIndex, null, tag.vrIndex, tag);
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

  static Tag lookupPublicCode(int code, int vrIndex) {
    final tag = PTag.lookupByCode(code, vrIndex);
    if (tag != null) return tag;
    if (isPublicGroupLengthCode(code)) return new PTagGroupLength(code);
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
    if (isPrivateGroupLengthCode(code))
      return new PrivateGroupLengthTag(code, vrIndex);
    if (isPCCode(code)) return PCTag.make(code, vrIndex, token);
    return badTagCode(code);
  }

  /// Returns a [String] corresponding to [tag], which might be an
  /// [int], [String], or [Tag].
  static String toMsg<T>(T tag) {
    String msg;
    if (tag is int) {
      msg = 'Code ${toDcm(tag)}';
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
      msgs = msgs ??= []..add(msg);
    }
    return (msgs == null) ? null : msgs;
  }

/*
  // Issue: should checkRange be global
  /// Returns_true_ if [code] is a valid Public Code, but
  /// _does not check that [code] is defined by the DICOM Standard.
  static bool isPublicCode(int code, {bool checkRange = true}) {
    final group = code >> 16;
    if (group.isEven) {
      return (checkRange) ? group >= 0x0002 && group <= 0xFFFC : true;
    }
    return false;
  }
*/

//  static bool isNotPublicCode(int code, {bool checkRange: true}) =>
//      !isPublicCode(code, checkRange: checkRange);

  // *** Private Tag Code methods
  /// Groups numbers that shall not be used in PrivateTags.
  static const List<int> invalidPrivateGroups = const <int>[
    0x0001, 0x0003, 0x0005, 0x0007, 0xFFFF // Don't reformat
  ];

  /// Returns gggg of (gggg,eeee).
  static int toGroup(int code) {
    final group = code >> 16;
    return (0x0007 < (code >> 16) && (code >> 16) < 0xFFFC) ? group : null;
  }

  /// Returns eeee of (gggg,eeee).
  static int toElt(int code) => code & 0xFFFF;

  /// Returns_true_ if [code] is a valid Private Code.
  static bool isPrivateCode(int code) => isPrivateGroup(code >> 16);

  /// Returns_true_ if [group] is a valid Private Group.
  static bool isPrivateGroup(int group) =>
      group.isOdd && group > 0x0007 && group < 0xFFFC;

  /// Returns the Group Number for [code], if code is a Private Code.
  static int privateGroup(int code) {
    final group = code >> 16;
    return (isPrivateGroup(group)) ? group : null;
  }

  static bool isNotPrivateCode(int code) => !isPrivateCode(code);

  static bool isGroupLengthCode(int code) => (code & 0xFFFF) == 0;

  static bool isPublicGroupLengthCode(int code) =>
      // Public Tags have bit #16 must equal 0.
      isPublicCode(code) && (code & 0x1FFFF) == 0;

  static bool isPrivateGroupLengthCode(int code) =>
      // Private Tags have bit #16 must equal 1.
      isPrivateCode(code) && (code & 0x1FFFF) == 0x10000;

  static bool isPrivateIllegalCode(int code) =>
      isPrivateCode(code) && (code & 0xFFFF) > 0 && code & 0xFFFF < 0x10;

  static bool isNotPrivateIllegalCode(int code) => !isPrivateIllegalCode(code);

  static bool isPublicGroupLengthKeyword(String keyword) =>
      keyword == 'PublicGroupLengthKeyword' ||
      isPublicGroupLengthKeywordCode(keyword);

  //TODO: unit test - needs to handle '0xGGGGEEEE' and 'GGGGEEEE'
  static bool isPublicGroupLengthKeywordCode(String keywordCode) {
    final code = int.tryParse(keywordCode);
    if (code == null) return false;
    return (code & 0x1FFFF) == 0 ? true : false;
  }

  /// Returns true if [code] is a valid Private Creator Code.
  static bool isPCCode(int code) {
    // Trick to check that it is both Private and Creator.
    final bits = code & 0x1FFFF;
    return (bits >= 0x10010 && bits <= 0x100FF);
  }

  static bool isNotPCCode(int code) => !isPCCode(code);

  static int pcSubgroup(int code) => code & 0xFF;

  static bool isPCCodeInGroup(int code, int group) {
    final g = group << 16;
    return (code >= (g + 0x10)) && (code <= (g + 0xFF));
  }

  static int pdSubgroup(int code) => (code & 0xFFFF) >> 8;

  static bool isPDCodeInSubgroup(int code, int group, int subgroup) {
    final sg = (group << 16) + (subgroup << 8);
    return (code >= sg && (code <= (sg + 0xFF)));
  }

  ///  Returns true if [pdCode] is a valid Private Data Code,
  ///  and either [pcCode] is zero or [pcCode] is a Private
  ///  Creator Code for [pdCode].
  static bool isPDCode(int pdCode, [int pcCode = 0]) {
    // Trick to check that it is both Private and Data.
    final bits = pdCode & 0x1FFFF;
    if (bits < 0x11000 || bits > 0x1FFFF) return false;
    return (pcCode == 0) ? true : _isValidPDCode(pdCode, pcCode);
  }

  ///  Returns true if [pdCode] is a valid Private Data Code,
  ///  and [pcCode] is the correct Private Creator Code for [pdCode].
  static bool isValidPDCode(int pdCode, int pcCode) {
    final pdGroup = Tag.privateGroup(pdCode);
    final pcGroup = Tag.privateGroup(pcCode);
    if (pdGroup == null || pcGroup == null || pdGroup != pcGroup) return false;
    return _isValidPDCode(pdCode, pcCode);
  }

  static bool _isValidPDCode(int pd, int pc) {
    final pdOffset = pd & 0xFFFF;
    final pdsg = pdOffset >> 8;
    final pcsg = (pc & 0xFF);
    if (pcsg < 0x10 || pcsg > 0xFF || pdsg != pcsg) return false;
    final base = pcsg << 8;
    final limit = base + 0xFF;
    return base <= pdOffset && pdOffset <= limit;
  }

  static int privateCreatorBase(int code) =>
      (isNotPCCode(code)) ? null : (code & 0xFFFF) << 8;

  static int privateCreatorLimit(int code) =>
      (isNotPCCode(code)) ? null : ((code & 0xFFFF) << 8) + 0xFF;

  //**** Private Tag Code 'Constructors' ****
  static bool isPCIndex(int pcIndex) => 0x0010 <= pcIndex && pcIndex <= 0x00FF;

  /// Returns a valid [PCTag], or -1 .
  static int toPrivateCreator(int group, int pcIndex) {
    if (group.isOdd && 0x0007 < group && group < 0xFFFF && _isPCIndex(pcIndex))
      return _toPrivateCreator(group, pcIndex);
    return -1;
  }

  /// Returns a valid [PDTagKnown], or -1.
  static int toPrivateData(int group, int pcIndex, int pdIndex) {
    if (group.isOdd &&
        (0x0007 < group && group < 0xFFFF) &&
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

/*
  /// Returns [code] in DICOM format '(gggg,eeee)'.
  static String toDcm(int code) {
    if (code == null) return '"null"';
    return '(${hex16(Group.fromTag(code), prefix: '')},'
        '${hex16(Elt.fromTag(code), prefix: '')})';
  }
*/

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

  /// Returns _true_ if [tag].vrIndex is equal to [targetVR], which MUST
  /// be a valid _VR Index_. Typically, one of the constants (k_XX_Index)
  /// is used.
  static bool isValidTag(Tag tag, Issues issues, int targetVR, Type type) {
    if (!doTestElementValidity) return true;
    return (tag != null && tag.vrIndex == targetVR)
        ? true
        : invalidTag(tag, issues, type);
  }

  static const List<int> kSpecialSSVRs = const [kUSSSIndex, kUSSSOWIndex];

  /// Returns _true_ if [tag].vrIndex is equal to [targetVR], which MUST
  /// be a valid _VR Index_. Typically, one of the constants (k_XX_Index)
  /// is used.
  static bool isValidSpecialTag(
      Tag tag, Issues issues, int targetVR, Type type) {
    if (!doTestElementValidity || targetVR == kUNIndex) return true;
    final vrIndex = tag.vrIndex;
    return (tag != null &&
            (vrIndex == targetVR || kSpecialSSVRs.contains(vrIndex)))
        ? true
        : invalidTag(tag, issues, type);
  }
}
