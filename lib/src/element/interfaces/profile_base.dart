//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/entity/instance.dart';
import 'package:core/src/profile/profile.dart';
import 'package:core/src/tag.dart';

/// Profile Terminology
///
/// Tag
///     A [Tag] is a semantic identifier for an [Element]. It has the
///     following properties: code, keyword, name, VR, VM, isRetired, and
///     EType.  The EType depends on the IOD of its containing Dataset.
///
/// Element
///     An Element is a DICOM Data Element. It has a Tag and a List of
///     values.
///
/// _Valid_ Element
///     An Element is _valid_ if it satisfies: 1) the VR and VM of its Tag,
///     and 2) the [EType] of the containing IOD; otherwise, it is _invalid_.
///
/// Dataset
///     A [Dataset] is a container for a set of Elements where each has a
///     unique [Tag].
///

/// [ProfileBase] defines the minimum interface that any ODW class
/// implementing a [Profile] must support.
abstract class ProfileBase<V> {
  static const List kEmptyList = <dynamic>[];

  /// **** Element Methods ****

  /// The namespace of the Profile. It maps _identifiers_ to _values_.
  Map<String, dynamic> get namespace;

  /// The [Dataset] that is being [Profile]d.
  Dataset get original;

  /// The [Dataset] that results from applying _this_ to [original].
  Dataset get result;

  /// Returns an _empty_ [List].
  List<V> get emptyList => kEmptyList;

  /// Returns the value associated with [identifier] in [namespace].
  /// The returned value must be of [Type]: [int], [double], or [String].
  ///
  /// If [identifier] is not valid, an [InvalidIdentifier] [Error] is
  /// thrown.
  ///
  /// If [namespace] has no key that matches [identifier], then an
  /// [UnknownIdentifier] [Error] is thrown.
  V lookup(String identifier);

  // Alternative to [lookup];
  V operator [](String identifier);

  /// Sets the value of [identifier] in [namespace].
  ///
  /// If [namespace] has no key that matches [identifier], then an an
  /// [UnknownIdentifier] [Error] is thrown.
  ///
  /// If [identifier] is not a valid _identifier_, an [InvalidIdentifier]
  /// [Error] is thrown.
  void update(String identifier, Object value);

  // Alternative to [update];
  void operator []=(String identifier, V value);

  /// Returns the value associated with [rowKey] and [columnKey] in
  /// [Database] [db].
  ///
  /// If [db] is unknown or unavailable throws an appropriate(?) [Error].
  ///
  /// If [db] does not contain a row with [rowKey], an [UnknownRow] [Error]
  /// is thrown.
  ///
  /// If the row corresponding to [rowKey] does not contain a column with
  /// [columnKey], an [UnknownColumn] [Error] is thrown.
  ///
  V dbLookup(Database db, String rowKey, String columnKey);

  /// Updates the entry in [db] associated with [rowKey] and [columnKey]
  /// with [value].
  ///
  /// If [db] is unknown or unavailable throws an appropriate [Error].
  ///
  /// If [db] does not contain a row with [rowKey], an [UnknownRow] [Error]
  /// is thrown.
  ///
  /// If the _row_ with [rowKey] does not contain a column with [columnKey], an
  /// [UnknownColumn] [Error] is thrown.
  ///
  bool dbUpdate(Database db, String rowKey, String columnKey, V value);

  /// Returns _true_ if the [Instance] being profiled contains a _valid_
  /// [Element] with [tag]; otherwise, returns _false_.
  ///
  /// This method ensures that if the [original] [Dataset] contains a _valid_
  /// [Element] with [tag], then the [result] [Dataset] _will_ contain the
  /// original [Element] unmodified.
  ///
  /// If [original] contains no element with [tag] and [tag] has eType == 1,
  /// 1c, 2, or 2c, where the condition is satisfied; then a Missing Element
  /// Error should be thrown.
  ///
  /// If [original] contains an element with [tag], but with values that are
  /// invalid, then an Invalid Element Error should be thrown.
  ///
  /// If while processing the [Profile] an attempt is made to [remove] or
  /// modify an element marked _keep_, then an [InvalidElementAccess](?) Error
  /// should be thrown.
  ///
  /// If [tag] is not valid an [InvalidTag] [Error] is thrown.
  ///
  bool keep(int tag);

