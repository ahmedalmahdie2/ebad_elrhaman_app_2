import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranandsunnahapp/Classes/hadith_books_subBooks_chapters_hadiths_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/book_button.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Hadith/hadith_bloc.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:quranandsunnahapp/Screens/hadith_book_chapter_content_screen.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

import 'hadith_books_main_screen.dart';

class HadithBookSubBooksListScreen extends StatefulWidget {
  static const String route = 'HadithBookChaptersListScreen';
  final HadithSubBookScreenArguments hadithSubBookScreenArguments;

  const HadithBookSubBooksListScreen({this.hadithSubBookScreenArguments});
  @override
  _HadithBookSubBooksListScreenState createState() =>
      _HadithBookSubBooksListScreenState();
}

class _HadithBookSubBooksListScreenState
    extends State<HadithBookSubBooksListScreen> {
  List<HadithSubBookData> hadithSubBooks = [];

  HadithBloc hadithBloc;

  @override
  void initState() {
    Toast.show("chapters screen", context);

    print('HadithBookSubBooksListScreen initState');
    super.initState();
    hadithBloc = BlocProvider.of<HadithBloc>(context);
  }

  Future goToBookScreen(int timeToWaitToGoToScreen, int subBookId,
      List<String> subBookTitle, HadithState state) {
    if (state is HadithEntireBookFileReadyInStorageState)
      Future.delayed(
        Duration(microseconds: timeToWaitToGoToScreen),
        () {},
      );
    return null;
  }

  Widget updateHadithSubBooksListWidget(HadithState state) {
    if (state is HadithEntireBookFileReadyInStorageState) {
      print('Hadith main screen HadithEntireBookFileReadyInStorageState ');
      hadithSubBooks = state.subBooks;

      if (hadithSubBooks != null && hadithSubBooks.length > 0) {
        List<Widget> tempHadithSubBooksWidgets = [];
        int chapterId = 1;
        hadithSubBooks.forEach(
          (hadithSubBook) {
            tempHadithSubBooksWidgets.add(BookButton(
              width: MediaQuery.of(context).size.width / 1.2,
              height: 150,
              fontSize: 30,
              texts: hadithSubBook.name,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  HadithContentScreen.route,
                  arguments: HadithSubBookContentScreenArguments(
                    bookTitle: widget.hadithSubBookScreenArguments.bookTitle,
                    subBookTitle: hadithSubBook.name,
                    bookId: widget.hadithSubBookScreenArguments.bookId,
                    bookNameId: widget.hadithSubBookScreenArguments.bookNameId,
                    subBookId: hadithSubBook.id,
                    filePath: state.filePath,
                  ),
                );
              },
            ));
          },
        );
        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 10,
                children: tempHadithSubBooksWidgets,
              ),
            ),
          ),
        );
      } else {
        print('Hadith main screen HadithBooksMetadataDownloadedState else');
        return Center(
          child: HelperMethods.getErrorLoadingWidget(
            'Something went wrong! click here to try again.',
            () {
              hadithBloc.add(HadithEntireBookFileExistsInStorageEvent(
                  state.filePath, state.book.id));
            },
          ),
        );
      }
    } else {
      return Center(child: HelperMethods.loadingWidget);
    }
  }

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
        hadithBloc.add(GettingHadithBooksMetadataEvent());
      },
      child: BlocListener<HadithBloc, HadithState>(
        listener: (context, state) {
          if (state is GettingHadithBooksListState) {
            print('Hadith chapters screen GettingHadithBooksListState');

            Navigator.popAndPushNamed(context, HadithBooksListScreen.route);
          }
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
                hadithBloc.add(GettingHadithBooksMetadataEvent());
              },
            ),
            title: Text(
              widget.hadithSubBookScreenArguments
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
                builder: (context, state) =>
                    updateHadithSubBooksListWidget(state)),
          ),
          drawer: SideMenu(),
          endDrawer: SideMenu(),
        ),
      ),
    );
  }
}
