import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranandsunnahapp/Classes/hadith_books_subBooks_chapters_hadiths_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/hadith_content_widget.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Hadith/hadith_bloc.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class HadithContentScreen extends StatefulWidget {
  static const String route = 'HadithContentScreen';
  final HadithSubBookContentScreenArguments hadithSubBookContentScreenArguments;

  const HadithContentScreen({this.hadithSubBookContentScreenArguments});

  @override
  _HadithContentScreenState createState() => _HadithContentScreenState();
}

class _HadithContentScreenState extends State<HadithContentScreen> {
  List<HadithData> hadiths = [];
  HadithBloc hadithBloc;

  @override
  void initState() {
    Toast.show("content screen", context);
    print('HadithBookSubBooksListScreen initState');
    super.initState();
    hadithBloc = BlocProvider.of<HadithBloc>(context);
    hadithBloc.add(
      GetHadithSubBookContentEvent(
        widget.hadithSubBookContentScreenArguments.filePath,
        widget.hadithSubBookContentScreenArguments.bookId,
        widget.hadithSubBookContentScreenArguments.subBookId,
      ),
    );
  }

  // Widget updateHadithBooksListWidget(HadithState state) {}

  // BannerAd banner;
  // //final adState=HomeScreen().
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final adState = Provider.of<AdState>(context);
  //   adState.initalization.then((status) {
  //     if (mounted) {
  //       setState(() {
  //         banner = adState.createBannerAd(adState.bannerAdUnitId)..load();
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        hadithBloc.add(
          HadithEntireBookFileExistsInStorageEvent(
              widget.hadithSubBookContentScreenArguments.filePath,
              widget.hadithSubBookContentScreenArguments.bookId),
        );
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: kMainAppColor02,
        // bottomNavigationBar: Container(
        //   width: MediaQuery.of(context).size.width,
        //   height: kHeightForBanner,
        //   child: banner == null ? SizedBox(height: 20) : AdWidget(ad: banner),
        // ),
        appBar: AppBar(
          backgroundColor: kMainAppColor01,
          leading: BackButton(
            color: kMainAppColor03,
            onPressed: () {
              hadithBloc.add(
                HadithEntireBookFileExistsInStorageEvent(
                    widget.hadithSubBookContentScreenArguments.filePath,
                    widget.hadithSubBookContentScreenArguments.bookId),
              );
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.hadithSubBookContentScreenArguments
                .bookTitle[HelperMethods.isArabic(context) ? 0 : 1],
            style: kAppBarTitleStyle,
          ),
          centerTitle: true,
          actions: [ChangeLanguageButton(), MenuButton()],
          // actions: [LangButton(), MenuButton()],
        ),
        body: SafeArea(
          child: BlocBuilder<HadithBloc, HadithState>(
            bloc: hadithBloc,
            builder: (context, state) {
              if (state is SubBookHadithsContentLoadedSuccessfullyState) {
                print(
                    'Hadith content screen SubBookHadithsContentLoadedSuccessfullyState ');
                hadiths = state.hadiths;
                if (hadiths != null && hadiths.length > 0) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Wrap(
                          runAlignment: WrapAlignment.center,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 10,
                          children: hadiths.map(
                            (hadith) {
                              return HadithContentWidget(
                                bookTitle: widget
                                    .hadithSubBookContentScreenArguments
                                    .bookTitle,
                                subBookTitle: widget
                                    .hadithSubBookContentScreenArguments
                                    .subBookTitle,
                                text: [
                                  HelperMethods.parseHtmlString(hadith.matn[0]),
                                  HelperMethods.parseHtmlString(hadith.matn[1])
                                ],
                                chapterNumber: hadith.chapterId,
                                chapterTitle: hadith.chapterName,
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  );
                } else {
                  print(
                      'Hadith content screen HadithBooksMetadataDownloadedState else');
                  return Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: HelperMethods.getErrorLoadingWidget(
                        'Something wrong with the book content, please contact the app developer',
                        () {
                          hadithBloc.add(
                            GetHadithSubBookContentEvent(
                              widget
                                  .hadithSubBookContentScreenArguments.filePath,
                              widget.hadithSubBookContentScreenArguments.bookId,
                              widget.hadithSubBookContentScreenArguments
                                  .subBookId,
                            ),
                          );
                        },
                        style: TextStyle(
                            color: HelperMethods.isDarkMode(context)
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  );
                }
              } else {
                return Center(child: HelperMethods.loadingWidget);
              }
            },
          ),
        ),
        drawer: SideMenu(),
        endDrawer: SideMenu(),
      ),
    );
  }
}
