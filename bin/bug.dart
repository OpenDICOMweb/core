void main() {
  foo(0, 5);
}

int foo(int start, int end, [int x = 0]) {
  var s = 0, index = start;
  if ((index += 2) < end) {
    if ((index += 2) < end) {  // Info here
      if (x == null) s = 1;
    }
  }
  return s;
}

// info: Conditions should not unconditionally evaluate to `true` or to `false`.
// verify: (index += 2) < end. (invariant_booleans at [core] bin\bug.dart:15)
