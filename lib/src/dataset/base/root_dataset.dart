// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/dataset/element_list/element_list.dart';
import 'package:core/src/dataset/parse_info.dart';
import 'package:core/src/dataset/status_report.dart';
import 'package:core/src/date_time/age.dart';
import 'package:core/src/date_time/date.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/empty_list.dart';
import 'package:core/src/entity/patient/patient.dart';
import 'package:core/src/entity/patient/person_name.dart';
import 'package:core/src/entity/patient/sex.dart';
import 'package:core/src/logger/formatter.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/tag/constants.dart';
import 'package:core/src/uid/uid.dart';
import 'package:core/src/uid/well_known/sop_class.dart';
import 'package:core/src/uid/well_known/transfer_syntax.dart';

/// The Root [Dataset] for a DICOM Entity.
abstract class RootDataset extends Dataset {
  // **** interface

  /// Returns a copy of this [RootDataset].
  RootDataset copy([Null _]);

  // **** End of interface

  @override
  Dataset get parent => null;

  ByteData get preamble => (dsBytes != null) ? dsBytes.preamble : kEmptyByteData;
  ByteData get prefix => (dsBytes != null) ? dsBytes.prefix : kEmptyByteData;

  @override
  RDSBytes get dsBytes;
  set dsBytes(RDSBytes bd);

  /// Returns the encoded [ByteData] for the File Meta Information (FMI) for
  /// _this_. [fmiBytes] has _one-time_ setter that is initialized lazily.
  Uint8List get fmiBytes => dsBytes.fmiBytes;

  /// An [ElementList] of the File Meta Information [Element]s in _this_.
  ///
  // Design Note: It is expected that [ElementList] will have
  // it's own specialized implementation for correctness and efficiency.
  ElementList get fmi;

  String get path;
  /// Returns the parsing information [ParseInfo] for _this_.
  /// [pInfo] has one-time setter that is initialized lazily.
  // ignore: unnecessary_getters_setters
  ParseInfo get pInfo => _pInfo;
  ParseInfo _pInfo;
  // ignore: unnecessary_getters_setters
  set pInfo(ParseInfo info) => _pInfo ??= info;

  @override
  int get vfLengthField => (dsBytes != null) ? dsBytes.vfLengthField : 0;

  bool get hadULength => false;

  Patient get patient => new Patient.fromRDS(this);

  /// The SopClass Uid for _this_ as a [String].
  String get sopClassId => getString(kSOPClassUID);

  /// The SopClass of _this_.
  SopClass get sopClassUid => getUid(kSOPClassUID);

  /// The [TransferSyntax].
  SopClass get sopClass => SopClass.lookup(sopClassId);

  //TODO: add to RootDataset constructor
  bool get isDicomDir => hasElementsInRange(0x00041130, 0x00031600);

  /// The [TransferSyntax].
  TransferSyntax get transferSyntax {
    final TransferSyntax ts = fmi.getUid(kTransferSyntaxUID, required: true);
    if (ts == null) {
//      log.info0('Using system.defaultTransferSyntax: ${system.defaultTransferSyntax}');
      return system.defaultTransferSyntax;
    }
    return ts;
  }

  bool get hasSupportedTransferSyntax =>
      system.isSupportedTransferSyntax(transferSyntax.asString);

  /// Returns _true_ if the [transferSyntax] is Explicit VR Transfer Syntax.
  bool get isEvr => transferSyntax.isEvr;

  /// Returns _true_ if the [transferSyntax] is Implicit VR Transfer Syntax.
  bool get isIVR => transferSyntax.isIvr;

  // TODO: tighten the upper bound
  bool get hasCmdElements => hasElementsInRange(0x00000000, 0x0000FFFF);

  // TODO: tighten the upper bound
  bool get hasFmi => fmi != null;

  bool get wasShortEncoding => pInfo.wasShortFile;

