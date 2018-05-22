//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/core.dart';

void main(){
  final rng = new RNG(0);

  final bd = new ByteData(10);
  final foo  = base64Test(bd);
  print('foo: $foo');
  ByteData bar;
  final foo1  = base64Test(bar);
  print('foo1: $foo1');

  const loop0Count = 10;
  for(var i = 0; i <= loop0Count; i++) {
    final d = rng.nextDouble;
    final x = rng.nextInt();
    final s = floatToString(x * d);
    if (s.length > 16)
      print('*** (${s.length})"$s"');
  }

  const loop1Count = 10;
  for(var i = 0; i< loop1Count; i++) {
    final dList = rng.listOfDouble();
    print('$i: dList: $dList');
    final sList = floatListToDSList(dList);
      print('$i: sList: $sList');
  }

  const loop2Count = 1000;
  for(var i = 0; i< loop2Count; i++) {
    final dList = rng.listOfDouble();
    print('$i: dList: $dList');
    final sList = randomListOfDouble(dList);
    print('$i: sList: $sList');
  }
}

List base64Test(ByteData bd) {
  print('bytes: $bd');
  return bd?.buffer?.asUint8List();
}


/// the same length as _this_.
Iterable<String> randomListOfDouble(List<double> dList) {
  final length = dList.length;
  final rList = new List<double>(length);
  for (var i = 0; i < length; i++) rList[i] = Global.rng.nextDouble();
  return rList.map(floatToString);
}

String floatToString(double v) {
  const precision = 10;
  var s = v.toString();
  if (s.length > 16) {
    s = v.toStringAsPrecision(precision);
    if (s.length > 16) {
      for (var i = precision; i > 0; i--) {
        s = v.toStringAsPrecision(i);
        if (s.length <= 16) break;
      }
    }
  }
  assert(s.length <= 16, '"$s" exceeds max DS length of 16');
  return s;
}


Iterable<String> floatListToDSList(Iterable<double> vList) {
  print('length0: ${vList.length}');
  final hashList = Sha256.float64(vList).map(floatToString);
  print('length1: ${hashList.length}');
  assert(vList.length == hashList.length);
  return hashList;
}


void printOptions(double v, int i) {
  final s0 = v.toString();
  var over = (s0.length > 16) ? '***' : '';
  print('$i: (${s0.length})"$s0" $over');
  final s1 = v.toStringAsExponential();
  over = (s1.length > 16) ? '***' : '';
  print('   (${s1.length})"$s1" $over');
  final s2 = v.toStringAsFixed(10);
  over = (s2.length > 16) ? '***' : '';
  print('   (${s2.length})"$s2" $over');
  final s3 = v.toStringAsPrecision(10);
  print('   (${s3.length})"$s3" $over');
  if (s3.length > 16) {
    over = (s3.length > 16) ? '***' : '';
    print('$i: (${s0.length})"$s0" $over');
    print('   (${s3.length})"$s3" $over');
  }
}
