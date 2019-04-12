//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/dataset.dart';
import 'package:core/src/element/element_formatter.dart';
import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/hash.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values.dart';
import 'package:core/src/vr/vr_base.dart';
import 'package:core/src/vr/vr_external.dart';

/// The base class for DICOM Data Elements
///
/// An implementation of this class must provide the following:
///   1. An implementation of a List<V> of values, where V is
///      one of [double], [int], [String], or [Item].
///
///   2. An implementation of a TypeData Getter typedData.
///

/// The Type of a Method or Function that takes an Element and returns a [bool].
typedef ElementTest = bool Function(Element e);

/// The Type signature of a condition handler.
typedef Condition = bool Function(Dataset ds, Element e);

/// Returns a formatter for _this_.
final ElementFormatter eFormat = SimpleElementFormatter();

// All add, replace, and remove operations should
// be done by calling add, replace, and remove methods in [Dataset].

/// The base class for DICOM Data Elements. The [Type] variable [V]
/// is the [Type] of the [values] of the [Element].
abstract class Element<V> extends ListBase<V> {
  // **** Interface

  @override
  List<V> toList({bool growable = true});

  /// Returns the [values] of _this_.
  List<V> get values => (_values == null) ? nullValueError() : _values;

  List<V> _values;

  /// Sets [values] to [v]. If [v] is [Iterable] it is first
  /// converted into a fixed length [List] and then assigned to [values].
  set values(Iterable<V> v) =>
      _values = (v is List) ? v : v.toList(growable: false);

  /// Returns the Tag Code ([code]) associated with this Element
  int get code;

  /// The actual length in bytes of the Value Field. It does
  /// not include any padding characters.
  int get vfLength;

  /// The length in bytes of [values].
  int get lengthInBytes;

  /// Returns the [Bytes] encoding for _this_.
  Bytes get bytes => unimplementedError();

  /// Returns the [json] encoding for _this_.
  String get json => unimplementedError();

  /// Returns the [xml] encoding for _this_.
  String get xml => unimplementedError();

  /// Encapsulated Pixel Data Fragments.
  VFFragmentList get fragments => unimplementedError();

  /// Pixel Data Basic Offset Table.
  Uint32List get offsets => unimplementedError();

  /// Pixel Data Frames if Multi-Frame.
  Iterable<Frame> get frames => unimplementedError();

  /// Returns a [Uint8List] containing the encoded [values] of _this_.
  // Urgent: convert this to Bytes.
  Uint8List get bulkdata;

  // **** End of Interface

  /// Returns the ith value of _this_.
  @override
  V operator [](int i) => values[i];

  /// Unsupported
  @override
  void operator []=(int i, V v) =>
      throw UnsupportedError('Elements are immutable');

  /// Returns true if _this_ and _other_ have a [tag] and [values] that
  /// are equal ([==]).
  @override
  bool operator ==(Object other) => equal(this, other);

  /// Returns a [hashCode] for _this_.
  @override
  int get hashCode => Hash64.k2(code, Hash64.list(values));

  /// Returns the number of [values] of _this_.
  @override
  int get length {
    if (values == null) return nullValueError();
    return values.length;
  }

  @override
  set length(int n) => throw UnsupportedError('Elements are immutable');

  /// Returns a single values from a [List] with [length] == 1.
  V get value {
    if (length != 1) {
      log.warn('Invalid values access: $this has ${values.length} values');
      if (length == 0) return nullValueError();
    }
    return values[0];
  }

  /// Returns a copy of [values].
  // *Note*: This Getter could be using [growable]: [false].
  Iterable<V> get valuesCopy => List.from(values);

  /// Returns the canonical empty list for [V] ([List<V>[]]).
  Iterable<V> get emptyList => const [];

  /// The [index] of the [Element] Definition for _this_.
  int get index => code;

