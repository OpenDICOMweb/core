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
// ignore_for_file: public_member_api_docs

// TODO: create errors for this class
// TODO: make subject a clinical trial subject that is DeIdentified

/// A singleton [class] that contains all [Study]s and [Patient]s
/// in the running system.
class ActiveStudies extends Object with MapMixin<Uid, Study> {
  ActiveStudies._() {
    print('************* created ActiveStudies');
  }

  /// Returns the [Study] that has [uid].
  @override
  Study operator [](Object uid) => uid is Uid ? _studies[uid] : null;

  /// Adds [study] to [ActiveStudies], if it is not already present.
  @override
  void operator []=(Uid uid, Study study) {
    if (uid != study.uid) throw 'Invalid study.uid';
    addStudyIfAbsent(study);
  }

  @override
  Iterable<Uid> get keys => _studies.keys;

  int get subjectCount => _patients.length;
  Iterable<Patient> get patients => _patients.values;

  int get studiesCount => _studies.length;
  Iterable<Study> get studies => _studies.values;

  int get seriesCount => series.length;
  Iterable<Series> get series => _series.values;

  int get instanceCount => instances.length;
  Iterable<Instance> get instances => _instances.values;

  String get stats => 'Patients(${_patients.length}): ${_patients.keys}\n'
      'Studies(${_studies.length}): ${_studies.keys}';

  String get summary => '''
ActiveStudies:
  Patients: ${_patients.length}
  $patientsSummary
  Studies: ${_studies.length}
  $studiesSummary
  ''';

  String get patientsSummary {
    //  var out = '';
    //  for (var s in _subjects.values) out = s.format(Formatter());
    //    return out;
    final sb = StringBuffer();
    for (var s in _patients.values) sb.writeln('\t$s');
    return '$sb';
  }

  String get studiesSummary {
//    var out = '';
//    for (var s in _studies.values) out = s.format(Formatter());
//    return out;
    final sb = StringBuffer();
    for (var s in _studies.values) sb.writeln('\t$s');
    return '$sb';
  }

  /// Returns _true_ if a [Study] with [uid] is in [activeStudies].
  @override
  bool containsKey(Object uid) => _studies.containsKey(uid);

  /// Returns _true_ if a [study] is in [activeStudies].
  @override
  bool containsValue(Object study) => _studies.containsValue(study);

  /// If the [Patient] is not already present in [ActiveStudies], it is added.
  Patient addPatientIfAbsent(Patient patient) {
    _subjectsByPid.putIfAbsent(patient.pid, () => patient);
    return _patients.putIfAbsent(patient.uid, () => patient);
  }

  /// Removes [patient] and all its [Study]s from [ActiveStudies].
  void removePatient(Patient patient) {
    if (!_subjectsByPid.containsKey(patient.pid) ||
        !_patients.containsKey(patient.uid)) throw '$patient not present';
    patient.studies.forEach(removeStudy);
    _subjectsByPid.remove(patient.pid);
    _patients.remove(patient.uid);
  }

  /// If the [Study] is not already present in [ActiveStudies], it is added.
  Study addStudyIfAbsent(Study study) {
    final patient = study.patient;
    addPatientIfAbsent(patient);
    final v = _studies.putIfAbsent(study.uid, () => study);
    _studyPatient.putIfAbsent(study.uid, () => patient);
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
      if (study.patient.studies.isEmpty) removePatient(study.patient);
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
    _patients.clear();
    _studies.clear();
    _studyPatient.clear();
  }

  Patient search(String pid, {PersonName name, Date dob}) {
    for (var p in _patients.values) {
      if ((pid == p.pid) &&
          (name == null || name == p.name) &&
          (dob == null || dob == p.dob)) return p;
    }
    return null;
  }

  String format(Formatter z) => z.fmt(this, _studies.values);

  @override
  String toString() =>
      '$runtimeType: ${_patients.length} Patients, ${_studies.length} Studies';

  //**** Static methods ****

  /// A [Map] from a [Patient] PID to the associated [Patient].
  static final Map<String, Patient> _subjectsByPid = <String, Patient>{};

  /// A [Map] from a [Patient] [Uid] (the Patient's MPI) to the [Patient].
  static final Map<Uid, Patient> _patients = <Uid, Patient>{};

  /// A [Map] from a [Study] [Uid] to the [Study].
  static final Map<Uid, Study> _studies = <Uid, Study>{};

