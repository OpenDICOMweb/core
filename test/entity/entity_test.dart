// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'entity_test', level: Level.info0);

  group('Entity Tests', () {
    final rootDataset = new TagRootDataset();

    test('Patient', () {
      final subjectUid0 = new Uid();
// **      final subjectUid1 = new Uid();
      final subject0 = new Patient('A001', subjectUid0, rootDataset);
      final subject1 = new Patient('A002', subjectUid0, rootDataset);
      final subject2 = subject0;
// **      Patient subject3 = new Patient('A003', subjectUid1, rootDataset);

      expect(subject0 == subject1, false);
      expect(subject0 == subject2, true);
      expect(subject0.hashCode == subject1.hashCode, false);
      expect(subject0.uid, isNotNull);

      final subject4 = activeStudies.addPatientIfAbsent(subject0);
      log.debug(activeStudies);
      expect(subject4 == subject0, true);

      system.throwOnError = true;
      final subject5 = new Patient('A001', subjectUid0, rootDataset);
      expect(() => activeStudies.addPatientIfAbsent(subject5),
          throwsA(const isInstanceOf<DuplicateEntityError>()));

// **      var removeSub = activeStudies.removePatient(subject0);
      activeStudies.removePatient(subject0);
      log.debug(activeStudies);
    });

    test('Patient', () {
      final patientUid = new Uid();
      final patient = new Patient('A001', patientUid, rootDataset);
      final patient1 = new Patient('A002', patientUid, rootDataset);

      expect(patient == patient1, false);
      expect(patient.hashCode == patient1.hashCode, false);
      expect(patient.uid, isNotNull);
    });

    test('Study', () {
      final studyUid0 = new Uid();
      final studyUid1 = new Uid();
      final subjectUid0 = new Uid();
      final subjectUid1 = new Uid();
      final subject0 = new Patient('A001', subjectUid0, rootDataset);
      final subject1 = new Patient('A002', subjectUid1, rootDataset);
      final subject3 = new Patient('A001', subjectUid0, rootDataset);
      final study0 = new Study(subject0, studyUid0, rootDataset);
      final study1 = new Study(subject3, studyUid0, rootDataset);
      final study2 = new Study(subject1, studyUid1, rootDataset);
      final study3 = new Study(subject1, studyUid1, rootDataset);

      expect(study0 == study1, false);
      expect(study0.hashCode == study1.hashCode, false);
      expect(study0.uid, isNotNull);

      //Adding Entity
      subject0.putIfAbsent(study0);
      log.debug(subject0);

      system.throwOnError = true;
      //Adding duplicate Entity
      expect(() => subject0.putIfAbsent(study1),
          throwsA(const isInstanceOf<DuplicateEntityError>()));

      subject0.putIfAbsent(study2);
      log.debug(subject0);

      final s0 = activeStudies.addStudyIfAbsent(study0);
      log.debug(activeStudies);
      expect(s0 == study0, true);
// **      var removeStu = activeStudies.remove(study0);
      log.debug(activeStudies);

      expect(() => activeStudies.addStudyIfAbsent(study1),
          throwsA(const isInstanceOf<DuplicateEntityError>()));

      activeStudies.addStudyIfAbsent(study2);

      expect(() => activeStudies.addStudyIfAbsent(study3),
          throwsA(const isInstanceOf<DuplicateEntityError>()));
    });

    test('Series', () {
      final seriesUid0 = new Uid();
      final seriesUid1 = new Uid();
      final studyUid0 = new Uid();
      final subjectUid0 = new Uid();
      final subject0 = new Patient('A001', subjectUid0, rootDataset);
      final study0 = new Study(subject0, studyUid0, rootDataset);
      final series0 = new Series(study0, seriesUid0, rootDataset);
      final series1 = new Series(study0, seriesUid0, rootDataset);
      final series2 = new Series(study0, seriesUid1, rootDataset);

      expect(series0 == series1, false);
      expect(series0.hashCode == series1.hashCode, false);
      expect(series0.uid, isNotNull);

      study0.putIfAbsent(series0);
      log.debug(study0);

      //Adding duplicate Entity
      expect(() => study0.putIfAbsent(series1),
          throwsA(const isInstanceOf<DuplicateEntityError>()));

      study0.putIfAbsent(series2);
      log.debug(study0);
    });

    test('Instance', () {
      final instanceUid0 = new Uid();
      final instanceUid1 = new Uid();
      final studyUid0 = new Uid();
      final subjectUid0 = new Uid();
      final seriesUid0 = new Uid();
      final subject0 = new Patient('A001', subjectUid0, rootDataset);
      final study0 = new Study(subject0, studyUid0, rootDataset);
      final series0 = new Series(study0, seriesUid0, rootDataset);
      final instance0 = new Instance(series0, instanceUid0, rootDataset);
      final instance1 = new Instance(series0, instanceUid0, rootDataset);
      final instance2 = new Instance(series0, instanceUid1, rootDataset);

      expect(instance0 == instance1, false);
      expect(instance0.hashCode == instance1.hashCode, false);
      expect(instance0.uid, isNotNull);

      system.throwOnError = false;
      //Adding Entity
      series0.putIfAbsent(instance0);
      log.debug(series0);

      system.throwOnError = true;
      //Adding duplicate Entity
      expect(() => series0.putIfAbsent(instance1),
          throwsA(const isInstanceOf<DuplicateEntityError>()));

      series0.putIfAbsent(instance2);
      log.debug(series0);
    });
  });
}
