import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BorderedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color borderColor;
  final TextAlign align;
  final double minFontSize;

  const BorderedText(
      {this.text, this.style, this.align, this.minFontSize, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: style != null
              ? style.copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = borderColor,
                  fontSize: minFontSize,
                )
              : null,
          textAlign: align ?? TextAlign.center,
        ).tr(),
        // Solid text as fill.
        Text(
          text,
          style: style != null ? style.copyWith(fontSize: minFontSize) : null,
          textAlign: align ?? TextAlign.center,
        ).tr(),
      ],
    );
  }
}
