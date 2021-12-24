import 'helper_methods.dart';

class DuaaData {
  final String azkarGroup;
  final int azkarGroupIndex;
  final String intro;
  final String zekr;
  final int count;
  final String reference;
  final String description;

  DuaaData(
      {this.azkarGroup,
      this.azkarGroupIndex,
      this.intro,
      this.zekr,
      this.count,
      this.reference,
      this.description});

  factory DuaaData.fromJson(
      {Map<String, dynamic> json, String title, int index}) {
    // print(json);

    return DuaaData(
      azkarGroup: title,
      azkarGroupIndex: index,
      intro: json['intro'] ?? "",
      zekr: json['zekr'],
      reference: json['reference'],
      count: HelperMethods.getIntParsedString(json['count'], defaultValue: 1),
      description: json['description'],
    );
  }
}

class DuaaGroupData {
  final String azkarGroup;
  final int azkarGroupIndex;
  final List<DuaaData> duaas;
  bool starred;
  DuaaGroupData({this.azkarGroup, this.azkarGroupIndex, this.duaas});
  set starAzkar(bool star) {
    this.starred = star;
  }

  bool get starAzkar {
    return starred;
  }

  factory DuaaGroupData.fromJson(
      {List<DuaaData> duaas, String title, int index}) {
    return DuaaGroupData(
      azkarGroup: title ?? "",
      azkarGroupIndex: index,
      duaas: duaas,
    );
  }
}

class AzkarData {
  final List<String> azkarSubgroupNames;
  final int azkarGroupIndex;
  final List<String> intro;
  final List<String> zekr;
  final int count;
  final String reference;
  final List<String> description;
  final String audioFileName;
  AzkarData({
    this.azkarSubgroupNames,
    this.azkarGroupIndex,
    this.intro,
    this.zekr,
    this.count,
    this.reference,
    this.description,
    this.audioFileName,
  });

  factory AzkarData.fromJson(
      {Map<String, dynamic> json, List<String> titles, int index}) {
    // print(json);

    return AzkarData(
      azkarSubgroupNames: titles,
      azkarGroupIndex: index,
      // intro: json['intro'] ?? "",
      zekr: [
        json['language_ar'],
        json['language_en'] ?? json['language_ar'],
      ],
      reference: json['hint'],
      audioFileName: json['file_name'],
      count: json['counter_num'] ?? 1,
      // description: json['description'],
    );
  }
}

class AzkarGroupData {
  final List<String> azkarGroupNames;
  final int azkarGroupIndex;
  final List<AzkarSubgroupData> subgroups;
  bool starred;
  AzkarGroupData({this.azkarGroupNames, this.azkarGroupIndex, this.subgroups});
  set starAzkar(bool star) {
    this.starred = star;
  }

  bool get starAzkar {
    return starred;
  }

  factory AzkarGroupData.fromJson(
      {List<AzkarSubgroupData> subgroups, List<String> titles, int index}) {
    return AzkarGroupData(
      azkarGroupNames: titles ?? [],
      azkarGroupIndex: index,
      subgroups: subgroups,
    );
  }
}

class AzkarSubgroupData {
  final int parentGroupIndex;
  final List<String> azkarSubgroupNames;
  final int azkarSubgroupIndex;
  final List<AzkarData> azkar;
  bool starred;
  AzkarSubgroupData(
      {this.azkarSubgroupNames,
      this.azkarSubgroupIndex,
      this.parentGroupIndex,
      this.azkar});
  set starAzkar(bool star) {
    this.starred = star;
  }

  bool get starAzkar {
    return starred;
  }

  factory AzkarSubgroupData.fromJson(
      {List<AzkarData> azkar,
      List<String> titles,
      int index,
      int parentGroupIndex}) {
    return AzkarSubgroupData(
      azkar: azkar,
      azkarSubgroupNames: titles,
      azkarSubgroupIndex: index,
      parentGroupIndex: parentGroupIndex,
    );
  }
}
