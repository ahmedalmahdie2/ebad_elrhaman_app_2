import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Classes/local_quran_loader.dart';
import 'package:quranandsunnahapp/Classes/quran_data.dart';
import 'package:quranandsunnahapp/Classes/surah_metadata.dart';
import 'package:quranandsunnahapp/Components/surah_widget.dart';
part 'quran_event.dart';
part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  QuranBloc() : super(QuranInitialState());
  List<SurahMetadata> surahsMetadata = [];
  List<int> quranPagesIndices = [];

  SurahData selectedSurah;
  QuranPageData selectedPage;
  int selectedPageIndex;

  int selectedSurahIndex;
  bool hasBeenInitialized = false;

  @override
  Stream<QuranState> mapEventToState(QuranEvent event) async* {
    yield QuranInitialState();
    if (event is QuranInitEvent) {
      if (quranPagesIndices.length < 1)
        for (int i = 0; i < 604; i++) {
          quranPagesIndices.add(i);
        }

      yield QuranInitialState();
      if (!hasBeenInitialized) {
        await LocalQuranJsonFileLoader.initializeQuran();
        yield QuranFileLoadedSuccessfullyState();
        // surahsMetadata = LocalQuranJsonFileLoader.quranSurahsMetadata;

        surahsMetadata = await compute(
          LocalQuranJsonFileLoader.parseSurahsMetaData,
          LocalQuranJsonFileLoader.quranMetaDataFileContent['data']['surahs']
              ['references'],
        ).then((value) {
          LocalQuranJsonFileLoader.quranSurahsMetadata = value;
          LocalQuranJsonFileLoader.populateSurahsMetadataWithPagesNumbers();
          return LocalQuranJsonFileLoader.quranSurahsMetadata;
        });

        print("loaded surahs metadata");
      }
      hasBeenInitialized = true;
      // print("yield SurahsMetaDataLoadedSuccessfullyState");
      yield SurahsMetaDataLoadedSuccessfullyState(surahsMetadata);
    } else if (event is QuranStartGettingDataEvent) {
      selectedSurah = await compute(
        LocalQuranJsonFileLoader.parseSurah,
        LocalQuranJsonFileLoader.quranFileContent['data']['surahs']
            [event.indexForSurah],
      );
      selectedSurahIndex = event.indexForSurah;
      yield SurahDataLoadedSuccessfullyState(
          surahsMetadata, selectedSurah, selectedSurahIndex);
    } else if (event is GettingNextPreviousSurahEvent) {
      selectedSurah = await compute(
        LocalQuranJsonFileLoader.parseSurah,
        LocalQuranJsonFileLoader.quranFileContent['data']['surahs']
            [event.index],
      );

      yield QuranPageViewLoadedSuccessfullyState(selectedSurah, event.index);
    } else if (event is ChangeQuranPageEvent) {
      selectedPage = LocalQuranJsonFileLoader.parseQuranPage(
        event.pageIndex,
        isMojawwad: true || event.isMojawwad,
      );

      yield QuranSinglePageLoadedSuccessfullyState(
          selectedPage, selectedPage.pageNumber);
    }
  }
}
