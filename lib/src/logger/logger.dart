// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:collection';

import 'indenter.dart';
import 'log_level.dart';
import 'log_record.dart';

// ignore_for_file: avoid_annotating_with_dynamic, only_throw_errors

/// A Function called by the Fatal method.
typedef void LogExitHandler(LogRecord record);

//Urgent: fix logger indentation
//Urgent: argument for increasing/decreasing indent
//Urgent: allow logger to be wrapped inside other Loggers
//TODO: Add ability to write to a file or network connection.
class Logger {
//	static const String defaultFileName = 'logger.log';

  /// The [List] of Logged events.
  final List<LogRecord> records = <LogRecord>[];

  final String name;

  /// Parent of this logger in the hierarchy of loggers.
  final Logger parent;

  final Map<String, Logger> _children;

  /// Controller used to notify when log entries are added to this logger.
  StreamController<LogRecord> _controller;

  /// The [Indenter] for this logger.
  final Indenter indenter;

  /// The [Level] at or above which logging should be done, by this.
  Level _level;

  /// _true_ if the logger should also [print] to stdout.
  bool doPrint = true;

  /// Singleton constructor. Calling `new Logger(name)` will return the same
  /// actual instance whenever it is called with the same string name.
  factory Logger(String name, [Level level = defaultLevel]) {
    if (name.startsWith('.')) throw new ArgumentError('Name shouldn\'t start with a "."');

    print('name: "$name"');
    if (name == 'root') return root;
    // Split hierarchical names (separated with '.').
    final nameList = name.split('.');
    print('names: $nameList');
    var parent = root;
    Logger logger;
    for (var i = 0; i < nameList.length; i++) {
      print('  parent: ${parent.name} - ${parent.fullName}');
      final name = nameList[i];
      logger = parent._children[name];
      logger ??=
          parent._children.putIfAbsent(name, () => new Logger._(name, parent, level));
      print('    logger: ${logger.name} - ${logger.fullName}');
      parent = logger;
    }
    print('  logger.name: "${logger.name}" parent: "${parent.name}"');
    return logger;
  }

  /// Creates a new detached [Logger].
  ///
  /// Returns a new [Logger] instance (unlike `new Logger`, which returns a
  /// [Logger] singleton), which doesn't have any parent or children,
  /// and is not a part of the global hierarchical loggers structure.
  ///
  /// It can be useful when you just need a local short-living logger,
  /// which you'd like to be garbage-collected later.
  factory Logger.detached(String name, [Level value = defaultLevel, Indenter indenter]) =>
      new Logger._(name, null, value);

  Logger._(this.name, this.parent, this._level, {Indenter indenter})
      : _children = <String, Logger>{},
        indenter = indenter ?? Indenter.basic {
    if (parent != null) parent._children[name] = this;
  }

  /// Effective level considering the levels established in this logger's parents
  /// (when [isHierarchicalEnabled] is true).
  Level get level {
    if (isHierarchicalEnabled) {
      if (_level != null) return _level;
      if (parent != null) return parent.level;
    }
    return root._level;
  }

  /// Override the level for this particular [Logger] and its children. */
  set level(Level value) {
    if (isHierarchicalEnabled && parent != null) {
      _level = value;
    } else {
      if (parent != null) {
        throw new UnsupportedError(
            'Please set "hierarchicalLoggingEnabled" to true if you want to '
            'change the level on a non-root logger.');
      }
      root._level = value;
    }
  }

  /// The full name of this logger, which includes the parent's full name.
  String get fullName =>
      (parent == null || parent.name == 'root') ? name : '${parent.fullName}.$name';

  Map<String, Logger> __children;
  Map<String, Logger> get children => __children ?? new UnmodifiableMapView(_children);

  /// Turn console printing on.
  bool get printOn => doPrint = true;

  /// Turn console printing off.
  bool get printOff => doPrint = false;

