//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:collection';
import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/dataset/utils/status_report.dart';
import 'package:core/src/element.dart';
import 'package:core/src/entity.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/value.dart';

/// The Root [Dataset] for a DICOM Entity.
abstract class RootDataset extends Dataset {
  String path;
  @override
  RDSBytes dsBytes;

  RootDataset(this.path, Bytes bytes, int fmiEnd)
      : dsBytes = (bytes == null || bytes.isEmpty)
            ? new RDSBytes.empty()
            : new RDSBytes(bytes, fmiEnd);

  RootDataset.empty() : dsBytes = new RDSBytes.empty();

  Bytes get bd => dsBytes.bytes;

  /// The [RootDataset] has no [parent]
  @override
  Dataset get parent => null;

  /// An [Dataset] of the File Meta Information [Element]s in _this_.
  ///
  // Design Note: It is expected that [Dataset] will have
  // it's own specialized implementation for correctness and efficiency.
  Fmi get fmi;

  /// Returns the encoded [Bytes] for the File Meta Information (FMI) for
  /// _this_. [fmiBytes] has _one-time_ setter that is initialized lazily.
  Uint8List get fmiBytes => dsBytes.fmiBytes;

  bool get hasFmi => fmi.isNotEmpty;

  /// Only supported by some [RootDataset]s. A [lengthInBytes] of -1
  /// indicates an unknown length.
  int get lengthInBytes => (dsBytes != null) ? dsBytes.vfLength : -1;

  Bytes get preamble => (dsBytes != null) ? dsBytes.preamble : kEmptyBytes;

  Bytes get prefix => (dsBytes != null) ? dsBytes.prefix : kEmptyBytes;

  bool get hadULength => false;

  Patient get patient => new Patient.fromRDS(this);

  /// The SopClass Uid for _this_ as a [String].
  String get sopClassId => getString(kSOPClassUID);

  // TODO Jim: determine whether MetaSopClass is a subtype of SopClass
  /// The SopClass of _this_.
  Uid get sopClassUid {
    final uids = getUidList(kSOPClassUID);
    return (uids == null || uids.length != 1) ? null : uids[0];
  }

  /// The [TransferSyntax].
  SopClass get sopClass => SopClass.lookup(sopClassId);

  bool get isDicomDir => hasElementsInRange(0x00041130, 0x00031600);

  /// The [TransferSyntax].
  TransferSyntax get transferSyntax =>
      fmi.uidLookup(kTransferSyntaxUID) ?? global.defaultTransferSyntax;

  bool get hasSupportedTransferSyntax =>
      global.isSupportedTransferSyntax(transferSyntax.asString);

  /// Returns _true_ if the [transferSyntax] is Explicit VR Transfer Syntax.
  bool get isEvr => transferSyntax.isEvr;

  /// Returns _true_ if the [transferSyntax] is Implicit VR Transfer Syntax.
  bool get isIVR => transferSyntax.isIvr;

  // TODO: tighten the bounds
  bool get hasCmdElements => hasElementsInRange(0x00000000, 0x0000FFFF);

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

  /// Sets [dsBytes] to the empty list.
  RDSBytes clearDSBytes() {
    final dsb = dsBytes;
    dsBytes = RDSBytes.kEmpty;
    return dsb;
  }

  /// An [List] of the duplicate [Element]s in _this_.
  List<Element> get duplicates => history.duplicates;
  List<Element> get added => history.added;
  List<Element> get removed => history.removed;
  List<Element> get updated => history.updated;
  List<int> get requiredNotPresent => history.requiredNotPresent;
  List<int> get notPresent => history.requiredNotPresent;

  int get nSequences => counter((e) => (e is SQ));
  int get nPrivate => counter((e) => Tag.isPrivateCode(e.code));
  int get nPrivateSequences =>
      counter((e) => Tag.isPrivateCode(e.code) && e is SQ);

  /// Returns a formatted summary of _this_.
  String get summary {
    final sqs = sequences;
    final sb = new StringBuffer('''\n$runtimeType: 
             SOP Class: $sopClassUid
       Transfer Syntax: $transferSyntax
        Total Elements: $total
    Top Level Elements: $length
      Total Duplicates: Fix: \$dupTotal
             Sequences: ${sqs.length}
         Private Total: $nPrivate
               History: $history''');
    if (nPrivateSequences != 0)
      sb.writeln('     Private Sequences: $nPrivateSequences');
// Fix    if (dupTotal != 0) sb.writeln('      Total Duplicates: $dupTotal');
    if (duplicates.isNotEmpty)
      sb.writeln('  Top Level Duplicates: ${duplicates.length}');
    return sb.toString();
  }

  @override
  Iterable<dynamic> findAllWhere(bool test(Element e)) {
    final result = <dynamic>[];
    for (var e in fmi.elements) if (test(e)) result.add(e);
    for (var e in elements) if (test(e)) result.add(e);
    return result;
  }

  /// Returns a formatted [String]. See [Formatter].
  @override
  String format(Formatter z) {
    final sb = new StringBuffer(summary);
    z.down;
    sb..write(z.fmt('FMI:', fmi.elements))..write(z.fmt('Elements:', elements));
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

abstract class Fmi extends ListBase<Element> {
  Iterable<Element> get elements;

  @override
  int get length => elements.length;

  Uid uidLookup(int code) {
    final e = this[code];
    if (e == null) return null;
    if (e is UI) {
      return e.uids[0];
    } else if (e is UN) {
      return new Uid(e.vfBytesAsAscii);
    } else {
      return elementError('Wrong Type ${e.runtimeType}: $e', e);
    }
  }
}
