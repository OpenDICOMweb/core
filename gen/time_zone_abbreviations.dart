//  Copyright (c) '201'6, '201'7, '201'8,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

const String clsHeader = '''
class TimeZoneName {
  final String name;
  final String abbr;
  final Duration offset;
  
  TimeZoneName(this.name, this.abbr, this.offset);
  
  ''';

void main() {

  final map = StringBuffer('Map<String, Duration> map = {\n');
  final cls = StringBuffer(clsHeader);

  for (var e in tz) {
    map.writeln('  ${e[0]}: TimeZoneName.${e[0]}');
    final duration = timeZoneOffsetToDuration(offset);
    cls.writeln('static const ${e[0]} = TimeZoneName(\'${e[1]}\', \'${e[0]}',
        ${Duration(hours: hours, minutes: minutes)});');
  }

  map.writeln('};');
  cls.writeln('}');

  print(map);
  print(cls);

}

int getHours(String offset) {
  final first = (offset[0] == '+') ? 1 : 0;
  return int.parse(offset.substring(first, 2));
}

int getMinutes(String offset) {
  if (offset.length == 3) return 0;
  if (offset.length == 6) return int.parse()
  final first = (offset[0] == '+') ? 1 : 0;
  final hours = int.parse(offset.substring(first, 2));
  final minutes = (offset.length == 6) ? int.parse(offset.substring(4, 6)) : 0;
  return Duration(hours: hours, minutes: minutes).inMinutes;
}
// Abbr.	Name	 offset
const List<List<String>> tz = [
  ['ACDT', 'Australian Central Daylight Savings Time', '+10:30'],
  ['ACST', 'Australian Central Standard Time', '+09:30'],
  ['ACT', 'Acre Time', '−05'],
//ACT	ASEAN Common Time	'+06:30' – '+09'],
  [
    'ACWST',
    'Australian Central Western Standard Time (unofficial)',
    '+08:45'
  ],
  ['ADT', 'Atlantic Daylight Time', '−03'],
  ['AEDT', 'Australian Eastern Daylight Savings Time', '+11'],
  ['AEST', 'Australian Eastern Standard Time', '+10'],
  ['AFT', 'Afghanistan Time', '+04:30'],
  ['AKDT', 'Alaska Daylight Time', '−08'],
  ['AKST', 'Alaska Standard Time', '−09'],
  ['AMST', 'Amazon Summer Time(Brazil)[1]', '−03'],
  ['AMT', 'Amazon Time(Brazil)[2]', '−04'],
  ['AMT', 'Armenia Time', '+04'],
  ['ART', 'Argentina Time', '−03'],
  ['AST', 'Arabia Standard Time', '+03'],
  ['AST', 'Atlantic Standard Time', '−04'],
  ['AWST', 'Australian Western Standard Time', '+08'],
  ['AZOST', 'Azores Summer Time', '±00'],
  ['AZOT', 'Azores Standard Time', '−01'],
  ['AZT', 'Azerbaijan Time', '+04'],
  ['BDT', 'Brunei Time', '+08'],
  ['BIOT', 'British Indian Ocean Time', '+06'],
  ['BIT', 'Baker Island Time', '−12'],
  ['BOT', 'Bolivia Time', '−04'],
  ['BRST', 'Brasília Summer Time', '−02'],
  ['BRT', 'Brasilia Time', '−03'],
  ['BST', 'Bangladesh Standard Time', '+06'],
  ['BST', 'Bougainville Standard Time[3]', '+11'],
  [
    'BST',
    'British Summer Time (British Standard Time from Feb 1968 to Oct 1971)',
    '+01'
  ],
  ['BTT', 'Bhutan Time', '+06'],
  ['CAT', 'Central Africa Time', '+02'],
  ['CCT', 'Cocos Islands Time', '+06:30'],
  ['CDT', 'Central Daylight Time (North America)', '−05'],
  ['CDT', 'Cuba Daylight Time [4]', '−04'],
  ['CEST', 'Central European Summer Time (Cf. HAEC)', '+02'],
  ['CET', 'Central European Time', '+01'],
  ['CHADT', 'Chatham Daylight Time', '+13:45'],
  ['CHAST', 'Chatham Standard Time', '+12:45'],
  ['CHOT', 'Choibalsan Standard Time', '+08'],
  ['CHOST', 'Choibalsan Summer Time', '+09'],
  ['CHST', 'Chamorro Standard Time', '+10'],
  ['CHUT', 'Chuuk Time', '+10'],
  ['CIST', 'Clipperton Island Standard Time', '−08'],
  ['CIT', 'Central Indonesia Time', '+08'],
  ['CKT', 'Cook Island Time', '−10'],
  ['CLST', 'Chile Summer Time', '−03'],
  ['CLT', 'Chile Standard Time', '−04'],
  ['COST', 'Colombia Summer Time', '−04'],
  ['COT', 'Colombia Time', '−05'],
  ['CST', 'Central Standard Time (North America)', '−06'],
  ['CST', 'China Standard Time', '+08'],
  ['CST', 'Cuba Standard Time', '−05'],
  ['CT', 'China Time', '+08'],
  ['CVT', 'Cape Verde Time', '−01'],
  [
    'CWST',
    'Central Western Standard Time (Australia) unofficial',
    '+08:45'
  ],
  ['CXT', 'Christmas Island Time', '+07'],
  ['DAVT', 'Davis Time', '+07'],
  ['DDUT', 'Dumont d\'Urville Time', '+10'],
  [
    'DFT',
    'AIX-specific equivalent of Central European Time[NB 1]',
    '+01'
  ],
  ['EASST', 'Easter Island Summer Time', '−05'],
  ['EAST', 'Easter Island Standard Time', '−06'],
  ['EAT', 'East Africa Time', '+03'],
  ['ECT', 'Eastern Caribbean Time (does not recognise DST)', '−04'],
  ['ECT', 'Ecuador Time', '−05'],
  ['EDT', 'Eastern Daylight Time (North America)', '−04]'],
  ['EEST', 'Eastern European Summer Time', '+03'],
  ['EET', 'Eastern European Time', '+02'],
  ['EGST', 'Eastern Greenland Summer Time', '±00'],
  ['EGT', 'Eastern Greenland Time', '−01'],
  ['EIT', 'Eastern Indonesian Time', '+09'],
  ['EST', 'Eastern Standard Time (North America)', '−05'],
  ['FET', 'Further-eastern European Time', '+03'],
  ['FJT', 'Fiji Time', '+12'],
  ['FKST', 'Falkland Islands Summer Time', '−03'],
  ['FKT', 'Falkland Islands Time', '−04'],
  ['FNT', 'Fernando de Noronha Time', '−02'],
  ['GALT', 'Galápagos Time	', '−06'],
  ['GAMT', 'Gambier Islands Time', '−09'],
  ['GET', 'Georgia Standard Time', '+04'],
  ['GFT', 'French Guiana Time', '−03'],
  ['GILT', 'Gilbert Island Time', '+12'],
  ['GIT', 'Gambier Island Time', '−09'],
  ['GMT', 'Greenwich Mean Time', '±00'],
  ['GST', 'South Georgia and the South Sandwich Islands Time', '−02'],
  ['GST', 'Gulf Standard Time', '+04'],
  ['GYT', 'Guyana Time', '−04'],
  ['HDT', 'Hawaii–Aleutian Daylight Time', '−09'],
  [
    'HAEC',
    'Heure Avancée d\'Europe Centrale French-language name for CEST',
    '+02'
  ],
  ['HST', 'Hawaii–Aleutian Standard Time', '−10'],
  ['HKT', 'Hong Kong Time', '+08'],
  ['HMT', 'Heard and McDonald Islands Time', '+05'],
  ['HOVST', 'Khovd Summer Time', '+08'],
  ['HOVT', 'Khovd Standard Time', '+07'],
  ['ICT', 'Indochina Time', '+07'],
  ['IDLW', 'International Day Line West time zone', '−12'],
  ['IDT', 'Israel Daylight Time', '+03'],
  ['IOT', 'Indian Ocean Time', '+03'],
  ['IRDT', 'Iran Daylight Time', '+04:30'],
  ['IRKT', 'Irkutsk Time', '+08'],
  ['IRST', 'Iran Standard Time', '+03:30'],
  ['IST', 'Indian Standard Time', '+05:30'],
  ['IST', 'Irish Standard Time[5]', '+01'],
  ['IST', 'Israel Standard Time', '+02'],
  ['JST', 'Japan Standard Time', '+09'],
  ['KALT', 'Kaliningrad Time', '+02'],
  ['KGT', 'Kyrgyzstan Time', '+06'],
  ['KOST', 'Kosrae Time', '+11'],
  ['KRAT', 'Krasnoyarsk Time', '+07'],
  ['KST', 'Korea Standard Time', '+09'],
  ['LHST', 'Lord Howe Standard Time', '+10:30'],
  ['LHST', 'Lord Howe Summer Time', '+11'],
  ['LINT', 'Line Islands Time', '+14'],
  ['MAGT', 'Magadan Time', '+12'],
  ['MART', 'Marquesas Islands Time', '−09:30'],
  ['MAWT', 'Mawson Station Time', '+05'],
  ['MDT', 'Mountain Daylight Time (North America)', '−06'],
  ['MET', 'Middle European Time Same zone as CET', '+01'],
  ['MEST', 'Middle European Summer Time Same zone as CEST', '+02'],
  ['MHT', 'Marshall Islands Time', '+12'],
  ['MIST', 'Macquarie Island Station Time', '+11'],
  ['MIT', 'Marquesas Islands Time', '−09:30'],
  ['MMT', 'Myanmar Standard Time', '+06:30'],
  ['MSK', 'Moscow Time', '+03'],
  ['MST', 'Malaysia Standard Time', '+08'],
  ['MST', 'Mountain Standard Time (North America)', '−07'],
  ['MUT', 'Mauritius Time', '+04'],
  ['MVT', 'Maldives Time', '+05'],
  ['MYT', 'Malaysia Time', '+08'],
  ['NCT', 'New Caledonia Time', '+11'],
  ['NDT', 'Newfoundland Daylight Time', '−02:30'],
  ['NFT', 'Norfolk Island Time', '+11'],
  ['NPT', 'Nepal Time', '+05:45'],
  ['NST', 'Newfoundland Standard Time', '−03:30'],
  ['NT', 'Newfoundland Time', '−03:30'],
  ['NUT', 'Niue Time', '−11'],
  ['NZDT', 'New Zealand Daylight Time', '+13'],
  ['NZST', 'New Zealand Standard Time', '+12'],
  ['OMST', 'Omsk Time', '+06'],
  ['ORAT', 'Oral Time', '+05'],
  ['PDT', 'Pacific Daylight Time (North America)', '−07'],
  ['PET', 'Peru Time', '−05'],
  ['PETT', 'Kamchatka Time', '+12'],
  ['PGT', 'Papua New Guinea Time', '+10'],
  ['PHOT', 'Phoenix Island Time', '+13'],
  ['PHT', 'Philippine Time', '+08'],
  ['PKT', 'Pakistan Standard Time', '+05'],
  ['PMDT', 'Saint Pierre and Miquelon Daylight Time', '−02'],
  ['PMST', 'Saint Pierre and Miquelon Standard Time', '−03'],
  ['PONT', 'Pohnpei Standard Time', '+11'],
  ['PST', 'Pacific Standard Time (North America)', '−08'],
  ['PST', 'Philippine Standard Time', '+08'],
  ['PYST', 'Paraguay Summer Time[6]', '−03'],
  ['PYT', 'Paraguay Time[7]', '−04'],
  ['RET', 'Réunion Time', '+04'],
  ['ROTT', 'Rothera Research Station Time', '−03'],
  ['SAKT', 'Sakhalin Island Time', '+11'],
  ['SAMT', 'Samara Time', '+04'],
  ['SAST', 'South African Standard Time', '+02'],
  ['SBT', 'Solomon Islands Time', '+11'],
  ['SCT', 'Seychelles Time', '+04'],
  ['SDT', 'Samoa Daylight Time', '−10'],
  ['SGT', 'Singapore Time', '+08'],
  ['SLST', 'Sri Lanka Standard Time', '+05:30'],
  ['SRET', 'Srednekolymsk Time', '+11'],
  ['SRT', 'Suriname Time', '−03'],
  ['SST', 'Samoa Standard Time', '−11'],
  ['SST', 'Singapore Standard Time', '+08'],
  ['SYOT', 'Showa Station Time', '+03'],
  ['TAHT', 'Tahiti Time', '−10'],
  ['THA', 'Thailand Standard Time', '+07'],
  ['TFT', 'Indian/Kerguelen', '+05'],
  ['TJT', 'Tajikistan Time', '+05'],
  ['TKT', 'Tokelau Time', '+13'],
  ['TLT', 'Timor Leste Time', '+09'],
  ['TMT', 'Turkmenistan Time', '+05'],
  ['TRT', 'Turkey Time', '+03'],
  ['TOT', 'Tonga Time', '+13'],
  ['TVT', 'Tuvalu Time', '+12'],
  ['ULAST', 'Ulaanbaatar Summer Time', '+09'],
  ['ULAT', 'Ulaanbaatar Standard Time', '+08'],
  ['UTC', 'Coordinated Universal Time', '+00'],
  ['UYST', 'Uruguay Summer Time', '−02'],
  ['UYT', 'Uruguay Standard Time', '−03'],
  ['UZT', 'Uzbekistan Time', '+05'],
  ['VET', 'Venezuelan Standard Time', '−04'],
  ['VLAT', 'Vladivostok Time', '+10'],
  ['VOLT', 'Volgograd Time', '+04'],
  ['VOST', 'Vostok Station Time', '+06'],
  ['VUT', 'Vanuatu Time', '+11'],
  ['WAKT', 'Wake Island Time', '+12'],
  ['WAST', 'West Africa Summer Time', '+02'],
  ['WAT', 'West Africa Time', '+01'],
  ['WEST', 'Western European Summer Time', '+01'],
  ['WET', 'Western European Time', '±00'],
  ['WIT', 'Western Indonesian Time', '+07'],
  ['WST', 'Western Standard Time', '+08'],
  ['YAKT', 'Yakutsk Time', '+09'],
  ['YEKT', 'Yekaterinburg Time', '+05']
];
