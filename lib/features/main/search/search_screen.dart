import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/core/extension/context_extension.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/core/widget/circular_progress_indicator_adaptive.dart';
import 'package:movie_mate_app/features/main/movie/controller/movie_controller.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_state.dart';
import 'package:movie_mate_app/features/main/movie/widget/search_movie_tile.dart';

final randomPosterProvider = Provider<String?>((ref) {
  final searchMoviesState = ref.watch(searchMoviesFullScreenProvider);
  if (searchMoviesState is Success && searchMoviesState.moviesList.isNotEmpty) {
    final randomIndex = Random().nextInt(
      searchMoviesState.moviesList.length - 1,
    );
    final randomMovie = searchMoviesState.moviesList[randomIndex];
    return randomMovie.posterUrl500Size;
  } else {
    return null;
  }
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ValueNotifier<String> _searchQuery = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    debugPrint('initState() SearchScreen');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onSubmitted: (value) {
                _searchQuery.value = value;
                ref
                    .read(searchMoviesFullScreenProvider.notifier)
                    .fetchMovies(
                      query: _searchQuery.value,
                      wantToPaginate: false,
                    );
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'search_hint'.tr(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Divider(height: 2),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Random Poster Image
                Consumer(
                  builder: (context, ref, child) {
                    final randomPosterUrl = ref.watch(randomPosterProvider);
                    debugPrint('Random Poster Url: $randomPosterUrl');
                    return Positioned.fill(
                      child: randomPosterUrl != null
                          ? Image.network(
                              randomPosterUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error_outline, color: red),
                            )
                          : SizedBox(),
                    );
                  },
                ),

                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final searchMoviesState = ref.watch(
                          searchMoviesFullScreenProvider,
                        );

                        switch (searchMoviesState) {
                          case Loading():
                            return Center(
                              child: CircularProgressIndicatorAdaptive(),
                            );
                          case Error(:final errorMessage):
                            return Center(
                              child: Text(
                                errorMessage,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: red,
                                ),
                              ),
                            );
                          case Success(
                            :final moviesList,
                            :final isLoadingMore,
                            :final hasReachedEnd,
                          ):
                            if (moviesList.isEmpty) {
                              return Center(child: Text('No Movies found!'));
                            }
                            return ValueListenableBuilder(
                              valueListenable: _searchQuery,
                              builder: (context, searchQuery, child) {
                                return NotificationListener<ScrollNotification>(
                                  onNotification: (notification) {
                                    if (notification.metrics.pixels >=
                                            notification
                                                    .metrics
                                                    .maxScrollExtent -
                                                300 &&
                                        !isLoadingMore &&
                                        !hasReachedEnd) {
                                      Future.microtask(() {
                                        ref
                                            .read(
                                              searchMoviesFullScreenProvider
                                                  .notifier,
                                            )
                                            .fetchMovies(query: searchQuery);
                                      });
                                    }
                                    return true;
                                  },
                                  child: ListView.builder(
                                    itemCount:
                                        moviesList.length +
                                        (isLoadingMore ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index == moviesList.length &&
                                          isLoadingMore &&
                                          !hasReachedEnd) {
                                        return Center(
                                          child:
                                              CircularProgressIndicatorAdaptive(),
                                        );
                                      } else {
                                        final movie = moviesList[index];
                                        return SearchMovieTile(
                                          movie: movie,
                                          onTap: ((movie, imageHeroTag) {
                                            context.navigateToMovieDetailScreen(
                                              movie: movie,
                                              imageHeroTag: imageHeroTag,
                                            );
                                          }),
                                          imageHeroTag:
                                              'search_full_screen_image/${movie.id}',
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            );
                          default:
                            return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
