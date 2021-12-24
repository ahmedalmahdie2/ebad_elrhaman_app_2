import 'dart:ui';

import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Classes/local_quran_loader.dart';
import 'package:quranandsunnahapp/Classes/surah_metadata.dart';
import 'dart:convert' as converter;

import 'package:quranandsunnahapp/Misc/constants.dart';

class SurahData {
  final int surahNumber;
  final String ayatWithNumbers;
  // final List<String> ayat;
  final bool hasBasmalah;
  final String source;
  final int ayatCount;
  final int firstPageIndex;
  final int lastPageIndex;
  //List<int> hizbQuarterIndex = [];
  List<QuranAyahData> ayatData;

  SurahData(
      {this.firstPageIndex,
      this.lastPageIndex,
      this.surahNumber,
      this.ayatWithNumbers,
      // this.ayat,
      this.hasBasmalah,
      this.source,
      this.ayatCount,
      this.ayatData});

  static String getAyatWithNumbers(
      dynamic json, int surahNumber, String surahName) {
    int i = 1;
    List<QuranAyahData> tempAyat = [];
    String allAyat = '';
    int ayaNumber = 0;

    QuranAyahData previousAyah;
    json.forEach(
      (ayah) {
        tempAyat.add(
          previousAyah = QuranAyahData.fromJson(
              json: ayah, surahNumber: surahNumber, previousAyah: previousAyah),
        );
      },
    );

    tempAyat.forEach(
      (ayah) {
        allAyat = allAyat + ayah.ayahTextWithNumber();
      },
    );

    return allAyat;
  }

  static List<QuranAyahData> getAllInfo(
      dynamic json, int surahNumber, String surahName) {
    List<QuranAyahData> tempAyat = [];
    List<String> allAyat = [];
    int ayaNumber = 0;

    QuranAyahData previousAyah;
    json.forEach(
      (ayah) {
        tempAyat.add(
          previousAyah = QuranAyahData.fromJson(
              json: ayah, surahNumber: surahNumber, previousAyah: previousAyah),
        );
      },
    );
    print(tempAyat[0].quarterNumber);
    return tempAyat;
  }

  static List<String> getAyat(dynamic json, int surahNumber, String surahName) {
    List<QuranAyahData> tempAyat = [];
    List<String> allAyat = [];
    int ayaNumber = 0;

    QuranAyahData previousAyah;
    json.forEach(
      (ayah) {
        tempAyat.add(
          previousAyah = QuranAyahData.fromJson(
              json: ayah, surahNumber: surahNumber, previousAyah: previousAyah),
        );
      },
    );

    tempAyat.forEach(
      (ayah) {
        allAyat.add(ayah.text);
      },
    );

    return allAyat;
  }

  factory SurahData.fromJson(Map<String, dynamic> json) {
    return SurahData(
      surahNumber: json['number'],
      // chapterName: [
      //   json['name'],
      //   json['englishName'],
      //   json['englishNameTranslation']
      // ],
      ayatWithNumbers:
          getAyatWithNumbers(json['ayahs'], json['number'], json['name']),
      // ayat: getAyat(json['ayahs'], json['number'], json['name']),
      ayatData: getAllInfo(json['ayahs'], json['number'], json['name']),
      source: json['revelationType'],
      hasBasmalah: json['number'] != 1 && json['number'] != 9,
      ayatCount: json['ayahs'].length,
      firstPageIndex: json['ayahs'][0]['page'],
      lastPageIndex: json['ayahs'][json['ayahs'].length - 1]['page'],
    );
  }
}

class QuranTajweedAyahData {
  final List<Color> colors;
  final List<String> parts;
  const QuranTajweedAyahData({this.colors, this.parts});

