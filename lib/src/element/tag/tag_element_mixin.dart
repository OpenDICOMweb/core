// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/mixin/tag_mixin_base.dart';
import 'package:core/src/element/byte_data/bd_element.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/tag/date_time.dart';
import 'package:core/src/element/tag/float.dart';
import 'package:core/src/element/tag/integer.dart';
import 'package:core/src/element/tag/string.dart';
import 'package:core/src/tag/tag_lib.dart';

typedef Element TagElementMaker<V>(Tag tag, Iterable<V> vList);
typedef TagElement MakeFrom(Element e);
typedef TagElement MakeFromBytes(ByteData bd);
typedef Element MakeFromBD(BDElement bd);

/// Tag Mixin Class
///
/// This mixin defines the interface to DICOM Tags, where a Tag is
/// a semantic identifier for an element.
abstract class TagElement<V> implements TagMixinBase<int, V> {
  // **** Tag Identifiers
  @override
  Tag get tag;
  @override
  int get key => tag.code;
  //Fix when fast_tag is ready
  int get index => tag.code;
  int get code => tag.code;
  String get keyword => tag.keyword;
  String get name => tag.name;

  // VR related Getters
  @override
  int get vrIndex => tag.vrIndex;
  @override
  int get vrCode => tag.vrCode;

  // **** VM Related Getters
  @override
  VM get vm => tag.vm;
  @override
  int get vmMin => tag.vm.min;
  @override
  int get vmMax => tag.vm.max;
  @override
  int get vmColumns => tag.vm.columns;

  // **** Value Field related Getters ****

  // This Getter must be overridden in OB, OW, SQ, and UN;
  @override
  int get vfLengthField => vfLength;

  @override
  EType get eType => tag.type;
  @override
  int get eTypeIndex => tag.type.index;
  // TODO: fix
  @override
  ETypePredicate get eTypePredicate => throw new UnimplementedError();

  // TODO: fix to IE.patient.index
  @override
  IEType get ieType => IEType.kInstance;

  @override
  int get ieIndex => ieType.index;

  @override
  String get ieLevel => ieType.level;

  //TODO: fix
  @override
  int get deIdIndex => 0;

  //TODO: fix
//  @override
//	DeIdMethod get deIdMethod => tag.deIdMethod;

  /// Returns true if _this_ is a Data Element defined by the DICOM Standard.
  @override
  bool get isPublic => tag.isPublic;
  @override
  bool get isPrivate => tag.isPrivate;

  @override
  bool get isRetired => tag.isRetired;

  /// Insert a DICOM media type header in the first 8 or 12
  /// bytes depending on the VR of the Element.
  ByteData getDcmBytes(int vfLength) {
    final bd = new ByteData(tag.dcmHeaderLength + vfLength)
      ..setUint32(0, code)
      ..setUint16(4, vrCode);
    if (tag.hasShortVF) {
      bd.setUint16(6, bd.lengthInBytes);
    } else {
      bd.setUint16(8, bd.lengthInBytes);
    }
    return bd;
  }

  static Element make(Tag tag, Iterable values, int vrIndex) =>
   // assert(tag.vr.isValid == vrIndex, 'Tag VR: ${tag.vrIndex}, vrIndex, '
   //     '$vrIndex');
     _tagMakers[vrIndex](tag, values);



  static Element from(Element e, int vrIndex) =>
      make(e.tag, e.values, vrIndex);

  static final List<TagElementMaker> _tagMakers = <TagElementMaker>[
    null,
    // Maybe Undefined Lengths
    OBtag.make, OWtag.make, UNtag.make, // No reformat

    // EVR Long
    ODtag.make, OFtag.make, OLtag.make,
    UCtag.make, URtag.make, UTtag.make,

    // EVR Short
    AEtag.make, AStag.make, ATtag.make,
    CStag.make, DAtag.make, DStag.make,
    DTtag.make, FDtag.make, FLtag.make,
    IStag.make, LOtag.make, LTtag.make,
    PNtag.make, SHtag.make, SLtag.make,
    SStag.make, STtag.make, TMtag.make,
    UItag.make, ULtag.make, UStag.make,
  ];

/*
  static Element fromEB(EBytes eb, [int vrIndex]) => _eByteMakers[vrIndex](eb);


  static final List<MakeFromEBytes> _eByteMakers = <MakeFromEBytes>[
    _sqError,
    // Maybe Undefined Lengths
    OBtag.fromEBytes, OWtag.fromEBytes, UNtag.fromEBytes, // No reformat

    // EVR Long
    ODtag.fromEBytes, OFtag.fromEBytes, OLtag.fromEBytes,
    UCtag.fromEBytes, URtag.fromEBytes, UTtag.fromEBytes,

    // EVR Short
    AEtag.fromEBytes, AStag.fromEBytes, ATtag.fromEBytes,
    CStag.fromEBytes, DAtag.fromEBytes, DStag.fromEBytes,
    DTtag.fromEBytes, FDtag.fromEBytes, FLtag.fromEBytes,
    IStag.fromEBytes, LOtag.fromEBytes, LTtag.fromEBytes,
    PNtag.fromEBytes, SHtag.fromEBytes, SLtag.fromEBytes,
    SStag.fromEBytes, STtag.fromEBytes, TMtag.fromEBytes,
    UItag.fromEBytes, ULtag.fromEBytes, UStag.fromEBytes,
  ];
*/

//  static Null _sqError(EBytes eb) => invalidElementIndex(0);

  static Element fromBD(BDElement bd, [int vrIndex]) =>
      _bdElementMakers[vrIndex](bd);

  static final List<MakeFromBD> _bdElementMakers = <MakeFromBD>[
    _sqErrorBD,
    // Maybe Undefined Lengths
    OBtag.fromBD, OWtag.fromBD, UNtag.fromBD, // No reformat

    // EVR Long
    ODtag.fromBD, OFtag.fromBD, OLtag.fromBD,
    UCtag.fromBD, URtag.fromBD, UTtag.fromBD,

    // EVR Short
    AEtag.fromBD, AStag.fromBD, ATtag.fromBD,
    CStag.fromBD, DAtag.fromBD, DStag.fromBD,
    DTtag.fromBD, FDtag.fromBD, FLtag.fromBD,
    IStag.fromBD, LOtag.fromBD, LTtag.fromBD,
    PNtag.fromBD, SHtag.fromBD, SLtag.fromBD,
    SStag.fromBD, STtag.fromBD, TMtag.fromBD,
    UItag.fromBD, ULtag.fromBD, UStag.fromBD,
  ];

  static Null _sqErrorBD(BDElement bd) => invalidElementIndex(0);



}
