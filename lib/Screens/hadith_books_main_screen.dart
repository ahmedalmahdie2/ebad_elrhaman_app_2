import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quranandsunnahapp/Classes/file_downloader.dart';
import 'package:quranandsunnahapp/Classes/hadith_books_subBooks_chapters_hadiths_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/book_button.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/download_progress_indicator.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Hadith/hadith_bloc.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:quranandsunnahapp/Screens/hadith_book_chapters_screen.dart';
import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Screens/home_screen.dart';
import 'package:toast/toast.dart';

// main screen - > chapters of book screen -> content screen
class HadithBooksListScreen extends StatefulWidget {
  static const String route = 'HadithBooksListScreen';
  final int titleIndex = 4;
  @override
  _HadithBooksListScreenState createState() => _HadithBooksListScreenState();
}

class _HadithBooksListScreenState extends State<HadithBooksListScreen> {
  List<HadithBookData> hadithBooks = [];
  HadithBloc hadithBloc;

  @override
  void initState() {
    Toast.show("main screen", context);
    super.initState();
    hadithBloc = BlocProvider.of<HadithBloc>(context);
    hadithBloc.add(GettingHadithBooksMetadataEvent());
  }

  Widget updateHadithBooksListWidget(HadithState state) {
    if (state is HadithBooksMetadataDownloadedState) {
      hadithBooks = state.books;
      print('hadith main screen HadithBooksMetadataDownloadedState');

      if (state.books.length > 0) {
        List<Widget> tempHadithBooksWidgets = [];
        state.books.forEach(
          (hadithBook) {
            // print(hadithBook.name[0]);
            if (hadithBook.name[0] != 'الشمائل المحمدية')
              tempHadithBooksWidgets.add(BookButton(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 150,
                fontSize: 35,
                texts: hadithBook.name,
                onTap: () {
                  hadithBloc.add(CheckHadithBookFileExistsEvent(hadithBook));
                },
              ));
          },
        );
        return Center(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 10,
                  children: tempHadithBooksWidgets,
                ),
              ),
            ),
          ),
        );
      } else {
        print('Hadith main screen HadithBooksMetadataDownloadedState else');
        return Center(
            child: HelperMethods.getErrorLoadingWidget(
                'Something went wrong! click here to try again.', () {
          hadithBloc.add(GettingHadithBooksMetadataEvent());
        }));
      }
    } else if (state is HadithBookIsDownloadingState) {
      // hadithBloc.add(
      //     HadithEntireBookIsDownloadingEvent(state.bookId, state.progress));
      // print('Hadith main screen HadithBookIsDownloadingState ');
      return DownloadProgressIndicator(
        downloadPercentege: state.progress,
      );
    } else if (state is HadithNotDownloadedState) {
      print('Hadith main screen HadithNotDownloadedState ');

      return Center(child: HelperMethods.getErrorLoadingWidget(null, () {}));
    } else if (state is HadithBookFilesDontExistState) {
      print('Hadith main screen HadithBookFilesDontExistState ');

      hadithBloc.add(HadithEntireBookIsDownloadingEvent(state.bookId, 0));
      return DownloadProgressIndicator(
        downloadPercentege: 0,
      );
    }
    print('Hadith main screen else');
    return Center(child: HelperMethods.loadingWidget);
  }

  BannerAd banner;

  @override
  void dispose() {
    FilesDownloader.closeDownload();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.route, (route) => false);
      },
      child: BlocListener<HadithBloc, HadithState>(
        listener: (context, state) {
          if (state is HadithEntireBookFileReadyInStorageState) {
            print(
                'Hadith main screen HadithEntireBookFileReadyInStorageState ');

            if (hadithBooks == null || hadithBooks.length < 1) {
              hadithBloc.add(GettingHadithBooksMetadataEvent());
              // return Center(child: HelperMethods.loadingWidget);
            } else {
              Navigator.popAndPushNamed(
                  context, HadithBookSubBooksListScreen.route,
                  arguments: HadithSubBookScreenArguments(
                      state.book.name, state.book.id, state.book.nameId));
            }

            // return;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kMainAppColor01,
            leading: BackButton(
              color: kMainAppColor03,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.route, (route) => false);
              },
            ),
            title: Text(
              HelperMethods.getMainCategoryScreenTitle(widget.titleIndex),
              style: kAppBarTitleStyle,
            ),
            centerTitle: true,
            actions: [ChangeLanguageButton(), MenuButton()],
            // actions: [LangButton(), MenuButton()],
          ),
          backgroundColor: kMainAppColor02,
          body: SafeArea(
            child: BlocBuilder<HadithBloc, HadithState>(
              bloc: hadithBloc,
              builder: (context, state) => updateHadithBooksListWidget(state),
            ),
          ),
          drawer: SideMenu(),
          endDrawer: SideMenu(),
        ),
      ),
    );
  }
}