  factory QuranTajweedAyahData.fromJson(String ayah) {
    List<Color> tempColors = [];
    List<String> tempParts = [];
    var matches = ayah.split('[');
    int firstMatchIndex = ayah.indexOf('[');

    int partsIndex = 0;
    if (firstMatchIndex > 0) {
      // print('color: ${kQuranTajweedCodeColorMap['normal']}');
      // print('text: ${ayah.substring(0, ayah.indexOf('['))}');
      tempColors.add(kQuranTajweedCodeColorMap['normal']);
      tempParts.add(ayah.substring(0, ayah.indexOf('[')));
      // partsIndex++;
    }

    for (int i = firstMatchIndex == 0 ? 0 : 1; i < matches.length; i += 2) {
      // var mojawwadTextEnd = matches[i + 1].indexOf(']');

      var subParts = matches[i + 1].split(']');
      tempColors.add(kQuranTajweedCodeColorMap[matches[i][0]]);
      tempParts.add(subParts[0]);
      // print('color: ${kQuranTajweedCodeColorMap[matches[i][0]]}');
      // print('text: ${subParts[0]}');
      partsIndex++;
      if (subParts.length > 1) {
        // print('color: ${kQuranTajweedCodeColorMap['normal']}');
        // print('text: ${subParts[1]}');
        tempColors.add(kQuranTajweedCodeColorMap['normal']);
        tempParts.add(subParts[1]);
        partsIndex++;
      }
    }

    return QuranTajweedAyahData(colors: tempColors, parts: tempParts);
  }
}

class QuranPageData {
  final int pageNumber;
  final List<QuranAyahData> ayatData;
  final List<QuranTajweedAyahData> ayatTajweedData;

  // List<pageContentType> cotentTypesList;

  QuranPageData({
    // this.surahsRanges,
    this.ayatData,
    this.pageNumber,
    this.ayatTajweedData,
  });

  static List<QuranAyahData> getAyatData(
      dynamic json, dynamic quranTextJson, int pageIndex) {
    List<QuranAyahData> tempAyat = [];

    Map<String, dynamic> surahs = json['surahs'];

    int surahIndex = surahs.values.first['number'];
    // int numberOfSurahsInPage = surahs.values.length;
    // List<int> surahsAyatCount =
    //     surahs.values.map((surah) => surah['numberOfAyahs'] as int).toList();
    // List<int> surahsIndices =
    //     surahs.values.map((surah) => surah['number'] as int).toList();
    //
    // int pageAyahs = json['ayahs'].length;

    // for (int i = 0; i < surahsAyatCount.length; i++) {
    //   print('surah ayat: ${surahsAyatCount[i]}');
    // }

    QuranAyahData previousAyah =
        LocalQuranJsonFileLoader.getInitialPreviousAyah(
            json, quranTextJson, surahIndex - 1, pageIndex);

    if (previousAyah != null)
      print('previousAyha Number: ${previousAyah.ayahNumber}');

    for (int i = 0; i < json['ayahs'].length; i++) {
      surahIndex = json['ayahs'][i]['surah']['number'];
      // print('getAyatData: surahIndex: ${surahIndex - 1}, ayahIndex: $i');
      tempAyat.add(QuranAyahData.fromJson(
        json: quranTextJson[surahIndex - 1]['ayahs']
            [json['ayahs'][i]['numberInSurah'] - 1],
        surahNumber: surahIndex,
        previousAyah: previousAyah,
      ));
      previousAyah = tempAyat[i];
    }

    // json['ayahs'].forEach((ayah) {
    //
    //   tempAyat.add();
    //
    //
    // });

    return tempAyat;
  }

