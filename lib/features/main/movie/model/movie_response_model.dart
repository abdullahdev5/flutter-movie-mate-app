import 'package:movie_mate_app/features/main/movie/model/movie_model.dart';

class MovieResponseModel {

  MovieResponseModel({
    required this.page,
    required this.moviesList,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<MovieModel> moviesList;
  final int totalPages;
  final int totalResults;


  factory MovieResponseModel.fromJson(Map<String, dynamic> json) {
    return MovieResponseModel(
      page: json['page'] as int,
      moviesList: (json['results'] as List).map(
              (movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>)
      ).toList(),
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'results': moviesList.map((movieJson) => movieJson.toJson()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults
    };
  }

}