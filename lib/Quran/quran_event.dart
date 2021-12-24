part of 'quran_bloc.dart';

abstract class QuranEvent extends Equatable {
  final bool isMojawwad;

  const QuranEvent({this.isMojawwad = false});
  @override
  List<Object> get props => [isMojawwad];
}

class QuranInitEvent extends QuranEvent {
  final bool isMojawwad;
  QuranInitEvent({this.isMojawwad = false});
  @override
  List<Object> get props => [isMojawwad];
}

class QuranStartGettingDataEvent extends QuranEvent {
  final bool isMojawwad;
  final int indexForSurah;
  const QuranStartGettingDataEvent(this.indexForSurah,
      {this.isMojawwad = false});
  @override
  List<Object> get props => [isMojawwad];
}

class LoadSurahForQuran extends QuranEvent {
  final bool isMojawwad;
  final int indexForSurah;
  const LoadSurahForQuran(this.indexForSurah, {this.isMojawwad = false});
  @override
  List<Object> get props => [indexForSurah, isMojawwad];
}

class GettingNextPreviousSurahEvent extends QuranEvent {
  final bool isMojawwad;
  final int index;
  const GettingNextPreviousSurahEvent(this.index, {this.isMojawwad = false});
  @override
  List<Object> get props => [this.index, isMojawwad];
}

class ChangeQuranPageEvent extends QuranEvent {
  final bool isMojawwad;
  final int pageIndex;
  const ChangeQuranPageEvent(this.pageIndex, {this.isMojawwad = false});
  @override
  List<Object> get props => [this.pageIndex, isMojawwad];
}

//۞
