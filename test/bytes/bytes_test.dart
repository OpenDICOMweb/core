//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'bytes_test.dart', level: Level.info);
  final rng = new RNG();
  group('Bytes Tests', () {
    test('Test getters and initial zeros', () {
      const count = 12;

      // Check initialized with zeros
      for (var i = 0; i < count; i++) {
        final bytes = new Bytes(count);
        expect(bytes.endian == Endian.little, true);

        expect(bytes.elementSizeInBytes == 1, true);
        expect(bytes.offset == 0, true);
        expect(bytes.buffer == bytes.bd.buffer, true);
        expect(bytes.length == count, true);
        expect(bytes.length == count, true);
        expect(bytes.length == bytes.length, true);

        expect(bytes.hashCode is int, true);

        for (var i = 0; i < bytes.length; i++) {
          expect(bytes[i] == 0, true);
          expect(bytes.getUint8(i) == 0, true);
        }

        for (var i = 0; i < bytes.length; i += 2) {
          expect(bytes[i] == 0, true);
          expect(bytes.getUint16(i) == 0, true);
        }
        for (var i = 0; i < bytes.length; i += 4) {
          expect(bytes[i] == 0, true);
          expect(bytes.getUint32(i) == 0, true);
        }
        for (var i = 0; i < bytes.length - 4; i += 8) {
          expect(bytes[i] == 0, true);
          expect(bytes.getUint64(i) == 0, true);
        }
        for (var i = 0; i < bytes.length; i++) {
          expect(bytes[i] == 0, true);
          expect(bytes.getInt8(i) == 0, true);
        }
        for (var i = 0; i < bytes.length; i += 2) {
          expect(bytes[i] == 0, true);
          expect(bytes.getInt16(i) == 0, true);
        }

        for (var i = 0; i < bytes.length; i += 4) {
          expect(bytes[i] == 0, true);
          expect(bytes.getInt32(i) == 0, true);
        }

        for (var i = 0; i < bytes.length - 4; i += 8) {
          expect(bytes[i] == 0, true);
          expect(bytes.getInt64(i) == 0, true);
        }

        for (var i = 0; i < bytes.length; i += 4) {
          expect(bytes[i] == 0, true);
          expect(bytes.getFloat32(i) == 0, true);
        }

        for (var i = 0; i < bytes.length - 4; i += 8) {
          expect(bytes[i] == 0, true);
          expect(bytes.getFloat64(i) == 0, true);
        }

        final bytes0 = new Bytes.from(bytes);
        expect(bytes0.endian == Endian.little, true);

        expect(bytes0.elementSizeInBytes == 1, true);
        expect(bytes0.offset == 0, true);
        expect(bytes0.buffer == bytes.bd.buffer, true);
        expect(bytes0.length == count, true);
        expect(bytes0.length == count, true);
        expect(bytes0.length == bytes.length, true);

        expect(bytes0.hashCode is int, true);
      }
    });

    test('Test List interface: initial zeroed, equality, hashCode', () {
      const count = 255;
      final a = new Bytes(count);
      final b = new Bytes(count);

      // Check initialized with zeros
      for (var i = 0; i < count; i++) {
        expect(a[i] == 0, true);
        expect(b[i] == 0, true);
        expect(a[i] == b[i], true);

        expect(a.getUint8(i) == 0, true);
        expect(b.getUint8(i) == 0, true);
        expect(a.getUint8(i) == b.getUint8(i), true);

        expect(a == b, true);
        expect(a.hashCode == b.hashCode, true);
      }

      // Check byte Setters
      for (var i = 0; i < count; i++) {
        a[i] = count;
        b[i] = count;

        expect(a[i] == count, true);
        expect(b[i] == count, true);
        expect(a[i] == b[i], true);

        expect(a.getUint8(i) == count, true);
        expect(b.getUint8(i) == count, true);
        expect(a.getUint8(i) == b.getUint8(i), true);

        expect(a == b, true);
        expect(a.hashCode == b.hashCode, true);
      }
    });

    //TODO: finish tests
    test('Test List Int16', () {
      const loopCount = 100;

      for (var i = 0; i < loopCount; i++) {
        final a = new Bytes(0xFFFF * Bytes.kInt16Size);
        assert(a.length == 0xFFFF * Bytes.kInt16Size, true);

        for (var i = 0, j = -10; i <= 10; i++, j += 2) {
          a.setInt16(i * 2, j);
          print('i: $i, j: $j, v: ${a.getInt16(i)}');
          expect(a.getInt16(i * 2) == j, true);
        }
        for (var i = 0, j = -10; i <= 10; i++, j += 2) {
          print('i: $i, j: $j, v: ${a.getInt16(i)}');
          expect(a.getInt16(i * 2) == j, true);
        }
      }
    });

    test('bytes from', () {
      final list0 = rng.uint8List(1, 1);
      final bytes = Bytes.asciiEncode(list0.toString());
      final byteF0 = new Bytes.from(bytes);
      expect(byteF0, equals(bytes));

      expect(byteF0.endian == Endian.little, true);
      expect(byteF0.elementSizeInBytes == 1, true);
      expect(byteF0.offset == 0, true);
      expect(byteF0.buffer == byteF0.bd.buffer, true);
      expect(byteF0.length == bytes.length, true);
      expect(byteF0.length == bytes.length, true);
      expect(byteF0.length == byteF0.length, true);
      expect(byteF0.hashCode is int, true);
    });

    test('bytes fromList', () {
      final list0 = rng.uint8List(1, 1);
      final byteFL0 = new Bytes.fromList(list0);
      expect(byteFL0, equals(list0));

      expect(byteFL0.endian == Endian.little, true);
      expect(byteFL0.elementSizeInBytes == 1, true);
      expect(byteFL0.offset == 0, true);
      expect(byteFL0.buffer == byteFL0.bd.buffer, true);
      expect(byteFL0.length == list0.length, true);
      expect(byteFL0.length == byteFL0.length, true);
      expect(byteFL0.length == byteFL0.length, true);
      expect(byteFL0.hashCode is int, true);
    });

    test('bytes fromTypedData', () {
      final list0 = rng.uint8List(1, 1);
      final byteFTD0 = new Bytes.typedDataView(list0);
      expect(byteFTD0, equals(list0));

      expect(byteFTD0.endian == Endian.little, true);
      expect(byteFTD0.elementSizeInBytes == 1, true);
      expect(byteFTD0.offset == 0, true);
      expect(byteFTD0.buffer == byteFTD0.bd.buffer, true);
      expect(byteFTD0.length == list0.length, true);
      expect(byteFTD0.length == byteFTD0.length, true);
      expect(byteFTD0.length == byteFTD0.length, true);
      expect(byteFTD0.hashCode is int, true);
    });
  });
}
