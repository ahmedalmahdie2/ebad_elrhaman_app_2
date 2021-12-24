import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Classes/local_quran_loader.dart';
import 'package:quranandsunnahapp/Classes/quran_data.dart';
import 'package:quranandsunnahapp/Components/Page_widget.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Quran/quran_bloc.dart';

class QuranScreenArguments {
  final bool isMojoad;
  final int pageIndex;
  final int surahIndex;
  final int ayahIndex;
  final bool isMojawwad;
  QuranScreenArguments(
      {this.isMojoad,
      this.pageIndex,
      this.surahIndex,
      this.ayahIndex,
      this.isMojawwad = false});
}

class QuranScreen extends StatefulWidget {
  static const String route = 'quranScreen';
  final QuranScreenArguments args;

  QuranScreen({this.args});

  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with CanListenToQuranLoadingEventMixin {
  TextEditingController _controller;
  QuranBloc quranBloc;
  PageController controller;
  PageView myPageView;
  AudioPlayer _player;
  Duration fulltime;

  bool playing = false;

  bool firstTime = true;
  bool isSearching = false;
  bool displaySearchResults = false;

  List<QuranAyahData> searchResults;

  int surahNum;
  int pageNum;

  QuranPageData pageData;

  bool doubleTaped = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    pageNum = widget.args.pageIndex;

    controller = PageController(
      initialPage: 0,
    );

    quranBloc = BlocProvider.of<QuranBloc>(context);
    quranBloc
        .add(ChangeQuranPageEvent(pageNum, isMojawwad: widget.args.isMojawwad));

    _player = AudioPlayer();
    fulltime = Duration(minutes: 0, seconds: 0);

    _player.onDurationChanged.listen((d) {
      fulltime = d;
    });
    _player.onAudioPositionChanged.listen((pos) {
      if (pos.inMinutes == fulltime.inMinutes &&
          pos.inSeconds == fulltime.inSeconds) {
        setState(() {
          print('why not me');
          playing = false;
        });
      }
    });
  }

  Future<List<Widget>> getAllSurahs() async {}

