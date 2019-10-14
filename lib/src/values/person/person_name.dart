//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:collection/collection.dart';
import 'package:constants/constants.dart';
import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/utils.dart';

// ignore_for_file: public_member_api_docs

/// The DICOM PersonName Types
enum PersonNameType { alphabetic, ideographic, phonetic }

//TODO: rewrite for correctness
/// A DICOM Person Name (VR = PN)
///
/// A [PersonName] is a String containing three [Name]s, which are
/// separated by the '=' character.
/// There are potentially three different Component Groups, which are
/// called [Name]s in a [PersonName]: [alphabetic], [ideographic],
/// and [phonetic].
///
/// Each Part can have up to five components: familyName, givenName,
/// middleName, prefix, and suffix.
///
/// Each Component Group of the PersonName has a maximum of 64 characters,
/// including delimiters ('=', '^'), which cannot include the US-ASCII
/// backslash ('\').  Each component after the first is separated from
/// the next component by the character '^'.
///
/// PersonNames as [String] has a canonical form in DICOM, which is:
///     'family^given^middle^prefix^suffix'.
///
/// [See PS3.5](http://dicom.nema.org/medical/dicom/
/// current/output/html/part05.html).
///
class PersonName {
  /// An equality function for List<Name>.
  static const ListEquality eq = ListEquality<Name>();
  final List<Name> groups;

  /// Create a new DICOM [PersonName].
  PersonName(this.groups);

  /// Create a PersonName from an ordered [List] of name components.
  factory PersonName.fromString(String s) {
    final list = splitTrim(s, '=');
    final groups = list.map((e) => Name.fromString(e));
    return PersonName(groups.toList(growable: false));
  }

  /// Checks the Equality (deep) of two [PersonName]s.
  @override
  bool operator ==(Object pn) =>
      pn is PersonName && eq.equals(groups, pn.groups);

  @override
  int get hashCode => global.hasher.nList(groups);

  Name get alphabetic => groups[0];

  Name get ideographic => groups[1];

  Name get phonetic => groups[2];

  /// Returns a DICOM formatted [PersonName].
  String get dcm => groups.map((e) => e.dcm).join('=');

  String get initials => alphabetic.initials;

  //TODO: is this ok for ACR
  // It does not exactly follow the ACR's algorithm.
  String toHashCode(int maxLength) {
    final s = alphabetic.hashCode.toRadixString(10);
    return s.substring(0, maxLength);
  }

  @override
  String toString() => dcm;

  // **** Static Methods *****

  /// Returns true if the [PersonName] component is valid.
  static bool isValidList(List<String> list) {
    assert(list != null && list.length == 3);
    return list.fold(true, (t, e) => t && Name.isValidString(e));
  }

  /// Returns true if the [PersonName] component is valid.
  static bool isValidString(String s) {
    assert(s != null && s != '');
    return isValidList(s.split('='));
  }

  /// Parses a PersonName [String] composed of up to three Component Groups,
  /// and if successful, returns it; otherwise, returns _null_.
  // ignore: prefer_constructors_over_static_methods
  static PersonName parse(String s) {
    if (s == null || s == '') return null;
    // Parse a PersonName
    final cGroups = splitTrim(s, '=');
    if (cGroups.isEmpty || cGroups.length > 3) return null;
    final names = <Name>[];
    for (final cg in cGroups) {
      final name = Name.parse(cg);
      if (name == null) return null;
      names.add(name);
    }
    final pn = PersonName(names);
    return (pn == null) ? null : pn;
  }
}

/// A [Name] corresponds to a DICOM Person Name (PN) Component Group.
/// A Components is a list of PN component [String]s. It may have from
/// one to five components.  The list may not contain _null_, so interior
/// elements that have no values are represented by the empty [String] ('').
///
/// For Example the following are valid:
/// ['Philbin', 'Jim', 'F', 'Dr.', 'II']
/// ['Philbin', 'Jim', 'F']
/// ['Philbin', '', 'F']
/// But these are not valid:
/// /// ['Philbin', null, 'F', 'Dr.', 'II']
///  ['Philbin', 'Jim', 'F', null]
class Name {
  static const int maxComponents = 5;
  static const int maxSeparators = 4;
  static const int maxGroupLength = 64;

  /// An equality function for List<String>.
  static const ListEquality eq = ListEquality<String>();
  final List<String> components;

