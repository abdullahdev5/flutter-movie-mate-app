import 'package:flutter/material.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_model.dart';
import 'package:movie_mate_app/features/main/movie/screen/movie_detail_screen.dart';

extension ContextExtension on BuildContext {
  void showSnackBar({
    required String message,
    Color? backgroundColor,
    int durationInSec = 3,
  }) {
    final snackBarTheme = Theme.of(this).snackBarTheme;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: snackBarTheme.behavior,
        backgroundColor: backgroundColor ?? snackBarTheme.backgroundColor,
        shape: snackBarTheme.shape,
        duration: Duration(seconds: durationInSec),
      ),
    );
  }

  void navigateToMovieDetailScreen({
    required MovieModel movie,
    required String imageHeroTag,
  }) {
    Navigator.of(this).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        reverseTransitionDuration: Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child: MovieDetailScreen(
                movie: movie,
                imageHeroTag: imageHeroTag,
              ),
            )
      ),
    );
  }
}
