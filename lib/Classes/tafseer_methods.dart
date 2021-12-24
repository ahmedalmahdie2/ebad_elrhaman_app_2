import 'dart:convert';
import 'dart:io';

import 'package:quranandsunnahapp/Classes/surah_metadata.dart';

class TafseerMethods {
  static Future<String> getTafseerText(int bookID, int surahID, int ayahID,
      List<SurahMetadata> allSurahs, File localFile) async {
    int sumStart = 0;
    int sumEnd = 0;

    for (int i = 1; i <= surahID; i++) {
      sumStart = sumEnd + allSurahs[i - 1].start;
      sumEnd = sumEnd + allSurahs[i - 1].end;
    }
    String content = await localFile.readAsString();
    dynamic json = jsonDecode(content);
    // print(sumStart.toString() +
    //     "   " +
    //     sumEnd.toString() +
    //     "   " +
    //     ayahID.toString());
    return (sumStart + (ayahID - 1) - 1) < json["data"].length
        ? json["data"][sumStart + (ayahID - 1) - 1]["text"].toString()
        : 'مع الأسف, لم نجد تفسير هذه الاية في هذا الكتاب. نعمل على اضافتها في القريب العاجل.';
  }
}
