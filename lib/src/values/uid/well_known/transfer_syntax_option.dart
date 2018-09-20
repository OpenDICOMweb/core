//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

//TODO: decide if this is useful - flush or complete.
// TODO: move this info to /dictionary/uid/transfer_syntax
class TransferSyntaxOption {
  final bool owAllowed;
  final bool hasEmptyOffsetTable;
  final bool hasOneFragment;

  const TransferSyntaxOption(
      {this.owAllowed, this.hasEmptyOffsetTable, this.hasOneFragment});

  static const TransferSyntaxOption native = TransferSyntaxOption(
      owAllowed: true, hasEmptyOffsetTable: false, hasOneFragment: false);

  static const TransferSyntaxOption mpeg2 = TransferSyntaxOption(
      owAllowed: false, hasEmptyOffsetTable: true, hasOneFragment: true);
}
