// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

// Urgent: separate internal and public
// Urgent: how to lookup vm from fast_tag
// Urgent: sort order min then max then width
// Urgent: add lookup(int min, int max, int width;
// Urgent: add isPublic, isPrivate, isBoth

/// A class that defined Value Multiplicities and their validators.
///
/// The Value Multiplicity (VM) of an Attribute defines the minimum,
/// maximum and width of an array of values in an Attribute's Value Field.
class VM {
  /// The name of this [VM].
  final String keyword;

  /// THe minimum number of values that must be present, if any values
  /// are present. [min] [%] [columns] must equal 0.
  final int min;

  /// The maximum number of values that are allowed. [max] [%] [columns]
  /// must equal 0. If [max] is -1 than as many values as will fit in the
  /// Value Field are allowed.
  final int max;

  /// The [columns] of the array of values. Both [min] and [max] must be
  /// evenly divisible by [columns]. That is [min] % [columns] == [max] %
  /// [columns] == 0 must be _true_ .
  final int columns;

  /// Returns _true_  if this is a VM used only with internal Tags.
  final bool isPrivate;

  // Constructor
  const VM(this.keyword, this.min, this.max, this.columns, {this.isPrivate = false});

  String get id {
    final s = keyword.replaceAll('-', '_');
    return 'k$s';
  }

  bool get isFixed => min == max;

  bool get isSingleton => min == 1 && max == 1 && columns == 1;

  int getMax(int maxLength) {
    if (max != -1) return max;
    final excess = maxLength % columns;
    final actual = maxLength - excess;
    assert(actual % columns == 0);
    return actual;
  }

  bool isValidLength(int length, int maxLength) =>
      length >= min && length <= getMax(maxLength);

  bool isValid<T>(List<T> v, int maxLength) =>
		  v.length >= min && v.length <= getMax(maxLength);

  bool isNotValid<T>(List<T> v, int maxLength) => !isValid(v, maxLength);

  @override
  String toString() => 'VM.$keyword';

  // Members
  static const VM kUnknown = const VM('kUnknown', -1, -1, -1);
  static const VM kNoVM = const VM('kNoVM', 0, 0, 0);

  // **** Rank 1 ****
  static const VM k0_n = const VM('k0-n', 0, -1, 1, isPrivate: true);

  static const VM k1 = const VM('k1', 1, 1, 1);
  static const VM k1_2 = const VM('k1-2', 1, 2, 1);
  static const VM k1_3 = const VM('k1-3', 1, 3, 1);
  static const VM k1_8 = const VM('k1-8', 1, 8, 1);
  static const VM k1_16 = const VM('k1-16', 1, 16, 1, isPrivate: true);
  static const VM k1_32 = const VM('k1-32', 1, 32, 1);
  static const VM k1_99 = const VM('k1-99', 1, 99, 1);
  static const VM k1_143 = const VM('k1-143', 1, 143, 1, isPrivate: true);
  static const VM k1_256 = const VM('k1-256', 1, 256, 1, isPrivate: true);
  static const VM k1_n = const VM('k1-n', 1, -1, 1);

  static const VM k2 = const VM('k2', 2, 2, 1);
  static const VM k2_3 = const VM('k2-3', 2, 3, 1, isPrivate: true);
  static const VM k2_n = const VM('k2-n', 2, -1, 1);

  static const VM k3 = const VM('k3', 3, 3, 1);
  static const VM k3_n = const VM('k3-n', 3, -1, 1);

  static const VM k4 = const VM('k4', 4, 4, 1);
  static const VM k4_n = const VM('k4-n', 4, -1, 1, isPrivate: true);

  static const VM k5 = const VM('k5', 5, 5, 1, isPrivate: true);

  static const VM k6 = const VM('k6', 6, 6, 1);
  static const VM k6_n = const VM('k6-n', 6, -1, 1);

  static const VM k7 = const VM('k7', 7, 7, 1, isPrivate: true);
  static const VM k7_n = const VM('k7-n', 7, -1, 1, isPrivate: true);

  static const VM k8 = const VM('k8', 8, 8, 1, isPrivate: true);
  static const VM k9 = const VM('k9', 9, 9, 1);

  static const VM k12 = const VM('k12', 12, 12, 1, isPrivate: true);
  static const VM k12_n = const VM('k12-n', 12, -1, 1, isPrivate: true);

  static const VM k16 = const VM('k16', 16, 16, 1);
  static const VM k18 = const VM('k18', 18, 18, 1, isPrivate: true);
  static const VM k24 = const VM('k24', 24, 24, 1, isPrivate: true);
  static const VM k28 = const VM('k28', 28, 28, 1, isPrivate: true);
  static const VM k32 = const VM('k32', 32, 32, 1, isPrivate: true);
  static const VM k35 = const VM('k35', 35, 35, 1, isPrivate: true);
  static const VM k256 = const VM('k256', 256, 256, 1, isPrivate: true);

  //If valid they need special lookup table
  static const VM k40909 = const VM('k40909', 40909, 40909, 1, isPrivate: true);
  static const VM k40910 = const VM('k40910', 40910, 40910, 1, isPrivate: true);
  static const VM k40915 = const VM('k40915', 40915, 40915, 1, isPrivate: true);
  static const VM k40923 = const VM('k40923', 40923, 40923, 1, isPrivate: true);

