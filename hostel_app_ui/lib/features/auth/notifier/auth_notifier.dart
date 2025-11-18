import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/core/storage/secure_storage.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/features/auth/model/reset_password_model.dart';
import 'package:hostel_app/features/auth/repository/auth_repository.dart';
import 'package:hostel_app/features/shared/models/base_info/base_info_model.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class PasswordResetState {
  final String? email;
  final int? otp;

  const PasswordResetState({
    this.email,
    this.otp,
  });

  PasswordResetState copyWith({
    String? email,
    int? otp,
  }) {
    return PasswordResetState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final BackendError? error;
  final BaseInfoModel? baseInfo;
  final bool isLoading;
  final PasswordResetState? resetState;

  const AuthState({
    required this.status,
    this.user,
    this.baseInfo,
    this.error,
    this.resetState,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    BackendError? error,
    BaseInfoModel? baseInfo,
    UserModel? user,
    bool? isLoading,
    PasswordResetState? resetState,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      baseInfo: baseInfo ?? this.baseInfo,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      resetState: resetState ?? this.resetState,
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
    print(response);
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
          fetchBaseInfo();
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
    } catch (e) {
      ToastHelper.showError('Something went wrong');
      print(e);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  void logout() {
    state = state.copyWith(status: AuthStatus.unauthenticated);
    router.goNamed(RouteConstantsNames.login);
    secureStorage.deleteAll();
  }

  Future<void> requestOTP(String email) async {
    state = state.copyWith(isLoading: true);
    final response = await _repository.requestOTP(email);
    response.fold(
      onSuccess: (_) {
        ToastHelper.showSuccess('OTP sent successfully');
        router.pushNamed(RouteConstantsNames.otpVerification);
        state = state.copyWith(
          isLoading: false,
          resetState: PasswordResetState(email: email),
        );
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
          isLoading: false,
        );
      },
    );
  }

  Future<void> verifyOTP(int OTP) async {
    state = state.copyWith(isLoading: true);
    if (state.resetState?.email == null) {
      ToastHelper.showError('Something went wrong');
      return;
    }
    final response = await _repository.verifyOTP(state.resetState!.email!, OTP);

    response.fold(
      onSuccess: (_) {
        router.goNamed(RouteConstantsNames.resetPassword);
        state = state.copyWith(
          isLoading: false,
          resetState: PasswordResetState(
            email: state.resetState?.email,
            otp: OTP,
          ),
        );
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
          isLoading: false,
        );
      },
    );
  }

  Future<void> changePassword(
    String newPassword,
    String confirmPassword,
  ) async {
    state = state.copyWith(isLoading: true);
    if (state.resetState == null) {
      ToastHelper.showError('Something went wrong');
      return;
    }
    final response = await _repository.changePassword(
      ResetPassswordModel(
        otp: state.resetState!.otp!,
        email: state.resetState!.email!,
        confirmPassword: confirmPassword,
        newPassword: newPassword,
      ),
    );

    response.fold(
      onSuccess: (_) {
        router.goNamed(RouteConstantsNames.login);
        state = state.copyWith(isLoading: false, resetState: null);
        ToastHelper.showSuccess('Password Successfully Reset');
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
          isLoading: false,
        );
      },
    );
  }
}
