import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';


final AppBarTheme appBarThemeLight = AppBarTheme(
  backgroundColor: backgroundLight,
  foregroundColor: black
);

final AppBarTheme appBarThemeDark = AppBarTheme(
  backgroundColor: backgroundDark,
  foregroundColor: white
);

final ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: white
  )
);

final TextButtonThemeData textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: primaryColor
  )
);

final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: primaryColor)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: primaryColor)
  ),
  hintStyle: TextStyle(
    color: lightGray
  ),
);

final FloatingActionButtonThemeData floatingActionButtonTheme = FloatingActionButtonThemeData(
  shape: CircleBorder(),
  backgroundColor: primaryColor,
  foregroundColor: white
);
