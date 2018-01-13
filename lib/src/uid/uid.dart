// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:bignum/bignum.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/uid/uid_errors.dart';
import 'package:core/src/uid/uid_string.dart';
import 'package:core/src/uid/well_known_uids.dart';
import 'package:core/src/uuid/uuid.dart';
import 'package:core/src/uuid/v4generator.dart';

// ingnore_for_package: prefer_constructor_over_static;
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

  //Urgent: test that validation is working
  Uid([String s]) : this.value = (s == null) ? _generator() : check(s);

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
  bool operator ==(Object other) => (other is Uid) && (asString == other.asString);

  @override
  int get hashCode => value.hashCode;

  int get minLength => kUidMinLength;
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

  //TODO: is this the correct number
  static const int kUidMinLength = 6;
  static const int kUidMaxLength = 64;
  //TODO: is this the correct number
  static  int kUidMaxRootLength = 24;

  /// ASCII constants for '0', '1', and '2'. No other roots are valid.
  static const List<String> uidRoots = kUidRoots;

  /// Returns the DICOM UID root [String]
  static String get dicomRoot => '1.2.840.10008';

  /// Returns the Well Known (DICOM) [Uid] corresponding to [s],
  /// or _null_ if none.
  static WKUid lookup(String s) => wellKnownUids[s];

  /// Returns a [Uid] created from a pseudo random [Uuid].
  static String generateSeededPseudoUidString() =>
      _convertBigIntToUid(V4Generator.seededPseudo.next);

  /// Returns a [Uid] created from a pseudo random [Uuid].
  static String generatePseudoUidString() => _convertBigIntToUid(V4Generator.pseudo.next);

  //Urgent: Jim fix
  static String _convertBigIntToUid(Uint8List uuid) {
    final n = new BigInteger.fromBytes(1, uuid).abs();
    final s = n.toRadix(16).padLeft(32, '0');
   log.debug('$n "$s"');
    return '2.25.$s';
  }

  /// Returns a [Uid] created from a secure random [Uuid].
  static String generateSecureUidString() => _convertBigIntToUid(V4Generator.secure.next);

  static bool isDicom(Uid uid) => uid.asString.indexOf(dicomRoot) == 0;

  /// Returns [s] if it is a valid [Uid] [String]; otherwise, _null_.
  static String check(String s) => isValidString(s) ? s : null;

//  static String test(String s) => isValidString(s) ? s : throw 'Invalid Uid String: $s';

  /// Returns a [String] containing the name of the organization associated
  /// with the root.
  static String rootType(String uidString) => uidRootType(uidString);

  /// Returns
  static bool isValidString(String s) => isValidUidString(s);

  /// Returns _true_ if [sList] is empty, i.e. [sList].length == 0, or if each
  /// [String] in the [List] is a valid [Uid].
  static bool isValidStringList(List<String> sList) =>
      sList != null && (sList.isEmpty || isValidUidStringList(sList));

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
  static String uidRootType(String uidString) => kUidRootType[uidString.codeUnitAt(0)];

  /// Returns a [list<Uid>] of [Uid] generated from random [Uuid]s.
  static List<Uid> randomList(int length) {
  	final uList = new List<Uid>(length);
    for (var i = 0; i < length; i++) uList[i] = new Uid();
    return uList;
  }

  /// Returns a [Uid] [String] generated from random [Uuid]s.
  static String randomString() => generateSecureUidString();
}
