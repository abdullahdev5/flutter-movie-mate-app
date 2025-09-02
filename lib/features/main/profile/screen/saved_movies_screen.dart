import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/core/extension/context_extension.dart';
import 'package:movie_mate_app/core/widget/circular_progress_indicator_adaptive.dart';
import 'package:movie_mate_app/features/main/movie/controller/movie_controller.dart';
import 'package:movie_mate_app/features/main/movie/widget/search_movie_tile.dart';


class SavedMoviesScreen extends ConsumerWidget {
  const SavedMoviesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('saved_movies'.tr()),
      ),
      body: StreamBuilder(
        stream: ref.read(savedMoviesProvider.notifier).getSavedMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicatorAdaptive());
          }

          if (!snapshot.hasData || (snapshot.data ?? []).isEmpty) {
            return Center(child: Text('No Saved Movies'));
          }

          final moviesList = snapshot.data ?? [];
          return ListView.builder(
            itemCount: moviesList.length,
            itemBuilder: (context, index) {
              final movie = moviesList[index];
              return SearchMovieTile(
                movie: movie,
                onTap: (movie, imageHeroTag) {
                  context.navigateToMovieDetailScreen(
                    movie: movie,
                    imageHeroTag: imageHeroTag,
                  );
                },
                imageHeroTag: 'saved_image/${movie.id}',
              );
            },
          );
        },
      ),
    );
  }
}

