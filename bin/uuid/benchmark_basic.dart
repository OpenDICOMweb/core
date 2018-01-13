// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:core/server.dart';

List<Uuid> uuids;
List<String> strings;

const int length = 10000;

// Create a new benchmark by extending BenchmarkBase.
class TemplateBenchmark extends BenchmarkBase {
  const TemplateBenchmark() : super('Template');

  static void main() {
    const TemplateBenchmark().report();
    Uuid.setGenerator(GeneratorType.secure);
  }

  // The benchmark code.
  @override
  void run() {
    for (var i = 0; i < length; i++)
      //uuids[i].toString();
      Uuid.parse(strings[i]);
  }

  // Not measured: setup code executed before the benchmark runs.
  @override
  void setup() {
    // Uuid.initialize(isSecure: false, seed: 0);
    uuids = new List<Uuid>(length);
    strings = new List<String>(length);
    for (var   i = 0; i < length; i++) {
      uuids[i] = new Uuid();
      strings[i] = uuids[i].toString();
    }
  }

  // Not measured: teardown code executed after the benchmark runs.
  @override
  void teardown() {}
}

// Main function runs the benchmark.
void main() {
  // Run TemplateBenchmark.
  TemplateBenchmark.main();
}
