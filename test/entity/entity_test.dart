//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

import 'package:quiver/collection.dart';

void main() {
  Server.initialize(name: 'entity_test', level: Level.info);

  group('Entity Tests', () {
    final rootDataset = TagRootDataset.empty();

    test('Patient', () {
      final subjectUid0 = Uid();
// **      final subjectUid1 = Uid();
      final subject0 = Patient('A001', subjectUid0, rootDataset);
      final subject1 = Patient('A002', subjectUid0, rootDataset);
      final subject2 = subject0;
// **      Patient subject3 = Patient('A003', subjectUid1, rootDataset);

      expect(subject0 == subject1, true);
      expect(subject0 == subject2, true);
      expect(subject0.hashCode == subject1.hashCode, true);
      expect(subject0.key, isNotNull);

      final subject4 = activeStudies.addPatientIfAbsent(subject0);
      log.debug(activeStudies);
      expect(subject4 == subject0, true);

      global.throwOnError = true;
      final subject5 = Patient('A001', subjectUid0, rootDataset);
      expect(activeStudies.addPatientIfAbsent(subject5), equals(subject0));
//          throwsA(const TypeMatcher<DuplicateEntityError>()));

// **      var removeSub = activeStudies.removePatient(subject0);
      activeStudies.removePatient(subject0);
      log.debug(activeStudies);
    });

    test('Patient', () {
      final patientUid = Uid();
      final patient = Patient('A001', patientUid, rootDataset);
      final patient1 = Patient('A002', patientUid, rootDataset);

      expect(patient == patient1, true);
      expect(patient.hashCode == patient1.hashCode, true);
      expect(patient.key, isNotNull);
    });

    test('Study', () {
      final studyUid0 = Uid();
      final studyUid1 = Uid();
      final subjectUid0 = Uid();
      final subjectUid1 = Uid();
      final subject0 = Patient('A001', subjectUid0, rootDataset);
      final subject1 = Patient('A002', subjectUid1, rootDataset);
      final subject3 = Patient('A001', subjectUid0, rootDataset);
      final study0 = Study(subject0, studyUid0, rootDataset);
      final study1 = Study(subject3, studyUid0, rootDataset);
      final study2 = Study(subject1, studyUid1, rootDataset);
      final study3 = Study(subject1, studyUid1, rootDataset);

      expect(study0 == study1, true);
      expect(study0.hashCode == study1.hashCode, true);
      expect(study0.key, isNotNull);

      //Adding Entity
      subject0.addIfAbsent(study0);
      log.debug(subject0);

      global.throwOnError = true;
      //Adding duplicate Entity
      expect(subject0.addIfAbsent(study1), equals(study0));

      expect(subject0.addIfAbsent(study2), equals(study0));
      log.debug(subject0);

      final s0 = activeStudies.addStudyIfAbsent(study0);
      log.debug(activeStudies);
      expect(s0 == study0, true);
// **      var removeStu = activeStudies.remove(study0);
      log.debug(activeStudies);

      expect(activeStudies.addStudyIfAbsent(study1), equals(study0));

      activeStudies.addStudyIfAbsent(study2);

      expect(activeStudies.addStudyIfAbsent(study3), equals(study0));
    });

    test('Series', () {
      final subjectUid0 = Uid();
      final studyUid0 = Uid();
      final seriesUid0 = Uid();

      final subject0 = Patient('A001', subjectUid0, rootDataset);
      final study0 = Study(subject0, studyUid0, rootDataset);
      final series0 = Series(study0, seriesUid0, rootDataset);
      final series1 = Series(study0, seriesUid0, rootDataset);

      expect(series0 == series1, true);
      expect(identical(series0, series1), false);
      expect(series0.hashCode == series1.hashCode, true);
      expect(series0.key, isNotNull);

      study0.addIfAbsent(series0);
      log.debug(study0);

      //Adding duplicate Entity
      expect(study0.addIfAbsent(series1), equals(series0));
      expect(study0.addIfAbsent(series1), equals(series1));
    });

    test('Instance', () {
      final instanceUid0 = Uid();
      final instanceUid1 = Uid();
      final studyUid0 = Uid();
      final subjectUid0 = Uid();
      final seriesUid0 = Uid();
      final subject0 = Patient('A001', subjectUid0, rootDataset);
      final study0 = Study(subject0, studyUid0, rootDataset);
      final series0 = Series(study0, seriesUid0, rootDataset);
      final instance0 = Instance(series0, instanceUid0, rootDataset);
      final instance1 = Instance(series0, instanceUid0, rootDataset);
      final instance2 = Instance(series0, instanceUid1, rootDataset);

      expect(instance0 == instance1, true);
      expect(instance0.hashCode == instance1.hashCode, true);
      expect(instance0.key, isNotNull);

      global.throwOnError = false;
      //Adding Entity
      series0.putIfAbsent(instance0.key, () => instance0);
      log.debug(series0);

      global.throwOnError = true;
      //Adding duplicate Entity
      expect(series0.addIfAbsent(instance1), equals(instance0));

      series0.putIfAbsent(instance2.key, () => instance2);
      log.debug(series0);
    });

    test('Iru_map', () {
      final cache = LruMap<int, String>(maximumSize: 20);
      cache[0] = 'zero';
      log.debug('0: ${cache[0]}');
      expect(cache[0] == 'zero', true);

      cache[1] = '1';
      log.debug('1: ${cache[1]}');
      expect(cache[1] == '1', true);

      cache.putIfAbsent(3, () => 'three');
      log.debug('3: ${cache[3]}');
      expect(cache[3] == 'three', true);

      cache.putIfAbsent(3, () => '-3');
      log.debug('3: ${cache[3]}');
      expect(cache[3] == 'three', true);

      cache[1] = null;
      log..debug('1: ${cache[1]}')..debug('length: ${cache.length}');
      expect(cache.length == 3, true);
      expect(cache[1] == null, true);
      log.debug('cache: ${cache.keys}\n ${cache.values}');
    });
  });
}
