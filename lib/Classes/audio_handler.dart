import 'package:audioplayers/audioplayers.dart';

class AudioPlayerHandler {
  static AudioPlayer audioPlayer = AudioPlayer();

  static void resumeAudio() async {
    await audioPlayer.resume();
  }

  static void setAudioUrl(
    String link,
  ) async {
    await audioPlayer.setUrl(link);
  }

  static void playAudio({
    String link,
    Function(Duration) onDurationChanged,
    Function(void) onPlayerCompletion,
    Function(Duration) onAudioPositionChanged,
    Function(AudioPlayerState) onPlayerStateChanged,
  }) async {
    await audioPlayer.release();
    await audioPlayer.stop();
    audioPlayer = null;
    audioPlayer = new AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((event) {
      print('AudioPlayerState: $event');
      if (onPlayerStateChanged != null) onPlayerStateChanged(event);
    });
    audioPlayer.onDurationChanged.listen((Duration d) {
      if (onDurationChanged != null) onDurationChanged(d);
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      if (onPlayerCompletion != null) onPlayerCompletion(event);
    });

    audioPlayer.onAudioPositionChanged.listen((Duration d) {
      if (onAudioPositionChanged != null) onAudioPositionChanged(d);
    });

    audioPlayer.play(
      link,
      // isLocal: false,
    );
  }

  static void pauseAudio() async {
    await audioPlayer.pause();
  }

  static void stopAudio() async {
    await audioPlayer.stop();
  }
}
