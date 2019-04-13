// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//

/// Return the width in characters of [n].
int getIntWidth(int n) => '$n'.length;

/// Returns a [String] containing containing [n] left padded to [width]
/// characters with [padChar], which defaults to 0.
String getPaddedInt(int n, int width, [String padChar = '0']) =>
    (n == null) ? '' : '${"$n".padLeft(width, padChar)}';
