import 'package:quranandsunnahapp/Components/gradient_colors_decorated_container.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'bordered_text.dart';
import 'clipped_card.dart';

class BookButton extends StatelessWidget {
  final List<String> texts;
  final Function onTap;
  // final String imageLink;
  final double width;
  final double height;
  final double fontSize;
  final TextStyle style;

  const BookButton({
    this.texts,
    // this.imageLink,
    this.fontSize,
    this.width,
    this.height,
    this.style,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height ?? width,
        minWidth: width,
        maxWidth: width,
      ),
      child: ClippedCard(
        elevation: 5,
        shadowColor: kMainAppColor05,
        isClipped: true,
        shape: RoundedRectangleBorder(
          side: kMainCategoriesButtonBorderSide,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: GradientColorsDecoratedContainer(
          gradient: LinearGradient(
              colors: kMainLinearGradient.colors,
              begin: kMainLinearGradient.begin,
              end: kMainLinearGradient.end),
          child: MaterialButton(
            onPressed: () {
              // print(texts);
              if (onTap != null) onTap();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: texts.map((text) {
                return Text(
                  text,
                  style: style != null
                      ? style.copyWith(fontSize: fontSize)
                      : kHadithButtonTextStyleWhiteScheherazadeFontNormal
                          .copyWith(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
