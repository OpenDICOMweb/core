// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/src/element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/logger.dart';

class Entry {
  final Level level;
  final Element element;
  final String msg;

  Entry(this.level, this.element, [this.msg]);

  String get name => level.name;

  Tag get tag => (element != null) ? element.tag : null;

  String get keyword => (element != null) ? element.tag.keyword : null;

  String get json => '''
  { "@type": "Message",b
    "Severity": "$level",
    "Element": '$element',
    "Message": "$msg" }
  ''';

  @override
  String toString() => (msg == null) ? '$name: $element' : '$name: $element - $msg';

  static Entry invalidNumberOfValues(Element e) =>
      new Entry(Level.error, e, 'Element with an invalid Number of values');
}

/// A warning about a Dataset or an Element in a Dataset.
class StatusReport {
  final String name;
  final List<Entry> entries = <Entry>[];
  bool doPrint;

  StatusReport(this.name, {this.doPrint: true});

  /// Turn console printing on.
  bool get printOn => doPrint = true;

  /// Turn console printing off.
  bool get printOff => doPrint = false;

  // Log(this.ieSeverity);
  Entry log(Level level, Element e, String message) {
    final r = new Entry(level, e, message);
    entries.add(r);
    if (doPrint) print(r);
    return r;
  }

  Entry call(Level level, Element e, String msg) => log(level, e, msg);

  List<Entry> recordsAt(Level level) => search(level);

  /// Log message at Level [Level.debug].
  Entry debug(Element e, [String msg]) => log(Level.debug, e, msg);

  /// Log message at Level [Level.config].
  Entry config(Element e, [String msg]) => log(Level.config, e, msg);

  /// Log message at Level [Level.info].
  Entry info(Element e, [String msg]) => log(Level.info, e, msg);

  /// Log message at Level [Level.warn].
  Entry warning(Element e, [String msg]) => log(Level.warn, e, msg);

  /// Log message at Level [Level.error].
  Entry error(Element e, [String msg]) => log(Level.error, e, msg);

  /// Log message at Level [Level.quarantine].
  Entry quarantine(Element e, [String msg]) => log(Level.quarantine, e, msg);

  /// Log message at Level [Level.abort].
  Entry abort(Element e, [String msg]) => log(Level.abort, e, msg);

  /// Log message at Level [Level.fatal].
  Entry fatal(Element e, [String msg]) {
    final entry = log(Level.fatal, e, msg);
    throw new FatalError(entry);
  }

  List<Entry> search(Level level) {
    final results = <Entry>[];
    for (var e in entries) if (e.level == level) results.add(e);
    return results;
  }

  void add(Entry m) => entries.add(m);

  String get json => '''
  {"@type": "StatusLog",
   "@date": ${new DateTime.now()},
   "Messages": [ ${entries.join(",")} ] }
   ''';

  @override
  String toString() => 'Status Log:\n  ${entries.join("\n  ")}';

  Entry invalidNumberOfValues(Element e) =>
      error(e, 'Element with an invalid Number of values');
}

class FatalError extends Error {
	Entry entry;

	FatalError(this.entry);

	@override
	String toString() => '$entry';
}
