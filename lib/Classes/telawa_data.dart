import 'package:quranandsunnahapp/Classes/helper_methods.dart';

class Telawa {
  int indexTelawa;
  int id;
  String qareaName;
  String rewaya;
  String musshaf_type;

  Telawa(
      {this.id,
      this.musshaf_type,
      this.qareaName,
      this.rewaya,
      this.indexTelawa});

  factory Telawa.fromJson(Map<String, dynamic> json, int index) {
    return Telawa(
        indexTelawa: index,
        id: json["id"] as int,
        musshaf_type: json["musshaf_type"] as String,
        rewaya: json["rewaya"] as String,
        qareaName: json["name"] as String);
  }
}
