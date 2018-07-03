//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:collection';

import 'package:core/src/dataset.dart';
import 'package:core/src/entity/entity.dart';
import 'package:core/src/entity/instance.dart';
import 'package:core/src/entity/patient/patient.dart';
import 'package:core/src/entity/series.dart';
import 'package:core/src/entity/study.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values/date_time.dart';
import 'package:core/src/values/person.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: only_throw_errors

// TODO: create errors for this class
// TODO: make subject a clinical trial subject that is DeIdentified

/// A singleton [class] that contains all [Study]s and [Patient]s
/// in the running system.
class ActiveStudies extends Object with MapMixin<Uid, Study> {
  /// A [Map] from a [Patient] PID to the associated [Patient].
  static final Map<String, Patient> _subjectsByPid = <String, Patient>{};

  /// A [Map] from a [Patient] [Uid] (the Patient's MPI) to the [Patient].
  static final Map<Uid, Patient> _subjects = <Uid, Patient>{};

  /// A [Map] from a [Study] [Uid] to the [Study].
  static final Map<Uid, Study> _studies = <Uid, Study>{};

  /// A [Map] from a [Study] [Uid] to the associated [Patient].
  static final Map<Uid, Patient> _studyPatient = <Uid, Patient>{};

  /// The singleton object in this class
  static ActiveStudies _activeStudies;

  ActiveStudies._();

  static ActiveStudies get activeStudies =>
      _activeStudies ??= new ActiveStudies._();

  /// Returns the [Study] that has [uid].
  @override
  Study operator [](Object uid) => _studies[uid];

  /// Adds [study] to [ActiveStudies], if it is not already present.
  @override
  void operator []=(Uid uid, Study study) {
    if (uid != study.uid) throw 'Invalid study.uid';
    addStudyIfAbsent(study);
  }

  @override
  List<Uid> get keys => _studies.keys;

  int get subjectCount => _subjects.length;
  List<Patient> get subjects => _subjects.values;

  int get studiesCount => _studies.length;
  List<Study> get studies => _studies.values;

  String get stats => 'Patients(${_subjects.length}): ${_subjects.keys}\n'
      'Studies(${_studies.length}): ${_studies.keys}';

  String get summary => '''
ActiveStudies:
  Patients: ${_subjects.length}
  Studies: ${_studies.length}
    $studiesSummary
  ''';

  String get studiesSummary {
    var out = '';
    for (var s in _studies.values) out = s.format(new Formatter());
    return out;
  }

  /// Returns _true_ if a [Study] with [uid] is in [activeStudies].
  @override
  bool containsKey(Object uid) => _studies.containsKey(uid);

  /// Returns _true_ if a [study] is in [activeStudies].
  @override
  bool containsValue(Object study) => _studies.containsValue(study);

  /// If the [Patient] is not already present in [ActiveStudies], it is added.
  Patient addPatientIfAbsent(Patient subject) {
    _subjectsByPid.putIfAbsent(subject.pid, () => subject);
    final v = _subjects.putIfAbsent(subject.uid, () => subject);
    if (v != subject) return duplicateEntityError(v, subject);
    return v;
  }

  /// Removes [subject] and all its [Study]s from [ActiveStudies].
  void removePatient(Patient subject) {
    if (!_subjectsByPid.containsKey(subject.pid) ||
        !_subjects.containsKey(subject.uid)) throw '$subject not present';
    subject.studies.forEach(removeStudy);
    _subjectsByPid.remove(subject.pid);
    _subjects.remove(subject.uid);
  }

  /// If the [Study] is not already present in [ActiveStudies], it is added.
  Study addStudyIfAbsent(Study study) {
    addPatientIfAbsent(study.subject);
    final v = _studies.putIfAbsent(study.uid, () => study);
    if (v != study) return duplicateEntityError(v, study);
    _studyPatient.putIfAbsent(study.uid, () => study.subject);
    return v;
  }

  /// Removes [study] from [ActiveStudies]. If [study] is the last [Study]
  /// in the [study]'s subject, then the [Patient] is also removed from
  /// [ActiveStudies].
  Study removeStudy(Study study) {
    if (study is Study) {
      if (!_studies.containsKey(study.uid) ||
          !_studyPatient.containsKey(study.uid)) throw '$study not present';
      _studies.remove(study.uid);
      _studyPatient.remove(study.uid);
      if (study.subject.studies.isEmpty) removePatient(study.subject);
      return study;
    } else {
      return null;
    }
  }

  /// See _removeStudy_.
  @override
  Study remove(Object study) => removeStudy(study);

  @override
  void clear() {
    _subjectsByPid.clear();
    _subjects.clear();
    _studies.clear();
    _studyPatient.clear();
  }

