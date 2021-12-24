import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quranandsunnahapp/Classes/ad_state.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:quranandsunnahapp/Quran/quran_bloc.dart';
import 'package:quranandsunnahapp/Screens/about_us.dart';
import 'package:quranandsunnahapp/Screens/azkar_main_category.dart';
import 'package:quranandsunnahapp/Screens/azkar_main_screen.dart';
import 'package:quranandsunnahapp/Screens/azkar_submain_screen.dart';
import 'package:quranandsunnahapp/Screens/duaa_main_screen.dart';
import 'package:quranandsunnahapp/Screens/duaa_screen.dart';
import 'package:quranandsunnahapp/Screens/duaa_types.dart';
import 'package:quranandsunnahapp/Screens/hadith_book_chapter_content_screen.dart';
import 'package:quranandsunnahapp/Screens/hadith_book_chapters_screen.dart';
import 'package:quranandsunnahapp/Screens/hadith_books_main_screen.dart';
import 'package:quranandsunnahapp/Screens/home_screen.dart';
import 'package:quranandsunnahapp/Screens/qibla_screen.dart';
import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Screens/quran_main_screen.dart';
import 'package:quranandsunnahapp/Screens/quran_screen2.dart';
import 'package:quranandsunnahapp/Screens/settings_screen.dart';
import 'package:quranandsunnahapp/Screens/tafseer_screen.dart';
import 'package:quranandsunnahapp/Screens/telawa_screen.dart';
import 'package:quranandsunnahapp/Tafseer/tafseer_bloc.dart';
import 'package:quranandsunnahapp/Telawa/telawa_bloc.dart';
import 'package:quranandsunnahapp/ads/ads_bloc.dart';
import 'Hadith/hadith_bloc.dart';
import 'Screens/azkar_screen.dart';
import 'Screens/quran_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'bloc/azkar/azkar_bloc.dart';
import 'newQuran/newquran_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  final initFuture = MobileAds.instance.initialize();

  final adState = AdState(initFuture);

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'AR'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('ar', 'AR'),
      child: Provider.value(
        value: adState,
        child: MultiBlocProvider(providers: [
          BlocProvider<AdsBloc>(
            create: (context) => AdsBloc(),
          ),
          BlocProvider<TelawaBloc>(
            create: (context) => TelawaBloc(),
          ),
          BlocProvider<TafseerBloc>(
            create: (context) => TafseerBloc(),
          ),
          BlocProvider<QuranBloc>(create: (context) => QuranBloc()),
          BlocProvider<AzkarBloc>(create: (context) => AzkarBloc()),
          BlocProvider<HadithBloc>(create: (context) => HadithBloc()),
          BlocProvider<NewquranBloc>(create: (context) => NewquranBloc())
        ], child: MyApp()),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'القرآن و السنة',
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: kMainAppColor03,
          // displayColor: kMainAppColor01,
        ),
      ),
      darkTheme: ThemeData.dark(),
      initialRoute: HomeScreen.route,
      routes: {
        HomeScreen.route: (ctx) => HomeScreen(),
        QuranMainScreen.route: (ctx) => QuranMainScreen(),
        QuranMainScreen.tajweedRoute: (ctx) => QuranMainScreen(
              isMojawwad: true,
            ),
        QuranScreen.route: (ctx) =>
            QuranScreen(args: ModalRoute.of(ctx).settings.arguments),
        // QuranTajweedScreen.route: (ctx) => QuranTajweedScreen(),
        AzkarListScreen.route: (ctx) => AzkarListScreen(),
        QiblaScreen.route: (ctx) => QiblaScreen(),
        AzkarScreen.route: (ctx) =>
            AzkarScreen(azkarSubgroup: ModalRoute.of(ctx).settings.arguments),
        HadithBooksListScreen.route: (ctx) => HadithBooksListScreen(),
        HadithBookSubBooksListScreen.route: (ctx) =>
            HadithBookSubBooksListScreen(
                hadithSubBookScreenArguments:
                    ModalRoute.of(ctx).settings.arguments),
        HadithContentScreen.route: (ctx) => HadithContentScreen(
            hadithSubBookContentScreenArguments:
                ModalRoute.of(ctx).settings.arguments),
        TelawaScreen.route: (context) => TelawaScreen(),
        TafseerScreen.route: (context) => TafseerScreen(),
        AboutusScreen.route: (context) => AboutusScreen(),
        SettingScreen.route: (context) => SettingScreen(),
        DuaaTypesScreen.route: (context) => DuaaTypesScreen(
            duaaAzkar: ModalRoute.of(context).settings.arguments),
        QuranScreenAlt.route: (context) => QuranScreen(),
        DuaaScreen.route: (context) => DuaaScreen(
              duaaGroup: ModalRoute.of(context).settings.arguments,
            ),
        DuaaListScreen.route: (context) => DuaaListScreen(),
        AzkarMainCategory.route: (conext) => AzkarMainCategory(
              initialTab: ModalRoute.of(conext).settings.arguments,
            ),
        AzkarSubCategoryScreen.route: (context) => AzkarSubCategoryScreen(
              subAzkarList: ModalRoute.of(context).settings.arguments,
            )
      },
    );
  }
}
