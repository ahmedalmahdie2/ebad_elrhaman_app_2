import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class QuranTextSearchBloc
    extends Bloc<QuranTextSearchEvent, QuranTextSearchState> {
  QuranTextSearchBloc(QuranTextSearchState initialState) : super(initialState);

  @override
  Stream<QuranTextSearchState> mapEventToState(event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}

abstract class QuranTextSearchEvent extends Equatable {
  const QuranTextSearchEvent();
  @override
  List<Object> get props => [];
}

class QuranTextSearchInitializationEvent extends QuranTextSearchEvent {}

class QuranTextSearchSendSearchRequestEvent extends QuranTextSearchEvent {
  final String textToSearchFo;

  QuranTextSearchSendSearchRequestEvent(this.textToSearchFo);
}

abstract class QuranTextSearchState extends Equatable {
  const QuranTextSearchState();
  @override
  List<Object> get props => [];
}
