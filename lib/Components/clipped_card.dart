import 'package:flutter/material.dart';

class ClippedCard extends StatelessWidget {
  final bool isClipped;
  final Widget child;
  final ShapeBorder shape;
  final double elevation;
  final Color color;
  final Color shadowColor;
  final Color borderColor;
  final double borderSideWidth;
  final double borderRadiusCircular;
  final bool hasBorder;
  const ClippedCard(
      {this.isClipped,
      this.child,
      this.shape,
      this.elevation = 0,
      this.color,
      this.borderSideWidth,
      this.borderRadiusCircular,
      this.shadowColor,
      this.hasBorder,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation,
      shadowColor: shadowColor ?? color,
      clipBehavior: isClipped != null && isClipped
          ? Clip.antiAliasWithSaveLayer
          : Clip.none,
      shape: shape ??
          RoundedRectangleBorder(
            side: hasBorder == null || hasBorder
                ? BorderSide(
                    width: borderSideWidth ?? 1,
                    color: borderColor ?? Colors.grey,
                  )
                : const BorderSide(),
            borderRadius: BorderRadius.circular(borderRadiusCircular ?? 20),
          ),
      child: child,
    );
  }
}