  static List<QuranTajweedAyahData> getAyatTajweedData(
      dynamic json, dynamic quranTextJson, int pageIndex) {
    List<QuranAyahData> tempAyat = [];
    List<QuranTajweedAyahData> tempMojawwadAyat = [];

    Map<String, dynamic> surahs = json['surahs'];

    int surahIndex = surahs.values.first['number'];

    QuranAyahData previousAyah =
        LocalQuranJsonFileLoader.getInitialPreviousAyah(
            json, quranTextJson, surahIndex - 1, pageIndex);

    if (previousAyah != null)
      print('previousAyha Number: ${previousAyah.ayahNumber}');

    for (int i = 0; i < json['ayahs'].length; i++) {
      surahIndex = json['ayahs'][i]['surah']['number'];
      // print('getAyatData: surahIndex: ${surahIndex - 1}, ayahIndex: $i');
      tempAyat.add(QuranAyahData.fromJson(
        json: quranTextJson[surahIndex - 1]['ayahs']
            [json['ayahs'][i]['numberInSurah'] - 1],
        surahNumber: surahIndex,
        previousAyah: previousAyah,
      ));
      tempMojawwadAyat.add(LocalQuranJsonFileLoader.parseMojawwadAyah(
          surahIndex - 1, json['ayahs'][i]['numberInSurah'] - 1));
      previousAyah = tempAyat[i];
    }

    return tempMojawwadAyat;
  }

  factory QuranPageData.fromJson(
      dynamic json, dynamic quranTextJson, int pageIndex,
      {bool isMojawwad = false}) {
    if (isMojawwad)
      return QuranPageData(
        ayatData: getAyatData(json, quranTextJson, pageIndex),
        pageNumber: json['ayahs'][0]['page'],
        ayatTajweedData: getAyatTajweedData(json, quranTextJson, pageIndex),
      );
    return QuranPageData(
      ayatData: getAyatData(json, quranTextJson, pageIndex),
      pageNumber: json['ayahs'][0]['page'],
    );
  }
}

class QuranAyahMetadataInQuranPageData {
  final bool hasSajdah;
  final int ayahNumber;
  final int surahNumber;
  // final bool isJuzStart;
  // final bool isHezbStart;
  // final bool isQuarterStart;
  final int juzNumber;
  final int quarterNumber;
  final int pageNumber;
  // final bool isPageBody;
  final bool isPageStart;
  // final bool isPageEnd;

  QuranAyahMetadataInQuranPageData(
      {this.hasSajdah,
      this.ayahNumber,
      this.surahNumber,
      // this.isJuzStart,
      // this.isHezbStart,
      // this.isQuarterStart,
      this.juzNumber,
      this.quarterNumber,
      this.pageNumber,
      this.isPageStart});

  factory QuranAyahMetadataInQuranPageData.fromJson(
      dynamic json, bool isPageStart) {
    // print('QuranAyahMetadataInQuranPageData: ');

    return QuranAyahMetadataInQuranPageData(
      pageNumber: json['page'],
      ayahNumber: json['numberInSurah'],
      surahNumber: json['surah']['number'],
      hasSajdah: false,
      juzNumber: json['juz'],
      quarterNumber: json['hizbQuarter'],
      isPageStart: isPageStart,
      // isJuzStart: previousAyah == null || previousAyah.juzNumber < json['juz'],
      // isQuarterStart: previousAyah == null ||
      //     previousAyah.quarterNumber < json['hizbQuarter'],
    );
  }
}

class QuranJuzData {
  final int ayahNumber;
  final int surahNumber;
  final int juzNumber;

  QuranJuzData({
    this.juzNumber,
    this.ayahNumber,
    this.surahNumber,
  });
}

class QuranAyahData {
  final String text;
  final QuranAyahMetadataInQuranPageData ayahMetadata;
  final bool hasSajdah;
  final int ayahNumber;
  final int surahNumber;
  final bool isJuzStart;
  final bool isHezbStart;
  final bool isQuarterStart;
  final int juzNumber;
  final int quarterNumber;
  final int pageNumber;
  final bool isPageBody;
  final bool isPageStart;
  final bool isPageEnd;

  String ayahTextWithNumber({bool addAyahNumber = true}) {
    // print('${HelperMethods.ConvertDigitsToLatin(ayahNumber)}');
    return text != null && text.trim().isNotEmpty
        ? text.trim() +
            (addAyahNumber
                ? ' ${HelperMethods.convertDigitsIntoArabic(ayahNumber)} '
                : '')
        : '';
  }

