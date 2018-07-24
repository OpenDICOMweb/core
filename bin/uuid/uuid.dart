//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart';

void main() {
  Server.initialize(name: 'uuid test', level: Level.debug2);

  for (var i = 0; i < 1000; i++) {
    var uuid = new Uuid();
    checkUuid(uuid);
    log
      ..debug('$i:')
      ..debug('  a:$uuid');
    uuid = new Uuid();
    log.debug('isSecure: ${Uuid.isSecure}');
    checkUuid(uuid);
    log.debug('  b:$uuid');
    uuid = new Uuid();
    checkUuid(uuid);
    log.debug('  c:$uuid');
  }
}

void checkUuid(Uuid uuid) {
  final s = uuid.toString();
  final uuid1 = Uuid.parse(s);
  final t = uuid1.toString();
  if (s != t) log.debug('$s != $t');
  if (!uuid1.isValid) log.debug('**** Uuid0: $uuid');
  if (uuid != uuid1) throw new UuidError('Uuid $uuid != $uuid1');
  if (s.length != 36) log.debug('invalid length ${s.length} in $s');
  if (s[14] != '4') log.debug('No 4 at Byte 6 (${s[14]} in Uuid: $uuid');
  if (!'89AaBb'.contains(s[19]))
    log.debug('No 8|9|A|B at Byte 8 (${s[19]} in Uuid: $uuid');
  if (!uuid.isValid) {
    log.debug('**** Uuid1: $uuid');
  }
}
