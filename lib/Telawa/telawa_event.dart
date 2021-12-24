part of 'telawa_bloc.dart';

abstract class TelawaEvent extends Equatable {
  const TelawaEvent();
  @override
  List<Object> get props => [];
}

class TelawaInitEvent extends TelawaEvent {
  const TelawaInitEvent();
  @override
  List<Object> get props => [];
}

class TelawaStartGettingDataEvent extends TelawaEvent {
  final int indexForQarea;
  final int indexForSurah;
  const TelawaStartGettingDataEvent(this.indexForQarea, this.indexForSurah);
  @override
  List<Object> get props => [];
}

class LoadSurahForTelawa extends TelawaEvent {
  final int indexForQarea;
  final int indexForSurah;
  const LoadSurahForTelawa(this.indexForQarea, this.indexForSurah);
  @override
  List<Object> get props => [indexForQarea, indexForSurah];
}
