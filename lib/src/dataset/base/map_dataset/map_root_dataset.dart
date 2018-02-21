// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/entity/patient/patient.dart';

/// A [MapRootDataset].
class MapRootDataset extends RootDataset {
  @override
  final Map<int, Element> fmi;
  /// A [Map] from key to [Element].
  final Map<int, Element> eMap;
  @override
  String path;

  /// Creates an empty, i.e. without ByteElements, [MapRootDataset].
  MapRootDataset(this.fmi, this.eMap, this.path) {
//    print('BDRoot: $this');
  }

  /// Creates an empty, i.e. without ByteElements, [MapRootDataset].
  MapRootDataset.empty(this.path)
      : fmi =  <int, Element>{},
        eMap = <int, Element>{} {
//    print('BDRoot: $this');
  }

  /// Creates a [MapRootDataset] from another [MapRootDataset].
  MapRootDataset.from(MapRootDataset rds)
      : fmi = new Map.from(rds.fmi),
        eMap = new Map.from(rds.eMap);

  @override
  Element operator [](int i) => eMap[i];

  @override
  void operator []=(int i, Element e) => eMap[i] = e;

  @override
  int get length => elements.length;

  @override
  set length(int _) => unsupportedError();

  @override
  Iterable<int> get keys => eMap.keys;
  @override
  Iterable<Element> get elements => eMap.values;

  @override
  Patient get patient => new Patient.fromRDS(this);

}
