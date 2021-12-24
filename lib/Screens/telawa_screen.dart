import 'dart:core';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quranandsunnahapp/Classes/ad_state.dart';
import 'package:quranandsunnahapp/Classes/audio_handler.dart';
import 'package:quranandsunnahapp/Classes/telawa_data.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Telawa/telawa_bloc.dart';
import '../Classes/helper_methods.dart';
import '../Components/menu_button.dart';
import '../Misc/constants.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class TelawaScreen extends StatefulWidget {
  static const String route = 'TelawaScreen';

  @override
  _TelawaScreenState createState() => _TelawaScreenState();
}

class _TelawaScreenState extends State<TelawaScreen> {
  //List<DropdownMenuItem<Telawa>> _dropDownMenuItems;
  String urlForSurah;
  int index = 0;
  int indexForSurah = 0;
  Duration playbackLength = Duration();
  String urlForAyah;
  String _slectedQareaName;
  Duration position = Duration();
  bool playing = false;
  bool adLoaded = false;
  Icon iconPlaying = Icon(Icons.play_arrow);
  Icon iconPause = Icon(Icons.pause);
  int statusOfPlaying = 0;
  List<Telawa> copyOfAllTelawa = [];
  List<Icon> allIcons = [
    Icon(Icons.repeat, color: Colors.grey),
    Icon(Icons.repeat, color: kMainAppColor03),
    Icon(Icons.repeat_one, color: kMainAppColor03),
    Icon(Icons.shuffle, color: kMainAppColor03)
  ];

