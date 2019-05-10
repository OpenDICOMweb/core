// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

const int kMinLength = 16;

const int kInt8Size = 1;
const int kInt16Size = 2;
const int kInt32Size = 4;
const int kInt64Size = 8;

const int kUint8Size = 1;
const int kUint16Size = 2;
const int kUint32Size = 4;
const int kUint64Size = 8;

const int kFloat32Size = 4;
const int kFloat64Size = 8;

const int kInt8MinValue = -0x7F - 1;
const int kInt16MinValue = -0x7FFF - 1;
const int kInt32MinValue = -0x7FFFFFFF - 1;
const int kInt64MinValue = -0x7FFFFFFFFFFFFFFF - 1;

const int kUint8MinValue = 0;
const int kUint16MinValue = 0;
const int kUint32MinValue = 0;
const int kUint64MinValue = 0;

const int kInt8MaxValue = 0x7F;
const int kInt16MaxValue = 0x7FFF;
const int kInt32MaxValue = 0x7FFFFFFF;
const int kInt64MaxValue = 0x7FFFFFFFFFFFFFFF;

const int kUint8MaxValue = 0xFF;
const int kUint16MaxValue = 0xFFFF;
const int kUint32MaxValue = 0xFFFFFFFF;
const int kUint64MaxValue = 0xFFFFFFFFFFFFFFFF;

const int kDefaultLength = 4096;

const int kDefaultLimit = 1024 * 1024 * 1024; // 1 GB
