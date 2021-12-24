part of 'telawa_bloc.dart';

abstract class TelawaState extends Equatable {
  const TelawaState();
  @override
  List<Object> get props => [];
}

class TelawaInitial extends TelawaState {
  const TelawaInitial();
  @override
  List<Object> get props => [];
}

class TelawaDataLoadedSuccessfully extends TelawaState {
  final List<Telawa> allTelawa;
  final List<SurahMetadata> allSurahsMetadata;
  // final int maxTime;
  final String url;
  const TelawaDataLoadedSuccessfully(
      this.allTelawa, this.allSurahsMetadata, this.url);
  @override
  List<Object> get props => [allTelawa, allSurahsMetadata, url];
}

class TelawaAudioLoadedSuccess extends TelawaState {
  final int maxTime;
  final String url;
  const TelawaAudioLoadedSuccess(this.maxTime, this.url);
  @override
  List<Object> get props => [maxTime];
}

class TelawaConnectionFailed extends TelawaState {
  const TelawaConnectionFailed();
  @override
  List<Object> get props => [];
}