  int get reset => indenter.reset;
  int get down => indenter.down;
  int get up => indenter.up;
  int get up2 => indenter.up2;

  /// Returns a stream of messages added to this [Logger].
  ///
  /// You can listen for messages using the standard stream APIs, for instance:
  ///
  /// ```dart
  /// logger.onRecord.listen((record) { ... });
  /// ```
  Stream<LogRecord> get onRecord => _getStream();

  Stream<LogRecord> _getStream() {
    if (isHierarchicalEnabled || parent == null) {
      _controller ??= new StreamController<LogRecord>.broadcast(sync: true);
      return _controller.stream;
    }
    return root._getStream();
  }

  void clearListeners() {
    if (isHierarchicalEnabled || parent == null) {
      if (_controller != null) {
        _controller.close();
        _controller = null;
      }
    } else {
      root.clearListeners();
    }
  }

  LogRecord log(Level logLevel, dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(logLevel, message, indent, error, stack, zone);

  /// Whether a message for [value]'s level is loggable in this logger.
  bool isLoggable(Level value) => (value >= _level);

  /// Create aa [LogRecord].
  LogRecord _log(Level logLevel, dynamic message,
      [int indent = 0, Object error, StackTrace stack, Zone zone]) {
    if (logLevel < level) return null;
    Object msg = message;
    Object object;
    if (msg is Function) msg = msg();
    if (msg is! String) {
      object = msg;
      msg = msg.toString();
    }

    var trace = stack;
    if (trace == null && logLevel >= recordStackTraceAtLevel) {
      try {
        throw 'autogenerated stack trace for $logLevel $msg';
        // ignore: avoid_catches_without_on_clauses
      } catch (e, t) {
        trace = t;
        error ??= e;
      }
    }
    zone ??= Zone.current;

    if (indent > 0) indenter.inc(indent);
    msg = '${indenter.z}$msg';
    final record = new LogRecord(logLevel, msg, fullName, error, trace, zone, object);
    records.add(record);
    if (doPrint) print(record);
    if (indent < 0) indenter.inc(indent);

    if (isHierarchicalEnabled) {
      var target = this;
      while (target != null) {
        target._publish(record);
        target = target.parent;
      }
    } else {
      root._publish(record);
    }
    return record;
  }

  void _publish(LogRecord record) {
    if (_controller != null) _controller.add(record);
  }

  LogRecord call(Level level, dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(level, message, indent, error, stack, zone);

  List<LogRecord> recordsAt(Level severity) => search(severity);

  /// Log message at [Level.debug2].
  LogRecord debug3(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.debug3, message, indent, error, stack, zone);

  /// Log message at [Level.debug2].
  LogRecord debug2(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.debug2, message, indent, error, stack, zone);

  /// Log message at [Level.debug1].
  LogRecord debug1(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.debug1, message, indent, error, stack, zone);

  /// Log message at [Level.debug0].
  LogRecord debug0(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.debug0, message, indent, error, stack, zone);

  LogRecord debug(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.debug0, message, indent, error, stack, zone);

  /// _Deprecated_: see [debug]
  @deprecated
  LogRecord debugDown(Object obj) => _log(Level.debug0, obj, _down);

  /// _Deprecated_: see [debug]
  @deprecated
  LogRecord debugUp(Object obj) => _log(Level.debug0, obj, _up);

  /// Log message at [Level.info1].
  LogRecord info1(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.info1, message, indent, error, stack, zone);

  /// Log message at [Level.info1].
  LogRecord info0(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.info0, message, indent, error, stack, zone);

  /// Log message at [Level.info0].
  LogRecord info(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.info0, message, indent, error, stack, zone);

  /// _Deprecated_: see [info]
  @deprecated
  LogRecord infoDown(Object obj) => _log(Level.info1, obj, _down);

  /// _Deprecated_: see [info]
  @deprecated
  LogRecord infoUp(Object obj) => _log(Level.info1, obj, _up);

  /// Log message at [Level.config].
  LogRecord config(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.config, message, indent, error, stack, zone);

  /// _Deprecated_: see [config]
  @deprecated
  LogRecord configDown(Object obj) => _log(Level.config, obj, _down);

  /// _Deprecated_: see [config]
  @deprecated
  LogRecord configUp(Object obj) => _log(Level.config, obj, _up);

  /// Log message at [Level.warn0].
  LogRecord warn1(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.warn1, message, indent, error, stack, zone);

  /// Log message at [Level.warn0].
  LogRecord warn0(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.warn0, message, indent, error, stack, zone);

  /// Log message at [Level.warn0].
  LogRecord warn(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.warn0, message, indent, error, stack, zone);

  /// _Deprecated_: see [warn]
  @deprecated
  LogRecord warnDown(Object obj) => _log(Level.warn0, obj, _down);

  /// _Deprecated_: see [warn]
  @deprecated

  /// Log message at [Level.warn0] and decrease indent level.
  LogRecord warnUp(Object obj) => _log(Level.warn0, obj, _up);

  /// Log message at [Level.error].
  LogRecord error(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.error, message, indent, error, stack, zone);

  /// _Deprecated_: see [error]
  @deprecated

  /// Log message at [Level.error] and increase indent level.
  LogRecord errorDown(Object obj) => _log(Level.error, obj, _down);

  /// _Deprecated_: see  [error]
  @deprecated

  /// Log message at [Level.error] and decrease indent level.
  LogRecord errorUp(Object obj) => _log(Level.error, obj, _up);

  /// Log message at [Level.error] and decrease indent level.
  LogRecord severe(Object obj) => _log(Level.error, obj);

  /// Log message at [Level.quarantine].
  LogRecord quarantine(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.quarantine, message, indent, error, stack, zone);

  /// Log message at [Level.abort].
  LogRecord abort(dynamic message,
          [int indent = 0, Object error, StackTrace stack, Zone zone]) =>
      _log(Level.abort, message, indent, error, stack, zone);

  /// Log message at [Level.fatal].
  void fatal(dynamic message,
      [int indent = 0, Object error, StackTrace stack, Zone zone]) {
    final record = _log(Level.fatal, message, indent, error, stack, zone);
    throw new FatalError('$record');
  }

  List<LogRecord> search(Level severity) {
    final results = <LogRecord>[];
    for (var record in records) if (record.level == severity) results.add(record);
    return results;
  }

  // void add(LogRecord m) => records.add(m);

  String get json => '''
  {"@type": "StatusLog",
   "@date": ${new DateTime.now()},
   "Messages": [ ${records.join(",")} ] }
   ''';

  @override
  String toString() => '$name';

  static const Level defaultLevel = Level.info0;

  /// Automatically record stack traces for any message of this level or above.
  ///
  /// Because this is expensive, this is off by default.
  static Level recordStackTraceAtLevel = Level.off;

  /// Whether to allow fine-grain logging and configuration of
  /// loggers in a hierarchy.
  ///
  /// When false, all logging is merged in the root logger.
  static bool isHierarchicalEnabled = true;

  /// Top-level (root) [Logger].
  // static final Logger root = init();
  static final Logger root = new Logger._('root', null, defaultLevel);

  /// All [Logger]s in the system.
  static final Map<String, Logger> _loggers = <String, Logger>{};

  /// [Level] for the root-logger. This will be the [Level] of all
  /// loggers if isHierarchical is false.
  static Level rootSeverity = Level.config;

  // indent down
  static const int _down = 1;
  // indent up
  static const int _up = -1;

  static void show() => 'Loggers<${_loggers.length}> $_loggers';
}

//TODO: create a standard set of Errors and Exceptions in Common.
class FatalError extends Error {
  final String msg;

  FatalError(this.msg);

  @override
  String toString() => 'Fatal Error: $msg';
}
