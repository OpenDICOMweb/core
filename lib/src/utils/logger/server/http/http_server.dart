//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

//TODO: convert to http server

/// An HTTP Server that handles:
/// Requests to store log entries from clients, and
/// Requests to search for specific log entries.
class HttpLoggingServer {
  final int port;
  final String filename;

  //File _file;

  HttpLoggingServer(this.port, this.filename);
}
