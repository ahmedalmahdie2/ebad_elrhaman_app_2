import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:quranandsunnahapp/Classes/DuaaModel.dart';
import 'package:quranandsunnahapp/Classes/telawa_data.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';

import 'azkar_data.dart';
import 'hadith_books_subBooks_chapters_hadiths_data.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

class HelperMethods {
  static NumberFormat formatter = NumberFormat('###');

  static String getNumberFormated(int number) {
    String formattedNumber = formatter.format(number);
    final originalLength = formattedNumber.length;
    for (int i = 0; i < 3 - originalLength; i++) {
      formattedNumber = '0' + formattedNumber;
    }
    return formattedNumber;
  }

  static String getMainCategoryScreenTitle(int index) {
    return index >= 0 && index < kMainCategoriesNames.length
        ? kMainCategoriesNames[index][0]
        : "القرآن والسنة";
  }

  static String getAzkarTitle(int index) {
    return index >= 0 && index < kMainPrayersNames.length
        ? kMainPrayersNames[index]
        : "أذكار";
  }

  static Future<Map<String, dynamic>> loadAzkarFile() async {
    var data = await rootBundle
        .loadString("assets/azkar/azkar_with_translations.json");
    return jsonDecode(data);
  }

  static Future<dynamic> loadDuaaFile() async {
    var data = await rootBundle.loadString("assets/ss.json");
    return jsonDecode(data);
  }

  static List<HadithBookData> parseHadithBooks(dynamic content) {
    List<HadithBookData> hadithBooksData = [];
    int index = 0;
    // print(content.toString());
    content.forEach((hadithCollectoion) {
      hadithBooksData.add(HadithBookData.fromJson(hadithCollectoion, index++));
    });

    return hadithBooksData;
  }

  static Future<List<Telawa>> getAllTelawa() async {
    String url = 'www.fastworldsolutions.com';
    String secondPart = "/islamic/public/api/quran/audio.sura";
    http.Response response = await http.get(Uri.https(url, secondPart));
    print(Uri.https(url, secondPart).toString());
    if (response.statusCode == 200) {
      List<dynamic> parsed = jsonDecode(response.body);
      int index = 0;
      List<Telawa> myList =
          parsed.map((dynamic item) => Telawa.fromJson(item, index++)).toList();
      print('i am here');
      return myList;
    } else {
      print('i am here ${response.statusCode}');
    }
  }

  static Future<String> getURLforTelawa(
      int indexofQarea, int indexofSurah) async {
    String url = 'www.fastworldsolutions.com';
    String secondPart = "/islamic/public/api/quran/audio.sura/" +
        indexofQarea.toString() +
        "/" +
        indexofSurah.toString();
    http.Response response = await http.get(Uri.https(url, secondPart));
    if (response.statusCode == 200) {
      String url = response.body;
      print('getURLforTelawa link: $url');
      return url;
    } else
      return "error";
  }

  static Uri getURLforZekr(AzkarData zekr) {
    // "https://fastworldsolutions.com/islamic/public/api/azkar/audio/1"
    String url = 'www.fastworldsolutions.com';
    String secondPart = "/islamic/public/api/azkar/audio/" + zekr.audioFileName;
    return Uri.https(url, secondPart);
  }

  static List<AzkarGroupData> azkarGroups = [];

  static List<AzkarGroupData> parseAzkar(Map<String, dynamic> content) {
    if (azkarGroups.isNotEmpty) azkarGroups.clear();

    //
    // for (int i = 0; i < content.values.length; i++)
    //   print(content.values.elementAt(i).toString());
    int groupIndex = 0;

    content.values.forEach((azkarGroup) {
      int subgroupIndex = 0;
      List<AzkarSubgroupData> azkarSubgroups = [];

      azkarGroup["category"].values.forEach((subgroup) {
        azkarSubgroups.add(
          AzkarSubgroupData.fromJson(
            index: subgroupIndex++,
            titles: [
              subgroup['language_ar'],
              subgroup["language_en"] ?? subgroup['language_ar'],
            ],
            parentGroupIndex: groupIndex,
            azkar: List<AzkarData>.generate(
              subgroup["zeker"].length,
              (index) => AzkarData.fromJson(
                  json: subgroup["zeker"][index],
                  titles: [
                    subgroup['language_ar'],
                    subgroup["language_en"] ?? subgroup['language_ar']
                  ],
                  index: index),
            ),
          ),
        );
      });

      azkarGroups.add(
        AzkarGroupData.fromJson(
            index: groupIndex++,
            titles: [azkarGroup["language_ar"], azkarGroup["language_en"]],
            subgroups: azkarSubgroups),
      );
    });

    return azkarGroups;
  }

