import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Classes/local_quran_loader.dart';
import 'package:quranandsunnahapp/Classes/quran_data.dart';
import 'package:quranandsunnahapp/Components/clipped_card.dart';
import 'package:quranandsunnahapp/Components/surah_decorated_title.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as HtmlDom;

class SurahWidget extends StatefulWidget {
  final SurahData surah;
  final isMojoad;

  static int ayahHighlighted = -1;

  const SurahWidget({this.surah, this.isMojoad});

  @override
  _SurahWidgetState createState() => _SurahWidgetState();
}

class _SurahWidgetState extends State<SurahWidget> {
  String _parseHtmlString(String htmlString) {
    final document = htmlParser.parse(htmlString);
    final String parsedString =
        htmlParser.parse(document.body.text).documentElement.text;
    return parsedString ?? "";
  }

  WidgetSpan ayahNumberWidget(int ayahNumber, TextStyle style) {
    return WidgetSpan(
      child: Container(
        width: 36,
        height: 36,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/ayah2.png',
                // width: 35,
                // height: 35,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${HelperMethods.convertDigitsIntoArabic(ayahNumber)}',
                  style: style,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// this will render the ayah number inside the ayah decoration
  /// but will change size as the number gets bigger
  TextSpan ayahNumberWidgetUsingFont(int ayahNumber, TextStyle style) {
    return TextSpan(
      text:
          ' \uFD3F${HelperMethods.convertDigitsIntoArabic(ayahNumber)}\uFD3E ',
      style: style,
    );
  }

  List<TextSpan> allText(String ayah) {
    List<String> mystr = ayah.split(" ");
    List<TextSpan> allTextWidget = [];
    for (int i = 0; i < mystr.length; i++) {
      if (mystr[i] == "اللَّهُ" ||
          mystr[i] == "اللَّهِ" ||
          mystr[i] == "وَاللَّهُ" ||
          mystr[i] == "اللَّهِ ") {
        allTextWidget.add(TextSpan(
          text: mystr[i],
          style: kTextStyleRedNormal.copyWith(fontSize: 25),
          // textAlign: TextAlign.justify,
          // textDirection: TextDirection.rtl,
        ));
        allTextWidget.add(TextSpan(text: " "));
      } else {
        // print(mystr[i]);
        allTextWidget.add(TextSpan(
          text: mystr[i],
          style: kTextStyleBlackNormal.copyWith(fontSize: 25),
          //textAlign: TextAlign.justify,
          //textDirection: TextDirection.rtl,
        ));
        allTextWidget.add(TextSpan(text: " "));
      }
    }
    return allTextWidget;
  }

  bool onOff = false;
  @override
  Widget build(BuildContext context) {
    int currentQuarter = widget.surah.ayatData[0].quarterNumber;
    var width = MediaQuery.of(context).size.width;
    var screenFactor = MediaQuery.of(context).devicePixelRatio > 2.85
        ? MediaQuery.of(context).devicePixelRatio
        : 2.85;
    var surahTitleFontSize = kSurahTitleFontSizeUnit * width * screenFactor;
    var ayahTextFontSize = kAyahTextFontSizeUnit * width * screenFactor;
    print(
        'surahTitleFontSize: $surahTitleFontSize, ayahTextFontSize: $ayahTextFontSize');
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SurahDecoratedTitle(
              text: kSurahsNamesGlyphs[widget.surah.surahNumber - 1],
              style: kUthmaniHafs1FontTextStyle.copyWith(
                  fontSize: surahTitleFontSize,
                  color: kMainQuranLightColor01,
                  fontFamily: 'QuranSurahNamesFont',
                  height: 0.8),
              minFontSize: surahTitleFontSize,
            ),
            widget.surah.hasBasmalah
                ? Center(
                    child: Image.asset(
                    'assets/images/bismillah.png',
                    width: 200,
                    // color: kMainAppColor01,
                  ))
                : Container(
                    height: 0,
                  ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: widget.surah.ayatData.map(
                    (ayah) {
                      bool flag = false;
                      if (widget.surah.ayatData[ayah.ayahNumber - 1]
                              .quarterNumber >
                          currentQuarter) {
                        flag = true;
                        currentQuarter++;
                      }
                      return TextSpan(
                        text: flag == true
                            ? "۞ ۞۞" + _parseHtmlString(ayah.text)
                            : _parseHtmlString(ayah.text +
                                ' ${String.fromCharCode(LocalQuranJsonFileLoader.getAyahIntNumberInQuranFont(ayah.ayahNumber))} '),
                        style: kUthmaniHafs1FontTextStyle.copyWith(
                          backgroundColor: onOff == true &&
                                  SurahWidget.ayahHighlighted != -1 &&
                                  SurahWidget.ayahHighlighted == ayah.ayahNumber
                              ? Colors.red[200]
                              : kMainAppColor02,
                          fontSize: ayahTextFontSize,
                          height: 1.5,

                          color: kMainQuranLightColor01,
                          fontWeight: FontWeight.bold
                        ),

                        // children: [
                        //   ayahNumberWidget(
                        //     ayah.ayahNumber,
                        //     kButtonTextStyleWhiteScheherazadeFontNormal
                        //         .copyWith(
                        //       fontSize: 19,
                        //       color: kMainQuranLightColor01,
                        //     ),
                        //   ),
                        // ],
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            // print(
                            //     'Tap on ayah: ${ayah.ayahNumber + 1}');

                            setState(() {
                              if (onOff &&
                                  SurahWidget.ayahHighlighted ==
                                      ayah.ayahNumber) {
                                onOff = false;
                                SurahWidget.ayahHighlighted = -1;
                              } else {
                                onOff = true;
                                SurahWidget.ayahHighlighted = ayah.ayahNumber;
                              }
                            });
                          },
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
