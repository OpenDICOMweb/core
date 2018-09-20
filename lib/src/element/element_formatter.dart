//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/element.dart';

// ignore_for_file: public_member_api_docs

const int kDefaultTruncatedValuesLength = 5;

abstract class ElementFormatter {
  /// The maximum number of values to print when an [Element]'s values
  /// are printed by [toString].
  int truncatedValuesLength;

  /// If _true_ the result includes some representation of e.values;
  /// otherwise, only e.values.length will be represented.
  bool _withValues;
  bool debugMode = false;

  ElementFormatter._(this.truncatedValuesLength, this._withValues);

  bool get includeValues => _withValues;
  String get vflName => 'vfLength';

  String code(Element e) => e.dcm;

  String keyword(Element e) {
    final t = e.tag;
    return (t == null) ? '*Unknown Tag*' : t.keyword;
  }

  String vr(Element e) => '${e.vrId}';

  String vm(Element e, int length) {
    if (e.isLengthAlwaysValid) return 'vm(1)';
    final max = (e.vmMax == -1) ? 'N' : '${e.vmMax}';
    return 'vm(${e.vmMin}_$max)';
  }

  String tag(Element e, int vLength) {
    final ret = (e.isRetired) ? '*retired* ' : '';
    return '${e.dcm} ${keyword(e)} ${vr(e)} ${vm(e, vLength)} $ret';
  }

  String vfLength(Element e) => _vfLength(e.vfLength);

  String _vfLength(int vfLength) {
    assert(vfLength != null || vfLength >= 0);
    return '$vflName: $vfLength';
  }

  /// Returns [values] in [List] format.
  String _valuesList(Iterable values) => '[${values.join(', ')}]';

  /// Returns a truncated values list
  String _truncatedList(Iterable values, int max) {
    assert(values.length > max);
    final vList = values.take(max);
    return '[${vList.join(', ')}...]';
  }

  String values(Element e, [int maxValues = kDefaultTruncatedValuesLength]) =>
      _values(e.values, maxValues);

  String _values(Iterable values, [int max = kDefaultTruncatedValuesLength]) =>
      (values.length <= max)
          ? _valuesList(values)
          : _truncatedList(values, max);

  String asString(Element e, {int maxValues, bool simple, bool withValues}) {
    maxValues ??= truncatedValuesLength;
    if (e == null) return 'null';
    final vfLength = e.vfLength;
    assert(vfLength != null || vfLength >= 0);
    final values = e.values;
    final vLength = values.length;

    final name = debugMode ? '$runtimeType' : '';
    final sb = StringBuffer(name)
      ..write(tag(e, vLength))
      ..write(_vfLength(vfLength))
      ..write(_values(values, maxValues));
    return '$sb';
  }
}

/// A formatter the allows different [String] representations of [Element]s.
class SimpleElementFormatter extends ElementFormatter {
  /// If _true_ a simple representation is returned.
  bool simple;

  SimpleElementFormatter({
    int truncatedValuesLength = kDefaultTruncatedValuesLength,
    bool withValues = true,
  }) : super._(truncatedValuesLength, withValues);

  void _valuesToSB(StringBuffer sb, Element e, [int max]) {
    if (!_withValues || e.values.isEmpty) return;

    final values = e.values;
    assert(values != null);
    max ??= truncatedValuesLength;
    final length = values.length;
    final vLength = (e.hasValidLength) ? '' : '-*Invalid Length*';
    final valid = (e.hasValidValues) ? '' : '*Bad Values*';
    final vList = (length > max) ? values.take(max) : values;
    sb.write('$valid($length$vLength)[${vList.join(', ')}]');
  }
}

/// A formatter to use when debugging [Element]s. Output format if valid is:
///     `(gggg,xxxx) keyword vr vmMin<= values.length <= vmMax ?*retired*
/// otherwise,
///     '
///
class DebugEFormatter extends ElementFormatter with ByteElementMixin {
  DebugEFormatter({
    int truncatedValuesLength = kDefaultTruncatedValuesLength,
    bool withValues = true,
  }) : super._(truncatedValuesLength, withValues);

  @override
  String get vflName => 'vfl';
  @override
  String get vlfName => 'vlf';

  @override
  String tag(Element e, int vLength) {
    final ret = (e.isRetired) ? '*retired*' : '';
    return '${e.dcm} ${keyword(e)} ${vr(e)} ${vm(e, vLength)} $ret';
  }

  @override
  String vr(Element e) => '${e.vrId}(${e.vrIndex})';

  @override
  String vm(Element e, int length) {
    if (e.isLengthAlwaysValid) return 'vm(1<=$length<=N)';
    final max = (e.vmMax == -1) ? 'N' : '${e.vmMax}';
    return 'vm(${e.vmMin}<=$length<=$max)';
  }

  void _valuesToSB(StringBuffer sb, Element e, [int max]) {
    if (!_withValues || e.values.isEmpty) return;

    max ??= truncatedValuesLength;
    final values = e.values;
    assert(values != null);
    final length = values.length;
    final vLength = (e.hasValidLength) ? '' : '-*Invalid Length*';
    // TODO: fix later
//    final valid = (e.hasValidValues) ? '' : '*Bad Values*';
    const valid = '';
    final vList = (length > max) ? values.take(max) : values;
    sb.write('$valid($length$vLength)[${vList.join(', ')}]');
  }

  @override
  String asString(Element e, {int maxValues, bool simple, bool withValues}) {
    maxValues ??= truncatedValuesLength;
    final vfLength = e.vfLength;
    assert(vfLength != null || vfLength >= 0);
    final values = e.values;
    final vLength = values.length;

    final sb = StringBuffer('$runtimeType: ')
      ..write(tag(e, vLength))
      ..write(_vfLength(vfLength));
    _valuesToSB(sb, e, maxValues);
    return '$sb';
  }
}

abstract class ByteElementMixin {
  String get vlfName => 'vfLengthField';

  String vfLengthField(int vfLengthField) => (vfLengthField == null)
      ? ''
      : (vfLengthField == 0xFFFFFFFF)
          ? 'kUndefineLength'
          : '$vlfName: $vfLengthField';
}

class HtmlElementFormatter extends SimpleElementFormatter {}
