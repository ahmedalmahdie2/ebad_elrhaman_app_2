import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quranandsunnahapp/Classes/audio_handler.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Classes/surah_metadata.dart';
import 'package:quranandsunnahapp/Classes/telawa_data.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
part 'telawa_event.dart';
part 'telawa_state.dart';

class TelawaBloc extends Bloc<TelawaEvent, TelawaState> {
  TelawaBloc() : super(TelawaInitial());

  @override
  Stream<TelawaState> mapEventToState(
    TelawaEvent event,
  ) async* {
    yield TelawaInitial();
    if (event is TelawaStartGettingDataEvent) {
      yield TelawaInitial();
      try {
        List<SurahMetadata> allSurahs = [];

        List<Telawa> mylist = await HelperMethods.getAllTelawa();
        var parsed = await HelperMethods.loadQuranMetadata();
        List<dynamic> lastParsed = parsed["data"]["surahs"]["references"];

        int index = 0;
        lastParsed.forEach((surah) {
          allSurahs.add(SurahMetadata.fromJson(json: surah, index: index++));
        });
        String url = 'www.fastworldsolutions.com';
        String secondPart = "/islamic/public/api/quran/audio.sura/" +
            event.indexForQarea.toString() +
            "/" +
            event.indexForSurah.toString();
        http.Response response = await http.get(Uri.https(url, secondPart));
        print('WTF');
        print(Uri.https(url, secondPart));
        print(response.statusCode);
        if (response.statusCode == 200) {
          print("downlaoded telawa audio link");
          // String url = response.body;
          AudioPlayerHandler.setAudioUrl(url);
          // int duration = await player.getDuration();
          // print('duration: $duration');
          yield TelawaDataLoadedSuccessfully(mylist, allSurahs, url);
        }
      } catch (e) {
        print(e);
        yield TelawaConnectionFailed();
      }
    }
  }
}
