import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    super.key,
    this.radius = 150,
    required this.backgroundImage,
  });

  final double radius;
  final Widget backgroundImage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: backgroundImage,
    );
  }
}
