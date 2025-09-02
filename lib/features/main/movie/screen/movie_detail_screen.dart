import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/core/widget/circular_progress_indicator_adaptive.dart';
import 'package:movie_mate_app/features/main/movie/controller/movie_controller.dart';
import 'package:movie_mate_app/features/main/movie/controller/movie_trailer_controller.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  const MovieDetailScreen({
    super.key,
    required this.movie,
    required this.imageHeroTag,
  });

  final MovieModel movie;
  final String imageHeroTag;

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<Offset>? _titleSlideAnimation;
  Animation<Offset>? _overviewSlideAnimation;

  final ValueNotifier<bool> _isSaved = ValueNotifier(false);

  YoutubePlayerController? _youtubePlayerController;
  String? _trailerKey;
  ValueNotifier<bool> _isTrailerPlaying = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _isSaved.value = ref
        .read(savedMoviesProvider.notifier)
        .getIsMovieSaved(widget.movie.id);

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _titleSlideAnimation =
        Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController!,
            curve: Curves.easeOutCubic,
          ),
        );

    _overviewSlideAnimation =
        Tween<Offset>(begin: const Offset(-2.0, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController!,
            curve: Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animationController?.forward();
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    _animationController?.dispose();
    _trailerKey = null;
    _isTrailerPlaying.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final movie = widget.movie;

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _isTrailerPlaying,
        builder: (context, isTrailerPlaying, child) {
          return PopScope(
            canPop: !isTrailerPlaying,
            onPopInvokedWithResult: (didPop, result) {
              if (isTrailerPlaying) {
                _isTrailerPlaying.value = false;
                if (_youtubePlayerController != null &&
                    _youtubePlayerController!.value.isReady) {
                  _youtubePlayerController!.pause();
                }
              }
              if (didPop) {
                ref
                    .read(movieTrailerControllerProvider(movie.id).notifier)
                    .resetMovieTrailer();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    // This is Important for Overflowed Buttons
                    children: [
                      // Image
                      Container(
                        width: double.maxFinite,
                        height: 300,
                        color: isDarkTheme ? backgroundDark : backgroundLight,
                        child: Consumer(
                          builder: (context, ref, child) {
                            final movieTrailerState = ref.watch(
                              movieTrailerControllerProvider(movie.id),
                            );

                            return movieTrailerState.when(
                              data: (trailerKey) {
                                debugPrint(
                                  'Trailer Key: $trailerKey (Success UI)',
                                );
                                if (_trailerKey == null && trailerKey != null) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    setState(() {
                                      _trailerKey = trailerKey;
                                      _youtubePlayerController ??=
                                          YoutubePlayerController(
                                            initialVideoId: trailerKey,
                                            flags: const YoutubePlayerFlags(
                                              autoPlay: true,
                                            ),
                                          );
                                    });
                                    if (!isTrailerPlaying &&
                                        _trailerKey != null) {
                                      _isTrailerPlaying.value = true;
                                    }
                                  });
                                }

                                if (isTrailerPlaying &&
                                    _youtubePlayerController != null) {
                                  return SafeArea(
                                    child: YoutubePlayer(
                                      controller: _youtubePlayerController!,
                                      showVideoProgressIndicator: true,
                                      progressIndicatorColor: primaryColor,
                                    ),
                                  );
                                } else {
                                  return movie.posterUrl500Size != null
                                      ? Hero(
                                          tag: widget.imageHeroTag,
                                          child: Image.network(
                                            movie.posterUrl500Size!,
                                            width: double.maxFinite,
                                            height: double.maxFinite,
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                                      Icons.error_outline,
                                                      color: red,
                                                    ),
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child: CircularProgressIndicatorAdaptive(
                                                    progress:
                                                        loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        )
                                      : const SizedBox();
                                }
                              },
                              error: (error, stackTrace) =>
                                  Text(error.toString()),
                              loading: () => Center(
                                child: CircularProgressIndicatorAdaptive(),
                              ),
                            );
                          },
                        ),
                      ),

                      // Bottom fade to hide hard edge
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 120,
                        child: !isTrailerPlaying
                            ? Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      isDarkTheme
                                          ? backgroundDark
                                          : backgroundLight,
                                      // fully dark to hide the edge
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ),

                      // Overflowed Buttons at the Bottom Right
                      Positioned(
                        bottom: -25,
                        right: 10,
                        child: !isTrailerPlaying
                            ? Row(
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: _isSaved,
                                    builder: (context, isSaved, child) {
                                      return _buildCircleButton(
                                        onPressed: () {
                                          _isSaved.value = !_isSaved.value;
                                          if (_isSaved.value) {
                                            ref
                                                .read(
                                                  savedMoviesProvider.notifier,
                                                )
                                                .saveMovieToSavedList(movie);
                                          } else {
                                            ref
                                                .read(
                                                  savedMoviesProvider.notifier,
                                                )
                                                .removeMovieFromSavedList(
                                                  movie.id,
                                                );
                                          }
                                        },
                                        child: AnimatedSaveMovieButton(
                                          isSaved: isSaved,
                                        ),
                                        tooltipMessage: isSaved
                                            ? 'unsave_movie'.tr()
                                            : 'save_movie'.tr(),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 8),
                                  _buildCircleButton(
                                    onPressed: () {
                                      if (_trailerKey == null) {
                                        ref
                                            .read(
                                              movieTrailerControllerProvider(
                                                movie.id,
                                              ).notifier,
                                            )
                                            .fetchMovieTrailerYoutubeKey(
                                              movie.id,
                                            );
                                      } else {
                                        if (!isTrailerPlaying) {
                                          _isTrailerPlaying.value = true;
                                        }
                                      }
                                    },
                                    child: Icon(
                                      Icons.play_arrow,
                                      color: primaryColor,
                                    ),
                                    tooltipMessage: 'play_movie'.tr(),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),

                      // back Button
                      Positioned(
                        left: 10,
                        top: kToolbarHeight,
                        child: _buildCircleButton(
                          onPressed: (() {
                            if (isTrailerPlaying) {
                              _isTrailerPlaying.value = false;
                              if (_youtubePlayerController != null &&
                                  _youtubePlayerController!.value.isReady) {
                                _youtubePlayerController!.pause();
                              }
                            } else {
                              Navigator.of(context).pop();
                            }
                          }),
                          backgroundColor: white.withOpacity(0.4),
                          child: Icon(Icons.arrow_back_ios, color: black),
                          tooltipMessage: 'back'.tr(),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  // Movie Details
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SlideTransition(
                          position: _titleSlideAnimation!,
                          child: Text(
                            movie.originalTitle ?? 'No Title',
                            style: textTheme.titleLarge,
                          ),
                        ),
                        Text(
                          '${'released_in'.tr()} ${movie.releaseDate ?? ''}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: lightGray,
                          ),
                        ),
                        Row(
                          spacing: 10.0,
                          children: [
                            Icon(Icons.star, color: yellow, size: 20),
                            Text(
                              (movie.voteAverage ?? 0.0).toStringAsFixed(1),
                              style: textTheme.bodyMedium?.copyWith(
                                color: lightGray,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          '${movie.voteCount ?? 0} ${'votes'.tr()}',
                          style: textTheme.bodySmall?.copyWith(
                            color: lightGray,
                          ),
                        ),

                        SizedBox(height: 20),
                        SlideTransition(
                          position: _overviewSlideAnimation!,
                          child: Text(
                            movie.overview ?? 'No Overview',
                            style: textTheme.bodyMedium?.copyWith(
                              color: lightGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircleButton({
    VoidCallback? onPressed,
    required Widget child,
    double radius = 50,
    Color backgroundColor = white,
    required String tooltipMessage,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Tooltip(
        message: tooltipMessage,
        child: Container(
          width: radius,
          height: radius,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: child,
        ),
      ),
    );
  }
}

class AnimatedSaveMovieButton extends StatefulWidget {
  final bool isSaved;

  const AnimatedSaveMovieButton({super.key, required this.isSaved});

  @override
  State<AnimatedSaveMovieButton> createState() =>
      _AnimatedSaveMovieButtonState();
}

class _AnimatedSaveMovieButtonState extends State<AnimatedSaveMovieButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(AnimatedSaveMovieButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSaved && !oldWidget.isSaved) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(
        widget.isSaved ? Icons.favorite : Icons.favorite_border,
        color: primaryColor,
      ),
    );
  }
}
