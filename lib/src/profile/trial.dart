//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

//Questions:
// 1. where does case number go?

//TODO create a JSON representation of these objects
class Trial {
  int id; // Like Trial Number
  String name;

  /// A [Uri] containing the URL of the Trial Server.
  final Uri trialUrl;

  /// A [Uri] containing the URL of the Quarantine Server.
  final String quarantineUrl;

//  Profile profile;
  List<int> retainTags = [];
  Map<String, String> parameters;

  Trial(this.id, this.name, this.trialUrl, this.quarantineUrl, this.parameters);

  // Subject Level
  String get sponsor => parameters['SPONSOR'];
  String get protocolID => parameters['ProtocolID'];
  String get protocolDescription => parameters['ProtocolDescription'];
  String get siteId => parameters['SITEID'];
  String get siteName => parameters['SITENAME'];
  String get subjectID => parameters['SUBJECTID'];
  String get subjectReadingID => parameters['SUBJECTREADINGID'];
  String get protocolEthicsCommitteeName =>
      parameters['ProtocolEthicsCommitteeName'];
  String get protocolEthicsCommitteeApprovalNumber =>
      parameters['ProtocolEthicsCommitteeApprovalNumber'];

  // Study Level
  String get timePointId => parameters['TimePointID'];
  String get timePointDescription => parameters['TimePointDescription'];
  String get distributionType => parameters['DistributionType'];
  String get consentForDistributionFlag =>
      parameters['ConsentForDistributionFlag'];

  // Series Level
  String get coordinatingCenterName => parameters['CoordinatingCenterName'];
  String get seriesID => parameters['SeriesID'];
  String get seriesDescription => parameters['SeriesDescription'];

  // ACR specific - what are these used for;
  String get prefix => parameters['PREFIX'];
  String get suffix => parameters['SUFFIX'];
  String get uidRoot => parameters['UIDROOT'];
  String get dateInc => parameters['DATEINC'];
  String get key => parameters['KEY'];

  String get projectNo => parameters['ProjectNo'];
  String get projectName => parameters['ProjectName'];
  String get trialNo => parameters['TrialNo'];
  String get trialName => parameters['TrialName'];
  String get groupNo => parameters['GroupNo'];
  String get groupName => parameters['GroupName'];
  String get caseNo => parameters['CaseNo'];
  String get submissionType => parameters['SubmissionType'];

  String lookup(String name) {
    final value = parameters[name];
    if (value != null) return value;
    //return profile.parameters[name];
    return null;
  }

}

class Site {
  final String id;
  final String name;

  Site(this.id, this.name);
}

class TrialGroup {
  final String id;
  final String name;

  TrialGroup(this.id, this.name);
}

class Project {
  final int id;
  final String name;

  Project(this.id, this.name);
}

//TODO: what are submission types
enum SubmissionType { one, two, three }

class Submission {
  final SubmissionType type;
  final String timePointId;
  final String timePointDescription;

  Submission(this.type, this.timePointId, this.timePointDescription);
}
