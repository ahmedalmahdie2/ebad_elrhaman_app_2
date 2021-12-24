part of 'quran_bloc.dart';

abstract class QuranState extends Equatable {
  final bool isMojawwad;
  const QuranState({this.isMojawwad = false});
  @override
  List<Object> get props => [isMojawwad];
}

class QuranInitialState extends QuranState {
  final bool isMojawwad;
  const QuranInitialState({this.isMojawwad = false});
  @override
  List<Object> get props => [isMojawwad];
}

class SurahsMetaDataLoadedSuccessfullyState extends QuranState {
  final bool isMojawwad;
  final List<SurahMetadata> surahsMetadata;
  const SurahsMetaDataLoadedSuccessfullyState(this.surahsMetadata,
      {this.isMojawwad = false});
  @override
  List<Object> get props => [surahsMetadata, isMojawwad];
}

class SurahDataLoadedSuccessfullyState extends QuranState {
  final bool isMojawwad;
  final List<SurahMetadata> surahsMetadata;
  final SurahData surah;
  final int surahIndex;
  const SurahDataLoadedSuccessfullyState(
      this.surahsMetadata, this.surah, this.surahIndex,
      {this.isMojawwad = false});
  @override
  List<Object> get props => [surahsMetadata, surah, surahIndex, isMojawwad];
}

class QuranFileLoadedSuccessfullyState extends QuranState {
  final bool isMojawwad;
  const QuranFileLoadedSuccessfullyState({this.isMojawwad = false});
  @override
  List<Object> get props => [isMojawwad];
}

class QuranPageViewLoadedSuccessfullyState extends QuranState {
  final bool isMojawwad;
  final SurahData surah;
  final int index;
  const QuranPageViewLoadedSuccessfullyState(this.surah, this.index,
      {this.isMojawwad = false});
  @override
  List<Object> get props => [surah, isMojawwad];
}

class QuranSinglePageLoadedSuccessfullyState extends QuranState {
  final QuranPageData page;
  final int index;
  const QuranSinglePageLoadedSuccessfullyState(this.page, this.index);
  @override
  List<Object> get props => [index, page];
}

class QuranSinglePageMojawwadLoadedSuccessfullyState extends QuranState {
  final bool isMojawwad;
  final QuranPageData page;
  final int index;
  const QuranSinglePageMojawwadLoadedSuccessfullyState(this.page, this.index,
      {this.isMojawwad = false});
  @override
  List<Object> get props => [index, page, isMojawwad];
}
