import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quranandsunnahapp/Classes/ad_state.dart';
import 'package:quranandsunnahapp/Classes/book_tafseer.dart';
import 'package:quranandsunnahapp/Classes/file_downloader.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Classes/surah_metadata.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/download_progress_indicator.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:quranandsunnahapp/Tafseer/tafseer_bloc.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class TafseerScreen extends StatefulWidget {
  static final String route = "TafseerScreen";
  @override
  _TafseerScreenState createState() => _TafseerScreenState();
}

class _TafseerScreenState extends State<TafseerScreen> {
  int chosenTafseerBookIndex;
  int indexForSurah;
  List<int> listOfAllNumOfAyahs = [];
  int indexForAyah;
  List<Icon> downloadStatus = [
    Icon(Icons.file_download),
    Icon(
      Icons.verified,
      color: Colors.green,
    ),
    Icon(Icons.delete_forever_sharp),
  ];
  TafseerBloc tafseerBloc;
  BannerAd banner;

  @override
  void initState() {
    print('tafseer initState');
    super.initState();
    tafseerBloc = BlocProvider.of<TafseerBloc>(context);
    tafseerBloc.add(GettingSurahMetadataEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initalization.then((status) {
      if (mounted) {
        setState(() {
          banner = adState.createBannerAd(adState.bannerAdUnitId)..load();
        });
      }
    });
  }

  @override
  void dispose() {
    print('dispose of tafseer screen');
    FilesDownloader.closeDownload();
    // tafseerBloc.add(CancelDownloadingTafseerBookEvent(
    //     tafseerBloc.tafseerBooks[chosenTafseerBookIndex].id));
    // tafseerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      backgroundColor: kMainAppColor02,
      appBar: AppBar(
        backgroundColor: kMainAppColor01,
        leading: BlocBuilder<TafseerBloc, TafseerState>(
          bloc: tafseerBloc,
          builder: (context, state) {
            return BackButton(
              color: kMainAppColor03,
              onPressed: () {
                if (state is TafseerInDownloadingState) {
                  tafseerBloc
                      .add(CancelDownloadingTafseerBookEvent(state.bookId));
                  Navigator.pop(context);
                } else
                  Navigator.pop(context);
              },
            );
          },
        ),
        title: Text(
          "tafseer",
          style: kAppBarTitleStyle,
        ).tr(),
        centerTitle: true,
        actions: [ChangeLanguageButton(), MenuButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<TafseerBloc, TafseerState>(
          bloc: tafseerBloc,
          builder: (context, state) {
            if (state is TafseerBooksListDownloadedState) {
              // print('TafseerBooksListDownloadedState');
              return getDropMenuWidget(
                  state.surahsMetadata, state.tafseerBooks, 0);
            } else if (state is TafseerBookNotDownloadedState) {
              // print('TafseerBookNotDownloadedState');
              return getDropMenuWidget(state.surahsMetadata, state.allBooks, 0);
            } else if (state is TafseerInDownloadingState) {
              // print('TafseerInDownloadingState');
              if (state.progress == 100) {
                print('finished download');

                tafseerBloc.add(TafseerFinishedDownloadingEvent(
                    tafseerBloc.surahsMetadata,
                    tafseerBloc.tafseerBooks,
                    state.bookId));
                return getDropMenuWidget(
                    tafseerBloc.surahsMetadata, tafseerBloc.tafseerBooks, 1);
              } else {
                tafseerBloc.add(
                    DownloadingTafseerBookEvent(state.bookId, state.progress));

                return DownloadProgressIndicator(
                  downloadPercentege: state.progress,
                );
              }
            } else if (state is TafseerTextLoadedSuccessfullyState) {
              // print('TafseerTextLoadedSuccessfullyState');
              return SingleChildScrollView(
                child: Column(
                  children: [
                    getDropMenuWidget(
                        state.surahsMetadata, tafseerBloc.tafseerBooks, 1),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(33),
                            border:
                                Border.all(color: kMainAppColor01, width: 2)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(state.text,
                              style: TextStyle(
                                  color: kMainAppColor01,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                              textDirection: HelperMethods.isArabic(context)
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              textAlign: TextAlign.justify),
                        ),
                      ),
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
              );
            } else if (state is TafseerBookDownloadedState) {
              // print('TafseerBookDownloadedState');
              // tafseerBloc.surahsMetadata.forEach((surah) {
              //   print(surah.arabicName);
              // });
              // tafseerBloc.tafseerBooks.forEach((book) {
              //   print(book.bookName);
              // });

              return getDropMenuWidget(
                  tafseerBloc.surahsMetadata, tafseerBloc.tafseerBooks, 1);
            } else {
              print('loading');
              return Center(child: HelperMethods.loadingWidget);
            }
          },
        ),
      ),
    );
  }

  Widget getDropMenuWidget(List<SurahMetadata> surahsMetadata,
      List<TafseerBook> allBooks, int status) {
    return Column(
      children: [
        Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(33),
                border: Border.all(color: kMainAppColor01, width: 2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: downloadStatus[status],
                  onPressed: () {
                    // print(statusOfDownload.toString()+" whattt");
                    if (status == 0) {
                      // print('requesting to download tafseer book');
                      tafseerBloc.add(StartDownloadBookEvent(
                          allBooks[chosenTafseerBookIndex].bookName,
                          allBooks[chosenTafseerBookIndex].id));
                    }
                  },
                  iconSize: 20,
                ),
                DropdownButton(
                  hint: Container(
                    width: MediaQuery.of(context).size.width * 0.485,
                    child: Center(
                      child: Text(
                        "PleaseChooseBook",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ).tr(),
                    ),
                  ),
                  value: chosenTafseerBookIndex,
                  onChanged: (newIndex) {
                    tafseerBloc.add(CheckTafseerBookFileExistEvent(
                        allBooks[newIndex].bookName, allBooks[newIndex].id));
                    // print(
                    //     "checking if tafseer book ${allBooks[newIndex].bookName} exists.");
                    setState(() {
                      chosenTafseerBookIndex = newIndex;
                    });
                  },
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: kMainAppColor01,
                  ),
                  items: allBooks.map((book) {
                    return DropdownMenuItem(
                        value: book.index,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.485,
                          child: Center(
                            child: Text(
                              book.bookName,
                              style: TextStyle(
                                  color: kMainAppColor03,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ));
                  }).toList(),
                  dropdownColor: kMainAppColor01,
                  selectedItemBuilder: (context) {
                    return allBooks.map((book) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.485,
                        child: Center(
                          child: Text(book.bookName,
                              style: TextStyle(
                                  color: kMainAppColor01,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                      );
                    }).toList();
                  },
                ),
                const SizedBox(
                  width: 27,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.17,
                  child: Text(
                    "chooseBook",
                    style: TextStyle(
                        color: kMainAppColor01,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ).tr(),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Visibility(
            visible: status == 1,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(33),
                  border: Border.all(color: kMainAppColor01, width: 2)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton(
                      hint: Container(
                        width: MediaQuery.of(context).size.width * 0.485,
                        child: Center(
                          child: Text(
                            "chooseSurah",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                      ),
                      value: indexForSurah,
                      onChanged: (newIndex) {
                        setState(() {
                          indexForAyah = 1;
                          indexForSurah = newIndex;
                          listOfAllNumOfAyahs = [];
                          for (int i = 0;
                              i < surahsMetadata[indexForSurah].numOfAyah;
                              i++) {
                            listOfAllNumOfAyahs.add(i + 1);
                          }
                        });
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: kMainAppColor01,
                      ),
                      items: surahsMetadata.map((surah) {
                        return DropdownMenuItem(
                            value: surah.index,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.485,
                              child: Center(
                                child: Text(
                                  HelperMethods.isArabic(context)
                                      ? surah.arabicName
                                      : surah.englishName,
                                  style: TextStyle(
                                      color: kMainAppColor03,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ));
                      }).toList(),
                      dropdownColor: kMainAppColor01,
                      selectedItemBuilder: (context) {
                        return surahsMetadata.map((surah) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.485,
                            child: Center(
                              child: Text(
                                  HelperMethods.isArabic(context)
                                      ? surah.arabicName
                                      : surah.englishName,
                                  style: TextStyle(
                                      color: kMainAppColor01,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          );
                        }).toList();
                      },
                    ),
                    const SizedBox(
                      width: 27,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        "chooseSurah",
                        style: TextStyle(
                            color: kMainAppColor01,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ).tr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Visibility(
            visible: status == 1,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(33),
                  border: Border.all(color: kMainAppColor01, width: 2)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton(
                      hint: Container(
                        width: MediaQuery.of(context).size.width * 0.485,
                        child: Center(
                          child: Text(
                            "chooseAyah",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                      ),
                      value: indexForAyah,
                      onChanged: (newIndex) {
                        setState(() {
                          indexForAyah = newIndex;
                          print("i am hereee $indexForAyah");
                        });
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: kMainAppColor01,
                      ),
                      items: listOfAllNumOfAyahs.map((ayah) {
                        return DropdownMenuItem(
                            value: ayah,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.485,
                              child: Center(
                                child: Text(
                                  ayah.toString(),
                                  style: TextStyle(
                                      color: kMainAppColor03,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ));
                      }).toList(),
                      dropdownColor: kMainAppColor01,
                      selectedItemBuilder: (context) {
                        return listOfAllNumOfAyahs.map((ayah) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.485,
                            child: Center(
                              child: Text(ayah.toString(),
                                  style: TextStyle(
                                      color: kMainAppColor01,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          );
                        }).toList();
                      },
                    ),
                    const SizedBox(
                      width: 27,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        "chooseAyah",
                        style: TextStyle(
                            color: kMainAppColor01,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ).tr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45.0),
                  color: kMainAppColor01),
              child: Center(
                child: Text(
                  "ShowVerseInterpretation",
                  style: TextStyle(
                      color: kMainAppColor03,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ).tr(),
              ),
            ),
            onTap: () {
              if (status == 1)
                tafseerBloc.add(GetAyahTafseerEvent(
                    chosenTafseerBookIndex + 1,
                    indexForSurah + 1,
                    listOfAllNumOfAyahs[indexForAyah - 1],
                    allBooks[chosenTafseerBookIndex].bookName));
            },
          ),
        )
      ],
    );
  }
}
