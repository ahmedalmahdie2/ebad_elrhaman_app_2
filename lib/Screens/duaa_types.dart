import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Classes/azkar_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/main_category_button.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';

import 'azkar_screen.dart';

class DuaaTypesScreen extends StatefulWidget {
  static String route = "duaaTypes";
  final AzkarGroupData duaaAzkar;
  DuaaTypesScreen({this.duaaAzkar});
  @override
  _DuaaTypesScreenState createState() => _DuaaTypesScreenState();
}

class _DuaaTypesScreenState extends State<DuaaTypesScreen> {
  List<Widget> getPrayersCategories() {
    // List<Widget> prayers = [];
    // kMainPrayersNames.forEach((prayer) {
    //   prayers.add(
    //     CategoryButton(
    //       shouldAddBorder: false,
    //       text: prayer,
    //       onTap: () {
    //         print(prayer);
    //         Navigator.pushNamed(context, AzkarScreen.route,
    //             arguments: azkars[kMainPrayersNames.indexOf(prayer)]);
    //       },
    //       width: MediaQuery.of(context).size.width / 3,
    //       fontSize: 30,
    //       style: kButtonTextStyleWhiteScheherazadeFontNormal.copyWith(
    //           color: kMainAppColor05),
    //     ),
    //   );
    // });
    // print(widget.duaaAzkar.subgroups[9].azkarGroupNames);
    return [Text("hello")];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainAppColor02,
      appBar: AppBar(
        backgroundColor: kMainAppColor01,
        leading: BackButton(
          color: kMainAppColor03,
        ),
        title: Text(
          'أنواع جوامع الدعاء',
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
