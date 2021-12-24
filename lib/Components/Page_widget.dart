import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quranandsunnahapp/Classes/file_downloader.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Classes/local_quran_loader.dart';
import 'package:quranandsunnahapp/Classes/quran_data.dart';
import 'package:quranandsunnahapp/Classes/tafseer_methods.dart';
import 'package:quranandsunnahapp/Components/surah_decorated_title.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quranandsunnahapp/Quran/quran_bloc.dart';
import 'package:quranandsunnahapp/Screens/quran_main_screen.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart' as easy;

import 'package:quranandsunnahapp/Screens/tafseer_screen.dart';
import 'package:share/share.dart';

class QuranPageWidget extends StatefulWidget {
  final QuranPageData pagetData;
  final int pageNum;
  static List<int> ayahHighlighted = [-1, -1];
  final bool isMojawwad;
  const QuranPageWidget(
      {this.pageNum, this.pagetData, this.isMojawwad = false});

  @override
  _QuranPageWidgetState createState() => _QuranPageWidgetState();
}

class _QuranPageWidgetState extends State<QuranPageWidget> {
  LongPressEndDetails toolbarPositionDetails;
  QuranAyahData selectedAyah;
  bool playing = false;
  AudioPlayer _player;

  bool onOff = false;
  double width;
  double screenFactor;
  double surahTitleFontSize;
  double ayahTextFontSize;
  bool isDrawn = false;
  Duration fullTime;

  bool isAyahBookmarked(QuranAyahData ayah) {
    return QuranMainScreen.pref != null &&
        QuranMainScreen.pref.getStringList("quranBookmarks") != null &&
        QuranMainScreen.pref.getStringList("quranBookmarks").contains(
            ayah.surahNumber.toString() + ':' + ayah.ayahNumber.toString());
  }

