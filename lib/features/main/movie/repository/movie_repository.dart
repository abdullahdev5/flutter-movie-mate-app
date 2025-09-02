import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_mate_app/core/constants/api_constants.dart';
import 'package:movie_mate_app/core/service/hive_service.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_response_model.dart';
import 'package:movie_mate_app/core/service/api_service.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_model.dart';

class MovieRepository {
  MovieRepository(this._apiService, this._hiveService);

  final ApiService _apiService;
  final HiveService _hiveService;

  CancelToken? _cancelToken;

  Future<MovieResponseModel> getPopularMovies({int page = 1}) async {
    final response = await _apiService.get(
      path: ApiConstants.popularMovies,
      queryParameters: {'page': page},
      cancelToken: _cancelToken,
    );
    final data = response.data as Map<String, dynamic>;
    final responseModel = MovieResponseModel.fromJson(data);
    return responseModel;
  }

  Future<MovieResponseModel> getTopRatedMovies({int page = 1}) async {
    final response = await _apiService.get(
      path: ApiConstants.topRatedMovies,
      queryParameters: {'page': page},
      cancelToken: _cancelToken,
    );
    final data = response.data as Map<String, dynamic>;
    final responseModel = MovieResponseModel.fromJson(data);
    return responseModel;
  }

  Future<MovieResponseModel> getNowPlayingMovies({int page = 1}) async {
    final response = await _apiService.get(
      path: ApiConstants.nowPlayingMovies,
      queryParameters: {'page': page},
      cancelToken: _cancelToken,
    );
    final data = response.data as Map<String, dynamic>;
    final responseModel = MovieResponseModel.fromJson(data);
    return responseModel;
  }

  Future<MovieResponseModel> searchMovies({
    required String query,
    int page = 1
  }) async {
    final response = await _apiService.get(
      path: ApiConstants.searchMovies,
      queryParameters: {
        'query': query,
        'page': page.toString(),
      },
      cancelToken: _cancelToken,
    );
    final data = response.data as Map<String, dynamic>;
    final responseModel = MovieResponseModel.fromJson(data);
    // Saving Now Playing Movies to Cache
    await _saveNowPlayingMoviesToCache(responseModel.moviesList);

    return responseModel;
  }

  // Fetching Youtube Trailer Video Id
  Future<String?> fetchMovieTrailerYoutubeKey(int movieId) async {
    try {
      final response = await _apiService.get(
          path: ApiConstants.videos(movieId));

      final results = response.data['results'] as List<dynamic>;

      final trailer = results.firstWhere(
            (video) => video['site'] == 'Youtube' && video['type'] == 'Trailer',
        orElse: () => results.firstOrNull,
      );
      debugPrint('Trailer Key: ${trailer['key']}');
      return trailer['key'];
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveNowPlayingMoviesToCache(
      List<MovieModel> nowPlayingMoviesList) async {
    final box = _hiveService.nowPlayingMoviesBox;
    await box.clear();
    for (var nowPlayingMovie in nowPlayingMoviesList) {
      box.put(nowPlayingMovie.id, nowPlayingMovie.toJson());
    }
  }

  Future<List<MovieModel>> getCachedNowPlayingMovies() async {
    final box = _hiveService.nowPlayingMoviesBox;
    return box.values
        .map((movieMap) => MovieModel.fromJson(Map<String, dynamic>.from(movieMap)))
        .toList();
  }


  Future<void> saveMovieToSavedList(MovieModel movie) async {
    await _hiveService.savedMoviesBox.put(movie.id, movie.toJson());
  }

  Future<void> removeMovieFromSavedList(int movieId) async {
    await _hiveService.savedMoviesBox.delete(movieId);
  }

  bool getIsMovieSaved(int movieId) {
    return _hiveService.savedMoviesBox.containsKey(movieId);
  }

  Stream<List<MovieModel>> getSavedMovies() {
    final controller = StreamController<List<MovieModel>>();
    final box = _hiveService.savedMoviesBox;

    // 1. Emit initial values
    controller.add(
      box.values
          .map((savedMovieMap) =>
          MovieModel.fromJson(Map<String, dynamic>.from(savedMovieMap)))
          .toList(),
    );

    // 2. Listen for updates from Hive
    final subscription = box.watch().listen((_) {
      controller.add(
        box.values
            .map((savedMovieMap) =>
            MovieModel.fromJson(Map<String, dynamic>.from(savedMovieMap)))
            .toList(),
      );
    });

    // 3. Cancel subscription when stream is closed
    controller.onCancel = () {
      subscription.cancel();
    };

    return controller.stream;
  }

  void cancelRequest() {
    try {
      _cancelToken?.cancel();
    } catch (e) {}
  }
}

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final hiveService = ref.read(hiveServiceProvider);
  return MovieRepository(apiService, hiveService);
});
