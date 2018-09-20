//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/group/group_base.dart';
import 'package:core/src/element.dart';
import 'package:core/src/utils/indenter.dart';
import 'package:core/src/utils/logger.dart';
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: only_throw_errors, public_member_api_docs

/// A [PublicGroup] can only contain Sequences ([SQ]) that
/// contain Public pElement]s.
class PublicGroup implements GroupBase {
  @override
  final int gNumber;
  List<SQ> sequences = <SQ>[];
  List<SQ> privateSQs = <SQ>[];

  @override
  Map<int, Element> members = <int, Element>{};

  /// Constructor
  PublicGroup(Element e, Dataset sqParent)
      : assert(e.group.isEven),
        gNumber = e.group {
    add(e, sqParent);
  }

  @override
  int get length => members.length;

  @override
  void add(Element e0, Dataset sqParent) {
    // members[e.code] = SQtag.from(sq);
    members[e0.code] = e0;
    if (e0 is SQ) {
      sequences.add(e0);
      for (var item in e0.items)
        for (var e1 in item.elements) if (e1.group.isOdd) privateSQs.add(e0);
    }
  }

  @override
  String get info {
    final s = '$runtimeType(${hex16(gNumber)}): ${members.values.length}';
    final sb = Indenter(s)..down;
    members.values.forEach(sb.writeln);
    sb.up;
    return '$sb';
  }

  String format(Formatter z) => z.fmt(
      '$runtimeType(${hex16(gNumber)}): '
      '${members.values.length} Groups',
      members);

  String format0(Formatter z) =>
      '${z(this)}\n${z.fmt('Groups(${members.values.length})', members)}';

  @override
  String toString() =>
      '$runtimeType(${hex16(gNumber)}) ${members.values.length} members';
}
