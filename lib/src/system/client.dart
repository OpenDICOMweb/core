//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:html';

import 'package:core/src/global.dart';
import 'package:core/src/values/uid.dart';
import 'package:version/version.dart';

// ignore_for_file: public_member_api_docs

//TODO: and initialize arguments for client and browers that
// are same as server.dart

/// A singleton class used to handle system-wide values and methods.
///
/// This is an example implementation of [Client].
/// Initialize the [Client] as follows:
///     Client.initialize();
/// Then access it as follows:
///     print(system.info);
class Client extends Global {
  @override
  final Uid defaultTransferSyntax = TransferSyntax.kDefaultForDicomWeb;

  Client() : super(version: Version(0, 6, 1));

  String get type => 'Non-Browser Client';
  @override
  String get script => document.title;

  @override
  void exit(int code, [String msg]) {
    //TODO: put the message in the appropriate place in the browser;
  }

  //TODO: add call to new System
  // Create the singleton [Server].
  static void initialize() {
    Global.global = Client();
  }
}

/// A singleton class used to handle system-wide values and methods.
///
/// This is an example implementation of [Client].
/// Initialize the [Client] as follows:
///     Client.initialize();
/// Then access it as follows:
///     print(system.info);
class Browser extends Global {
  @override
  final Uid defaultTransferSyntax = TransferSyntax.kDefaultForDicomWeb;

  //TODO:
  Browser() : super(version: Version(0, 6, 1));

  String get type => 'Browser Client';
  @override
  String get script => document.title;

  @override
  void exit(int code, [String msg]) {
    //TODO: put the message in the appropriate place in the browser;
  }

  //TODO: add call to new System
  // Create the singleton [Server].
  static void initialize() {
    Global.global = Client();
  }
}
