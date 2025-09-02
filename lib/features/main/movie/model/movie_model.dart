class MovieModel {

  MovieModel({
    required this.isAdult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.hasVideo,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool? isAdult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? hasVideo;
  final double? voteAverage;
  final int? voteCount;



  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      isAdult: json['adult'] as bool?,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List?)?.map((item) => item as int).toList(),
      id: json['id'] as int,
      originalLanguage: json['original_language'] as String?,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      popularity: json['popularity'] as double?,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      title: json['title'] as String?,
      hasVideo: json['video'] as bool?,
      voteAverage: json['vote_average'] as double?,
      voteCount: json['vote_count'] as int?
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'adult': isAdult,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds,
      'id': id,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'video': hasVideo,
      'vote_average': voteAverage,
      'vote_count': voteCount
    };
  }


  String? get posterUrl500Size => posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

}