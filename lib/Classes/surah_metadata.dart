class SurahMetadata {
  int number;
  String englishName;
  int numOfAyah;
  int start;
  int end;
  String arabicName;
  int index;
  int startPage;
  bool isMaccan;

  SurahMetadata(
      {this.number,
      this.arabicName,
      this.englishName,
      this.end,
      this.start,
      this.numOfAyah,
      this.index,
      this.startPage,
      this.isMaccan});

  factory SurahMetadata.fromJson(
      {Map<String, dynamic> json,
      int index,
      int startAyahNumber = 1,
      int endAyahNumber}) {
    return SurahMetadata(
      number: json["number"] as int,
      arabicName: json["name"] as String,
      englishName: json["englishName"] as String,
      numOfAyah: json["numberOfAyahs"] as int,
      start: (json["start"] ?? startAyahNumber) as int,
      end: (json["end"] ?? endAyahNumber ?? json["numberOfAyahs"]) as int,
      index: index,
      isMaccan: json['revelationType'] == 'Meccan',
    );
  }
}
