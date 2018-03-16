// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

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

Bytes makeShortEvrHeader(int code, int vrCode, Bytes bd) {
  final group = code >> 16;
  final elt = code & 0xFFFF;
  // log.debug('mkShort: group: ${hex16(group)} elt: ${hex16(elt)}');
  // final v = group << 16)
  // log.debug('mkShortCode: ')
  final vfLength = bd.lengthInBytes - _shortEvrHeaderSize;
  bd
    ..setUint16(0, group)
    ..setUint16(2, elt)
    ..setUint16(_evrVROffset, vrCode)
    ..setUint16(_shortEvrVFLengthOffset, vfLength);
  return bd;
}

Bytes makeLongEvrHeader(int code, int vrCode, Bytes bd) {
  final group = code >> 16;
  final elt = code & 0xFFFF;
  final vfLength = bd.lengthInBytes - _longEvrHeaderSize;
  log.debug('vfLength: $vfLength');
  // log.debug('mkShort: group: ${hex16(group)} elt: ${hex16(elt)}');
  // final v = group << 16)
  // log.debug('mkShortCode: ')
  bd
    ..setUint16(0, group)
    ..setUint16(2, elt)
    ..setUint16(_evrVROffset, vrCode)
    ..setUint16(_shortEvrVFLengthOffset, 0)
    ..setUint32(_longEvrVFLengthOffset, vfLength);
  //longEvrInfo(bd);
  return bd;
}

Bytes makeIvrHeader(int code, int vfLengthInBytes, Bytes bd) {
  final group = code >> 16;
  final elt = code & 0xFFFF;
  // log.debug('mkShort: group: ${hex16(group)} elt: ${hex16(elt)}');
  // final v = group << 16)
  // log.debug('mkShortCode: ')
  bd
    ..setUint16(0, group)
    ..setUint16(2, elt)
    ..setUint16(_ivrVFLengthOffset, vfLengthInBytes);
  return bd;
}

Bytes makeShortEvr(int code, int vrCode, Bytes vfBD) {
  // log.debug('makeEvr: ${hex32(code)}');
  final vfLength = vfBD.lengthInBytes;
  var eLength = _shortEvrHeaderSize + vfLength;
  if(eLength.isOdd) eLength++;
  final bd = new Bytes(eLength);
  makeShortEvrHeader(code, vrCode, bd);
  copyVFtoE(bd, _shortEvrVFOffset, vfBD);
  return new Bytes.fromTypedData(bd);
}

Bytes makeLongEvr(int code, int vrCode, Bytes vfBD) {
  // log.debug('makeEvr: ${hex32(code)}');
  final vfLength = vfBD.lengthInBytes;
  var eLength = _longEvrHeaderSize + vfLength;
  if(eLength.isOdd) eLength++;
  final bd = new Bytes(eLength);
  makeLongEvrHeader(code, vrCode, bd);
  copyVFtoE(bd, _longEvrVFOffset, vfBD);
  return new Bytes.fromTypedData(bd);
}

Bytes makeIvr(int code, Bytes vfBD) {
  // log.debug('makeEvr: ${hex32(code)}');
  final vfLength = vfBD.lengthInBytes;
  final eLength = _ivrHeaderSize + vfLength;
  final bd = new Bytes(eLength);
  makeIvrHeader(code, vfLength, bd);
  copyVFtoE(bd, _ivrVFOffset, vfBD);
  return bd;
}

void copyVFtoE(Bytes e, int vfOffset, Bytes vfBD) {
//  print('  e before: $e');
//  print('  CopyBDtoVF: $vfBD');
  for (var i = 0, j = vfOffset; i < vfBD.lengthInBytes; i++, j++)
    e.setUint8(j, vfBD.getUint8(i));
  if(vfBD.lengthInBytes.isOdd) e.setUint8(vfOffset + vfBD.lengthInBytes, 32);
//  print('  e after: $e');
}

/// Returns the Tag Code from [Bytes].
int getCode(Bytes bd) {
  final group = bd.getUint16(0);
  final elt = bd.getUint16(2);
//  log.debug('group: ${hex16(group)}, elt: ${hex(elt)}');
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
  final sb = new StringBuffer()..write('0x${vr.toRadixString(16).padLeft(4, '0')}');
  return sb.toString();
}

int getVRCode(Bytes bd) => bd.getUint16(_evrVROffset);

int getVRIndex(Bytes bd) => vrIndexFromCodeMap[getVRCode(bd)];

String getVRId(Bytes bd) => vrIdByIndex[getVRIndex(bd)];

int getShortVFLength(Bytes bd) {
  final vfl = bd.getUint16(_shortEvrVFLengthOffset);
  log.debug('vfl: $vfl');
  return vfl;
}

int getLongVFLength(Bytes bd) {
  final vfl = bd.getUint32(_longEvrVFLengthOffset);
  log.debug('vfl: $vfl');
  return vfl;
}

String shortEvrInfo(Bytes bd) {
  final code = dcm(bd.getCode(0));
  final vr = getVRId(bd);
  final vfLength = getShortVFLength(bd);
  final msg = 'ShortEvr: $code $vr $vfLength';
  log.debug(msg);
  return msg;
}

String longEvrInfo(Bytes bd) {
  final code = dcm(bd.getCode(0));
  final vr = getVRId(bd);
  final vfLength = getLongVFLength(bd);
  final msg = 'LongEvr(${bd.lengthInBytes}): $code $vr $vfLength';
  log.debug(msg);
  return msg;
}

String shortEvrToString(Bytes bd) {
  final sb = new StringBuffer()
    ..write('${codeToString(getCode(bd))}')
    ..write(' ${vrToString(getVRCode(bd))} ')
    ..write(getShortVFLength(bd));
  return sb.toString();
}

Bytes makeAsciiBD(List<String> vList) {
  final s = vList.join('\\');
  final  bList = asciiEncode(s);
  return new Bytes.fromTypedData(bList);
}

Bytes uint8ListToBytes(Uint8List bList) =>
    new Bytes.fromTypedData(bList);

String vfToString(List vList, Bytes vfBD) {
  final bytes = vfBD.buffer.asUint8List();
  return 'vList: $vList vfBD: $bytes';
}

Bytes makeAE(int code, List<String> vList) =>
    makeShortEvr(code, kAECode, makeAsciiBD(vList));

Bytes makeFL(int code, List<double> vList) =>
    makeShortEvr(code, kFLCode, Float32.toBytes(vList));

Bytes makeFD(int code, List<double> vList) =>
    makeShortEvr(code, kFDCode, Float64.toBytes(vList));

Bytes makeOF(int code, List<double> vList) {
// print('  MakeOF: $vList');
// print('  f32Bytes: ${Float32.toBytes(vList)}');

  final e =  makeLongEvr(code, kOFCode, Float32.toBytes(vList));
// print('  MakeOF e: $e');
  return e;
}

Bytes makeOD(int code, List<double> vList) =>
    makeLongEvr(code, kODCode, Float64.toBytes(vList));
