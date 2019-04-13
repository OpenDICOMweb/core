//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

const List<Term> kPhotometricInterpretationRelatedTerms = <Term>[
  Term.kMonochrome1,
  Term.kMonochrome2,
  Term.kMonochrome3,
  Term.kRGB,
  Term.kYBR_FULL,
  Term.kYBR_FULL_422,
  Term.kYBR_PARTIAL_422,
  Term.kYBR_PARTIAL_420,
  Term.kYBR_ICT,
  Term.kYBR_RCT
];

//const _PhotometricInterpretation = const [Term.kPhotometricInterpretation];

class RelatedTerms {
  final Term term;
  final List<Term> related;

  const RelatedTerms(this.term, this.related);

  static const RelatedTerms kPhotometricInterpretation =
      RelatedTerms(Term.kPhotometricInterpretation, <Term>[
    Term.kMonochrome1,
    Term.kMonochrome2,
    Term.kMonochrome3,
    Term.kRGB,
    Term.kYBR_FULL,
    Term.kYBR_FULL_422,
    Term.kYBR_PARTIAL_422,
    Term.kYBR_PARTIAL_420,
    Term.kYBR_ICT,
    Term.kYBR_RCT
  ]);
}

class Term {
  final String name;
  final String definition;

  const Term(this.name, this.definition);

  static const Term kYES = Term('YES', 'True or in agreement');
  static const Term kNO = Term('NO', 'False or NOT in agreement');

  static const Term kPhotometricInterpretation = Term(
      'Photometric Interpretation',
      'The values of Photometric Interpretation (0028,0004) specifies '
          'the intended interpretation of the image pixel data. See PS3.5 '
          'for restrictions imposed by compressed Transfer Syntaxes.'
          'The following values are defined. Other values are permitted but '
          'the meaning is not defined by this Standard.');

  static const Term kMonochrome1 = Term(
      'MONOCHROME1',
      'Pixel data represent a single monochrome image plane. The minimum '
          'sample values is intended to be displayed as white after any VOI '
          'gray scale transformations have been performed. See PS3.4. '
          'This values may be used only when Samples per Pixel '
          '(0028,0002) has a values of 1.');
  static const Term kMonochrome2 = Term(
      'MONOCHROME2',
      'Pixel data represent a single monochrome image plane. The minimum '
          'sample values is intended to be displayed as black after any VOI '
          'gray scale transformations have been performed. See PS3.4. This '
          'values may be used only when Samples per Pixel (0028,0002) has a '
          'values of 1.');
  static const Term kMonochrome3 = Term(
    'MONOCHROME3',
    'Pixel data describe a color image with a single sample per pixel (single '
        'image plane). The pixel values is used as an index into each of the '
        'Red, Blue, and Green Palette Color Lookup Tables '
        '(0028,1101-1103&1201-1203). This values may be used only when '
        'Samples per Pixel (0028,0002) has a values of 1. When the '
        'Photometric Interpretation is Palette Color; Red, '
        'Blue, and Green Palette Color Lookup Tables shall be present.',
  );
  static const Term kRGB = Term(
    'RGB',
    'Pixel data represent a color image described by red, green, and blue '
        'image planes. The minimum sample values for each color plane '
        'represents minimum intensity of the color. This values may be used'
        ' only when Samples per Pixel 0028,0002) has a values of 3.',
  );

  static const Term kHSV = Term('HSV', 'Retired.');
  // ignore: constant_identifier_names
  static const Term kARGB = Term('ARGB', 'Retired.');
  // ignore: constant_identifier_names
  static const Term kCMYK = Term('CMYK', 'Retired.');
  // ignore: constant_identifier_names
  static const Term kYBR_FULL = Term(
      'YBR_FULL',
      'Pixel data represent a color image described by one luminance (Y) '
          'and two chrominance planes (CB and CR). This photometric '
          'interpretation may be used only when Samples per Pixel (0028,0002) '
          'has a values of 3. Black is represented by Y equal to zero. '
          'The absence of color is represented by both CB and CR values '
          'equal to half full scale.\n    '
          'Note: In the case where Bits Allocated (0028,0100) has values of '
          '8 half full scale is 128.\n'
          'In the case where Bits Allocated (0028,0100) has a values of 8 '
          'then the following equations convert between RGB and YCBCR '
          'Photometric Interpretation.'
          '\n  Y = + .2990R + .5870G + .1140B'
          '\n  CB= - .1687R - .3313G + .5000B + 128'
          '\n  CR= + .5000R - .4187G - .0813B + 128'
          '\n    Note: The above is based on CCIR Recommendation 601-2 '
          'dated 1990.');

  //TODO: finish
  // ignore: constant_identifier_names
  static const Term kYBR_FULL_422 = Term(
    'YBR_FULL_422',
    'The same as YBR_FULL except that the CB and CR values are '
        'sampled horizontally at half the Y rate and as a result '
        'there are half as many CB and CR values as Y values...',
  );

  //TODO: finish
  // ignore: constant_identifier_names
  static const Term kYBR_PARTIAL_422 =
      Term('YBR_PARTIAL_422', 'The same as YBR_FULL_422 except that:...');

  //TODO: finish
  // ignore: constant_identifier_names
  static const Term kYBR_PARTIAL_420 = Term(
    'YBR_PARTIAL_420',
    'The same as YBR_PARTIAL_422 except that the CB and CR values are sampled '
        'horizontally and vertically at half the Y rate and as a result there '
        'are four times less CB and CR values than Y values, versus twice '
        'less for YBR_PARTIAL_422...',
  );

  //TODO: finish
  // ignore: constant_identifier_names
  static const Term kYBR_ICT =
      Term('YBR_ICT', 'Irreversible Color Transformation:...');

  //TODO: finish
  // ignore: constant_identifier_names
  static const Term kYBR_RCT =
      Term('YBR_RCT', 'Reversible Color Transformation:...');

  static const Term kDNS =
      Term('DNS', 'An Internet dotted name. Either in ASCII or as integers');
  static const Term kEUI64 =
      Term('EUI64', 'An IEEE Extended Unique Identifier');
  static const Term kISO =
      Term('ISO', 'An International Standards Organization Object Identifier');
  static const Term kURI = Term('URI', 'Uniform Resource Identifier');
  static const Term kUUID = Term('UUID', 'The DCE Universal Unique Identifier');
  static const Term kX400 = Term('X400', 'An X.400 MHS identifier');
  static const Term kX500 = Term('X500', 'An X.500 directory name');
}