  static List<DuaaGroup> parseDuaa(dynamic content) {
    List<DuaaGroup> allGroups = [];
    List<DuaaModel> allDuaa = [];

    content["data"]["أدعية من القرآن"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa, duaaNameGroup: "أدعية من القرآن", subGroups: null));

    ////////////////////////////////////////////////////////////////////////////
    allDuaa = [];
    content["data"]["جوامع الدعاء"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa, duaaNameGroup: "جوامع الدعاء", subGroups: null));

    ////////////////////////////////////////////////////////////////////////////
    allDuaa = [];
    content["data"]["أدعية النَّبِيِّ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ"]
        .forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa,
        duaaNameGroup: "أدعية النَّبِيِّ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ",
        subGroups: null));
    ///////////////////////////////////////////////////////////////////////////////
    allDuaa = [];

    content["data"]["أدعية ألأنبياء"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson2(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa, duaaNameGroup: "أدعية ألأنبياء", subGroups: null));
    //////////////////////////////////////////////////////////////////////////
    content["data"]["فضل الذكر"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa, duaaNameGroup: "فضل الذكر", subGroups: null));

    ///////////////////////////////////////////////////////////////////////
    allDuaa = [];
    content["data"]["أدعية مختارة "].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa, duaaNameGroup: "أدعية مختارة", subGroups: null));
    //////////////////////////////////////////////////////////////////////////

    allDuaa = [];

    content["data"]["ثناء ومناجاة من السنة النبوية"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa,
        duaaNameGroup: "ثناء ومناجاة من السنة النبوية",
        subGroups: null));
    //////////////////////////////////////////////////////////////////////////
    allDuaa = [];

    content["data"]["ثناء ومناجاة من كلام الصحابة والتابعين"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa,
        duaaNameGroup: "ثناء ومناجاة من كلام الصحابة والتابعين",
        subGroups: null));

    //////////////////////////////////////////////////////////////////////////
    allDuaa = [];

    content["data"][" مناجاة المحبين"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa, duaaNameGroup: "مناجاة المحبين", subGroups: null));
    //////////////////////////////////////////////////////////////////////////
    allDuaa = [];

    content["data"]["أدعية للمتوفى (ذكور)"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa,
        duaaNameGroup: "أدعية للمتوفى (ذكور)",
        subGroups: null));

    //////////////////////////////////////////////////////////////////////////
    allDuaa = [];

    content["data"]["أدعية للمتوفية (إناث)"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa,
        duaaNameGroup: "أدعية للمتوفية (إناث)",
        subGroups: null));

    /////////////////////////////////////////////////////////////////////////
    allDuaa = [];

    content["data"]["أدعية للميّت الطفل الصغير (ذكر أو أنثى)"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa,
        duaaNameGroup: "أدعية للميّت الطفل الصغير (ذكر أو أنثى)",
        subGroups: null));
    /////////////////////////////////////////////////////////////////////////////////////////////
    allDuaa = [];

    content["data"]["الدّعاء للميّت في صّلاة الجنازة"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa,
        duaaNameGroup: "الدّعاء للميّت في صّلاة الجنازة",
        subGroups: null));
    /////////////////////////////////////////////////////////////////////////////////////////////
    allDuaa = [];

    content["data"]["دُعَاءُ خَتْمِ القُرْآنِ الكَريمِ"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa,
        duaaNameGroup: "دُعَاءُ خَتْمِ القُرْآنِ الكَريمِ",
        subGroups: null));

    /////////////////////////////////////////////////////////////////////////////////////////////
    allDuaa = [];

    content["data"]["الرُّقية الشرعية من القرآن الكريم"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa,
        duaaNameGroup: "الرُّقية الشرعية من القرآن الكريم",
        subGroups: null));
    /////////////////////////////////////////////////////////////////////////////////////////////
    allDuaa = [];

    content["data"]["الرُّقية الشرعية من السنة النبوية"].forEach((duaa) {
      allDuaa.add(DuaaModel.fromJson(duaa));
    });
    allGroups.add(DuaaGroup(
        duaaList: allDuaa,
        duaaNameGroup: "الرُّقية الشرعية من السنة النبوية",
        subGroups: null));
    return allGroups;
  }

  static List<AzkarData> parsePrayers(dynamic content) {
    List<AzkarData> azkar = [];
    int index = 0;
    content['data'].forEach(
      (zekr) {
        azkar.add(
          AzkarData.fromJson(
              json: zekr,
              titles: ["جوامع الدعاء", "جوامع الدعاء"],
              index: index++),
        );
      },
    );

    return azkar;
  }

  static List<HadithSubBookData> parseHadithSubBooks(
      dynamic content, int bookId) {
    List<HadithSubBookData> hadithSubBooksData = [];
    int index = 0;
    // print(content.toString());
    content.forEach((hadithSubBook) {
      hadithSubBooksData
          .add(HadithSubBookData.fromJson(hadithSubBook, bookId, index++));
    });

    return hadithSubBooksData;
  }

  static List<HadithData> parseHadithChapter(
      HadithContentApiArguments content) {
    List<HadithData> hadithData = [];
    // print(content.toString());
    content.jsonContent.forEach((hadith) {
      hadithData
          .add(HadithData.fromJson(hadith, content.bookId, content.subBooKId));
    });

    return hadithData;
  }

  static Future<dynamic> loadHadithBooksListFile() async {
    print('trying to loadHadithBooksListFile');
    var data = await rootBundle.loadString("assets/HadithCollectionsList.json");
    return jsonDecode(data);
  }

  static Future<dynamic> loadHadithBukhariSubBooksListFile() async {
    print('trying to loadHadithBukhariSubBooksListFile');
    var data = await rootBundle.loadString("assets/BukhariBooksList.json");
    return jsonDecode(data);
  }

  static Future<dynamic> loadHadithBukhariSubBookHadithsFile(int index) async {
    print('trying to loadHadithBukhariSubBookHadithsFile');
    var data = await rootBundle.loadString("assets/BukhariBooks_1.json");
    return jsonDecode(data);
  }

  static Future<dynamic> loadQuranMetadata() async {
    var data =
        await rootBundle.loadString("assets/quran/quran_chapters_list.json");
    return jsonDecode(data);
  }

  static RoundedRectangleBorder get clippedCardShape => RoundedRectangleBorder(
        side: BorderSide(width: 2),
        borderRadius: BorderRadius.circular(20.0),
      );

  static String getSystemTime() {
    return DateFormat("H:m:s").format(DateTime.now());
  }

  static String getSystemDate(int day) {
    return DateFormat("yyyy-MM-dd")
            .format(DateTime.now().add(Duration(days: day))) +
        ' ${getSystemWeekDayByIndex(DateTime.now().add(Duration(days: day)).weekday)}';
  }

  static String getTimeFormated(DateTime time) {
    return DateFormat("H:M").format(time) +
        (time.hour > 12 ? ' مساءًً' : 'صباحًا ');
  }

  static String getSystemWeekDayByIndex(int index) {
    return kWeekDaysList[index - 1][0];
  }

  static ArabicNumbers arabicNumber = ArabicNumbers();

  static String convertDigitsIntoArabic(int s) {
    return arabicNumber.convert(s);
  }

  static Future<dynamic> getCurrentAzan(
      int month, int year, double lat, double long) async {
    String firstUrl = "www.fastworldsolutions.com";

    String secondPart = "/islamic/public/api/azan/";
    try {
      http.Response response = await http.get(Uri.https(firstUrl, secondPart, {
        "latitude": lat.toString(),
        "longitude": long.toString(),
        "month": month.toString(),
        "year": year.toString()
      }));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      var data = await rootBundle.loadString("assets/testazan.json");
      return jsonDecode(data);
    }
  }

  static isArabic(BuildContext context) {
    return context.locale == Locale('ar', 'AR');
  }

  static bool isDarkMode(BuildContext context) {
    return SchedulerBinding.instance.window.platformBrightness ==
        Brightness.dark;
  }

  static Widget getErrorLoadingWidget(String message, Function onTap,
      {TextStyle style}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Column(
            children: [
              Icon(
                Icons.error,
                size: 45,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                message ?? 'Couldn\'t load file .. please try again later.',
                style: style,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget loadingWidget = Center(
    child: Theme(
      data: ThemeData.light().copyWith(accentColor: kMainAppColor01),
      child: new CircularProgressIndicator(),
    ),
  );

  static int getIntParsedString(String count, {int defaultValue = 0}) {
    return count != null && count.isNotEmpty ? int.parse(count) : defaultValue;
  }

  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }
}
