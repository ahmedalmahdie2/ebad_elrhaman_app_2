import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Classes/DuaaModel.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/main_category_button.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:quranandsunnahapp/Screens/duaa_screen.dart';

class DuaaListScreen extends StatefulWidget {
  static const String route = 'DuaaListScreen';
  @override
  _DuaaListScreenState createState() => _DuaaListScreenState();
}

dynamic duaaFileContent;
List<DuaaGroup> listOfGroups = [];

class _DuaaListScreenState extends State<DuaaListScreen> {
  @override
  void initState() {
    super.initState();
    () async {
      HelperMethods.loadDuaaFile().then((value) {
        duaaFileContent = value;
        compute(HelperMethods.parseDuaa, duaaFileContent).then(
          (value) {
            print('we\'ve parsed duaa');
            if (mounted)
              setState(() {
                listOfGroups = value;
              });
            // azkars.forEach((azkar) {
            //   print(azkar.azkarGroup);
            //   azkar.azkar.forEach((zekr) {
            //     print(zekr.zekr);
            //   });
            // });
          },
        );
      });
    }();
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
          'جوامع الدعاء',
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

  List<Widget> getPrayersCategories() {
    List<Widget> prayers = [];

    for (int i = 0; i < listOfGroups.length; i++) {
      prayers.add(
        CategoryButton(
          shouldAddBorder: false,
          text: listOfGroups[i].duaaNameGroup,
          onTap: () {
            Navigator.pushNamed(context, DuaaScreen.route,
                arguments: listOfGroups[i]);
          },
          width: MediaQuery.of(context).size.width / 3,
          fontSize: 25,
          style: kButtonTextStyleScheherazadeFontNormal.copyWith(
              color: kMainAppColor05),
        ),
      );
    }

    return prayers;
  }
}
