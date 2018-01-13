// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/element_list/element_list.dart';
import 'package:core/src/dataset/element_list/history.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/system/system.dart';

//  create MapAsList
//  create some Elements
//  insert and remove and compare for identity (identical(a, b)
//
//  create a second ElementList
//  insert same elements in both list
//  compare for equality and hashCode
//  compare list.keys and list.elements for equality
//
//  confirm that removeAt and copy work.

/// The default initial size of an Element [List].
// TODO: update this number so that it handles 80% of Datasets without need to grow
const int defaultSize = 200;

/// An [ElementList] implemented using a [Map].
class MapAsList extends ElementList<int> {
  /// A [Map] from key to [Element].
  Map<int, Element> eMap;

  MapAsList([Dataset dataset, List<SQ> sequences, History history])
      : eMap = <int, Element>{},
        super(dataset, sequences, history);

  MapAsList.from(MapAsList map, [Dataset dataset])
      : eMap = new Map.from(map.eMap),
        super(dataset ??= map.dataset, new List.from(map.sequences),
            new History.from(map.history));

 //Flush when above is working
  @override
  bool operator ==(Object other) {
    if (other is MapAsList) {
      final length = eMap.length;
      if (length != other.eMap.length) return false;
      final keysA = eMap.keys.iterator;
      final keysB = other.eMap.keys.iterator;

      for (var i = 0; i < length; i++) {
        keysA.moveNext();
        keysB.moveNext();
        if (keysA.current != keysB.current) {
//        	print('A = ${keysA.current}');
//	        print('B = ${keysB.current}');
	        return false;
        }
      }

      final valuesA = eMap.values.iterator;
      final valuesB = other.eMap.values.iterator;
      for (var i = 0; i < length; i++) {
        valuesA.moveNext();
        valuesB.moveNext();
        if (valuesA.current != valuesB.current) return false;
      }
      return true;
    }
    return false;
  }

  @override
  Element operator [](int index) => lookup(index);

  @override
  Element lookup(int index, {bool required = false}) {
  	final e = eMap[index];
  	if (e == null && required == true) return invalidElementIndex(index);
  	return e;
  }

  @override
  void operator []=(int index, Element e) => eMap[e.index] = e;

/*
  @override
  bool operator ==(Object other) =>
		  (other is MapAsList) ? _equality.equals(eMap, other.eMap) : false;
*/

  @override
  int get hashCode => system.hasher.nList(eMap.values);

  @override
  Iterable<Element> get elements => eMap.values;

  @override
  Element elementAt(int index) => eMap.values.elementAt(index);

  @override
  List<Element> get elementsList => elements.toList();

  @override
  Iterable<int> get keys => eMap.keys;

  @override
  List<int> get keysList => keys.toList();

  @override
  int get length => eMap.length;

  @override
  set length(int length) {}

  @override
  String get info {
    final sb = new StringBuffer('$this:\n');
    for (var e in eMap.values) sb.write('  $e\n');
    return sb.toString();
  }

  /// Removes the [Element] with key from _this_.
  @override
  Element removeAt(int index, {bool required = false}) => eMap.remove(index);

  @override
  MapAsList copy([Dataset dataset]) => new MapAsList.from(this, dataset);

  @override
  String toString() => '$elementsList';

 // static const MapEquality<int, Element> _equality = const MapEquality();
}
