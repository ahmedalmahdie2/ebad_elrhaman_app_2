import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:quranandsunnahapp/bloc/azkar/azkar_event.dart';
import 'package:quranandsunnahapp/bloc/azkar/azkar_state.dart';

class AzkarBloc extends Bloc<AzkarEvent, AzkarState> {
  AzkarBloc() : super(AzkarInitial());

  Map<String, String> azkarAudioLinks = {};

  dynamic _getZekrAudioLinkIfSavedFromBefore(String fileName) {
    return azkarAudioLinks.containsKey(fileName)
        ? azkarAudioLinks[fileName]
        : false;
  }

  @override
  Stream<AzkarState> mapEventToState(
    AzkarEvent event,
  ) async* {
    yield AzkarInitial();
    if (event is LoadAudioForAzkarEvent) {
      yield AzkarInitial();

      if (_getZekrAudioLinkIfSavedFromBefore(event.fileName) != false) {
        print('loading zekr link from before');
        yield AzkarAudioLoadedSuccessState(
            _getZekrAudioLinkIfSavedFromBefore(event.fileName));
      } else {
        try {
          http.Response response = await http.get(event.urlForZekr);

          // print(Uri.https(url, secondPart));
          // print(response.statusCode);
          if (response.statusCode == 200) {
            String url = response.body;
            azkarAudioLinks.addAll({event.fileName: url});
            yield AzkarAudioLoadedSuccessState(url);
          }
        } catch (e) {
          print(e);
          yield AzkarConnectionFailed();
        }
      }
    }
  }
}