  @override
  void dispose() {
    _player.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: doubleTaped
          ? AppBar(
              toolbarHeight: 0,
            )
          : AppBar(
              backgroundColor: kMainAppColor01,
              automaticallyImplyLeading: false,
              title: Container(
                // color: kMainAppColor03,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isSearching)
                      BackButton(
                        color: kMainAppColor03,
                      ),
                    if (isSearching)
                      IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.close,
                            color: kMainAppColor03,
                            // size: MediaQuery.of(context).size.width / 15,
                          ),
                          onPressed: () async {
                            if (isSearching)
                              setState(() {
                                isSearching = !isSearching;
                              });
                          }),
                    Column(
                      children: [
                        if (pageData == null)
                          Text("سورة الفاتحة", style: TextStyle(fontSize: 12)),
                        if (pageData != null)
                          Text(
                              LocalQuranJsonFileLoader.getSurahInQuranFont(
                                  pageData.ayatData[1].surahNumber - 1),
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'UthmanicHafs1')),
                        if (pageData == null || pageData.ayatData == null)
                          Text("صفحة ", style: TextStyle(fontSize: 12)),
                        if (pageData != null)
                          Text(
                            "صفحة " +
                                HelperMethods.convertDigitsIntoArabic(
                                    (pageNum + 1)) +
                                "، جزء " +
                                HelperMethods.convertDigitsIntoArabic(
                                    pageData.ayatData[1].juzNumber) +
                                "، الربع " +
                                HelperMethods.convertDigitsIntoArabic(
                                    pageData.ayatData[1].quarterNumber),
                            style: TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.search,
                          color: kMainAppColor03,
                          // size: MediaQuery.of(context).size.width / 15,
                        ),
                        onPressed: () async {
                          if (!isSearching)
                            setState(() {
                              isSearching = !isSearching;
                            });
                          else {
                            if (_controller.text.isEmpty ||
                                _controller.text == "" ||
                                _controller.text == " ") return;

                            Future.delayed(const Duration(milliseconds: 2000),
                                () {
                              setState(() {
                                doubleTaped = true;
                              });
                            });

                            setState(() {
                              displaySearchResults = true;
                            }); // print('seraching for ${_controller.text}');
                            LocalQuranJsonFileLoader.searchForTextInQuranDB(
                                    _controller.text)
                                .then((value) {
                              setState(() {
                                searchResults = value;
                                // searchResults.forEach((ayah) {
                                //   print(ayah.text);
                                // });
                              });
                            });
                          }
                        }),
                    if (!isSearching)
                      Expanded(
                        // color: kMainAppColor03,
                        child: Center(
                          child: Container(
                            color: kMainAppColor01,
                          ),
                        ),
                      ),
                    if (isSearching)
                      Container(
                        color: kMainAppColor03,
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 30,
                              maxWidth: MediaQuery.of(context).size.width / 2.4,
                            ),
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'ابحث في نص القرآن',
                                contentPadding:
                                    EdgeInsets.only(bottom: 8, right: 4),
                              ),
                              style: kUthmaniHafs1FontTextStyle.copyWith(
                                  color: kMainAppColor01, fontSize: 16),
                            )),
                      ),
                    if (!isSearching) ChangeLanguageButton(),
                    if (!isSearching) MenuButton(),
                  ],
                ),
              ),
            ),
      backgroundColor: kMainAppColor02,
      body: GestureDetector(
        onDoubleTap: () {
          setState(() {
            if (doubleTaped)
              doubleTaped = false;
            else
              doubleTaped = true;
          });
        },
        child: !displaySearchResults
            ? PageView.builder(
                // itemCount: 604,
                controller: controller,
                onPageChanged: (nextIndex) {
                  if (controller.position.userScrollDirection ==
                      ScrollDirection.reverse) {
                    if (pageNum + 1 < quranBloc.quranPagesIndices.length) {
                      print(
                          'going to page ${pageNum + 1}, from page: $pageNum');
                      quranBloc.add(ChangeQuranPageEvent(pageNum + 1,
                          isMojawwad: widget.args.isMojawwad));
                    } else
                      quranBloc.add(ChangeQuranPageEvent(0,
                          isMojawwad: widget.args.isMojawwad));
                  } else {
                    if (pageNum - 1 >= 0) {
                      print(
                          'going to page ${pageNum - 1}, from page: $pageNum');
                      quranBloc.add(ChangeQuranPageEvent(pageNum - 1,
                          isMojawwad: widget.args.isMojawwad));
                    } else
                      quranBloc.add(ChangeQuranPageEvent(
                          quranBloc.quranPagesIndices.length - 1,
                          isMojawwad: widget.args.isMojawwad));
                  }
                },
                itemBuilder: (context, index) {
                  return SafeArea(
                    child: BlocBuilder<QuranBloc, QuranState>(
                      bloc: quranBloc,
                      builder: (context, state) {
                        if (state is QuranInitialState) {
                          return Center(child: HelperMethods.loadingWidget);
                        }
                        // else if (state
                        //     is QuranPageViewLoadedSuccessfullyState) {
                        //   surahNum = state.surah.surahNumber;
                        //   return SurahWidget(
                        //     surah: state.surah,
                        //     isMojoad: widget.args.isMojoad,
                        //   );
                        // }
                        else if (state
                            is QuranSinglePageLoadedSuccessfullyState) {
                          pageNum = state.index - 1;
                          pageData = state.page;
                          Future.delayed(Duration.zero, () async {
                            setState(() {
                              pageNum = pageNum;
                              pageData = pageData;
                            });
                          });

                          return QuranPageWidget(
                              isMojawwad: widget.args.isMojawwad,
                              pagetData: state.page,
                              pageNum: pageNum);
                        } else {
                          // print(state);
                          return Center(child: HelperMethods.loadingWidget);
                        }
                      },
                    ),
                  );
                })
            : GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    if (doubleTaped)
                      doubleTaped = false;
                    else
                      doubleTaped = true;
                  });
                },
                child: SafeArea(
                  child: searchResults != null
                      ? SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              textDirection: TextDirection.rtl,
                              children: searchResults.map((ayah) {
                                return Column(
                                  children: [
                                    ListTile(
                                      // leading: Text(
                                      //   '${HelperMethods.ConvertDigitsIntoArabic(surah.index)}',
                                      //   style: kAppDefaultTextStyle,
                                      // ),

                                      title: Text(
                                        HelperMethods.parseHtmlString(ayah
                                                .text +
                                            ' ${String.fromCharCode(LocalQuranJsonFileLoader.getAyahIntNumberInQuranFont(ayah.ayahNumber))} '),
                                        style:
                                            kUthmaniHafs1FontTextStyle.copyWith(
                                          fontSize: 25,
                                          color: kMainQuranLightColor01,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${LocalQuranJsonFileLoader.quranSurahsMetadata[ayah.surahNumber - 1].arabicName}',
                                        style: kAppDefaultTextStyle.copyWith(
                                            fontSize: 12,
                                            color: kAppDefaultTextStyle.color
                                                .withOpacity(0.5)),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isSearching = false;
                                          displaySearchResults = false;
                                        });

                                        quranBloc.add(ChangeQuranPageEvent(
                                            LocalQuranJsonFileLoader
                                                    .getSearchResultAyahPageNumber(
                                                        ayah) -
                                                1,
                                            isMojawwad:
                                                widget.args.isMojawwad));
                                      },
                                      trailing: Text(
                                        'صفحة ${HelperMethods.convertDigitsIntoArabic(LocalQuranJsonFileLoader.getSearchResultAyahPageNumber(ayah))}',
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
                        )
                      : Center(child: HelperMethods.loadingWidget),
                ),
              ),
      ),
      drawer: SideMenu(),
      // endDrawer: SideMenu(),
    );
  }
}
