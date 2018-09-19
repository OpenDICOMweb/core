//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

/// The DICOM Information Entity Level for RootDatasets.
class IELevel {
  final int level;
  final String name;

  const IELevel(this.level, this.name);

  IELevel get parent => (level == 0) ? null : levels[level - 1];

  IELevel get child => (level == 5) ? null : levels[level + 1];

  String get info => '$this: parent($parent), child($child)';

  @override
  String toString() => '$runtimeType($level) $name';

  /// The Patient level.
  static const IELevel subject = const IELevel(0, 'Patient');

  /// The Study level.
  static const IELevel study = const IELevel(1, 'Study');

  /// The Series level.
  static const IELevel series = const IELevel(2, 'Series');

  /// The Instance level.
  static const IELevel instance = const IELevel(3, 'Instance');

  /// The RootDataset Level.  Note: this is currently not used
  static const IELevel dataset = const IELevel(4, 'RootDataset');

  /// The Item level.
  static const IELevel item = const IELevel(5, 'Item');

  static const List<IELevel> levels = const <IELevel>[
    subject, study, series, instance, dataset, item // No reindent
  ];
}
