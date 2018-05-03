//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:collection';
import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/src/value/empty_list.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element/base/errors.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/hash.dart';
import 'package:core/src/vr_base.dart';
import 'package:core/src/vr.dart';

/// The base class for DICOM Data Elements
///
/// An implementation of this class must provide the following:
///   1. An implementation of a List<V> of values, where V is
///      one of [double], [int], [String], or [Item].
///
///   2. An implementation of a TypeData Getter typedData.
///

// TODO: the following typedefs should be replaced with the new
//       inline Type declarations
/// The Type of a Method or Function that takes an Element and returns
/// a [bool].
typedef bool ElementTest(Element e);

typedef bool Condition(Dataset ds, Element e);

Iterable<V> _toList<V>(Iterable v) =>
    (v is Iterable) ? v.toList(growable: false) : v;

bool doTestValidity = true;

// All add, replace, and remove operations should
// be done by calling add, replace, and remove methods in [Dataset].

/// The base class for DICOM Data Elements. The [Type] variable [V]
/// is the [Type] of the [values] of the [Element].
abstract class Element<V> extends ListBase<V> {
  // **** Interface

  /// Returns the identifier ([index]), used to locate
  /// the Attributes associated with this Element.
  int get index;

  /// Returns the Tag Code ([code]) associated with this Element
  int get code;

  /// Returns the _keyword_ associated with this Element.
  String get keyword;

  /// Returns the _name_ associated with this Element.
  String get name;

  // **** VR related Getters ****

  /// The index ([vrIndex]) of the Value Representation for this Element.
  int get vrIndex;

  /// The _minimum_ length of a non-empty Value Field for this Element.
  int get vmMin;

  /// The _maximum_ length of a non-empty Value Field for this Element.
  int get vmMax;

  /// The _rank_ or _width_, i.e. the number of columns in the
  /// Value Field for this Element. _Note_: The Element values
  /// length must be a multiple of this number.
  int get vmColumns;

  /// The Element Type index of this Element.
 // int get eTypeIndex;

  /// The Information Entity index of this Element.
  //  int get ieIndex;

  /// The DeIdentification Method index for this Element.
  //  int get deIdIndex;

  /// The Information Entity level of this Element.
 // String get ieLevel;

  /// Returns true if _this_ is a Data Element defined by the DICOM Standard.
  bool get isPublic;

  /// _true_ if this Element has been retired, i.e. is no longer
  /// defined by the current DICOM Standard.
  bool get isRetired;

  /// Returns the [Iterable<V>] [values] of _this_.
  Iterable<V> get values;
  set values(Iterable<V> vList);

  /// Returns the canonical empty list for [V] ([List<V>[]]).
  List<V> get emptyList;



  // **** End of Interface

  /// Returns the Value Representation (VR) integer code [vrCode] for _this_.
  int get vrCode => vrCodeByIndex[vrIndex];

  /// Returns the [Tag] that corresponds to this [code].
  ///
  /// _Note_: If the [code] is private (i.e. odd) then an either an
  /// [PCTagUnknown] or [PDTagUnknown] will be returned. This should be
  /// overridden whenever possible.
  Tag get tag => Tag.lookupByCode(code);

  /// The actual length in bytes of the Value Field. It does
  /// not include any padding characters.
  int get vfLength => values.length * sizeInBytes;

  /// The start of an element in and encoding.
  int get eStart => -1;

  /// The end of an element in and encoding.
  int get eEnd => -1;

  /// Returns _true_ if [value] is valid for _this_.
  bool checkValue(V v, {Issues issues, bool allowInvalid = false});

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

  // The Tag Code Group of _this_.
  int get group => code >> 16;

  // The Tag Code Group as a hexadecimal [String].
  String get groupHex => hex16(group);

  // The Tag Code Element ([elt]) of _this_.
  int get elt => code & 0xFFFF;

  // The Tag Code Element ([elt]) as a hexadecimal [String].
  String get eltHex => hex16(elt);

  /// Returns _true_ if this is a _Group Length_ [Element].
  /// Group Length [Element]s have codes in the format (gggg,0000).
  /// _Note_: Group Length [Element]s are _retired_, but they appear
  /// in many existing DICOM Datasets.
  bool get isGroupLength => elt == 0;

