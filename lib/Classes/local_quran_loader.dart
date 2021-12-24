import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quranandsunnahapp/Classes/quran_data.dart';
import 'package:quranandsunnahapp/Classes/surah_metadata.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:quranandsunnahapp/Screens/quran_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'file_downloader.dart';
import 'helper_methods.dart';

class LocalQuranJsonFileLoader {
  static bool hasQuranBeenLoaded = false;
  static bool hasQuranTajweedBeenLoaded = false;
  static bool hasQuranMetaDataBeenLoaded = false;

  static dynamic quranFileContent;
  static dynamic quranMetaDataFileContent;
  static dynamic quranPagesFileContent;
  static dynamic quranJuzMetaDataFileContent;

  static dynamic quranTajweedFileContent;
  static List<CanListenToQuranLoadingEventMixin> _quranLoadedEventListeners =
      [];

  static List<SurahMetadata> quranSurahsMetadata = [];
  static List<QuranPageData> quranPagesData = [];
  static List<QuranPageData> currentQuranPagesData = [];
  static List<List<int>> quranJuzData = [];
  static int selectedQuranPageIndex = 0;
  static List<List<int>> surahsAyatStartsEnds;
  static List<CanListenToQuranLoadingEventMixin>
      _quranTajweedLoadedEventListeners = [];

  static Future initializeQuran() async {
    hasQuranBeenLoaded = false;
    hasQuranTajweedBeenLoaded = false;
    hasQuranMetaDataBeenLoaded = false;

    quranMetaDataFileContent = await loadQuranMetaDataFile();
    print('loaded QuranMetaDataFile');
    hasQuranMetaDataBeenLoaded = true;

    quranFileContent = await loadQuranFile();
    print('loaded QuranFile');
    hasQuranBeenLoaded = true;
    quranPagesFileContent = await loadQuranPagesDataFile();
    print('loaded QuranPagesDataFile');
    quranJuzMetaDataFileContent = await loadQuranJuzMetaDataFile();
    print('loaded QuranJuzMetaDataFile');
    quranJuzMetaDataFileContent['data']['juzs']['references'].forEach((juz) {
      List<int> tempJuz = [];
      tempJuz.add(juz['surah']);
      tempJuz.add(juz['ayah']);
      quranJuzData.add(tempJuz);
      print('juz ${quranJuzData.length} $tempJuz');
    });

    quranTajweedFileContent = await loadQuranTajweedFile();
    print('loaded quranTajweedFileContent');
    // parseMojawwadAyah(23, 34);
    // parseMojawwadAyah(1, 2);
  }

  static Future initializeSavedData() async {
    QuranMainScreen.pref = await SharedPreferences.getInstance();
  }

  static List<QuranAyahData> getBookmarkedAyahs() {
    List<QuranAyahData> bookmarkedAyat = [];
    List<String> bookmarks =
        QuranMainScreen.pref.getStringList("quranBookmarks");

    if (bookmarks != null) {
      for (int i = 0; i < bookmarks.length; i++) {
        bookmarkedAyat
            .add(LocalQuranJsonFileLoader.getAyahFromBookmark(bookmarks[i]));
        print(bookmarks[i]);
      }
    }
    return bookmarkedAyat;
  }

  static Future<dynamic> loadQuranFile() async {
    print('trying to load json file quran');
    String myStr = await rootBundle.loadString("assets/quran/quran.json");
    return jsonDecode(myStr);
  }

  static Future<dynamic> loadQuranJuzMetaDataFile() async {
    print('trying to loadQuranMetaDataFile');
    String myStr = await rootBundle.loadString("assets/quran/quran_meta.json");
    return jsonDecode(myStr);
  }

  static Future<dynamic> loadQuranPagesDataFile() async {
    print('trying to loadQuranPagesDataFile');
    String myStr = await rootBundle.loadString("assets/quran/quranPages.json");
    return jsonDecode(myStr);
  }

  static Future<dynamic> loadQuranTajweedFile() async {
    print('trying to load json file quran tajweed');
    var data = await rootBundle
        .loadString("assets/quran/ar/tajweed/quran_complete_tajweed_ar02.json");
    return jsonDecode(data);
  }