  QuranAyahData({
    this.text,
    this.hasSajdah,
    this.ayahNumber,
    this.surahNumber,
    this.juzNumber,
    this.quarterNumber,
    this.pageNumber,
    this.isJuzStart,
    this.isHezbStart,
    this.isQuarterStart,
    this.isPageBody,
    this.isPageStart,
    this.isPageEnd,
    this.ayahMetadata,
  });

  static String removeBasmalah(int an, int sn, String ayah) {
    if (an == 1 && sn != 1 && sn != 9) {
      print('removing basmalah in ayah $an');
      return ayah.substring(39);
    }
    return ayah;
  }

  factory QuranAyahData.fromJson(
      {Map<String, dynamic> json,
      int surahNumber,
      QuranAyahData previousAyah,
      bool ignoreStartFlags = false}) {
    return QuranAyahData(
      surahNumber: surahNumber,
      ayahNumber: json['numberInSurah'],
      text: removeBasmalah(json['numberInSurah'], surahNumber, json['text']),
      hasSajdah: false,
      juzNumber: json['juz'],
      quarterNumber: json['hizbQuarter'],
      pageNumber: json['page'],
      isPageStart: ignoreStartFlags
          ? false
          : previousAyah == null ||
              previousAyah != null && previousAyah.pageNumber < json['page'],
      isJuzStart: ignoreStartFlags
          ? false
          : previousAyah == null ||
              previousAyah != null && previousAyah.juzNumber < json['juz'],
      isQuarterStart: ignoreStartFlags
          ? false
          : previousAyah == null ||
              previousAyah != null &&
                  previousAyah.quarterNumber < json['hizbQuarter'],
    );
  }

  factory QuranAyahData.fromTajweedJson(
      {Map<String, dynamic> json,
      int ayahNumber,
      int surahNumber,
      String surahName}) {
    // print(json['text']);

    return QuranAyahData(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      text: json['text_uthmani_tajweed'],
      hasSajdah: false,
      // juzNumber: json['juz'],
      // quarterNumber: json['hizQuarter'],
    );
  }
}

class QuranTextDBSearchResultData {
  static const tblName = 'quran_text';
  static const colSurahId = 'sura';
  static const colAyahId = 'aya';
  static const colAyahText = 'text';
  static const colIndex = 'id';
  static const colUthmaniAyahText = 'text_full';

  final String ayaText;
  final int surahId;
  final int ayaId;
  final int ayahIndex;
  QuranAyahData ayahData;

  QuranTextDBSearchResultData({
    this.ayaText,
    this.surahId,
    this.ayaId,
    this.ayahIndex,
  });

  factory QuranTextDBSearchResultData.fromMap(Map<String, dynamic> map) {
    return QuranTextDBSearchResultData(
      ayaText: map[colUthmaniAyahText],
      surahId: int.parse(map[colSurahId]),
      ayaId: int.parse(map[colAyahId]),
      ayahIndex: int.parse(map[colIndex]),
    );
  }
}

class QuranTextJSONSearchResultData {
  final String searchText;
  final int resultsCount;
  final int numberOfPages;
  static const resultsPerPage = 20;
  List<List<QuranAyahData>> searchResultAyat;

  QuranTextJSONSearchResultData({
    this.searchText,
    this.resultsCount,
    this.numberOfPages,
  });

  factory QuranTextJSONSearchResultData.fromMap(
      Map<String, dynamic> json, String searchText) {
    return QuranTextJSONSearchResultData(
      resultsCount: json['search']['total_results'],
      searchText: searchText,
      numberOfPages: (json['search']['total_results'] / resultsPerPage) +
          (json['search']['total_results'] % resultsPerPage > 0 ? 1 : 0),
    );
  }
}

class TajweedData {
  dynamic ayatListContent;
  List<SurahMetadata> quranSurahsMetadata;
  List<List<int>> surahsAyatStartsEnds; //[[1, 7], [8, 293]. [294, 493]]
  List<QuranAyahData> quranAyatData;
  TajweedData(
      {this.ayatListContent,
      this.quranSurahsMetadata,
      this.surahsAyatStartsEnds,
      this.quranAyatData});
}
