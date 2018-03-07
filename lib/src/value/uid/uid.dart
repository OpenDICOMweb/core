// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/value/uid/uid_errors.dart';
import 'package:core/src/value/uid/uid_string.dart';
import 'package:core/src/value/uid/well_known_uids.dart';
import 'package:core/src/value/uuid.dart';

export 'package:core/src/value/uid/constants.dart';
export 'package:core/src/value/uid/supported_transfer_syntax.dart';
export 'package:core/src/value/uid/supported_uids.dart';
export 'package:core/src/value/uid/uid.dart';
export 'package:core/src/value/uid/uid_errors.dart';
export 'package:core/src/value/uid/uid_string.dart';
export 'package:core/src/value/uid/well_known/uid_type.dart';

// ignore_for_package: prefer_constructor_over_static;
typedef String _Generator();
typedef Uid OnUidParseError(String s);

/// A class that implements *DICOM Unique Identifiers* (UID) <*add link*>,
/// also known as OSI *Object Identifiers* (OID), in accordance with
/// Rec. ITU-T X.667 | ISO/IEC 9834-8. See <http://www.oid-info.com/get/2.25>
///
/// [Uid]s are immutable.  They can be created as:
///   1. compile time constants (e.g Well Known [Uid]s (WKUid),
///   2. from Strings in [Uid] format, or
///   3. generated from random [Uuid]s. See <http://www.oid-info.com/get/2.25>

/// A UID constructed from a [String] or from a root and leaf.  This
/// class is the super class for all Well Known UIDs.
class Uid {
  // A generator function for random [Uid]s. This should be
  // set to either [
  static final _Generator _generator = generateSecureUidString;
  final String value;

  factory Uid([String s]) {
    String v;
    if (s == null) {
      v = _generator();
    } else {
      v = s.trim();
      final wk = wellKnownUids[s];
      if (wk != null) return wk;
      if (!isValidUidString(v)) return invalidUidString(v);
    }
    return new Uid._(v);
  }

  /// Used by internal random generators
  Uid._(this.value);

  const Uid.wellKnown(this.value);

  /// Returns a [String] containing a random UID as per the
  /// See Dart sdk/math/Random.
  factory Uid.seededPseudo() => new Uid._(generateSeededPseudoUidString());

  /// Returns a [String] containing a random UID as per the
  /// See Dart sdk/math/Random.
  factory Uid.pseudo() => new Uid._(generatePseudoUidString());

  /// Returns a [String] containing a _secure_ random UID.
  /// See Dart sdk/math/Random.
  factory Uid.secure() => new Uid._(generateSecureUidString());

  @override
  bool operator ==(Object other) =>
      (other is Uid) && (asString == other.asString);

  @override
  int get hashCode => value.hashCode;

  /// The minimum length of a [Uid][String].
  int get minLength => kUidMinLength;

  /// The maximum length of a [Uid][String].
  int get maxLength => kUidMaxLength;

  int get maxRootLength => kUidMaxRootLength;

  /// Returns _true_ if _this_ is an encapsulated [TransferSyntax].
  bool get isEncapsulated => false;

  /// Returns _true_ if _this_ is a [Uid] defined by the DICOM Standard.
  bool get isWellKnown => false;

  /// Return a [String] that includes the [runtimeType].
  String get info => '$runtimeType: $asString';

  /// Returns the [Uid] [String].
  String get asString => value;

  /// Returns the [Uid] [String].
  @override
  String toString() => asString;

  // **** Static Getters and Methods

  //TODO: What should minimum be?
  static const int kUidMinLength = 6;
  static const int kUidMaxLength = 64;
  //TODO: What should this value be?
  static const int kUidMaxRootLength = 24;

  /// An empty [List<Uid>].
  static const List<Uid> kEmptyList = const <Uid>[];

  /// ASCII constants for '0', '1', and '2'. No other roots are valid.
  static const List<String> uidRoots = kUidRoots;

  /// Returns the DICOM UID root [String]
  static String get dicomRoot => '1.2.840.10008';

  /// Returns the Well Known (DICOM) [Uid] corresponding to [s],
  /// or _null_ if none.
  static WKUid lookup(String s) => wellKnownUids[s];

  /// Returns a [Uid] created from a pseudo random [Uuid].
  static String generateSeededPseudoUidString() =>
      Uuid.toUid(V4Generator.seededPseudo.next);

  /// Returns a [Uid] created from a pseudo random [Uuid].
  static String generatePseudoUidString() =>
      Uuid.toUid(V4Generator.pseudo.next);

  /// Returns a [Uid] created from a secure random [Uuid].
  static String generateSecureUidString() =>
      Uuid.toUid(V4Generator.secure.next);

  /// Returns _true_ is [uid] has the DICOM UID Root (1.2.840.10008).
  static bool isDicom(Uid uid) => uid.asString.indexOf(dicomRoot) == 0;

  /// Returns a [String] containing the name of the organization associated
  /// with the root.
  static String rootType(String uidString) => uidRootType(uidString);

  /// Returns
  static bool isValidString(String s) => isValidUidString(s);

  /// Returns _true_ if [sList] is empty, i.e. [sList].length == 0, or if each
  /// [String] in the [List] is a valid [Uid].
  static bool isValidStringList(List<String> sList) =>
      isValidUidStringList(sList);

  /// Parse [s] as [Uid] and return its value.
  ///
  /// If [s] is valid and a WellKnownUid([WKUid]), the canonical
  /// WellKnownUid([WKUid]) is returned; otherwise, a new [Uid] is
  /// created and returned.
  ///
  /// If [s] is not a valid [Uid] [String], [onError] is called with [s] as
  /// its argument, and its value is returned as the value of the [parse]
  /// expression. If no [onError] is provided, an [InvalidUidError] is thrown.
  ///
  /// The onError handler can be chosen to return null. This is preferable
  /// to to throwing and then immediately catching the FormatException.
  static Uid parse(String s, {OnUidParseError onError}) {
    final v = s.trim();
    if (!Uid.isValidString(v)) {
      if (onError != null) {
        return onError(s);
      } else {
        return invalidUidString(s);
      }
    }
    final wk = wellKnownUids[s];
    return (wk != null) ? wk : new Uid(s);
  }

  /// Parses a [List] of [String]s as [Uid]s and returns a new
  /// [List] containing the corresponding [Uid]s.
  ///
  /// If any member of [sList] is not valid, [onError] is called and
  /// its values is stored in the  result. If no [onError] is provided,
  /// an [InvalidUidError] is thrown.
  static List<Uid> parseList(List<String> sList, {OnUidParseError onError}) {
    final uids = new List<Uid>(sList.length);
    for (var i = 0; i < sList.length; i++)
      uids[i] = Uid.parse(sList[i], onError: onError);
    return uids;
  }

  /// Return the first character of the [Uid] [String].
  static String uidRootType(String uidString) =>
      kUidRootType[uidString.codeUnitAt(0)];

  /// Returns a [list<Uid>] of [Uid] generated from random [Uuid]s.
  static List<Uid> randomList(int length) {
    final uList = new List<Uid>(length);
    for (var i = 0; i < length; i++) uList[i] = new Uid();
    return uList;
  }

  /// Returns a [Uid] [String] generated from random [Uuid]s.
  static String randomString() => generateSecureUidString();
}
