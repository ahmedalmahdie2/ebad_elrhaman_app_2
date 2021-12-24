part of 'tafseer_bloc.dart';

abstract class TafseerEvent extends Equatable {
  const TafseerEvent();

  @override
  List<Object> get props => [];
}

class GettingSurahMetadataEvent extends TafseerEvent {
  GettingSurahMetadataEvent();
  @override
  List<Object> get props => [];
}

class CheckTafseerBookFileExistEvent extends TafseerEvent {
  final int bookId;
  final String fileName;
  const CheckTafseerBookFileExistEvent(this.fileName, this.bookId);
  @override
  List<Object> get props => [fileName, bookId];
}

class StartDownloadBookEvent extends TafseerEvent {
  final String fileName;
  final int bookId;
  const StartDownloadBookEvent(this.fileName, this.bookId);
  @override
  List<Object> get props => [fileName, bookId];
}

class DownloadingTafseerBookEvent extends TafseerEvent {
  final int bookId;
  final int progress;
  const DownloadingTafseerBookEvent(this.bookId, this.progress);
  @override
  List<Object> get props => [bookId, progress];
}

class TafseerFinishedDownloadingEvent extends TafseerEvent {
  final int bookId;
  final List<SurahMetadata> surahsMetadata;
  final List<TafseerBook> tafseerBooks;
  const TafseerFinishedDownloadingEvent(
      this.surahsMetadata, this.tafseerBooks, this.bookId);
  @override
  List<Object> get props => [bookId, surahsMetadata, tafseerBooks];
}

class GetAyahTafseerEvent extends TafseerEvent {
  final int surahID;
  final int ayahID;
  final int bookID;
  final String bookName;
  const GetAyahTafseerEvent(
      this.bookID, this.surahID, this.ayahID, this.bookName);
  @override
  List<Object> get props => [bookID, surahID, ayahID, bookName];
}

class CancelDownloadingTafseerBookEvent extends TafseerEvent {
  final int bookID;
  const CancelDownloadingTafseerBookEvent(this.bookID);
  @override
  List<Object> get props => [bookID];
}