  /// Returns true if _this_ is Data [Element] defined by an implementation.
  bool get isPrivate => group.isOdd && group > 0x0007 && group < 0xFFFF;

  bool get isPrivateCreator => isPrivate && (elt >= 0x10 && elt < 0xFF);

  /// Returns the creator token for _this_.
  /// _Note_: This Getter MUST be overridden for [PrivateTag]s.
  String get creator => 'DICOM';

  // ****** Value Representation related Getters and Methods ******
  // **************************************************************

  /// The size in bytes of the Value Field Length field.
  int get vlfSize => vr.vlfSize;

  VR get vr => vrByIndex[vrIndex];
  String get vrId => vr.id;

  /// The name of the Value Representation (VR) for _this_.
  String get vrKeyword => 'k${vr.id}';

  /// The name of the Value Representation (VR) for _this_.
  String get vrName => vrNameByIndex[vrIndex];

  /// The [vrCode] as a hexadecimal [String].
  String get vrHex => '0x${hex16(vrCode)}';

  /// The number of bytes in one value.
  int get sizeInBytes => vr.sizeInBytes;

  /// The maximum Value Field length in bytes for this Element.
  int get maxVFLength => vr.maxVFLength;

  /// Returns _true_ for OB, OD, OF, OL, OW, SQ, UN, and UR, which
  /// MUST override this Getter; otherwise, false.
  bool get isLengthAlwaysValid => false;

  // ******* Value Multiplicity related Getters and Methods *******
  // **************************************************************

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

  int get rows => length ~/ columns;

  // ****** Element Type Interface, Getters, and Methods ******
  // **************************************************************

  /// The Element Type of this Element.
  EType get eType => tag.eType;

  /// The Element Type predicate of this Element.
  Condition get eTypePredicate => unimplementedError();

  // ********** Value Field related Getters and Methods ***********
  // **************************************************************

  /// The Value Length field value, that is, the 32-bit [int]
  /// contained in the Value Field of _this_. If the returned value
  /// is 0xFFFFFFFF ([kUndefinedLength]), it means the length of
  /// the Value Field was undefined.
  ///
  /// _Note_: [kUndefinedLength] may only appear in VRs of OB, OW, SQ,
  /// and UN Elements (and in Item [Dataset]s). _This method MUST
  /// be overridden for those elements.
  int get vfLengthField => vfLength;

  /// Returns _false_ for all Elements except SQ, OB, OW, and UN.
  /// Items are also allowed to have undefined length.
  bool get isUndefinedLengthAllowed => false;

  /// _true_ if this [Element] had an undefined length token in the
  /// Value Length field. It may only be true for OB, OW, SQ, and
  /// UN Elements.
  bool get hadULength => vfLengthField == kUndefinedLength;

  // ************* Values related Getters and Methods *************
  // **************************************************************
  // ****Note: This should be implemented at the
  // Integer/Float/String/Sequence level.

  /// The maximum number of values for this element;
  int get maxLength;

  @override
  V operator [](int i) => values.elementAt(i);

  @override
  void operator []=(int i, V v) =>
      throw new UnsupportedError('Elements are immutable');

  /// Returns the number of [values] of _this_.
  @override
  int get length {
    if (values == null) return nullValueError();
    return  values.length;
  }

  @override
  set length(int n) => throw new UnsupportedError('Elements are immutable');

  /// The length in bytes of [values].
  int get lengthInBytes => values.length * sizeInBytes;

  /// Returns a single value from a [List] with [length] == 1.
  V get value {
    if (length != 1) {
      log.warn('Invalid value access: $this has ${values.length} values');
      if (length == 0) return null;
    }
    return values.first;
  }

  /// Returns a copy of [values].
  // *Note*: This Getter could be using [growable]: [false].
  Iterable<V> get valuesCopy => new List.from(values);

  /// Returns [values] encoded as an [TypedData]. The subtype of [TypedData]
  /// depends on the VR.
  TypedData get typedData;

  /// Returns [values] encoded as [ByteData].
  ByteData get vfByteData =>
      (checkValues(values)) ? typedData.buffer.asByteData() : null;

