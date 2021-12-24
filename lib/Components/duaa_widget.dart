import 'package:quranandsunnahapp/Classes/DuaaModel.dart';
import 'package:quranandsunnahapp/Classes/azkar_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/clipped_card.dart';
import 'package:quranandsunnahapp/Components/times_counter_button.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';

class DuaaWidget extends StatelessWidget {
  final DuaaModel duaa;
  final int index;

  const DuaaWidget({this.duaa, this.index});

  List<TextSpan> allText() {
    String afterParsing = HelperMethods.parseHtmlString(duaa.zekr);
    List<String> mystr = afterParsing.split(" ");
    List<TextSpan> allTextWidget = [];
    for (int i = 0; i < mystr.length; i++) {
      // print(mystr[i]);
      if (mystr[i] == "اللَّهُمَّ" ||
          mystr[i] == "اللهم" ||
          mystr[i] == 'إلهي' ||
          mystr[i] == "إلهنا" ||
          mystr[i] == "ربنا" ||
          mystr[i] == "رب" ||
          mystr[i] == "((اللهم" ||
          mystr[i] == "اللَّهُمَّ") {
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

  @override
  Widget build(BuildContext context) {
    return ClippedCard(
      isClipped: true,
      shape: HelperMethods.clippedCardShape,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RichText(
              text: TextSpan(children: allText())
              //HelperMethods.parseHtmlString(zekr.zekr),
              ,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
            ),
            //Text(zekr.zekr),
            if (duaa.reference != null && duaa.reference.isNotEmpty)
              Text(
                HelperMethods.parseHtmlString(duaa.reference),
                style: kTextStyleBlackNormal.copyWith(
                    fontSize: 25, color: kMainAppColor01),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
              ),
            if (duaa.description != null && duaa.description.isNotEmpty)
              Text(
                HelperMethods.parseHtmlString(duaa.description),
                style: kTextStyleBlackNormal.copyWith(
                    fontSize: 25, color: kMainAppColor01),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
              ),
            if (duaa.name != null && duaa.name.isNotEmpty)
              Text(
                duaa.name,
                style: kTextStyleBlackNormal.copyWith(
                    fontSize: 25, color: kMainAppColor01),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
              ),

            TimesCounterButton(
              times: duaa.count,
              index: index,
              text: duaa.zekr,
            ),
          ],
        ),
      ),
    );
  }
}
