part of 'hadith_bloc.dart';

abstract class HadithState extends Equatable {
  const HadithState();

  @override
  List<Object> get props => [];
}

class HadithInitialState extends HadithState {
  const HadithInitialState();
  @override
  List<Object> get props => [];
}

class GettingHadithBooksListState extends HadithState {
  const GettingHadithBooksListState();
  @override
  List<Object> get props => [];
}

class HadithIsReadyState extends HadithState {
  final HadithBookData book;
  const HadithIsReadyState(this.book);
  @override
  List<Object> get props => [book];
}

class HadithEntireBookFileReadyInStorageState extends HadithState {
  final HadithBookData book;
  final List<HadithSubBookData> subBooks;
  final String filePath;
  const HadithEntireBookFileReadyInStorageState(
      this.book, this.subBooks, this.filePath);
  @override
  List<Object> get props => [book, subBooks, filePath];
}

class HadithBookIsDownloadingState extends HadithState {
  final int bookId;
  final int progress;
  const HadithBookIsDownloadingState(this.bookId, this.progress);
  @override
  List<Object> get props => [bookId, progress];
}

class HadithNotDownloadedState extends HadithState {
  final String error;
  const HadithNotDownloadedState(this.error);
  @override
  List<Object> get props => [error];
}

class HadithBooksMetadataDownloadedState extends HadithState {
  final List<HadithBookData> books;
  const HadithBooksMetadataDownloadedState(this.books);
  @override
  List<Object> get props => [books];
}

class HadithBookNotDownloadedState extends HadithState {
  final HadithBookData book;
  const HadithBookNotDownloadedState(this.book);
  @override
  List<Object> get props => [book];
}

class HadithBookFileExistsState extends HadithState {
  final HadithBookData bookData;
  final int bookId;
  final String filePath;

  const HadithBookFileExistsState(this.bookData, this.bookId, this.filePath);
  @override
  List<Object> get props => [bookData, bookId, filePath];
}

class HadithBookFilesDontExistState extends HadithState {
  final HadithBookData bookData;
  final int bookId;
  final String filePath;
  const HadithBookFilesDontExistState(
      this.bookData, this.bookId, this.filePath);
  @override
  List<Object> get props => [bookData, bookId, filePath];
}

class HadithSubBookFileExistsState extends HadithState {
  final String subBookId;
  final int bookId;
  const HadithSubBookFileExistsState(this.subBookId, this.bookId);
  @override
  List<Object> get props => [
        subBookId,
        bookId,
      ];
}

class HadithBookMetadataFileExistsState extends HadithState {
  final String bookNameId;
  final int bookId;
  const HadithBookMetadataFileExistsState(this.bookNameId, this.bookId);
  @override
  List<Object> get props => [
        bookNameId,
        bookId,
      ];
}

class SubBookHadithsContentLoadedSuccessfullyState extends HadithState {
  final List<HadithData> hadiths;
  final String bookName;
  const SubBookHadithsContentLoadedSuccessfullyState(
      this.hadiths, this.bookName);
  @override
  List<Object> get props => [hadiths, bookName];
}

class HadithSubBookLoadedSuccessfullyState extends HadithState {
  final HadithSubBookData subBook;

  HadithSubBookLoadedSuccessfullyState(this.subBook);

  @override
  List<Object> get props => [subBook];
}
