import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranandsunnahapp/Classes/audio_handler.dart';
import 'package:quranandsunnahapp/Classes/azkar_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/loading_indicator.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/bloc/azkar/azkar_bloc.dart';
import 'package:quranandsunnahapp/bloc/azkar/azkar_event.dart';
import 'package:quranandsunnahapp/bloc/azkar/azkar_state.dart';
import 'package:share/share.dart';
import 'dart:math' as math; // import this

import 'dart:ui' as ui;

final PageController controller = PageController(initialPage: 0);

class AzkarScreen extends StatefulWidget {
  static const String route = 'AzkarScreen';
  final AzkarSubgroupData azkarSubgroup;

  const AzkarScreen({this.azkarSubgroup});

  @override
  _AzkarScreenState createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  String urlForZekr = '';
  Duration playbackLength = Duration();
  Duration position = Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool hasFinished = false;
  Icon iconPlaying = Icon(Icons.play_arrow);
  Icon iconPause = Icon(Icons.pause);
  int statusOfPlaying = 0;
  int currentZekrIndex = 0;
  int zekrCounter = 1;
  Duration audioDuration = Duration.zero;
  final ScrollController scrollController = ScrollController();
  AzkarBloc azkarBloc;
  @override
  void initState() {
    super.initState();
    azkarBloc = BlocProvider.of<AzkarBloc>(context);
    initialize();
  }

  void initialize() async {
    // setState(() {
    //   urlForZekr = HelperMethods.getURLforZekr(
    //           widget.azkarSubgroup.azkar[currentZekrIndex])
    //       .toString();
    // });

    azkarBloc.add(LoadAudioForAzkarEvent(
        fileName: widget.azkarSubgroup.azkar[currentZekrIndex].audioFileName,
        urlForZekr: HelperMethods.getURLforZekr(
            widget.azkarSubgroup.azkar[currentZekrIndex])));
    print(
        'loading zekr audio file:  ${HelperMethods.getURLforZekr(widget.azkarSubgroup.azkar[currentZekrIndex])}');
  }

  void playAudio() {
    playZekrAudio(urlForZekr);
  }