  /// Returns [values] encoded as a [Bytes].
  Bytes get vfBytes =>
      (checkValues(values)) ? new Bytes.typedDataView(typedData) : null;

  String get vfBytesAsAscii => vfBytes.getAscii();

  List<String> get vfBytesAsAsciiList => vfBytes.getAsciiList();

  String get vfBytesAsUtf8 => cvt.utf8.decode(vfBytes, allowMalformed: true);

  List<String> get vfBytesAsUtf8List =>
      cvt.utf8.decode(vfBytes, allowMalformed: true).split('\\');

  /// Returns _true_ if [vList] has a valid [length] for _this_.
  /// [vList] defaults to [values].
  bool checkLength([Iterable<V> vList, Issues issues]) {
    vList ??= values;
    if (isLengthAlwaysValid) return true;
    final length = vList.length;
    return (length == 0) ||
        (length >= minValues && length <= maxValues && (length % columns == 0));
  }

  /// Returns _true_ if [values] are valid for _this_.
  bool checkValues(Iterable<V> vList, [Issues issues]) {
    final ok = checkLength(vList, issues);
    if (!ok) return ok;
    for (var v in vList)
      if (!checkValue(v, issues: issues)) {
        invalidValuesError(vList, issues: issues);
        return false;
      }
    return true;
  }

  bool valuesEqual(Element<V> other) => vListEqual<V>(values, other.values);

  // ************ Element related Getters and Methods *************
  // **************************************************************

  /// _true_ if VR is valid for _this_.
  bool get hasValidVR => tag.vrIndex == vrIndex;

  /// Returns _true_ if [values].length is valid for _this_.
  bool get hasValidLength => checkLength(values);

  // Note: this SHOULD NOT be implemented by any subclasses
  /// Returns _true_ if all [values] are valid for _this_.
  bool get hasValidValues => checkValues(values);

  @override
  bool operator ==(Object other) => equal(this, other);

  /// Returns a [hashCode] for _this_.
  @override
  int get hashCode => Hash64.k2(tag, Hash64.list(values));

  /// Returns a copy of _this_ with an empty [values] [List].
  Element<V> get noValues => update(emptyList);

  /// Returns a copy of _this_, but with each [value] replaced by
  /// a hash of that value but with the same type, i.e. if value had
  /// [Type] [int] the hashed [value] will have [Type] [int].
  Element get hash => sha256;

  /// Returns a copy of _this_, but with [values] replaced by
  /// a [List] where each [value] has been replaced with a
  /// Digest containing its SHA-256 hash.
  Element get sha256 => throw new UnimplementedError();

  /// Returns a copy of _this_, but with [values] replaced by
  /// a [List] where each [value] has been replaced with an
  /// AES-DCM encryption of the initial [value].
  Element get encrypted => throw new UnimplementedError();

  /// Returns a copy of _this_, but with [values] replaced by
  /// a [List] where each [value] has been replaced with a
  /// AES-DCM decryption of the initial encrypted [value].
  Element get decrypted => throw new UnimplementedError();

  /// Returns the total number of [Element]s in _this_.
  /// _Note_: Sequence (SQ) overrides this Getter.
  int get total => 1;

  Issues get issues {
    Issues result;
    if (tag is PTagInvalidVR)
      (result ?? _getIssues()).add('Invalid VR for $tag');
    checkLength(values, result ?? _getIssues());
    checkValues(values, result ?? _getIssues());
    return result;
  }

  Issues _getIssues() => new Issues('$this\n  $values');

  String get asString => toString();

  String get info {
    final v = values;
    if (v == null) return nullElementError();
    List<V> vList = _toList<V>(values);
    vList = (vList.length > 10) ? vList.sublist(0, 10) : values;
    final s = '(${vList.length})${vList.map((v) => '$v')}';
    return '$runtimeType$dcm: $s';
  }

  // **** Methods

  /// _true_ if the [Element] is valid.
  bool get isValid => hasValidVR && hasValidLength && hasValidValues;