  /// Returns the [Tag] that corresponds to this [code].
  ///
  /// _Note_: If the [code] is private (i.e. odd) then an either an
  /// [PCTagUnknown] or [PDTagUnknown] will be returned. This should be
  /// overridden whenever possible.
  Tag get tag => Tag.lookupByCode(code);

  /// Returns the _keyword_ associated with this Element.
  String get keyword => tag.keyword;

  /// Returns the _name_ associated with this Element.
  String get name => tag.name;

  // **** VR related Getters ****

  /// The index ([vrIndex]) of the Value Representation for this Element.
  /// Since this depends on the [tag], the [vrIndex] might be
  /// [kUNIndex] for Private [Element]s.
  int get vrIndex {
    final vrIndex = tag.vrIndex;
    if (isSpecialVRIndex(vrIndex)) {
      log.debug('Using kUNIndex for $tag');
      return kUNIndex;
    }
    return vrIndex;
  }

  /// Returns true if _this_ is a Data Element defined by the DICOM Standard.
  bool get isPublic => code.isEven;

  /// _true_ if this Element has been retired, i.e. is no longer
  /// defined by the current DICOM Standard.
  bool get isRetired => tag.isRetired;

  /// Returns the Value Representation (VR) integer code [vrCode] for _this_.
  int get vrCode => vrCodeByIndex[vrIndex];

  /// The start of an element in and encoding.
  int get eStart => -1;

  /// The end of an element in and encoding.
  int get eEnd => -1;

  /// Returns a copy of _this_ with [values] replaced by [vList].
  Element<V> update([Iterable<V> vList]) => unsupportedError();

  // **** end Interface

  // ********* Tag Identifier related interface, Getters, and Methods
  // **************************************************************
  // **** Some of these Getters may be accessed directly in the element.

  // Copied from system package to avoid name conflict
  /// Returns a DICOM Tag code in the format (gggg,eeee), where
  /// _g_ and _e_ are hexadecimal characters.
  String get dcm {
    final c = code;
    assert(c >= 0 && c <= 0xFFFFFFFF, 'code: $c');
    return '(${hex16(c >> 16)},${hex16(c & 0xFFFF)})';
  }

  /// Returns a DICOM Tag code as a hexadecimal integer.
  String get hex {
    final c = code;
    return '${hex32(c)}';
  }

  /// _true_ if [code] is a File Meta Information Tag Code.
  bool get isFMI {
    final c = code;
    return c >= 0x00020000 && c <= 0x00020102;
  }

  /// The Tag Code Group of _this_.
  int get group => code >> 16;

  /// The Tag Code Group as a hexadecimal [String].
  String get groupHex => hex16(group);

  /// The Tag Code Element ([elt]) of _this_.
  int get elt => code & 0xFFFF;

  /// The Tag Code Element ([elt]) as a hexadecimal [String].
  String get eltHex => hex16(elt);

  /// Returns _true_ if this is a _Group Length_ [Element].
  /// Group Length [Element]s have codes in the format (gggg,0000).
  /// _Note_: Group Length [Element]s are _retired_, but they appear
  /// in many existing DICOM Datasets.
  bool get isGroupLength => elt == 0;

  /// Returns true if _this_ is Data [Element] defined by an implementation.
  bool get isPrivate => group.isOdd && group > 0x0007 && group < 0xFFFF;

  /// Returns true if _this_ is a Private Creator.
  bool get isPrivateCreator => isPrivate && (elt >= 0x10 && elt < 0xFF);

  /// Returns the creator token for _this_.
  /// _Note_: This Getter MUST be overridden for [PrivateTag]s.
  String get creator => 'DICOM';

  // ****** Value Representation related Getters and Methods ******
  // **************************************************************

  /// The size in bytes of the Value Field Length field.
  int get vlfSize => vr.vlfSize;

  /// Returns the Value Representation [VR] of _this_.
  VR get vr => vrByIndex[vrIndex];

  /// Returns the identifier associated with the [tag]'s [VR].
  String get vrId => vr.id;

