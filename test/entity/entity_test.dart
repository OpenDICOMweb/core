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

      expect(subject0 == subject1, false);
      expect(subject0 == subject2, true);
      expect(subject0.hashCode == subject1.hashCode, false);
      expect(subject0.uid, isNotNull);

      final subject4 = activeStudies.addPatientIfAbsent(subject0);
      log.debug(activeStudies);
      expect(subject4 == subject0, true);

      global.throwOnError = true;
      final subject5 = Patient('A001', subjectUid0, rootDataset);
      expect(() => activeStudies.addPatientIfAbsent(subject5),
          throwsA(const TypeMatcher<DuplicateEntityError>()));

// **      var removeSub = activeStudies.removePatient(subject0);
      activeStudies.removePatient(subject0);
      log.debug(activeStudies);
    });

    test('Patient', () {
      final patientUid = Uid();
      final patient = Patient('A001', patientUid, rootDataset);
      final patient1 = Patient('A002', patientUid, rootDataset);

      expect(patient == patient1, false);
      expect(patient.hashCode == patient1.hashCode, false);
      expect(patient.uid, isNotNull);
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

      expect(study0 == study1, false);
      expect(study0.hashCode == study1.hashCode, false);
      expect(study0.uid, isNotNull);

      //Adding Entity
      subject0.putIfAbsent(study0);
      log.debug(subject0);

      global.throwOnError = true;
      //Adding duplicate Entity
      expect(() => subject0.putIfAbsent(study1),
          throwsA(const TypeMatcher<DuplicateEntityError>()));

      subject0.putIfAbsent(study2);
      log.debug(subject0);

      final s0 = activeStudies.addStudyIfAbsent(study0);
      log.debug(activeStudies);
      expect(s0 == study0, true);
// **      var removeStu = activeStudies.remove(study0);
      log.debug(activeStudies);

      expect(() => activeStudies.addStudyIfAbsent(study1),
          throwsA(const TypeMatcher<DuplicateEntityError>()));

      activeStudies.addStudyIfAbsent(study2);

      expect(() => activeStudies.addStudyIfAbsent(study3),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });

    test('Series', () {
      final seriesUid0 = Uid();
      final seriesUid1 = Uid();
      final studyUid0 = Uid();
      final subjectUid0 = Uid();
      final subject0 = Patient('A001', subjectUid0, rootDataset);
      final study0 = Study(subject0, studyUid0, rootDataset);
      final series0 = Series(study0, seriesUid0, rootDataset);
      final series1 = Series(study0, seriesUid0, rootDataset);
      final series2 = Series(study0, seriesUid1, rootDataset);

      expect(series0 == series1, false);
      expect(series0.hashCode == series1.hashCode, false);
      expect(series0.uid, isNotNull);

      study0.putIfAbsent(series0);
      log.debug(study0);

      //Adding duplicate Entity
      expect(() => study0.putIfAbsent(series1),
          throwsA(const TypeMatcher<DuplicateEntityError>()));

      study0.putIfAbsent(series2);
      log.debug(study0);
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

      expect(instance0 == instance1, false);
      expect(instance0.hashCode == instance1.hashCode, false);
      expect(instance0.uid, isNotNull);

      global.throwOnError = false;
      //Adding Entity
      series0.putIfAbsent(instance0);
      log.debug(series0);

      global.throwOnError = true;
      //Adding duplicate Entity
      expect(() => series0.putIfAbsent(instance1),
          throwsA(const TypeMatcher<DuplicateEntityError>()));

      series0.putIfAbsent(instance2);
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
      log..debug('1: ${cache[1]}')
      ..debug('length: ${cache.length}');
      expect(cache.length == 3, true);
      expect(cache[1] == null, true);
      log.debug('cache: ${cache.keys}\n ${cache.values}');

    });
  });
}
