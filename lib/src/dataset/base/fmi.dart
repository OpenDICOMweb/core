// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/tag/constants.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/uid/uid.dart';
import 'package:core/src/uid/well_known_uids.dart';

/// File Meta Information
class Fmi {
  final Dataset ds;
  int _lengthInBytes;
  int _version;
  Uid _mediaStorageSopClass;
  Uid _mediaStorageSopInstanceUid;
  Uid _transferSyntax;
  Uid _implementationClassUid;
  String _implementationVersionName;
  String _sourceApplicationEntityTitle;
  String _sendingApplicationEntityTitle;
  String _receivingApplicationEntityTitle;
  Uid _privateInformationCreatorUID;
  Uint8List _privateInformation;

  /// Create an [Fmi] eagerly.
  Fmi(this.ds)
      : _lengthInBytes = getGroupLength(ds),
        _version = getVersion(ds),
        _mediaStorageSopClass = getMediaStorageSopClass(ds),
        _mediaStorageSopInstanceUid = getMediaStorageSopInstance(ds),
        _transferSyntax = getTransferSyntax(ds),
        _implementationClassUid = getImplementationClass(ds),
        _implementationVersionName = getImplementationVersionName(ds),
        _sourceApplicationEntityTitle = getSourceAppAETitle(ds),
        _sendingApplicationEntityTitle = getSendingAppAETitle(ds),
        _receivingApplicationEntityTitle = getReceivingAppAETitle(ds),
        _privateInformationCreatorUID = getPrivateInfoCreatorUid(ds),
        _privateInformation = getPrivateInfo(ds) {
    checkVersion(ds);
  }

  /// Create an [Fmi] lazily.
  Fmi.lazy(this.ds);

  int get lengthInBytes => _lengthInBytes ??= getGroupLength(ds);

  int get version => _version ??= getVersion(ds);

  Uid get mediaStorageSopClass => _mediaStorageSopClass ??= getMediaStorageSopClass(ds);

  Uid get mediaStorageSopInstanceUid =>
      _mediaStorageSopInstanceUid ??= getMediaStorageSopInstance(ds);

  Uid get transferSyntax => _transferSyntax ??= getTransferSyntax(ds);

  Uid get implementationClassUid =>
      _implementationClassUid ??= getImplementationClass(ds);

  String get implementationVersionName =>
      _implementationVersionName ??= getImplementationVersionName(ds);

  String get sourceApplicationEntityTitle =>
      _sourceApplicationEntityTitle ??= getSourceAppAETitle(ds);

  String get sendingApplicationEntityTitle =>
      _sendingApplicationEntityTitle ??= getSendingAppAETitle(ds);

  String get receivingApplicationEntityTitle =>
      _receivingApplicationEntityTitle ??= getReceivingAppAETitle(ds);

  Uid get privateInformationCreatorUID =>
      _privateInformationCreatorUID ??= getPrivateInfoCreatorUid(ds);

  Uint8List get privateInformation => _privateInformation ??= getPrivateInfo(ds);

  WKUid get transferSyntaxUid => WKUid.lookup(_mediaStorageSopClass);

  WKUid get sopClassUid => WKUid.lookup(_mediaStorageSopClass);

  @override
  String toString() =>
      '$runtimeType(${WKUid.lookup(sopClassUid).name}) ${transferSyntaxUid.name} ';

  static int getGroupLength(Dataset ds) =>
      ds.getInt(kFileMetaInformationGroupLength);

  static int getVersion(Dataset ds) {
    final v = ds.getIntList(kFileMetaInformationVersion);
    //TODO: what should this return? We could create a version object.
    if (v == null) return -1;
    final version = v.toList(growable: false);
    if (version.length != 2 || version[1] != 1) log.warn0('Invalid FMI Version');
    return version[1];
  }

  static bool checkVersion(Dataset ds) => getVersion == 1;

  static Uid getMediaStorageSopClass(Dataset ds) =>
      ds.getUid(kMediaStorageSOPClassUID);

  static Uid getMediaStorageSopInstance(Dataset ds) =>
      ds.getUid(kMediaStorageSOPInstanceUID);

  static Uid getTransferSyntax(Dataset ds) {
    final ts = ds.getString(kTransferSyntaxUID);
    if (ts == null) {
 //     log.info0('Using system.defaultTransferSyntax: ${system.defaultTransferSyntax}');
      return system.defaultTransferSyntax;
    }
    return TransferSyntax.lookup(ts);
  }

  static Uid getImplementationClass(Dataset ds) =>
      ds.getUid(kImplementationClassUID);

  static String getImplementationVersionName(Dataset ds) =>
      ds.getString(kImplementationVersionName);

  static String getSourceAppAETitle(Dataset ds) =>
      ds.getString(kSourceApplicationEntityTitle);

  static String getSendingAppAETitle(Dataset ds) =>
      ds.getString(kSendingApplicationEntityTitle);

  static String getReceivingAppAETitle(Dataset ds) =>
      ds.getString(kReceivingApplicationEntityTitle);

  static Uid getPrivateInfoCreatorUid(Dataset ds) =>
      ds.getUid(kPrivateInformationCreatorUID);

  static Uint8List getPrivateInfo(Dataset ds) =>
      ds.getIntList(kPrivateInformation);
}
