import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';

class CircularProgressIndicatorAdaptive extends StatelessWidget {
  const CircularProgressIndicatorAdaptive({
    super.key,
    this.color = primaryColor,
    this.progress
  });

  final Color color;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation(color),
      value: progress,
    );
  }
}