  @override
  void initState() {
    super.initState();

    HelperMethods.getURLforTelawa(1, 1).then((value) => urlForSurah = value);

    BlocProvider.of<TelawaBloc>(context)
        .add(TelawaStartGettingDataEvent(index + 1, indexForSurah + 1));
    AudioPlayerHandler.audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        playbackLength = d;
      });
    });
    AudioPlayerHandler.audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('onAudioPositionChanged');
      setState(() {
        position = p;
        if (position.inMinutes == playbackLength.inMinutes &&
            position.inSeconds == playbackLength.inSeconds) {
          if (statusOfPlaying == 3) {
            print('hello world');
            Random r = Random();

            indexForSurah = r.nextInt(113);
            AudioPlayerHandler.stopAudio();
            HelperMethods.getURLforTelawa(
                    copyOfAllTelawa[index].id, indexForSurah + 1)
                .then((value) {
              urlForSurah = value;
              AudioPlayerHandler.audioPlayer.play(urlForSurah);
            });
          } else if (statusOfPlaying == 0) {
            playing = false;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // AudioPlayerHandler.stopAudio();
    AudioPlayerHandler.audioPlayer.dispose();
    // banner.dispose();

    super.dispose();
  }

  BannerAd banner;
  // final adState=HomeScreen().
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);

    adState.initalization.then((status) {
      if (mounted) {
        setState(() {
          banner = BannerAd(
              size: AdSize.banner,
              adUnitId: adState.bannerAdUnitId,
              listener: BannerAdListener(
                onAdLoaded: (Ad ad) {
                  print("ad Loaded");
                  setState(() {
                    adLoaded = true;
                  });
                },
                onAdFailedToLoad: (Ad ad, LoadAdError error) {
                  ad.dispose();
                },
                onAdOpened: (Ad ad) {
                  print("Ad opened");
                },
                onAdClosed: (Ad ad) {
                  print("Ad closed");
                },
              ),
              request: AdRequest())
            ..load();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      // bottomNavigationBar:
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
          'telawa',
          style: kAppBarTitleStyle,
        ).tr(),
        centerTitle: true,
        actions: [ChangeLanguageButton(), MenuButton()],
      ),
      body: BlocBuilder<TelawaBloc, TelawaState>(
        builder: (context, state) {
          if (state is TelawaDataLoadedSuccessfully) {
            copyOfAllTelawa = state.allTelawa;
            return Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(33),
                    border: Border.all(color: kMainAppColor01, width: 2)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'chooseQarea',
                              style: TextStyle(
                                  color: kMainAppColor01,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                          ),

                          // const Spacer(),
                          Expanded(
                            flex: 2,
                            child: DropdownButton(
                              // isExpanded: false,
                              style: TextStyle(
                                color: kMainAppColor01,
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: kMainAppColor01,
                              ),
                              selectedItemBuilder: (BuildContext context) {
                                return state.allTelawa.map((value) {
                                  String finalName = state
                                      .allTelawa[value.indexTelawa].qareaName;
                                  if (state.allTelawa[value.indexTelawa]
                                          .rewaya ==
                                      "") {
                                    if (state.allTelawa[value.indexTelawa]
                                            .musshaf_type !=
                                        "") {
                                      finalName = finalName +
                                          " - " +
                                          state.allTelawa[value.indexTelawa]
                                              .musshaf_type;
                                    }
                                  } else {
                                    finalName = finalName +
                                        " - " +
                                        state.allTelawa[value.indexTelawa]
                                            .rewaya;
                                    if (state.allTelawa[value.indexTelawa]
                                            .musshaf_type !=
                                        "") {
                                      finalName = finalName +
                                          " - " +
                                          state.allTelawa[value.indexTelawa]
                                              .musshaf_type;
                                    }
                                  }
                                  return Container(
                                    width: 150,
                                    child: Center(
                                      child: Text(
                                        finalName,
                                        style: const TextStyle(
                                            color: kMainAppColor01,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              dropdownColor: kMainAppColor01,
                              // hint: Text(
                              //   "برجاء اختيار القارئ",
                              //   style: TextStyle(color: Colors.black),
                              // ),
                              value: index,
                              onChanged: (value) async {
                                setState(() {
                                  index = value;
                                });

                                print('qarie onChanged');

                                HelperMethods.getURLforTelawa(
                                        state.allTelawa[index].id,
                                        indexForSurah + 1)
                                    .then((link) => setState(() {
                                          urlForSurah = link;
                                        }));
                              },
                              items: state.allTelawa.map((valueItem) {
                                // print(valueItem.id);
                                String finalName = state
                                    .allTelawa[valueItem.indexTelawa].qareaName;
                                if (state.allTelawa[valueItem.indexTelawa]
                                        .rewaya ==
                                    "") {
                                  if (state.allTelawa[valueItem.indexTelawa]
                                          .musshaf_type !=
                                      "") {
                                    finalName = finalName +
                                        " - " +
                                        state.allTelawa[valueItem.indexTelawa]
                                            .musshaf_type;
                                  }
                                } else {
                                  finalName = finalName +
                                      " - " +
                                      state.allTelawa[valueItem.indexTelawa]
                                          .rewaya;
                                  if (state.allTelawa[valueItem.indexTelawa]
                                          .musshaf_type !=
                                      "") {
                                    finalName = finalName +
                                        " - " +
                                        state.allTelawa[valueItem.indexTelawa]
                                            .musshaf_type;
                                  }
                                }

                                return DropdownMenuItem(
                                    child: Container(
                                      width: 220,
                                      child: Center(
                                        child: Text(
                                          finalName,
                                          style: TextStyle(
                                              color: kMainAppColor03,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    value: valueItem.indexTelawa);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'chooseSurah',
                              style: TextStyle(
                                  color: kMainAppColor01,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                          ),
                          Expanded(
                            flex: 2,
                            child: DropdownButton(
                              iconEnabledColor: kMainAppColor03,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: kMainAppColor01,
                              ),
                              dropdownColor: kMainAppColor01,
                              selectedItemBuilder: (BuildContext context) {
                                return state.allSurahsMetadata.map((value) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Center(
                                      child: context.locale.countryCode == "AR"
                                          ? Text(
                                              value.arabicName,
                                              style: const TextStyle(
                                                  color: kMainAppColor01,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              value.englishName,
                                              style: const TextStyle(
                                                  color: kMainAppColor01,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  );
                                }).toList();
                              },
                              // hint: Text(
                              //   "برجاء اختيار السوره",
                              //   style: TextStyle(color: Colors.black),
                              // ),
                              value: indexForSurah,
                              onChanged: (value) async {
                                // print("surah num $value and qarea num is $index");
                                setState(() {
                                  print(
                                      "surah num $value and qarea num is ${state.allTelawa[index].id}");
                                  indexForSurah = value;
                                  AudioPlayerHandler.stopAudio();
                                  // AudioPlayerHandler.stopAudio();
                                  playing = false;
                                  urlForSurah = '';

                                  // BlocProvider.of<TelawaBloc>(context, listen: false)
                                  //     .add(TelawaStartGettingDataEvent(index+1, indexForSurah+1));
                                });

                                HelperMethods.getURLforTelawa(
                                        state.allTelawa[index].id, value + 1)
                                    .then((link) => setState(() {
                                          urlForSurah = link;
                                        }));
                              },
                              items: state.allSurahsMetadata.map((valueItem) {
                                // print(valueItem.id);
                                return DropdownMenuItem(
                                    child: Container(
                                      width: 250,
                                      child: context.locale.countryCode == "AR"
                                          ? Text(
                                              state
                                                  .allSurahsMetadata[
                                                      valueItem.index]
                                                  .arabicName,
                                              style: TextStyle(
                                                  color: kMainAppColor03,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              state
                                                  .allSurahsMetadata[
                                                      valueItem.index]
                                                  .englishName,
                                              style: TextStyle(
                                                  color: kMainAppColor03,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                    value: valueItem.index);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(child: sliderX()),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                            style: TextStyle(
                                color: kMainAppColor01,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 100.0,
                          ),
                          Text(
                            "${playbackLength.inMinutes}:${playbackLength.inSeconds.remainder(60)}",
                            style: TextStyle(
                                color: kMainAppColor01,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: kMainAppColor01,
                            borderRadius: BorderRadius.circular(45.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 45.0,
                              color: kMainAppColor03,
                              onPressed: () async {
                                setState(() {
                                  indexForSurah--;
                                  if (indexForSurah == 0) indexForSurah++;
                                  position = Duration(seconds: 0);
                                  AudioPlayerHandler.stopAudio();
                                });
                                HelperMethods.getURLforTelawa(
                                        state.allTelawa[index].id,
                                        indexForSurah + 1)
                                    .then((link) => setState(() {
                                          urlForSurah = link;
                                        }));
                              },
                              icon: Icon(
                                Icons.skip_previous,
                              ),
                            ),
                            IconButton(
                              color: kMainAppColor03,
                              icon: playing == false ? iconPlaying : iconPause,
                              iconSize: 45.0,
                              onPressed: () {
                                setState(() {
                                  if (!playing &&
                                      urlForSurah != null &&
                                      urlForSurah.isNotEmpty) {
                                    playing = true;
                                    AudioPlayerHandler.audioPlayer
                                        .play(urlForSurah);
                                  } else {
                                    playing = false;
                                    AudioPlayerHandler.audioPlayer.pause();
                                  }
                                });
                              },
                            ),
                            IconButton(
                              iconSize: 45.0,
                              color: kMainAppColor03,
                              onPressed: () async {
                                setState(() {
                                  indexForSurah++;
                                  indexForSurah %= 114;
                                  position = Duration(seconds: 0);
                                  AudioPlayerHandler.stopAudio();
                                  playing = false;
                                });
                                HelperMethods.getURLforTelawa(
                                        state.allTelawa[index].id,
                                        indexForSurah + 1)
                                    .then((link) => setState(() {
                                          urlForSurah = link;
                                        }));
                              },
                              icon: Icon(
                                Icons.skip_next,
                              ),
                            ),
                            IconButton(
                              iconSize: 45.0,
                              color: kMainAppColor03,
                              onPressed: () async {
                                setState(() {
                                  position = Duration(seconds: 0);
                                  playing = false;
                                  AudioPlayerHandler.stopAudio();
                                });
                                HelperMethods.getURLforTelawa(
                                        state.allTelawa[index].id,
                                        indexForSurah + 1)
                                    .then((link) => setState(() {
                                          urlForSurah = link;
                                        }));
                              },
                              icon: Icon(
                                Icons.crop_square,
                                color: kMainAppColor03,
                              ),
                            ),
                            IconButton(
                                iconSize: 45.0,
                                onPressed: () async {
                                  setState(() {
                                    statusOfPlaying = (statusOfPlaying + 1) % 4;
                                    print(statusOfPlaying.toString() + " now ");
                                  });
                                  if (statusOfPlaying == 1) {
                                    await AudioPlayerHandler.audioPlayer
                                        .setReleaseMode(ReleaseMode.LOOP);
                                  } else if (statusOfPlaying == 0) {
                                    await AudioPlayerHandler.audioPlayer
                                        .setReleaseMode(ReleaseMode.STOP);
                                    setState(() {
                                      playing = false;
                                      position = Duration(seconds: 0);
                                    });
                                  } else if (statusOfPlaying == 2) {}
                                },
                                icon: allIcons[statusOfPlaying]),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: kHeightForBanner,
                      child: banner == null || !adLoaded
                          ? SizedBox(height: 20)
                          : AdWidget(ad: banner),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is TelawaConnectionFailed) {
            return connectionFailed();
          } else {
            return HelperMethods.loadingWidget;
          }
        },
      ),
    );
  }

  Widget sliderX() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: 300.0,
        child: Slider(
            activeColor: kMainAppColor01,
            inactiveColor: Colors.grey[350],
            value: position.inSeconds.toDouble(),
            max: playbackLength.inSeconds.toDouble(),
            onChanged: (value) {
              seekToSec(value.toInt());
            }),
      ),
    );
  }

  Widget connectionFailed() {
    return Center(
      child: Text(
        'حدث خطأ يرجى التأكد من إتصالك بالانترنت',
        style: TextStyle(color: kMainAppColor01, fontSize: 15.0),
      ),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    AudioPlayerHandler.audioPlayer.seek(newPos);
  }
}
