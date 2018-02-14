// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/private_group.dart';
import 'package:core/src/dataset/base/root_dataset.dart';

import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';

/* Flush
import 'package:core/src/tag/private/pc_tag.dart';
import 'package:core/src/tag/private/pc_tag_definitions.dart';
import 'package:core/src/tag/private/pc_tag_map.dart';
import 'package:core/src/tag/private/pc_tag_names.dart';
import 'package:core/src/tag/private/pd_tag.dart';
import 'package:core/src/tag/private/pd_tag_definitions.dart';
import 'package:core/src/tag/private/pd_tags.dart';*/


List<Element> findAllPrivate(RootDataset rds) {
  for(var e in rds) {
    if (e.isPrivate) {

    } else if (e is SQ) {

    }
  }
}

PrivateGroup getPGroup(Dataset ds) {

}