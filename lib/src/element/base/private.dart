// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/logger/formatter.dart';
import 'package:core/src/tag/tag_lib.dart';

// Note: PrivateData Elements are just regular [Element]s
abstract class PrivateElement<V> extends Element<V> {
	Element<V> get e;
	bool get wasUN;

  /// Create a [PrivateElement]
//  PrivateElement(this.e, {this.wasUN = false}) : super(e.tag);

  @override
  bool operator ==(Object other) => other is PrivateElement && e == other.e;

  @override
	Iterable<V> get emptyList => e.emptyList;
  @override
  int get hashCode => e.hashCode;
  @override
  Tag get tag => e.tag;
	bool get isKnown => tag.isKnown;
	@override
	int get group => e.tag.group;
  //Why are these 3 necessary
  @override
  int get code => tag.code;
  @override
  String get keyword => tag.keyword;
  @override
  int get vrIndex => tag.vrIndex;
  @override
  int get vrCode => tag.vrCode;
  @override
  VM get vm => tag.vm;
  @override
  int get sizeInBytes => tag.elementSize;
  @override
  Iterable<V> get values => e.values;

  @override
  bool get isPrivate => true;

  @override
  int get padChar => e.padChar;

  @override
  Element get sha256 => e.sha256;

	@override
	TypedData get typedData => e.typedData;

/* Flush if not needed
  @override
  Uint8List get vfBytesWithPadding => e.vfBytesWithPadding;
*/

  @override
  Uint8List get vfBytes => e.vfBytes;

/* Flush if not needed
  @override
  ByteData get vfByteDataWithPadding => e.vfByteDataWithPadding;
*/

  @override
	ByteData get vfByteData => e.vfByteData;

  @override
	bool checkValues([Iterable<V> vList, Issues issues]) =>
			e.checkValues(vList, issues);

	@override
	PrivateElement<V> update([Iterable<V> vList]) => e.update(vList);

	@override
	PrivateElement<V> updateF(Iterable<V> f(Iterable<V> vList)) => e.updateF(f);

  PrivateElement<V> view([int start = 0, int end]) => throw new UnimplementedError();
}

abstract class PrivateIllegal<V> extends PrivateElement<V> {
  //PrivateIllegal(Element e) : super(e);

 // K get key;
}

abstract class PrivateCreator extends LO {
  final Map<int, PrivateElement> pData = <int, PrivateElement>{};

  int get sgIndex => tag.elt;
  PCTag get pcTag => tag;
  int get base => pcTag.base;
  int get limit => pcTag.limit;
  String get token => value;

  bool inSubgroup(int pdCode) {
    final pdIndex = Elt.fromTag(pdCode);
    //log.debug('isSubgroup: base: ${Elt.hex(base)}, limit: ${Elt.hex(limit)}');
    return pdIndex >= base && pdIndex <= limit;
  }

  void addData(PrivateElement pd) => pData[pd.code] = pd;

  Element lookupData(int code) => pData[code];

  @override
  String format(Formatter z) {
    final sb = new StringBuffer('${z(this)}\n');
    z.down;
    sb.write(z(pData.values));
    z.up;
    return sb.toString();
  }

  @override
  String toString() => '$runtimeType${tag.dcm} ${tag.name}: ${pData.length} pData';
}
