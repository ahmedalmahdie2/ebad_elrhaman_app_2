import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quranandsunnahapp/Classes/file_downloader.dart';
import 'package:quranandsunnahapp/Classes/hadith_books_subBooks_chapters_hadiths_data.dart';
import 'package:http/http.dart' as http;
import 'package:quranandsunnahapp/Classes/hadith_methods.dart';
import 'dart:io';

import 'package:quranandsunnahapp/Misc/constants.dart';

part 'hadith_event.dart';
part 'hadith_state.dart';

class HadithBloc extends Bloc<HadithEvent, HadithState> {
  HadithBloc() : super(HadithInitialState());
  List<HadithBookData> hadithbBooks = [];
  int bookDownloadingProgress;
  List<http.Response> responses = [];
  final String separator = Platform.pathSeparator;

  @override
  Stream<HadithState> mapEventToState(
    HadithEvent event,
  ) async* {
    yield HadithInitialState();

    /// 1- GettingHadithBooksMetadataEvent -> 2- CheckHadithBookFilesExistEvent -> 3- if 2(no) DownloadHadithEntireBookEvent -> 4- looping HadithEntireBookIsDownloadingEvent till end
    /// -> 5- if 2(yes) HadithSubBookFileExistsState -> HadithEntireBookDownloadSuccessfullyEvent

    if (event is GettingHadithBooksMetadataEvent) {
      yield GettingHadithBooksListState();

      if (hadithbBooks.isEmpty) {
        hadithbBooks = [];

        if (!await FilesDownloader.doesFileExist('Hadith', 'index.json')) {
          http.Response response = await http.get(Uri.https(
              kQuranAndSunnahDomain,
              kUploadsSecondPart + kHadithsFolder + '/index.json'));
          // print(Uri.https(kQuranAndSunnahDomain,
          //         kUploadsSecondPart + kHadithsFolder + '/index.json')
          //     .toString());
          if (response.statusCode == 200) {
            await FilesDownloader.SaveFile(
                'Hadith', 'index.json', response.bodyBytes);
          } else {
            print("error downloading hadith books list!");
            yield HadithNotDownloadedState(response.statusCode.toString());
            return;
          }
        }

        var json = jsonDecode(
            await FilesDownloader.readFileAsString('Hadith', 'index.json'));

        int bookId = 0;
        json['data'].forEach((book) {
          hadithbBooks.add(HadithBookData.fromJson(book, bookId++));
        });
        HadithMethods.initializeHadithBooks(hadithbBooks.length);
      }
      yield HadithBooksMetadataDownloadedState(hadithbBooks);
    } else if (event is DownloadHadithEntireBookEvent) {
      bookDownloadingProgress = 0;

      FilesDownloader.downloadFile(
        uri: Uri.https(
            kQuranAndSunnahDomain,
            kUploadsSecondPart +
                kHadithsFolder +
                '/${event.fileName}/all.json'),
        onDone: (fileBytes) async {
          print('${event.fileName}.json book has been Downloaded');
          this.add(HadithEntireBookFileExistsInStorageEvent(
              await FilesDownloader.SaveFile(
                  'Hadith', '${event.fileName}.json', fileBytes),
              event.bookId));
        },
        onError: (e) {
          print('${event.fileName}.json book Downloaded Error: \n$e}');
          this.add(
            HadithEntireBookDownloadUnsuccessfulEvent(
              event.fileName,
              event.bookId,
            ),
          );
        },
        onProgress: (progress) {
          // print('progress: ${(bookDownloadingProgress).toStringAsFixed(1)}');
          bookDownloadingProgress = progress;
          this.add(
            HadithEntireBookIsDownloadingEvent(
                event.bookId, bookDownloadingProgress),
          );
        },
      );
      yield HadithBookIsDownloadingState(
        event.bookId,
        bookDownloadingProgress,
      );
    } else if (event is HadithEntireBookIsDownloadingEvent) {
      yield HadithBookIsDownloadingState(event.bookId, event.progress);
    } else if (event is HadithBookFileDontExistInStorageEvent) {
      this.add(DownloadHadithEntireBookEvent(
          hadithbBooks[event.bookId].nameId, event.bookId));
    } else if (event is HadithEntireBookFileExistsInStorageEvent) {
      List<HadithSubBookData> subBooks =
          await HadithMethods.getHadithBookSubbooks(
              event.bookId, File(event.filePath));
      yield HadithEntireBookFileReadyInStorageState(
          hadithbBooks[event.bookId], subBooks, event.filePath);
    } else if (event is GetHadithSubBookContentEvent) {
      // var homeDirectory = await getApplicationDocumentsDirectory();
      // print('dir: $homeDirectory');

      List<HadithData> subBookHadiths = await HadithMethods.getSubBookHadiths(
          event.bookId, File(event.filePath), event.subBookId);
      yield SubBookHadithsContentLoadedSuccessfullyState(
          subBookHadiths, hadithbBooks[event.bookId].nameId);
    } else if (event is CheckHadithBookFileExistsEvent) {
      final directory = await getApplicationDocumentsDirectory();
      String filePath = directory.path;
      String finalFileName = event.bookData.nameId;
      finalFileName = finalFileName.replaceAll(" ", "_");
      print(
          'check if hadith Book metadata file: ${event.bookData.nameId} exists.');
      File file = File(
          filePath + separator + 'Hadith' + separator + '$finalFileName.json');
      print('file path: ${file.path}');
      bool flag = false;
      flag = await file.exists();
      if (flag) {
        bookDownloadingProgress = 100;
        print('yes exist!!');
        this.add(
          HadithEntireBookFileExistsInStorageEvent(
            file.path,
            event.bookData.id,
          ),
        );
      } else {
        print('hadith Book file: ${event.bookData.nameId} does\'nt exist!');
        this.add(HadithBookFileDontExistInStorageEvent(
          file.path,
          event.bookData.id,
        ));
      }
    }
  }
}