  /// The name of the Value Representation (VR) for _this_.
  String get vrKeyword => 'k${vr.id}';

  /// The name of the Value Representation (VR) for _this_.
  String get vrName => vrNameByIndex[vrIndex];

  /// The [vrCode] as a hexadecimal [String].
  String get vrHex => '0x${hex16(vrCode)}';

  // The number of bytes in one values.
//  int get sizeInBytes => vr.sizeInBytes;

  /// The maximum Value Field length in bytes for this Element.
  int get maxVFLength => vr.maxVFLength;

  /// Returns _true_ for OB, OD, OF, OL, OW, SQ, UN, and UR, which
  /// MUST override this Getter; otherwise, false.
  bool get isLengthAlwaysValid;

  // ******* Value Multiplicity related Getters and Methods *******
  // **************************************************************

  /// The _minimum_ number of Values for this Element.
  int get vmMin => tag.vmMin;

  /// The _maximum_ number of Values for this Element.
  int get vmMax => tag.vmMax;

  /// The _rank_ or _width_, i.e. the number of columns in the
  /// Value Field for this Element. _Note_: The Element values
  /// length must be a multiple of this number.
  int get vmColumns => tag.vmColumns;

  /// The maximum number of values for this element;
  int get maxLength;

  /// The Value Multiplicity ([vm]) for this Element.
  VM get vm => tag.vm;

  /// The minimum number of values that MUST be present for _this_,
  /// if any values are present.
  int get minValues => vmMin;

  /// The maximum number of values allowed for _this_.
  int get maxValues {
    if (vmMax != -1) return vmMax;
    final n = maxLength - (maxLength % vmColumns);
    assert(n % vmColumns == 0);
    return n;
  }

  /// The number of columns in the [values] array. If [columns] is
  /// greater than 1, the number of [values] must be an integer
  /// multiple of [columns]
  int get columns => vmColumns;

  /// The number of rows in the [values] array. If [columns] is
  /// greater than 1, the number of [values] must be an integer
  /// multiple of [columns]
  int get rows => length ~/ columns;

  // ****** Element Type Interface, Getters, and Methods ******
  // **************************************************************

  /// The Element Type of this Element.
  EType get eType => tag.eType;

  /// The Element Type Index of this Element.
  int get eTypeIndex => tag.type.index;

  /// The Element Type predicate of this Element.
  Condition get eTypePredicate => unimplementedError();

  // ********** Value Field related Getters and Methods ***********
  // **************************************************************

  /// The Value Length field values, that is, the 32-bit [int]
  /// contained in the Value Field of _this_. If the returned values
  /// is 0xFFFFFFFF ([kUndefinedLength]), it means the length of
  /// the Value Field was undefined.
  ///
  /// _Note_: [kUndefinedLength] may only appear in VRs of OB, OW, SQ,
  /// and UN Elements (and in Item [Dataset]s). _This method MUST
  /// be overridden for those elements.
  int get vfLengthField => vfLength;

  /// Returns _true_ if [vfLengthField] == [kUndefinedLength].
  bool get hadULength => vfLengthField == kUndefinedLength;

  /// Returns _false_ for all Elements except SQ, OB, OW, and UN.
  /// Items are also allowed to have undefined length.
  bool get isUndefinedLengthAllowed => false;

  // ************* Values related Getters and Methods *************
  // **************************************************************
  // ****Note: This should be implemented at the
  // Integer/Float/String/Sequence level.

  /// Returns [values] encoded as an [TypedData]. The subtype of [TypedData]
  /// depends on the VR.
  TypedData get typedData;

  /// Returns [values] encoded as [ByteData].
  ByteData get vfByteData => (checkValues(values))
      ? typedData.buffer
          .asByteData(typedData.offsetInBytes, typedData.lengthInBytes)
      : null;

  /// Returns [values], including any required padding, encoded as a [Bytes].
  // Note: Always Bytes not DicomBytes
  Bytes get vfBytes =>
      (checkValues(values)) ? Bytes.typedDataView(typedData) : null;

