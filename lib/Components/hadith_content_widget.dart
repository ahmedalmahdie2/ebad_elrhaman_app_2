import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'clipped_card.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class HadithContentWidget extends StatelessWidget {
  final List<String> text;
  final List<String> bookTitle;
  final List<String> subBookTitle;
  final List<String> chapterTitle;
  final String chapterNumber;

  // final Function onTap;

  const HadithContentWidget({
    this.text,
    this.bookTitle,
    this.subBookTitle,
    this.chapterTitle,
    this.chapterNumber,
  });

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ClippedCard(
        isClipped: true,
        shape: HelperMethods.clippedCardShape,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Text(
              //   bookTitle[0],
              //   style: kTextStyleBlackNormal.copyWith(
              //       fontSize: 25, color: kMainAppColor01),
              //   textAlign: TextAlign.justify,
              //   textDirection: TextDirection.rtl,
              // ),
              Text(
                  HelperMethods.isArabic(context)
                      ? subBookTitle[0]
                      : subBookTitle[1],
                  style: kTextStyleBlackNormal.copyWith(fontSize: 25),
                  textDirection: HelperMethods.isArabic(context)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  textAlign: TextAlign.justify),
              Text(
                HelperMethods.isArabic(context)
                    ? chapterTitle[0]
                    : chapterTitle[1],
                style: kTextStyleBlackNormal.copyWith(
                    fontSize: 25, color: kMainAppColor03),
                textDirection: HelperMethods.isArabic(context)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                textAlign: TextAlign.justify,
              ),
              Text(
                HelperMethods.isArabic(context) ? text[0] : text[1],
                style: kTextStyleBlackNormal.copyWith(
                    fontSize: 25, color: kMainAppColor01),
                textDirection: HelperMethods.isArabic(context)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
