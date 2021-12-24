import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quranandsunnahapp/Classes/alarm.dart';
import 'package:quranandsunnahapp/Classes/azkar_data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quranandsunnahapp/Classes/ad_state.dart';
import 'package:quranandsunnahapp/Classes/date.dart';
import 'package:quranandsunnahapp/Classes/notification.dart';
import 'package:quranandsunnahapp/Classes/prayer_time_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/clipped_card.dart';
import 'package:quranandsunnahapp/Components/gradient_colors_decorated_container.dart';
import 'package:quranandsunnahapp/Components/main_category_button.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/prayer_time_alerts.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:quranandsunnahapp/Screens/about_us.dart';
import 'package:quranandsunnahapp/Screens/azkar_main_category.dart';
import 'package:quranandsunnahapp/Screens/duaa_main_screen.dart';
import 'package:quranandsunnahapp/Screens/hadith_books_main_screen.dart';
import 'package:quranandsunnahapp/Screens/qibla_screen.dart';
import 'package:quranandsunnahapp/Screens/quran_main_screen.dart';
import 'package:quranandsunnahapp/Screens/quran_screen.dart';
import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Screens/tafseer_screen.dart';
import 'package:quranandsunnahapp/Screens/telawa_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class HomeScreen extends StatefulWidget {
  static const String route = 'homeScreen';
  static NotificationServices notificationServices;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAzanSectionExpanded = false;

  BannerAd banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initalization.then((status) {
      if (mounted) {
        setState(() {
          banner = BannerAd(
              size: AdSize.banner,
              adUnitId: adState.bannerAdUnitId,
              listener: adState.adListner,
              request: AdRequest())
            ..load();
          //banner = adState.createBannerAd(adState.bannerAdUnitId)..load();
          print('i am in home');
        });
      }
    });
  }

  bool _hasAzanSectionExpandingAnimationEnded = false;
  bool _hasAzanSectionCollapsingAnimationEnded = true;
  List<List<String>> showAlerts = [
    ['إظهار', 'show'],
    ['إخفاء', 'hide']
  ];

  bool notificationWithSound = true;
  List<AzkarGroupData> prayers = [];
  int indexOfCurrentTime = 0;
  List<String> mystr = ["00:00", "00:00", "00:00", "00:00", "00:00", "00:00"];
  SharedPreferences pref;
  static List<Alarm> allAlarms = [];
  List<MyDate> date = [];
  Future<void> getAlarmData() async {
    for (int i = 0; i < 6; i++) {
      allAlarms.add(Alarm(after: true, before: true, inTime: true));
      // allAlarms[i].before = false;
      // allAlarms[i].inTime = false;
      // allAlarms[i].after = false;
    }
    pref = await SharedPreferences.getInstance();

    allAlarms[0].before = pref.getBool("0B") ?? true;
    // print(allAlarms[0].before);
    allAlarms[0].inTime = pref.getBool("0T") ?? true;
    allAlarms[0].after = pref.getBool("0A") ?? true;

    allAlarms[1].before = pref.getBool("1B") ?? true;
    allAlarms[1].inTime = pref.getBool("1T") ?? true;
    allAlarms[1].after = pref.getBool("1A") ?? true;

    allAlarms[2].before = pref.getBool("2B") ?? true;
    allAlarms[2].inTime = pref.getBool("2T") ?? true;
    allAlarms[2].after = pref.getBool("2A") ?? true;

    allAlarms[3].before = pref.getBool("3B") ?? true;
    allAlarms[3].inTime = pref.getBool("3T") ?? true;
    allAlarms[3].after = pref.getBool("3A") ?? true;

    allAlarms[4].before = pref.getBool("4B") ?? true;
    allAlarms[4].inTime = pref.getBool("4T") ?? true;
    allAlarms[4].after = pref.getBool("4A") ?? true;

    allAlarms[5].before = pref.getBool("5B") ?? true;
    allAlarms[5].inTime = pref.getBool("5T") ?? true;
    allAlarms[5].after = pref.getBool("5A") ?? true;
  }

  int biggerAzanhour = 0;
  int biggerAzanMinute = 0;
  int currentday = 0;
  String address;
  var json;
  @override
  void initState() {
    super.initState();
    //BlocProvider.of<NewquranBloc>(context).add(GettingAllSurahsofQuran());
    HomeScreen.notificationServices = NotificationServices();
    () async {
      await HomeScreen.notificationServices.initialize();
      var x = DateTime.now();
      var pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      try {
        final coordinates = new Coordinates(pos.latitude, pos.longitude);
        List<Address> addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        setState(() {
          address = addresses.first.adminArea;
        });
      } catch (e) {
        address = "Undefined Address";
      }

      json = await HelperMethods.getCurrentAzan(
          x.month, x.year, pos.latitude, pos.longitude);
      mystr[0] = json["data"][x.day - 1]["timings"]["Fajr"];
      mystr[1] = json["data"][x.day - 1]["timings"]["Sunrise"];
      mystr[2] = json["data"][x.day - 1]["timings"]["Dhuhr"];
      mystr[3] = json["data"][x.day - 1]["timings"]["Asr"];
      mystr[4] = json["data"][x.day - 1]["timings"]["Maghrib"];
      mystr[5] = json["data"][x.day - 1]["timings"]["Isha"];
      await getAlarmData();
      // print(allAlarms[2].inTime.toString() + " hahaha");

      for (int i = 0; i < 6; i++) {
        mystr[i] = mystr[i].substring(0, 5);
        date.add(MyDate(
            hour: int.parse(mystr[i][0] + mystr[i][1]),
            minute: int.parse(mystr[i][3] + mystr[i][4])));

        if (int.parse(mystr[i][0] + mystr[i][1]) > 12) {
          mystr[i] = "0" +
              (int.parse(mystr[i][0] + mystr[i][1]) - 12).toString() +
              mystr[i].substring(2);
          mystr[i] += " PM";
        } else
          mystr[i] += " AM";
      }
      updatePrayerTime();
      await getNotificationAzan(context);
      setState(() {
        //print(dateTime.hour);
      });
    }();

    // BlocProvider.of<QuranBloc>(context).add(QuranInitEvent());

    //
    // HelperMethods.loadAzkarFile().then((parsedAzkarFile) {
    //   compute(HelperMethods.parseAzkar, parsedAzkarFile).then(
    //     (azkarGroups) {
    //       prayers = azkarGroups;
    //       print('we\'ve parsed azkar');
    //     },
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    //print(context.locale.);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        // bottomNavigationBar: Container(
        //   width: MediaQuery.of(context).size.width,
        //   height: kHeightForBanner,
        //   child: banner == null ? SizedBox(height: 20) : AdWidget(ad: banner),
        // ),
        backgroundColor: kMainAppColor02,
        appBar: AppBar(
          backgroundColor: kMainAppColor01,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/ebadelrahmanlogo.png',
              width: 25,
            ),
          ),
          title: Text(
            "appname",
            style: kAppBarTitleStyle,
          ).tr(),
          centerTitle: true,
          actions: [ChangeLanguageButton(), MenuButton()],
          // actions: [LangButton(), MenuButton()],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CategoryButton(
                              text: "hadith",
                              onTap: () {
                                Navigator.pushNamed(
                                    context, HadithBooksListScreen.route);
                              },
                              width: MediaQuery.of(context).size.width / 3,
                              fontSize: 35,
                              style: kButtonTextStyleScheherazadeFontNormal
                                  .copyWith(color: kMainAppColor03),
                            ),
                            CategoryButton(
                              text: 'quran',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  QuranMainScreen.route,
                                );
                              },
                              width: MediaQuery.of(context).size.width / 3,
                              fontSize: 35,
                              style: kButtonTextStyleScheherazadeFontNormal
                                  .copyWith(color: kMainAppColor03),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CategoryButton(
                              text: "duaa",
                              onTap: () {
                                // Navigator.pushNamed(context, DuaaListScreen.route,
                                //     arguments: prayers);
                                Navigator.pushNamed(
                                  context,
                                  DuaaListScreen.route,
                                );
                              },
                              width: MediaQuery.of(context).size.width / 3,
                              fontSize: 35,
                              style: kButtonTextStyleScheherazadeFontNormal
                                  .copyWith(color: kMainAppColor03),
                            ),
                            CategoryButton(
                              text: "azkar",
                              onTap: () {
                                // Navigator.pushNamed(
                                //     context, AzkarListScreen.route);
                                Navigator.pushNamed(
                                    context, AzkarMainCategory.route,
                                    arguments: 1);
                              },
                              width: MediaQuery.of(context).size.width / 3,
                              fontSize: 35,
                              style: kButtonTextStyleScheherazadeFontNormal
                                  .copyWith(color: kMainAppColor03),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CategoryButton(
                              text: "telawa",
                              onTap: () {
                                Navigator.pushNamed(
                                    context, TelawaScreen.route);
                              },
                              width: MediaQuery.of(context).size.width / 3,
                              fontSize: 35,
                              style: kButtonTextStyleScheherazadeFontNormal
                                  .copyWith(color: kMainAppColor03),
                            ),
                            CategoryButton(
                              text: "tafseer",
                              onTap: () {
                                Navigator.pushNamed(
                                    context, TafseerScreen.route);
                              },
                              width: MediaQuery.of(context).size.width / 3,
                              fontSize: 35,
                              style: kButtonTextStyleScheherazadeFontNormal
                                  .copyWith(color: kMainAppColor03),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ClippedCard(
                    elevation: 5,
                    shadowColor: kMainAppColor05,
                    isClipped: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: kMainCategoriesButtonBorderSide),
                    child: GradientColorsDecoratedContainer(
                      gradient: LinearGradient(
                        colors: kMainLinearGradient.colors,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'جرينيتش + ١',
                                  style: kAppBarTitleStyle,
                                ),
                                const Spacer(),
                                Wrap(children: [Text(address ?? "القاهــرة")]),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TimerBuilder.periodic(Duration(seconds: 1),
                                      builder: (context) {
                                    if (date.length > 0) updatePrayerTime();
                                    return Text(
                                      "${HelperMethods.getSystemTime()}",
                                    );
                                  }),
                                  const Spacer(),
                                  Text(kPrayersNames[indexOfCurrentTime][0]),
                                ],
                              ),
                            ),
                            Container(
                              height: 10,
                              color: kMainAppColor03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.refresh_sharp,
                                          color: kMainAppColor03,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_back_ios_sharp,
                                          color: kMainAppColor03,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            currentday--;
                                            updateJson();
                                          });
                                        },
                                      ),
                                      TimerBuilder.periodic(
                                          Duration(seconds: 1),
                                          builder: (context) {
                                        // print("${getSystemTime()}");
                                        return Text(
                                          "${HelperMethods.getSystemDate(currentday)}",
                                        );
                                      }),
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: kMainAppColor03,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            currentday++;
                                            updateJson();
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: notificationWithSound == true
                                            ? Icon(
                                                Icons.volume_up_rounded,
                                                color: kMainAppColor03,
                                              )
                                            : Icon(Icons.volume_off),
                                        onPressed: () {
                                          setState(() {
                                            notificationWithSound =
                                                !notificationWithSound;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ClippedCard(
                              shadowColor: kMainAppColor01,
                              isClipped: true,
                              shape: HelperMethods.clippedCardShape.copyWith(
                                  side: kMainCategoriesButtonBorderSide
                                      .copyWith(width: 2)),
                              child: TextButton(
                                onPressed: () async {
                                  // showDialog(
                                  //     context: context,
                                  //     builder:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         (_) => AzkarPicker());
                                  await getAlarms();
                                  setState(() {
                                    _isAzanSectionExpanded =
                                        !_isAzanSectionExpanded;
                                  });
                                  if (notificationWithSound)
                                    await getNotificationAzan(context);
                                  else
                                    await getNotificationAzanWithoutSound(
                                        context);
                                },
                                child: Center(
                                  child: Text(
                                    showAlerts[_isAzanSectionExpanded ? 1 : 0]
                                        [0],
                                    style: TextStyle(
                                        color: kMainAppColor01,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: new Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              // width: screenWidth,
                              height: _isAzanSectionExpanded ? 290 : 0,
                              onEnd: () {
                                setState(() {
                                  if (_isAzanSectionExpanded) {
                                    _hasAzanSectionCollapsingAnimationEnded =
                                        false;
                                    _hasAzanSectionExpandingAnimationEnded =
                                        true;
                                  } else {
                                    _hasAzanSectionCollapsingAnimationEnded =
                                        true;
                                    _hasAzanSectionExpandingAnimationEnded =
                                        false;
                                  }
                                });
                              },
                              child: _isAzanSectionExpanded ||
                                      _hasAzanSectionExpandingAnimationEnded
                                  ? Column(
                                      children: [
                                        for (int i = 0;
                                            i < kPrayersNames.length;
                                            i++)
                                          PrayerAlertsWidget(
                                            alerts: PrayerAlerts(
                                                alertsOn: [
                                                  allAlarms[i].before ?? false,
                                                  allAlarms[i].inTime ?? false,
                                                  allAlarms[i].after ?? false
                                                ],
                                                before: DateTime.now(),
                                                alert: mystr[i],
                                                after: DateTime.now(),
                                                PrayerNameIndex: i),
                                          )
                                      ],
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      CategoryButton(
                        shouldAddBorder: false,
                        text: "qibla",
                        onTap: () {
                          Navigator.pushNamed(context, QiblaScreen.route);
                        },
                        width: MediaQuery.of(context).size.width / 5,
                        style: kButtonTextStyleScheherazadeFontNormal.copyWith(
                          color: kMainAppColor03,
                          fontSize: 10,
                        ),
                      ),
                      // CategoryButton(
                      //   shouldAddBorder: false,
                      //   text: kSubCatergoriesNames[1][0],
                      //   onTap: () {},
                      //   width: MediaQuery.of(context).size.width / 5,
                      //   fontSize: 16,
                      //   style: kButtonTextStyleWhiteScheherazadeFontNormal
                      //       .copyWith(color: kMainAppColor03),
                      // ),
                      CategoryButton(
                        shouldAddBorder: false,
                        text: 'aboutus',
                        onTap: () {
                          Navigator.pushNamed(context, AboutusScreen.route);
                        },
                        width: MediaQuery.of(context).size.width / 5,
                        style: kButtonTextStyleScheherazadeFontNormal.copyWith(
                          color: kMainAppColor03,
                          fontSize: 10,
                        ),
                      ),
                      CategoryButton(
                        onTap: () => Navigator.pushNamed(
                          context,
                          QuranMainScreen.tajweedRoute,
                        ),
                        shouldAddBorder: false,
                        text: "quranmoj",
                        width: MediaQuery.of(context).size.width / 5,
                        style: kButtonTextStyleScheherazadeFontNormal.copyWith(
                          color: kMainAppColor03,
                          fontSize: 10,
                        ),
                      )
                      // ),
                      // CategoryButton(
                      //   shouldAddBorder: false,
                      //   text: "settings",
                      //   onTap: () {
                      //     Navigator.pushNamed(context, SettingScreen.route);
                      //   },
                      //   width: MediaQuery.of(context).size.width / 5,
                      //   fontSize: 16,
                      //   style: kButtonTextStyleWhiteScheherazadeFontNormal
                      //       .copyWith(color: kMainAppColor03),
                      // ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: kHeightForBanner,
                    child: banner == null
                        ? SizedBox(height: 20)
                        : AdWidget(ad: banner),
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: SideMenu(),
        endDrawer: SideMenu(),
      ),
    );
  }

  void updateJson() {
    var x = DateTime.now();
    if (x.add(Duration(days: currentday)).month == DateTime.now().month) {
      mystr[0] = json["data"][x.day + currentday]["timings"]["Fajr"];
      mystr[1] = json["data"][x.day + currentday]["timings"]["Sunrise"];
      mystr[2] = json["data"][x.day + currentday]["timings"]["Dhuhr"];
      mystr[3] = json["data"][x.day + currentday]["timings"]["Asr"];
      mystr[4] = json["data"][x.day + currentday]["timings"]["Maghrib"];
      mystr[5] = json["data"][x.day + currentday]["timings"]["Isha"];
      for (int i = 0; i < 6; i++) {
        mystr[i] = mystr[i].substring(0, 5);
        date.add(MyDate(
            hour: int.parse(mystr[i][0] + mystr[i][1]),
            minute: int.parse(mystr[i][3] + mystr[i][4])));

        if (int.parse(mystr[i][0] + mystr[i][1]) > 12) {
          mystr[i] = "0" +
              (int.parse(mystr[i][0] + mystr[i][1]) - 12).toString() +
              mystr[i].substring(2);
          mystr[i] += " PM";
        } else
          mystr[i] += " AM";
      }
    } else {
      //need to think what we will do here
    }
  }

  Future<void> getNotificationAzan(BuildContext context) async {
    int count = 0;
    for (int i = 0; i < 6; i++) {
      if (allAlarms[i].before) {
        var newMinute;
        var newHour;
        if (date[i].minute < 30) {
          newMinute = (date[i].minute - 30) % 60;
          newHour = (date[i].hour - 1) % 24;
        } else {
          newMinute = date[i].minute - 30;
          newHour = date[i].hour;
        }
        DateTime x = DateTime(2021, 9, 1, newHour, newMinute);
        await HomeScreen.notificationServices.schedulePrayerNotifications(
            count, x, "${kPrayersNames[i][0]}", "متبقى 30 دقيقه", '$count');
        count++;
      }
      if (allAlarms[i].inTime) {
        // print('i am now here');
        DateTime x = DateTime(2021, 9, 1, date[i].hour, date[i].minute);

        await HomeScreen.notificationServices
            .schedulePrayerWithSoundNotifications(
                count,
                x,
                "${kPrayersNames[i][0]}",
                "حان الآن أذان ${kPrayersNames[i][0]} ",
                '$count');
        count++;
      }

      if (allAlarms[i].after) {
        if (allAlarms[i].after) {
          var newMinute;
          var newHour;
          if (date[i].minute > 30) {
            newMinute = (date[i].minute + 30) % 60;
            newHour = (date[i].hour + 1) % 24;
          } else {
            newMinute = date[i].minute + 30;
            newHour = date[i].hour;
          }
          DateTime x = DateTime(2021, 9, 1, newHour, newMinute);
          await HomeScreen.notificationServices.schedulePrayerNotifications(
              count,
              x,
              "${kPrayersNames[i][0]}",
              "${kPrayersNames[i][0]} مر 30 دقيقه على ",
              '$count');
          count++;
        }
      }
    }
  } //await notificationServices.checkPendingNotificationRequests(context);

  Future<void> getAlarms() async {
    allAlarms = [];
    pref = await SharedPreferences.getInstance();
    for (int i = 0; i < 6; i++) {
      allAlarms.add(Alarm(after: true, before: true, inTime: true));
    }
    allAlarms[0].before = pref.getBool("0B") ?? true;
    print(allAlarms[0].before);
    allAlarms[0].inTime = pref.getBool("0T") ?? true;
    allAlarms[0].after = pref.getBool("0A") ?? true;

    allAlarms[1].before = pref.getBool("1B") ?? true;
    allAlarms[1].inTime = pref.getBool("1T") ?? true;
    allAlarms[1].after = pref.getBool("1A") ?? true;

    allAlarms[2].before = pref.getBool("2B") ?? true;
    allAlarms[2].inTime = pref.getBool("2T") ?? true;
    allAlarms[2].after = pref.getBool("2A") ?? true;

    allAlarms[3].before = pref.getBool("3B") ?? true;
    allAlarms[3].inTime = pref.getBool("3T") ?? true;
    allAlarms[3].after = pref.getBool("3A") ?? true;

    allAlarms[4].before = pref.getBool("4B") ?? true;
    allAlarms[4].inTime = pref.getBool("4T") ?? true;
    allAlarms[4].after = pref.getBool("4A") ?? true;

    allAlarms[5].before = pref.getBool("5B") ?? true;
    allAlarms[5].inTime = pref.getBool("5T") ?? true;
    allAlarms[5].after = pref.getBool("5A") ?? true;
  }

  @override
  void dispose() {
    // banner.dispose();
    super.dispose();
  }

  Future<void> getNotificationAzanWithoutSound(BuildContext context) async {
    int count = 0;
    for (int i = 0; i < 6; i++) {
      if (allAlarms[i].before) {
        var newMinute;
        var newHour;
        if (date[i].minute < 30) {
          newMinute = (date[i].minute - 30) % 60;
          newHour = (date[i].hour - 1) % 24;
        } else {
          newMinute = date[i].minute - 30;
          newHour = date[i].hour;
        }
        DateTime x = DateTime(2021, 9, 1, newHour, newMinute);
        await HomeScreen.notificationServices.schedulePrayerNotifications(
            count, x, "${kPrayersNames[i][0]}", "متبقى 30 دقيقه", '$count');
        count++;
      }
      if (allAlarms[i].inTime) {
        DateTime x = DateTime(2021, 9, 1, date[i].hour, date[i].minute);
        await HomeScreen.notificationServices.schedulePrayerNotifications(
            count,
            x,
            "${kPrayersNames[i][0]}",
            "حان الآن أذان ${kPrayersNames[i][0]} ",
            '$count');
        count++;
      }

      if (allAlarms[i].after) {
        var newMinute;
        var newHour;
        if (date[i].minute > 30) {
          newMinute = (date[i].minute + 30) % 60;
          newHour = (date[i].hour + 1) % 24;
        } else {
          newMinute = date[i].minute + 30;
          newHour = date[i].hour;
        }

        DateTime x = DateTime(2021, 9, 1, newHour, newMinute);
        await HomeScreen.notificationServices.schedulePrayerNotifications(
            count,
            x,
            "${kPrayersNames[i][0]}",
            "${kPrayersNames[i][0]} مر 30 دقيقه على ",
            '$count');
        count++;
      }
    }
  }

  void updatePrayerTime() {
    // var min = DateTime.now().minute;
    var hours = DateTime.now().hour;

    if (hours >= date[0].hour && hours <= date[1].hour)
      indexOfCurrentTime = 1;
    else if (hours >= date[1].hour && hours <= date[2].hour)
      indexOfCurrentTime = 2;
    else if (hours >= date[2].hour && hours <= date[3].hour)
      indexOfCurrentTime = 3;
    else if (hours >= date[3].hour && hours <= date[4].hour)
      indexOfCurrentTime = 4;
    else if (hours >= date[4].hour && hours <= date[5].hour)
      indexOfCurrentTime = 5;
    else
      indexOfCurrentTime = 0;
  }
}
