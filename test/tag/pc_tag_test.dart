// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'pc_tag_test', level: Level.info);

  test('PrivateCreatorTag ACUSON Test', () {
    final pTag = PCTag.make(0x00090010, kUNIndex, 'ACUSON');
    log.debug('pTag: $pTag');
    expect(pTag is PCTagKnown, true);
    log.debug(pTag.info);
    if (pTag is PCTagDefinition) {
      log.debug('${pTag.name}: ${pTag.dataTags}');
    }
  });

  test('PrivateCreatorTag.unknown Test', () {
    final pTag = PCTag.make(0x00090010, kUNIndex, 'foo');
    log.debug('${pTag.info}\n${pTag.name}: ${pTag.dataTags}');
  });

  test('Good CreatorCodeInGroup Test', () {
    final creatorCodes = <int>[0x00090010, 0x001100FF, 0x0035008F];
    final groups = <int>[0x0009, 0x0011, 0x0035];

    for (var i = 0; i < creatorCodes.length; i++) {
      final creator = creatorCodes[i];
      final group = groups[i];
      final v = Tag.isCreatorCodeInGroup(creator, group);
      log.debug('$v: creator: ${dcm(creator)}, '
          'group:  ${dcm(group)}');
      expect(v, true);
    }
  });

  test('Bad CreatorCodeInGroup Test', () {
    final creatorCodes = <int>[0x000110010, 0x0011000e, 0x00350008];
    final groups = <int>[0x0009, 0x0011, 0x0035];

    for (var i = 0; i < creatorCodes.length; i++) {
      final creator = creatorCodes[i];
      final group = groups[i];
      final v = Tag.isCreatorCodeInGroup(creator, group);
      log.debug('$v: creator: ${dcm(creator)}, group:  ${dcm(group)
      }');
      expect(v, false);
    }
  });

  test('Good isPDataCodeInSubgroup Test', () {
    final codes = <int>[0x00091000, 0x0011FF00, 0x00358FFF];
    final groups = <int>[0x0009, 0x0011, 0x0035];
    final subgroups = <int>[0x10, 0xFF, 0x8F];

    for (var i = 0; i < codes.length; i++) {
      final code = codes[i];
      final group = groups[i];
      final subgroup = subgroups[i];
      final v = Tag.isPDataCodeInSubgroup(code, group, subgroup);
      log.debug('$v: code: ${dcm(code)}, '
          'group:  ${dcm(group)}, subgroup:  ${dcm(subgroup)}');
      expect(v, true);
    }
  });

  test('Bad isPDatagit CodeInSubgroup Test', () {
    final codes = <int>[0x00111000, 0x0011000e, 0x003508eFF];
    final groups = <int>[0x0009, 0x0011, 0x0035];
    final subgroups = <int>[0x10, 0xFF, 0x8F];

    for (var i = 0; i < codes.length; i++) {
      final code = codes[i];
      final group = groups[i];
      final subgroup = subgroups[i];
      final v = Tag.isPDataCodeInSubgroup(code, group, subgroup);
      log.debug('$v: code: ${dcm(code)}, '
          'group:  ${dcm(group)}, subgroup:  ${dcm(subgroup)}');
      expect(v, false);
    }
  });
}
