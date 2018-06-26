//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:async';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'logger/logging_test', level: Level.info);

  group('Logger Tests', () {
    test('level comparison is a valid comparator', () {
      const level1 = const Level('N3', 'NOT_REAL1', 253);
      expect(level1 == level1, isTrue);
      expect(level1 <= level1, isTrue);
      expect(level1 >= level1, isTrue);
      expect(level1 < level1, isFalse);
      expect(level1 > level1, isFalse);

      const level2 = const Level('N3', 'NOT_REAL2', 455);
      expect(level1 <= level2, isTrue);
      expect(level1 < level2, isTrue);
      expect(level2 >= level1, isTrue);
      expect(level2 > level1, isTrue);

      const level3 = const Level('N3', 'NOT_REAL3', 253);
      expect(level1, isNot(same(level3))); // different instances
      expect(level1, equals(level3)); // same value.
    });

    test('default levels are in order', () {
      const levels = Level.levels;

      for (var i = 0; i < levels.length; i++) {
        for (var j = i + 1; j < levels.length; j++) {
          expect(levels[i] < levels[j], isTrue);
        }
      }
    });

    test('levels are comparable', () {
      final unsorted = <Level>[
        Level.info0,
        Level.config,
        Level.debug1,
        Level.warn1,
        Level.abort,
        Level.off,
        Level.debug2,
        Level.fatal,
        Level.all,
        Level.warn0,
        Level.info1,
        Level.debug3,
        Level.error,
        Level.debug0,
        Level.quarantine
      ];

      const sorted = Level.levels;

      expect(unsorted, isNot(orderedEquals(sorted)));

      unsorted.sort();
      log.debug(unsorted);
      expect(unsorted, orderedEquals(sorted));
    });

    test('levels are hashable', () {
      final map = <Level, String>{};
      map[Level.info1] = 'info';
      map[Level.abort] = 'abort';
      expect(map[Level.info1], same('info'));
      expect(map[Level.abort], same('abort'));
    });

    test('logger name cannot start with a "." ', () {
      expect(() => new Logger('.c'), throwsArgumentError);
    });

    test('logger naming is hierarchical', () {
      final c = new Logger('a.b.c');
      expect(c.name, equals('c'));
      log.debug('c.parent.name: ${c.parent.name}');
      expect(c.parent.name, equals('b'));
      expect(c.parent.parent.name, equals('a'));
      expect(c.parent.parent.parent.name, equals('root'));
      expect(c.parent.parent.parent.parent, isNull);
    });

    test('logger full name', () {
      final c = new Logger('a.b.c');
      expect(c.fullName, equals('a.b.c'));
      expect(c.parent.fullName, equals('a.b'));
      expect(c.parent.parent.fullName, equals('a'));
      expect(c.parent.parent.parent.fullName, equals('root'));
      expect(c.parent.parent.parent.parent, isNull);
    });

    test('logger parent-child links are correct', () {
      final a = new Logger('a');
      final b = new Logger('a.b');
      final c = new Logger('a.c');
      expect(a, same(b.parent));
      expect(a, same(c.parent));
      expect(a.children['b'], same(b));
      expect(a.children['c'], same(c));
    });

    test('loggers are singletons', () {
      final a1 = new Logger('a');
      final a2 = new Logger('a');
      final b = new Logger('a.b');
      final root = Logger.root;
      expect(a1, same(a2));
      expect(a1, same(b.parent));
      expect(root, same(a1.parent));
      expect(root, same(new Logger('root')));
    });

    test('cannot directly manipulate Logger.children', () {
      final loggerAB = new Logger('a.b');
      final loggerA = loggerAB.parent;

      expect(loggerA.children['b'], same(loggerAB),
          reason: 'can read Children');

      expect(() {
        loggerAB.children['test'] = null;
      }, throwsUnsupportedError, reason: 'Children is read-only');
    });

    test('stackTrace gets throw to LogRecord', () {
      Logger.root.level = Level.info0;

      final records = <LogRecord>[];

      final sub = Logger.root.onRecord.listen(records.add);

      try {
        throw new UnsupportedError('test exception');
        // ignore: avoid_catches_without_on_clauses
      } catch (error, stack) {
        Logger.root
          ..log(Level.error, 'error', 0, error, stack)
          ..warn0('foo', 0, error, stack);
      }

      Logger.root.log(Level.abort, 'abort');
      sub.cancel();

      expect(records, hasLength(3));

      //    Logger.root.reset;
      final error = records[0];
      expect(error.message, 'error');
      expect(error.error is UnsupportedError, isTrue);
      expect(error.trace is StackTrace, isTrue);

      final warn0 = records[1];
      expect(warn0.message, 'foo');
      expect(warn0.error is UnsupportedError, isTrue);
      expect(warn0.trace is StackTrace, isTrue);

      final abort = records[2];
      expect(abort.message, 'abort');
      expect(abort.error, isNull);
      expect(abort.trace, isNull);
    });
  });

  group('zone gets recorded to LogRecord', () {
    test('root zone', () {
      final root = Logger.root;

      final recordingZone = Zone.current;
      final records = <LogRecord>[];
      root.onRecord.listen(records.add);
      root.info0('hello');

      expect(records, hasLength(1));
      expect(records.first.zone, equals(recordingZone));
    });

    test('child zone', () {
      final root = Logger.root;

      Zone recordingZone;
      final records = <LogRecord>[];
      root.onRecord.listen(records.add);

      runZoned(() {
        recordingZone = Zone.current;
        root.info0('hello');
      });

      expect(records, hasLength(1));
      expect(records.first.zone, equals(recordingZone));
    });

    test('custom zone', () {
      final root = Logger.root;

      Zone recordingZone;
      final records = <LogRecord>[];
      root.onRecord.listen(records.add);

      runZoned(() {
        recordingZone = Zone.current;
      });

      runZoned(
          () => root.log(Level.info0, 'hello', 0, null, null, recordingZone));
      expect(records, hasLength(1));
      expect(records.first.zone, equals(recordingZone));
    });
  });

  group('detached loggers', () {
    test('create new instances of Logger', () {
      final a1 = new Logger.detached('a');
      final a2 = new Logger.detached('a');
      final a = new Logger('a');

      expect(a1, isNot(a2));
      expect(a1, isNot(a));
      expect(a2, isNot(a));
    });

    test('parent is null', () {
      final a = new Logger.detached('a');
      expect(a.parent, null);
    });

    test('children is empty', () {
      final a = new Logger.detached('a');
      expect(a.children, isMap);
    });
  });

  group('mutating levels', () {
    final root = Logger.root;
    final a = new Logger('a');
    final b = new Logger('a.b');
    final c = new Logger('a.b.c');
    final d = new Logger('a.b.c.d');
    final e = new Logger('a.b.c.d.e');

    setUp(() {
      Logger.isHierarchicalEnabled = true;
      root.level = Level.info0;
      a.level = null;
      b.level = null;
      c.level = null;
      d.level = null;
      e.level = null;
      root.clearListeners();
      a.clearListeners();
      b.clearListeners();
      c.clearListeners();
      d.clearListeners();
      e.clearListeners();
      Logger.isHierarchicalEnabled = false;
      root.level = Level.info0;
    });

    test('cannot set level if hierarchy is disabled', () {
      expect(() {
        a.level = Level.debug1;
      }, throwsUnsupportedError);
    });

    test('loggers effective level - no hierarchy', () {
      expect(root.level, equals(Level.info0));
      expect(a.level, equals(Level.info0));
      expect(b.level, equals(Level.info0));

      root.level = Level.abort;

      expect(root.level, equals(Level.abort));
      expect(a.level, equals(Level.abort));
      expect(b.level, equals(Level.abort));
    });

    test('loggers effective level - with hierarchy', () {
      Logger.isHierarchicalEnabled = true;
      expect(root.level, equals(Level.info0));
      expect(a.level, equals(Level.info0));
      expect(b.level, equals(Level.info0));
      expect(c.level, equals(Level.info0));

      root.level = Level.abort;
      b.level = Level.debug1;

      expect(root.level, equals(Level.abort));
      expect(a.level, equals(Level.abort));
      expect(b.level, equals(Level.debug1));
      expect(c.level, equals(Level.debug1));
    });

    test('isLoggable is appropriate', () {
      Logger.isHierarchicalEnabled = true;
      root.level = Level.error;
      c.level = Level.all;
      e.level = Level.off;

      expect(root.isLoggable(Level.abort), isTrue);
      expect(root.isLoggable(Level.error), isTrue);
      expect(root.isLoggable(Level.warn0), isFalse);
      expect(c.isLoggable(Level.debug3), isTrue);
      expect(c.isLoggable(Level.debug1), isTrue);
      expect(e.isLoggable(Level.abort), isFalse);
    });

    test('add/remove handlers - no hierarchy', () {
      var calls = 0;
      void handler(Object _) => calls++;

      final sub = c.onRecord.listen(handler);
      root..info0('foo')..info0('foo');
      expect(calls, equals(2));
      sub.cancel();
      root.info0('foo');
      expect(calls, equals(2));
    });

    test('add/remove handlers - with hierarchy', () {
      Logger.isHierarchicalEnabled = true;
      var calls = 0;
      void handler(Object _) => calls++;

      c.onRecord.listen(handler);
      root..info0('foo')..info0('foo');
      expect(calls, equals(0));
    });

    test('logging methods store appropriate level', () {
      root.level = Level.all;
      final rootMessages = <String>[];
      root.onRecord.listen((record) {
        rootMessages.add('${record.level}: ${record.message}');
      });

      root
        ..debug3('1')
        ..debug2('2')
        ..debug1('3')
        ..config('4')
        ..info0('5')
        ..warn0('6')
        ..error('7')
        ..abort('8');

      expect(
          rootMessages,
          equals([
            'Debug3: 1',
            'Debug2: 2',
            'Debug1: 3',
            'Config: 4',
            'Info0: 5',
            'Warn0: 6',
            'Error: 7',
            'Abort: 8'
          ]));
    });

    test('logging methods store exception', () {
      root.level = Level.all;
      final rootMessages = <String>[];
      root.onRecord.listen((r) {
        rootMessages.add('${r.level}: ${r.message} ${r.error}');
      });

      root
        ..debug3('1')
        ..debug2('2')
        ..debug1('3')
        ..config('4')
        ..info0('5')
        ..warn0('6')
        ..error('7')
        ..abort('8')
        // TODO: fix minus indent
        ..debug3('1', 0, 'a')
        ..debug2('2', 1, 'b')
        ..debug1('3', -1, ['c'])
        ..config('4', 0, 'd')
        ..info0('5', 1, 'e')
        ..warn0('6', 1, 'f')
        ..error('7', -1, 'g')
        ..abort('8', -1, 'h');

      expect(
          rootMessages,
          equals([
            'Debug3: 1 null',
            'Debug2: 2 null',
            'Debug1: 3 null',
            'Config: 4 null',
            'Info0: 5 null',
            'Warn0: 6 null',
            'Error: 7 null',
            'Abort: 8 null',
            'Debug3: 1 a',
            'Debug2:   2 b',
            'Debug1:   3 [c]',
            'Config: 4 d',
            'Info0:   5 e',
            'Warn0:     6 f',
            'Error:     7 g',
            'Abort:   8 h'
          ]));
    });

    test('message logging - no hierarchy', () {
      Logger.isHierarchicalEnabled = false;
      root.level = Level.warn0;
      final rootMessages = <String>[];
      final aMessages = <String>[];
      final cMessages = <String>[];
      c.onRecord.listen((record) {
        cMessages.add('${record.level}: ${record.message}');
      });
      a.onRecord.listen((record) {
        aMessages.add('${record.level}: ${record.message}');
      });

      root.onRecord.listen((record) {
        rootMessages.add('${record.level}: ${record.message}');
      });

      root
        ..info0('1')
        ..debug1('2')
        ..abort('3');

      b
        ..info0('4')
        ..error('5')
        ..warn0('6')
        ..debug1('7');

      c
        ..debug1('8')
        ..warn0('9')
        ..abort('10');

      log
        ..debug('onrecode: ${root.onRecord}')
        ..debug('root messages: $rootMessages');
      expect(
          rootMessages,
          equals([
            // 'INFO: 1' is not loggable
            // 'FINE: 2' is not loggable
            'Abort: 3',
            // 'INFO: 4' is not loggable
            'Error: 5',
            'Warn0: 6',
            // 'FINE: 7' is not loggable
            // 'FINE: 8' is not loggable
            'Warn0: 9',
            'Abort: 10'
          ]));

      // no hierarchy means we all hear the same thing.
      expect(aMessages, equals(rootMessages));
      expect(cMessages, equals(rootMessages));
    });

    test('message logging - with hierarchy', () {
      Logger.isHierarchicalEnabled = true;

      b.level = Level.warn0;

      final rootMessages = <String>[];
      final aMessages = <String>[];
      final cMessages = <String>[];
      c.onRecord.listen((record) {
        cMessages.add('${record.level}: ${record.message}');
      });
      a.onRecord.listen((record) {
        aMessages.add('${record.level}: ${record.message}');
      });
      root.onRecord.listen((record) {
        rootMessages.add('${record.level}: ${record.message}');
      });

      root
        ..reset
        ..info0('1')
        ..debug1('2')
        ..abort('3');
      b
        ..info0('4')
        ..error('5')
        ..warn0('6')
        ..debug1('7');
      c
        ..debug1('8')
        ..warn0('9')
        ..abort('10');

      expect(
          rootMessages,
          equals([
            'Info0: 1',
            // 'Debug1: 2' is not loggable
            'Abort: 3',
            // 'Info0: 4' is not loggable
            'Error: 5',
            'Warn0: 6',
            // 'Debug1: 7' is not loggable
            // 'Debug1: 8' is not loggable
            'Warn0: 9',
            'Abort: 10'
          ]));

      expect(
          aMessages,
          equals([
            // 1,2 and 3 are lower in the hierarchy
            // 'info0: 4' is not loggable
            'Error: 5',
            'Warn0: 6',
            // 'debug1: 7' is not loggable
            // 'debug1: 8' is not loggable
            'Warn0: 9',
            'Abort: 10'
          ]));

      expect(
          cMessages,
          equals([
            // 1 - 7 are lower in the hierarchy
            // 'debug1: 8' is not loggable
            'Warn0: 9',
            'Abort: 10'
          ]));
    });

    test('message logging - lazy functions', () {
      root
        ..reset
        ..level = Level.info0;
      final messages = <String>[];
      root.onRecord.listen((record) {
        messages.add('${record.level}: ${record.message}');
      });

      var callCount = 0;
      String myClosure() => '${++callCount}';

      root
        ..info0(myClosure)
        ..debug2(myClosure) // Should not get evaluated.
        ..warn0(myClosure);

      expect(
          messages,
          equals([
            'Info0: 1',
            'Warn0: 2',
          ]));
    });

    test('message logging - calls toString', () {
      root.level = Level.info0;
      final messages = <String>[];
      final objects = <Object>[];
      final object = new Object();
      root.onRecord.listen((record) {
        messages.add('${record.level}: ${record.message}');
        objects.add(record.object);
      });

      log
        ..debug('controller: ${c.onRecord}')
        ..debug('messages: $messages')
        ..debug('objects: $objects');
      root
        ..info0(5)
        ..info0(false)
        ..info0([1, 2, 3])
        ..info0(() => 10)
        ..info0(object);

      expect(
          messages,
          equals([
            'Info0: 5',
            'Info0: false',
            'Info0: [1, 2, 3]',
            'Info0: 10',
            'Info0: Instance of \'Object\''
          ]));

      expect(objects, [
        5,
        false,
        [1, 2, 3],
        10,
        object
      ]);
    });
  });

  group('recordStackTraceAtLevel', () {
    final root = Logger.root;
    tearDown(() {
      Logger.recordStackTraceAtLevel = Level.off;
      root.clearListeners();
    });

    test('no stack trace by default', () {
      final records = <LogRecord>[];
      root.onRecord.listen(records.add);
      root
        ..error('hello')
        ..warn0('hello')
        ..info0('hello');
      expect(records, hasLength(3));
      expect(records[0].trace, isNull);
      expect(records[1].trace, isNull);
      expect(records[2].trace, isNull);
    });

    test('trace recorded only on requested levels', () {
      final records = <LogRecord>[];
      Logger.recordStackTraceAtLevel = Level.warn0;
      root.onRecord.listen(records.add);
      root
        ..error('hello')
        ..warn0('hello')
        ..info0('hello');
      expect(records, hasLength(3));
      expect(records[0].trace, isNotNull);
      expect(records[1].trace, isNotNull);
      expect(records[2].trace, isNull);
    });

    test('provided trace is used if given', () {
      StackTrace trace;
      Object error;
      try {
        // ignore: only_throw_errors
        throw 'trace';
        // ignore: avoid_catches_without_on_clauses
      } catch (e, t) {
        trace = t;
        error = e;
        log.debug('trace:$t');
      }
      final records = <LogRecord>[];
      Logger.recordStackTraceAtLevel = Level.warn0;
      root.onRecord.listen(records.add);
      root
        ..error('hello')
        ..warn0('hello', 0, error, trace);
      expect(records, hasLength(2));
      expect(records[0].trace, isNot(equals(trace)));
      expect(records[1].trace, trace);
    });

    test('error also generated when generating a trace', () {
      final records = <LogRecord>[];
      Logger.recordStackTraceAtLevel = Level.warn0;
      root.onRecord.listen(records.add);
      root
        ..error('hello')
        ..warn0('hello')
        ..info0('hello');
      expect(records, hasLength(3));
      expect(records[0].error, isNotNull);
      expect(records[1].error, isNotNull);
      expect(records[2].error, isNull);
    });
  });
}
