import 'dart:convert';
import 'dart:isolate';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Classes/local_quran_loader.dart';
import 'package:quranandsunnahapp/Classes/quran_data.dart';
import 'package:quranandsunnahapp/Classes/surah_metadata.dart';
import 'package:quranandsunnahapp/Classes/tafseer_methods.dart';
import 'package:quranandsunnahapp/Components/Page_widget.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Components/surah_widget.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Quran/quran_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:quranandsunnahapp/Screens/quran_screen.dart';
import 'dart:io' as io;

import 'package:quranandsunnahapp/Screens/tafseer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranMainScreen extends StatefulWidget {
  static const String route = 'QuranMainScreen';
  static const String tajweedRoute = 'QuranMojawwadMainScreen';
  static SharedPreferences pref;
  final bool isMojawwad;
  QuranMainScreen({this.isMojawwad = false});

  @override
  _QuranMainScreenState createState() => _QuranMainScreenState();
}

class _QuranMainScreenState extends State<QuranMainScreen>
    with CanListenToQuranLoadingEventMixin {
  // Widget quranWidget;
  // String title = '';
  // int selectedSurahIndex = 0;
  // List<SurahMetadata> surahMetadata;
  // List<Widget> myPageViews = []..length = 114;
  QuranBloc quranBloc;
  List<QuranAyahData> bookmarkedAyat = [];

  @override
  void initState() {
    print('quran main screen init state');
    super.initState();

    // BlocProvider.of<QuranBloc>(context).add(QuranInitEvent());
    quranBloc = BlocProvider.of<QuranBloc>(context);
    quranBloc.add(QuranInitEvent(isMojawwad: widget.isMojawwad));
    LocalQuranJsonFileLoader.initializeSavedData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool firstTime = true;
  int surahNum;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 2,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kMainAppColor01,
          automaticallyImplyLeading: false,
          titleSpacing: 15,
          title: Container(
            // color: kMainAppColor03,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BackButton(
                  color: kMainAppColor03,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'القرآن الكريم',
                      style: kAppBarTitleStyle,
                    ),
                  ),
                ),
                MenuButton(),
              ],
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: ListTile(
                  trailing: Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  contentPadding: EdgeInsets.zero,
                  title: Center(
                      child: Text(
                    'المفضلة',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              Tab(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  trailing: Icon(
                    Icons.menu_book_rounded,
                    size: 25,
                    color: kMainAppColor03,
                  ),
                  title: Center(
                      child: Text('الأجزاء',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold))),
                  horizontalTitleGap: 0,
                ),
              ),
              Tab(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  trailing: Icon(
                    Icons.menu_book_rounded,
                    size: 25,
                    color: kMainAppColor03,
                  ),
                  title: Center(
                      child: Text('السور',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold))),
                  horizontalTitleGap: 0,
                ),
              ),
            ],
            // onTap: (indx) {
            //   if (indx == 0) get_favourite();
            // },
          ),
        ),
        backgroundColor: kMainAppColor02,
        body: TabBarView(
          children: [
            SafeArea(
                child: BlocBuilder<QuranBloc, QuranState>(
                    bloc: quranBloc,
                    builder: (context, state) {
                      if (state is SurahsMetaDataLoadedSuccessfullyState) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              textDirection: TextDirection.rtl,
                              children:
                                  LocalQuranJsonFileLoader.getBookmarkedAyahs()
                                      .map((bookmark) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        HelperMethods.parseHtmlString(bookmark
                                                .text
                                                .substring(
                                                    0,
                                                    bookmark.text.length >= 50
                                                        ? 50
                                                        : bookmark
                                                            .text.length) +
                                            (bookmark.text.length >= 50
                                                ? ' ... '
                                                : '') +
                                            ' ${String.fromCharCode(LocalQuranJsonFileLoader.getAyahIntNumberInQuranFont(bookmark.ayahNumber))} '),
                                        style:
                                            kUthmaniHafs1FontTextStyle.copyWith(
                                          fontSize: 20,
                                          color: kMainQuranLightColor01,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${LocalQuranJsonFileLoader.quranSurahsMetadata[bookmark.surahNumber - 1].arabicName} , صفحة ${HelperMethods.convertDigitsIntoArabic(bookmark.pageNumber)}',
                                        style: kAppDefaultTextStyle.copyWith(
                                            fontSize: 12,
                                            color: kAppDefaultTextStyle.color
                                                .withOpacity(0.5)),
                                      ),
                                      onTap: () {
                                        quranBloc.add(ChangeQuranPageEvent(
                                            bookmark.pageNumber - 1,
                                            isMojawwad: widget.isMojawwad));
                                      },
                                      trailing: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.bookmark_outlined,
                                            color: kMainAppColor01,
                                          ),
                                          onPressed: () {
                                            print('removing: $bookmark');
                                            List<String> stringOfIndexes = [];
                                            stringOfIndexes.addAll(
                                                QuranMainScreen.pref
                                                    .getStringList(
                                                        "quranBookmarks"));
                                            stringOfIndexes.remove(bookmark
                                                    .surahNumber
                                                    .toString() +
                                                ':' +
                                                bookmark.ayahNumber.toString());
                                            QuranMainScreen.pref.setStringList(
                                                "quranBookmarks",
                                                stringOfIndexes);
                                            setState(() {});
                                          }),
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: kMainAppColor01.withOpacity(0.5),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      } else if (state
                          is QuranSinglePageLoadedSuccessfullyState) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              textDirection: TextDirection.rtl,
                              children:
                                  LocalQuranJsonFileLoader.getBookmarkedAyahs()
                                      .map((bookmark) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        HelperMethods.parseHtmlString(bookmark
                                                .text
                                                .substring(
                                                    0,
                                                    bookmark.text.length >= 50
                                                        ? 50
                                                        : bookmark
                                                            .text.length) +
                                            (bookmark.text.length >= 50
                                                ? ' ... '
                                                : '') +
                                            ' ${String.fromCharCode(LocalQuranJsonFileLoader.getAyahIntNumberInQuranFont(bookmark.ayahNumber))} '),
                                        style:
                                            kUthmaniHafs1FontTextStyle.copyWith(
                                          fontSize: 20,
                                          color: kMainQuranLightColor01,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${LocalQuranJsonFileLoader.quranSurahsMetadata[bookmark.surahNumber - 1].arabicName} , صفحة ${bookmark.ayahNumber}',
                                        style: kAppDefaultTextStyle.copyWith(
                                            fontSize: 12,
                                            color: kAppDefaultTextStyle.color
                                                .withOpacity(0.5)),
                                      ),
                                      onTap: () {
                                        quranBloc.add(ChangeQuranPageEvent(
                                            bookmark.pageNumber - 1,
                                            isMojawwad: widget.isMojawwad));
                                      },
                                      trailing: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.bookmark_outlined,
                                            color: kMainAppColor01,
                                          ),
                                          onPressed: () {
                                            print('removing: $bookmark');
                                            List<String> stringOfIndexes = [];
                                            stringOfIndexes.addAll(
                                                QuranMainScreen.pref
                                                    .getStringList(
                                                        "quranBookmarks"));
                                            stringOfIndexes.remove(bookmark
                                                    .surahNumber
                                                    .toString() +
                                                ':' +
                                                bookmark.ayahNumber.toString());
                                            QuranMainScreen.pref.setStringList(
                                                "quranBookmarks",
                                                stringOfIndexes);
                                            setState(() {});
                                          }),
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: kMainAppColor01.withOpacity(0.5),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      } else if (state is QuranInitialState) {
                        print('quran main screen QuranInitialState');

                        return Center(child: HelperMethods.loadingWidget);
                      } else
                        return Container();
                    })),
            SafeArea(
              child: BlocBuilder<QuranBloc, QuranState>(
                bloc: quranBloc,
                builder: (context, state) {
                  if (state is QuranInitialState) {
                    print('quran main screen QuranInitialState');

                    return Center(child: HelperMethods.loadingWidget);
                  } else if (state is SurahsMetaDataLoadedSuccessfullyState) {
                    // print(
                    //     'quran main screen has: ${LocalQuranJsonFileLoader.quranSurahsMetadata.length} surahs');

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          textDirection: TextDirection.rtl,
                          children:
                              LocalQuranJsonFileLoader.quranJuzData.map((juz) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                      'الجزء ${HelperMethods.convertDigitsIntoArabic(LocalQuranJsonFileLoader.quranJuzData.indexOf(juz) + 1)}',
                                      style:
                                          kButtonTextStyleWhiteAmiriFontNormal
                                              .copyWith(
                                                  color: kMainAppColor01)),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        QuranScreen.route,
                                        arguments: QuranScreenArguments(
                                          pageIndex: LocalQuranJsonFileLoader
                                                      .getFirstAyahInJuz(juz)
                                                  .pageNumber -
                                              1,
                                          isMojawwad: widget.isMojawwad,
                                        ));
                                  },
                                  trailing: Text(
                                    'صفحة ${HelperMethods.convertDigitsIntoArabic(LocalQuranJsonFileLoader.getFirstAyahInJuz(juz).pageNumber)}',
                                    style: kAppDefaultTextStyle,
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: kMainAppColor01.withOpacity(0.5),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  } else if (state is QuranSinglePageLoadedSuccessfullyState) {
                    print(
                        'quran main screen has: ${LocalQuranJsonFileLoader.quranSurahsMetadata.length} surahs');

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          textDirection: TextDirection.rtl,
                          children:
                              LocalQuranJsonFileLoader.quranJuzData.map((juz) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                      'الجزء ${HelperMethods.convertDigitsIntoArabic(LocalQuranJsonFileLoader.quranJuzData.indexOf(juz) + 1)}',
                                      style: kUthmaniHafs1FontTextStyle
                                          .copyWith(color: kMainAppColor01)),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        QuranScreen.route,
                                        arguments: QuranScreenArguments(
                                          pageIndex: LocalQuranJsonFileLoader
                                                      .getFirstAyahInJuz(juz)
                                                  .pageNumber -
                                              1,
                                          isMojawwad: widget.isMojawwad,
                                        ));
                                  },
                                  trailing: Text(
                                    'صفحة ${LocalQuranJsonFileLoader.getFirstAyahInJuz(juz).pageNumber}',
                                    style: kAppDefaultTextStyle,
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: kMainAppColor01.withOpacity(0.5),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  } else {
                    print('quran main screen $state');
                    return Center(child: HelperMethods.loadingWidget);
                  }
                },
              ),
            ),
            SafeArea(
              child: BlocBuilder<QuranBloc, QuranState>(
                bloc: quranBloc,
                builder: (context, state) {
                  if (state is QuranInitialState) {
                    print('quran main screen QuranInitialState');

                    return Center(child: HelperMethods.loadingWidget);
                  } else if (state is SurahsMetaDataLoadedSuccessfullyState) {
                    print(
                        'quran main screen has: ${LocalQuranJsonFileLoader.quranSurahsMetadata.length} surahs');

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          textDirection: TextDirection.rtl,
                          children: LocalQuranJsonFileLoader.quranSurahsMetadata
                              .map((surah) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: Text(
                                    '${HelperMethods.convertDigitsIntoArabic(surah.index)}',
                                    style: kAppDefaultTextStyle,
                                  ),
                                  title: Text('${surah.arabicName}',
                                      style: kUthmaniHafs1FontTextStyle
                                          .copyWith(color: kMainAppColor01)),
                                  subtitle: Text(
                                    'عدد أياتها ${HelperMethods.convertDigitsIntoArabic(surah.numOfAyah)} آية',
                                    style: kAppDefaultTextStyle.copyWith(
                                        fontSize: 12,
                                        color: kAppDefaultTextStyle.color
                                            .withOpacity(0.5)),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(QuranScreen.route,
                                            arguments: QuranScreenArguments(
                                              pageIndex: surah.startPage - 1,
                                              isMojawwad: widget.isMojawwad,
                                            ));
                                  },
                                  trailing: Text(
                                    'صفحة ${HelperMethods.convertDigitsIntoArabic(surah.startPage)}',
                                    style: kAppDefaultTextStyle,
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: kMainAppColor01.withOpacity(0.5),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  } else if (state is QuranSinglePageLoadedSuccessfullyState) {
                    print(
                        'quran main screen has: ${LocalQuranJsonFileLoader.quranSurahsMetadata.length} surahs');

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          textDirection: TextDirection.rtl,
                          children: LocalQuranJsonFileLoader.quranSurahsMetadata
                              .map((surah) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: Text(
                                    '${HelperMethods.convertDigitsIntoArabic(surah.index)}',
                                    style: kAppDefaultTextStyle,
                                  ),
                                  title: Text('${surah.arabicName}',
                                      style: kUthmaniHafs1FontTextStyle
                                          .copyWith(color: kMainAppColor01)),
                                  subtitle: Text(
                                    'عدد أياتها ${HelperMethods.convertDigitsIntoArabic(surah.numOfAyah)} آية',
                                    style: kAppDefaultTextStyle.copyWith(
                                        fontSize: 12,
                                        color: kAppDefaultTextStyle.color
                                            .withOpacity(0.5)),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(QuranScreen.route,
                                            arguments: QuranScreenArguments(
                                              pageIndex: surah.startPage - 1,
                                              isMojawwad: widget.isMojawwad,
                                            ));
                                  },
                                  trailing: Text(
                                    'صفحة ${HelperMethods.convertDigitsIntoArabic(surah.startPage)}',
                                    style: kAppDefaultTextStyle,
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: kMainAppColor01.withOpacity(0.5),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  } else {
                    print('quran main screen $state');
                    return Center(child: HelperMethods.loadingWidget);
                  }
                },
              ),
            ),
          ],
        ),
        drawer: SideMenu(),
        // endDrawer: SideMenu(),
      ),
    );
  }
}
