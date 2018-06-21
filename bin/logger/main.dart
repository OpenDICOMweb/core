//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/core.dart';

void main() {
	final foo = '.'.split('.');
	print('foo(${foo.length}): $foo');
  nonHierarchicalLoggerTest();

 // loggerTest('NonHierarchical', isHierarchical: false, doError: false);
 // loggerTest('Hierarchical', isHierarchical: true, doError: true);
}

const String defaultDateTimeFormat = 'yyyy.mm.dd HH:mm:ss.SSS';

void nonHierarchicalLoggerTest() {
	Logger.isHierarchicalEnabled = false;
  print('\nNon Hierarchical Test');
	print('  Root = ${Logger.root}');
  print('  ${Logger.show()}');

  final log = new Logger('foo', Level.debug);
  print('logger "log": $log');

	final logFile = new LogFile(prefix: 'log');
  final handler = new FileHandler(logFile, doPrint: true);
  print('handler: $handler');
  Logger.root.onRecord.listen(handler);

	print('"log0":');
  final log0 = new Logger('log0', Level.warn)
    ..debug('Shouldn\'t print')
    ..info0('Shouldn\'t print')
    ..warn('Should print')
    ..error('Should print');
  final record = log0.warn('test');
  print(record.info);
  print(log0);
  print('${Logger.show()}');
  print('  Log Level = ${log0.level}');
  print('Levels: ${log0.level}, level: ${log0.level}');

  print('log0.log1: $log0');
	Logger.show();
  final log1 = new Logger('log0.log1', Level.debug)
    ..debug3('Shouldn\'t print')
    ..debug2('Shouldn\'t print')
    ..debug('Should print')
    ..warn('Should print')
    ..error('Should print');
	print('log0.log1: $log1');
}

void loggerTest(String name, {bool isHierarchical, bool doError}) {
  print('\n\nLogger Test: $name');
  print('  Test Record:');
  final record = new LogRecord(Level.debug, 'Bad Foo', 'Module');
  print('    record:$record');

  //TODO: fix this stuff
  //print('setup BaseLogger:');
  //var handler = new ListHandler(name: 'test.log', doPrint: true);
  //print('handler: $handler');
  //Logger.root.onRecord.listen(handler);
  //BaseLogger.init();

  // Logger.root.level = Level.info;
  Logger.isHierarchicalEnabled = isHierarchical;
  print('Log Root Level = ${Logger.root.level}');

  print('foo0:');
  new Logger('foo0', Level.config)
    ..debug('shouldn\'t print')
    ..info0('shouldn\'t print')
    ..config('should print')
    ..warn('should print');

  print('foo1:');
  new Logger('foo0.foo1', Level.info0)
    ..debug('shouldn\'t print')
    ..info0('should print')
    ..config('should print')
    ..warn('should print');

  print('foo2:');
  final foo2 = new Logger('foo0.foo1.foo2', Level.debug)
    ..debug('should print')
    ..info0('should print')
    ..config('should print')
    ..warn('should print');

  if (doError) foo2.error('should do stacktrace');
}
