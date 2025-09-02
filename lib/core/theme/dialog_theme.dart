import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';

final DialogThemeData dialogThemeLight = DialogThemeData(
  backgroundColor: backgroundLight,
  titleTextStyle: TextStyle(color: black),
  contentTextStyle: TextStyle(color: black)
);

final DialogThemeData dialogThemeDark = DialogThemeData(
  backgroundColor: backgroundDark,
  titleTextStyle: TextStyle(color: white),
  contentTextStyle: TextStyle(color: white),
);