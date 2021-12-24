import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quranandsunnahapp/Classes/ad_state.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/loading_indicator.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/qiblah_compass.dart';
import 'package:quranandsunnahapp/Components/qiblah_maps.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblaScreen extends StatefulWidget {
  static const String route = 'qiblahScreen';

  @override
  _QiblaScreenState createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();
  // BannerAd banner;
  // //final adState=HomeScreen().
  // @override

  // void didChangeDependencies()
  // {
  //     super.didChangeDependencies();
  //     final adState=Provider.of<AdState>(context);
  //     adState.initalization.then((status) {
  //     if(mounted)
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
      drawer: SideMenu(),
      // bottomNavigationBar: Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: kHeightForBanner,
      //   child: banner==null?SizedBox(height: 20):AdWidget(ad:banner),

      // ),
      appBar: AppBar(
        backgroundColor: kMainAppColor01,
        leading: BackButton(
          color: kMainAppColor03,
        ),
        title: Text(
          'القبلة',
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        actions: [ChangeLanguageButton(), MenuButton()],
        // actions: [LangButton(), MenuButton()],
      ),
      backgroundColor: kMainAppColor02,
      body: SafeArea(
        child: FutureBuilder(
          future: _deviceSupport,
          builder: (_, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return LoadingIndicator();
            if (snapshot.hasError)
              return Center(
                child: Text("Error: ${snapshot.error.toString()}"),
              );

            if (snapshot.data)
              return QiblahCompass();
            else
              return QiblahMaps();
          },
        ),
      ),
    );
  }
}