  void playZekrAudio(String zekrAudioLink) async {
    // await _player.stop();
    // await _player.play(
    //   zekrAudioLink,
    //   isLocal: false,
    // );

    // if (_player.seek(Duration)) await _player.stop();
    // await AudioPlayerHandler.audioPlayer.release();
    AudioPlayerHandler.playAudio(
        link: zekrAudioLink,
        // onAudioPositionChanged: (Duration d) {
        //   if (position.inMinutes < playbackLength.inMinutes &&
        //       position.inSeconds < playbackLength.inSeconds)
        //     setState(() {
        //       isPlaying = true;
        //       position = d;
        //     });
        // },
        onPlayerStateChanged: (playerState) {
          setState(() {
            isPlaying = playerState == AudioPlayerState.PLAYING;
            isPaused = playerState == AudioPlayerState.PAUSED;
            hasFinished = playerState == AudioPlayerState.COMPLETED ||
                playerState == AudioPlayerState.STOPPED;
            // position = d;
          });
        },
        onDurationChanged: (Duration d) {
          setState(() {
            playbackLength = d;
            audioDuration = d;
            print('onDurationChanged zekr duration: $audioDuration');
          });
        },
        onPlayerCompletion: (event) {
          if (position.inMinutes == playbackLength.inMinutes &&
              position.inSeconds == playbackLength.inSeconds) {
            print('onPlayerCompletion finished playing');
            isPlaying = false;
            AudioPlayerHandler.stopAudio();
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> updateAzkarListWidget() {
    List<Widget> tempAzkarsWidgets = [];
    widget.azkarSubgroup.azkar.forEach(
      (zekr) {
        // print(zekr.zekr);
        tempAzkarsWidgets.add(AzkarWidget(zekr: zekr));
      },
    );
    return tempAzkarsWidgets;
  }

  void nextPage() {
    if (mounted && currentZekrIndex + 1 < widget.azkarSubgroup.azkar.length) {
      AudioPlayerHandler.stopAudio();
      setState(() {
        zekrCounter = 1;
        currentZekrIndex++;
        audioDuration = Duration.zero;
        position = Duration.zero;
        isPlaying = false;
        isPaused = false;
        hasFinished = false;
        urlForZekr = '';
      });
      controller.animateToPage(currentZekrIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);

      azkarBloc.add(LoadAudioForAzkarEvent(
          fileName: widget.azkarSubgroup.azkar[currentZekrIndex].audioFileName,
          urlForZekr: HelperMethods.getURLforZekr(
              widget.azkarSubgroup.azkar[currentZekrIndex])));
      print(
          'zekr audio link: ${HelperMethods.getURLforZekr(widget.azkarSubgroup.azkar[currentZekrIndex]).toString()}');
    }
  }

  void previousPage() {
    if (mounted && currentZekrIndex - 1 >= 0) {
      AudioPlayerHandler.stopAudio();
      setState(() {
        zekrCounter = 1;
        currentZekrIndex--;
        audioDuration = Duration.zero;
        position = Duration.zero;
        isPlaying = false;
        isPaused = false;
        hasFinished = false;
        urlForZekr = '';
      });
      controller.animateToPage(currentZekrIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      azkarBloc.add(LoadAudioForAzkarEvent(
          fileName: widget.azkarSubgroup.azkar[currentZekrIndex].audioFileName,
          urlForZekr: HelperMethods.getURLforZekr(
              widget.azkarSubgroup.azkar[currentZekrIndex])));
    }
  }

  void onCount() {
    if (mounted) {
      if (zekrCounter + 1 <=
          widget.azkarSubgroup.azkar[currentZekrIndex].count) {
        setState(() {
          zekrCounter++;
        });
      } else
        nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AzkarBloc, AzkarState>(
      listener: (context, state) {
        if (state is AzkarAudioLoadedSuccessState) {
          print('in AzkarAudioLoadedSuccessState with url: ${state.url}');
          setState(() {
            urlForZekr = state.url;
          });
        } else if (state is AzkarConnectionFailed) {
          print('zekr link is not working');
          setState(() {
            urlForZekr = '';
          });
        }
      },
      child: Scaffold(
        bottomNavigationBar: TimesCounterButton(
          hasTimer: true,
          duration: audioDuration,
          currentCount: zekrCounter,
          zekr: widget.azkarSubgroup.azkar[currentZekrIndex],
          onNext: nextPage,
          onPrevious: previousPage,
          onShare: () {
            String aboutUS =
                "\n للمزيد من الاذكار والادعيه قم بتحميل التطبيق من خلال جوجل بلاي https://play.google.com/store/apps/details?id=com.fastworld.quranandsunnahapp";
            Share.share(widget.azkarSubgroup.azkar[currentZekrIndex]
                    .zekr[HelperMethods.isArabic(context) ? 0 : 1] +
                aboutUS);
          },
          isPlaying: isPlaying,
          isPaused: isPaused,
          hasFinished: hasFinished,
          onCount: onCount,
          onPause: AudioPlayerHandler.pauseAudio,
          onPlay: playAudio,
          onResume: AudioPlayerHandler.resumeAudio,
        ),
        backgroundColor: kMainAppColor02,
        appBar: AppBar(
          backgroundColor: kMainAppColor01,
          leading: BackButton(
            color: kMainAppColor03,
            onPressed: () {
              AudioPlayerHandler.stopAudio();
              AudioPlayerHandler.audioPlayer.release();
              // await AudioPlayerHandler.audioPlayer.dispose();
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.azkarSubgroup
                .azkarSubgroupNames[HelperMethods.isArabic(context) ? 0 : 1],
            style: kAppBarTitleStyle,
          ),
          centerTitle: true,
          actions: [ChangeLanguageButton(), MenuButton()],
          // actions: [LangButton(), MenuButton()],
        ),
        body: Stack(
          children: [
            GestureDetector(
              onHorizontalDragEnd: (dragEndDetails) {
                if (dragEndDetails.primaryVelocity > 0) {
                  if (HelperMethods.isArabic(context))
                    onCount();
                  else
                    previousPage();
                } else if (dragEndDetails.primaryVelocity < 0) {
                  if (HelperMethods.isArabic(context))
                    previousPage();
                  else
                    onCount();
                }
                return Future<bool>.delayed(
                    Duration(milliseconds: 1), () => false);
              },
              child: PageView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                children: List<Widget>.generate(
                    widget.azkarSubgroup.azkar.length, (index) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: AzkarWidget(
                      zekr: widget.azkarSubgroup.azkar[index],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        drawer: SideMenu(),
        endDrawer: SideMenu(),
      ),
    );
  }
}

class AzkarWidget extends StatelessWidget {
  final AzkarData zekr;

  const AzkarWidget({
    this.zekr,
  });

  List<TextSpan> allText(bool isArabic) {
    String afterParsing =
        HelperMethods.parseHtmlString(zekr.zekr[isArabic ? 0 : 1]);
    List<String> mystr = afterParsing.split(" ");
    List<TextSpan> allTextWidget = [];
    for (int i = 0; i < mystr.length; i++) {
      if (mystr[i] == "اللَّهُمَّ") {
        allTextWidget.add(TextSpan(
          text: '\n' + mystr[i],
          style: kTextStyleRedNormal.copyWith(fontSize: 20),
          // textAlign: TextAlign.justify,
          // textDirection: TextDirection.rtl,
        ));
        allTextWidget.add(TextSpan(text: " "));
      } else {
        // print(mystr[i]);
        allTextWidget.add(TextSpan(
          text: mystr[i],
          style: kTextStyleBlackNormal.copyWith(fontSize: 18),
          //textAlign: TextAlign.justify,
          //textDirection: TextDirection.rtl,
        ));
        allTextWidget.add(TextSpan(text: " "));
      }
    }
    return allTextWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (zekr.intro != null && zekr.intro.isNotEmpty)
                Text(
                  HelperMethods.parseHtmlString(zekr.intro[0]),
                  style: kTextStyleBlackNormal.copyWith(
                      fontSize: 22, color: kMainAppColor01),
                  textAlign: TextAlign.justify,
                  textDirection: HelperMethods.isArabic(context)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              RichText(
                text: TextSpan(
                    children: allText(HelperMethods.isArabic(context)),
                    style: TextStyle(fontSize: 12)),
                textAlign: TextAlign.justify,
                textDirection: HelperMethods.isArabic(context)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
              ),
              Divider(
                thickness: 1.0,
                height: 15,
                color: Colors.grey,
              ),
              //Text(zekr.zekr),
              if (zekr.reference != null && zekr.reference.isNotEmpty)
                Text(
                  HelperMethods.parseHtmlString(zekr.reference),
                  style: kTextStyleBlackNormal.copyWith(
                      fontSize: 17, color: kMainAppColor01),
                  textAlign: TextAlign.right,
                  textDirection: HelperMethods.isArabic(context)
                      ? TextDirection.rtl
                      : TextDirection.rtl,
                ),
              if (zekr.description != null && zekr.description.isNotEmpty)
                Text(
                  HelperMethods.parseHtmlString(zekr.description[0]),
                  style: kTextStyleBlackNormal.copyWith(
                      fontSize: 17, color: kMainAppColor01),
                  textAlign: TextAlign.right,
                  textDirection: HelperMethods.isArabic(context)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class TimesCounterButton extends StatefulWidget {
  const TimesCounterButton({
    @required this.times,
    @required this.currentCount,
    @required this.zekr,
    this.onPlay,
    this.onPause,
    this.onResume,
    this.duration,
    this.index,
    this.text,
    this.onNext,
    this.onPrevious,
    this.onCount,
    this.onShare,
    this.isPlaying,
    this.isPaused,
    this.hasFinished,
    this.hasTimer = false,
  });

  final Function onPlay;
  final Function onPause;
  final Function onResume;
  final Function onNext;
  final Function onPrevious;
  final Function onCount;
  final Function onShare;
  final Duration duration;
  final AzkarData zekr;
  final int times;
  final int currentCount;
  final int index;
  final String text;
  final bool isPlaying;
  final bool isPaused;
  final bool hasFinished;
  final bool hasTimer;

  @override
  _TimesCounterButtonState createState() => _TimesCounterButtonState();
}

class _TimesCounterButtonState extends State<TimesCounterButton> {
  int countsRemaining;
  int counterMin = 0;
  int counterSec = 0;
  Timer timer;
  // bool isPlaying = false;
  bool hasStartedPlaying = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    resetCounter();
  }

  void startTimer() {
    if (widget.hasTimer && widget.duration != null)
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted && widget.isPlaying) {
          setState(() {
            if (counterSec == 59) {
              counterMin++;
              counterSec = 0;
            } else
              counterSec++;
          });
        }
      });
  }

  void resetTimer() {
    print('resetTimer');
    if (timer != null) timer.cancel();
    if (mounted)
      setState(() {
        counterMin = 0;
        counterSec = 0;
      });
  }

  int decrement() {
    return countsRemaining - 1 >= 0 ? countsRemaining-- : 0;
  }

  void resetCounter() {
    countsRemaining = widget.zekr.count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kMainAppColor01,
      height: 75,
      child: Row(
        textDirection: ui.TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 7.0,
            ),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(right: 4),
                    child: Text(
                      widget.zekr.count.toString() +
                          " - " +
                          widget.currentCount.toString(),
                      style: TextStyle(fontSize: 14),
                    )),
                Transform(
                  transform: Matrix4.rotationY(math.pi),
                  alignment: Alignment.center,
                  child: IconButton(
                    iconSize: 35,
                    icon: Icon(
                      Icons.skip_next_outlined,
                      color: kMainAppColor02,
                    ),
                    splashColor: Colors.grey,
                    onPressed: widget.onCount,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                iconSize: 45,
                icon: Icon(
                  Icons.fast_forward_rounded,
                  color: kMainAppColor02,
                ),
                splashColor: Colors.grey,
                onPressed: widget.onPrevious,
              ),
              if (isLoading) LoadingIndicator(),
              if (!isLoading)
                IconButton(
                  iconSize: 45,
                  icon: Icon(
                    widget.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: kMainAppColor02,
                  ),
                  splashColor: Colors.grey,
                  onPressed: () {
                    if (!widget.isPlaying) {
                      if (!widget.isPaused) resetTimer();
                      startTimer();
                      if (!hasStartedPlaying || widget.hasFinished) {
                        if (widget.onPlay != null) {
                          widget.onPlay();
                        }
                      } else if (widget.onResume != null) {
                        widget.onResume();
                      }
                    } else {
                      if (widget.onPause != null) {
                        widget.onPause();
                      }
                    }
                    setState(() {
                      if (!hasStartedPlaying) {
                        hasStartedPlaying = true;
                      }
                    });
                  },
                ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: IconButton(
                  iconSize: 45,
                  icon: Icon(
                    Icons.fast_forward_rounded,
                    color: kMainAppColor02,
                  ),
                  splashColor: Colors.grey,
                  onPressed: widget.onCount,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Column(
              children: [
                SizedBox(
                  width: 52,
                  child: Row(
                    children: [
                      if (!widget.hasTimer || !hasStartedPlaying)
                        SizedBox(height: 15),
                      if (widget.hasTimer && hasStartedPlaying)
                        Text(
                          counterSec.toString().padLeft(2, "0"),
                          style: TextStyle(),
                        ),
                      if (widget.hasTimer && hasStartedPlaying) Text(" : "),
                      if (widget.hasTimer && hasStartedPlaying)
                        Text(
                          counterMin.toString().padLeft(2, "0"),
                          style: TextStyle(),
                        ),
                    ],
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.share,
                      color: kMainAppColor02,
                    ),
                    onPressed: widget.onShare),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
