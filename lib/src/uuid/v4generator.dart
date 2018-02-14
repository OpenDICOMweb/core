// Copyright (c) 2016, 2017 Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/random/rng.dart';

/// A generator of Version 4 (random) UUIDs.
///
/// The generator can use either the [RNG] RNG, which is
/// the default, or the [RNG.secure] RNG.
// Note: This implementation is faster than http:pub.dartlang.org/uuid
//   this one: Template(RunTime): 142,266.66666666666 us.
//   pub uuid: Template(RunTime): 170,166.66666666666 us.
class V4Generator {
  final RNG rng;
  final bool isSecure;
  final int seed;

  /// Creates a generator of Version 4 UUIDs.  [isSecure] (the default)
  /// determines whether the [RNG] or [RNG.secure] RNG is used.
  ///
  /// [seed] affects only the [RNG] RNG and can be used to
  /// generate pseudo-RNG numbers.
  V4Generator({this.isSecure: false, this.seed})
      : rng = (isSecure) ? new RNG.secure() : new RNG(seed);

  V4Generator._(this.rng, {this.isSecure: false, this.seed});

  /// Returns a new RNG (V4) UUID value.
  /// _Note_: The value is a [Uint8List], not a Uuid.
  Uint8List get next {
    final rList = new Uint32List(4);
    for (var i = 0; i < 4; i++) rList[i] = rng.nextUint32;
    final bytes = rList.buffer.asUint8List();
    // Set the version and variant bits to the correct values.
    bytes[6] = bytes[6] >> 4 | 0x40;
    bytes[8] = bytes[8] >> 2 | 0x80;
    return bytes;
  }

  static final RNG _rngSecure = new RNG.secure();
  static final RNG _rngBasic = new RNG();
  static final RNG _rngTest = new RNG(0);

  /// Generates a series of RNG (secure) Uuids.
  static final V4Generator secure =
      new V4Generator._(_rngSecure, isSecure: true);

  /// Generates a series of pseudo-random Uuids.
  /// _Note_: No [seed] is used. This is faster than
  /// [secure] and can be used for testing.
  static final V4Generator pseudo = new V4Generator._(_rngBasic);

  /// Generates a reproducible series of pseudo-random Uuids.
  /// The [seed] used is 1.
  static final V4Generator seededPseudo = new V4Generator._(_rngTest, seed: 0);
}
