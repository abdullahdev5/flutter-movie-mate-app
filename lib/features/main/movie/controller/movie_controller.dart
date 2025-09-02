import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_model.dart';
import 'package:movie_mate_app/features/main/movie/model/movies_type.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_response_model.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_state.dart';
import 'package:movie_mate_app/features/main/movie/repository/movie_repository.dart';

class MovieController extends StateNotifier<MovieState> {
  MovieController(this._movieRepository, this._type) : super(MovieState.initial());

  final MovieRepository _movieRepository;
  final MoviesType _type;


  Future<void> fetchMovies({String? query, wantToPaginate = true}) async {
    try {
      if (state is Success && wantToPaginate == true) {
        final currentState = state as Success;
        debugPrint('Movies List Length after Success: ${currentState.moviesList.length}');
        debugPrint('Current Page: ${currentState.page}');
        debugPrint('Total Pages: ${currentState.totalPages}');
        debugPrint('hasReachedEnd: ${currentState.hasReachedEnd}');
        if (currentState.hasReachedEnd || currentState.isLoadingMore) {
          debugPrint('Reached End and isLoadingMore is true');
          return;
        }

        state = currentState.copyWith(isLoadingMore: true);
        if (currentState.page >= currentState.totalPages) {
          state = currentState.copyWith(
            isLoadingMore: false,
            hasReachedEnd: true,
          );
          return;
        }

        MovieResponseModel movieResponse;

        switch (_type) {
          case MoviesType.Popular:
            movieResponse = await _movieRepository.getPopularMovies(
              page: currentState.page + 1,
            );
            break;
          case MoviesType.TopRated:
            movieResponse = await _movieRepository.getTopRatedMovies(
              page: currentState.page + 1,
            );
            break;
          case MoviesType.NowPlaying:
            movieResponse = await _movieRepository.getNowPlayingMovies(
              page: currentState.page + 1,
            );
            break;
          case MoviesType.ExpandedSearch:
            if (query == null || query.trim().isEmpty) {
              state = currentState.copyWith(isLoadingMore: false, moviesList: []);
              return;
            }
            final encodedQuery = Uri.encodeQueryComponent(query);
            movieResponse = await _movieRepository.searchMovies(
              query: encodedQuery,
              page: currentState.page + 1
            );
            break;
          case MoviesType.FullScreenSearch:
            if (query == null || query.trim().isEmpty) {
              state = currentState.copyWith(isLoadingMore: false, moviesList: []);
              return;
            }
            final encodedQuery = Uri.encodeQueryComponent(query);
            movieResponse = await _movieRepository.searchMovies(
                query: encodedQuery,
                page: currentState.page + 1
            );
            break;
          default:
            // TODO: Handle this case.
            throw UnimplementedError();
        }

        final updatedMovies = [...currentState.moviesList, ...movieResponse.moviesList];
        debugPrint('About to update state with ${updatedMovies.length} movies');

        state = currentState.copyWith(
          moviesList: updatedMovies,
          page: movieResponse.page,
          totalPages: movieResponse.totalPages,
          isLoadingMore: false,
          hasReachedEnd: currentState.page >= currentState.totalPages,
        );
        debugPrint('Movies List Length after Success: ${(state as Success).moviesList.length}');
      } else {
        state = MovieState.loading();

        MovieResponseModel movieResponse;

        switch (_type) {
          case MoviesType.Popular:
            movieResponse = await _movieRepository.getPopularMovies();
            break;
          case MoviesType.TopRated:
            movieResponse = await _movieRepository.getTopRatedMovies();
            break;
          case MoviesType.NowPlaying:
            movieResponse = await _movieRepository.getNowPlayingMovies();
            break;
          case MoviesType.ExpandedSearch:
            if (query == null) {
              return;
            }
            if (query.trim().isEmpty) {
              state = MovieState.success(
                moviesList: [],
                page: 1,
                totalPages: 2
              );
              return;
            }
            final encodedQuery = Uri.encodeQueryComponent(query);
            movieResponse = await _movieRepository.searchMovies(query: encodedQuery);
            break;
          case MoviesType.FullScreenSearch:
            if (query == null) {
              return;
            }
            if (query.trim().isEmpty) {
              state = MovieState.success(
                  moviesList: [],
                  page: 1,
                  totalPages: 2
              );
              return;
            }
            final encodedQuery = Uri.encodeQueryComponent(query);
            movieResponse = await _movieRepository.searchMovies(query: encodedQuery);
            break;
          default:
            // TODO: Handle this case.
            throw UnimplementedError();
        }

        debugPrint('Movies List Length Initial: ${movieResponse.moviesList.length}');

        state = MovieState.success(
          moviesList: movieResponse.moviesList,
          hasReachedEnd: movieResponse.page >= movieResponse.totalPages,
          page: movieResponse.page,
          totalPages: movieResponse.totalPages,
        );
      }
    } catch (e) {
      // When Response Didn't Gave the Map of ResponseModel so Dart will give TypeError
      // and I am Expecting that When I get Type Error and The Current State is Success
      // so We Reach the End of Movies
      if (e is TypeError) {
        debugPrint('Type Error: ${e.toString()}');
        if (state is Success) {
          final currentState = state as Success;
          state = MovieState.success(
            moviesList: currentState.moviesList,
            isLoadingMore: false,
            page: currentState.page,
            totalPages: currentState.totalPages,
          );
        } else {
          state = MovieState.error(e.toString());
        }
      } else if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          if (_type == MoviesType.NowPlaying) {
            final nowPlayingCachedMoviesList = await _movieRepository
                .getCachedNowPlayingMovies();
            if (nowPlayingCachedMoviesList.isNotEmpty) {
              state = MovieState.success(
                moviesList: nowPlayingCachedMoviesList,
                page: 1,
                totalPages: 1,
                hasReachedEnd: true,
              );
            } else {
              state = MovieState.error(e.message ?? 'No Internet Connection!', isNetworkError: true);
            }
          } else {
            state = MovieState.error(e.message ?? 'No Internet Connection!', isNetworkError: true);
          }
        }
      } else {
        debugPrint('Exception: ${e.toString()}');
        state = MovieState.error(e.toString());
      }
    }
  }


  // Saved Movies Related
  Future<void> saveMovieToSavedList(MovieModel movie) async {
    _movieRepository.saveMovieToSavedList(movie);
  }
  Future<void> removeMovieFromSavedList(int movieId) async {
    _movieRepository.removeMovieFromSavedList(movieId);
  }
  bool getIsMovieSaved(int movieId) {
    return _movieRepository.getIsMovieSaved(movieId);
  }
  Stream<List<MovieModel>> getSavedMovies() {
    return _movieRepository.getSavedMovies();
  }


  @override
  void dispose() {
    _movieRepository.cancelRequest();
    super.dispose();
  }
}

final movieControllerProvider = StateNotifierProvider.family<MovieController, MovieState, MoviesType>(
    (ref, type) {
      final movieRepository = ref.read(movieRepositoryProvider);
      return MovieController(movieRepository, type);
    }
);

final popularMoviesProvider = movieControllerProvider(MoviesType.Popular);
final topRatedMoviesProvider = movieControllerProvider(MoviesType.TopRated);
final nowPlayingMoviesProvider = movieControllerProvider(MoviesType.NowPlaying);
final searchMoviesExpandedProvider = movieControllerProvider(MoviesType.ExpandedSearch);
final searchMoviesFullScreenProvider = movieControllerProvider(MoviesType.FullScreenSearch);
final savedMoviesProvider = movieControllerProvider(MoviesType.Saved);