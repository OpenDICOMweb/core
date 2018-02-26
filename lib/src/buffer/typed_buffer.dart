// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

// Base Types
//  - List<T>
//  -   BufferedData implements TypedData
//  -   ByteData implements TypedData
//  -   BufferedList<T> extends List<T> with TypedData
//  - Int8List extends BufferedList<int>
//  - Float32List extends TypedBuffer<double>
//  - Uint8List extends TypedBuffer<int> implements ByteData
abstract class TypedBuffer<T> implements List<T>, TypedData {

}

