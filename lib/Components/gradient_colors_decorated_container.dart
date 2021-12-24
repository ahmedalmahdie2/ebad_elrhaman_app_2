import 'package:flutter/material.dart';

class GradientColorsDecoratedContainer extends StatelessWidget {
  final Widget child;
  final LinearGradient gradient;
  const GradientColorsDecoratedContainer(
      {this.child, this.gradient,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: child,
    );
  }
}