  /// Converts [vfBytes] to an ASCII [String] and returns it.
  String get vfBytesAsAscii => vfBytes.getAscii();

  /// Converts [vfBytes] to a [List<String>] of ASCII [String]s and returns it.
  Iterable<String> get vfBytesAsAsciiList => vfBytes.getAsciiList();

  /// Converts [vfBytes] to a UTF8 [String] and returns it.
  String get vfBytesAsUtf8 => utf8.decode(vfBytes, allowMalformed: true);

  /// Converts [vfBytes] to a [List<String>] of UTF8 [String]s and returns it.
  Iterable<String> get vfBytesAsUtf8List =>
      utf8.decode(vfBytes, allowMalformed: true).split('\\');

  /// Returns _true_ if [vrIndex] is valid for _this_.
  bool checkVR(int vrIndex, [Issues issues]) {
    if (vrIndex == tag.vrIndex) return true;
    if (issues != null) issues.add('Invalid VR($vrIndex): $this');
    return false;
  }

  /// Returns _true_ if [vList] has a valid [length] for _this_.
  /// [vList] defaults to [values].
  bool checkLength([Iterable<V> vList, Issues issues]) {
    vList ??= values;
    if (isLengthAlwaysValid || allowInvalidNumberOfValues) return true;
    final length = vList.length;
    return (length == 0) ||
        (length >= minValues && length <= maxValues && (length % columns == 0));
  }

  /// Returns _true_ if [vList] is valid for _this_.
  bool checkValues(Iterable<V> vList, [Issues issues]) {
    final ok = checkLength(vList, issues);
    if (!ok) return false;
    for (var i = 0; i < vList.length; i++) {
      if (!checkValue(vList.elementAt(i), issues: issues))
        return invalidValues(vList, issues);
    }
    return true;
  }

  /// Returns _true_ if _this_ is valid. If [issues] is non-_null_ messages
  /// are added to it.
  bool check([Issues issues]) =>
      checkVR(vrIndex, issues) &&
      checkLength(values, issues) &&
      checkValues(values, issues);

  /// Returns _true_ if [values] is valid for _this_.
  bool checkValue(V v, {Issues issues, bool allowInvalid = false});

  /// Returns _true_ if the [values] of _this_ are equal to the [values] of
  /// [other].
  bool valuesEqual(Element<V> other) => vListEqual(values, other.values);

  // ************ Element related Getters and Methods *************
  // **************************************************************

  /// _true_ if VR is valid for _this_.
  bool get hasValidVR => tag.vrIndex == vrIndex;

  /// Returns _true_ if [values].length is valid for _this_.
  bool get hasValidLength => checkLength(values);

  // Note: this SHOULD NOT be implemented by any subclasses
  /// Returns _true_ if all [values] are valid for _this_.
  bool get hasValidValues => checkValues(values);

  /// Returns a copy of _this_ with an empty [values] [List].
  Element<V> get noValues => update(emptyList);

  /// Returns a copy of _this_, but with each [values] replaced by
  /// a hash of that values but with the same type, i.e. if values had
  /// [Type] [int] the hashed [values] will have [Type] [int].
  Element get hash => sha256;

  /// Returns a copy of _this_, but with [values] replaced by
  /// a [List] where each [values] has been replaced with a
  /// Digest containing its SHA-256 hash.
  Element get sha256 => throw UnimplementedError();

  /// Returns a copy of _this_, but with [values] replaced by
  /// a [List] where each [values] has been replaced with an
  /// AES-DCM encryption of the initial [values].
  Element get encrypted => throw UnimplementedError();

  /// Returns a copy of _this_, but with [values] replaced by
  /// a [List] where each [values] has been replaced with a
  /// AES-DCM decryption of the initial encrypted [values].
  Element get decrypted => throw UnimplementedError();

