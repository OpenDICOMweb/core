//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/value/uid/well_known/transfer_syntax.dart';

//TODO: finish this class
class SupportedTransferSyntax {
  final TransferSyntax uid;
  final bool isStorable;
  final bool isDecodable;
  final bool isEncodable;
  final bool isDisplayable;

  //TODO: flesh out the rest of this table.
  const SupportedTransferSyntax(this.uid,
      {this.isStorable = true,
      this.isDecodable = false,
      this.isEncodable = false,
      this.isDisplayable = false});

  static bool contains(String uid) => map.containsKey(uid);
  static bool isSupported(String uid) => map.containsKey(uid);

  static const SupportedTransferSyntax kImplicitVRLittleEndian =
      const SupportedTransferSyntax(TransferSyntax.kImplicitVRLittleEndian,
          isStorable: true, isDecodable: true, isEncodable: false, isDisplayable: true);

  static const SupportedTransferSyntax kExplicitVRLittleEndian =
      const SupportedTransferSyntax(TransferSyntax.kExplicitVRLittleEndian,
          isStorable: true, isDecodable: true, isEncodable: true, isDisplayable: true);
  static const SupportedTransferSyntax kDeflatedExplicitVRLittleEndian =
      const SupportedTransferSyntax(TransferSyntax.kDeflatedExplicitVRLittleEndian);
//  static const SupportedTransferSyntax kExplicitVRBigEndian =
//      const SupportedTransferSyntax(TransferSyntax.kExplicitVRBigEndian);
  static const SupportedTransferSyntax kJpegBaseline1 =
      const SupportedTransferSyntax(TransferSyntax.kJpegBaseline1);
  static const SupportedTransferSyntax kJpegExtended2_4 =
      const SupportedTransferSyntax(TransferSyntax.kJpegExtended2_4);
  static const SupportedTransferSyntax kJpegExtended3_5 =
      const SupportedTransferSyntax(TransferSyntax.kJpegExtended3_5);
  static const SupportedTransferSyntax kJpegSpectralSelectionNonHierarchical6_8 =
      const SupportedTransferSyntax(
          TransferSyntax.kJpegSpectralSelectionNonHierarchical6_8);
  static const SupportedTransferSyntax kJpegSpectralSelectionNonHierarchical7_9 =
      const SupportedTransferSyntax(
          TransferSyntax.kJpegSpectralSelectionNonHierarchical7_9);
  static const SupportedTransferSyntax kJpegFullProgressionNonHierarchical10_12 =
      const SupportedTransferSyntax(
          TransferSyntax.kJpegFullProgressionNonHierarchical10_12);
  static const SupportedTransferSyntax kJpegFullProgressionNonHierarchical11_13 =
      const SupportedTransferSyntax(
          TransferSyntax.kJpegFullProgressionNonHierarchical11_13);
  static const SupportedTransferSyntax kJpegLosslessNonHierarchical14 =
      const SupportedTransferSyntax(TransferSyntax.kJpegLosslessNonHierarchical14);
  static const SupportedTransferSyntax kJpegLosslessNonHierarchical15 =
      const SupportedTransferSyntax(TransferSyntax.kJpegLosslessNonHierarchical15);
  static const SupportedTransferSyntax kJpegExtendedHierarchical16_18 =
      const SupportedTransferSyntax(TransferSyntax.kJpegExtendedHierarchical16_18);
  static const SupportedTransferSyntax kJpegExtendedHierarchical17_19 =
      const SupportedTransferSyntax(TransferSyntax.kJpegExtendedHierarchical17_19);
  static const SupportedTransferSyntax kJpegSpectralSelectionHierarchical20_22 =
      const SupportedTransferSyntax(
          TransferSyntax.kJpegSpectralSelectionHierarchical20_22);
  static const SupportedTransferSyntax kJpegSpectralSelectionHierarchical21_23 =
      const SupportedTransferSyntax(
          TransferSyntax.kJpegSpectralSelectionHierarchical21_23);
  static const SupportedTransferSyntax kJpegFullProgressionHierarchical24_26 =
      const SupportedTransferSyntax(TransferSyntax.kJpegFullProgressionHierarchical24_26);
  static const SupportedTransferSyntax kJpegFullProgressionHierarchical25_27 =
      const SupportedTransferSyntax(TransferSyntax.kJpegFullProgressionHierarchical25_27);
  static const SupportedTransferSyntax kJpegLosslessHierarchical28 =
      const SupportedTransferSyntax(TransferSyntax.kJpegLosslessHierarchical28);
  static const SupportedTransferSyntax kJpegLosslessHierarchical29 =
      const SupportedTransferSyntax(TransferSyntax.kJpegLosslessHierarchical29);
  static const SupportedTransferSyntax
      kJpegLosslessNonHierarchicalFirstOrderPrediction14_1 =
      const SupportedTransferSyntax(
          TransferSyntax.kJpegLosslessNonHierarchicalFirstOrderPrediction14_1);
  static const SupportedTransferSyntax kJpegLSLosslessImageCompression =
      const SupportedTransferSyntax(TransferSyntax.kJpegLSLosslessImageCompression);
  static const SupportedTransferSyntax kJpegLSLossyImageCompression =
      const SupportedTransferSyntax(TransferSyntax.kJpegLSLossyImageCompression);
  static const SupportedTransferSyntax kJpeg2000ImageCompressionLosslessOnly =
      const SupportedTransferSyntax(TransferSyntax.kJpeg2000ImageCompressionLosslessOnly);
  static const SupportedTransferSyntax kJpeg2000ImageCompression =
      const SupportedTransferSyntax(TransferSyntax.kJpeg2000ImageCompression);
  static const SupportedTransferSyntax
      kJpeg2000Part2MultiComponentImageCompressionLosslessOnly =
      const SupportedTransferSyntax(
          TransferSyntax.kJpeg2000Part2MultiComponentImageCompressionLosslessOnly);
  static const SupportedTransferSyntax kJpeg2000Part2MultiComponentImageCompression =
      const SupportedTransferSyntax(
          TransferSyntax.kJpeg2000Part2MultiComponentImageCompression);
  static const SupportedTransferSyntax kJPIPReferenced =
      const SupportedTransferSyntax(TransferSyntax.kJPIPReferenced);
  static const SupportedTransferSyntax kJPIPReferencedDeflate =
      const SupportedTransferSyntax(TransferSyntax.kJPIPReferencedDeflate);
  static const SupportedTransferSyntax kMpeg2MainProfileMainLevel =
      const SupportedTransferSyntax(TransferSyntax.kMpeg2MainProfileMainLevel);
  static const SupportedTransferSyntax kMpeg2MainProfileHighLevel =
      const SupportedTransferSyntax(TransferSyntax.kMpeg2MainProfileHighLevel);
  static const SupportedTransferSyntax kMpeg4AVCH264HighProfileLevel41 =
      const SupportedTransferSyntax(TransferSyntax.kMpeg4AVCH264HighProfileLevel41);
  static const SupportedTransferSyntax kMpeg4AVCH264BDCompatibleHighProfileLevel41 =
      const SupportedTransferSyntax(
          TransferSyntax.kMpeg4AVCH264BDCompatibleHighProfileLevel41);
  static const SupportedTransferSyntax kRLELossless =
      const SupportedTransferSyntax(TransferSyntax.kRLELossless);
  static const SupportedTransferSyntax kRFC2557MIMEncapsulation =
      const SupportedTransferSyntax(TransferSyntax.kRFC2557MIMEncapsulation);
  static const SupportedTransferSyntax kXMLEncoding =
      const SupportedTransferSyntax(TransferSyntax.kXMLEncoding);

