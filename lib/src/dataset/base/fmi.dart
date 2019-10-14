//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:constants/constants.dart';
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/global.dart';
import 'package:bytes/bytes.dart';

import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

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
  Bytes _privateInformation;

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

  Uid get mediaStorageSopClass =>
      _mediaStorageSopClass ??= getMediaStorageSopClass(ds);

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

  Bytes get privateInformation =>
      _privateInformation ??= getPrivateInfo(ds);

  WKUid get transferSyntaxUid => WKUid.lookup(_mediaStorageSopClass);

  WKUid get sopClassUid => WKUid.lookup(_mediaStorageSopClass);

  @override
  String toString() => '$runtimeType(${WKUid.lookup(sopClassUid).name}) '
      '${transferSyntaxUid.name} ';

  static int getGroupLength(Dataset ds) =>
      ds.getInt(kFileMetaInformationGroupLength);

  static int getVersion(Dataset ds) {
    final v = ds.getIntList(kFileMetaInformationVersion);
    //TODO(Jim): what should this return? We could create a version object.
    if (v == null) return -1;
    final version = v.toList(growable: false);
    if (version.length != 2 || version[1] != 1)
      log.warn0('Invalid FMI Version');
    return version[1];
  }

  static bool checkVersion(Dataset ds) => getVersion(ds) == 1;

  static Uid getMediaStorageSopClass(Dataset ds) =>
      ds.getUid(kMediaStorageSOPClassUID);

  static Uid getMediaStorageSopInstance(Dataset ds) =>
      ds.getUid(kMediaStorageSOPInstanceUID);

  static Uid getTransferSyntax(Dataset ds) {
    final ts = ds.getString(kTransferSyntaxUID);
    return (ts == null)
        ? global.defaultTransferSyntax
        : TransferSyntax.lookup(ts);
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

  static Bytes getPrivateInfo(Dataset ds) =>
      ds.getIntList(kPrivateInformation);
}
