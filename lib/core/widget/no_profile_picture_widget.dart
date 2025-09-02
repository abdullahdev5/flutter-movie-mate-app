import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';

class NoProfilePictureWidget extends StatelessWidget {
  const NoProfilePictureWidget({
    super.key,
    this.radius = 150.0,
    this.boxColor = lightGray,
    this.personIconColor = black,
  });

  final double radius;
  final Color boxColor;
  final Color personIconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: boxColor, shape: BoxShape.circle),
      child: Icon(Icons.person, size: radius / 2, color: personIconColor),
    );
  }
}
