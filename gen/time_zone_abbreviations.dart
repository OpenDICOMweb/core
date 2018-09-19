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
    cls.writeln('static const ${e[0]} ='
        ' TimeZoneName(\'${e[1]}\', \'${e[0]}', ${Duration(hours: hours, minutes: minutes)});');
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
  return Duration(hours: hours, minutes: minutes);
}
// Abbr.	Name	 offset
const List<List<String>> tz = const [
  const ['ACDT', 'Australian Central Daylight Savings Time', '+10:30'],
  const ['ACST', 'Australian Central Standard Time', '+09:30'],
  const ['ACT', 'Acre Time', '−05'],
//ACT	ASEAN Common Time	'+06:30' – '+09'],
  const [
    'ACWST',
    'Australian Central Western Standard Time (unofficial)',
    '+08:45'
  ],
  const ['ADT', 'Atlantic Daylight Time', '−03'],
  const ['AEDT', 'Australian Eastern Daylight Savings Time', '+11'],
  const ['AEST', 'Australian Eastern Standard Time', '+10'],
  const ['AFT', 'Afghanistan Time', '+04:30'],
  const ['AKDT', 'Alaska Daylight Time', '−08'],
  const ['AKST', 'Alaska Standard Time', '−09'],
  const ['AMST', 'Amazon Summer Time(Brazil)[1]', '−03'],
  const ['AMT', 'Amazon Time(Brazil)[2]', '−04'],
  const ['AMT', 'Armenia Time', '+04'],
  const ['ART', 'Argentina Time', '−03'],
  const ['AST', 'Arabia Standard Time', '+03'],
  const ['AST', 'Atlantic Standard Time', '−04'],
  const ['AWST', 'Australian Western Standard Time', '+08'],
  const ['AZOST', 'Azores Summer Time', '±00'],
  const ['AZOT', 'Azores Standard Time', '−01'],
  const ['AZT', 'Azerbaijan Time', '+04'],
  const ['BDT', 'Brunei Time', '+08'],
  const ['BIOT', 'British Indian Ocean Time', '+06'],
  const ['BIT', 'Baker Island Time', '−12'],
  const ['BOT', 'Bolivia Time', '−04'],
  const ['BRST', 'Brasília Summer Time', '−02'],
  const ['BRT', 'Brasilia Time', '−03'],
  const ['BST', 'Bangladesh Standard Time', '+06'],
  const ['BST', 'Bougainville Standard Time[3]', '+11'],
  const [
    'BST',
    'British Summer Time (British Standard Time from Feb 1968 to Oct 1971)',
    '+01'
  ],
  const ['BTT', 'Bhutan Time', '+06'],
  const ['CAT', 'Central Africa Time', '+02'],
  const ['CCT', 'Cocos Islands Time', '+06:30'],
  const ['CDT', 'Central Daylight Time (North America)', '−05'],
  const ['CDT', 'Cuba Daylight Time [4]', '−04'],
  const ['CEST', 'Central European Summer Time (Cf. HAEC)', '+02'],
  const ['CET', 'Central European Time', '+01'],
  const ['CHADT', 'Chatham Daylight Time', '+13:45'],
  const ['CHAST', 'Chatham Standard Time', '+12:45'],
  const ['CHOT', 'Choibalsan Standard Time', '+08'],
  const ['CHOST', 'Choibalsan Summer Time', '+09'],
  const ['CHST', 'Chamorro Standard Time', '+10'],
  const ['CHUT', 'Chuuk Time', '+10'],
  const ['CIST', 'Clipperton Island Standard Time', '−08'],
  const ['CIT', 'Central Indonesia Time', '+08'],
  const ['CKT', 'Cook Island Time', '−10'],
  const ['CLST', 'Chile Summer Time', '−03'],
  const ['CLT', 'Chile Standard Time', '−04'],
  const ['COST', 'Colombia Summer Time', '−04'],
  const ['COT', 'Colombia Time', '−05'],
  const ['CST', 'Central Standard Time (North America)', '−06'],
  const ['CST', 'China Standard Time', '+08'],
  const ['CST', 'Cuba Standard Time', '−05'],
  const ['CT', 'China Time', '+08'],
  const ['CVT', 'Cape Verde Time', '−01'],
  const [
    'CWST',
    'Central Western Standard Time (Australia) unofficial',
    '+08:45'
  ],
  const ['CXT', 'Christmas Island Time', '+07'],
  const ['DAVT', 'Davis Time', '+07'],
  const ['DDUT', 'Dumont d\'Urville Time', '+10'],
  const [
    'DFT',
    'AIX-specific equivalent of Central European Time[NB 1]',
    '+01'
  ],
  const ['EASST', 'Easter Island Summer Time', '−05'],
  const ['EAST', 'Easter Island Standard Time', '−06'],
  const ['EAT', 'East Africa Time', '+03'],
  const ['ECT', 'Eastern Caribbean Time (does not recognise DST)', '−04'],
  const ['ECT', 'Ecuador Time', '−05'],
  const ['EDT', 'Eastern Daylight Time (North America)', '−04]'],
  const ['EEST', 'Eastern European Summer Time', '+03'],
  const ['EET', 'Eastern European Time', '+02'],
  const ['EGST', 'Eastern Greenland Summer Time', '±00'],
  const ['EGT', 'Eastern Greenland Time', '−01'],
  const ['EIT', 'Eastern Indonesian Time', '+09'],
  const ['EST', 'Eastern Standard Time (North America)', '−05'],
  const ['FET', 'Further-eastern European Time', '+03'],
  const ['FJT', 'Fiji Time', '+12'],
  const ['FKST', 'Falkland Islands Summer Time', '−03'],
  const ['FKT', 'Falkland Islands Time', '−04'],
  const ['FNT', 'Fernando de Noronha Time', '−02'],
  const ['GALT', 'Galápagos Time	', '−06'],
  const ['GAMT', 'Gambier Islands Time', '−09'],
  const ['GET', 'Georgia Standard Time', '+04'],
  const ['GFT', 'French Guiana Time', '−03'],
  const ['GILT', 'Gilbert Island Time', '+12'],
  const ['GIT', 'Gambier Island Time', '−09'],
  const ['GMT', 'Greenwich Mean Time', '±00'],
  const ['GST', 'South Georgia and the South Sandwich Islands Time', '−02'],
  const ['GST', 'Gulf Standard Time', '+04'],
  const ['GYT', 'Guyana Time', '−04'],
  const ['HDT', 'Hawaii–Aleutian Daylight Time', '−09'],
  const [
    'HAEC',
    'Heure Avancée d\'Europe Centrale French-language name for CEST',
    '+02'
  ],
  const ['HST', 'Hawaii–Aleutian Standard Time', '−10'],
  const ['HKT', 'Hong Kong Time', '+08'],
  const ['HMT', 'Heard and McDonald Islands Time', '+05'],
  const ['HOVST', 'Khovd Summer Time', '+08'],
  const ['HOVT', 'Khovd Standard Time', '+07'],
  const ['ICT', 'Indochina Time', '+07'],
  const ['IDLW', 'International Day Line West time zone', '−12'],
  const ['IDT', 'Israel Daylight Time', '+03'],
  const ['IOT', 'Indian Ocean Time', '+03'],
  const ['IRDT', 'Iran Daylight Time', '+04:30'],
  const ['IRKT', 'Irkutsk Time', '+08'],
  const ['IRST', 'Iran Standard Time', '+03:30'],
  const ['IST', 'Indian Standard Time', '+05:30'],
  const ['IST', 'Irish Standard Time[5]', '+01'],
  const ['IST', 'Israel Standard Time', '+02'],
  const ['JST', 'Japan Standard Time', '+09'],
  const ['KALT', 'Kaliningrad Time', '+02'],
  const ['KGT', 'Kyrgyzstan Time', '+06'],
  const ['KOST', 'Kosrae Time', '+11'],
  const ['KRAT', 'Krasnoyarsk Time', '+07'],
  const ['KST', 'Korea Standard Time', '+09'],
  const ['LHST', 'Lord Howe Standard Time', '+10:30'],
  const ['LHST', 'Lord Howe Summer Time', '+11'],
  const ['LINT', 'Line Islands Time', '+14'],
  const ['MAGT', 'Magadan Time', '+12'],
  const ['MART', 'Marquesas Islands Time', '−09:30'],
  const ['MAWT', 'Mawson Station Time', '+05'],
  const ['MDT', 'Mountain Daylight Time (North America)', '−06'],
  const ['MET', 'Middle European Time Same zone as CET', '+01'],
  const ['MEST', 'Middle European Summer Time Same zone as CEST', '+02'],
  const ['MHT', 'Marshall Islands Time', '+12'],
  const ['MIST', 'Macquarie Island Station Time', '+11'],
  const ['MIT', 'Marquesas Islands Time', '−09:30'],
  const ['MMT', 'Myanmar Standard Time', '+06:30'],
  const ['MSK', 'Moscow Time', '+03'],
  const ['MST', 'Malaysia Standard Time', '+08'],
  const ['MST', 'Mountain Standard Time (North America)', '−07'],
  const ['MUT', 'Mauritius Time', '+04'],
  const ['MVT', 'Maldives Time', '+05'],
  const ['MYT', 'Malaysia Time', '+08'],
  const ['NCT', 'New Caledonia Time', '+11'],
  const ['NDT', 'Newfoundland Daylight Time', '−02:30'],
  const ['NFT', 'Norfolk Island Time', '+11'],
  const ['NPT', 'Nepal Time', '+05:45'],
  const ['NST', 'Newfoundland Standard Time', '−03:30'],
  const ['NT', 'Newfoundland Time', '−03:30'],
  const ['NUT', 'Niue Time', '−11'],
  const ['NZDT', 'New Zealand Daylight Time', '+13'],
  const ['NZST', 'New Zealand Standard Time', '+12'],
  const ['OMST', 'Omsk Time', '+06'],
  const ['ORAT', 'Oral Time', '+05'],
  const ['PDT', 'Pacific Daylight Time (North America)', '−07'],
  const ['PET', 'Peru Time', '−05'],
  const ['PETT', 'Kamchatka Time', '+12'],
  const ['PGT', 'Papua New Guinea Time', '+10'],
  const ['PHOT', 'Phoenix Island Time', '+13'],
  const ['PHT', 'Philippine Time', '+08'],
  const ['PKT', 'Pakistan Standard Time', '+05'],
  const ['PMDT', 'Saint Pierre and Miquelon Daylight Time', '−02'],
  const ['PMST', 'Saint Pierre and Miquelon Standard Time', '−03'],
  const ['PONT', 'Pohnpei Standard Time', '+11'],
  const ['PST', 'Pacific Standard Time (North America)', '−08'],
  const ['PST', 'Philippine Standard Time', '+08'],
  const ['PYST', 'Paraguay Summer Time[6]', '−03'],
  const ['PYT', 'Paraguay Time[7]', '−04'],
  const ['RET', 'Réunion Time', '+04'],
  const ['ROTT', 'Rothera Research Station Time', '−03'],
  const ['SAKT', 'Sakhalin Island Time', '+11'],
  const ['SAMT', 'Samara Time', '+04'],
  const ['SAST', 'South African Standard Time', '+02'],
  const ['SBT', 'Solomon Islands Time', '+11'],
  const ['SCT', 'Seychelles Time', '+04'],
  const ['SDT', 'Samoa Daylight Time', '−10'],
  const ['SGT', 'Singapore Time', '+08'],
  const ['SLST', 'Sri Lanka Standard Time', '+05:30'],
  const ['SRET', 'Srednekolymsk Time', '+11'],
  const ['SRT', 'Suriname Time', '−03'],
  const ['SST', 'Samoa Standard Time', '−11'],
  const ['SST', 'Singapore Standard Time', '+08'],
  const ['SYOT', 'Showa Station Time', '+03'],
  const ['TAHT', 'Tahiti Time', '−10'],
  const ['THA', 'Thailand Standard Time', '+07'],
  const ['TFT', 'Indian/Kerguelen', '+05'],
  const ['TJT', 'Tajikistan Time', '+05'],
  const ['TKT', 'Tokelau Time', '+13'],
  const ['TLT', 'Timor Leste Time', '+09'],
  const ['TMT', 'Turkmenistan Time', '+05'],
  const ['TRT', 'Turkey Time', '+03'],
  const ['TOT', 'Tonga Time', '+13'],
  const ['TVT', 'Tuvalu Time', '+12'],
  const ['ULAST', 'Ulaanbaatar Summer Time', '+09'],
  const ['ULAT', 'Ulaanbaatar Standard Time', '+08'],
  const ['UTC', 'Coordinated Universal Time', '+00'],
  const ['UYST', 'Uruguay Summer Time', '−02'],
  const ['UYT', 'Uruguay Standard Time', '−03'],
  const ['UZT', 'Uzbekistan Time', '+05'],
  const ['VET', 'Venezuelan Standard Time', '−04'],
  const ['VLAT', 'Vladivostok Time', '+10'],
  const ['VOLT', 'Volgograd Time', '+04'],
  const ['VOST', 'Vostok Station Time', '+06'],
  const ['VUT', 'Vanuatu Time', '+11'],
  const ['WAKT', 'Wake Island Time', '+12'],
  const ['WAST', 'West Africa Summer Time', '+02'],
  const ['WAT', 'West Africa Time', '+01'],
  const ['WEST', 'Western European Summer Time', '+01'],
  const ['WET', 'Western European Time', '±00'],
  const ['WIT', 'Western Indonesian Time', '+07'],
  const ['WST', 'Western Standard Time', '+08'],
  const ['YAKT', 'Yakutsk Time', '+09'],
  const ['YEKT', 'Yekaterinburg Time', '+05']
];