  static Future<dynamic> loadQuranMetaDataFile() async {
    print('trying to load json file quran MetaData');
    var data =
        await rootBundle.loadString("assets/quran/quran_chapters_list.json");

    return jsonDecode(data);
  }

  static List<SurahData> parseSurahs(dynamic content) {
    List<SurahData> quranData = [];
    content.forEach((surah) {
      quranData.add(SurahData.fromJson(surah));
    });

    return quranData;
  }

  static SurahData parseSurah(dynamic content) {
    return SurahData.fromJson(content);
  }

  static QuranTajweedAyahData parseMojawwadAyah(int surahIndex, int ayahIndex) {
    return QuranTajweedAyahData.fromJson(quranTajweedFileContent['data']
        ['surahs'][surahIndex]['ayahs'][ayahIndex]['text']);
  }

  static QuranAyahData parseAyah(
      dynamic content, int surahNumber, QuranAyahData previousAyah) {
    return QuranAyahData.fromJson(
        json: content, surahNumber: surahNumber, previousAyah: previousAyah);
  }

  static QuranAyahData getInitialPreviousAyah(dynamic content,
      dynamic quranTextContent, int surahIndex, int pagehIndex) {
    int ayahIndex = quranTextContent[surahIndex]['ayahs'][0]['numberInSurah'];
    if (ayahIndex - 1 < 0 || surahIndex - 1 < 0) return null;
    if (ayahIndex - 1 < 0) {
      surahIndex--;
      ayahIndex = quranTextContent[surahIndex]['ayahs'].length - 1;
    } else {
      ayahIndex--;
    }

    var ayahMeta = QuranAyahMetadataInQuranPageData.fromJson(
        content['ayahs'][ayahIndex], true);

    return QuranAyahData(
        pageNumber: ayahMeta.pageNumber,
        ayahNumber: ayahIndex,
        surahNumber: surahIndex,
        quarterNumber: ayahMeta.quarterNumber,
        juzNumber: ayahMeta.juzNumber);
  }

  static QuranPageData parseQuranPage(int pageIndex,
      {bool isMojawwad = false}) {
    return QuranPageData.fromJson(
      quranPagesFileContent[pageIndex]['data'],
      quranFileContent['data']['surahs'],
      pageIndex,
      isMojawwad: isMojawwad,
    );
  }

  static List<SurahMetadata> parseSurahsMetaData(dynamic surahsListContent) {
    List<SurahMetadata> surahsMetadata = [];
    int index = 1;
    surahsListContent.forEach((surah) {
      surahsMetadata.add(SurahMetadata.fromJson(json: surah, index: index++));
    });
    return surahsMetadata;
  }

  static int getSearchResultAyahPageNumber(QuranAyahData ayah) {
    return quranFileContent['data']['surahs'][ayah.surahNumber - 1]['ayahs']
        [ayah.ayahNumber - 1]['page'];
  }

  static QuranAyahData getFirstAyahInJuz(List<int> juzData) {
    return QuranAyahData.fromJson(
      json: quranFileContent['data']['surahs'][juzData[0] - 1]['ayahs']
          [juzData[1] - 1],
      surahNumber: juzData[0],
      ignoreStartFlags: true,
    );
  }

  static QuranAyahData getAyahFromBookmark(String bookmark) {
    List<String> parts = bookmark.split(':');
    var surahNumber = HelperMethods.getIntParsedString(parts[0]);
    var ayahNumber = HelperMethods.getIntParsedString(parts[1]);
    return QuranAyahData.fromJson(
      json: quranFileContent['data']['surahs'][surahNumber - 1]['ayahs']
          [ayahNumber - 1],
      surahNumber: surahNumber,
      ignoreStartFlags: true,
    );
  }

  static void populateSurahsMetadataWithPagesNumbers() {
    int surahIndex = 0;
    quranSurahsMetadata.forEach((surah) {
      surah.startPage =
          quranFileContent['data']['surahs'][surahIndex++]['ayahs'][0]['page'];
      // print('${surah.arabicName}\'s start page: ${surah.startPage}');
    });
  }

