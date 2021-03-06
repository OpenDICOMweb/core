// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// A Simple Timer based on Dart's [Stopwatch].
class Timer {
  final Stopwatch watch = new Stopwatch();
  /// The last time _this_ was started.
  DateTime _start;

  /// The last time _this_ was stopped.
  DateTime _stop;

  /// The constructor automatically starts the timer,
  /// unless [start] == _false_.
  Timer({bool start = true}) {
    if (start) watch.start();
  }

  /// The [DateTime] when _this_ started/
  DateTime get lastStart => _start;

  /// The [DateTime] when _this_ was last started/
  DateTime get lastStop => _stop;

  /// The [frequency] of _this_.
  int get frequency => watch.frequency;

  /// The total elapsed time as a [Duration] since the first call to
  /// [start], while the [Timer] is running.
  Duration get elapsed => watch.elapsed;

  int get elapsedMicroseconds => watch.elapsedMicroseconds;

  int get elapsedMilliseconds => watch.elapsedMilliseconds;

  int get elapsedTicks => watch.elapsedTicks;

  bool get isRunning => watch.isRunning;

  bool get isStopped => !watch.isRunning;

  /// The elapsed number of ticks at the last split.
  int _ticksAtLastSplit = 0;

  /// Returns the current [split] in clock ticks.
  int get splitTicks {
    final now = watch.elapsedTicks;
    final ticks = now - _ticksAtLastSplit;
    _ticksAtLastSplit = now;
    return ticks;
  }

  /// Returns the current [split] in microseconds.
  int get splitMicroseconds => splitTicks * 1000000 ~/ watch.frequency;

  /// Returns the [Duration] between the current time and the last split.
  Duration get split => new Duration(microseconds: splitMicroseconds);

  /// Returns the average [Duration] for each thing timed, where [total]
  /// is the total number of things timed.
  Duration average(int total) =>
      new Duration(microseconds: elapsedMicroseconds ~/ total);

  /// (Re)Start the [Timer].
  void start() {
    _start = new DateTime.now();
    watch.start();
  }

  /// Stop the [Timer], but it may be restarted later.
  void stop() {
    watch.stop();
    _stop = new DateTime.now();
  }

  /// Resets the [elapsed] count to zero.
  /// _Note_: _This method does not stop or start the [Timer]_.
  void reset() => watch.reset();
}

