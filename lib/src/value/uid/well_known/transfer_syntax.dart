//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/value/uid/uid.dart';
import 'package:core/src/value/uid/well_known/uid_type.dart';
import 'package:core/src/value/uid/well_known/wk_uid.dart';

class TransferSyntax extends WKUid {
  static const UidType uidType = UidType.kTransferSyntax;
  final String mediaType;

  @override
  final bool isEncapsulated;

  final bool mayHaveFragments;

  final Endian endian;

  const TransferSyntax(String uid, String keyword, String name, this.mediaType,
      {bool isRetired = false,
      this.isEncapsulated = true,
      this.mayHaveFragments = true,
      this.endian = Endian.little})
      : super(uid, keyword, UidType.kTransferSyntax, name,
            isRetired: isRetired);

  @override
  UidType get type => UidType.kCodingScheme;

  /// Returns _true_ if the [TransferSyntax] exists and has not been retired.
  bool get isTransferSyntax => true;

  /// _true_ if _this_ is an Implicit VR Transfer Syntax.
  bool get isIvr => this == TransferSyntax.kImplicitVRLittleEndian;

  /// _true_ if _this_ is an Explicit VR Transfer Syntax.
  bool get isEvr => !isIvr;

  Endian get endianness =>
      (endian == Endian.little) ? Endian.little : Endian.big;

  bool get isNativeFormat => !isEncapsulated;

  bool get isImplicitLittleEndian => this == kImplicitVRLittleEndian;

  bool get isBigEndian => this == kExplicitVRBigEndian;

  bool get isValidForDICOMweb => !(isImplicitLittleEndian || isBigEndian);

  /// Returns _true_ if the [TransferSyntax] exists, but has been retired.
  bool get isRetiredTransferSyntax => isRetired;

  bool get isValidForRS =>
      (isNotRetired) ||
      (asString != kImplicitVRLittleEndian.asString &&
          asString != kExplicitVRBigEndian.asString);

  @override
  String toString() => 'TransferSyntax($asString): $name';

  /// Returns the TransferSyntax corresponding to the [String] or [Uid].
  static TransferSyntax lookup(Object ts) {
    if (ts is TransferSyntax) return ts;
    if (ts is Uid) return _map[ts.asString];
    if (ts is String) return _map[ts];
    return invalidUid(ts);
  }

  static List<TransferSyntax> get uids => _map.values;

  static List<String> get strings => _map.keys;

  //*****   Constant Values   *****

  static const String kName = 'Transfer Syntax';

  static const TransferSyntax kImplicitVRLittleEndian = const TransferSyntax(
    '1.2.840.10008.1.2',
    'ImplicitVRLittleEndian',
    'Implicit VR Little Endian: Default Transfer Syntax for DICOM',
    'image/???',
    isEncapsulated: false,
    mayHaveFragments: false,
  );

  static const TransferSyntax kDefaultForDIMSE = kImplicitVRLittleEndian;

  static const TransferSyntax kExplicitVRLittleEndian = const TransferSyntax(
    '1.2.840.10008.1.2.1',
    'ExplicitVRLittleEndian',
    'Explicit VR Little Endian',
    'image/uncompressed??',
    isEncapsulated: false,
    mayHaveFragments: false,
  );

  static const TransferSyntax kDefaultForDicomWeb = kExplicitVRLittleEndian;

  static const TransferSyntax kDeflatedExplicitVRLittleEndian =
      const TransferSyntax(
          '1.2.840.10008.1.2.1.99',
          'DeflatedExplicitVRLittleEndian',
          'Deflated Explicit VR Little Endian',
          'image/deflate??',
          isEncapsulated: false,
          mayHaveFragments: false);

  static const TransferSyntax kExplicitVRBigEndian = const TransferSyntax(
      '1.2.840.10008.1.2.2',
      'ExplicitVRBigEndian',
      'Explicit VR Big Endian (Retired)',
      'image/bigEndian',
      isRetired: true,
      isEncapsulated: false,
      mayHaveFragments: false,
      endian: Endian.big);