  /// A [Map] from a [Study] [Uid] to the associated [Patient].
  static final Map<Uid, Patient> _studyPatient = <Uid, Patient>{};

  /// A [Map] from a [Series] [Uid] to the [Series].
  static final Map<Uid, Series> _series = <Uid, Series>{};

  /// A [Map] from a [Instance] [Uid] to the [Instance].
  static final Map<Uid, Instance> _instances = <Uid, Instance>{};

  /// Returns the corresponding [Study], or _null_ if not present.
  static Study lookupStudy(Uid studyUid) => _studies[studyUid];

  /// Returns the corresponding [Patient], or _null_ if not present.
  static Patient lookupPatientByUid(Uid subjectUid) => _patients[subjectUid];

  /// Returns the corresponding [Patient], or _null_ if not present.
  static Patient lookupPatientByPid(String pid) => _subjectsByPid[pid];

  /// Returns the corresponding [Patient], or _null_ if not present.
  static Patient subjectFromStudy(Uid studyUid) => _studyPatient[studyUid];

  Entity entityFromRootDataset(RootDataset rds) {
    Entity entity;

    // Get the Patient
    final patient = Patient.fromRootDataset(rds);
/* Patient is handled by study
    if (patient != null) addPatientIfAbsent(patient);
    entity ??= patient;
*/

    // Get the Study
    var study = lookupStudy(rds.getUid(kStudyInstanceUID));
    study ??= Study.fromRootDataset(rds, patient);
    if (study != null) addStudyIfAbsent(study);
    entity ??= study;

    // Get the Series
    final s = study[rds.getUid(kStudyInstanceUID)];
    // ignore: avoid_as
    var series = s as Series;
    series ??= Series.fromRootDataset(rds, study);
    entity ??= series;

    // Get the Instance
    var instance = series[rds.getUid(kSOPInstanceUID)];
    if (instance != null) throw 'Entity($entity) already present';
    instance = Instance.fromRootDataset(rds, series);
    instance ??= series.addIfAbsent(instance);
    // Return the highest level [Entity] created.
    return entity ??= instance;
  }

  /// Adds the [Entity] contained in [rds] to the [ActiveStudies].
  //TODO: this will be expanded to handle Mint study and series objects.
  static Entity addSopInstance(RootDataset rds) {
    final e = rds[kPatientID];
    if (e == null) return elementNotPresentError(PTag.kPatientID);
    final String pid = e.value;
    var patient = _subjectsByPid[pid];
    patient ??= Patient.fromRootDataset(rds);

    final studyUid = lookupEntityUid(rds, kStudyInstanceUID);
    var study = _studies[studyUid];
    study ??= Study.fromRootDataset(rds, patient);
    patient.addIfAbsent(study);

    final seriesUid = lookupEntityUid(rds, kSeriesInstanceUID);
    var series = _series[seriesUid];
    series ??= Series.fromRootDataset(rds, study);
    study.addIfAbsent(series);
    _series[seriesUid] = series;

    final instanceUid = lookupEntityUid(rds, kSOPInstanceUID);
    var instance = _instances[instanceUid];
    if (instance != null) return throw 'duplicate instance error: $instanceUid';

    instance ??= Instance.fromRootDataset(rds, series);
    final v = series.addIfAbsent(instance);
    _instances[instanceUid] = instance;
    if (v != instance)
      return throw 'duplicate instance error: old: $v new:$instance';
    activeStudies.addStudyIfAbsent(study);
    return instance;
  }

  static Uid lookupEntityUid(RootDataset rds, int code,
      {bool addIfMissing = true}) {
    final e = rds[code];
    if (e == null) return elementNotPresentError(PTag.lookupByCode(code));
    final String s = e.value;
    return activeEntityUids.addIfAbsent(s);
  }
}

/// A [Map] from [String] to [Uid] for all [Entity]s known to the system.
class ActiveEntityUids {
  final Map<String, Uid> uids = {};

  /// Internal Constructor
  ActiveEntityUids._();

  /// Returns the [Entity] [Uid] associated with [s].
  Uid operator [](String s) => uids[s];

  /// Returns the [Uid] associated with [s]. If the Map has no key [s],
  /// a new [Uid] a new entry is created for [s] and
  Uid addIfAbsent(String s) {
    var v = uids[s];
    if (v != null) return v;

    v ??= Uid(s);
    return (v == null) ? null : uids[s] = v;
  }
}

final ActiveEntityUids activeEntityUids = ActiveEntityUids._();
final ActiveStudies activeStudies = ActiveStudies._();