  static String getSurahAyatWithText(int index, TajweedData data) {
    String ayatWithNumbers = '';
    for (int i = data.surahsAyatStartsEnds[index][0] - 1;
        i < data.surahsAyatStartsEnds[index][1];
        i++) {
      ayatWithNumbers +=
          data.quranAyatData[i].ayahTextWithNumber(addAyahNumber: false);
    }
    return ayatWithNumbers;
  }

  static List<SurahData> parseSurahsTajweed(TajweedData data) {
    int index = 0;
    int sumStart = 0;
    int sumEnd = 0;
    data.surahsAyatStartsEnds = [];
    data.quranSurahsMetadata.forEach((surah) {
      // print('quranSurahsMetadata adding surahsAyatStartsEnds');

      sumStart = sumEnd + surah.start;
      sumEnd = sumEnd + surah.end;
      index++;
      // print('Surah $index start: $sumStart, end: $sumEnd');
      data.surahsAyatStartsEnds.add([sumStart, sumEnd]);
    });

    int surahIndex = 0;
    int ayahIndex = 0;
    data.quranAyatData = [];
    data.ayatListContent.forEach((ayah) {
      data.quranAyatData.add(
        QuranAyahData.fromTajweedJson(
          json: ayah,
          surahNumber: surahIndex + 1,
          ayahNumber: ayahIndex + 1,
          surahName: data.quranSurahsMetadata[surahIndex].arabicName,
        ),
      );
      ayahIndex++;
      if (ayahIndex == data.surahsAyatStartsEnds[surahIndex][1]) {
        surahIndex++;
      }
    });

    surahIndex = 0;
    List<SurahData> quranData = [];

    data.quranSurahsMetadata.forEach((surah) {
      quranData.add(SurahData(
          ayatCount: surah.end,
          ayatWithNumbers: getSurahAyatWithText(surahIndex++, data),
          hasBasmalah:
              LocalQuranJsonFileLoader.doesSurahHaveBasmalah(surah.index),
          surahNumber: surah.index));
    });

    return quranData;
  }

  static List<SurahData> parseSurahsTajweedFromDynamic(dynamic quranJson) {
    int surahIndex = 0;
    List<SurahData> quranData = [];

    quranJson.forEach((surah) {
      quranData.add(SurahData.fromJson(surah));
    });

    return quranData;
  }

  static Future<List<QuranAyahData>> searchForTextInQuranDB(
      String searchText) async {
    var resultMap =
        await QuranTextSearchDatabaseHelper.instance.SearchForText(searchText);
    List<QuranAyahData> resultList = resultMap.map((ayah) {
      // print(ayah.ayaId);
      return QuranAyahData(
          ayahNumber: ayah.ayaId,
          text: ayah.ayaText,
          surahNumber: ayah.surahId);
    }).toList();

    // resultList.forEach((ayah) {
    //   print(ayah.text);
    // });

    return resultList;
  }

  static List<SurahData> surahs = [];
  static Future<void> insertQuranFullTextIntoDB() async {
    if (surahs.length != 114)
      for (int i = 0; i < 114; i++) {
        print('parsing surah No. ${i + 1}');
        surahs.add(await compute(
          LocalQuranJsonFileLoader.parseSurah,
          LocalQuranJsonFileLoader.quranFileContent['data']['surahs'][i],
        ));
      }
    // await QuranTextSearchDatabaseHelper.instance.insertAyatIntoDB(surahs);
  }

  static bool doesSurahHaveBasmalah(int surahIndex) {
    // print('doesSurahHaveBasmalah surah Index: $surahIndex');
    return surahIndex != 1 && surahIndex != 9;
  }

  static String getAyahNumberStringInQuranFont(int number) {
    var firstAyah = int.parse(kAyatNumbersGlyphs[0], radix: 16);
    var ayaNumber = firstAyah + number - 1;

    return ayaNumber.toRadixString(16);
  }

  static String getSurahInQuranFont(int number) {
    return quranSurahsMetadata[number].arabicName;
    // return int.parse(kSurahsNamesGlyphs[number], radix: 16);
  }

  static int getAyahIntNumberInQuranFont(int number) {
    // print('getAyahIntNumberInQuranFont: $number');
    var firstAyah = int.parse(kAyatNumbersGlyphs[0], radix: 16);
    return firstAyah + number - 1;
  }

