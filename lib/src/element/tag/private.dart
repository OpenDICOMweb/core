// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/private.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/tag/string.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/tag/export.dart';
import 'package:core/src/vr/vr.dart';


// Note: PrivateData Elements are just regular [Element]s
class PrivateTagElement<V> extends PrivateElement<V> with TagElement<V> {
  /// Create a [PrivateElement]
  PrivateTagElement(this.e, {this.wasUN = false});

  @override
  Iterable<V> get values => e.values;
  @override
  set values(Iterable<V> vList) => unsupportedError('PrivateElementTag.values');
  @override
  int get sizeInBytes => e.sizeInBytes;
  @override
  String get vrKeyword => e.vrKeyword;
  @override
  String get vrName => e.vrName;
  @override
  int get maxLength => e.maxLength;
  @override
  int get maxVFLength => e.maxVFLength;
  @override
  Element<V> e;
  @override
  bool wasUN;

//  @override
//  VR get vr => unimplementedError();

  @override
  bool checkValue(V v, {Issues issues, bool allowInvalid = false}) =>
      e.checkValue(v, issues: issues, allowInvalid: allowInvalid);

  @override
  PrivateTagElement<V> update([Iterable<V> vList]) =>
		  unsupportedError('PrivateIllegalElementTag.replace');

  @override
  PrivateTagElement<V> updateF(Iterable<V> f(Iterable<V> vList)) =>
		  unsupportedError('PrivateIllegalElementTag.replace');
}

class IllegalPrivateTagElement<V> extends PrivateTagElement<V> {
  IllegalPrivateTagElement(Element e, {bool wasUN}) : super(e, wasUN: wasUN);
}

class TagPrivateCreator extends LOtag {
  LOtag e;
  final Map<int, Element> pData = <int, Element>{};

  factory TagPrivateCreator(Element e, {bool wasUN}) =>
      (e is LOtag) ? new TagPrivateCreator._(e, e.vrIndex == kUNIndex) :
      invalidElementError(e);

  factory TagPrivateCreator.phantom(int code) {
    const values = const <String>['Phantom Private Creator'];
    final pcIndex = Elt.fromTag(code) >> 8;
    final pcCode = (code << 16) + pcIndex;
    final tag = new PCTagUnknown(pcCode, kLOIndex, 'Phantom Private Creator');
    final e = new LOtag(tag, values);
    return new TagPrivateCreator(e);
  }

  TagPrivateCreator._(Element e, [bool wasUN = false]) :
        super.internal(e.tag, e.values);

  @override
  int get maxVFLength => e.maxVFLength;
}
