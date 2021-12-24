import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quranandsunnahapp/Classes/ad_state.dart';
import 'package:quranandsunnahapp/Classes/url_launcher.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/clipped_card.dart';
import 'package:quranandsunnahapp/Components/gradient_colors_decorated_container.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share/share.dart';
import 'dart:io' show Platform;

class AboutusScreen extends StatefulWidget {
  static String route = "AboutusScreen";

  @override
  _AboutusScreenState createState() => _AboutusScreenState();
}

class _AboutusScreenState extends State<AboutusScreen> {
  // BannerAd banner;
  // //final adState=HomeScreen().
  // @override
  // void didChangeDependencies()
  // {
  //     super.didChangeDependencies();
  //     final adState=Provider.of<AdState>(context);
  //     adState.initalization.then((status) {
  //       if(mounted)
  //       {
  //           setState(() {
  //         banner=adState.createBannerAd(adState.bannerAdUnitId)..load();
  //                    });
  //       }

  //     });

  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: kHeightForBanner,
      //   child: banner==null?SizedBox(height: 20):AdWidget(ad:banner),
      // ),
      backgroundColor: kMainAppColor02,
      appBar: AppBar(
        backgroundColor: kMainAppColor01,
        leading: BackButton(
          color: kMainAppColor03,
          onPressed: () async {
            // await _player.dispose();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'aboutus',
          style: kAppBarTitleStyle,
        ).tr(),
        centerTitle: true,
        actions: [ChangeLanguageButton(), MenuButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClippedCard(
          color: kMainAppColor01,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: ListTile(
                        trailing: Icon(
                          Icons.launch,
                          color: kMainAppColor03,
                        ),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: Image.asset(
                              'assets/images/facebookImage.png',
                              width: 35,
                              height: 35,
                            )),
                        title: Text('Facebook',
                            style: TextStyle(
                                color: kMainAppColor03,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                        onTap: () async {
                          await URLSetting.launchInBrowser(
                              "https://www.facebook.com");
                        },
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: kMainAppColor03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: ListTile(
                        trailing: Icon(
                          Icons.launch,
                          color: kMainAppColor03,
                        ),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: Image.asset(
                              'assets/images/email.jpeg',
                              width: 35,
                              height: 35,
                            )),
                        title: Text('Email',
                            style: TextStyle(
                                color: kMainAppColor03,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                        onTap: () async {
                          await URLSetting.launchInEmail(kGmailPlaceHolder);
                          print('hi');
                        },
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: kMainAppColor03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: ListTile(
                        trailing: Icon(
                          Icons.launch,
                          color: kMainAppColor03,
                        ),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: Image.asset(
                              'assets/images/website.png',
                              width: 35,
                              height: 35,
                            )),
                        title: Text('Website',
                            style: TextStyle(
                                color: kMainAppColor03,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                        onTap: () async {
                          await URLSetting.launchInBrowser(
                              kQuranAndSunnahDomain);
                        },
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: kMainAppColor03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: ListTile(
                        trailing: Icon(
                          Icons.launch,
                          color: kMainAppColor03,
                        ),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: Image.asset(
                              'assets/images/whatsapp.png',
                              width: 35,
                              height: 35,
                            )),
                        title: Text(kWhatsApp,
                            style: TextStyle(
                                color: kMainAppColor03,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                        onTap: () async {
                          URLSetting.openWhatsapp(kWhatsApp);
                        },
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: kMainAppColor03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: ListTile(
                        trailing: Icon(
                          Icons.launch,
                          color: kMainAppColor03,
                        ),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: Icon(
                              Icons.call_sharp,
                              color: kMainAppColor03,
                            )),
                        title: Text(kPhoneNumber,
                            style: TextStyle(
                                color: kMainAppColor03,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                        onTap: () async {
                          URLSetting.callPhone(kPhoneNumber);
                        },
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: kMainAppColor03,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: ListTile(
                        trailing: Icon(
                          Icons.launch,
                          color: kMainAppColor03,
                        ),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: Icon(
                              Icons.share,
                              color: kMainAppColor03,
                            )),
                        title: Text(kShare,
                            style: TextStyle(
                                color: kMainAppColor03,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                        onTap: ()  {
                          String aboutUS =
                              "القران والسنة تطبيق كامل يحتاجه كل مسلم، قم بتحميله الان :"
                              "https://play.google.com/store/apps/details?id=com.fastworld.quranandsunnahapp";
                          Share.share( aboutUS);

                        },
                      ),
                    ),
           
                    Divider(
                      thickness: 1.5,
                      color: kMainAppColor03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: ListTile(
                        trailing: Icon(
                          Icons.launch,
                          color: kMainAppColor03,
                        ),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: Icon(
                              Icons.star,
                              color: kMainAppColor03,
                            )),
                        title: Text(kRate,
                            style: TextStyle(
                                color: kMainAppColor03,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),

                        onTap: () async {
                          if (Platform.isAndroid) {
                            await URLSetting.launchInBrowser(
                                "https://play.google.com/store/apps/details?id=com.fastworld.quranandsunnahapp");
                          } else if (Platform.isIOS) {
                            await URLSetting.launchInBrowser(
                                "https://apps.apple.com/eg/app/%D8%A7%D9%84%D9%82%D8%B1%D8%A2%D9%86-%D8%A7%D9%84%D9%83%D8%B1%D9%8A%D9%85-%D9%88%D8%A7%D9%84%D8%B3%D9%86%D8%A9/id1563730047");
                          }

                        },
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: kMainAppColor03,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 0,top :16,right :0, bottom: 6),
                      child: Center(
                        child:
                            Text(' Quran and sunnah All Rights Reserved © 2021',style: TextStyle(fontSize: 13),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
