import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/core/widget/circular_progress_indicator_adaptive.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_model.dart';

class MovieTile extends StatelessWidget {
  const MovieTile({
    super.key,
    required this.movie,
    this.tileWidth = 150,
    this.onTap,
    required this.imageHeroTag,
  });

  final MovieModel movie;
  final double tileWidth;
  final Function(MovieModel movie, String imageHeroTag)?
  onTap;
  final String imageHeroTag;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: tileWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: InkWell(
          onTap: (() {
            onTap?.call(movie, imageHeroTag);
          }),
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                movie.posterUrl500Size != null
                    ? Hero(
                        tag: imageHeroTag,
                        child: Image.network(
                          movie.posterUrl500Size ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.error, color: red),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicatorAdaptive(
                                  progress:
                                      (loadingProgress.expectedTotalBytes !=
                                          null)
                                      ? (loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!)
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                      )
                    : SizedBox(),
                // Shade
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [black.withOpacity(0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                // Title
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    movie.title ?? '',
                    style: textTheme.bodyMedium?.copyWith(
                      color: white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
