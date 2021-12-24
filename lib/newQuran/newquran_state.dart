part of 'newquran_bloc.dart';

abstract class NewquranState extends Equatable {
  const NewquranState();

  @override
  List<Object> get props => [];
}

class NewquranInitial extends NewquranState {}

class NewquranLoaded extends NewquranState {
  final List<SurahData> allSurahs;
  const NewquranLoaded(this.allSurahs);
  @override
  List<Object> get props => [allSurahs];
}
