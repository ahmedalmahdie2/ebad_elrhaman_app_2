import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quranandsunnahapp/Classes/book_tafseer.dart';
import 'package:quranandsunnahapp/Classes/file_downloader.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Classes/surah_metadata.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;

import 'package:quranandsunnahapp/Classes/tafseer_methods.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';

part 'tafseer_event.dart';
part 'tafseer_state.dart';

class TafseerBloc extends Bloc<TafseerEvent, TafseerState> {
  TafseerBloc() : super(TafseerInitialState());
  List<SurahMetadata> surahsMetadata = [];
  List<TafseerBook> tafseerBooks = [];
  int bookDownloadingProgress = 0;

  @override
  Stream<TafseerState> mapEventToState(
    TafseerEvent event,
  ) async* {
    yield TafseerInitialState();
    if (event is GettingSurahMetadataEvent) {
      surahsMetadata = [];
      tafseerBooks = [];

      bookDownloadingProgress = 0;
      var parsed = await HelperMethods.loadQuranMetadata();
      List<dynamic> lastParsed = parsed["data"]["surahs"]["references"];

      int index = 0;
      lastParsed.forEach((surah) {
        surahsMetadata.add(SurahMetadata.fromJson(json: surah, index: index++));
      });

      if (!await FilesDownloader.doesFileExist('Tafseer', 'index.json')) {
        http.Response response = await http.get(Uri.https(kQuranAndSunnahDomain,
            kUploadsSecondPart + kTafseerFolder + '/index.json'));
        if (response.statusCode == 200) {
          await FilesDownloader.SaveFile(
              'Tafseer', 'index.json', response.bodyBytes);
        } else {
          print("error downloading tafseer books list!");
          yield TafseerBooksListNotDownloadedState(
              response.statusCode.toString());
        }
      }

      var json = jsonDecode(
          await FilesDownloader.readFileAsString('Tafseer', 'index.json'));
      int i = 0;

      json.forEach((book) {
        tafseerBooks.add(TafseerBook.fromJson(book, i++));
      });
      yield TafseerBooksListDownloadedState(surahsMetadata, tafseerBooks);
    } else if (event is CheckTafseerBookFileExistEvent) {
      final directory = await getApplicationDocumentsDirectory();
      String filePath = directory.path;
      String finalFileName = event.fileName;
      finalFileName = finalFileName.replaceAll(" ", "_");

      bool flag =
          await io.File("$filePath/Tafseer/$finalFileName.json").exists();
      if (flag) {
        bookDownloadingProgress = 100;
        print('yes exist!!');
        yield TafseerBookDownloadedState(
            event.bookId, surahsMetadata, tafseerBooks);
      } else {
        print('no it is does not exist!!!');
        yield TafseerBookNotDownloadedState(surahsMetadata, tafseerBooks);
      }
    } else if (event is StartDownloadBookEvent) {
      bookDownloadingProgress = 0;
      FilesDownloader.downloadFile(
        uri: Uri.https(
            kQuranAndSunnahDomain,
            kUploadsSecondPart +
                kTafseerFolder +
                '/${event.bookId}/${event.bookId}.json'),
        onDone: (fileBytes) async {
          await FilesDownloader.SaveFile(
              'Tafseer', '${event.fileName}.json', fileBytes);
          // print('BookDownloaded');
          // yieldTafseerBookDownloaded(surahsMetadata, allBooks);
        },
        onError: (e) {},
        onProgress: (progress) {
          // print('progress: ${(bookDownloadingProgress).toStringAsFixed(1)}');
          bookDownloadingProgress = progress;
        },
      );

      yield TafseerInDownloadingState(event.bookId, bookDownloadingProgress);
    } else if (event is DownloadingTafseerBookEvent) {
      yield TafseerInDownloadingState(
          event.bookId, (bookDownloadingProgress).floor());
    } else if (event is TafseerFinishedDownloadingEvent) {
      // print('progress: ${(bookDownloadingProgress).toStringAsFixed(1)}');
      yield TafseerBookDownloadedState(
          event.bookId, event.surahsMetadata, event.tafseerBooks);
    } else if (event is GetAyahTafseerEvent) {
      final directory = await getApplicationDocumentsDirectory();
      String filePath = directory.path;
      String finalFileName = event.bookName;
      finalFileName = finalFileName.replaceAll(" ", "_");

      io.File file = io.File("$filePath/Tafseer/$finalFileName.json");
      String tafseerText = await TafseerMethods.getTafseerText(
          event.bookID, event.surahID, event.ayahID, surahsMetadata, file);
      yield TafseerTextLoadedSuccessfullyState(
          tafseerText, surahsMetadata, tafseerBooks);
    } else if (event is CancelDownloadingTafseerBookEvent) {
      yield TafseerBookNotDownloadedState(surahsMetadata, tafseerBooks);
    }
  }
}
