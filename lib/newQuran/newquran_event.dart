part of 'newquran_bloc.dart';

abstract class NewquranEvent extends Equatable {
  const NewquranEvent();

  @override
  List<Object> get props => [];
}

class GettingAllSurahsofQuran extends NewquranEvent {
  const GettingAllSurahsofQuran();
  @override
  List<Object> get props => [];
}