  /// Returns a copy of _this_ with [values] [f]([values]).
  Element updateF(Iterable<V> f(Iterable<V> vList)) => update(f(values));

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  Iterable<V> replace([Iterable<V> vList]) {
    vList ??= <V>[];
    final old = values;
    values = vList;
    return old;
  }

  /// Replace the current [values] with the result of [f([values]])],
  /// and return the original [values]. This method modifies the [Element].
  Iterable<V> replaceF(Iterable<V> f(Iterable<V> vList)) => replace(f(values));

  /// Returns a copy of _this_.
  Element<V> get copy => update(valuesCopy);

  int counter(ElementTest test) => test(this) ? 1 : 0;

  /// Returns a formatted [String] representation of _this_.
  // String format(Formatter z) => '${z(info)}\n';
  // String format(Formatter z) => z.fmt(this, elements);

  bool doFancy = false;
  bool withValues = true;

  @override
  String toString() =>
      (doFancy) ? _toFancyString(withValues) : _toStringWithValues();

  String _toFancyString(bool withValues) =>
      '$runtimeType$_tag $_vfLength $_values()';

  String _toStringWithValues() =>
      '$runtimeType: $_tag vlf: $vfLength ${_values()}';

  String toSimpleString() => '$runtimeType $_tag vlf: $vfLength';

  // **** These are local methods for [toString]
  String get _keyword {
    final t = tag;
    return (t == null) ? '*Unknown Tag*' : t.keyword;
  }
  String get _vr => '$vrId($vrIndex)';
  String get _vmMax => (vmMax == -1) ? 'N' : '$vmMax';
  String get _vm => (isLengthAlwaysValid)
      ? 'vm(1<= $_vfLength <=N'
      : 'vm($vmMin<= $_vfLength <=$_vmMax)';
  String get _tag => '$dcm $_keyword $_vr $_vm';

  String get _vfLength {
    final _vfLength = vfLength;
    final _vflf = vfLengthField;
    assert(_vfLength != null || _vfLength != -1);
    final _vfl = 'vfl: $_vfLength';
    if (_vflf == null) return _vfl;
    final s = (_vflf == 0xFFFFFFFF) ? 'kUndefineLength' : 'vlf: $_vflf';
    return '$s, $_vfl';
  }

  /// The maximum number of values to print when an [Element]'s values
  /// are printed by [toString].
  static int truncatedValuesLength = 5;

  String _values([int max]) {
    if (!withValues) return '';
    assert(values != null);
    max ??= truncatedValuesLength;
    final length = values.length;
    final vLength = (hasValidLength) ? '' : '-*Invalid Length*';
    final valid = (hasValidValues) ? '' : '*Bad Values*';
    final vList = (length > max) ? values.take(max) : values;
    return '$valid($length$vLength)[${vList.join(', ')}]';
  }

  String getValuesAsString([int max]) => _values(max);

  // **** End of local methods for [toString]

  // ***************** Static Getters and Methods *****************
  // **************************************************************
  static bool equal<V>(Element<V> a, Element<V> b) =>
      identical(a, b) || (a.tag == b.tag && vListEqual<V>(a.values, b.values));

  static bool vListEqual<V>(Iterable<V> a, Iterable<V> b) =>
      identical(a, b) || (a.length == b.length && _vListEqual(a, b));

  static bool _vListEqual<V>(Iterable<V> aList, Iterable<V> bList) {
    final a = aList.iterator;
    final b = bList.iterator;
    while (a.moveNext()) {
      b.moveNext();
      if (a.current != b.current) return false;
    }
    return true;
  }

  static bool isValidVListLength<V>(
      Tag tag, Iterable<V> vList, Issues issues, int maxLength) {
    assert(tag != null && vList != null);
    if (tag.isLengthAlwaysValid || vList.isEmpty) return true;
    final length = vList.length;
    if (length >= tag.vmMin &&
        (length <= tag.vmMax || (tag.vmMax == -1 && length <= maxLength)) &&
        (length % tag.vmColumns == 0)) return true;
    invalidValuesLengthError(tag, vList, issues);
    return false;
  }

  static bool isNotValidVListLength<V>(
          Tag tag, Iterable<V> vList, Issues issues, int maxLength) =>
      !isValidVListLength(tag, vList, issues, maxLength);
}