  static List<QuranPageData> quranPages = [];

  static Future mergeAllQuranPagesFiles() async {
    Directory homePath = await getApplicationDocumentsDirectory();

    if (quranPages.length < 604) {
      List<int> allPagesBytes = [];
      allPagesBytes.addAll('['.codeUnits);
      for (int i = 0; i < 604; i++) {
        print('loading page No. ${i + 1}');
        String myStr = await rootBundle.loadString(
          join(homePath.path, 'Quran', 'QuranPages${i + 1}.json'),
        );
        allPagesBytes.addAll(myStr.codeUnits);
        if (i + 1 < 604) allPagesBytes.addAll(','.codeUnits);
      }
      allPagesBytes.addAll(']'.codeUnits);
      await FilesDownloader.SaveFile('Quran', 'quranPages.json', allPagesBytes);
    }
  }

  static Future<void> getAllQuranPages() async {
    // http://api.alquran.cloud/v1/page/585/quran-uthmani

    List<int> bytes = [];

    // if (quranPages.length != 604)
    for (int i = 0; i < 604; i++) {
      print('parsing page No. ${i + 1}');

      await FilesDownloader.downloadFile(
        uri: Uri.https('api.alquran.cloud', '/v1/page/${i + 1}/quran-uthmani'),
        onDone: (fileBytes) async {
          bytes.addAll(fileBytes);
          print('page: ${i + 1} has been Downloaded');
          await FilesDownloader.SaveFile(
              '/Quran', 'QuranPages${i + 1}.json', fileBytes);
        },
        onError: (e) {
          print('page ${i + 1} was Downloaded with the Error: \n$e}');
        },
        onProgress: (progress) {
          print('progress: page ${i + 1}');
        },
      );
      await Future.delayed(Duration(seconds: 1));

      // surahs.add(await compute(
      //   LocalQuranJsonFileLoader.parseSurah,
      //   LocalQuranJsonFileLoader.quranFileContent['data']['surahs'][i],
      // ));
    }
    // await QuranTextSearchDatabaseHelper.instance.insertAyatIntoDB(surahs);
  }
}

class CanListenToQuranLoadingEventMixin {
  void onQuranHasBeenLoadedEvent() {}
  void onQuranTajweedHasBeenLoadedEvent() {}
}

class QuranTextSearchDatabaseHelper {
  static const _databaseName = 'quran.db';

  //singleton class
  QuranTextSearchDatabaseHelper._();
  static final QuranTextSearchDatabaseHelper instance =
      QuranTextSearchDatabaseHelper._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    print('_initDatabase');
    var dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);

    if (!await File(dbPath).exists()) {
      print(dbPath);
      ByteData data = await rootBundle.load(join("assets", _databaseName));

      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(dbPath).writeAsBytes(bytes);
    }
    print('openDatabase');

    return await openDatabase(dbPath);
  }

  // Future insertAyatIntoDB(List<SurahData> surahs) async {
  //   Database db = await databaseClean;
  //   String query;
  //   String aya;
  //   for (int i = 0, k = 1; i < surahs.length; i++) {
  //     for (int j = 0; j < surahs[i].ayatCount; j++, k++) {
  //       query = '''UPDATE ${QuranTextDBSearchResultData.tblName}
  //           SET ${QuranTextDBSearchResultData.colUthmaniAyahText} = ?
  //           WHERE ${QuranTextDBSearchResultData.colIndex} = ?''';
  //       // print('query: $query');
  //       aya = surahs[i].ayatData[j].text;
  //       // print('ayah No. $k: $aya');
  //       await db.rawUpdate(query, ['$aya', '$k']);
  //     }
  //   }
  // }

  Future<List> SearchForText(String searchText) async {
    Database db = await database;
    var query =
        'SELECT * FROM ${QuranTextDBSearchResultData.tblName} where ${QuranTextDBSearchResultData.colAyahText} like ?';
    print('query: $query');
    List<Map> ayat = await db.rawQuery(query, ['%$searchText%']);

    print('ayat: ${ayat.length}');

    if (ayat.length == 0)
      return [];
    else {
      return ayat.map((x) => QuranTextDBSearchResultData.fromMap(x)).toList();
    }
  }
}
