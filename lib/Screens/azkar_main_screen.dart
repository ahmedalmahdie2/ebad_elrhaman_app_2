import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quranandsunnahapp/Classes/ad_state.dart';
import 'package:flutter/foundation.dart';
import 'package:quranandsunnahapp/Classes/azkar_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/main_category_button.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Screens/duaa_main_screen.dart';
import 'package:quranandsunnahapp/Screens/duaa_types.dart';
import 'azkar_screen.dart';

class AzkarListScreen extends StatefulWidget {
  static const String route = 'AzkarListScreen';
  final int titleIndex = 2;
  @override
  _AzkarListScreenState createState() => _AzkarListScreenState();
}

class _AzkarListScreenState extends State<AzkarListScreen> {
  List<Widget> getPrayersCategories() {
    List<Widget> prayers = [];
    kMainPrayersNames.forEach((prayer) {
      prayers.add(
        CategoryButton(
          shouldAddBorder: false,
          text: prayer,
          onTap: () {
            print(prayer);
            if (prayer == "جوامع الدعاء") {
              Navigator.pushNamed(
                context,
                DuaaListScreen.route,
              );
            } else
              Navigator.pushNamed(context, AzkarScreen.route,
                  arguments: azkars[kMainPrayersNames.indexOf(prayer)]);
          },
          width: MediaQuery.of(context).size.width / 3,
          fontSize: 30,
          style: kButtonTextStyleScheherazadeFontNormal.copyWith(
              color: kMainAppColor05),
        ),
      );
    });
    return prayers;
  }

  // BannerAd banner;
  //final adState=HomeScreen().
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final adState = Provider.of<AdState>(context);
  //   adState.initalization.then((status) {
  //     setState(() {
  //       banner = adState.createBannerAd(adState.bannerAdUnitId)..load();
  //     });
  //   });
  // }

  List<AzkarGroupData> azkars = [];
  Map<String, dynamic> azkarFileContent;

  @override
  void initState() {
    super.initState();

    HelperMethods.loadAzkarFile().then((value) {
      azkarFileContent = value;
      compute(HelperMethods.parseAzkar, azkarFileContent).then(
        (value) {
          azkars = value;
          print('we\'ve parsed azkar');
          // azkars.forEach((azkar) {
          //   print(azkar.azkarGroup);
          //   azkar.azkar.forEach((zekr) {
          //     print(zekr.zekr);
          //   });
          // });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: kHeightForBanner,
      //   child: banner == null ? SizedBox(height: 20) : AdWidget(ad: banner),
      // ),
      backgroundColor: kMainAppColor02,
      appBar: AppBar(
        backgroundColor: kMainAppColor01,
        leading: BackButton(
          color: kMainAppColor03,
        ),
        title: Text(
          HelperMethods.getMainCategoryScreenTitle(widget.titleIndex),
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        actions: [ChangeLanguageButton(), MenuButton()],
        // actions: [LangButton(), MenuButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                // runAlignment: WrapAlignment.center,
                // alignment: WrapAlignment.start,
                spacing: 40,
                runSpacing: 10,
                children: getPrayersCategories(),
              ),
            ),
          ),
        ),
      ),
      drawer: SideMenu(),
      endDrawer: SideMenu(),
    );
  }
}
