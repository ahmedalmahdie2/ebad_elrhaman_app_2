import 'package:equatable/equatable.dart';

abstract class AzkarState extends Equatable {
  const AzkarState();
  @override
  List<Object> get props => [];
}

class AzkarInitial extends AzkarState {
  const AzkarInitial();
  @override
  List<Object> get props => [];
}

class AzkarAudioLoadedSuccessState extends AzkarState {
  // final int maxTime;
  final String url;
  const AzkarAudioLoadedSuccessState(this.url);
  @override
  List<Object> get props => [url];
}

class AzkarConnectionFailed extends AzkarState {
  const AzkarConnectionFailed();
  @override
  List<Object> get props => [];
}
