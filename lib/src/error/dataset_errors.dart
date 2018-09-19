//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/entity.dart';
import 'package:core/src/error/utils.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

Null badElementIndex(int index,
                     {Element e, bool required = false, Issues issues}) {
  final code = dcm(index);
  final msg = (required)
              ? 'InvalidRequiredElementIndex: $code'
              : 'InvalidElementIndex: $code';
  if (issues != null) issues.add(msg);
  return badElement(msg, e, issues);
}

bool invalidElementIndex(int index,
                         {Element e, bool required = false, Issues issues}) {
  badElementIndex(index, e: e, required: required, issues: issues);
  return false;
}

class InvalidValueFieldError extends Error {
  final String msg;
  final Bytes vfBytes;

  InvalidValueFieldError(this.msg, [this.vfBytes]);

  @override
  String toString() => msg;
}


/*
class RetainedElementError<K> extends Error {
  K key;
  String msg;

  RetainedElementError(this.key,
  [this.msg = 'Attempt to change a Retained Element']);

  @override
  String toString() => _msg(key, msg);

  static String _msg<K>(K key, String msg) =>
      'RetainedElementError: ${keyTypeString(key)}';
}

Null retainedElementError<K>(K key, [String msg]) {
  log.error(RetainedElementError._msg(key, msg));
  if (throwOnError) throw new RetainedElementError(key);
  return null;
}
*/

class DeletedElementError<K> extends Error {
  K key;

  DeletedElementError(this.key);

  @override
  String toString() => _msg(key);

  static String _msg<K>(K key) =>
      'Error: Invalid Attempt to add an Element that is on the Remove '
      'List: ${keyTypeString(key)}';
}

Null deletedElementError<K>(K key) {
  log.error(DeletedElementError._msg(key));
  if (throwOnError) throw new DeletedElementError(key);
  return null;
}

class ElementNotPresentError extends Error {
  Object key;

  ElementNotPresentError(this.key);

  @override
  String toString() => '${_msg(key)}';

  static String _msg<K>(K key) =>
      'Error: Element not present in Dataset: ${keyTypeString(key)}';
}

Null elementNotPresentError<K>(K key) {
  log.error(ElementNotPresentError._msg(key));
  if (throwOnError) throw new ElementNotPresentError(key);
  return null;
}

class DuplicateElementError extends Error {
  final Element oldE;
  final Element newE;

  DuplicateElementError(this.oldE, this.newE);

  @override
  String toString() => _msg(oldE, newE);

  static String _msg(Element oldE, Element newE) =>
      'DuplicateElementError:\n  old: $oldE\n  new: $newE';
}

Null duplicateElementError(Element oldE, Element newE) {
  log.error(DuplicateElementError._msg(oldE, newE));
  if (throwOnError) throw new DuplicateElementError(oldE, newE);
  return null;
}

/* Flush when working
class InvalidElementError extends Error {
  final Element e;

  InvalidElementError(this.e);

  @override
  String toString() => _msg(e);

  static String _msg(Element e) => (e == null)
      ? 'null'
      : 'InvalidElementError:\n'
      '\n  element: ${e.info}'
      '\n   values: ${e.values}';
}

Null invalidElementError<V>(Element e) {
  log.error(InvalidElementError._msg(e));
  if (throwOnError) throw new InvalidElementError(e);
  return null;
}
*/

class InvalidTransferSyntax extends Error {
  final TransferSyntax ts;
  final TransferSyntax target;

  InvalidTransferSyntax(this.ts, [this.target]);

  @override
  String toString() => _msg(ts, target);

  static String _msg(TransferSyntax ts, TransferSyntax target) {
    final s = (target == null) ? '' : '$target';
    return 'InvalidTransferSyntaxError($ts): Target($s)';
  }
}

Null invalidTransferSyntax(TransferSyntax ts, [TransferSyntax target]) {
  log.error(InvalidTransferSyntax._msg(ts, target));
  if (throwOnError) throw new InvalidTransferSyntax(ts, target);
  return null;
}

class DuplicateUidError extends Error {
  final Uid uid;

  DuplicateUidError(this.uid);

  @override
  String toString() => _msg(uid);

  static String _msg(Uid uid) => 'DuplicateUidError:\n  Uid: $uid';
}

Null duplicateUidError(Uid uid) {
  log.error(DuplicateUidError._msg(uid));
  if (throwOnError) throw new DuplicateUidError(uid);
  return null;
}

//Fix: The type bounds should be tighter than [Dataset].
class DuplicateItemError extends Error {
  final Dataset item;

  DuplicateItemError(this.item) {
    log.error(toString());
  }

  @override
  String toString() => _msg(item);

  static String _msg(Dataset item) => '$DuplicateItemError:\n  Item: $item';
}

Null duplicateItemError(Dataset item) {
  log.error(DuplicateItemError._msg(item));
  if (throwOnError) throw new DuplicateItemError(item);
  return null;
}

class DuplicateEntityError extends Error {
  final Entity oldE;
  final Entity newE;

  DuplicateEntityError(this.oldE, this.newE);

  @override
  String toString() => _msg(oldE, newE);

  static String _msg(Entity oldE, Entity newE) {
    final vOld = (oldE == null) ? 'null' : '$oldE';
    final vNew = (newE == null) ? 'null' : '$newE';
    return 'DuplicateEntityError:\n  old: $vOld\n  new: $vNew';
  }
}

Null duplicateEntityError(Entity oldE, Entity newE) {
  log.error(DuplicateEntityError._msg(oldE, newE));
  if (throwOnError) throw new DuplicateEntityError(oldE, newE);
  return null;
}

class MissingUidError<K> extends Error {
  final K key;

  MissingUidError(this.key);

  @override
  String toString() => _msg(key);

  static String _msg<K>(K key) {
    final s = (key is Tag) ? 'key: $key' : 'Tag: ${Tag.lookup(key)}';
    return 'MissingUidError: $s';
  }
}

Null missingUidError<K>(K key) {
  log.error(MissingUidError._msg(key));
  if (throwOnError) throw new MissingUidError(key);
  return null;
}

class MissingElementError<K> extends Error {
  final K key;
  final String msg;

  MissingElementError(this.key, this.msg);

  @override
  String toString() => msg;
}

Null missingRequiredElement<K>(K key, {bool wasRequired = false}) {
  final msg =
      (wasRequired) ? 'MissingRequiredElementError: $key' : 'MissingElementError: $key';
  log.error(msg);
  if (throwOnError) throw new MissingElementError(key, msg);
  return null;
}

class MissingRequiredValuesError extends Error {
  final Element e;

  MissingRequiredValuesError(this.e);

  @override
  String toString() => _msg(e);

  static String _msg(Element e) => 'MissingRequiredValuesError: $e';
}

Null missingRequiredValuesError(Element e) {
  log.error(MissingRequiredValuesError._msg(e));
  if (throwOnError) throw new MissingRequiredValuesError(e);
  return null;
}

class PixelDataNotPresent extends Error {
  final String msg;

  PixelDataNotPresent([this.msg]);

  @override
  String toString() => _msg(msg);

  static String _msg(String msg) => 'PixelDataNotPresent: $msg';
}

Null pixelDataNotPresent([String msg]) {
  log.error(PixelDataNotPresent._msg(msg));
  if (throwOnError) throw new PixelDataNotPresent(msg);
  return null;
}
