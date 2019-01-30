//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/entity/active_studies.dart';
import 'package:core/src/entity/entity.dart';
import 'package:core/src/entity/ie_level.dart';
import 'package:core/src/entity/study.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values/date_time.dart';
import 'package:core/src/values/person.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: only_throw_errors
// ignore_for_file: public_member_api_docs

/// The [Patient] of a DICOM [Study].
class Patient extends Entity {
  final String pid;
  PersonName _name;
  Date _dob;
  Sex _sex;

  /// Creates a  [Patient].
  Patient(this.pid, Uid uid, RootDataset rds,
      [Map<Uid, Study> studies, this._name, this._dob, this._sex])
      : super(null, uid, rds, studies ?? <Uid, Study>{});

  /// Returns a copy of _this_ [Patient], but with a  [Uid].
  Patient.from(Patient patient, RootDataset rds, this.pid)
      : _name = patient.name,
        _dob = patient._dob,
        _sex = patient._sex,
        super(null, Uid(), rds, <Uid, Study>{});

  /// Returns a  [Patient] created from the [RootDataset].
  factory Patient.fromRootDataset(RootDataset rds) {
    final pid = rds.patientId;
    final name = rds.patientName;
    final dob = rds.patientBirthDate;
    final sex = rds.patientSex;
    final patient = search(pid, name, dob);
    return (patient != null)
        ? patient
        : Patient(pid, Uid(), rds, <Uid, Study>{}, name, dob, sex);
  }

  @override
  IELevel get level => IELevel.subject;
  @override
  Type get childType => Study;

  /// Returns the [Study]s of this [Patient].
  Iterable<Study> get studies => childMap.values;

  /// The [PersonName] of the person who is _this_ [Patient];
  PersonName get name => _name ??= rds.patientName;

  /// Returns the Birth Date of _this_
  Date get dob => _dob ??= rds.patientBirthDate;

  /// Returns the [Sex] of _this_.
  Sex get sex => _sex ??= rds.patientSex;

  /// Returns the [Sex] of _this_.
  int get age => throw UnimplementedError('');

  Study createStudyFromRootDataset(RootDataset rds) =>
      Study.fromRootDataset(rds, this);

  @override
  String toPath() =>  '/$uid';

  static Patient search(String pid, [PersonName name, Date dob]) =>
      activeStudies.search(pid, name: name, dob: dob);
}

//TODO: make this a Clinical Trial Subject
/// THE [DICOM] [Subject] Information Entity.
class Subject extends Patient {
  /// Creates a  [Subject].
  Subject(String pid, Uid key, RootDataset rds,
      {Map<Uid, Study> studies, PersonName name, Date dob, Sex sex})
      : super(pid, key, rds, (studies == null) ? <Uid, Study>{} : studies, name,
            dob, sex);

  /// Returns a  [Subject] created from the [RootDataset].
  factory Subject.fromRDS(RootDataset rds) {
    final e = rds[kPatientID];
    if (e == null) return elementNotPresentError(e);
    if (!e.hasValidValues) return badValues(e.value);
    final key = Uid();
    final String pid = e.value;
    return Subject(pid, key, rds);
  }

  @override
  IELevel get level => IELevel.subject;
}

// **** nothing tested below this line

class IssuerOfPatientId {
  String issuerOfPatientId;
  IssuerOfPatientIdQualifiersSequence qualifiers;
}

class IssuerOfPatientIdQualifiersSequence {
  String universalEntityId;
  UniversalEntityIDType type;
  //  IdentifierTypeCode code;
  AssigningFacilitySequence facility;
}

class AssigningFacilitySequence {
  String localNamespaceEntityID;
  String universalEntityID;
  UniversalEntityIDType type;
  CodeSequence codeSequence;

  AssigningFacilitySequence(
      this.localNamespaceEntityID, this.universalEntityID, this.type) {
    if (localNamespaceEntityID == null &&
        universalEntityID != null &&
        type != null)
      throw 'AssigningFacilitySequence must have either '
          'localNamespaceEntityID or universalEntityID';
  }
}

class CodeSequence {
  CodingScheme designator;
  String value;
  String meaning;
  List<String> longValue;
  String urnValue;

  CodeSequence(
      this.designator, this.value, this.meaning, this.longValue, this.urnValue);
}

class CodingScheme {
  String designator;
  String version;
}

class UniversalEntityIDType {
  final String id;
  final String name;
  final Term term;

  const UniversalEntityIDType(this.id, this.name, this.term);

  static const UniversalEntityIDType kDNS =
      UniversalEntityIDType('DNS', 'Domain Name System', Term.kDNS);

  static const UniversalEntityIDType kEUI64 = UniversalEntityIDType(
      'EUI64', 'IEEE Extended Unique Idnetifier', Term.kEUI64);

  static const UniversalEntityIDType kISO = UniversalEntityIDType('ISO',
      'An International Standards Organization Object Identifier', Term.kISO);

  static const UniversalEntityIDType kURI =
      UniversalEntityIDType('URI', 'Universal Resource Identifier', Term.kURI);

  static const UniversalEntityIDType kUUID =
      UniversalEntityIDType('UUID', 'Universal Unique Identifier', Term.kUUID);

  static const UniversalEntityIDType kX400 =
      UniversalEntityIDType('X400', 'X400 MHS Identifier', Term.kX400);

  static const UniversalEntityIDType kX500 =
      UniversalEntityIDType('X500', 'X500 Directory Name', Term.kX500);

  UniversalEntityIDType lookup(String key) => map[key];

  static Map<String, UniversalEntityIDType> map = const {
    'DNS': kDNS,
    'EUI64': kEUI64,
    'ISO': kISO,
    'URI': kURI,
    'UUID': kUUID,
    'X400': kX400,
    'X500': kX500
  };
}