  // **** Rank 2 ****
  static const VM k2_2n = const VM('k2-2n', 2, -1, 2);

  // **** Rank 3 ****
  static const VM k3_3n = const VM('k3-3n', 3, -1, 3);

  // **** Rank 4 ****
  static const VM k4_4n = const VM('k4-4n', 4, -1, 4, isPrivate: true);

  // **** Rank 6 ****
  static const VM k6_6n = const VM('k6-6n', 6, -1, 6, isPrivate: true);

  // **** Rank 30 ****
  static const VM k30_30n = const VM('k30-30n', 30, -1, 30, isPrivate: true);

  // **** Rank 47 ****
  static const VM k47_47n = const VM('k47-47n', 47, -1, 47, isPrivate: true);

  static VM lookup(int min, int max, int columns) {
    for (var i = 0; i < byIndex.length; i++) {
      final vm = byIndex[i];
      if (vm.min != min) continue;
      if (vm.max != max) continue;
      if (vm.columns != columns) continue;
      return vm;
    }
    return null;
  }

  // Lookup Map
  static const List<VM> byIndex = const [
    VM.k0_n,

    VM.k1,
    VM.k1_2,
    VM.k1_3,
    VM.k1_8,
    VM.k1_32,
    VM.k1_99,
    VM.k1_143,
    VM.k1_256,
    VM.k1_n,

    VM.k2,
    VM.k2_3,
    VM.k2_n,
    VM.k2_2n,

    VM.k3,
    VM.k3_n,
    VM.k3_3n,

    VM.k4,
    VM.k4_n,
    VM.k4_4n,

    VM.k5,

    VM.k6,
    VM.k6_n,
    VM.k6_6n,

    VM.k7,
    VM.k7_n,

    VM.k8,
    VM.k9,

    VM.k12,
    VM.k12_n,

    VM.k16,
    VM.k18,
    VM.k24,
    VM.k28,
    VM.k30_30n,
    VM.k32,
    VM.k35,
    VM.k47_47n,
    VM.k256,

    //???
    VM.k40909,
    VM.k40910,
    VM.k40915,
    VM.k40923,
  ];

  //TODO: add all internal definitions to this map
  // Lookup Map
  static const Map<String, VM> publicKeywordMap = const {
    'kNoVM': VM.kNoVM,
    'k1': VM.k1,
    'k1_2': VM.k1_2,
    'k1_3': VM.k1_3,
    'k1_8': VM.k1_8,
    'k1_32': VM.k1_32,
    'k1_99': VM.k1_99,
    'k1_n': VM.k1_n,
    'k2': VM.k2,
    'k2_n': VM.k2_n,
    'k2_2n': VM.k2_2n,
    'k3': VM.k3,
    'k3_n': VM.k3_n,
    'k3_3n': VM.k3_3n,
    'k4': VM.k4,
    'k6': VM.k6,
    'k6_n': VM.k6_n,
    'k9': VM.k9,
    'k16': VM.k16,
  };

  static const Map<String, VM> keywordMap = const {
    'kNoVM': VM.kNoVM,
    'k0_n': VM.k0_n,
    'k1': VM.k1,
    'k1_2': VM.k1_2,
    'k1_3': VM.k1_3,
    'k1_8': VM.k1_8,
    'k1_32': VM.k1_32,
    'k1_99': VM.k1_99,
    'k1_143': VM.k1_143,
    'k1_256': VM.k1_256,
    'k1_n': VM.k1_n,
    'k2': VM.k2,
    'k2_3': VM.k2_3,
    'k2_n': VM.k2_n,
    'k2_2n': VM.k2_2n,
    'k3': VM.k3,
    'k3_n': VM.k3_n,
    'k3_3n': VM.k3_3n,
    'k4': VM.k4,
    'k4_n': VM.k4_n,
    'k4_4n': VM.k4_4n,
    'k5': VM.k5,
    'k6': VM.k6,
    'k6_n': VM.k6_n,
    'k6_6n': VM.k6_6n,
    'k7': VM.k7,
    'k7_n': VM.k7_n,
    'k8': VM.k8,
    'k9': VM.k9,
    'k12': VM.k12,
    'k12_n': VM.k12_n,
    'k16': VM.k16,
    'k18': VM.k18,
    'k24': VM.k24,
    'k28': VM.k28,
    'k30_30n': VM.k30_30n,
    'k32': VM.k32,
    'k35': VM.k35,
    'k47_47': VM.k47_47n,
    'k256': VM.k256,
    'k40909': VM.k40909,
    'k40910': VM.k40910,
    'k40915': VM.k40915,
    'k40923': VM.k40923,
  };
/*
  //TODO: add all internal definitions to this map
  // Lookup Map
  static const Map<String, VMx> map = const {
    '1': VMx.k1,
    '1_2': VMx.k1_2,
    '1_32': VMx.k1_32,
    '1_99': VMx.k1_99,
    '16': VMx.k16,
    '1_n': VMx.k1_n,
    '2': VMx.k2,
    '2_2n': VMx.k2_2n,
    '2_n': VMx.k2_n,
    '3': VMx.k3,
    '3_3n': VMx.k3_3n,
    '3_n': VMx.k3_n,
    '4': VMx.k4,
    '6': VMx.k6,
    '6_n': VMx.k6_n,
    '9': VMx.k9
  };
*/

}
