//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

//TODO: this class might disappear when all the types are implemented as
// classes.

/// Uid Types
class UidType {
  final int index;
  final String name;

  const UidType._(this.index, this.name);

  String get keyword => 'k${name.replaceAll(' ', '')}';

  @override
  String toString() => name;

  /// The [kUnknown] type.
  static const UidType kUnknown = UidType._(-1, 'Unknown');

  // Random 2.25. + V4 Uuid
  static const UidType kUidRandom = UidType._(0, 'RandomUuid');

  // Constructed from Root + leaf
  static const UidType kConstructed = UidType._(1, 'Constructed');

  // Well Known DICOM UID Types
  static const UidType kSOPClass = UidType._(2, 'SOP Class');

  static const UidType kTransferSyntax = UidType._(3, 'Transfer Syntax');

  static const UidType kFrameOfReference = UidType._(4, 'Frame Of Reference');

  static const UidType kSOPInstance = UidType._(5, 'SOP Instance');

  static const UidType kCodingScheme = UidType._(6, 'Coding Scheme');

  static const UidType kMetaSOPClass = UidType._(7, 'Meta SOP Class');

  static const UidType kServiceClass = UidType._(8, 'Service Class');

  static const UidType kApplicationContextName =
      UidType._(9, 'Application Context Name');

  static const UidType kApplicationHostingModel =
      UidType._(10, 'Application Hosting Model');

  static const UidType kLdapOid = UidType._(15, 'LDAP OID');

  static const UidType kMappingResource = UidType._(11, 'Mapping Resource');

  static const UidType kSynchronizationFrameOfReference =
      UidType._(12, 'Synchronization Frame Of Reference');
}
