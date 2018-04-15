//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/base.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';

// Note: PrivateData Elements are just regular [Element]s
abstract class ElementTagMixin<V> {
  Element<V> get e;
  bool get wasUN;

  int get sgIndex => tag.sgNumber;

  PrivateTag get tag => e.tag;

  @override
  bool operator ==(Object other) =>
      other is PrivateElementMixin && e == other.e;

  List<V> get emptyList => e.emptyList;
  @override
  int get hashCode => e.hashCode;

  bool get isKnown => tag.isKnown;
  int get group => e.tag.group;
  //Why are these 3 necessary
  int get code => tag.code;
  String get keyword => tag.keyword;
  int get vrIndex => tag.vrIndex;
  int get vrCode => tag.vrCode;
  VM get vm => tag.vm;
  int get sizeInBytes => tag.elementSize;

  int get vfLengthField => e.vfLengthField;
  Iterable<V> get values => e.values;

  bool get isPrivate => true;

  int get padChar => e.padChar;

  Element get sha256 => e.sha256;

  TypedData get typedData => e.typedData;

  Bytes get vfBytes => e.vfBytes;

  ByteData get vfByteData => e.vfByteData;

/* TODO: uncomment when fast_tag implemented
  int get deIdIndex => e.deIdIndex;
  int get ieIndex => e.ieIndex;
*/

  bool checkValues(Iterable<V> vList, [Issues issues]) =>
      e.checkValues(vList, issues);

  PrivateElementMixin<V> view([int start = 0, int end]) =>
      throw new UnimplementedError();
}

// Note: PrivateData Elements are just regular [Element]s
abstract class PrivateElementMixin<V> {
  Element<V> get e;
  bool get wasUN;

  int get sgIndex => tag.sgNumber;

  PrivateTag get tag => e.tag;

  @override
  bool operator ==(Object other) =>
      other is PrivateElementMixin && e == other.e;

  List<V> get emptyList => e.emptyList;
  @override
  int get hashCode => e.hashCode;

  bool get isKnown => tag.isKnown;
  int get group => e.tag.group;
  //Why are these 3 necessary
  int get code => tag.code;
  String get keyword => tag.keyword;
  int get vrIndex => tag.vrIndex;
  int get vrCode => tag.vrCode;
  VM get vm => tag.vm;
  int get sizeInBytes => tag.elementSize;

  int get vfLengthField => e.vfLengthField;
  Iterable<V> get values => e.values;

  bool get isPrivate => true;

  int get padChar => e.padChar;

  Element get sha256 => e.sha256;

  TypedData get typedData => e.typedData;

  Bytes get vfBytes => e.vfBytes;

  ByteData get vfByteData => e.vfByteData;

  bool checkValues(Iterable<V> vList, [Issues issues]) =>
      e.checkValues(vList, issues);

  PrivateElementMixin<V> view([int start = 0, int end]) =>
      throw new UnimplementedError();
}

class PrivateCreator extends LO with PrivateElementMixin<String> {
  @override
  final PCTag tag;
  @override
  final Element<String> e;
  @override
  final bool wasUN;

  PrivateCreator(this.tag, this.e, {this.wasUN});

  @override
  List<String> get values => e.values;
  @override
  set values(Iterable<String> vList) => e.values = vList;

  int get base => tag.base;
  int get limit => tag.limit;
  String get token => e.value;

  @override
  PrivateCreator update([Iterable<String> vList]) => e.update(vList);

  bool inSubgroup(int pdCode) => (tag.elt >= base) && (tag.elt <= limit);

  @override
  String toString() => '$runtimeType${tag.dcm} ${tag.name}';
}
