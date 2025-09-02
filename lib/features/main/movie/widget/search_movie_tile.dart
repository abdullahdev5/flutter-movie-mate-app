import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/core/widget/circular_progress_indicator_adaptive.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_model.dart';

class SearchMovieTile extends StatelessWidget {
  const SearchMovieTile({
    super.key,
    required this.movie,
    this.onTap,
    required this.imageHeroTag,
  });

  final MovieModel movie;
  final Function(MovieModel movie, String imageHeroTag)? onTap;
  final String imageHeroTag;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: (() {
        onTap?.call(movie, imageHeroTag);
      }),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                // borderRadius: BorderRadius.circular(12),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(12),
                ),
                child: movie.posterUrl500Size != null
                    ? Container(
                        width: 120,
                        height: 150,
                        color: black,
                        child: Hero(
                          tag: imageHeroTag,
                          child: Image.network(
                            movie.posterUrl500Size!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error_outline, color: red);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicatorAdaptive(
                                    progress:
                                        (loadingProgress.expectedTotalBytes !=
                                            null)
                                        ? (loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!)
                                        : null,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      )
                    : SizedBox(width: 120, height: 150),
              ),

              Expanded(
                child: SizedBox(
                  height: 150,
                  child: BlurryContainer(
                    blur: 100,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                      topLeft: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            bottom: 10.0,
                            right: 10.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.originalTitle ?? '',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5.0),
                              Expanded(
                                child: Text(
                                  movie.overview ?? '',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: lightGray,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              movie.releaseDate ?? '',
                              style: textTheme.labelMedium?.copyWith(
                                color: white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
