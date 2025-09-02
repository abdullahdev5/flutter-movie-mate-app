// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MovieState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MovieState()';
}


}

/// @nodoc
class $MovieStateCopyWith<$Res>  {
$MovieStateCopyWith(MovieState _, $Res Function(MovieState) __);
}


/// Adds pattern-matching-related methods to [MovieState].
extension MovieStatePatterns on MovieState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( Error value)?  error,TResult Function( Success value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Error() when error != null:
return error(_that);case Success() when success != null:
return success(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( Error value)  error,required TResult Function( Success value)  success,}){
final _that = this;
switch (_that) {
case Initial():
return initial(_that);case Loading():
return loading(_that);case Error():
return error(_that);case Success():
return success(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( Error value)?  error,TResult? Function( Success value)?  success,}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Error() when error != null:
return error(_that);case Success() when success != null:
return success(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String errorMessage,  bool isNetworkError)?  error,TResult Function( List<MovieModel> moviesList,  bool isLoadingMore,  bool hasReachedEnd,  int page,  int totalPages)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Error() when error != null:
return error(_that.errorMessage,_that.isNetworkError);case Success() when success != null:
return success(_that.moviesList,_that.isLoadingMore,_that.hasReachedEnd,_that.page,_that.totalPages);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String errorMessage,  bool isNetworkError)  error,required TResult Function( List<MovieModel> moviesList,  bool isLoadingMore,  bool hasReachedEnd,  int page,  int totalPages)  success,}) {final _that = this;
switch (_that) {
case Initial():
return initial();case Loading():
return loading();case Error():
return error(_that.errorMessage,_that.isNetworkError);case Success():
return success(_that.moviesList,_that.isLoadingMore,_that.hasReachedEnd,_that.page,_that.totalPages);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String errorMessage,  bool isNetworkError)?  error,TResult? Function( List<MovieModel> moviesList,  bool isLoadingMore,  bool hasReachedEnd,  int page,  int totalPages)?  success,}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Error() when error != null:
return error(_that.errorMessage,_that.isNetworkError);case Success() when success != null:
return success(_that.moviesList,_that.isLoadingMore,_that.hasReachedEnd,_that.page,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc


class Initial implements MovieState {
  const Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MovieState.initial()';
}


}




/// @nodoc


class Loading implements MovieState {
  const Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MovieState.loading()';
}


}




/// @nodoc


class Error implements MovieState {
  const Error(this.errorMessage, {this.isNetworkError = false});
  

 final  String errorMessage;
@JsonKey() final  bool isNetworkError;

/// Create a copy of MovieState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorCopyWith<Error> get copyWith => _$ErrorCopyWithImpl<Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Error&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isNetworkError, isNetworkError) || other.isNetworkError == isNetworkError));
}


@override
int get hashCode => Object.hash(runtimeType,errorMessage,isNetworkError);

@override
String toString() {
  return 'MovieState.error(errorMessage: $errorMessage, isNetworkError: $isNetworkError)';
}


}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res> implements $MovieStateCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) _then) = _$ErrorCopyWithImpl;
@useResult
$Res call({
 String errorMessage, bool isNetworkError
});




}
/// @nodoc
class _$ErrorCopyWithImpl<$Res>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error _self;
  final $Res Function(Error) _then;

/// Create a copy of MovieState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMessage = null,Object? isNetworkError = null,}) {
  return _then(Error(
null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,isNetworkError: null == isNetworkError ? _self.isNetworkError : isNetworkError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class Success implements MovieState {
  const Success({required final  List<MovieModel> moviesList, this.isLoadingMore = false, this.hasReachedEnd = false, required this.page, required this.totalPages}): _moviesList = moviesList;
  

 final  List<MovieModel> _moviesList;
 List<MovieModel> get moviesList {
  if (_moviesList is EqualUnmodifiableListView) return _moviesList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_moviesList);
}

@JsonKey() final  bool isLoadingMore;
@JsonKey() final  bool hasReachedEnd;
 final  int page;
 final  int totalPages;

/// Create a copy of MovieState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessCopyWith<Success> get copyWith => _$SuccessCopyWithImpl<Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Success&&const DeepCollectionEquality().equals(other._moviesList, _moviesList)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasReachedEnd, hasReachedEnd) || other.hasReachedEnd == hasReachedEnd)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_moviesList),isLoadingMore,hasReachedEnd,page,totalPages);

@override
String toString() {
  return 'MovieState.success(moviesList: $moviesList, isLoadingMore: $isLoadingMore, hasReachedEnd: $hasReachedEnd, page: $page, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $SuccessCopyWith<$Res> implements $MovieStateCopyWith<$Res> {
  factory $SuccessCopyWith(Success value, $Res Function(Success) _then) = _$SuccessCopyWithImpl;
@useResult
$Res call({
 List<MovieModel> moviesList, bool isLoadingMore, bool hasReachedEnd, int page, int totalPages
});




}
/// @nodoc
class _$SuccessCopyWithImpl<$Res>
    implements $SuccessCopyWith<$Res> {
  _$SuccessCopyWithImpl(this._self, this._then);

  final Success _self;
  final $Res Function(Success) _then;

/// Create a copy of MovieState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? moviesList = null,Object? isLoadingMore = null,Object? hasReachedEnd = null,Object? page = null,Object? totalPages = null,}) {
  return _then(Success(
moviesList: null == moviesList ? _self._moviesList : moviesList // ignore: cast_nullable_to_non_nullable
as List<MovieModel>,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasReachedEnd: null == hasReachedEnd ? _self.hasReachedEnd : hasReachedEnd // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
