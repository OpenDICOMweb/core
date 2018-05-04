//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/core.dart';

const _evrVROffset = 4;

const _shortEvrHeaderSize = 8;
const _shortEvrVFLengthOffset = 6;
const _shortEvrVFOffset = 8;

const _longEvrHeaderSize = 12;
const _longEvrVFLengthOffset = 8;
const _longEvrVFOffset = 12;

const _ivrHeaderSize = 8;
const _ivrVFLengthOffset = 4;
const _ivrVFOffset = 8;

Bytes makeShortEvrHeader(int code, int vrCode, Bytes bytes) {
  final group = code >> 16;
  final elt = code & 0xFFFF;
  // log.debug('mkShort: group: ${hex16(group)} elt: ${hex16(elt)}');
  // final v = group << 16)
  // log.debug('mkShortCode: ')
  final vfLength = bytes.length - _shortEvrHeaderSize;
  bytes
    ..setUint16(0, group)
    ..setUint16(2, elt)
    ..setUint16(_evrVROffset, vrCode)
    ..setUint16(_shortEvrVFLengthOffset, vfLength);
  return bytes;
}

Bytes makeLongEvrHeader(int code, int vrCode, Bytes bytes) {
  final group = code >> 16;
  final elt = code & 0xFFFF;
  final vfLength = bytes.length - _longEvrHeaderSize;
  log.debug('vfLength: $vfLength');
  // log.debug('mkShort: group: ${hex16(group)} elt: ${hex16(elt)}');
  // final v = group << 16)
  // log.debug('mkShortCode: ')
  bytes
    ..setUint16(0, group)
    ..setUint16(2, elt)
    ..setUint16(_evrVROffset, vrCode)
    ..setUint16(_shortEvrVFLengthOffset, 0)
    ..setUint32(_longEvrVFLengthOffset, vfLength);
  //longEvrInfo(bd);
  return bytes;
}

Bytes makeIvrHeader(int code, int vfLengthInBytes, Bytes bytes) {
  final group = code >> 16;
  final elt = code & 0xFFFF;
  // log.debug('mkShort: group: ${hex16(group)} elt: ${hex16(elt)}');
  // final v = group << 16)
  // log.debug('mkShortCode: ')
  bytes
    ..setUint16(0, group)
    ..setUint16(2, elt)
    ..setUint16(_ivrVFLengthOffset, vfLengthInBytes);
  return bytes;
}

Bytes makeShortEvr(int code, int vrCode, Bytes vfBytes,
    [Endian endian = Endian.little]) {
  // log.debug('makeEvr: ${hex32(code)}');
  // final vfLength = vfBytes.length;
  // var eLength = _shortEvrHeaderSize + vfLength;
  // if (eLength.isOdd) eLength++;
  final bytes = EvrShortBytes.makeFromBytes(code, vrCode, vfBytes, endian);

  makeShortEvrHeader(code, vrCode, bytes);
  copyBytesToVF(bytes, _shortEvrVFOffset, vfBytes);
  return bytes;
}

Bytes makeLongEvr(int code, int vrCode, Bytes vfBytes,
    [Endian endian = Endian.little]) {
  // log.debug('makeEvr: ${hex32(code)}');
  final vfLength = vfBytes.length;
  var eLength = _longEvrHeaderSize + vfLength;
  if (eLength.isOdd) eLength++;
  final bytes = new Bytes(eLength, endian);
  makeLongEvrHeader(code, vrCode, bytes);
  copyBytesToVF(bytes, _longEvrVFOffset, vfBytes);
  return bytes;
}

Bytes makeIvr(int code, Bytes vfBytes) {
  // log.debug('makeEvr: ${hex32(code)}');
  final vfLength = vfBytes.length;
  final eLength = _ivrHeaderSize + vfLength;
  final bd = new Bytes(eLength);
  makeIvrHeader(code, vfLength, bd);
  copyBytesToVF(bd, _ivrVFOffset, vfBytes);
  return bd;
}

void copyBytesToVF(Bytes bytes, int vfOffset, Bytes vfBytes) {
  for (var i = 0, j = vfOffset; i < vfBytes.length; i++, j++)
    bytes.setUint8(j, vfBytes.getUint8(i));
  if (vfBytes.length.isOdd) bytes.setUint8(vfOffset + vfBytes.length, 32);
}

/// Returns the Tag Code from [Bytes].
int getCode(DicomBytes bytes) {
  final group = bytes.getUint16(0);
  final elt = bytes.getUint16(2);
  return (group << 16) + elt;
}

String codeToString(int code) {
//  log.debug('code: ${hex32(code)}');
  final group = code >> 16;
  final elt = code & 0xFFFF;
  final sb = new StringBuffer()
    ..write('(${group.toRadixString(16).padLeft(4, '0')},')
    ..write('${elt.toRadixString(16).padLeft(4, '0')})');
  return sb.toString();
}

String vrToString(int vr) {
  final sb = new StringBuffer()
    ..write('0x${vr.toRadixString(16).padLeft(4, '0')}');
  return sb.toString();
}

String getVRId(DicomBytes bytes) => vrIdByIndex[bytes.getVRCode(4)];

