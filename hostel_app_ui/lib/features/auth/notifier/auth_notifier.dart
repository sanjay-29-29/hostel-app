import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/core/storage/secure_storage.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/features/auth/repository/auth_repository.dart';
import 'package:hostel_app/features/shared/models/base_info/base_info_model.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  loading,
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final BackendError? error;
  final BaseInfoModel? baseInfo;

  const AuthState({required this.status, this.user, this.baseInfo, this.error});

  AuthState copyWith({
    AuthStatus? status,
    BackendError? error,
    BaseInfoModel? baseInfo,
    UserModel? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      baseInfo: baseInfo ?? this.baseInfo,
      error: error ?? this.error,
    );
  }

  factory AuthState.initial() =>
      const AuthState(status: AuthStatus.unauthenticated);
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repository;
  final SecureStorage secureStorage = SecureStorage();

  AuthState build() {
    _repository = ref.read(authRepositoryProvider);
    return AuthState.initial();
  }

  Future<void> restoreSession() async {
    try {
      String? user = await secureStorage.getKey('user');
      if (user == null) {
        router.goNamed(RouteConstantsNames.login);
        return;
      }
      final userModel = UserModel.fromJson(jsonDecode(user));
      state = state.copyWith(user: userModel, status: AuthStatus.authenticated);
      await fetchBaseInfo();
      router.goNamed(RouteConstantsNames.home);
    } catch (e) {
      router.goNamed(RouteConstantsNames.login);
    }
  }

  Future<void> fetchBaseInfo() async {
    final response = await _repository.fetchBaseInfo();
    response.fold(
      onSuccess: (model) {
        state = state.copyWith(baseInfo: model);
      },
      onFailure: (error) {},
    );
    print(response.isSuccess);
  }

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
          secureStorage.saveKey('user', jsonEncode(userModel.toJson()));
          secureStorage.saveKey('token', token);
          ToastHelper.showSuccess('Login Successfull');

          router.goNamed(RouteConstantsNames.home);
        },
        onFailure: (error) {
          if (error.detail != null) {
            ToastHelper.showError(error.detail ?? 'Something went wrong');
          } else if (error.nonFieldErrors != null) {
            ToastHelper.showError(
              error.nonFieldErrors ?? 'Something went wrong',
            );
          }
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            error: error,
          );
        },
      );
      await fetchBaseInfo();
    } catch (e) {
      ToastHelper.showError(
        'Something went wrong',
      );
      print(e);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.unauthenticated);
    secureStorage.deleteAll();
  }
}
