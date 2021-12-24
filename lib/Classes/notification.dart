//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io' show File, Platform;

class NotificationServices {
  final BehaviorSubject<RecivedNotification>
      didRecievedLocalNotificationSubject =
      BehaviorSubject<RecivedNotification>();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationServices();
  Future initialize() async {
    await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    //_flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      await _requestIOSPermission();
    }
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) async {
      RecivedNotification recivedNotification = RecivedNotification(
          body: body, id: id, payload: payload, title: title);
      didRecievedLocalNotificationSubject.add(recivedNotification);
    });
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  _requestIOSPermission() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  setListnerForLowerVersions(Function onNotificationInLowerVersions) {
    didRecievedLocalNotificationSubject.listen((value) {
      onNotificationInLowerVersions(value);
    });
  }

  Future _schedulePrayerNotification(
      int id, String title, String body, DateTime scheduleDate,
      [String payload]) async {
    var notificationTime =
        Time(scheduleDate.hour, scheduleDate.minute, scheduleDate.second);
    print(DateTime.now().hour);

    //print(tz.TZDateTime.now(tz.local));
    var android = AndroidNotificationDetails(
      '0',
      'prayer time for azan',
      'prayer time and azan notification',
      priority: Priority.high,
      importance: Importance.max,
      visibility: NotificationVisibility.public,
      enableLights: true,
      channelShowBadge: true,
    );
    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);
    //Time(1,1);
    await _flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, body, notificationTime, platform);
  }

  Future _schedulePrayerWithSoundNotification(
      int id, String title, String body, DateTime scheduleDate,
      [String payload]) async {
    var notificationTime =
        Time(scheduleDate.hour, scheduleDate.minute, scheduleDate.second);
    print('${notificationTime.hour} and ${notificationTime.minute}');

    //print(tz.TZDateTime.now(tz.local));
    var android = AndroidNotificationDetails(
      '15',
      'prayer time for azan',
      'prayer time and azan notification',
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
      visibility: NotificationVisibility.public,
      enableLights: true,
      channelShowBadge: true,
      sound: RawResourceAndroidNotificationSound('azan'),
    );
    var ios = IOSNotificationDetails(
        sound: 'ezan.aiff',
        presentSound: true,
        presentAlert: true,
        presentBadge: true);

    var platform = new NotificationDetails(android: android, iOS: ios);
    //Time(1,1);
    await _flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, body, notificationTime, platform);

    // tz.initializeTimeZones();
    // final String currentTimeZone =
    //     await FlutterNativeTimezone.getLocalTimezone();
    // tz.setLocalLocation(tz.getLocation(currentTimeZone));
    // var x = tz.TZDateTime.now(tz.local);
    // await _flutterLocalNotificationsPlugin.zonedSchedule(
    //     id,
    //     title,
    //     body,
    //     x
    //             .add(Duration(
    //                 minutes: scheduleDate.minute - x.minute,
    //                 hours: scheduleDate.hour - x.hour))
    //             .isBefore(tz.TZDateTime.now(tz.local))
    //         ? x.add(Duration(days: 1))
    //         : x,
    //     platform,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     androidAllowWhileIdle: true,
    //     matchDateTimeComponents: DateTimeComponents.time);
    // print(x);
    //await _flutterLocalNotificationsPlugin.periodicallyShow(id, title, body, repeatInterval, notificationDetails)
  }

  Future<void> schedulePrayerNotifications(int id, DateTime prayerTime,
      String prayerNameTitle, String prayerNameBody, String payload) async {
    _schedulePrayerNotification(
        id, prayerNameTitle, prayerNameBody, prayerTime, payload);
  }

  Future<void> schedulePrayerWithSoundNotifications(int id, DateTime prayerTime,
      String prayerNameTitle, String prayerNameBody, String payload) async {
    _schedulePrayerWithSoundNotification(
        id, prayerNameTitle, prayerNameBody, prayerTime, payload);
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    var pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('${pendingNotificationRequests[0].title} begad');
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.80,
            child: ListView.builder(
                itemCount: pendingNotificationRequests.length,
                itemBuilder: (BuildContext context, int i) {
                  return Text(pendingNotificationRequests[i].id.toString() +
                      ' ' +
                      pendingNotificationRequests[i].title);
                }),
          ),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // cancel the notification with id value of zero
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}

class RecivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  RecivedNotification(
      {@required this.body,
      @required this.id,
      @required this.payload,
      @required this.title});
}
