//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

abstract class StackBase<E> {
  int get limit;
  final _stack = <E>[];

  // Example constructor
  // Stack([int limit = 100]);

  E get current => _stack.last;

  int get length => _stack.length;

  void push(E sq) {
    if (_stack.length > limit)
      throw const StackOverflowError();
    _stack.add(sq);
  }

  E pop() => _stack.removeLast();
}

class Stack extends StackBase<Object> {
  @override
  final int limit;

  Stack([this.limit = 100]);
}

