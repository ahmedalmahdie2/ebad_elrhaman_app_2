class DuaaModel {
  Map<String, List<DuaaModel>> subList;
  int count;
  String description;
  String reference;
  String zekr;
  String name;

  DuaaModel(
      {this.zekr,
      this.count,
      this.description,
      this.reference,
      this.subList,
      this.name});

  factory DuaaModel.fromJson(Map<String, dynamic> json) {
    return DuaaModel(
        count: json["count"] == "" ? 1 : int.parse(json["count"]),
        description: json["description"],
        reference: json["reference"],
        zekr: json["zekr"]);
  }
  factory DuaaModel.fromJson2(Map<String, dynamic> json) {
    return DuaaModel(
        count: json["count"] == "" ? 1 : int.parse(json["count"]),
        description: json["description"],
        reference: json["reference"],
        zekr: json["zekr"],
        name: json["name"]);
  }
}

class DuaaGroup {
  List<DuaaModel> duaaList;
  String duaaNameGroup;
  List<DuaaGroup> subGroups;
  DuaaGroup({this.duaaList, this.duaaNameGroup, this.subGroups});
  factory DuaaGroup.fromJsonFadlZekr(Map<String, dynamic> json) {
    return DuaaGroup(duaaList: json["فضل الذكر"]);
  }
}
