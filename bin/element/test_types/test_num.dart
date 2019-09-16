//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:math';
import 'dart:typed_data';

import 'package:core/core.dart';

Logger log = Logger('test_double', Level.info0);
void main() {
  const n = 1.1;
  const m = 1;

  final x = numToString(n);
  print('x: $x');
  final y = numToString(m);
  print('y: $y');

  test(1000, 500000);
}

final List<Object> doubleList = [1.1, 2.2, 3.3];
final List<num> goodList = [1.1, 2, 3.3];
final List<Object> badList = [1.1, 2, '"3.3"'];
const List<Object> doubleList0 = [1.1, 2.2, 3.3];
const List<num> goodList0 = [1.1, 2, 3.3];
const List<Object> badList0 = [1.1, 2, '"3.3"'];

String numToString(num v) {
  if (num is double) return floatToString(v);
  if (num is int) return dec32(v);
  return null;
}

void test(int length, int loops) {
  final rng = Random(0);
  double getFloat(int i) => rng.nextDouble();
  int getInt(int i) => rng.nextInt(2 << 31);

  final test0 = List<double>.generate(length, getFloat);
  final test1 = List<int>.generate(length, getInt);
  final test2 = test0.map((v) => v + 1.0);
  final test3 = test1.map((v) => v + 1);
  final test4 = Float64List.fromList(test0);
  final tests = [test0, test1, test2, test3, test4];

  log.info0('Coerce Test: List length: ${test0.length}');
  var good0 = isListDoubleType(goodList);
  var good1 = isIterableDouble(goodList);
  log
    ..debug('    testList Type@4: ${goodList.runtimeType}')
    ..debug('    testList isListDoubleType@4: $good0')
    ..debug('    testList isListDouble@4: $good1');

  final times = <List<Duration>>[];
  final timer = Timer();
  for (var i = 4; i < functions.length; i++) {
    log.info0('\nCoerce $i: start');
    final loopTimes = <Duration>[];
    final start = timer.elapsedMicroseconds;
    for (var j = 0; j < tests.length; j++) {
      _checkList = false;
      _coerceList = false;
      log.info0('  Test $j:');
      final v = testCoerce(tests[j], loops, functions[i]);
      final time = timer.split;
      loopTimes.add(time);
      log.info('checkList: $_checkList coerceList: $_coerceList');
      good0 = isListDoubleType(v);
      good1 = isIterableDouble(v);
      log
        ..debug('    coerce1 testList Type@4: ${v.runtimeType}')
        ..debug('    coerce1 goodList->v isListDoubleType@4: $good0')
        ..debug('    coerce1 goodList->v isListDouble@4: $good1')
        ..info0('    time: $time');
    }
    final end = timer.elapsedMicroseconds;
    final elapsed = Duration(microseconds: end - start);

    loopTimes.add(elapsed);
    times.add(loopTimes);
    log.info0('  Elapsed: $loopTimes');
  }
  timer.stop();
  for (var i = 0; i < times.length; i++) log.info0('  $i: ${times[i]}');
  log.info0('Total: ${timer.elapsed}');
}

final List<Function> functions = [
  coerceToDouble1, coerceToDouble2, coerceToDouble3,
  coerceToDouble4, coerceToDouble5, coerceToDouble6 // No reformat
];

List<double> testCoerce(
    Iterable<num> vList, int loops, List<double> Function(Iterable<num> v) f) {
  List<double> v;
  try {
    for (var i = 0; i < loops; i++) v = f(vList);
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    print('@1 $e');
  }
  return v;
}

bool isListDoubleType(List v) => v is List<double>;

bool isIterableDouble(Iterable<num> vList) {
  print('isIterableDouble: ${vList.runtimeType}');
  for (final v in vList) if (v is! double) return false;
  return true;
}

List<double> coerceToDouble1(Iterable vList) => List<double>.generate(
    vList.length, (i) => vList.elementAt(i).toDouble());

//Very Slow
List<double> coerceToDouble2(Iterable vList) {
  if (vList is Float64List || vList is Float32List) return vList;
  final dList = List<double>(vList.length);
  for (var i = 0; i < dList.length; i++) {
    double v = vList.elementAt(i);
    if (v is! double) {
      if (v is num) {
        v = v.toDouble();
      } else {
        print('@3 Invalid double(${v.runtimeType}): $v');
        throw TypeError();
      }
    }
    dList[i] = v;
  }
  return dList;
}

List<double> coerceToDouble3(Iterable vList) {
  if (vList is Float64List || vList is Float32List) return vList;
  final dList = (vList is! List) ? vList.toList() : <double>[]
    ..length = vList.length;
  for (var i = 0; i < dList.length; i++) {
    double v = vList.elementAt(i);
    if (v is! double) {
      if (v is num) {
        v = v.toDouble();
      } else {
        print('@3 Invalid double(${v.runtimeType}): $v');
        throw TypeError();
      }
    }
    dList[i] = v;
  }
  return dList;
}

List<double> coerceToDouble4(Iterable vList) {
  if (vList is Float64List || vList is Float32List) return vList;
  final List<num> v1 = (vList is! List) ? vList.toList(growable: false) : vList;
  final dList = List<double>(vList.length);
  for (var i = 0; i < v1.length; i++) {
    var v = v1[i];
    if (v is! double) {
      if (v is num) {
        v = v.toDouble();
      } else {
        print('@4 Invalid double(${v.runtimeType}): $v');
        throw TypeError();
      }
    }
    dList[i] = v;
  }
  return dList;
}

bool _checkList;
bool _coerceList;

List<double> coerceToDouble5(Iterable<num> vList) {
  if (vList is Float64List || vList is Float32List) return vList;
  return (vList is List<double>)
      ? _checkListDouble0(vList)
      : _coerceList0(vList);
}

List<double> coerceToDouble6(Iterable<num> vList) {
  if (vList is Float64List || vList is Float32List) return vList;
  return (vList is List<double>)
      ? _checkListDouble1(vList)
      : _coerceList1(vList);
}

List<double> _checkListDouble0(List<num> vList) {
  _checkList = true;
  for (var i = 0; i < vList.length; i++) {
    if (vList[i] is! double) return _coerceList0(vList);
  }
  return vList;
}

List<double> _checkListDouble1(List<num> vList) {
  _checkList = true;
  for (var i = 0; i < vList.length; i++) {
    if (vList[i] is! double) return _coerceList1(vList);
  }
  return vList;
}

List<double> _coerceList0(Iterable<num> vList) {
  _coerceList = true;
  final List<num> v1 = (vList is! List) ? vList.toList(growable: false) : vList;
  final dList = Float64List(vList.length);
  for (var i = 0; i < vList.length; i++) {
    final v = v1[i];
    dList[i] = (v is double) ? v : _coerce(v);
  }
  return dList;
}

List<double> _coerceList1(Iterable<num> iter) {
  _coerceList = true;
  final dList = Float64List(iter.length);
  for (var i = 0; i < iter.length; i++) {
    final v = iter.elementAt(i);
    dList[i] = (v is double) ? v : _coerce(v);
  }
/*   var i = 0;
   for(var v in iter) {
   	dList[0] = (v is double) ? v : _coerce(v);
   	i++;
   }*/
  return dList;
}

double _coerce(num v) => (v is num) ? v.toDouble() : throw TypeError();
