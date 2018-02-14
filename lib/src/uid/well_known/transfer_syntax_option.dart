// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See /[package]/AUTHORS file for other contributors.

//TODO: decide if this is useful - flush or complete.
// TODO: move this info to /dictionary/uid/transfer_syntax
class TransferSyntaxOption {
  final bool owAllowed;
  final bool hasEmptyOffsetTable;
  final bool hasOneFragment;

  const TransferSyntaxOption(
      {this.owAllowed, this.hasEmptyOffsetTable, this.hasOneFragment});

  static const TransferSyntaxOption native = const TransferSyntaxOption(
      owAllowed: true, hasEmptyOffsetTable: false, hasOneFragment: false);

  static const TransferSyntaxOption mpeg2 = const TransferSyntaxOption(
      owAllowed: false, hasEmptyOffsetTable: true, hasOneFragment: true);
}
