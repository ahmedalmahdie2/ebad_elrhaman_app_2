import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/gradient_colors_decorated_container.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
import 'bordered_text.dart';
import 'clipped_card.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final String imageLink;
  final double width;
  final double height;
  final double fontSize;
  final TextStyle style;
  final bool shouldAddBorder;

  const CategoryButton({
    this.text,
    this.imageLink,
    this.fontSize,
    this.width,
    this.height,
    this.style,
    this.shouldAddBorder,
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
        shadowColor: kMainAppColor01,
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
              print(text);
              onTap();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                shouldAddBorder == null || shouldAddBorder
                    ? BorderedText(
                        text: text,
                        borderColor: kMainAppColor01,
                        style: style != null
                            ? style
                            : kButtonTextStyleScheherazadeFontNormal,
                        align: TextAlign.center,
                        minFontSize: fontSize,
                      )
                    : Text(
                        text,
                        style: style != null
                            ? style.copyWith(
                                fontSize: fontSize, color: Colors.white)
                            : kButtonTextStyleScheherazadeFontNormal.copyWith(
                                fontSize: fontSize, color: Colors.white),
                        textAlign: TextAlign.center,
                      ).tr(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
