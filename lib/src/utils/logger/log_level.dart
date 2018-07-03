//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

/// Logger Levels ([Level]s).
///
/// Logging can be enabled to include all [Level]s above a specific
/// [Level]. [Level]s are ordered using an integer values [Level].values.
///
/// This should be imported as '_LogLevel_'.
///
/// The predefined [Level] constants below are sorted as follows
/// (in descending order):
/// [Level.off]
/// [Level.fatal],
/// [Level.abort],
/// [Level.quarantine],
/// [Level.severe],
/// [Level.error],
/// [Level.config],
/// [Level.warn0],
/// [Level.warn1],
/// [Level.info1],
/// [Level.info0],
/// [Level.debug0],
/// [Level.debug1],
/// [Level.debug2],
/// [Level.debug3],and
/// [Level.all].
///
/// We recommend using one of the predefined [Level]s. If you define your
/// own [Level], make sure to use a values between those used in
/// [Level.all], and [Level.off].
class Level implements Comparable<Level> {
  /// The [abbr] should have exactly 4 letters.
  final String abbr;
  final String name;

  /// Unique values for a [Level]. Used for typing exceptions.
  /// Allows searching for a particular type of log.
  final int value;

  const Level(this.abbr, this.name, this.value);

  @override
  bool operator ==(Object other) => other is Level && value == other.value;

  bool operator <(Level other) => value < other.value;

  bool operator <=(Level other) => value <= other.value;

  bool operator >(Level other) => value > other.value;

  bool operator >=(Level other) => value >= other.value;

  @override
  int compareTo(Level other) => value - other.value;

  @override
  int get hashCode => value;

  @override
  String toString() => '${name.trimLeft()}';

  /// Special key to turn on logging for all [Level]s.
  static const Level all = const Level(' All', 'All', 0);

  /// Key for tracing information ([value] = 300).
  static const Level debug3 = const Level('D3', 'Debug3', 300);

  /// Key for tracing information ([value] = 400).
  static const Level debug2 = const Level('D2', 'Debug2', 400);

  /// Key for tracing information ([value] = 500).
  static const Level debug1 = const Level('D1', 'Debug1', 500);

  /// Key for tracing information ([value] = 600).
  static const Level debug0 = const Level('D0', 'Debug', 600);

  /// Key for tracing information ([value] = 600).
  static const Level debug = const Level('D0', 'Debug', 600);

  /// Key for informational messages ([value] = 700).
  static const Level info1 = const Level('I1', ' Info1', 700);

  /// Key for informational messages ([value] = 750).
  static const Level info0 = const Level('I0', ' Info0', 750);
  static const Level info = info0;

  /// Key for potential problems ([value] = 800).
  static const Level warn1 = const Level('W1', ' Warn1', 800);

  /// Key for potential problems ([value] = 900).
  static const Level warn0 = const Level('W0', ' Warn0', 900);
  static const Level warn = warn0;

  /// Key for static configuration messages ([value] = 1000).
  static const Level config = const Level('C0', 'Config', 1000);

  /// Key for errors ([value] = 1000).
  static const Level error = const Level('Error', 'Error', 1100);

  /// Key for errors ([value] = 1150).
  static const Level severe = const Level('Severe Error', 'Severe', 1150);

  /// Key for serious errors that cause the decoder to quarantine the Study.
  static const Level quarantine =
      const Level('Quarantine', 'Quarantine', 1200);

  /// Key for serious errors that cause the decoder to abort immediately.
  static const Level abort =
      const Level('Abort', 'Abort', 1300);

  /// Key for fatal errors that cause the script to exit
  /// ([value] = 1300).
  static const Level fatal = const Level('Fatal', 'Fatal', 1400);

  /// Special key to turn off all logging ([value] = 2000).
  static const Level off = const Level(' Off', 'OFF', 2000);

  static const List<Level> levels = const [
    all, debug3, debug2, debug1, debug0, info1, info0, warn1, warn0,
    config, error, quarantine, abort, fatal, off   // No reformat
  ];

  static Level lookup(String level) => map[level.toLowerCase()];

  static const Map<String, Level> map = const <String, Level>{
    'off': Level.off,
    'fatal': Level.fatal,
    'abort': Level.abort,
    'quarantine': Level.quarantine,
    'error': Level.error,
    'config': Level.config,
    'warn0': Level.warn0,
    'warn1': Level.warn1,
    'info0': Level.info1,
    'info1': Level.info0,
    'debug0': Level.debug0,
    'debug1': Level.debug1,
    'debug2': Level.debug2,
    'debug3': Level.debug3,
    'all': Level.all
  };
}
