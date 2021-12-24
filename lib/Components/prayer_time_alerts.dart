import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Classes/prayer_time_data.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:quranandsunnahapp/Screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerAlertsWidget extends StatefulWidget {
  final PrayerAlerts alerts;

  const PrayerAlertsWidget({this.alerts});

  @override
  _PrayerAlertsWidgetState createState() => _PrayerAlertsWidgetState();
}

class _PrayerAlertsWidgetState extends State<PrayerAlertsWidget> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  SharedPreferences pref;
  getData() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            child: Text(
              kPrayersNames[widget.alerts.PrayerNameIndex][0],
              style: kAppBarTitleStyle,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  widget.alerts.alertsOn[0]
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_outlined,
                  color: kMainAppColor03,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    if (widget.alerts.alertsOn[0]) {
                      pref.setBool(
                          widget.alerts.PrayerNameIndex.toString() + "B",
                          false);
                      widget.alerts.alertsOn[0] = false;
                      HomeScreen.notificationServices.cancelNotification(
                          (widget.alerts.PrayerNameIndex * 3) + 0);
                    } else {
                      pref.setBool(
                          widget.alerts.PrayerNameIndex.toString() + "B", true);
                      widget.alerts.alertsOn[0] = true;
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  widget.alerts.alertsOn[1]
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_outlined,
                  color: kMainAppColor03,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    if (widget.alerts.alertsOn[1]) {
                      pref.setBool(
                          widget.alerts.PrayerNameIndex.toString() + "T",
                          false);
                      widget.alerts.alertsOn[1] = false;
                      HomeScreen.notificationServices.cancelNotification(
                          (widget.alerts.PrayerNameIndex * 3) + 1);
                    } else {
                      pref.setBool(
                          widget.alerts.PrayerNameIndex.toString() + "T", true);
                      widget.alerts.alertsOn[1] = true;
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  widget.alerts.alertsOn[2]
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_outlined,
                  color: kMainAppColor03,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    if (widget.alerts.alertsOn[2]) {
                      pref.setBool(
                          widget.alerts.PrayerNameIndex.toString() + "A",
                          false);
                      widget.alerts.alertsOn[2] = false;
                      HomeScreen.notificationServices.cancelNotification(
                          (widget.alerts.PrayerNameIndex * 3) + 2);
                    } else {
                      pref.setBool(
                          widget.alerts.PrayerNameIndex.toString() + "A", true);
                      widget.alerts.alertsOn[2] = true;
                    }
                  });
                },
              ),
            ],
          ),
          const Spacer(),
          Text(
            //HelperMethods.getTimeFormated(widget.alerts.alert),
            widget.alerts.alert,
            style: kAppBarTitleStyle,
          ),
        ],
      ),
    );
  }
}
