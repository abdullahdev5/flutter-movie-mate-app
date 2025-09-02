import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/core/extension/context_extension.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/core/widget/circular_progress_indicator_adaptive.dart';
import 'package:movie_mate_app/features/main/movie/controller/movie_controller.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_state.dart';
import 'package:movie_mate_app/features/main/movie/widget/search_movie_tile.dart';

class ExpandedSearchBar extends ConsumerStatefulWidget {
  const ExpandedSearchBar({super.key});

  @override
  ConsumerState<ExpandedSearchBar> createState() => _ExpandedSearchBarState();
}

class _ExpandedSearchBarState extends ConsumerState<ExpandedSearchBar> {
  final ValueNotifier<bool> _isSearchBarExpanded = ValueNotifier(false);
  final ValueNotifier<String> _searchQuery = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: BoxBorder.all(color: isDarkTheme ? white : black),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: _isSearchBarExpanded,
            builder: (context, isSearchBarExpanded, child) {
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                child: TextField(
                  onTap: (() {
                    _isSearchBarExpanded.value = true;
                  }),
                  onSubmitted: ((String? value) {
                    if (value == null) return;

                    _searchQuery.value = value;

                    debugPrint(
                      'Encoded Query: ${Uri.encodeQueryComponent(_searchQuery.value)}',
                    );
                    ref
                        .read(searchMoviesExpandedProvider.notifier)
                        .fetchMovies(
                          query: _searchQuery.value,
                          wantToPaginate: false,
                        );
                  }),
                  canRequestFocus: isSearchBarExpanded,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'search_hint'.tr(),
                    prefixIcon: isSearchBarExpanded
                        ? IconButton(
                            onPressed: (() {
                              _isSearchBarExpanded.value = false;
                            }),
                            icon: Icon(Icons.arrow_back),
                          )
                        : Icon(Icons.search),
                  ),
                ),
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: _isSearchBarExpanded,
            builder: (context, isSearchBarExpanded, child) {
              return AnimatedSize(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: ConstrainedBox(
                  constraints: isSearchBarExpanded
                      ? BoxConstraints()
                      : BoxConstraints(maxHeight: 0),
                  child: AnimatedOpacity(
                    opacity: isSearchBarExpanded ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final searchMoviesState = ref.watch(
                          searchMoviesExpandedProvider,
                        );

                        switch (searchMoviesState) {
                          case Loading():
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: CircularProgressIndicatorAdaptive(),
                              ),
                            );
                          case Error(:final errorMessage):
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  errorMessage,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(color: red),
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
                            return SizedBox(
                              height: 500,
                              child: ValueListenableBuilder(
                                valueListenable: _searchQuery,
                                builder: (context, searchQuery, child) {
                                  return NotificationListener<
                                    ScrollNotification
                                  >(
                                    onNotification: (notification) {
                                      if (notification.metrics.pixels >=
                                              notification
                                                      .metrics
                                                      .maxScrollExtent -
                                                  300 &&
                                          !isLoadingMore &&
                                          !hasReachedEnd) {
                                        ref
                                            .read(
                                              searchMoviesExpandedProvider
                                                  .notifier,
                                            )
                                            .fetchMovies(query: searchQuery);
                                      }
                                      return true;
                                    },
                                    child: ListView.builder(
                                      itemCount:
                                          moviesList.length +
                                          (isLoadingMore ? 1 : 0),
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        if (index >= moviesList.length &&
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
                                              context
                                                  .navigateToMovieDetailScreen(
                                                    movie: movie,
                                                    imageHeroTag: imageHeroTag,
                                                  );
                                            }),
                                            imageHeroTag:
                                                'search_image/${movie.id}',
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          default:
                            return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