  static Map<String, SupportedTransferSyntax> map = const {
    '1.2.840.10008.1.2': kImplicitVRLittleEndian,
    '1.2.840.10008.1.2.1': kExplicitVRLittleEndian,
    '1.2.840.10008.1.2.1.99': kDeflatedExplicitVRLittleEndian,
//    '1.2.840.10008.1.2.2' : kExplicitVRBigEndian,
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
    '1.2.840.10008.1.2.4.70': kJpegLosslessNonHierarchicalFirstOrderPrediction14_1,
    '1.2.840.10008.1.2.4.80': kJpegLSLosslessImageCompression,
    '1.2.840.10008.1.2.4.81': kJpegLSLossyImageCompression,
    '1.2.840.10008.1.2.4.90': kJpeg2000ImageCompressionLosslessOnly,
    '1.2.840.10008.1.2.4.91': kJpeg2000ImageCompression,
    '1.2.840.10008.1.2.4.92': kJpeg2000Part2MultiComponentImageCompressionLosslessOnly,
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

  /// TODO: update to describe support for reading, writing, & displaying
  static List<TransferSyntax> supportedTransferSyntaxes = const <TransferSyntax>[
    TransferSyntax.kImplicitVRLittleEndian,
    TransferSyntax.kExplicitVRLittleEndian,
    TransferSyntax.kDeflatedExplicitVRLittleEndian,
    //  TransferSyntax.kExplicitVRBigEndian,
    TransferSyntax.kJpegBaseline1,
    TransferSyntax.kJpegExtended2_4,
    TransferSyntax.kJpegExtended3_5,
    TransferSyntax.kJpegSpectralSelectionNonHierarchical6_8,
    TransferSyntax.kJpegSpectralSelectionNonHierarchical7_9,
    TransferSyntax.kJpegFullProgressionNonHierarchical10_12,
    TransferSyntax.kJpegFullProgressionNonHierarchical11_13,
    TransferSyntax.kJpegLosslessNonHierarchical14,
    TransferSyntax.kJpegLosslessNonHierarchical15,
    TransferSyntax.kJpegExtendedHierarchical16_18,
    TransferSyntax.kJpegExtendedHierarchical17_19,
    TransferSyntax.kJpegSpectralSelectionHierarchical20_22,
    TransferSyntax.kJpegSpectralSelectionHierarchical21_23,
    TransferSyntax.kJpegFullProgressionHierarchical24_26,
    TransferSyntax.kJpegFullProgressionHierarchical25_27,
    TransferSyntax.kJpegLosslessHierarchical28,
    TransferSyntax.kJpegLosslessHierarchical29,
    TransferSyntax.kJpegLosslessNonHierarchicalFirstOrderPrediction14_1,
    TransferSyntax.kJpegLSLosslessImageCompression,
    TransferSyntax.kJpegLSLossyImageCompression,
    TransferSyntax.kJpeg2000ImageCompressionLosslessOnly,
    TransferSyntax.kJpeg2000ImageCompression,
    TransferSyntax.kJpeg2000Part2MultiComponentImageCompressionLosslessOnly,
    TransferSyntax.kJpeg2000Part2MultiComponentImageCompression,
    TransferSyntax.kJPIPReferenced,
    TransferSyntax.kJPIPReferencedDeflate,
    TransferSyntax.kMpeg2MainProfileMainLevel,
    TransferSyntax.kMpeg2MainProfileHighLevel,
    TransferSyntax.kMpeg4AVCH264HighProfileLevel41,
    TransferSyntax.kMpeg4AVCH264BDCompatibleHighProfileLevel41,
    TransferSyntax.kRLELossless,
    TransferSyntax.kRFC2557MIMEncapsulation,
    TransferSyntax.kXMLEncoding
  ];
}
