// Copyright (c) 2016, 2017 Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for

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
