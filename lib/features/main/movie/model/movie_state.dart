import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_mate_app/features/main/movie/model/movie_model.dart';

part 'movie_state.freezed.dart';

@freezed
sealed class MovieState with _$MovieState {
  const factory MovieState.initial() = Initial;
  const factory MovieState.loading() = Loading;
  const factory MovieState.error(
    String errorMessage,
    {@Default(false) bool isNetworkError}
  ) = Error;
  const factory MovieState.success({
    required List<MovieModel> moviesList,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedEnd,
    required int page,
    required int totalPages,
  }) = Success;
}