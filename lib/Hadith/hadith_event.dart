part of 'hadith_bloc.dart';

abstract class HadithEvent extends Equatable {
  const HadithEvent();

  @override
  List<Object> get props => [];
}

class GettingHadithBooksMetadataEvent extends HadithEvent {
  GettingHadithBooksMetadataEvent();
  @override
  List<Object> get props => [];
}

class GettingHadithBookMetadataEvent extends HadithEvent {
  final int bookId;
  GettingHadithBookMetadataEvent(this.bookId);
  @override
  List<Object> get props => [bookId];
}

class CheckHadithBookFileExistsEvent extends HadithEvent {
  final HadithBookData bookData;

  const CheckHadithBookFileExistsEvent(this.bookData);
  @override
  List<Object> get props => [bookData];
}

class DownloadHadithEntireBookEvent extends HadithEvent {
  final String fileName;
  final int bookId;
  const DownloadHadithEntireBookEvent(this.fileName, this.bookId);
  @override
  List<Object> get props => [fileName, bookId];
}

class HadithEntireBookIsDownloadingEvent extends HadithEvent {
  final int bookId;
  final int progress;
  const HadithEntireBookIsDownloadingEvent(this.bookId, this.progress);
  @override
  List<Object> get props => [bookId, progress];
}

class HadithEntireBookFileExistsInStorageEvent extends HadithEvent {
  // final File file;
  final String filePath;
  final int bookId;
  const HadithEntireBookFileExistsInStorageEvent(this.filePath, this.bookId);
  @override
  List<Object> get props => [filePath, bookId];
}

class HadithBookFileDontExistInStorageEvent extends HadithEvent {
  // final File file;
  final String filePath;
  final int bookId;
  const HadithBookFileDontExistInStorageEvent(this.filePath, this.bookId);
  @override
  List<Object> get props => [filePath, bookId];
}

class HadithEntireBookDownloadUnsuccessfulEvent extends HadithEvent {
  final String fileName;
  final int bookId;
  const HadithEntireBookDownloadUnsuccessfulEvent(this.fileName, this.bookId);
  @override
  List<Object> get props => [fileName, bookId];
}

class HadithEntireBookMetadataDownloadSuccessfulEvent extends HadithEvent {
  final String fileName;
  final int bookId;
  const HadithEntireBookMetadataDownloadSuccessfulEvent(
      this.fileName, this.bookId);
  @override
  List<Object> get props => [fileName, bookId];
}

class GetHadithSubBookContentEvent extends HadithEvent {
  final String filePath;
  final int bookId;
  final int subBookId;
  const GetHadithSubBookContentEvent(
      this.filePath, this.bookId, this.subBookId);
  @override
  List<Object> get props => [filePath, bookId, subBookId];
}