  static const TransferSyntax kJpegBaseline1 = const TransferSyntax(
      '1.2.840.10008.1.2.4.50',
      'JPEGBaseline_1',
      'JPEG Baseline (Process 1) : Default Transfer Syntax for Lossy '
      'JPEG 8 Bit Image Compression',
      'image/jpeg');

  static const TransferSyntax kJpegLossy8BitDefault = kJpegBaseline1;

  static const TransferSyntax kJpegExtended2_4 = const TransferSyntax(
      '1.2.840.10008.1.2.4.51',
      'JPEGExtended_2_4',
      'JPEG Extended (Process 2 & 4) : Default Transfer Syntax for '
      'Lossy JPEG 12 Bit Image Compression (Process 4 only)',
      'image/jpeg');

  static const TransferSyntax kJpegLossy12BitDefault = kJpegExtended2_4;

  static const TransferSyntax kJpegExtended3_5 = const TransferSyntax(
      '1.2.840.10008.1.2.4.52',
      'JPEGExtended_3_5_Retired',
      'JPEG Extended (Process 3 & 5) (Retired)',
      'image/jpeg',
      isRetired: true);

  static const TransferSyntax kJpegSpectralSelectionNonHierarchical6_8 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.53',
          'JPEGSpectralSelectionNonHierarchical_6_8_Retired',
          'JPEG Spectral Selection, Non-Hierarchical (Process 6 & 8) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegSpectralSelectionNonHierarchical7_9 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.54',
          'JPEGSpectralSelectionNonHierarchical_7_9_Retired',
          'JPEG Spectral Selection, Non-Hierarchical (Process 7 & 9) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegFullProgressionNonHierarchical10_12 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.55',
          'JPEGFullProgressionNonHierarchical_10_12_Retired',
          'JPEG Full Progression, Non-Hierarchical (Process 10 & 12) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegFullProgressionNonHierarchical11_13 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.56',
          'JPEGFullProgressionNonHierarchical_11_13_Retired',
          'JPEG Full Progression, Non-Hierarchical (Process 11 & 13) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegLosslessNonHierarchical14 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.57',
          'JPEGLosslessNonHierarchical_14',
          'JPEG Lossless, Non-Hierarchical (Process 14)',
          'image/jpeg???');

  static const TransferSyntax kJpegLosslessNonHierarchical15 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.58',
          'JPEGLosslessNonHierarchical_15_Retired',
          'JPEG Lossless, Non-Hierarchical (Process 15) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegExtendedHierarchical16_18 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.59',
          'JPEGExtendedHierarchical_16_18_Retired',
          'JPEG Extended, Hierarchical (Process 16 & 18) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegExtendedHierarchical17_19 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.60',
          'JPEGExtendedHierarchical_17_19_Retired',
          'JPEG Extended, Hierarchical (Process 17 & 19) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegSpectralSelectionHierarchical20_22 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.61',
          'JPEGSpectralSelectionHierarchical_20_22_Retired',
          'JPEG Spectral Selection, Hierarchical (Process 20 & 22) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegSpectralSelectionHierarchical21_23 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.62',
          'JPEGSpectralSelectionHierarchical_21_23_Retired',
          'JPEG Spectral Selection, Hierarchical (Process 21 & 23) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegFullProgressionHierarchical24_26 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.63',
          'JPEGFullProgressionHierarchical_24_26_Retired',
          'JPEG Full Progression, Hierarchical (Process 24 & 26) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegFullProgressionHierarchical25_27 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.64',
          'JPEGFullProgressionHierarchical_25_27_Retired',
          'JPEG Full Progression, Hierarchical (Process 25 & 27) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegLosslessHierarchical28 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.65',
          'JPEGLosslessHierarchical_28_Retired',
          'JPEG Lossless, Hierarchical (Process 28) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax kJpegLosslessHierarchical29 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.66',
          'JPEGLosslessHierarchical_29_Retired',
          'JPEG Lossless, Hierarchical (Process 29) (Retired)',
          'image/jpeg',
          isRetired: true);

  static const TransferSyntax
      kJpegLosslessNonHierarchicalFirstOrderPrediction14_1 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.70',
          'JPEGLosslessNonHierarchicalFirst_OrderPrediction_14_1',
          'JPEG Lossless, Non-Hierarchical, First-Order Prediction '
          '(Process 14 [Selection Value 1]) : Default Transfer Syntax '
          'for Lossless JPEG Image Compression',
          'image/jpeg');

  static const TransferSyntax kJpegLosslessDefault =
      kJpegLosslessNonHierarchicalFirstOrderPrediction14_1;

  static const TransferSyntax kJpegLSLosslessImageCompression =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.80',
          'JPEG_LSLosslessImageCompression',
          'JPEG-LS Lossless Image Compression',
          'image/jpeg-ls');
  static const TransferSyntax kJpegLSLossyImageCompression =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.81',
          'JPEG_LSLossyImageCompression',
          'JPEG-LS Lossy (Near-Lossless) Image Compression',
          'image/jpeg-ls');

  static const TransferSyntax kJpeg2000ImageCompressionLosslessOnly =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.90',
          'JPEG2000ImageCompressionLosslessOnly',
          'JPEG 2000 Image Compression Lossless Only',
          'image/jp2');

  static const TransferSyntax kJpeg2000ImageCompression = const TransferSyntax(
      '1.2.840.10008.1.2.4.91',
      'JPEG2000ImageCompression',
      'JPEG 2000 Image Compression',
      'image/jp2');

  static const TransferSyntax
      kJpeg2000Part2MultiComponentImageCompressionLosslessOnly =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.92',
          'JPEG2000Part2Multi_componentImageCompressionLosslessOnly',
          'JPEG 2000 Part 2 Multi-component Image Compression Lossless Only',
          'image/jp2');

  static const TransferSyntax kJpeg2000Part2MultiComponentImageCompression =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.93',
          'JPEG2000Part2Multi_componentImageCompression',
          'JPEG 2000 Part 2 Multi-component Image Compression',
          'image/jp2');

  static const TransferSyntax kJPIPReferenced = const TransferSyntax(
      '1.2.840.10008.1.2.4.94',
      'JPIPReferenced',
      'JPIP Referenced',
      'image/jpip???');

  static const TransferSyntax kJPIPReferencedDeflate = const TransferSyntax(
      '1.2.840.10008.1.2.4.95',
      'JPIPReferencedDeflate',
      'JPIP Referenced Deflate',
      'image/jpip???');

  static const TransferSyntax kMpeg2MainProfileMainLevel = const TransferSyntax(
      '1.2.840.10008.1.2.4.100',
      'MPEG2MainProfile_MainLevel',
      'MPEG2 Main Profile @ Main Level',
      'image/mpeg');

  static const TransferSyntax kMpeg2MainProfileHighLevel = const TransferSyntax(
      '1.2.840.10008.1.2.4.101',
      'MPEG2MainProfile_HighLevel',
      'MPEG2 Main Profile @ High Level',
      'image/mpeg???');

  static const TransferSyntax kMpeg4AVCH264HighProfileLevel41 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.102',
          'MPEG_4AVC_H264HighProfile_Level41',
          'MPEG-4 AVC/H.264 High Profile / Level 4.1',
          'image/mpeg4',
          isRetired: false);

  static const TransferSyntax kMpeg4AVCH264BDCompatibleHighProfileLevel41 =
      const TransferSyntax(
          '1.2.840.10008.1.2.4.103',
          'MPEG_4AVC_H264BD_compatibleHighProfile_Level41',
          'MPEG-4 AVC/H.264 BD-compatible High Profile / Level 4.1',
          'image/mpeg4???',
          isRetired: false);

  static const TransferSyntax kRLELossless = const TransferSyntax(
      '1.2.840.10008.1.2.5', 'RLELossless', 'RLE Lossless', 'image/rle???',
      isRetired: false);

  static const TransferSyntax kRFC2557MIMEncapsulation = const TransferSyntax(
      '1.2.840.10008.1.2.6.1',
      'RFC2557MIMEncapsulation',
      'RFC 2557 MIME encapsulation',
      'image/????',
      isRetired: false);

  static const TransferSyntax kXMLEncoding = const TransferSyntax(
      '1.2.840.10008.1.2.6.2', 'XMLEncoding', 'XML Encoding', 'text/xml???',
      isRetired: false);

  static const Map<String, Uid> _map = const {
    '1.2.840.10008.1.2': kImplicitVRLittleEndian,
    '1.2.840.10008.1.2.1': kExplicitVRLittleEndian,
    '1.2.840.10008.1.2.1.99': kDeflatedExplicitVRLittleEndian,
    '1.2.840.10008.1.2.2': kExplicitVRBigEndian,
    '1.2.840.10008.1.2.4.50': kJpegBaseline1,
    '1.2.840.10008.1.2.4.51': kJpegExtended2_4,
    '1.2.840.10008.1.2.4.52': kJpegExtended3_5,
    '1.2.840.10008.1.2.4.53': kJpegSpectralSelectionNonHierarchical6_8,
    '1.2.840.10008.1.2.4.54': kJpegSpectralSelectionNonHierarchical7_9,
    '1.2.840.10008.1.2.4.55': kJpegFullProgressionNonHierarchical10_12,
    '1.2.840.10008.1.2.4.56': kJpegFullProgressionNonHierarchical11_13,
    '1.2.840.10008.1.2.4.57': kJpegLosslessNonHierarchical14,
    '1.2.840.10008.1.2.4.58': kJpegLosslessNonHierarchical15,
    '1.2.840.10008.1.2.4.59': kJpegExtendedHierarchical16_18,
    '1.2.840.10008.1.2.4.60': kJpegExtendedHierarchical17_19,
    '1.2.840.10008.1.2.4.61': kJpegSpectralSelectionHierarchical20_22,
    '1.2.840.10008.1.2.4.62': kJpegSpectralSelectionHierarchical21_23,
    '1.2.840.10008.1.2.4.63': kJpegFullProgressionHierarchical24_26,
    '1.2.840.10008.1.2.4.64': kJpegFullProgressionHierarchical25_27,
    '1.2.840.10008.1.2.4.65': kJpegLosslessHierarchical28,
    '1.2.840.10008.1.2.4.66': kJpegLosslessHierarchical29,
    '1.2.840.10008.1.2.4.70':
        kJpegLosslessNonHierarchicalFirstOrderPrediction14_1,
    '1.2.840.10008.1.2.4.80': kJpegLSLosslessImageCompression,
    '1.2.840.10008.1.2.4.81': kJpegLSLossyImageCompression,
    '1.2.840.10008.1.2.4.90': kJpeg2000ImageCompressionLosslessOnly,
    '1.2.840.10008.1.2.4.91': kJpeg2000ImageCompression,
    '1.2.840.10008.1.2.4.92':
        kJpeg2000Part2MultiComponentImageCompressionLosslessOnly,
    '1.2.840.10008.1.2.4.93': kJpeg2000Part2MultiComponentImageCompression,
    '1.2.840.10008.1.2.4.94': kJPIPReferenced,
    '1.2.840.10008.1.2.4.95': kJPIPReferencedDeflate,
    '1.2.840.10008.1.2.4.100': kMpeg2MainProfileMainLevel,
    '1.2.840.10008.1.2.4.101': kMpeg2MainProfileHighLevel,
    '1.2.840.10008.1.2.4.102': kMpeg4AVCH264HighProfileLevel41,
    '1.2.840.10008.1.2.4.103': kMpeg4AVCH264BDCompatibleHighProfileLevel41,
    '1.2.840.10008.1.2.5': kRLELossless,
    '1.2.840.10008.1.2.6.1': kRFC2557MIMEncapsulation,
    '1.2.840.10008.1.2.6.2': kXMLEncoding
  };
}
