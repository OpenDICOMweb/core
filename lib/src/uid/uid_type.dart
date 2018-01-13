// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: add classes to well_known for all these types.  Use transfer_systax
//   as example.
//TODO: this class might disappear when all the types are implemented as classes.
/// Uid Types
class UidType {
  final int index;
  final String name;

  const UidType._(this.index, this.name);

  String get keyword => 'k${name.replaceAll(' ', '')}';

  @override
  String toString() => name;

  /// The [kUnknown] type.
  static const UidType kUnknown = const UidType._(-1, 'Unknown');

  // Random 2.25. + V4 Uuid
  static const UidType kUidRandom = const UidType._(0, 'RandomUuid');

  // Constructed from Root + leaf
  static const UidType kConstructed = const UidType._(1, 'Constructed');

  // DICOM Well Known Types
  static const UidType kSOPClass = const UidType._(2, 'SOP Class');

  static const UidType kTransferSyntax = const UidType._(3, 'Transfer Syntax');

  static const UidType kWellKnownFrameOfReference =
      const UidType._(4, 'Frame Of Reference');

  static const UidType kWellKnownSOPInstance =
      const UidType._(5, 'SOP Instance');

  static const UidType kCodingScheme = const UidType._(6, 'Coding Scheme');

  static const UidType kMetaSOPClass = const UidType._(7, 'Meta SOP Class');

  static const UidType kServiceClass = const UidType._(8, 'Service Class');

  static const UidType kApplicationContextName =
      const UidType._(9, 'Application Context Name');

  static const UidType kApplicationHostingModel =
      const UidType._(10, 'Application Hosting Model');

  static const UidType kLdapOid = const UidType._(15, 'LDAP OID');

  static const UidType kMappingResource =
      const UidType._(11, 'Mapping Resource');

  static const UidType kSynchronizationFrameOfReference =
      const UidType._(12, 'Synchronization Frame Of Reference');
}