  /// Ensures that an [Element] with [tag] and [EType] != 1, contained in
  /// the [original] is _not_ contained in [result]. Returns the removed
  /// [Element], if present; otherwise, returns _null_.
  ///
  /// If [tag] is not valid an [InvalidTag] [Error] is thrown.
  ///
  /// _Note_: Elements with an [EType] != 3 are not removed from [result].
  ///
  Element remove(int tag);

  /// Modifies the value of the [Element] with [tag] to the [emptyList].
  /// Return the [Element]'s original value. If [original] contains no
  /// [Element] with [tag] _null_ is returned.
  ///
  /// If [tag] is not valid an [InvalidTag] [Error] is thrown.
  ///
  List<V> empty(int tag);

  /// Returns the [values] of the [Element] in [original] with [tag].
  ///
  /// If [original] contains no [Element] with [tag] an UnknownElement [Error]
  /// is thrown.
  ///
  /// If [tag] is not valid an [InvalidTag] [Error] is thrown.
  ///
  List<V> values(int tag);

  /// Requires that a _valid_ [Element] with [tag] is contained in the [result].
  ///
  /// If an [Element] with [tag] is present in [original], but has no value,
  /// it is given a value of [emptyList].
  ///
  /// If an [Element] with [tag] is present in [original], but is not _valid_,
  /// an [InvalidElement] [Error] is thrown.
  ///
  /// If a _valid_ [Element] with [tag] is present in [original], and [vList]
  /// is provided, an new [Element] with [tag] is created with [vList] as its
  /// value, and is added to [result].
  ///
  /// If no [Element] with [tag] is contained in [original], then:
  ///     - if [EType] == 1 or if [EType] == 1c and the condition is satisfied,
  ///       then a [MissingElement](?) [Error] is thrown.
  ///     - otherwise; an [Element] with [tag] is created with a [value] of
  ///       [emptyList], and is added to [result].
  ///
  /// If [tag] is not valid an [InvalidTag] [Error] is thrown.
  ///
  /// If [vList] is not valid for [tag], an [InvalidValues] [Error] is thrown.
  ///
  bool require(int tag, [List<V> vList = kEmptyList]);

  /// Takes the [Element] with [tag] in [original], and updates its values
  /// with [vList]. Returns the original values of the [Element].
  ///
  /// If [original] contains no [Element] with [tag] and [vList] is valid
  /// for [tag], a new [Element] containing [tag] and [vList]  is created,
  /// and added to [result].
  ///
  /// If [tag] is not valid an [InvalidTag] [Error] is thrown.
  ///
  /// If [vList] is not valid for [tag], an [InvalidValues] [Error] is thrown.
  ///
  List<V> replace(int tag, List<V> vList);

  /// Takes the [values] of the [Element] with [tag] in [original], and
  /// encrypts it using [key]. A new [Element] containing [tag] and the
  /// encrypted values is added to [result]. Returns the original [values].
  ///
  /// If the [Element] with [tag] has an _empty_ value, then the [Element]
  /// is added to [result].
  ///
  /// Returns _null_ if [original] contains no [Element] with [tag].
  ///
  /// If [tag] is not valid an [InvalidTag] [Error] is thrown.
  ///
  List<V> encrypt(int tag, V key);

  // **** Global Methods ****

  /// Ensures that [result] contains no private [Element]s that were not
  /// marked _keep_.
  void removePrivate();

  /// Ensures that [result] contains no [Element]s with a [Tag] in [group]
  /// that were not marked _keep_.
  void removeGroup(int group);

}

abstract class Database {
  // Alternative to [lookup];
  dynamic operator [](String identifier);

  // Alternative to [update];
  void operator []=(String identifier, Object value);
}

class InvalidTag extends Error {}

class InvalidIdentifier extends Error {}
class UnknownIdentifier extends Error {}

class InvalidValues extends Error {}

class UnknownRow extends Error {}
class UnknownColumn extends Error {}

class InvalidElement extends Error {}
class UnknownbElement extends Error {}
class InvalidElementAccess extends Error {}
class MissingElement extends Error {}




