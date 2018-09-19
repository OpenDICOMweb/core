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

// TODO: decide where these primitive io functions should go

String cleanPath(String path) => path.replaceAll('\\', '/');


/// Checks that [file] is not empty.
void checkFile(File file, {bool overWrite = false}) {
  if (file == null) throw new ArgumentError('null File');
  if (file.existsSync() && (file.lengthSync() == 0))
    throw new ArgumentError('$file has zero length');
}

/// Checks that [path] is not empty.
String checkPath(String path) {
  if (path == null || path == '') throw new ArgumentError('Empty path: $path');
  return path;
}

/// Checks that [dataset] is not empty.
void checkRootDataset(Dataset dataset) {
  if (dataset == null || dataset.isEmpty)
    throw new ArgumentError('Empty ' 'Empty Dataset: $dataset');
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
  final dir = new Directory(dirPath);
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
    final List<String> vList = e.values;
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

/*
//TODO move to utilities
 List<Filename> listFromDirectory(String source, [String ext = '.dcm']) {
log.debug('source: $source');
final files = getFilesFromDirectory(source, ext);
log.debug('Total FSEntities: ${files.length}');
final fNames = new List(files.length);
for (var i = 0; i < files.length; i++)
fNames[i] = new Filename(files[i].path);
return fNames;
}
*/

//TODO move to utilities
/// Returns a [List] of [File]s with extension [ext] from the specified [Directory].
List<File> getFilesFromDirectory(String source, [String ext = '.dcm']) {
  final dir = new Directory(source);
  final entities = dir.listSync(recursive: true, followLinks: false);
  final files = <File>[];
  for (var e in entities)
    if (e is File && path.extension(e.path) == ext) files.add(e);
  return files;
}


