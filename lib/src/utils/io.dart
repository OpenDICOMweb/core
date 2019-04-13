// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/error.dart';
import 'package:core/src/utils/dicom.dart';
import 'package:core/src/values.dart';

// ignore_for_file: public_member_api_docs

// TODO: decide where these primitive io functions should go

String cleanPath(String path) => path.replaceAll('\\', '/');

/// Checks that [file] is not empty.
void checkFile(File file, {bool overWrite = false}) {
  if (file == null) throw ArgumentError('null File');
  if (file.existsSync() && (file.lengthSync() == 0))
    throw ArgumentError('$file has zero length');
}

/// Checks that [path] is not empty.
String checkPath(String path) {
  if (path == null || path == '') throw ArgumentError('Empty path: $path');
  return path;
}

/// Checks that [dataset] is not empty.
void checkRootDataset(Dataset dataset) {
  if (dataset == null || dataset.isEmpty)
    throw ArgumentError('Empty ' 'Empty Dataset: $dataset');
}

String getOutputPath(String inPath, {String dir, String base, String ext}) {
  dir ??= path.dirname(path.current);
  base ??= path.basenameWithoutExtension(inPath);
  ext ??= path.extension(inPath);
  return cleanPath(path.absolute(dir, '$base.$ext'));
}

String getOutPath(String base, String ext, {String dir}) {
  dir ??= path.dirname(path.current);
  return cleanPath(path.absolute(dir, '$base.$ext'));
}

String getVNAPath(RootDataset rds, String rootDir, String ext) {
  final study = _getUid(rds, kStudyInstanceUID, '/');
  final series = _getUid(rds, kSeriesInstanceUID, '/');
  final instance = _getUid(rds, kSOPInstanceUID, '');
  final dirPath = '$rootDir$study$series';
  final dir = Directory(dirPath);
  if (!dir.existsSync()) dir.createSync(recursive: true);
  return (instance == '')
      ? '${dirPath.substring(0, dirPath.length - 1)}.$ext'
      : '$dirPath$instance.$ext';
}

/// Returns a [Uid] value for the [UI] [Element] with [index].
/// If the [Element] is not present or if the [Element] has more
/// than one value, either throws or returns _null_.
String _getUid(RootDataset rds, int index, String suffix) {
  // Note: this might be UI or UN
  final e = rds.lookup(index);
  if (e == null) return '';
  if (e is UI) {
    final vList = e.values;
    final length = vList.length;
    return (length == 1) ? '${vList[0]}$suffix' : '';
  }
  if (e is UN) {
    var s = e.vfBytesAsAscii;
    if (s.codeUnitAt(s.length - 1) == 0) s = s.substring(0, s.length - 1);
    return '$s$suffix';
  }
  return badUidElement(e);
}

//TODO move to utilities
/// Returns a [List] of [File]s with extension [ext] from the
/// specified [Directory].
List<File> getFilesFromDirectory(String source, [String ext = '.dcm']) {
  final dir = Directory(source);
  final entities = dir.listSync(recursive: true, followLinks: false);
  final files = <File>[];
  for (final e in entities)
    if (e is File && path.extension(e.path) == ext) files.add(e);
  return files;
}