  Name(Iterable<String> names)
      : components = (names is List) ? names : names.toList(growable: false);

  factory Name.fromString(String s) {
    final names = splitTrim(s, '^');
    for (final name in names) {
      if (!_isPNComponentGroup(name)) return null;
    }
    return Name(names.toList(growable: false));
  }

  const Name._(this.components);

  static const Name empty = Name._(<String>[]);

  @override
  bool operator ==(Object other) =>
      (other is Name) && eq.equals(components, other.components);

  @override
  int get hashCode => global.hash(components);

  /// Family name.
  String get family => _getComponent(0);

  /// Given or first name.
  String get given => _getComponent(1);

  /// Middle name(s) or initial(s)
  String get middle => _getComponent(2);

  /// A [prefix] such as Ms., Mr., Mrs., Dr...
  String get prefix => _getComponent(3);

  /// A [suffix] such as Ph.D., or M.D.
  String get suffix => _getComponent(4);

  String _initial(String s) => (s == null || s == '') ? '' : s[0];
  String get initials =>
      '${_initial(given)}${_initial(middle)}${_initial(family)}'.toUpperCase();

  String get dcm => '${components.join('^')}';

  /// Returns an informational [String] for this [Name].
  String get info => '$runtimeType: $dcm';

  //TODO: is this the right format?
  /// Returns a [Name] (PN Component Group) in DICOM order.
  @override
  String toString() => '$components';

  /// Returns true if the [PersonName] component is valid.
  static bool isValidList(List<String> list) {
    if (list == null || list.isEmpty || list.length > 5) return false;
    for (final s in list)
      if (!_filteredTest(s, _isPNComponentGroupChar)) return false;
    return true;
  }

  /// The filter for DICOM PersonName characters.  Visible ASCII
  /// characters, except Backslash(\) and Equal Sign(=).
  static bool _isPNComponentGroupChar(int c) =>
      c >= kSpace && c < kDelete && (c != kBackslash && c != kEqual);

  static bool isValidComponentGroup(String s) {
    if (s == null || s == '' || s.length > maxGroupLength) return false;
    final groups = s.split('=');
    for (final group in groups) {
      if (group.length > 64 || !_filteredTest(group, _isPNNameChar))
        return false;
    }
    return true;
  }

  //TODO: these are taken from VRString
  /// Returns _true_ if all characters pass the filter.
  static bool _filteredTest(String s, bool Function(int) filter) {
    for (var i = 0; i < s.length; i++)
      if (!filter(s.codeUnitAt(i))) return false;
    return true;
  }

  /// Returns true if the [PersonName] component is valid.
  static bool isValidString(String s) {
    assert(s != null && s != '');
    return s.length <= maxGroupLength && _hasValidNameChars(s);
  }

  /// Parses a Component Group into a [Name]
  // ignore: prefer_constructors_over_static_methods
  static Name parse(String s,
      {int start = 0,
      int end,
      Issues issues,
      PersonName Function(String) onError}) {
    if (s == null || s == '' || s.length > 64 || !_filteredTest(s, _isPNChar))
      //TODO: return invalidPersonNameString(s)
      return null;
    //  final groups = splitTrim(s, '^')..forEach(_isPNComponentGroup);
    return Name.fromString(s.trim());
  }

  /// Return the ith component or _null_ if [i] is not a valid [List] index.
  String _getComponent(int i) =>
      (i >= 1 && i < components.length) ? components.elementAt(i) : null;
}

/// The filter for DICOM String characters.
/// Visible ASCII characters, except Backslash.
bool _isPNChar(int c) =>
    c >= kSpace && c < kDelete && c != kBackslash && c != kEqual;

bool _isPNComponentGroup(String s) => _filteredTest(s, _isPNNameChar);

/// Returns _true_ if all characters pass the filter.
bool _filteredTest(String s, bool Function(int) filter) {
  if (s.isEmpty || s.length > 64) return false;
  for (var i = 0; i < s.length; i++) {
    if (!filter(s.codeUnitAt(i))) return false;
  }
  return true;
}

bool _isPNNameChar(int c) => _isPNChar(c) && c != kEqual;

/// Returns _true_ if all characters pass the filter.
bool _hasValidNameChars(String s) {
  for (var i = 0; i < s.length; i++) {
    if (!_isPNNameChar(s.codeUnitAt(i))) return false;
  }
  return true;
}
