import 'package:equatable/equatable.dart';

abstract class AzkarEvent extends Equatable {
  const AzkarEvent();
  @override
  List<Object> get props => [];
}

class AzkarInitEvent extends AzkarEvent {
  const AzkarInitEvent();
  @override
  List<Object> get props => [];
}

class LoadAudioForAzkarEvent extends AzkarEvent {
  final String fileName;
  final Uri urlForZekr;
  const LoadAudioForAzkarEvent({
    this.fileName,
    this.urlForZekr,
  });
  @override
  List<Object> get props => [fileName, urlForZekr];
}
