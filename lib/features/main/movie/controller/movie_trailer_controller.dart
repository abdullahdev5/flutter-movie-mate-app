import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/features/main/movie/repository/movie_repository.dart';

class MovieTrailerController extends FamilyAsyncNotifier<String?, int> {

  MovieTrailerController();

  MovieRepository? _movieRepository;

  @override
  String? build(int _) {
    _movieRepository = ref.read(movieRepositoryProvider);
    return null;
  }


  Future<void> fetchMovieTrailerYoutubeKey(int movieId) async {
    try {
      state = AsyncValue.loading();
      final trailerKey = await _movieRepository?.fetchMovieTrailerYoutubeKey(
          movieId);
      state = AsyncValue.data(trailerKey);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  void resetMovieTrailer() {
    state = const AsyncData(null);
  }


}

final movieTrailerControllerProvider = AsyncNotifierProvider.family<MovieTrailerController, String? , int>(
    () => MovieTrailerController()
);