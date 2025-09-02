import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_mate_app/core/extension/context_extension.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/core/widget/circular_progress_indicator_adaptive.dart';
import 'package:movie_mate_app/features/main/movie/controller/movie_controller.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_model.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_state.dart';
import 'package:movie_mate_app/features/main/movie/screen/movie_detail_screen.dart';
import 'package:movie_mate_app/features/main/movie/widget/expanded_search_bar.dart';
import 'package:movie_mate_app/features/main/movie/widget/movie_tile.dart';
import 'package:movie_mate_app/features/main/movie/widget/search_movie_tile.dart';

class MovieScreen extends ConsumerStatefulWidget {
  const MovieScreen({super.key});

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    debugPrint('initState() Movie Screen');
    _fetchAllMovies();
    _scrollController.addListener(() {
      final position = _scrollController.position;

      // Paginating Now Playing Movies
      if (position.pixels >= position.maxScrollExtent - 300) {
        final nowPlayingMoviesState = ref.read(nowPlayingMoviesProvider);
        if (nowPlayingMoviesState is Success) {
          if (!nowPlayingMoviesState.isLoadingMore &&
              !nowPlayingMoviesState.hasReachedEnd) {
            Future.microtask(() {
              ref.read(nowPlayingMoviesProvider.notifier).fetchMovies();
            });
          }
        }
      }
    });
  }

  Future<void> _fetchAllMovies() async {
    Future.microtask(() async {
      await ref.read(popularMoviesProvider.notifier).fetchMovies();
      await ref.read(topRatedMoviesProvider.notifier).fetchMovies();
      await ref.read(nowPlayingMoviesProvider.notifier).fetchMovies();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarTheme.backgroundColor,
        surfaceTintColor: Colors.transparent,
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.agbalumo(
              fontSize: textTheme.titleLarge?.fontSize,
            ),
            children: [
              TextSpan(text: 'Movie'),
              TextSpan(
                text: 'Mate',
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main Content Below the Search Bar
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 80),

                  // Popular Movies
                  Consumer(
                    builder: (context, ref, child) {
                      final popularMoviesState = ref.watch(
                        popularMoviesProvider,
                      );

                      switch (popularMoviesState) {
                        case Loading():
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircularProgressIndicatorAdaptive(),
                          );
                        case Error(:final errorMessage, :final isNetworkError):
                          if (isNetworkError) {
                            return SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              errorMessage,
                              style: textTheme.bodySmall?.copyWith(color: red),
                            ),
                          );
                        case Success(
                          :final moviesList,
                          :final isLoadingMore,
                          :final hasReachedEnd,
                        ):
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(title: 'popular'.tr()),
                              AnimatedOpacity(
                                opacity: moviesList.isNotEmpty ? 1 : 0,
                                duration: Duration(milliseconds: 500),
                                child: _buildPopularMoviesList(
                                  moviesList: moviesList,
                                  isLoadingMore: isLoadingMore,
                                  hasReachedEnd: hasReachedEnd,
                                  onPaginate: (() {
                                    ref
                                        .read(popularMoviesProvider.notifier)
                                        .fetchMovies();
                                  }),
                                ),
                              ),
                            ],
                          );
                        default:
                          return SizedBox.shrink();
                      }
                    },
                  ),

                  SizedBox(height: 10),
                  // Top Rated Movies
                  Consumer(
                    builder: (context, ref, child) {
                      final topRatedMoviesState = ref.watch(
                        topRatedMoviesProvider,
                      );

                      switch (topRatedMoviesState) {
                        case Loading():
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircularProgressIndicatorAdaptive(),
                          );
                        case Error(:final errorMessage, :final isNetworkError):
                          if (isNetworkError) {
                            return SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              errorMessage,
                              style: textTheme.bodySmall?.copyWith(color: red),
                            ),
                          );
                        case Success(
                          :final moviesList,
                          :final isLoadingMore,
                          :final hasReachedEnd,
                        ):
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(title: 'top_rated'.tr()),
                              _buildTopRatedMoviesList(
                                moviesList: moviesList,
                                isLoadingMore: isLoadingMore,
                                hasReachedEnd: hasReachedEnd,
                                onPaginate: (() {
                                  ref
                                      .read(topRatedMoviesProvider.notifier)
                                      .fetchMovies();
                                }),
                              ),
                            ],
                          );
                        default:
                          return SizedBox.shrink();
                      }
                    },
                  ),

                  SizedBox(height: 10),
                  // Now Playing Movies
                  Consumer(
                    builder: (context, ref, child) {
                      final nowPlayingMoviesState = ref.watch(
                        nowPlayingMoviesProvider,
                      );

                      switch (nowPlayingMoviesState) {
                        case Loading():
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircularProgressIndicatorAdaptive(),
                          );
                        case Error(:final errorMessage):
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              errorMessage,
                              style: textTheme.bodySmall?.copyWith(color: red),
                            ),
                          );
                        case Success(
                          :final moviesList,
                          :final isLoadingMore,
                          :final hasReachedEnd,
                        ):
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(title: 'now_playing'.tr()),
                              _buildNowPlayingMoviesList(
                                moviesList: moviesList,
                                isLoadingMore: isLoadingMore,
                                hasReachedEnd: hasReachedEnd,
                              ),
                              isLoadingMore && !hasReachedEnd
                                  ? Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child:
                                            CircularProgressIndicatorAdaptive(),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          );
                        default:
                          return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Expanded Search Bar in Top
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: _buildExpandedSearchBar(ref: ref),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required String title, int titleMaxLines = 2}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
        maxLines: titleMaxLines,
      ),
    );
  }

  Widget _buildPopularMoviesList({
    required List<MovieModel> moviesList,
    required bool isLoadingMore,
    required hasReachedEnd,
    VoidCallback? onPaginate,
  }) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    if (moviesList.isEmpty) {
      return Center(child: Text('No Popular Movies!'));
    }
    return Container(
      height: 230,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDarkTheme
                ? white.withOpacity(0.1)
                : black.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 300 &&
              !isLoadingMore &&
              !hasReachedEnd) {
            Future.microtask(() => onPaginate?.call());
          }
          return true;
        },
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.8, initialPage: 1),
          scrollDirection: Axis.horizontal,
          itemCount: moviesList.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= moviesList.length && isLoadingMore && !hasReachedEnd) {
              return Center(child: CircularProgressIndicatorAdaptive());
            } else {
              final movie = moviesList[index];
              return MovieTile(
                movie: movie,
                tileWidth: double.maxFinite,
                onTap: ((movie, imageHeroTag) {
                  context.navigateToMovieDetailScreen(
                    movie: movie,
                    imageHeroTag: imageHeroTag,
                  );
                }),
                imageHeroTag: 'popular_image/${movie.id}',
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTopRatedMoviesList({
    required List<MovieModel> moviesList,
    required bool isLoadingMore,
    required hasReachedEnd,
    VoidCallback? onPaginate,
  }) {
    if (moviesList.isEmpty) {
      return Center(child: Text('No Top Rated Movies!'));
    }
    return SizedBox(
      height: 230,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 300 &&
              !isLoadingMore &&
              !hasReachedEnd) {
            Future.microtask(() => onPaginate?.call());
          }
          return true;
        },
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: moviesList.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= moviesList.length && isLoadingMore && !hasReachedEnd) {
              return Center(child: CircularProgressIndicatorAdaptive());
            } else {
              final movie = moviesList[index];
              return MovieTile(
                movie: movie,
                onTap: ((movie, imageHeroTag) {
                  context.navigateToMovieDetailScreen(
                    movie: movie,
                    imageHeroTag: imageHeroTag,
                  );
                }),
                imageHeroTag: 'top_rated_image/${movie.id}',
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildNowPlayingMoviesList({
    required List<MovieModel> moviesList,
    required bool isLoadingMore,
    required bool hasReachedEnd,
  }) {
    if (moviesList.isEmpty) {
      return Center(child: Text('No Now Playing Movies!'));
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.70,
      ),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: moviesList.length,
      itemBuilder: (context, index) {
        final movie = moviesList[index];
        return MovieTile(
          movie: movie,
          onTap: ((movie, imageHeroTag) {
            context.navigateToMovieDetailScreen(
              movie: movie,
              imageHeroTag: imageHeroTag,
            );
          }),
          imageHeroTag: 'now_playing_image/${movie.id}',
        );
      },
    );
  }

  Widget _buildExpandedSearchBar({required WidgetRef ref}) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDarkTheme ? backgroundDark : backgroundLight,
      padding: const EdgeInsets.all(10.0),
      child: ExpandedSearchBar(),
    );
  }
}
