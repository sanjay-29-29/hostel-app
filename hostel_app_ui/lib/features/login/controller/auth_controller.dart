import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hostel_app/app/core/storage/secure_storage.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/dio_provider.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/features/login/repository/auth_repository.dart';
import 'package:toastification/toastification.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final String? error;

  const AuthState({required this.status, this.error});

  AuthState copyWith({AuthStatus? status, String? token, String? error}) {
    return AuthState(status: status ?? this.status, error: error);
  }

  factory AuthState.initial() =>
      const AuthState(status: AuthStatus.unauthenticated);
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorage secureStorage = SecureStorage();

  AuthController(this._repository) : super(AuthState.initial());

  Future<void> login(String username, String password) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      final response = await _repository.login(username, password);
      response.fold(
        (token) {
          state = state.copyWith(status: AuthStatus.authenticated);
          secureStorage.saveToken(token.token);
          ToastUtil.success('Login Successfull');
          router.pushNamed('home');
        },
        (error) {
          state = state.copyWith(status: AuthStatus.unauthenticated);
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.unauthenticated, token: null);
  }
}

final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(ref.watch(dioClientProvider)),
);
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(ref.watch(authRepositoryProvider));
  },
);
