import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/core/theme/component_themes.dart';
import 'package:movie_mate_app/core/theme/dialog_theme.dart';
import 'package:movie_mate_app/core/theme/snackbar_theme.dart';
import 'package:movie_mate_app/core/theme/text_themes.dart';

class MovieMateTheme {
  MovieMateTheme._();

  static final ThemeData themeLight = ThemeData(
    brightness: Brightness.light,
    colorScheme: colorSchemeLight,
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: appBarThemeLight,
    textTheme: textThemeLight,
    elevatedButtonTheme: elevatedButtonTheme,
    textButtonTheme: textButtonTheme,
    inputDecorationTheme: inputDecorationTheme,
    floatingActionButtonTheme: floatingActionButtonTheme,
    dialogTheme: dialogThemeLight,
    snackBarTheme: snackBarThemeLight
  );

  static final ThemeData themeDark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: colorSchemeDark,
    scaffoldBackgroundColor: backgroundDark,
    appBarTheme: appBarThemeDark,
    textTheme: textThemeDark,
    elevatedButtonTheme: elevatedButtonTheme,
    textButtonTheme: textButtonTheme,
    inputDecorationTheme: inputDecorationTheme,
    floatingActionButtonTheme: floatingActionButtonTheme,
    dialogTheme: dialogThemeDark,
    snackBarTheme: snackBarThemeDark
  );


}