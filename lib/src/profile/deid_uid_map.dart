// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.


import 'package:core/src/uid/uid.dart';

/*
class StudyUids {
  final Uid idedStudyUid;
  final Uid deidedStudyUid;
  final Map<Uid, UidMap> studiesMap;

  StudyUids()
      : deidedStudyUid = new Uid(),
        studiesMap = new UidMap();

  Uid lookup(Uid study, [Uid series, Uid instance]) {
    if (study == idedStudyUid && series == null) return deidedStudyUid;
    final deIdSeries = seriesMap[series];
      if (deIdSeries != null) return series;
      final seriesMap = new DeIdUidSeriesMap(series);
      seriesUids[series] = new DeIdUidSeriesMap(series);
        return deIdSeries;
      } else {
        var deIdInstance = seriesUids[instance];
        if (deIdInstance != null) return deIdInstance;
        deIdInstance = new Uid();
        seriesUids[instance] = deIdInstance;
      }
    }
  }
}

class SeriesUids {
  final Uid idSeriesUid;
  final UidMap uidMap;

  SeriesUids(this.idSeriesUid)
      : uidMap = new UidMap(idSeriesUid);


  Uid get deIdSeriesUid => uidMap.parentDeIdUid;
  Uid operator [](Uid instance) => lookup(instance);

  Uid lookup(Uid instance, [Uid series]) {
    if (series != null && series != uidMap.parentUid)
      throw 'Invalid Parent Uid: ${uidMap.parentUid}'
    {
      return idedSeriesUid;
    } else {
      final deIdInstance = uidMap[instance];
      if (deIdInstance != null) {
        return deIdInstance;
      } else {
        return null;
      }
    }
  }

  void add(Uid idUid) {
    final out = uidMap.putIfAbsent(idUid, () => new Uid());
    if (out)
  }
}
*/

class UidMap {
  final Uid parentUid;
  final Uid parentDeIdUid;
  final  _uidMap = <Uid, Uid>{};

  UidMap(this.parentUid) : parentDeIdUid = new Uid();

  Uid operator [](Uid instance) => lookup(instance);

  Uid lookup(Uid idUid, [Uid parent]) {
    assert(parentUid == null || parent == parentUid);
    final deIdUid = _uidMap[idUid];
    if (deIdUid != null) return deIdUid;
    final newDeIdUid = new Uid();
    final result = _uidMap.putIfAbsent(idUid, () => newDeIdUid);
    assert(newDeIdUid == result);
    return newDeIdUid;
  }
}