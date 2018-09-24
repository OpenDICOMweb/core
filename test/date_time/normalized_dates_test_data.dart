//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'test normalized dates', level: Level.info);

  test('Normalized Date Test', () {
    for (var list in normalizedDateTestData) {
      final enrollmentDate = Date.parse(list[2], isDicom: false);
      final studyDate = Date.parse(list[3], isDicom: false);
      final answer = Date.parse(list[4], isDicom: false);
      final normalizedDate = studyDate.normalize(enrollmentDate);
      log
        ..debug('enrollmentDate: $enrollmentDate')
        ..debug('     studyDate: $studyDate')
        ..debug('normalizedDate: $normalizedDate')
        ..debug('        answer: $answer');
      expect(normalizedDate == answer, true);
    }
  });
}

const List<List<String>> normalizedDateTestData = <List<String>>[
  //'Image Case #', 'Clinical Case #', 'Enrollment', 'Study', 'Normalized],
  <String>['005-001', '10', '2010-08-19', '2010-08-19', '1960-01-01'],
  <String>['001-001', '1', '2009-11-10', '2010-01-13', '1960-03-05'],
  <String>['001-001', '1', '2009-11-10', '2010-01-13', '1960-03-05'],
  <String>['001-001', '1', '2009-11-10', '2010-01-13', '1960-03-05'],
  <String>['001-001', '1', '2009-11-10', '2009-11-10', '1960-01-01'],
  <String>['001-001', '1', '2009-11-10', '2010-02-17', '1960-04-09'],
  <String>['001-001', '1', '2009-11-10', '2010-02-18', '1960-04-10'],
  <String>[
    '001-001 FDG 1 Regional',
    '1',
    '2009-11-10',
    '2009-11-10',
    '1960-01-01'
  ],
  <String>[
    '001-001 FDG 2 Regional',
    '1',
    '2009-11-10',
    '2010-01-07',
    '1960-02-28'
  ],
  <String>[
    '001-001 FDG 2 WB',
    '1',
    '2009-11-10',
    '2010-01-07',
    '1960-02-28'
  ],
  <String>[
    '001-001 FDG 3 Regional',
    '1',
    '2009-11-10',
    '2010-02-17',
    '1960-04-09'
  ],
  <String>[
    '001-001 FLT 1 Dynamic',
    '1',
    '2009-11-10',
    '2009-11-13',
    '1960-01-04'
  ],
  <String>[
    '001-001 FLT 1 WB',
    '1',
    '2009-11-10',
    '2009-11-13',
    '1960-01-04'
  ],
  <String>[
    '001-001 FLT 1 WB(2hr)',
    '1',
    '2009-11-10',
    '2009-11-13',
    '1960-01-04'
  ],
  <String>[
    '001-001 FLT 3',
    '1',
    '2009-11-10',
    '2010-02-18',
    '1960-04-10'
  ],
  <String>['001-002', '2', '2010-01-18', '2010-03-08', '1960-02-19'],
  <String>['001-002', '2', '2010-01-18', '2010-03-08', '1960-02-19'],
  <String>['001-002', '2', '2010-01-18', '2010-03-10', '1960-02-21'],
  <String>['001-002', '2', '2010-01-18', '2010-03-10', '1960-02-21'],
  <String>['001-002', '2', '2010-01-18', '2010-03-10', '1960-02-21'],
  <String>['001-002', '2', '2010-01-18', '2010-01-20', '1960-01-03'],
  <String>[
    '001-002 FDG 1',
    '2',
    '2010-01-18',
    '2010-01-18',
    '1960-01-01'
  ],
  <String>[
    '001-002 FDG 1 Regional',
    '2',
    '2010-01-18',
    '2010-01-18',
    '1960-01-01'
  ],
  <String>[
    '001-002 FLT 1 WB',
    '2',
    '2010-01-18',
    '2010-01-20',
    '1960-01-03'
  ],
  <String>[
    '001-002 FLT 1 WB',
    '2',
    '2010-01-18',
    '2010-01-20',
    '1960-01-03'
  ],
  <String>['001-003', '3', '2010-03-23', '2010-08-19', '1960-05-29'],
  <String>['001-003', '3', '2010-03-23', '2010-08-19', '1960-05-29'],
  <String>['001-003', '3', '2010-03-23', '2010-08-19', '1960-05-29'],
  <String>['001-003', '3', '2010-03-23', '2010-05-25', '1960-03-04'],
  <String>['001-003', '3', '2010-03-23', '2010-05-25', '1960-03-04'],
  <String>['001-003', '3', '2010-03-23', '2010-03-23', '1960-01-01'],
  <String>['001-003', '3', '2010-03-23', '2010-03-23', '1960-01-01'],
  <String>['001-003', '3', '2010-03-23', '2010-03-24', '1960-01-02'],
  <String>['001-003', '3', '2010-03-23', '2010-03-24', '1960-01-02'],
  <String>['001-003', '3', '2010-03-23', '2010-03-24', '1960-01-02'],
  <String>['001-004', '4', '2010-04-27', '2010-06-29', '1960-03-04'],
  <String>['001-004', '4', '2010-04-27', '2010-06-30', '1960-03-05'],
  <String>['001-004', '4', '2010-04-27', '2010-04-26', '1959-12-31'],
  <String>['001-004', '4', '2010-04-27', '2010-04-26', '1959-12-31'],
  <String>['001-004', '4', '2010-04-27', '2010-04-27', '1960-01-01'],
  <String>['001-004', '4', '2010-04-27', '2010-04-27', '1960-01-01'],
  <String>['001-004', '4', '2010-04-27', '2010-04-27', '1960-01-01'],
  <String>[
    '001-004 FDG 2',
    '4',
    '2010-04-27',
    '2010-06-29',
    '1960-03-04'
  ],
  <String>[
    '001-004 FLT 2 WB (2hr)',
    '4',
    '2010-04-27',
    '2010-06-30',
    '1960-03-05'
  ],
  <String>[
    '001-004 FLT 2 WB (2hr)',
    '4',
    '2010-04-27',
    '2010-06-30',
    '1960-03-05'
  ],
  <String>['001-005', '5', '2010-04-29', '2010-08-18', '1960-04-21'],
  <String>['001-005', '5', '2010-04-29', '2010-08-18', '1960-04-21'],
  <String>['001-005', '5', '2010-04-29', '2010-08-18', '1960-04-21'],
  <String>['001-005', '5', '2010-04-29', '2010-05-06', '1960-01-08'],
  <String>['001-005', '5', '2010-04-29', '2010-05-06', '1960-01-08'],
  <String>['001-005', '5', '2010-04-29', '2010-04-29', '1960-01-01'],
  <String>['001-005', '5', '2010-04-29', '2010-04-29', '1960-01-01'],
  <String>['001-005', '5', '2010-04-29', '2010-08-11', '1960-04-14'],
  <String>['001-005', '5', '2010-04-29', '2010-08-11', '1960-04-14'],
  <String>['001-005', '5', '2010-04-29', '2010-10-27', '1960-06-30'],
  <String>['001-005', '5', '2010-04-29', '2010-10-27', '1960-06-30'],
  <String>['001-005', '5', '2010-04-29', '2010-10-28', '1960-07-01'],
  <String>['001-005', '5', '2010-04-29', '2010-10-28', '1960-07-01'],
  <String>['001-005', '5', '2010-04-29', '2010-10-28', '1960-07-01'],
  <String>[
    '001-006 FLT 1 WB(2Hr)',
    '6',
    '2010-05-24',
    '2010-05-24',
    '1960-01-01'
  ],
  <String>[
    '001-006 FLT 1WB(1hr)',
    '6',
    '2010-05-24',
    '2010-05-24',
    '1960-01-01'
  ],
  <String>['001-007', '9', '2010-07-28', '2010-07-29', '1960-01-02'],
  <String>['001-007', '9', '2010-07-28', '2010-07-29', '1960-01-02'],
  <String>['001-007', '9', '2010-07-28', '2010-07-29', '1960-01-02'],
  <String>['001-007', '9', '2010-07-28', '2010-10-13', '1960-03-18'],
  <String>['001-007', '9', '2010-07-28', '2010-10-13', '1960-03-18'],
  <String>['001-007', '9', '2010-07-28', '2010-10-13', '1960-03-18'],
  <String>['001-008', '30', '2011-02-22', '2011-03-08', '1960-01-15'],
  <String>['001-008', '30', '2011-02-22', '2011-03-08', '1960-01-15'],
  <String>['001-008', '30', '2011-02-22', '2011-02-22', '1960-01-01'],
  <String>['001-008', '30', '2011-02-22', '2011-02-22', '1960-01-01'],
  <String>['001-008', '30', '2011-02-22', '2011-02-22', '1960-01-01'],
  <String>['001-008', '30', '2011-02-22', '2011-07-18', '1960-05-26'],
  <String>['001-008', '30', '2011-02-22', '2011-07-18', '1960-05-26'],
  <String>['001-009', '42', '2011-05-17', '2011-06-07', '1960-01-22'],
  <String>['001-009', '42', '2011-05-17', '2011-06-07', '1960-01-22'],
  <String>['001-009', '42', '2011-05-17', '2011-05-17', '1960-01-01'],
  <String>['001-009', '42', '2011-05-17', '2011-05-17', '1960-01-01'],
  <String>['001-009', '42', '2011-05-17', '2011-05-17', '1960-01-01'],
  <String>['001-009', '42', '2011-05-17', '2011-11-28', '1960-07-14'],
  <String>['001-009', '42', '2011-05-17', '2011-11-28', '1960-07-14'],
  <String>['001-010', '70', '2011-12-15', '2011-12-15', '1960-01-01'],
  <String>['001-010', '70', '2011-12-15', '2011-12-15', '1960-01-01'],
  <String>['001-010', '70', '2011-12-15', '2011-12-21', '1960-01-07'],
  <String>['001-010', '70', '2011-12-15', '2012-04-19', '1960-05-06'],
  <String>['001-010', '70', '2011-12-15', '2012-04-19', '1960-05-06'],
  <String>['001-010', '70', '2011-12-15', '2011-12-21', '1960-01-07'],
  <String>['001-011', '80', '2012-03-22', '2012-03-22', '1960-01-01'],
  <String>['001-011', '80', '2012-03-22', '2012-03-22', '1960-01-01'],
  <String>['001-011', '80', '2012-03-22', '2012-04-12', '1960-01-22'],
  <String>['001-011', '80', '2012-03-22', '2012-04-12', '1960-01-22'],
  <String>['002-001', '14', '2010-09-24', '2010-10-01', '1960-01-08'],
  <String>['002-001', '14', '2010-09-24', '2010-10-13', '1960-01-20'],
  <String>['002-001', '14', '2010-09-24', '2010-09-30', '1960-01-07'],
  <String>['002-001', '14', '2010-09-24', '2011-04-01', '1960-07-08'],
  <String>['002-001', '14', '2010-09-24', '2010-09-30', '1960-01-07'],
  <String>['002-001', '14', '2010-09-24', '2010-10-13', '1960-01-20'],
  <String>['002-001', '14', '2010-09-24', '2010-09-30', '1960-01-07'],
  <String>['002-001', '14', '2010-09-24', '2010-09-30', '1960-01-07'],
  <String>['002-001', '14', '2010-09-24', '2010-09-30', '1960-01-07'],
  <String>['002-002', '18', '2010-10-12', '2010-10-22', '1960-01-11'],
  <String>['002-002', '18', '2010-10-12', '2010-10-20', '1960-01-09'],
  <String>['002-002', '18', '2010-10-12', '2010-10-20', '1960-01-09'],
  <String>['002-003', '19', '2010-10-20', '2010-10-28', '1960-01-09'],
  <String>['002-003', '19', '2010-10-20', '2011-03-31', '1960-06-11'],
  <String>['002-003', '19', '2010-10-20', '2010-10-15', '1959-12-27'],
  <String>['002-003', '19', '2010-10-20', '2010-11-05', '1960-01-17'],
  <String>['002-003', '19', '2010-10-20', '2011-03-31', '1960-06-11'],
  <String>['002-003', '19', '2010-10-20', '2010-10-28', '1960-01-09'],
  <String>['002-003', '19', '2010-10-20', '2010-11-05', '1960-01-17'],
  <String>['002-004', '23', '2010-12-28', '2011-01-14', '1960-01-18'],
  <String>['002-004', '23', '2010-12-28', '2011-02-04', '1960-02-08'],
  <String>['002-004', '23', '2010-12-28', '2011-01-13', '1960-01-17'],
  <String>['002-004', '23', '2010-12-28', '2011-06-24', '1960-06-27'],
  <String>['002-004', '23', '2010-12-28', '2011-01-13', '1960-01-17'],
  <String>['002-004', '23', '2010-12-28', '2011-02-04', '1960-02-08'],
  <String>['002-004', '23', '2010-12-28', '2011-06-24', '1960-06-27'],
  <String>['002-005', '31', '2011-03-02', '2011-07-21', '1960-05-21'],
  <String>['002-005', '31', '2011-03-02', '2011-04-07', '1960-02-06'],
  <String>['002-005', '31', '2011-03-02', '2011-04-07', '1960-02-06'],
  <String>['002-005', '31', '2011-03-02', '2011-07-21', '1960-05-21'],
  <String>['002-005', '31', '2011-03-02', '2011-03-18', '1960-01-17'],
  <String>['002-005', '31', '2011-03-02', '2011-03-18', '1960-01-17'],
  <String>['002-005', '31', '2011-03-02', '2011-03-18', '1960-01-17'],
  <String>['002-005', '31', '2011-03-02', '2011-04-07', '1960-02-06'],
  <String>['002-005', '31', '2011-03-02', '2011-04-07', '1960-02-06'],
  <String>['002-005', '31', '2011-03-02', '2011-07-21', '1960-05-21'],
  <String>['002-007', '44', '2011-06-07', '2011-11-17', '1960-06-12'],
  <String>['002-007', '44', '2011-06-07', '2011-11-17', '1960-06-12'],
  <String>['002-007', '44', '2011-06-07', '2011-06-23', '1960-01-17'],
  <String>['002-007', '44', '2011-06-07', '2011-06-09', '1960-01-03'],
  <String>['002-007', '44', '2011-06-07', '2011-06-23', '1960-01-17'],
  <String>['002-008', '45', '2011-06-15', '2011-06-23', '1960-01-09'],
  <String>['002-008', '45', '2011-06-15', '2011-10-13', '1960-04-30'],
  <String>['002-008', '45', '2011-06-15', '2011-06-15', '1960-01-01'],
  <String>['002-008', '45', '2011-06-15', '2011-06-23', '1960-01-09'],
  <String>['002-008', '45', '2011-06-15', '2011-06-23', '1960-01-09'],
  <String>['003-001', '7', '2010-07-19', '2010-07-15', '1959-12-28'],
  <String>['003-001', '7', '2010-07-19', '2010-07-15', '1959-12-28'],
  <String>['003-001', '7', '2010-07-19', '2010-07-15', '1959-12-28'],
  <String>['003-002', '33', '2011-03-14', '2011-03-28', '1960-01-15'],
  <String>['003-002', '33', '2011-03-14', '2011-03-14', '1960-01-01'],
  <String>['003-003', '38', '2011-04-07', '2011-04-07', '1960-01-01'],
  <String>['003-003', '38', '2011-04-07', '2011-05-02', '1960-01-26'],
  <String>['003-003', '38', '2011-04-07', '2011-10-06', '1960-07-01'],
  <String>['003-004', '39', '2011-04-26', '2011-04-26', '1960-01-01'],
  <String>['003-004', '39', '2011-04-26', '2011-05-12', '1960-01-17'],
  <String>['003-004', '39', '2011-04-26', '2011-05-12', '1960-01-17'],
  <String>['003-004', '39', '2011-04-26', '2011-10-20', '1960-06-26'],
  <String>['003-004', '39', '2011-04-26', '2011-04-26', '1960-01-01'],
  <String>['003-005', '40', '2011-04-27', '2011-05-06', '1960-01-10'],
  <String>['003-005', '40', '2011-04-27', '2011-04-27', '1960-01-01'],
  <String>['003-005', '40', '2011-04-27', '2011-04-27', '1960-01-01'],
  <String>['003-005', '40', '2011-04-27', '2011-05-06', '1960-01-10'],
  <String>['003-006', '49', '2011-07-20', '2011-08-18', '1960-01-30'],
  <String>['003-006', '49', '2011-07-20', '2012-01-30', '1960-07-13'],
  <String>['003-006', '49', '2011-07-20', '2011-07-20', '1960-01-01'],
  <String>['003-007', '50', '2011-07-26', '2011-07-26', '1960-01-01'],
  <String>['003-007', '50', '2011-07-26', '2011-08-04', '1960-01-10'],
  <String>['003-009', '52', '2011-08-19', '2011-08-25', '1960-01-07'],
  <String>['003-009', '52', '2011-08-19', '2012-02-28', '1960-07-12'],
  <String>['003-010', '77', '2012-02-17', '2012-02-21', '1960-01-05'],
  <String>['003-011', '84', '2012-05-01', '2012-05-01', '1960-01-01'],
  <String>['004-001', '8', '2010-07-22', '2010-07-13', '1959-12-23'],
  <String>['004-001', '8', '2010-07-22', '2010-07-22', '1960-01-01'],
  <String>['004-002', '22', '2010-11-30', '2010-12-09', '1960-01-10'],
  <String>['004-002', '22', '2010-11-30', '2011-04-05', '1960-05-06'],
  <String>['004-002', '22', '2010-11-30', '2010-12-09', '1960-01-10'],
  <String>['004-002', '22', '2010-11-30', '2010-12-09', '1960-01-10'],
  <String>['004-002', '22', '2010-11-30', '2010-12-20', '1960-01-21'],
  <String>['004-002', '22', '2010-11-30', '2010-12-20', '1960-01-21'],
  <String>['004-002', '22', '2010-11-30', '2011-04-05', '1960-05-06'],
  <String>['004-002', '22', '2010-11-30', '2010-11-23', '1959-12-25'],
  <String>['004-003', '78', '2012-02-22', '2012-02-17', '1959-12-27'],
  <String>['004-003', '78', '2012-02-22', '2012-02-28', '1960-01-07'],
  <String>['005-001', '10', '2010-08-19', '2010-08-19', '1960-01-01'],
  <String>['005-001', '10', '2010-08-19', '2010-08-19', '1960-01-01'],
  <String>['005-001', '10', '2010-08-19', '2010-09-02', '1960-01-15'],
  <String>['005-001', '10', '2010-08-19', '2011-02-07', '1960-06-21'],
  <String>['005-001', '10', '2010-08-19', '2011-02-07', '1960-06-21'],
  <String>['005-001', '10', '2010-08-19', '2010-09-02', '1960-01-15'],
  <String>['005-001', '10', '2010-08-19', '2011-02-07', '1960-06-21'],
  <String>['005-002', '11', '2010-08-24', '2011-02-08', '1960-06-17'],
  <String>['005-002', '11', '2010-08-24', '2010-08-25', '1960-01-02'],
  <String>['005-002', '11', '2010-08-24', '2010-10-01', '1960-02-08'],
  <String>['005-002', '11', '2010-08-24', '2011-02-08', '1960-06-17'],
  <String>['005-002', '11', '2010-08-24', '2011-02-08', '1960-06-17'],
  <String>['005-002', '11', '2010-08-24', '2010-08-25', '1960-01-02'],
  <String>['005-002', '11', '2010-08-24', '2010-08-25', '1960-01-02'],
  <String>['005-002', '11', '2010-08-24', '2010-10-01', '1960-02-08'],
  <String>['005-002', '11', '2010-08-24', '2010-10-01', '1960-02-08'],
  <String>['005-004', '59', '2011-10-05', '2011-10-05', '1960-01-01'],
  <String>['005-005', '86', '2012-07-11', '2012-07-11', '1960-01-01'],
  <String>['005-005', '86', '2012-07-11', '2012-07-20', '1960-01-10'],
  <String>['005-005', '86', '2012-07-11', '2012-11-21', '1960-05-13'],
  <String>['006_001', '67', '2011-12-13', '2011-12-23', '1960-01-11'],
  <String>['006-001', '67', '2011-12-13', '2011-12-13', '1960-01-01'],
  <String>['007-001', '17', '2010-10-01', '2011-03-22', '1960-06-21'],
  <String>['007-001', '17', '2010-10-01', '2010-10-05', '1960-01-05'],
  <String>['007-001', '17', '2010-10-01', '2010-10-13', '1960-01-13'],
  <String>['007-002', '35', '2011-04-11', '2011-04-22', '1960-01-12'],
  <String>['007-002', '35', '2011-04-11', '2011-04-11', '1960-01-01'],
  <String>['007-002', '35', '2011-04-11', '2011-10-25', '1960-07-16'],
  <String>['008-001', '12', '2010-08-12', '2010-08-12', '1960-01-01'],
  <String>['008-001', '12', '2010-08-12', '2010-08-26', '1960-01-15'],
  <String>['008-001', '12', '2010-08-12', '2011-01-17', '1960-06-07'],
  <String>['008-002', '13', '2010-08-27', '2010-08-27', '1960-01-01'],
  <String>['008-002', '13', '2010-08-27', '2010-09-07', '1960-01-12'],
  <String>['008-002', '13', '2010-08-27', '2010-12-21', '1960-04-26'],
  <String>['008-003', '15', '2010-09-15', '2010-09-16', '1960-01-02'],
  <String>['008-003', '15', '2010-09-15', '2010-09-30', '1960-01-16'],
  <String>['008-003', '15', '2010-09-15', '2010-12-28', '1960-04-14'],
  <String>['008-004', '16', '2010-09-21', '2010-09-21', '1960-01-01'],
  <String>['008-004', '16', '2010-09-21', '2010-10-21', '1960-01-31'],
  <String>['008-005', '24', '2010-10-11', '2010-10-11', '1960-01-01'],
  <String>['008-005', '24', '2010-10-11', '2010-10-28', '1960-01-18'],
  <String>['008-005', '24', '2010-10-11', '2011-03-08', '1960-05-28'],
  <String>['008-006', '25', '2010-10-21', '2010-10-21', '1960-01-01'],
  <String>['008-006', '25', '2010-10-21', '2010-11-18', '1960-01-29'],
  <String>['008-007', '20', '2010-10-25', '2010-10-25', '1960-01-01'],
  <String>['008-007', '20', '2010-10-25', '2010-11-15', '1960-01-22'],
  <String>['008-007', '20', '2010-10-25', '2011-03-31', '1960-06-06'],
  <String>['009-001', '90', '2012-08-21', '2012-08-22', '1960-01-02'],
  <String>['009-001', '90', '2012-08-21', '2012-08-22', '1960-01-02'],
  <String>['009-001', '90', '2012-08-21', '2012-08-29', '1960-01-09'],
  <String>['009-001', '90', '2012-08-21', '2013-02-25', '1960-07-07'],
  <String>['010-001', '28', '2011-01-21', '2011-01-21', '1960-01-01'],
  <String>['010-001', '28', '2011-01-21', '2011-01-21', '1960-01-01'],
  <String>['010-001', '28', '2011-01-21', '2011-02-03', '1960-01-14'],
  <String>['010-001', '28', '2011-01-21', '2011-02-03', '1960-01-14'],
  <String>['010-001', '28', '2011-01-21', '2011-05-16', '1960-04-25'],
  <String>['010-002', '29', '2011-02-10', '2011-02-10', '1960-01-01'],
  <String>['010-002', '29', '2011-02-10', '2011-02-25', '1960-01-16'],
  <String>['010-002', '29', '2011-02-10', '2011-02-25', '1960-01-16'],
  <String>['010-002', '29', '2011-02-10', '2011-07-25', '1960-06-14'],
  <String>['011-001', '51', '2011-08-23', '2011-08-25', '1960-01-03'],
  <String>['011-002', '53', '2011-09-06', '2011-09-06', '1960-01-01'],
  <String>['011-003', '54', '2011-09-16', '2011-09-20', '1960-01-05'],
  <String>['011-003', '54', '2011-09-16', '2011-10-11', '1960-01-26'],
  <String>['011-003', '54', '2011-09-16', '2012-02-02', '1960-05-19'],
  <String>['011-004', '60', '2011-10-07', '2011-10-27', '1960-01-21'],
  <String>['011-004', '60', '2011-10-07', '2012-03-23', '1960-06-17'],
  <String>['011-004', '60', '2011-10-07', '2011-10-07', '1960-01-01'],
  <String>['011-006', '58', '2011-10-03', '2011-10-12', '1960-01-10'],
  <String>['011-007', '62', '2011-11-07', '2011-11-14', '1960-01-08'],
  <String>['011-007', '62', '2011-11-07', '2011-11-21', '1960-01-15'],
  <String>['011-007', '62', '2011-11-07', '2012-06-04', '1960-07-29'],
  <String>['011-008', '63', '2011-11-15', '2011-11-15', '1960-01-01'],
  <String>['011-009', '72', '2011-12-29', '2012-01-05', '1960-01-08'],
  <String>['011-010', '76', '2012-02-13', '2012-02-13', '1960-01-01'],
  <String>['011-010', '76', '2012-02-13', '2012-02-29', '1960-01-17'],
  <String>['011-011', '79', '2012-02-21', '2012-02-21', '1960-01-01'],
  <String>['011-011', '79', '2012-02-21', '2012-04-05', '1960-02-14'],
  <String>['011-012', '83', '2012-03-26', '2012-03-26', '1960-01-01'],
  <String>['011-012', '83', '2012-03-26', '2012-04-04', '1960-01-10'],
  <String>['012-001', '41', '2011-05-18', '2011-05-13', '1959-12-27'],
  <String>['012-001', '41', '2011-05-18', '2011-05-20', '1960-01-03'],
  <String>['012-001', '41', '2011-05-18', '2011-06-09', '1960-01-23'],
  <String>['012-001', '41', '2011-05-18', '2011-09-16', '1960-05-01'],
  <String>['012-002', '43', '2011-05-25', '2011-05-25', '1960-01-01'],
  <String>['012-002', '43', '2011-05-25', '2011-05-12', '1959-12-19'],
  <String>['012-002', '43', '2011-05-25', '2011-06-03', '1960-01-10'],
  <String>['012-003', '48', '2011-06-30', '2011-07-07', '1960-01-08'],
  <String>['012-003', '48', '2011-06-30', '2011-07-15', '1960-01-16'],
  <String>['012-003', '48', '2011-06-30', '2011-11-01', '1960-05-04'],
  <String>['014-001', '21', '2010-10-29', '2011-03-01', '1960-05-03'],
  <String>['014-001', '21', '2010-10-29', '2011-03-01', '1960-05-03'],
  <String>['014-001', '21', '2010-10-29', '2010-11-15', '1960-01-18'],
  <String>['014-001', '21', '2010-10-29', '2010-11-15', '1960-01-18'],
  <String>['014-001', '21', '2010-10-29', '2010-11-04', '1960-01-07'],
  <String>['014-001', '21', '2010-10-29', '2010-11-04', '1960-01-07'],
  <String>['014-001', '21', '2010-10-29', '2010-11-04', '1960-01-07'],
  <String>['014-001', '21', '2010-10-29', '2010-11-04', '1960-01-07'],
  <String>['014-001', '21', '2010-10-29', '2010-11-15', '1960-01-18'],
  <String>['014-001', '21', '2010-10-29', '2010-11-15', '1960-01-18'],
  <String>['014-001', '21', '2010-10-29', '2011-03-01', '1960-05-03'],
  <String>['014-001', '21', '2010-10-29', '2011-03-01', '1960-05-03'],
  <String>['014-002', '26', '2011-01-04', '2011-01-18', '1960-01-15'],
  <String>['014-002', '26', '2011-01-04', '2011-01-04', '1960-01-01'],
  <String>['014-002', '26', '2011-01-04', '2011-01-18', '1960-01-15'],
  <String>['014-002', '26', '2011-01-04', '2011-01-04', '1960-01-01'],
  <String>['014-003', '37', '2011-04-18', '2011-04-18', '1960-01-01'],
  <String>['014-003', '37', '2011-04-18', '2011-05-02', '1960-01-15'],
  <String>['016-001', '34', '2011-03-31', '2011-04-08', '1960-01-09'],
  <String>['016-001', '34', '2011-03-31', '2011-04-08', '1960-01-09'],
  <String>['016-001', '34', '2011-03-31', '2011-03-31', '1960-01-01'],
  <String>['016-001', '34', '2011-03-31', '2011-03-31', '1960-01-01'],
  <String>['016-001', '34', '2011-03-31', '2011-07-29', '1960-04-30'],
  <String>['016-001', '34', '2011-03-31', '2011-07-29', '1960-04-30'],
  <String>['016-002', '36', '2011-04-11', '2011-04-11', '1960-01-01'],
  <String>['016-002', '36', '2011-04-11', '2011-04-11', '1960-01-01'],
  <String>['016-002', '36', '2011-04-11', '2011-09-15', '1960-06-06'],
  <String>['016-002', '36', '2011-04-11', '2011-09-15', '1960-06-06'],
  <String>['016-002', '36', '2011-04-11', '2011-04-22', '1960-01-12'],
  <String>['016-002', '36', '2011-04-11', '2011-04-22', '1960-01-12'],
  <String>['017-001', '27', '2011-01-18', '2011-01-26', '1960-01-09'],
  <String>['017-001', '27', '2011-01-18', '2011-01-19', '1960-01-02'],
  <String>['017-001', '27', '2011-01-18', '2011-05-18', '1960-04-30'],
  <String>['017-002', '64', '2011-11-28', '2011-12-13', '1960-01-16'],
  <String>['017-002', '64', '2011-11-28', '2011-11-30', '1960-01-03'],
  <String>['017-002', '64', '2011-11-28', '2012-04-09', '1960-05-13'],
  <String>['017-003', '66', '2011-12-09', '2011-12-29', '1960-01-21'],
  <String>['017-003', '66', '2011-12-09', '2011-12-14', '1960-01-06'],
  <String>['017-003', '66', '2011-12-09', '2012-05-09', '1960-06-01'],
  <String>['017-004', '82', '2012-04-03', '2012-04-16', '1960-01-14'],
  <String>['017-004', '82', '2012-04-03', '2012-06-05', '1960-03-04'],
  <String>['017-004', '82', '2012-04-03', '2012-04-05', '1960-01-03'],
  <String>['018-001', '47', '2011-06-24', '2011-06-27', '1960-01-04'],
  <String>['018-002', '57', '2011-10-03', '2011-10-06', '1960-01-04'],
  <String>['018-002', '57', '2011-10-03', '2011-10-26', '1960-01-24'],
  <String>['018-002', '57', '2011-10-03', '2011-10-26', '1960-01-24'],
  <String>['018-002', '57', '2011-10-03', '2011-10-06', '1960-01-04'],
  <String>['018-002', '57', '2011-10-03', '2012-03-08', '1960-06-06'],
  <String>['018-002', '57', '2011-10-03', '2012-03-08', '1960-06-06'],
  <String>['018-003', '61', '2011-11-03', '2011-11-04', '1960-01-02'],
  <String>['018-003', '61', '2011-11-03', '2011-11-04', '1960-01-02'],
  <String>['018-003', '61', '2011-11-03', '2011-11-15', '1960-01-13'],
  <String>['018-003', '61', '2011-11-03', '2011-11-15', '1960-01-13'],
  <String>['018-003', '61', '2011-11-03', '2012-03-15', '1960-05-13'],
  <String>['018-003', '61', '2011-11-03', '2012-03-15', '1960-05-13'],
  <String>['018-005', '69', '2011-12-16', '2011-12-16', '1960-01-01'],
  <String>['018-005', '69', '2011-12-16', '2011-12-16', '1960-01-01'],
  <String>['018-005', '69', '2011-12-16', '2011-12-30', '1960-01-15'],
  <String>['018-005', '69', '2011-12-16', '2011-12-30', '1960-01-15'],
  <String>['018-005', '69', '2011-12-16', '2012-08-02', '1960-08-18'],
  <String>['018-005', '69', '2011-12-16', '2012-08-02', '1960-08-18'],
  <String>['018-006', '75', '2012-02-07', '2012-02-08', '1960-01-02'],
  <String>['018-006', '75', '2012-02-07', '2012-02-08', '1960-01-02'],
  <String>['018-006', '75', '2012-02-07', '2012-02-17', '1960-01-11'],
  <String>['018-006', '75', '2012-02-07', '2012-02-17', '1960-01-11'],
  <String>['018-006', '75', '2012-02-07', '2012-07-30', '1960-06-23'],
  <String>['018-006', '75', '2012-02-07', '2012-07-30', '1960-06-23'],
  <String>['018-007', '81', '2012-03-30', '2012-04-02', '1960-01-04'],
  <String>['018-007', '81', '2012-03-30', '2012-04-02', '1960-01-04'],
  <String>['018-008', '85', '2012-07-05', '2012-07-05', '1960-01-01'],
  <String>['018-008', '85', '2012-07-05', '2012-07-05', '1960-01-01'],
  <String>['018-008', '85', '2012-07-05', '2012-07-26', '1960-01-22'],
  <String>['018-008', '85', '2012-07-05', '2012-07-26', '1960-01-22'],
  <String>['018-008', '85', '2012-07-05', '2012-10-03', '1960-03-31'],
  <String>['018-008', '85', '2012-07-05', '2012-10-03', '1960-03-31'],
  <String>['018-009', '87', '2012-07-17', '2012-07-18', '1960-01-02'],
  <String>['018-009', '87', '2012-07-17', '2012-07-18', '1960-01-02'],
  <String>['018-009', '87', '2012-07-17', '2012-07-31', '1960-01-15'],
  <String>['018-009', '87', '2012-07-17', '2012-07-31', '1960-01-15'],
  <String>['018-009', '87', '2012-07-17', '2012-10-24', '1960-04-09'],
  <String>['018-009', '87', '2012-07-17', '2012-10-24', '1960-04-09'],
  <String>['018-010', '89', '2012-08-17', '2012-08-21', '1960-01-05'],
  <String>['018-010', '89', '2012-08-17', '2012-08-21', '1960-01-05'],
  <String>['018-010', '89', '2012-08-17', '2012-08-30', '1960-01-14'],
  <String>['018-010', '89', '2012-08-17', '2012-08-30', '1960-01-14'],
  <String>['018-010', '89', '2012-08-17', '2013-03-05', '1960-07-19'],
  <String>['018-010', '89', '2012-08-17', '2013-03-05', '1960-07-19'],
  <String>['021-001', '46', '2011-06-21', '2011-06-21', '1960-01-01'],
  <String>['021-001', '46', '2011-06-21', '2011-06-30', '1960-01-10'],
  <String>['021-001', '46', '2011-06-21', '2011-12-08', '1960-06-19'],
  <String>['021-002', '71', '2011-12-16', '2011-12-19', '1960-01-04'],
  <String>['021-002', '71', '2011-12-16', '2011-12-29', '1960-01-14'],
  <String>['021-002', '71', '2011-12-16', '2012-05-04', '1960-05-20'],
  <String>['021-003', '73', '2012-01-18', '2012-01-18', '1960-01-01'],
  <String>['021-003', '73', '2012-01-18', '2012-01-26', '1960-01-09'],
  <String>['021-003', '73', '2012-01-18', '2012-07-11', '1960-06-24']
];
