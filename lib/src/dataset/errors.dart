// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/entity/entity.dart';
import 'package:core/src/string/dicom_string.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/tag/tag_lib.dart';
import 'package:core/src/uid/uid.dart';
import 'package:core/src/uid/well_known/transfer_syntax.dart';

/*
/// Read Error
class ReadError extends Error {
  final String msg;

  ReadError(this.msg);

  @override
  String toString() => _msg(msg);

  static String _msg(String msg) => 'ReadError: $msg';
}

/// Read Error
Null readError(String msg) {
  log.error(ReadError._msg(msg));
  if (throwOnError) throw new ReadError(msg);
  return null;
}
*/

String _toMsgString<K>(K key) {
  if (key is int) {
    return 'Code ${dcm(key)}';
  } else if (key is String) {
    return 'Keyword "$key"';
  } else if (key is Tag) {
    return '$key';
  }
  return 'Error: bad Tag($key) in _toMsgString($key)';
}

class InvalidKeyError<K> extends Error {
  K key;
  String msg;

  InvalidKeyError(this.key, [this.msg]);

  @override
  String toString() => (msg == null) ? 'InvalidKeyError: ${_toMsgString(key)}' : msg;
}

Null invalidKey<K>(K key, [String msg]) {
  final msg = 'InvalidKeyError: ${_toMsgString(key)}';
  log.error(msg);
  if (throwOnError) throw new InvalidKeyError(key);
  return null;
}

class InvalidElementTypeError<V> extends Error {
	Element e;
	String msg;

	InvalidElementTypeError(this.e, [this.msg]);

	@override
	String toString() =>  msg;
}

Null invalidElementType(Element e, [String msg]) {
	log.error(msg);
	if (throwOnError) throw new InvalidElementTypeError<int>(e, msg);
	return null;
}
Null invalidIntElement(Element e) {
	final msg = 'Invalid Integer Element: $e';
	return invalidElementType(e, msg);

}

Null invalidFloatElement(Element e) {
	final msg = 'Invalid Floating Point Element: $e';
	return invalidElementType(e, msg);
}

Null invalidStringElement(Element e) {
	final msg = 'Invalid String Element: $e';
	return invalidElementType(e, msg);
}

Null invalidSequenceElement(Element e) {
	final msg = 'Invalid Floating Point Element: $e';
	return invalidElementType(e, msg);
}

Null invalidUidElement(Element e) {
	final msg = 'Invalid UI (uid) Element: $e';
	return invalidElementType(e, msg);
}


/*
class RetainedElementError<K> extends Error {
  K key;
  String msg;

  RetainedElementError(this.key, [this.msg = 'Attempt to change a Retained Element']);

  @override
  String toString() => _msg(key, msg);

  static String _msg<K>(K key, String msg) =>
      'RetainedElementError: ${_toMsgString(key)}';
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
      'List: ${_toMsgString(key)}';
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
      'Error: Element not present in Dataset: ${_toMsgString(key)}';
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
