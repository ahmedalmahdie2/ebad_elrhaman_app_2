import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Screens/azkar_main_category.dart';
import 'package:quranandsunnahapp/Screens/duaa_main_screen.dart';
import 'package:quranandsunnahapp/Screens/hadith_books_main_screen.dart';
import 'package:quranandsunnahapp/Screens/qibla_screen.dart';
import 'package:quranandsunnahapp/Screens/quran_main_screen.dart';
import 'package:quranandsunnahapp/Screens/quran_screen.dart';
import 'package:quranandsunnahapp/Screens/tafseer_screen.dart';
import 'package:quranandsunnahapp/Screens/telawa_screen.dart';

import 'bordered_text.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Image.asset('assets/images/ebadelrahmanlogo.png'),
              ),
              Text(
                'القرآن والسنة',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          decoration: BoxDecoration(
            gradient: kMainLinearGradient,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, QuranMainScreen.route,
                arguments: false);
          },
          title: Center(
            child: BorderedText(
              text: 'القرآن',
              style:
                  kUthmaniHafs1FontTextStyle.copyWith(color: kMainAppColor01),
              minFontSize: 20,
              borderColor: Colors.white,
            ),
          ),
        ),
        Divider(
          color: kMainAppColor01,
          thickness: 1,
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, HadithBooksListScreen.route);
          },
          title: Center(
            child: BorderedText(
              text: 'الحديث',
              style:
                  kUthmaniHafs1FontTextStyle.copyWith(color: kMainAppColor01),
              minFontSize: 20,
              borderColor: Colors.white,
            ),
          ),
        ),
        Divider(
          color: kMainAppColor01,
          thickness: 1,
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, DuaaListScreen.route);
          },
          title: Center(
            child: BorderedText(
              text: 'جوامع الدعاء',
              style:
                  kUthmaniHafs1FontTextStyle.copyWith(color: kMainAppColor01),
              minFontSize: 20,
              borderColor: Colors.white,
            ),
          ),
        ),
        Divider(
          color: kMainAppColor01,
          thickness: 1,
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AzkarMainCategory.route, arguments: 1);
          },
          title: Center(
            child: BorderedText(
              text: 'الاذكار',
              style:
                  kUthmaniHafs1FontTextStyle.copyWith(color: kMainAppColor01),
              minFontSize: 20,
              borderColor: Colors.white,
            ),
          ),
        ),
        Divider(
          color: kMainAppColor01,
          thickness: 1,
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, TafseerScreen.route);
          },
          title: Center(
            child: BorderedText(
              text: 'التفسير',
              style:
                  kUthmaniHafs1FontTextStyle.copyWith(color: kMainAppColor01),
              minFontSize: 20,
              borderColor: Colors.white,
            ),
          ),
        ),
        Divider(
          color: kMainAppColor01,
          thickness: 1,
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, TelawaScreen.route);
          },
          title: Center(
            child: BorderedText(
              text: 'التلاوة',
              style:
                  kUthmaniHafs1FontTextStyle.copyWith(color: kMainAppColor01),
              minFontSize: 20,
              borderColor: Colors.white,
            ),
          ),
        ),
        Divider(
          color: kMainAppColor01,
          thickness: 1,
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, QiblaScreen.route);
          },
          title: Center(
            child: BorderedText(
              text: 'القبله',
              style:
                  kUthmaniHafs1FontTextStyle.copyWith(color: kMainAppColor01),
              minFontSize: 20,
              borderColor: Colors.white,
            ),
          ),
        ),
        Divider(
          color: kMainAppColor01,
          thickness: 1,
        ),

        //   Switch()
        // ListTile(
        //   onTap: () {
        //     Navigator.pop(context);
        //     ExternalLinkHandler.launchInBrowser(kPrivacyPolicyLink);
        //   },
        //   title: Center(
        //       child: Text(
        //           LanguageHandler.isArabic()
        //               ? 'سياسة الخصوصية'
        //               : 'Privacy policy',
        //           style: kPlantButtonTextStyle.copyWith(color: kCopperColor))),
        // ),
      ],
    ));
  }
}
