import 'dart:convert';
import 'dart:io';

import 'package:quranandsunnahapp/Classes/hadith_books_subBooks_chapters_hadiths_data.dart';

class HadithMethods {
  static List<bool> hasReadFiles = [];
  static List<String> contents = [];
  static List<dynamic> jsons = [];
  static List<List<HadithSubBookData>> booksSubbooks = [];
  static List<List<List<HadithData>>> booksSubbooksHadiths = [];

  static void initializeHadithBooks(int numberOfBooks) {
    for (int i = 0; i < numberOfBooks; i++) {
      hasReadFiles.add(false);
      contents.add(null);
      jsons.add(null);
      booksSubbooks.add([]);
      booksSubbooksHadiths.add([]);
    }
  }

  static bool isBookIdValid(int bookId) {
    return bookId >= 0 && bookId < hasReadFiles.length;
  }

  static Future<List<HadithSubBookData>> getHadithBookSubbooks(
      int bookId, File localFile) async {
    if (isBookIdValid(bookId)) {
      if (!hasReadFiles[bookId]) {
        hasReadFiles[bookId] = true;
        contents[bookId] = await localFile.readAsString();
        jsons[bookId] = jsonDecode(contents[bookId]);
        booksSubbooks[bookId] = [];
        int subBookId = 0;
        jsons[bookId].forEach(
          (subBook) {
            booksSubbooks[bookId]
                .add(HadithSubBookData.fromJson(subBook, bookId, subBookId++));
            booksSubbooksHadiths[bookId].add([]);
          },
        );
      }

      return booksSubbooks[bookId];
    }
    return null;
  }

  static Future<List<HadithData>> getSubBookHadiths(
      int bookId, File localFile, int subBookId) async {
    if (isBookIdValid(bookId)) {
      // contents[bookId] = await localFile.readAsString();
      // jsons[bookId] = jsonDecode(utf8.decode(contents[bookId].codeUnits));
      // booksSubbooks[bookId] = [];
      // print(
      //     'booksSubbooksHadiths[bookId].length ${booksSubbooksHadiths[bookId].length}, subBookId: ${subBookId}');
      booksSubbooksHadiths[bookId][subBookId] = [];

      if (jsons[bookId][subBookId].containsKey('data') &&
          jsons[bookId][subBookId]['data'].containsKey('data'))
        jsons[bookId][subBookId]['data']['data'].forEach(
          (hadith) {
            booksSubbooksHadiths[bookId][subBookId]
                .add(HadithData.fromJson(hadith, bookId, subBookId.toString()));
          },
        );

      return booksSubbooksHadiths[bookId][subBookId];
    }
    return null;
  }
}
