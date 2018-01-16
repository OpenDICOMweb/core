// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

// Urgent Sharath: please fix these tests
void main() {
  Server.initialize(name: 'replace_uids', level: Level.info);

	group('', (){
		test('updateUid', () {
			//Begin: Test for updateUid on Elements with VM.k1
      system.throwOnError = false;
			final ui0 = new UItag(PTag.kStudyInstanceUID, null);
			log.debug('ui0: $ui0');
			expect(ui0, isNull);

			system.throwOnError = true;
			expect(new UItag(PTag.kStudyInstanceUID, null),
             throwsA(const isInstanceOf<InvalidValuesError>()));

/* Urgent Sharath: fix or flush
			expect(ui0 is UI, true);
			expect(ui0.values.length, equals(0));
			expect(ui0.value, null);
			log.debug('ui0: $ui0');
*/

			final rootDS0 = new TagRootDataset();

			// Test for element not present with system.throwOnError
			system.throwOnError = true;
			expect(() => rootDS0.updateUid(ui0.tag.index, null, required: true),
					       throwsA(const isInstanceOf<NullValueError>()));
			expect(() => rootDS0.updateUid(ui0.tag.index, <Uid>[], required: true),
					       throwsA(const isInstanceOf<ElementNotPresentError>()));
			expect(() => rootDS0.update(ui0.tag.index, ['1.804.35.0.89'], required: true),
					       throwsA(const isInstanceOf<ElementNotPresentError>()));

			// Test for element not present without system.throwOnError
			system.throwOnError = false;
			expect(rootDS0.updateUid(ui0.tag.index, null, required: false), isNull);
			expect(rootDS0.update(ui0.tag.index, <String>[], required: false), isNull);
			expect(rootDS0.update(ui0.tag.index, ['1.804.35.0.89'], required: false), isNull);

			// Test for empty list
			final uidList0 = <String>[];
			final ui1 = new UItag(PTag.kStudyInstanceUID, uidList0);
			rootDS0.add(ui1);
			expect(ui1.values, equals(uidList0));
			final ui1r = rootDS0.update(ui1.tag.index, uidList0, required: true);
			log.debug('ui1r: $ui1r');
			expect(ui1r != null, true);
			expect(ui1r.values, equals(uidList0));
			expect(ui1r.value, null);

			// Test for non empty list
			final ui2 = new UItag(PTag.kStudyInstanceUID, ['2.16.840.1.113662.2.1.1519.11582']);
			final rootDS2 = new TagRootDataset()..add(ui2);
			log.debug('ui2: $ui2');
			final uidList1 = ['1.2.840.10008.5.1.1.16.376'];
			final v = Uid.isValidStringList(uidList1);
			log.debug('$uidList1 isValid: $v');
			final ui2r = rootDS2.update(ui2.tag.index, uidList1);
			log.debug('ui2r: $ui2r');
			expect(ui2r is UI, isTrue);
			expect(ui2r.values == uidList1, true);
			expect(ui2r.value == '1.2.840.10008.5.1.1.16.376', true);

			final uidList2 = ['1.2.840.10008.3.1.2.5.4'];
			final ui3 = new UItag(PTag.kSeriesInstanceUID, uidList2);
			final rootDS3 = new TagRootDataset()..add(ui3);
			final uidList2r = ['1.2.840.10008.1.4.1.13'];
			expect(Uid.isValidStringList(uidList2r), true);
			final ui3r = rootDS3.update(ui3.tag.index, uidList2r);
			expect(ui3r is UI, true);
			expect(ui3r.values, equals(uidList2r));
			expect(ui3r.value == '1.2.840.10008.1.4.1.13', true);

			final rootDS4 = new TagRootDataset();
			final uidList3 = ['2.16.840.1.113662.2.1.1519.11582'];
			final ui4 = new UItag(PTag.kStudyInstanceUID, uidList3);
			rootDS4.add(ui4);
			final uidList3r = ['1.2.840.10008.5.1.1.17'];
			expect(Uid.isValidStringList(uidList3r), true);
			final ui4r = rootDS4.update(ui4.tag.index, uidList3r);
			expect(ui4r is UI, true);
			expect(ui4r.values, equals(uidList3r));
			expect(ui4r.value, equals('1.2.840.10008.5.1.1.17'));

			//Passing values greater than valid VM
			system.throwOnError = false;
			final ui4r1 = rootDS4.update(
					ui4.tag.index, ['1.2.840.10008.5.1.4.1.1.1', '1.2.840.10008.5.1.4.1.1.5']);
			log.debug('ui4r1:$ui4r1');
			expect(ui4r1, isNull);

			// Check trying to updateUid with non-UI element
			final ob0 = new OBtag(PTag.kPrivateInformation, <int>[], 0);
			rootDS0.add(ob0);
			final ob0r = rootDS0.updateUid(ob0.tag.index, null);
			log.debug('ob0R:$ob0r');
			expect(ob0r, isNull);

			//Testing noValue on RootDatasetTag
			final rootDSNV = new TagRootDataset();
			final uidListNV = ['2.16.840.1.113662.2.1.1519.11582'];
			final uiNV = new UItag(PTag.kStudyInstanceUID, uidListNV);
			rootDSNV.add(uiNV);

			var old = rootDSNV.noValues(uiNV.code);
			expect(old, equals(uiNV));
			final nv = rootDSNV[kStudyInstanceUID];
			log.debug('ui1NoValue:$nv');
			expect(nv.value, null);

			final uiValues3 = rootDSNV.updateUid(uiNV.tag.index, []);
			expect(uiValues3.values, equals(<String>[]));
			//End: Elements with VM.k1

			//Begin: Test for updateUid on Elements with VM.k1_n
			final rootDS5 = new TagRootDataset();
			var ui5 = new UItag(PTag.kReferencedRelatedGeneralSOPClassUIDInFile, null);
			expect(ui5 is UI, true);
			expect(ui5.hasValidValues, true);
			expect(ui5.values.length, equals(0));
			log.debug('ui4:$ui5');

			// Test for element not present with system.throwOnError
			system.throwOnError = true;
			expect(() => rootDS5.updateUid(ui5.tag.index, null, required: true),
					       throwsA(const isInstanceOf<NullValueError>()));
			expect(() => rootDS5.update(ui5.tag.index, <String>[], required: true),
					       throwsA(const isInstanceOf<ElementNotPresentError>()));
			expect(
							() => rootDS5.update(
							ui5.tag.index, ['1.804.35.0.89', '1.2.840.10008.1.2.​4.​57'],
							required: true),
					throwsA(const isInstanceOf<InvalidTagValuesError>()));

			// Test for element not present  without system.throwOnError
			system.throwOnError = false;
			expect(rootDS5.updateUid(ui5.tag.index, null), isNull);
			expect(rootDS5.update(ui5.tag.index, <String>[]), isNull);
			expect(rootDS5.update(ui5.tag.index, ['1.804.35.0.89', '1.2.840.10008.1.2.​4.​57']),
					       isNull);

			// Test for empty list
			final uidListEmpty = <String>[];
			ui5 = new UItag(PTag.kReferencedRelatedGeneralSOPClassUIDInFile, uidListEmpty);
			rootDS5.add(ui5);
			expect(ui5.values, equals(uidListEmpty));
			final ui5Empty = rootDS5.update(ui5.tag.index, uidListEmpty);
			expect(ui5Empty != null, true);
			expect(ui5Empty.values, equals(uidListEmpty));
			expect(ui5Empty.value, null);

			//Test for valid list values
			final ui6 = new UItag(PTag.kReferencedRelatedGeneralSOPClassUIDInFile,
					                      ['1.2.840.10008.1.2.1', '1.2.840.10008.5.1.1.9']);
			final rootDS6 = new TagRootDataset()..add(ui6);
			log.debug('ui6: $ui6');
			final uidList4 = ['1.2.840.10008.5.1.4.1.1.30', '1.2.840.10008.5.1.4.1.1.77.5.4'];
			expect(Uid.isValidStringList(uidList4), true);
			final ui6r = rootDS6.update(ui6.tag.index, uidList4);
			log.debug('ui6r: $ui6r');
			expect(ui6r is UI, isTrue);
			expect(ui6r.values == uidList4, true);
			expect(ui6r.value == '1.2.840.10008.5.1.4.1.1.30', true);

			final uidList5 = ['1.2.840.10008.1.2.4.51', '1.2.840.10008.1.2.4.100'];
			final ui7 = new UItag(PTag.kReferencedRelatedGeneralSOPClassUIDInFile, uidList5);
			final rootDS7 = new TagRootDataset()..add(ui7);
			final uidList5r = ['1.2.840.10008.1.2.6.2', '1.2.840.10008.1.4.1.9'];
			expect(Uid.isValidStringList(uidList5r), true);
			final ui7r = rootDS7.update(ui7.tag.index, uidList5r);
			expect(ui7r is UI, true);
			expect(ui7r.values, equals(uidList5r));

			final rootDS8 = new TagRootDataset();
			final uidList6 = ['1.2.840.10008.5.1.1.40.1', '1.2.840.10008.5.1.4.1.1.1'];
			final ui8 = new UItag(PTag.kReferencedRelatedGeneralSOPClassUIDInFile, uidList6);
			rootDS8.add(ui8);
			final uidList6r = ['1.2.840.10008.5.1.4.1.1.1', '1.2.840.10008.5.1.4.1.1.5'];
			expect(Uid.isValidStringList(uidList6r), true);
			final ui8r = rootDS8.update(ui8.tag.index, uidList6r);
			expect(ui8r is UI, true);
			expect(ui8r.values, equals(uidList6r));
			expect(ui8r.value, equals('1.2.840.10008.5.1.4.1.1.1'));

			final rootDS9 = new TagRootDataset();
			final uidList7 = ['1.2.840.10008.5.1.1.40.1', '1.2.840.10008.5.1.4.1.1.1'];
			final ui9 = new UItag(PTag.kRelatedGeneralSOPClassUID, uidList7);
			rootDS9.add(ui9);
			final uidList7r = ['1.2.840.10008.5.1.4.1.1.1', '1.2.840.10008.5.1.4.1.1.5'];
			expect(Uid.isValidStringList(uidList7r), true);
			final ui9r = rootDS9.update(ui9.tag.index, uidList7r);
			expect(ui9r is UI, true);
			expect(ui9r.values, equals(uidList7r));
			expect(ui9r.value, equals('1.2.840.10008.5.1.4.1.1.1'));

			//Testing noValue on RootDatasetTag
			final rootDSNV1 = new TagRootDataset();
			final uidListNV1 = ['1.2.840.10008.5.1.4.1.1.1', '1.2.840.10008.5.1.4.1.1.5'];
			final uiNV1 = new UItag(PTag.kRelatedGeneralSOPClassUID, uidListNV1);
			rootDSNV1.add(uiNV1);
			old = rootDSNV1.noValues(uiNV1.code);
			expect(old, equals(uiNV1));
			final uiNoValue4 = rootDSNV1[kRelatedGeneralSOPClassUID];
			log.debug('uiNoValue4:$uiNoValue4');
			expect(uiNoValue4.value, null);

			final uiValues5 = rootDSNV1.update(uiNV1.tag.index, <String>[]);
			expect(uiValues5.values, equals(<String>[]));
			//End: Elements with VM.k1_n

			// Applying noValues on UI Element and adding the result element to
			// RootDatasetTag
			final rootDS10 = new TagRootDataset();
			final uidList9 = <String>['1.2.840.10008.5.1.1.40.1', '1.2.840.10008.5.1.4.1.1.1'];
			final ui11 = new UItag(PTag.kRelatedGeneralSOPClassUID, uidList9);
			log.debug('ui11: $ui11');
			final ui11NV = ui11.noValues;
			log.debug('ui11NV: $ui11NV');

			rootDS10.add(ui11NV);
			final ui11NVR = rootDS10.update(ui11NV.tag.index, uidList9);
			expect(ui11NVR is UI, true);
			expect(ui11NVR.values, equals(uidList9));
			expect(ui11NVR.value, equals('1.2.840.10008.5.1.1.40.1'));
		});

	});

}