class HadithSubBookScreenArguments {
  final List<String> bookTitle;
  final int bookId;
  final String bookNameId;

  HadithSubBookScreenArguments(this.bookTitle, this.bookId, this.bookNameId);
}

class HadithSubBookContentScreenArguments {
  final List<String> bookTitle;
  final List<String> subBookTitle;
  final int bookId;
  final String bookNameId;
  final int subBookId;
  final String filePath;

  HadithSubBookContentScreenArguments({
    this.bookTitle,
    this.subBookTitle,
    this.bookId,
    this.bookNameId,
    this.subBookId,
    this.filePath,
  });
}

class HadithContentApiArguments {
  final dynamic jsonContent;
  final int bookId;
  final String subBooKId;

  HadithContentApiArguments(this.jsonContent, this.bookId, this.subBooKId);
}

class HadithBookData {
  final int id;
  final String nameId;
  final List<String> name;
  final bool hasSubBooks;
  final bool hasChapters;

  HadithBookData(
      {this.id, this.nameId, this.name, this.hasSubBooks, this.hasChapters});

  factory HadithBookData.fromJson(Map<String, dynamic> json, int id) {
    // print(json.toString());
    return HadithBookData(
      id: id,
      nameId: json['name'],
      name: [json['collection'][1]['title'], json['collection'][0]['title']],
      hasSubBooks: json['hasBooks'],
      hasChapters: json['hasChapters'],
    );
  }
}

class HadithSubBookData {
  final int bookId;
  final int id;
  final List<String> name;
  final String hadithsLink;
  List<HadithData> hadiths;

  HadithSubBookData({this.id, this.bookId, this.hadithsLink, this.name});

  factory HadithSubBookData.fromJson(
      Map<String, dynamic> json, int bookId, int subBookId) {
    return HadithSubBookData(
      id: subBookId,
      name: [json['book'][1]['name'], json['book'][0]['name']],
      bookId: bookId,
      hadithsLink: json['hadith'],
    );
  }
}

class HadithData {
  final int bookId;
  final String subBookId;
  final String chapterId;
  final List<String> bookTitle;
  final List<String> subBookTitle;
  final List<String> chapterTitle;

  final String hadithNumber;
  final List<String> chapterName;

  final List<String> sanad;
  final List<String> matn;

  HadithData(
      {this.bookId,
      this.subBookId,
      this.chapterId,
      this.bookTitle,
      this.subBookTitle,
      this.chapterTitle,
      this.hadithNumber,
      this.chapterName,
      this.sanad,
      this.matn});

  factory HadithData.fromJson(
      Map<String, dynamic> json, int bookId, String subBookId) {
    return HadithData(
      bookTitle: [
        json['hadith'][1]['chapterTitle'],
        json['hadith'][0]['chapterTitle']
      ],
      subBookTitle: [
        json['hadith'][1]['chapterTitle'],
        json['hadith'][0]['chapterTitle']
      ],
      chapterName: [
        json['hadith'][1]['chapterTitle'],
        json['hadith'][0]['chapterTitle']
      ],
      bookId: bookId,
      subBookId: subBookId,
      chapterId: json['hadith'][1]['chapterNumber'],
      hadithNumber: json['hadithNumber'],
      // sanad: json['body'],
      matn: [json['hadith'][1]['body'], json['hadith'][0]['body']],
    );
  }
}
