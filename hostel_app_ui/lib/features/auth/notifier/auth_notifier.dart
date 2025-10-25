import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/core/storage/secure_storage.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/dio_provider.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/features/auth/repository/auth_repository.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  loading,
  userNotExist,
  userExist,
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final BackendError? error;

  const AuthState({required this.status, this.error, this.user});

  AuthState copyWith({
    AuthStatus? status,
    BackendError? error,
    UserModel? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: this.user ?? user,
    );
  }

  factory AuthState.initial() =>
      const AuthState(status: AuthStatus.unauthenticated);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorage secureStorage = SecureStorage();

  AuthNotifier(this._repository) : super(AuthState.initial());

  Future<void> login(String username, String password) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      final response = await _repository.login(username, password);
      response.fold(
        onSuccess: (user) {
          final (userModel, token) = user;
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: userModel,
          );
          print(userModel.email);
          secureStorage.saveToken(token);
          ToastHelper.showSuccess('Login Successfull');
          router.goNamed(RouteConstantsNames.home);
        },
        onFailure: (error) {
          if (error.detail != null) {
            ToastHelper.showError(error.detail ?? 'Something went wrong');
          } else if (error.nonFieldErrors != null) {
            ToastHelper.showError(error.nonFieldErrors ?? 'Something went wrong');
          }
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            error: error,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }

  Future<void> isUserExist(String username) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      final response = await _repository.isUserExistRepo(username);
      response.fold(
        onSuccess: (_) {
          state = state.copyWith(status: AuthStatus.userExist);
        },
        onFailure: (error) {
          state = state.copyWith(status: AuthStatus.userNotExist, error: error);
        },
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }
}

final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(ref.watch(dioClientProvider)),
);
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