  bool get hasIssues => pInfo.hadErrors || pInfo.hadWarnings;

  bool get hasErrors => pInfo.hadParsingErrors || hasIssues;

  /// If this value is _true_ after decoding  a [Dataset], then the
  /// [Dataset] contains invalid elements and should not be used further
  /// until they are corrected.
  bool get shouldAbort => _mustAbort;

  /// If _true_ after dataset is created, then abort with error report.
  bool _mustAbort = false;

  /// Called if the [Dataset] has errors with a severity
  /// that requires aborting the decoding of the study.
  bool abort() => _mustAbort = true;

  String get conditionReport {
    final out = 'Condition Report for $this}\n';
    //TODO: fix
    // for (Condition c in conditions) out += '    ${c.info}\n';
    return out;
  }

  /// The DICOM Preamble (128 bytes) and Prefix('DICM')
  // Uint8List get prefix => ASCII.encode('DICM');

  /// Returns a formatted summary of _this_.
  String get summary => '''\n$runtimeType 
             SOP Class: $sopClassUid
       Transfer Syntax: $transferSyntax
${elements.subSummary}       
''';

  @override
  Iterable<dynamic> findAllWhere(bool test(Element e)) {
    final result = <dynamic>[];
    for (var e in fmi) if (test(e)) result.add(e);
    for (var e in elements) if (test(e)) result.add(e);
    return result;
  }

  /// Sets [dsBytes] to the empty list, and returns the existing value of [dsBytes].
  RDSBytes clearDSBytes() {
    final dsb = dsBytes;
    dsBytes = RDSBytes.kEmpty;
    return dsb;
  }

  /// Returns a formatted [String]. See [Formatter].
  @override
  String format(Formatter z) {
    final sb = new StringBuffer(summary);
    z.down;
    sb
      ..write(z.fmt('FMI:', fmi))
      ..write(z.fmt('Elements:', elements));
    z.up;
    return sb.toString();
  }

  // *******Accessors for [Tag]s that are only found in [RootDataset]s.

  List<Element> getFMI() => getElementsInRange(0x00020000, 0x00030000);

  List<Element> getDicomDir() => getElementsInRange(0x00040000, 0x00050000);

  // **** Patient related accessors

  String get patientId => getString(kPatientID);

  String get patientNameString => getString(kPatientName);

  PersonName get patientName => PersonName.parse(patientNameString);

  String get patientBirthDateString => getString(kPatientBirthDate);

  Date get patientBirthDate => Date.parse(patientBirthDateString);

  String get patientSexString => getString(kPatientSex);

  Sex get patientSex => Sex.parse(patientSexString);

  String get patientAgeString => getString(kPatientSex);

  Age get patientAge => Age.parse(patientAgeString);

  // **** Uids

  String get studyUidString => getString(kStudyInstanceUID);

  Uid get studyUid => Uid.parse(studyUidString);

  String get seriesUidString => getString(kSeriesInstanceUID);

  Uid get seriesUid => Uid.parse(seriesUidString);

  String get instanceId => getString(kSOPInstanceUID);

  Uid get instanceUid => Uid.parse(instanceId);

  bool get getIsDeIdentified {
    StatusReport report;
    final e = lookup(kPatientIdentityRemoved);
    //TODO: should this throw?
    if (e == null || e.values.isEmpty) return false;
    final String v = e.value;
    if (v == 'YES' || v.toUpperCase() == 'YES') {
      report ??= new StatusReport('PatientIdentityRemoved')
        ..error(e, '"$v" should be "YES"');
      return true;
    } else if (v == 'NO' || v.toUpperCase() == 'NO') {
      report ??= new StatusReport('PatientIdentityRemoved')
        ..error(e, '"$v" should be "YES"');
      return false;
    } else {
      report ??= new StatusReport('PatientIdentityRemoved')
        ..error(e, 'Invalid value in PatientIdentityRemoved Element: $v');
      return false;
    }
  }
}