int getShortVFLength(EvrBytes bytes) {
  final vfl = bytes.vfLengthField;
  log.debug('vfl: $vfl');
  return vfl;
}

int getLongVFLength(EvrBytes bd) {
  final vfl = bd.getUint32(_longEvrVFLengthOffset);
  log.debug('vfl: $vfl');
  return vfl;
}

String shortEvrInfo(EvrBytes bytes) {
  final code = dcm(getCode(bytes));
  final vr = getVRId(bytes);
  final vfLength = getShortVFLength(bytes);
  final msg = 'ShortEvr: $code $vr $vfLength';
  log.debug(msg);
  return msg;
}

String longEvrInfo(EvrBytes bytes) {
  final code = dcm(bytes.code);
  final vr = bytes.vrId;
  final vfLength = bytes.vfLength;
  final msg = 'LongEvrInfo($bytes): $code $vr $vfLength';
  log.debug(msg);
  return msg;
}

String shortEvrToString(EvrBytes bytes) {
  final sb = new StringBuffer()
    ..write('${dcm(bytes.code)}')
    ..write(' ${vrToString(bytes.vrCode)} ')
    ..write(bytes.vfLength);
  return sb.toString();
}

Bytes asciiListToBytes(List<String> vList) => Bytes.toAscii(vList.join('\\'));

Bytes uint8ListToBytes(Uint8List bList) => new Bytes.typedDataView(bList);

String vfToString(List vList, Bytes vfBytes) =>
    'vList: $vList vfBD: ${vfBytes.getUtf8List()}';

AEevr makeAE(int code, List<String> vList) {
  final vfBytes = Bytes.asciiFromList(vList);
  final vfLength = vfBytes.length;
  final evr = EvrShortBytes.makeEmpty(code, kFLCode, vfLength)
    ..setAsciiList(_shortEvrVFOffset, vList);
  return AEevr.makeFromBytes(evr);
}

Bytes makeFloat32Bytes(List<double> vList) {
  if (vList.isEmpty) return kEmptyBytes;
  final list = new Float32List.fromList(vList);
  return new Bytes.typedDataView(list.buffer.asByteData());
}

const int _f32ElementSize = 4;

FLevr makeFL(int code, List<double> vList) {
  final vfLength = vList.length * _f32ElementSize;
  print('|vList: (${vList.length})$vList');
  final evr = EvrShortBytes.makeEmpty(code, kFLCode, vfLength);
  _writeFloat32VF(evr, _shortEvrVFOffset, vList);
  print('|evr: $evr');
  print('|values.length: ${evr.vfLength ~/ 4}');
  print('|vfBytes: ${evr.vfBytes}');
  print('|asFloat32List: ${evr.vfBytes.asFloat32List()}');

  final e =  FLevr.makeFromBytes(evr);
  print('values: ${e.values}');
  return e;
}

OFevr makeOF(int code, List<double> vList) {
  final vfLength = vList.length * _f32ElementSize;
  final evr = EvrLongBytes.makeEmpty(code, kFLCode, vfLength);
  _writeFloat32VF(evr, _longEvrVFOffset, vList);
/*
  for (var i = 0, j = 8; i < vList.length; i++, j += 4)
    evr.setFloat32(j, vList[i]);
*/
  print(evr);
  return OFevr.makeFromBytes(evr);
}

void _writeFloat32VF(EvrBytes evr, int vfOffset, List<double> vList) {
  for (var i = 0, j = vfOffset; i < vList.length; i++, j += _f32ElementSize) {
    print('vList[$i]: ${vList[i]}');
    evr.setFloat32(j, vList[i]);
    print('values: ${evr.vfBytes.asFloat32List()}');
  }
}

const int _f64ElementSize = 8;

FDevr makeFD(int code, List<double> vList) {
  final vfLength = vList.length * _f64ElementSize;
  final evr = EvrShortBytes.makeEmpty(code, kFDCode, vfLength);
  print('vList.length: ${vList.length}');
  _writeFloat64VF(evr, _shortEvrVFOffset, vList);
/*  for (var i = 0, j = _shortEvrVFOffset; i < vList.length; i++, j += 8)
    evr.setFloat64(j, vList[i]);*/
  print(evr);
  print(evr.vfBytes);
  print(evr.vfBytes.asFloat64List());
  return FDevr.makeFromBytes(evr);
}

ODevr makeOD(int code, List<double> vList) {
  final vfLength = vList.length * _f64ElementSize;
  final evr = EvrLongBytes.makeEmpty(code, kODCode, vfLength);
  print('vList.length: ${vList.length}');
  _writeFloat64VF(evr, _longEvrVFOffset, vList);
  print(evr);
  print(evr.asFloat64List());
  return ODevr.makeFromBytes(evr);
}

void _writeFloat64VF(EvrBytes evr, int vfOffset, List<double> vList) {
  for (var i = 0, j = vfOffset; i < vList.length; i++, j += _f64ElementSize) {
    print('vList[$i]: ${vList[i]}');
    evr.setFloat64(j, vList[i]);
  }
  final vf = evr.vfBytes;
  final rList = vf.asFloat64List();
  print('values: ${evr.vfBytes.asFloat64List()}');
}