  Widget showToolbarForAyah(QuranAyahData ayah) {
    return Container(
      color: kMainAppColor01,
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            textDirection: TextDirection.rtl,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  !playing ? Icons.play_arrow : Icons.pause,
                  color: kMainAppColor03,
                  // size: MediaQuery.of(context).size.width / 15,
                ),
                onPressed: () async {
                  if (playing) {
                    playing = false;

                    _player.pause();
                  } else {
                    String url = 'www.fastworldsolutions.com';
                    String secondPart = "/islamic/public/api/quran/audio/" +
                        "51" +
                        "/" +
                        (QuranPageWidget.ayahHighlighted[0]).toString() +
                        "/" +
                        (QuranPageWidget.ayahHighlighted[1] - 1).toString();
                    print(url + secondPart);
                    http.Response response =
                        await http.get(Uri.https(url, secondPart));

                    playing = true;

                    if (response.statusCode == 200) {
                      String url = response.body;

                      _player.play(url);
                    }
                  }

                  setState(() {});
                },
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.menu_book_rounded,
                  color: kMainAppColor03,
                  // size: MediaQuery.of(context).size.width / 15,
                ),
                onPressed: () async {
                  final directory = await getApplicationDocumentsDirectory();
                  String filePath = directory.path;
                  var finalFileName = [
                    "تفسير_الجلالين.json",
                    'The_Meaning_of_the_Glorious_Koran.json'
                  ];
                  bool flag = await FilesDownloader.doesFileExist('Tafseer',
                      finalFileName[HelperMethods.isArabic(context) ? 0 : 1]);
                  print('does book exist: $flag');
                  if (flag) {
                    File file = File(
                        "$filePath/Tafseer/${finalFileName[HelperMethods.isArabic(context) ? 0 : 1]}");
                    String tafseerText = await TafseerMethods.getTafseerText(
                        HelperMethods.isArabic(context) ? 2 : 10,
                        QuranPageWidget.ayahHighlighted[0],
                        QuranPageWidget.ayahHighlighted[1] - 1,
                        BlocProvider.of<QuranBloc>(context).surahsMetadata,
                        file);

                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.black87,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: SingleChildScrollView(
                                child: Text(
                                  tafseerText,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.justify,
                                  textDirection: HelperMethods.isArabic(context)
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(
                          "TafseerBookNotDownloaded",
                          style: TextStyle(color: kMainAppColor01),
                        ).tr(),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text("PleaseDownloadTafseerBook").tr(),
                              Row(
                                children: [
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, TafseerScreen.route);
                                    },
                                    child: Text('حمل الآن'),
                                  ),
                                  Spacer(),
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('لاحقـاً'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  isAyahBookmarked(ayah)
                      ? Icons.bookmark_outlined
                      : Icons.bookmark_border,
                  color: kMainAppColor03,
                ),
                onPressed: () {
                  List<String> stringOfIndexes = [];
                  stringOfIndexes.addAll(
                      QuranMainScreen.pref.getStringList("quranBookmarks") ??
                          []);
                  if (!stringOfIndexes.contains(ayah.surahNumber.toString() +
                      ':' +
                      ayah.ayahNumber.toString())) {
                    stringOfIndexes.add(ayah.surahNumber.toString() +
                        ':' +
                        ayah.ayahNumber.toString());
                  } else {
                    stringOfIndexes.remove(ayah.surahNumber.toString() +
                        ':' +
                        ayah.ayahNumber.toString());
                  }
                  QuranMainScreen.pref
                      .setStringList("quranBookmarks", stringOfIndexes);
                  print(ayah.surahNumber.toString() +
                      ':' +
                      ayah.ayahNumber.toString());

                  setState(() {
                    if (onOff &&
                        QuranPageWidget.ayahHighlighted[0] ==
                            ayah.surahNumber &&
                        QuranPageWidget.ayahHighlighted[1] ==
                            ayah.ayahNumber + 1) {
                      onOff = false;
                      QuranPageWidget.ayahHighlighted = [-1, -1];
                      toolbarPositionDetails = null;
                      selectedAyah = null;
                    }
                  });
                },
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.share),
                  color: kMainAppColor03,
                  onPressed: () {
                    String aboutUS =
                        "\n للمزيد من الاذكار والادعيه قم بتحميل التطبيق من خلال جوجل بلاي "
                        "https://play.google.com/store/apps/details?id=com.fastworld.quranandsunnahapp";
                    Share.share(ayah.text + aboutUS);
                  })
            ],
          )),
    );
  }

  WidgetSpan getSurahDecoratedTitle(
      {String text, TextStyle style, bool isMaccan, int surahNumber}) {
    return WidgetSpan(
      child: SurahDecoratedTitle(
        style: style,
        text: text,
        isMaccan: isMaccan,
        surahNumber: surahNumber,
      ),
    );
  }

  List<InlineSpan> pageContent() {
    List<InlineSpan> pageSpanContent = [];

    int ayahIndexInPage = 0;
    widget.pagetData.ayatData.forEach(
      (ayah) {
        if (ayah.ayahNumber == 1) // surah start
        {
          /// add surah name
          // print('surahNamr: ${kSurahsNamesGlyphs[ayah.surahNumber - 1]}');
          pageSpanContent.add(
            getSurahDecoratedTitle(
                text: LocalQuranJsonFileLoader.getSurahInQuranFont(
                    ayah.surahNumber - 1),
                style: kUthmaniHafs1FontTextStyle.copyWith(
                    fontSize: surahTitleFontSize,
                    color: kMainQuranLightColor01,
                    // fontFamily: 'THULUTH',
                    height: 2),
                surahNumber: ayah.surahNumber,
                isMaccan: LocalQuranJsonFileLoader
                    .quranSurahsMetadata[ayah.surahNumber - 1].isMaccan),
          );

          /// add bismillah if the surah has it
          if (LocalQuranJsonFileLoader.doesSurahHaveBasmalah(ayah.surahNumber))
            pageSpanContent.add(
              WidgetSpan(
                child: Center(
                  child: Image.asset(
                    'assets/images/bismillah.png',
                    width: MediaQuery.of(context).size.width / 2,
                    // color: kMainAppColor01,
                  ),
                ),
              ),
            );
        }
        if (!widget.isMojawwad)
          pageSpanContent.add(TextSpan(
            text: ayah.isQuarterStart
                ? "\u06de " +
                    HelperMethods.parseHtmlString(ayah.text +
                        ' ${String.fromCharCode(LocalQuranJsonFileLoader.getAyahIntNumberInQuranFont(ayah.ayahNumber))} ')
                : HelperMethods.parseHtmlString(ayah.text +
                    ' ${String.fromCharCode(LocalQuranJsonFileLoader.getAyahIntNumberInQuranFont(ayah.ayahNumber))} '),
            style: kUthmaniHafs1FontTextStyle.copyWith(
                backgroundColor: onOff == true &&
                        QuranPageWidget.ayahHighlighted[0] != -1 &&
                        QuranPageWidget.ayahHighlighted[0] ==
                            ayah.surahNumber &&
                        QuranPageWidget.ayahHighlighted[1] ==
                            ayah.ayahNumber + 1
                    ? Colors.blue[200]
                    : kMainAppColor02,
                fontSize: ayahTextFontSize,
                color: kMainQuranLightColor01,
                fontWeight: FontWeight.bold),
            // children: [
            //   ayahNumberWidget(
            //     ayah.ayahNumber + 1,
            //     kButtonTextStyleWhiteScheherazadeFontNormal.copyWith(
            //       fontSize: 19,
            //       color: kMainQuranLightColor01,
            //     ),
            //   ),
            // ],
            recognizer: new LongPressGestureRecognizer()
              ..onLongPressEnd = (details) {
                print('Tap on ayah: ${ayah.ayahNumber}, details: $details');

                setState(() {
                  if (onOff &&
                      QuranPageWidget.ayahHighlighted[0] == ayah.surahNumber &&
                      QuranPageWidget.ayahHighlighted[1] ==
                          ayah.ayahNumber + 1) {
                    onOff = false;
                    QuranPageWidget.ayahHighlighted = [-1, -1];
                    toolbarPositionDetails = null;
                    selectedAyah = null;
                  } else {
                    toolbarPositionDetails = details;
                    selectedAyah = ayah;
                    onOff = true;
                    // print(ayah.surahNumber);
                    QuranPageWidget.ayahHighlighted = [
                      ayah.surahNumber,
                      ayah.ayahNumber + 1
                    ];
                  }
                });
              },
          ));
        else {
          pageSpanContent.add(TextSpan(
            // text: ayah.isQuarterStart ? "\u06de " : '',

            children: List<InlineSpan>.generate(
              widget.pagetData.ayatTajweedData[ayahIndexInPage].parts.length,
              (index) => TextSpan(
                text: widget.pagetData.ayatTajweedData[ayahIndexInPage]
                        .parts[index] +
                    (index ==
                            widget.pagetData.ayatTajweedData[ayahIndexInPage]
                                    .parts.length -
                                1
                        ? ' ${String.fromCharCode(LocalQuranJsonFileLoader.getAyahIntNumberInQuranFont(ayah.ayahNumber))} '
                        : ''),
                style: kUthmaniHafs1FontTextStyle.copyWith(
                    backgroundColor: onOff == true &&
                            QuranPageWidget.ayahHighlighted[0] != -1 &&
                            QuranPageWidget.ayahHighlighted[0] ==
                                ayah.surahNumber &&
                            QuranPageWidget.ayahHighlighted[1] ==
                                ayah.ayahNumber + 1
                        ? Colors.blue[200]
                        : kMainAppColor02,
                    fontSize: ayahTextFontSize,
                    color: widget.pagetData.ayatTajweedData[ayahIndexInPage]
                        .colors[index],
                    fontWeight: FontWeight.bold),
                recognizer: new LongPressGestureRecognizer()
                  ..onLongPressEnd = (details) {
                    print('Tap on ayah: ${ayah.ayahNumber}, details: $details');

                    setState(() {
                      if (onOff &&
                          QuranPageWidget.ayahHighlighted[0] ==
                              ayah.surahNumber &&
                          QuranPageWidget.ayahHighlighted[1] ==
                              ayah.ayahNumber + 1) {
                        onOff = false;
                        QuranPageWidget.ayahHighlighted = [-1, -1];
                        toolbarPositionDetails = null;
                        selectedAyah = null;
                      } else {
                        toolbarPositionDetails = details;
                        selectedAyah = ayah;
                        onOff = true;
                        // print(ayah.surahNumber);
                        QuranPageWidget.ayahHighlighted = [
                          ayah.surahNumber,
                          ayah.ayahNumber + 1
                        ];
                      }
                    });
                  },
              ),
              growable: false,
            ),
            recognizer: new LongPressGestureRecognizer()
              ..onLongPressEnd = (details) {
                print('Tap on ayah: ${ayah.ayahNumber}, details: $details');

                setState(() {
                  if (onOff &&
                      QuranPageWidget.ayahHighlighted[0] == ayah.surahNumber &&
                      QuranPageWidget.ayahHighlighted[1] ==
                          ayah.ayahNumber + 1) {
                    onOff = false;
                    QuranPageWidget.ayahHighlighted = [-1, -1];
                    toolbarPositionDetails = null;
                    selectedAyah = null;
                  } else {
                    toolbarPositionDetails = details;
                    selectedAyah = ayah;
                    onOff = true;
                    // print(ayah.surahNumber);
                    QuranPageWidget.ayahHighlighted = [
                      ayah.surahNumber,
                      ayah.ayahNumber + 1
                    ];
                  }
                });
              },
          ));
        }
        ayahIndexInPage++;
      },
    );
    return pageSpanContent;
  }

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    fullTime = Duration(minutes: 0, seconds: 0);

    _player.onDurationChanged.listen((d) {
      fullTime = d;
    });
    _player.onAudioPositionChanged.listen((pos) {
      if (pos.inMinutes == fullTime.inMinutes &&
          pos.inSeconds == fullTime.inSeconds) {
        setState(() {
          print('why not me');
          playing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // int currentQuarter = widget
    //     .pagetData.ayatData[widget.pagetData.ayatData.length - 1].quarterNumber;
    setState(() {
      width = MediaQuery.of(context).size.width;
      screenFactor = MediaQuery.of(context).devicePixelRatio > 2.85
          ? MediaQuery.of(context).devicePixelRatio
          : 2.85;
      surahTitleFontSize = kSurahTitleFontSizeUnit * width * screenFactor;
      ayahTextFontSize = kAyahTextFontSizeUnit * width * screenFactor;
    });

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, left: 8.0, right: 8.0, bottom: 50),
            child: RichText(
              textDirection: TextDirection.rtl,
              text: TextSpan(
                children: pageContent(),
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
        if (onOff == true &&
            toolbarPositionDetails != null &&
            selectedAyah != null)
          Positioned(
            width: 215,
            height: 45,
            top: toolbarPositionDetails.globalPosition.dy / 2,
            left: toolbarPositionDetails.globalPosition.dx / 2,
            child: showToolbarForAyah(selectedAyah),
          ),
        Positioned.fill(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                HelperMethods.convertDigitsIntoArabic(widget.pageNum + 1)
                    .toString(),
                style: TextStyle(fontSize: 20, color: Colors.black),
              )),
        ),
        if (widget.isMojawwad)
          Positioned.fill(
            child: Align(
              alignment: Alignment(0, 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 25,
                      height: 38,
                      decoration: BoxDecoration(
                        color: kMainAppColor03,
                        border: Border.all(
                          color: kMainAppColor06,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            kQuranTajweedCodeColorMap['m'],
                                        radius: 6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      kQuranTajweedNotations[0],
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            kQuranTajweedCodeColorMap['o'],
                                        radius: 6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      kQuranTajweedNotations[2],
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            kQuranTajweedCodeColorMap['pm'],
                                        radius: 6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      kQuranTajweedNotations[1],
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            kQuranTajweedCodeColorMap['n'],
                                        radius: 6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      kQuranTajweedNotations[3],
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 25,
                      height: 38,
                      decoration: BoxDecoration(
                        color: kMainAppColor03,
                        border: Border.all(
                          color: kMainAppColor06,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            kQuranTajweedCodeColorMap['g'],
                                        radius: 6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      kQuranTajweedNotations[4],
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            kQuranTajweedCodeColorMap['h'],
                                        radius: 6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      kQuranTajweedNotations[5],
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            kQuranTajweedCodeColorMap['p'],
                                        radius: 6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      kQuranTajweedNotations[6],
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            kQuranTajweedCodeColorMap['q'],
                                        radius: 6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      kQuranTajweedNotations[7],
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
