import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/clipped_card.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'dart:math' as math; // import this

import 'dart:ui' as ui;

class TimesCounterButton extends StatefulWidget {
  const TimesCounterButton({@required this.times, this.index, this.text});

  final int times;
  final int index;
  final String text;

  @override
  _TimesCounterButtonState createState() => _TimesCounterButtonState();
}

class _TimesCounterButtonState extends State<TimesCounterButton> {
  int timeRemainig;
  int counterMin = 0;
  int counterSec = 0;
  Timer timer;

  @override
  void initState() {
    super.initState();

    resetCounter();
  }

  int decrement() {
    return timeRemainig - 1 >= 0 ? timeRemainig-- : 0;
  }

  void resetCounter() {
    timeRemainig = widget.times;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kMainAppColor01,
      height: 75,
      child: Row(
        textDirection: ui.TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //         widget.times.toString(),
          //         (widget.index + 1).toString(),

          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Column(
              children: [
                SizedBox(height: 15),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: kMainAppColor02,
                  ),
                  onPressed: () {
                    String aboutUS =
                        "\n للمزيد من الاذكار والادعيه قم بتحميل التطبيق من خلال جوجل بلاي https://play.google.com/store/apps/details?id=com.fastworld.quranandsunnahapp";
                    Share.share(widget.text + aboutUS);
                  },
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
                onPressed: () {},
              ),
              Stack(
                children: [
                  // new CircularPercentIndicator(
                  //   radius: 62.0,
                  //   lineWidth: 6.0,
                  //   percent: 0.5,
                  //   progressColor: Colors.white,
                  // ),

                  IconButton(
                    iconSize: 45,
                    icon: Icon(
                      Icons.play_arrow,
                      color: kMainAppColor01,
                    ),
                    splashColor: Colors.grey,
                    onPressed: () {},
                  ),
                ],
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
                  onPressed: () {},
                ),
              )
            ],
          ),

          Column(
            children: [
              Text(
                widget.times.toString(),
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              IconButton(
                iconSize: 40,
                icon: Icon(
                  Icons.skip_next_outlined,
                  color: kMainAppColor02,
                ),
                splashColor: Colors.grey,
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
