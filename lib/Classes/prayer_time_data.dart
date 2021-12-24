import 'package:flutter/material.dart';

class DayPrayersAlertsData {
  // TodayAzanData({this._fagrTime});
  DateTime day;

  DateTime fagrTime;
  DateTime sunriseTime;
  DateTime dhuhrTime;
  DateTime asrTime;
  DateTime maghribTime;
  DateTime eshaaTime;

  DayPrayersAlertsData(
      {this.day,
      this.fagrTime,
      this.sunriseTime,
      this.dhuhrTime,
      this.asrTime,
      this.maghribTime,
      this.eshaaTime});

  factory DayPrayersAlertsData.fromjson(Map<String, dynamic> json) {
    return DayPrayersAlertsData();
  }
}

class PrayerAlerts {
  int PrayerNameIndex = 0;
  List<bool> alertsOn;
  DateTime before;
  String alert;
  DateTime after;

  PrayerAlerts({
    this.PrayerNameIndex = 0,
    this.alertsOn = const [false, false, false],
    this.before,
    this.alert,
    this.after,
  });
}
