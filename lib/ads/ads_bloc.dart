import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  AdsBloc() : super(AdsInitial());

  @override
  Stream<AdsState> mapEventToState(
    AdsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
