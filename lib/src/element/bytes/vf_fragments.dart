//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/element/utils.dart';
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: public_member_api_docs

/// [VFFragments[ contains the Value Field of an _encapsulated_
/// (i.e. compressed) OBPixelData Element. This class is used
/// to convert the [fragments]s to [bulkdata].
class VFFragments {
  /// The fragments contained in the Value Field without their Item headers.
  final List<Uint8List> fragments;

  /// Creates a [VFFragments].
  VFFragments(this.fragments);

  bool get isCompressed => true;
  bool get isEncapsulated => isCompressed;

  /// The Basic Offset Table (see PS3.5, Section 8.2) for this encapsulated
  /// PixelData. [offsets] as a [Uint32List] of offsets contained in the
  /// first fragment. _Note_: [offsets] might have length[0] if the Basic
  /// Offset Table was empty.
  Uint32List get offsets => getUint32List(fragments[0]);

  /// The length in bytes of the pixels contained in the Value Field.
  int get lengthInBytes => _lengthInBytes ??= () {
        var length = 0;
        for (var j = 1; j < fragments.length; j++)
          length += fragments[j].length;
        return length;
      }();
  int _lengthInBytes;

  /// Returns a [Uint8List] that combines the bytes in [fragments].
  /// Note: The [bulkdata] is contained in fragments 1 to n. Fragment 0
  /// contains the Basic Offset Table.
  Uint8List get bulkdata => _bulkdata ??= () {
        final v = Uint8List(lengthInBytes);
        var i = 0;
        for (var j = 1; j < fragments.length; j++) {
          if (fragments[j].isNotEmpty) {
            final chunk = fragments[j];
            for (var k = 0; k < chunk.length; k++, i++) v[i] = chunk[k];
          }
        }
        return v;
      }();
  Uint8List _bulkdata;

  String get info =>
      '$this\n  offsets(${offsets.length}) Bulkdata $lengthInBytes bytes';

  @override
  String toString() => '$runtimeType(${fragments.length} fragments)';

  /// Returns the [VFFragments] contained in the Value Field [vf]. Note: the
  /// trailing kSequenceDelimiterItem and delimiter length have been removed
  /// from [vf].
  static VFFragments parse(Uint8List vf) {
    final bd = vf.buffer.asByteData(vf.offsetInBytes, vf.lengthInBytes);
    final endOfVF = vf.lengthInBytes;
    var rIndex = 0;

    // Read 32-bit Little Endian unsigned integer.
    int readUint32() {
      final v = bd.getUint32(rIndex, Endian.little);
      rIndex += 4;
      return v;
    }

    // [rIndex] is at first kItem delimiter, and [_endOf
    final fragments = <Uint8List>[];
//    _log.debug('VFF code vf.length ${vf.lengthInBytes}');
    while (rIndex < endOfVF) {
      final code = readUint32();
      if (code == kSequenceDelimitationItem32BitLE) break;
      assert(code == kItem32BitLE, 'Invalid Item code: ${toDcm(code)}');
      final vfLength = readUint32();
//      _log.debug('VFF code ${toDcm(code)} length: $vfLength');
      assert(
          vfLength != kUndefinedLength, 'Invalid length: ${toDcm(vfLength)}');
      final startOfVF = rIndex;
      rIndex += vfLength;
      fragments.add(bd.buffer.asUint8List(startOfVF, rIndex - startOfVF));
    }
    final vfFragments = VFFragments(fragments);
//    _log.debug('VFFragments: $fragments');
    return vfFragments;
  }
}
