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
  final vfLength = bytes.lengthInBytes - _shortEvrHeaderSize;
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
  final vfLength = bytes.lengthInBytes - _longEvrHeaderSize;
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

Bytes makeShortEvr(int code, int vrCode, Bytes vfBytes) {
  // log.debug('makeEvr: ${hex32(code)}');
  final vfLength = vfBytes.lengthInBytes;
  var eLength = _shortEvrHeaderSize + vfLength;
  if (eLength.isOdd) eLength++;
  final bytes = new Bytes(eLength);
  makeShortEvrHeader(code, vrCode, bytes);
  copyBytesToVF(bytes, _shortEvrVFOffset, vfBytes);
  return bytes;
}

Bytes makeLongEvr(int code, int vrCode, Bytes vfBytes) {
  // log.debug('makeEvr: ${hex32(code)}');
  final vfLength = vfBytes.lengthInBytes;
  var eLength = _longEvrHeaderSize + vfLength;
  if (eLength.isOdd) eLength++;
  final bytes = new Bytes(eLength);
  makeLongEvrHeader(code, vrCode, bytes);
  copyBytesToVF(bytes, _longEvrVFOffset, vfBytes);
  return bytes;
}

Bytes makeIvr(int code, Bytes vfBytes) {
  // log.debug('makeEvr: ${hex32(code)}');
  final vfLength = vfBytes.lengthInBytes;
  final eLength = _ivrHeaderSize + vfLength;
  final bd = new Bytes(eLength);
  makeIvrHeader(code, vfLength, bd);
  copyBytesToVF(bd, _ivrVFOffset, vfBytes);
  return bd;
}

void copyBytesToVF(Bytes bytes, int vfOffset, Bytes vfBytes) {
  for (var i = 0, j = vfOffset; i < vfBytes.lengthInBytes; i++, j++)
    bytes.setUint8(j, vfBytes.getUint8(i));
  if (vfBytes.lengthInBytes.isOdd)
    bytes.setUint8(vfOffset + vfBytes.lengthInBytes, 32);
}

/// Returns the Tag Code from [Bytes].
int getCode(Bytes bytes) {
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

int getVRCode(Bytes bytes) => bytes.getUint16(_evrVROffset);

int getVRIndex(Bytes bytes) => vrIndexFromCodeMap[getVRCode(bytes)];

String getVRId(Bytes bytes) => vrIdByIndex[getVRIndex(bytes)];

int getShortVFLength(Bytes bytes) {
  final vfl = bytes.getUint16(_shortEvrVFLengthOffset);
  log.debug('vfl: $vfl');
  return vfl;
}

int getLongVFLength(Bytes bd) {
  final vfl = bd.getUint32(_longEvrVFLengthOffset);
  log.debug('vfl: $vfl');
  return vfl;
}

String shortEvrInfo(Bytes bytes) {
  final code = dcm(getCode(bytes));
  final vr = getVRId(bytes);
  final vfLength = getShortVFLength(bytes);
  final msg = 'ShortEvr: $code $vr $vfLength';
  log.debug(msg);
  return msg;
}

String longEvrInfo(Bytes bytes) {
  final code = dcm(getCode(bytes));
  final vr = getVRId(bytes);
  final vfLength = getLongVFLength(bytes);
  final msg = 'LongEvr(${bytes.lengthInBytes}): $code $vr $vfLength';
  log.debug(msg);
  return msg;
}

String shortEvrToString(Bytes bytes) {
  final sb = new StringBuffer()
    ..write('${codeToString(getCode(bytes))}')
    ..write(' ${vrToString(getVRCode(bytes))} ')
    ..write(getShortVFLength(bytes));
  return sb.toString();
}

Bytes makeAsciiBD(List<String> vList) => Bytes.asciiEncode(vList.join('\\'));

Bytes uint8ListToBytes(Uint8List bList) => new Bytes.fromTypedData(bList);

String vfToString(List vList, Bytes vfBytes) =>
    'vList: $vList vfBD: ${vfBytes.asUtf8List()}';

Bytes makeAE(int code, List<String> vList) =>
    makeShortEvr(code, kAECode, makeAsciiBD(vList));

Bytes makeFloat32Bytes(List<double> vList) {
  if (vList.isEmpty) return kEmptyBytes;
  final list = new Float32List.fromList(vList);
  return new Bytes.fromTypedData(list.buffer.asByteData());
}

Bytes makeFL(int code, List<double> vList) =>
    makeShortEvr(code, kFLCode, makeFloat32Bytes(vList));

Bytes makeOF(int code, List<double> vList) =>
    makeLongEvr(code, kOFCode, makeFloat32Bytes(vList));

Bytes makeFloat64Bytes(List<double> vList) {
  if (vList.isEmpty) return kEmptyBytes;
  final list = new Float64List.fromList(vList);
  return new Bytes.fromTypedData(list.buffer.asByteData());
}

Bytes makeFD(int code, List<double> vList) =>
    makeShortEvr(code, kFDCode, makeFloat64Bytes(vList));

Bytes makeOD(int code, List<double> vList) =>
    makeLongEvr(code, kODCode, makeFloat64Bytes(vList));
