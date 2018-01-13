// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';


// TODO: add tests for all three errors in core/src/uid/uid_errors.dart.

void main() {
  Server.initialize(name: 'uid_test', level: Level.info);

  group('WKUid Map Test', () {
    test('Well known Uid String validation', () {
      for (var s in wellKnownUids.keys) {
        expect(isValidUidString(s), true);
      }

      for (var s in wellKnownUids.keys) {
	      final uid = Uid.parse(s);
        final v = uid is WKUid;
        if (!v) log.debug('Bad SopClass: $uid');
        expect(uid is WKUid, true);
      }

      for (var c in wkUids) {
        expect(c is WKUid, true);
      }
    });
  });
}
