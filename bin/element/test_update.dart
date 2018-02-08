// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';

void main() {

    final map0 = new MapAsList();
    //final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
    final as0 = new AStag(PTag.kPatientAge, ['024Y']);

    //map0[fd0.code] = fd0;
    map0[as0.code] = as0;

    final update0 = map0.update(as0.key, <String>[]);
    assert(update0 == as0);
    assert(update0.isEmpty, false);

    /* update0 = map0.update(as0.key);
      expect(update0.isEmpty, true);
      log.debug('update0: $update0');*/

}