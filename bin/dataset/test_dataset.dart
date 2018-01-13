// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:tag/tag.dart';

void main() {
  Server.initialize();

  final rootDS = new TagRootDataset()..checkIssuesOnAdd = true;
  print('doCheckIssuesOnAdd: ${rootDS.checkIssuesOnAdd}');

  final SL sl0 = new SLtag(PTag.kReferencePixelX0, [kInt32Min]);
  final SL sl2 = new SLtag(PTag.kDisplayedAreaTopLeftHandCorner, [1, 2]);
  final LT lt2 = new LTtag(PTag.kDetectorDescription, ['foo']);
  final FL fl3 = new FLtag(PTag.kAbsoluteChannelDisplayScale, [123.45]);

  PTag.kPerformedLocation.isValidValues(['foo']);

  rootDS..add(sl0)..add(sl2)..add(lt2)..add(fl3);

  //integer type VR
  final value = rootDS.getValue<int>(kReferencePixelX0);
  print('kReferencePixelX0: $value');

  //integer type VR : with VM more then one
  final values = rootDS.getValues<int>(kDisplayedAreaTopLeftHandCorner);
  print('kDisplayedAreaTopLeftHandCorner: $values');

  //string type VR
  final desc = rootDS.getValue<String>(kDetectorDescription);
  print('kDetectorDescription: $desc');
}
