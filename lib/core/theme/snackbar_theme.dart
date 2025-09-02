import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';

final SnackBarThemeData snackBarThemeLight = SnackBarThemeData(
  backgroundColor: backgroundDark,
  actionTextColor: white,
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);

final SnackBarThemeData snackBarThemeDark = SnackBarThemeData(
  backgroundColor: backgroundLight,
  actionTextColor: black,
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);