  Patient search(String pid, {PersonName name, Date dob}) {
    for (var p in _subjects.values) {
      if ((pid == p.pid) &&
          (name == null || name == p.name) &&
          (dob == null || dob == p.dob)) return p;
    }
    return null;
  }

  String format(Formatter z) => z.fmt(this, _studies.values);

  @override
  String toString() =>
      '$runtimeType: ${_subjects.length} Patients, ${_studies.length} Studies';

  //**** Static methods ****

  /// Returns the corresponding [Study], or _null_ if not present.
  static Study lookupStudy(Uid studyUid) => _studies[studyUid];

  /// Returns the corresponding [Patient], or _null_ if not present.
  static Patient lookupPatientByUid(Uid subjectUid) => _subjects[subjectUid];

  /// Returns the corresponding [Patient], or _null_ if not present.
  static Patient lookupPatientByPid(String pid) => _subjectsByPid[pid];

  /// Returns the corresponding [Patient], or _null_ if not present.
  static Patient subjectFromStudy(Uid studyUid) => _studyPatient[studyUid];

/* flush if not needed
  static Patient createPatientIfAbsent(Uid studyUid, RootDataset ds) {
    String pid = ds.subject.pid;
    Patient subject = _subjectsByPid[pid];
    if (subject == null) {
      subject = new Patient.fromRootDataset(ds);
      _subjects[subject.uid] = subject;
      _subjectsByPid[pid] = subject;
    }
    return subject;
  }
*/

/*  flush if not needed
  static Study createStudyIfAbsent(RootDataset ds) {
    //TODO: create Study from dataset
    Uid studyUid = ds.studyUid;
    if (studyUid == null) throw 'RootDataset w/o studyUid';
    Patient subject = createPatientIfAbsent(studyUid, ds);
    Study study = _studies[studyUid];
    if (study == null) study = new Study(subject, studyUid, ds);
    subject.children[studyUid] = study;
    _studies[studyUid] = study;
    _studysPatient[studyUid] = subject;
    //TODO: fix or remove if redundant check
    // _checkIfStudyPresent(study);
    return study;
  }
*/

  /*  flush if not needed
 static bool removeStudyIfPresent(Uid studyUid) {
    Study study = _studies[studyUid];
    if (study == null) return false;
    Patient subject = _studysPatient[studyUid];
    _studies.remove(studyUid);
    _studysPatient.remove(studyUid);
    _subjects.remove(subject.uid);
    _subjectsByPid.remove(subject.pid);
    //TODO: remove redundant check
    return _checkStudyRemoved(study, subject);
  }
*/
/*  flush if not needed
  static bool _checkStudyRemoved(study, subject) {
    if (_studies[study.uid] != null)
      throw "Study with UID ${study.uid} still present in _studies";
    if (_studysPatient[study.uid] != null)
      throw "StudysPatient with UID ${study.uid} still present in _studies";
    if (_subjects.remove(subject.uid) != null)
      throw "Study with UID ${study.uid}  still present in _studies";
    if (_subjectsByPid.remove(subject.cType) != null)
      throw "Study with UID ${study.uid}  still present in _studies";
    return true;
  }
*/

  Entity entityFromRootDataset(RootDataset rds) {
    Entity entity;

    // Get the Patient
    final patient = new Patient.fromRDS(rds);
    entity ??= patient;

    // Get the Study
    var study = lookupStudy(rds.getUid(kSeriesInstanceUID));
    study ??= new Study.fromRootDataset(rds, patient);
    entity ??= study;

    // Get the Series
    var series = study[rds.getUid(kStudyInstanceUID)];
    series ??= new Series.fromRootDataset(rds, study);
    entity ??= series;

    // Get the Instance
    var instance = series[rds.getUid(kSOPInstanceUID)];
    if (instance != null) throw 'Entity($entity) already present';
    instance = new Instance.fromRDS(rds, series);
    // Return the highest level [Entity] created.
    return entity ??= instance;
  }

  /// Adds the [Entity] contained in [rds] to the [ActiveStudies].
  //TODO: this will be expanded to handle Mint study and series objects.
  static Entity addSopInstance(RootDataset rds) {
    final e = rds[kPatientID];
    if (e == null) return elementNotPresentError(PTag.kPatientID);
    final String pid = e.value;
    var subject = _subjectsByPid[pid];
    subject ??= new Patient.fromRDS(rds);
    final study = subject.createStudyFromRootDataset(rds);
    final series = study.createSeriesFromRootDataset(rds);
    final instance = series.createInstanceFromRootDataset(rds);
    activeStudies.addStudyIfAbsent(study);
    return instance;
  }
}

final ActiveStudies activeStudies = new ActiveStudies._();
