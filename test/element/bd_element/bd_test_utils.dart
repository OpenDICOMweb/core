// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert' as cvt;
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

ByteData makeShortEvrHeader(int code, int vrCode, ByteData bd) {
  final group = code >> 16;
  final elt = code & 0xFFFF;
  // log.debug('mkShort: group: ${hex16(group)} elt: ${hex16(elt)}');
  // final v = group << 16)
  // log.debug('mkShortCode: ')
  final vfLength = bd.lengthInBytes - _shortEvrHeaderSize;
  bd
    ..setUint16(0, group, Endian.little)
    ..setUint16(2, elt, Endian.little)
    ..setUint16(_evrVROffset, vrCode, Endian.little)
    ..setUint16(_shortEvrVFLengthOffset, vfLength, Endian.little);
  return bd;
}

ByteData makeLongEvrHeader(int code, int vrCode, ByteData bd) {
  final group = code >> 16;
  final elt = code & 0xFFFF;
  final vfLength = bd.lengthInBytes - _longEvrHeaderSize;
  log.debug('vfLength: $vfLength');
  // log.debug('mkShort: group: ${hex16(group)} elt: ${hex16(elt)}');
  // final v = group << 16)
  // log.debug('mkShortCode: ')
  bd
    ..setUint16(0, group, Endian.little)
    ..setUint16(2, elt, Endian.little)
    ..setUint16(_evrVROffset, vrCode, Endian.little)
    ..setUint16(_shortEvrVFLengthOffset, 0, Endian.little)
    ..setUint32(_longEvrVFLengthOffset, vfLength, Endian.little);
  //longEvrInfo(bd);
  return bd;
}

ByteData makeIvrHeader(int code, int vfLengthInBytes, ByteData bd) {
  final group = code >> 16;
  final elt = code & 0xFFFF;
  // log.debug('mkShort: group: ${hex16(group)} elt: ${hex16(elt)}');
  // final v = group << 16)
  // log.debug('mkShortCode: ')
  bd
    ..setUint16(0, group, Endian.little)
    ..setUint16(2, elt, Endian.little)
    ..setUint16(_ivrVFLengthOffset, vfLengthInBytes, Endian.little);
  return bd;
}

ByteData makeShortEvr(int code, int vrCode, ByteData vfBD) {
  // log.debug('makeEvr: ${hex32(code)}');
  final vfLength = vfBD.lengthInBytes;
  var eLength = _shortEvrHeaderSize + vfLength;
  if(eLength.isOdd) eLength++;
  final bd = new ByteData(eLength);
  makeShortEvrHeader(code, vrCode, bd);
  copyBDToVF(bd, _shortEvrVFOffset, vfBD);
  return bd;
}

ByteData makeLongEvr(int code, int vrCode, ByteData vfBD) {
  // log.debug('makeEvr: ${hex32(code)}');
  final vfLength = vfBD.lengthInBytes;
  var eLength = _longEvrHeaderSize + vfLength;
  if(eLength.isOdd) eLength++;
  final bd = new ByteData(eLength);
  makeLongEvrHeader(code, vrCode, bd);
  copyBDToVF(bd, _longEvrVFOffset, vfBD);
  return bd;
}

ByteData makeIvr(int code, ByteData vfBD) {
  // log.debug('makeEvr: ${hex32(code)}');
  final vfLength = vfBD.lengthInBytes;
  final eLength = _ivrHeaderSize + vfLength;
  final bd = new ByteData(eLength);
  makeIvrHeader(code, vfLength, bd);
  copyBDToVF(bd, _ivrVFOffset, vfBD);
  return bd;
}

void copyBDToVF(ByteData bd, int vfOffset, ByteData vfBD) {
  for (var i = 0, j = vfOffset; i < vfBD.lengthInBytes; i++, j++)
    bd.setUint8(j, vfBD.getUint8(i));
  if(vfBD.lengthInBytes.isOdd) bd.setUint8(vfOffset + vfBD.lengthInBytes, 32);
}

/// Returns the Tag Code from [ByteData].
int getCode(ByteData bd) {
  final group = bd.getUint16(0, Endian.little);
  final elt = bd.getUint16(2, Endian.little);
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

int getVRCode(ByteData bd) => bd.getUint16(_evrVROffset, Endian.little);

int getVRIndex(ByteData bd) => vrIndexFromCodeMap[getVRCode(bd)];

String getVRId(ByteData bd) => vrIdByIndex[getVRIndex(bd)];

int getShortVFLength(ByteData bd) {
  final vfl = bd.getUint16(_shortEvrVFLengthOffset, Endian.little);
  log.debug('vfl: $vfl');
  return vfl;
}

int getLongVFLength(ByteData bd) {
  final vfl = bd.getUint32(_longEvrVFLengthOffset, Endian.little);
  log.debug('vfl: $vfl');
  return vfl;
}

String shortEvrInfo(ByteData bd) {
  final code = dcm(getCode(bd));
  final vr = getVRId(bd);
  final vfLength = getShortVFLength(bd);
  final msg = 'ShortEvr: $code $vr $vfLength';
  log.debug(msg);
  return msg;
}

String longEvrInfo(ByteData bd) {
  final code = dcm(getCode(bd));
  final vr = getVRId(bd);
  final vfLength = getLongVFLength(bd);
  final msg = 'LongEvr(${bd.lengthInBytes}): $code $vr $vfLength';
  log.debug(msg);
  return msg;
}

String shortEvrToString(ByteData bd) {
  final sb = new StringBuffer()
    ..write('${codeToString(getCode(bd))}')
    ..write(' ${vrToString(getVRCode(bd))} ')
    ..write(getShortVFLength(bd));
  return sb.toString();
}

ByteData makeAsciiBD(List<String> vList) {
  final s = vList.join('\\');
  final Uint8List b = cvt.ascii.encode(s);
  return b.buffer.asByteData(b.offsetInBytes, b.lengthInBytes);
}

ByteData uint8ListToByteData(Uint8List bytes) =>
    bytes.buffer.asByteData(bytes.offsetInBytes, bytes.lengthInBytes);

String vfToString(List vList, ByteData vfBD) {
  final bytes = vfBD.buffer.asUint8List();
  return 'vList: $vList vfBD: $bytes';
}

ByteData makeAE(int code, List<String> vList) =>
    makeShortEvr(code, kAECode, makeAsciiBD(vList));

ByteData makeFL(int code, List<double> vList) =>
    makeShortEvr(code, kFLCode, Float32.toByteData(vList));

ByteData makeFD(int code, List<double> vList) =>
    makeShortEvr(code, kFDCode, Float64.toByteData(vList));

ByteData makeOF(int code, List<double> vList) =>
    makeLongEvr(code, kOFCode, Float32.toByteData(vList));

ByteData makeOD(int code, List<double> vList) =>
    makeLongEvr(code, kODCode, Float64.toByteData(vList));
