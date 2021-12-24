import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Classes/local_quran_loader.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';

class SurahDecoratedTitle extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double minFontSize;
  final int surahNumber;
  final bool isMaccan;

  const SurahDecoratedTitle(
      {this.text,
      this.style,
      this.minFontSize,
      this.surahNumber,
      this.isMaccan});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Image.asset(
            'assets/images/surah03.png',
            width: 390,
            color: kMainAppColor01,
          ),
        ),
        Center(
          child: Container(
            width: 195,
            height: 45,
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    'رقم ${HelperMethods.convertDigitsIntoArabic(surahNumber)}',
                    style: TextStyle(fontSize: 15, color: kMainAppColor01),
                    // textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    text,
                    style: style != null
                        ? style.copyWith(fontSize: minFontSize)
                        : null,
                    // textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    isMaccan ? 'مكية' : 'مدنية',
                    style: TextStyle(fontSize: 15, color: kMainAppColor01),
                    // textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