  /// Returns the total number of [Element]s in _this_.
  /// _Note_: Sequence (SQ) overrides this Getter.
  int get total => 1;

  /// Returns an [Issues] associated with the [values] of _this_.
  Issues get issues {
    Issues result;
    if (tag is PTagInvalidVR)
      (result ?? _getIssues()).add('Invalid VR for $tag');
    checkLength(values, result ?? _getIssues());
    checkValues(values, result ?? _getIssues());
    return result;
  }

  Issues _getIssues() => Issues('$this\n  $values');

  /// Returns a [String] representation of _this_.
  String get asString => toString();

  /// Returns a [String] containing information about _this_.
  String get info {
    var v = values;
    if (v == null) return nullElement();
    v = (v.length > 10) ? v.sublist(0, 10) : values;
    final s = '(${v.length})${v.map((v) => '$v')}';
    return '$runtimeType$dcm: $s';
  }

  // **** Methods

  /// _true_ if the [Element] is valid.
  bool get isValid => hasValidVR && hasValidLength && hasValidValues;

  /// Returns a copy of _this_ with [values] [f]([values]).
  Element updateF(Iterable<V> f(List<V> vList)) => update(f(values));

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  List<V> replace([Iterable<V> vList]) {
    vList ??= <V>[];
    final old = values;
    values = vList;
    return old;
  }

  /// Replace the current [values] with the result of [f([values]])],
  /// and return the original [values]. This method modifies the [Element].
  List<V> replaceF(List<V> f(List<V> vList)) => replace(f(values));

  /// Returns a copy of _this_.
  Element<V> get copy => update(valuesCopy);

  /// Returns a formatted [String] representation of _this_.
  // String format(Formatter z) => '${z(info)}\n';
  // String format(Formatter z) => z.fmt(this, elements);

  @override
  String toString() => eFormat.asString(this);

  // ***************** Static Getters and Methods *****************
  // **************************************************************

  /// Returns _true_ if [a] is equal to [b].
  static bool equal(Element a, Element b) =>
      identical(a, b) || (a.tag == b.tag && vListEqual(a.values, b.values));

  /// Returns _true_ if the [values] of [a] are equal to the [values] of [b].
  static bool vListEqual(Iterable a, Iterable b) =>
      identical(a, b) || (a.length == b.length && _vListEqual(a, b));

  static bool _vListEqual(Iterable aList, Iterable bList) {
    final a = aList.iterator;
    final b = bList.iterator;
    while (a.moveNext()) {
      b.moveNext();
      if (a.current != b.current) return false;
    }
    return true;
  }

  /// Returns _true_ if [tag].vrIndex is equal to [targetVR],
  /// which MUST be a valid _VR Index_. Typically, one of the
  /// constants (k_XX_Index) is used.
  static bool isValidTag(Tag tag, Issues issues, int targetVR, Type type) =>
      (doTestElementValidity &&
          tag.vrIndex != targetVR &&
          invalidTag(tag, issues, type)) ||
      true;

  /// Returns _true_ is [vList] has a valid length for [tag].
  static bool isValidLength<V>(Tag tag, Iterable<V> vList, Issues issues,
      int maxLengthForVR, Type type) {
    if (tag == null) return invalidTag(tag, issues, type);
    if (vList == null) return nullValueError();
    // TODO: change this when Element type is known
    if (vList.isEmpty || allowInvalidVMs || tag.isLengthAlwaysValid)
      return true;
    final min = tag.vmMin;
    final max = tag.vm.max(maxLengthForVR);
    final length = vList.length;
    if (length >= min && length <= max && (length % tag.columns) == 0) {
      return true;
    } else {
      return invalidValuesLength(vList, min, max, issues, tag);
    }
  }

  /// Returns _true_ is [vList] does not have a valid length for [tag].
  static bool isNotValidLength<V>(Tag tag, Iterable<V> vList, Issues issues,
          int maxLength, Type type) =>
      !isValidLength(tag, vList, issues, maxLength, type);
}
