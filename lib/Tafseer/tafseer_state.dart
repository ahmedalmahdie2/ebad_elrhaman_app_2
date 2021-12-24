part of 'tafseer_bloc.dart';

abstract class TafseerState extends Equatable {
  const TafseerState();

  @override
  List<Object> get props => [];
}

class TafseerInitialState extends TafseerState {
  const TafseerInitialState();
  @override
  List<Object> get props => [];
}

class TafseerBooksListDownloadedState extends TafseerState {
  final List<SurahMetadata> surahsMetadata;
  final List<TafseerBook> tafseerBooks;
  const TafseerBooksListDownloadedState(this.surahsMetadata, this.tafseerBooks);
  @override
  List<Object> get props => [surahsMetadata, tafseerBooks];
}

class TafseerBooksListNotDownloadedState extends TafseerState {
  final String error;
  const TafseerBooksListNotDownloadedState(this.error);
  @override
  List<Object> get props => [error];
}

class TafseerBookDownloadedState extends TafseerState {
  final int downloadedBookId;
  final List<SurahMetadata> surahsMetadata;
  final List<TafseerBook> allBooks;
  const TafseerBookDownloadedState(
      this.downloadedBookId, this.surahsMetadata, this.allBooks);
  @override
  List<Object> get props => [downloadedBookId, surahsMetadata, allBooks];
}

class TafseerBookNotDownloadedState extends TafseerState {
  final List<SurahMetadata> surahsMetadata;
  final List<TafseerBook> allBooks;
  const TafseerBookNotDownloadedState(this.surahsMetadata, this.allBooks);
  @override
  List<Object> get props => [surahsMetadata, allBooks];
}

class TafseerTextLoadedSuccessfullyState extends TafseerState {
  final String text;
  final List<SurahMetadata> surahsMetadata;
  final List<TafseerBook> allBooks;
  const TafseerTextLoadedSuccessfullyState(
      this.text, this.surahsMetadata, this.allBooks);
  @override
  List<Object> get props => [text];
}

class TafseerInDownloadingState extends TafseerState {
  final int bookId;
  final int progress;
  const TafseerInDownloadingState(this.bookId, this.progress);
  @override
  List<Object> get props => [bookId, progress];
}
