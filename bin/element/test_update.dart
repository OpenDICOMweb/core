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


    final map0 = new TagRootDataset.empty();
    //final fd0 = new FDtag(PTag.kBlendingWeightConstant, [15.24]);
    final as0 = new AStag(PTag.kPatientAge, ['024Y']);

    //map0[fd0.code] = fd0;
    map0[as0.code] = as0;

    final update0 = map0.update(as0.code, <String>[]);
    assert(update0 == as0);
    assert(update0.isEmpty, false);

    /* update0 = map0.update(as0.key);
      expect(update0.isEmpty, true);
      log.debug('update0: $update0');*/

}