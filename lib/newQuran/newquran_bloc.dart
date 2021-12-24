import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quranandsunnahapp/Classes/local_quran_loader.dart';
import 'package:quranandsunnahapp/Classes/quran_data.dart';

part 'newquran_event.dart';
part 'newquran_state.dart';

class NewquranBloc extends Bloc<NewquranEvent, NewquranState> {
  NewquranBloc() : super(NewquranInitial());

  @override
  Stream<NewquranState> mapEventToState(
    NewquranEvent event,
  ) async* {
    if (event is GettingAllSurahsofQuran) {
      List<SurahData> allSurahs = [];
      for (int i = 0; i < 114; i++) {
        SurahData surah = await compute(
          LocalQuranJsonFileLoader.parseSurah,
          LocalQuranJsonFileLoader.quranFileContent['data']['surahs'][i],
        );
        allSurahs.add(surah);
      }
    }
  }
}
