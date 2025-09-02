import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticating() = _Authenticating;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.userDataStored() = _UserDataStored;
  const factory AuthState.failed(String errorMessage) = _Failed;
}